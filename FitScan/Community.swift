import Combine
import SwiftUI

// Community-Rezepte über Firebase (Firestore und anonyme Anmeldung per REST, ohne zusätzliches SDK).
// Die Verbindung (Projekt-ID und Web-API-Key) trägst du in der App unter „Community einrichten“ ein.

enum CommunityConfig {
    static var projectID: String { UserDefaults.standard.string(forKey: "community.projectID") ?? "" }
    static var apiKey: String { UserDefaults.standard.string(forKey: "community.apiKey") ?? "" }
    static var isConfigured: Bool { !projectID.isEmpty && !apiKey.isEmpty }

    static let rules = """
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        match /sharedRecipes/{id} {
          allow read: if request.auth != null;
          allow create: if request.auth != null
            && request.resource.data.uid == request.auth.uid
            && request.resource.data.reports == 0
            && request.resource.data.name is string
            && request.resource.data.name.size() <= 80
            && request.resource.data.payload is string
            && request.resource.data.payload.size() < 40000;
          // Melden: nur der Zähler „reports“ darf um 1 steigen
          allow update: if request.auth != null
            && request.resource.data.diff(resource.data).affectedKeys().hasOnly(['reports'])
            && request.resource.data.reports == resource.data.reports + 1;
          allow delete: if request.auth != null && resource.data.uid == request.auth.uid;
        }
      }
    }
    """
}

struct SharedRecipe: Identifiable {
    let id: String
    let name: String
    let author: String
    let created: Date
    let reports: Int
    let uid: String
    let recipe: CustomRecipe
}

enum CommunityError: LocalizedError {
    case notConfigured
    case message(String)
    var errorDescription: String? {
        switch self {
        case .notConfigured: return "Die Community ist noch nicht eingerichtet."
        case .message(let m): return m
        }
    }
}

@MainActor
final class CommunityService: ObservableObject {
    @Published var recipes: [SharedRecipe] = []
    @Published var busy = false
    @Published var error: String?
    @Published var configured = CommunityConfig.isConfigured
    /// lokale Rezept-ID -> Dokument-ID der eigenen veröffentlichten Rezepte
    @Published private(set) var mine: [String: String] = [:]
    @Published private(set) var hidden: Set<String> = []

    private var idToken = ""
    private var refreshToken = ""
    private var uid = ""
    private var expiry = Date.distantPast
    private let d = UserDefaults.standard

    init() {
        idToken = d.string(forKey: "community.idToken") ?? ""
        refreshToken = d.string(forKey: "community.refreshToken") ?? ""
        uid = d.string(forKey: "community.uid") ?? ""
        expiry = Date(timeIntervalSince1970: d.double(forKey: "community.expiry"))
        mine = (d.dictionary(forKey: "community.mine") as? [String: String]) ?? [:]
        hidden = Set(d.stringArray(forKey: "community.hidden") ?? [])
    }

    func saveConfig(projectID: String, apiKey: String) {
        d.set(projectID.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "community.projectID")
        d.set(apiKey.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "community.apiKey")
        // neue Verbindung -> neue Anmeldung
        idToken = ""; refreshToken = ""; uid = ""; expiry = .distantPast
        persistAuth()
        configured = CommunityConfig.isConfigured
    }

    private func persistAuth() {
        d.set(idToken, forKey: "community.idToken")
        d.set(refreshToken, forKey: "community.refreshToken")
        d.set(uid, forKey: "community.uid")
        d.set(expiry.timeIntervalSince1970, forKey: "community.expiry")
    }

    private func persistLists() {
        d.set(mine, forKey: "community.mine")
        d.set(Array(hidden), forKey: "community.hidden")
    }

    // MARK: Netzwerk

    private var base: String {
        "https://firestore.googleapis.com/v1/projects/\(CommunityConfig.projectID)/databases/(default)/documents"
    }

    private func request(_ method: String, _ urlString: String, json: Any? = nil, form: String? = nil, auth: Bool = true) async throws -> Data {
        guard let url = URL(string: urlString) else { throw CommunityError.message("Ungültige Adresse. Prüfe die Projekt-ID.") }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.timeoutInterval = 20
        if let json {
            req.httpBody = try JSONSerialization.data(withJSONObject: json)
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if let form {
            req.httpBody = form.data(using: .utf8)
            req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        if auth { req.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization") }
        let (data, resp) = try await URLSession.shared.data(for: req)
        if let http = resp as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            var text = "Fehler \(http.statusCode)"
            if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let e = obj["error"] as? [String: Any], let m = e["message"] as? String { text = m }
            throw CommunityError.message(text)
        }
        return data
    }

    private func ensureAuth() async throws {
        guard CommunityConfig.isConfigured else { throw CommunityError.notConfigured }
        if !idToken.isEmpty && expiry > Date().addingTimeInterval(60) { return }
        if !refreshToken.isEmpty, (try? await refreshAuth()) == true { return }
        try await signUp()
    }

    private var keyQuery: String {
        CommunityConfig.apiKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? CommunityConfig.apiKey
    }

    private func signUp() async throws {
        let data = try await request("POST", "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=\(keyQuery)",
                                     json: ["returnSecureToken": true], auth: false)
        guard let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let t = obj["idToken"] as? String, let r = obj["refreshToken"] as? String, let u = obj["localId"] as? String else {
            throw CommunityError.message("Anmeldung fehlgeschlagen. Ist die anonyme Anmeldung in Firebase aktiviert?")
        }
        idToken = t; refreshToken = r; uid = u
        expiry = Date().addingTimeInterval(Double(obj["expiresIn"] as? String ?? "3600") ?? 3600)
        persistAuth()
    }

    private func refreshAuth() async throws -> Bool {
        let rt = refreshToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? refreshToken
        let data = try await request("POST", "https://securetoken.googleapis.com/v1/token?key=\(keyQuery)",
                                     form: "grant_type=refresh_token&refresh_token=\(rt)", auth: false)
        guard let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let t = obj["id_token"] as? String else { return false }
        idToken = t
        refreshToken = obj["refresh_token"] as? String ?? refreshToken
        uid = obj["user_id"] as? String ?? uid
        expiry = Date().addingTimeInterval(Double(obj["expires_in"] as? String ?? "3600") ?? 3600)
        persistAuth()
        return true
    }

    // MARK: Aktionen

    func reload() async {
        guard CommunityConfig.isConfigured else { configured = false; return }
        busy = true; error = nil
        defer { busy = false }
        do {
            try await ensureAuth()
            let body: [String: Any] = ["structuredQuery": [
                "from": [["collectionId": "sharedRecipes"]],
                "orderBy": [["field": ["fieldPath": "createdAt"], "direction": "DESCENDING"]],
                "limit": 80
            ]]
            let data = try await request("POST", base + ":runQuery", json: body)
            guard let arr = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { recipes = []; return }
            recipes = arr.compactMap { parse($0["document"] as? [String: Any]) }
                .filter { $0.reports < 3 && !hidden.contains($0.id) }
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func parse(_ doc: [String: Any]?) -> SharedRecipe? {
        guard let doc, let name = doc["name"] as? String, let f = doc["fields"] as? [String: Any] else { return nil }
        func str(_ k: String) -> String? { (f[k] as? [String: Any])?["stringValue"] as? String }
        guard let payload = str("payload"), let pd = payload.data(using: .utf8),
              let recipe = try? JSONDecoder().decode(CustomRecipe.self, from: pd) else { return nil }
        let reports = Int(((f["reports"] as? [String: Any])?["integerValue"] as? String) ?? "0") ?? 0
        var created = Date()
        if let ts = (f["createdAt"] as? [String: Any])?["timestampValue"] as? String {
            let a = ISO8601DateFormatter(); a.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let b = ISO8601DateFormatter()
            created = a.date(from: ts) ?? b.date(from: ts) ?? Date()
        }
        return SharedRecipe(id: name.components(separatedBy: "/").last ?? name, name: str("name") ?? recipe.name,
                            author: str("author") ?? "Anonym", created: created, reports: reports, uid: str("uid") ?? "", recipe: recipe)
    }

    @discardableResult
    func publish(_ r: CustomRecipe, author: String) async -> Bool {
        busy = true; error = nil
        defer { busy = false }
        do {
            try await ensureAuth()
            let payload = String(data: try JSONEncoder().encode(r), encoding: .utf8) ?? ""
            let rec = r.asRecipe
            let name = String(r.name.prefix(80))
            let fields: [String: Any] = [
                "name": ["stringValue": name],
                "author": ["stringValue": String(author.prefix(30))],
                "uid": ["stringValue": uid],
                "payload": ["stringValue": payload],
                "createdAt": ["timestampValue": ISO8601DateFormatter().string(from: Date())],
                "reports": ["integerValue": "0"],
                "kcal": ["doubleValue": rec.kcal],
                "protein": ["doubleValue": rec.protein]
            ]
            let data = try await request("POST", base + "/sharedRecipes", json: ["fields": fields])
            if let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any], let n = obj["name"] as? String {
                mine[r.id.uuidString] = n.components(separatedBy: "/").last ?? n
                persistLists()
            }
            return true
        } catch {
            self.error = error.localizedDescription
            return false
        }
    }

    func unpublish(_ localID: UUID) async {
        guard let docID = mine[localID.uuidString] else { return }
        busy = true; error = nil
        defer { busy = false }
        do {
            try await ensureAuth()
            _ = try await request("DELETE", base + "/sharedRecipes/\(docID)")
            mine[localID.uuidString] = nil
            persistLists()
        } catch {
            self.error = error.localizedDescription
        }
    }

    func report(_ s: SharedRecipe) async {
        busy = true; error = nil
        defer { busy = false }
        do {
            try await ensureAuth()
            let docName = "projects/\(CommunityConfig.projectID)/databases/(default)/documents/sharedRecipes/\(s.id)"
            let body: [String: Any] = ["writes": [["transform": [
                "document": docName,
                "fieldTransforms": [["fieldPath": "reports", "increment": ["integerValue": "1"]]]
            ]]]]
            _ = try await request("POST", base + ":commit", json: body)
        } catch {
            self.error = error.localizedDescription
        }
        hidden.insert(s.id)
        persistLists()
        recipes.removeAll { $0.id == s.id }
    }

    func isMine(_ s: SharedRecipe) -> Bool { !uid.isEmpty && s.uid == uid }

    /// Kopiert ein Community-Rezept in die eigenen Rezepte
    func adopt(_ s: SharedRecipe, into store: RecipeStore) {
        var r = s.recipe
        r.id = UUID()
        r.note = (r.note.isEmpty ? "" : r.note + "\n") + "Community-Rezept von \(s.author)"
        store.customs.append(r)
    }
}

// MARK: Oberfläche

struct CommunityView: View {
    @EnvironmentObject var service: CommunityService
    @State private var search = ""

    private var items: [SharedRecipe] {
        service.recipes.filter {
            search.isEmpty || $0.name.localizedCaseInsensitiveContains(search)
                || $0.recipe.items.contains { $0.name.localizedCaseInsensitiveContains(search) }
        }
    }

    var body: some View {
        List {
            if !service.configured {
                Section {
                    Text("Die Community-Bibliothek ist noch nicht verbunden. Dafür braucht die App ein kostenloses Firebase-Projekt. Die Einrichtung dauert etwa 10 Minuten.")
                    NavigationLink { CommunitySetupView() } label: { Label("Community einrichten", systemImage: "gearshape") }
                }
            } else {
                if let e = service.error {
                    Section { Text(e).font(.footnote).foregroundStyle(.red) }
                }
                Section {
                    if service.busy && service.recipes.isEmpty { HStack { ProgressView(); Text("Lade …").foregroundStyle(.secondary) } }
                    if !service.busy && items.isEmpty { Text("Noch keine Rezepte. Teile dein eigenes Rezept als Erster.").foregroundStyle(.secondary) }
                    ForEach(items) { s in
                        NavigationLink { SharedRecipeDetail(shared: s) } label: {
                            HStack(spacing: 12) {
                                RecipeCover(recipe: s.recipe.asRecipe, height: 56)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(s.name)
                                    let r = s.recipe.asRecipe
                                    Text("\(Int(r.kcal.rounded())) kcal · \(Int(r.protein.rounded())) g Eiweiß · \(s.recipe.minutes) Min.")
                                        .font(.footnote).foregroundStyle(.secondary)
                                    Text("von \(s.author)").font(.caption).foregroundStyle(.secondary)
                                    if !r.tags.isEmpty {
                                        Text(r.tags.map(\.rawValue).joined(separator: " · ")).font(.caption2).foregroundStyle(Color.accentColor)
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text("Community-Rezepte")
                } footer: {
                    Text("Rezepte stammen von anderen Nutzern. Nährwerte sind ungeprüft. Unpassende Rezepte kannst du melden.")
                }
                Section {
                    NavigationLink { CommunitySetupView() } label: { Label("Verbindung", systemImage: "gearshape") }
                }
            }
        }
        .searchable(text: $search, prompt: "Rezept oder Zutat suchen")
        .navigationTitle("Community")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { Task { await service.reload() } } label: { Image(systemName: "arrow.clockwise") }
                    .disabled(!service.configured || service.busy)
            }
        }
        .task { if service.configured { await service.reload() } }
        .refreshable { await service.reload() }
    }
}

struct SharedRecipeDetail: View {
    let shared: SharedRecipe
    @EnvironmentObject var service: CommunityService
    @EnvironmentObject var store: RecipeStore
    @Environment(\.dismiss) private var dismiss
    @State private var adopted = false
    @State private var confirmReport = false

    private var recipe: Recipe { shared.recipe.asRecipe }

    var body: some View {
        List {
            Section {
                RecipeCover(recipe: recipe, height: 190, wide: true).listRowInsets(EdgeInsets())
                Text("von \(shared.author) · \(shared.created.formatted(date: .abbreviated, time: .omitted))")
                    .font(.footnote).foregroundStyle(.secondary)
                if !recipe.tags.isEmpty {
                    Text(recipe.tags.map(\.rawValue).joined(separator: " · ")).font(.footnote).foregroundStyle(Color.accentColor)
                }
            }
            Section("Nährwerte pro Portion (aus den Zutaten berechnet)") {
                LabeledContent("Kalorien", value: "\(Int(recipe.kcal.rounded())) kcal")
                LabeledContent("Eiweiß", value: "\(Int(recipe.protein.rounded())) g")
                LabeledContent("Kohlenhydrate", value: "\(Int(recipe.carbs.rounded())) g")
                LabeledContent("Fett", value: "\(Int(recipe.fat.rounded())) g")
                LabeledContent("Zubereitung", value: "\(recipe.minutes) Min.")
            }
            Section("Zutaten") {
                ForEach(recipe.items.indices, id: \.self) { i in
                    LabeledContent(recipe.items[i].ing.name, value: "\(Int(recipe.items[i].grams.rounded())) g")
                }
            }
            Section("Zubereitung") {
                if recipe.steps.isEmpty { Text("Keine Schritte angegeben.").foregroundStyle(.secondary) }
                ForEach(Array(recipe.steps.enumerated()), id: \.offset) { i, s in Text("\(i + 1). \(s)") }
                if !recipe.note.isEmpty { Text(recipe.note).font(.footnote).foregroundStyle(.secondary) }
            }
            Section {
                Button {
                    service.adopt(shared, into: store)
                    adopted = true
                } label: {
                    Label(adopted ? "In deinen Rezepten" : "In meine Rezepte übernehmen", systemImage: adopted ? "checkmark.circle.fill" : "square.and.arrow.down")
                }
                .disabled(adopted)
                if service.isMine(shared) {
                    Text("Das ist dein eigenes Rezept. Zurückziehen kannst du es im Rezept über „Mit Community teilen“.")
                        .font(.footnote).foregroundStyle(.secondary)
                } else {
                    Button(role: .destructive) { confirmReport = true } label: { Label("Rezept melden", systemImage: "flag") }
                }
            }
        }
        .navigationTitle(shared.name)
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Dieses Rezept melden?", isPresented: $confirmReport, titleVisibility: .visible) {
            Button("Melden und ausblenden", role: .destructive) {
                Task { await service.report(shared); dismiss() }
            }
            Button("Abbrechen", role: .cancel) {}
        } message: {
            Text("Gemeldete Rezepte werden bei dir sofort ausgeblendet und ab mehreren Meldungen für alle.")
        }
    }
}

/// Eigenes Rezept veröffentlichen oder zurückziehen
struct ShareToCommunitySheet: View {
    let recipe: CustomRecipe
    @EnvironmentObject var service: CommunityService
    @Environment(\.dismiss) private var dismiss
    @AppStorage("community.author") private var author = ""
    @State private var done = false

    var body: some View {
        NavigationStack {
            Form {
                if !service.configured {
                    Section {
                        Text("Die Community ist noch nicht verbunden. Richte sie zuerst unter Rezepte, Community ein.")
                    }
                } else if service.mine[recipe.id.uuidString] != nil {
                    Section {
                        Label("Dieses Rezept ist in der Community veröffentlicht.", systemImage: "checkmark.seal")
                        Button("Veröffentlichung zurückziehen", role: .destructive) {
                            Task { await service.unpublish(recipe.id); dismiss() }
                        }
                    }
                } else {
                    Section {
                        TextField("Anzeigename (z. B. Sean)", text: $author)
                    } header: {
                        Text("Wer soll als Autor stehen?")
                    } footer: {
                        Text("Veröffentlicht werden: Rezeptname, Zutaten mit Mengen, Schritte, Notiz und dein Anzeigename. Keine Kontodaten, kein Foto. Alle Nutzer können das Rezept sehen und kopieren. Du kannst es jederzeit zurückziehen.")
                    }
                    Section {
                        Button {
                            Task { done = await service.publish(recipe, author: author.isEmpty ? "Anonym" : author) }
                        } label: { Label("Jetzt veröffentlichen", systemImage: "person.3") }
                        .disabled(service.busy)
                        if done { Label("Veröffentlicht", systemImage: "checkmark.circle.fill").foregroundStyle(.green) }
                    }
                }
                if let e = service.error { Section { Text(e).font(.footnote).foregroundStyle(.red) } }
            }
            .navigationTitle("Mit Community teilen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Schließen") { dismiss() } } }
        }
    }
}

struct CommunitySetupView: View {
    @EnvironmentObject var service: CommunityService
    @State private var projectID = CommunityConfig.projectID
    @State private var apiKey = CommunityConfig.apiKey
    @State private var tested: String?

    var body: some View {
        Form {
            Section {
                TextField("Projekt-ID", text: $projectID).textInputAutocapitalization(.never).autocorrectionDisabled()
                TextField("Web-API-Key", text: $apiKey).textInputAutocapitalization(.never).autocorrectionDisabled()
                Button {
                    service.saveConfig(projectID: projectID, apiKey: apiKey)
                    Task {
                        await service.reload()
                        tested = service.error ?? "Verbunden. \(service.recipes.count) Rezepte gefunden."
                    }
                } label: { Label("Speichern und testen", systemImage: "checkmark.circle") }
                .disabled(projectID.trimmingCharacters(in: .whitespaces).isEmpty || apiKey.trimmingCharacters(in: .whitespaces).isEmpty)
                if let t = tested { Text(t).font(.footnote).foregroundStyle(.secondary) }
            } header: { Text("Firebase-Verbindung") }
            Section("Einrichtung in 6 Schritten") {
                Text("1. console.firebase.google.com öffnen, „Projekt hinzufügen“ (Google Analytics kann aus bleiben).")
                Text("2. Build, Firestore Database, „Datenbank erstellen“, Region eur3 (Europa), Produktionsmodus.")
                Text("3. Build, Authentication, „Jetzt starten“, Anmeldemethode „Anonym“ aktivieren.")
                Text("4. Firestore, Reiter „Regeln“: den Text unten einfügen und veröffentlichen.")
                Text("5. Projekteinstellungen (Zahnrad): „Projekt-ID“ und „Web-API-Key“ kopieren.")
                Text("6. Beides oben eintragen und „Speichern und testen“ tippen.")
            }
            Section {
                Text(CommunityConfig.rules).font(.system(.caption2, design: .monospaced)).textSelection(.enabled)
                ShareLink(item: CommunityConfig.rules) { Label("Regeln teilen / kopieren", systemImage: "square.and.arrow.up") }
            } header: { Text("Firestore-Regeln") } footer: {
                Text("Die Regeln erlauben Lesen und Veröffentlichen nur für angemeldete Nutzer, Löschen nur dem Autor und beim Melden nur das Hochzählen des Meldezählers. Für eine öffentliche App im App Store brauchst du zusätzlich Moderation.")
            }
        }
        .navigationTitle("Community einrichten")
        .navigationBarTitleDisplayMode(.inline)
    }
}
