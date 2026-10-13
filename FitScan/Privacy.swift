import SwiftUI
import UIKit

/// Rechtliche Angaben – HIER vor dem Release eintragen (siehe Dokument „Datenschutz, Recht und Monetarisierung“).
enum LegalInfo {
    static let responsibleName = "[Name eintragen]"
    static let responsibleAddress = "[Ladungsfähige Anschrift eintragen]"
    static let contactEmail = "[E-Mail eintragen]"
    /// Sobald die Datenschutzerklärung online steht, hier die URL eintragen (App Store Connect verlangt sie ebenfalls).
    static let privacyURL: URL? = nil
}

/// Erster Start: Einwilligung in die Verarbeitung von Gesundheitsdaten (DSGVO Art. 9) – jederzeit widerrufbar.
struct ConsentView: View {
    @AppStorage("bfc.consent.answered") private var answered = false
    @AppStorage("bfc.consent.health") private var health = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Willkommen bei BFC").font(.largeTitle.bold())
                Text("Deine Daten gehören dir. BFC speichert alles auf deinem iPhone und lädt keine Gesundheitsdaten auf Server hoch.")
                Group {
                    Label("Apple Health: Schritte, Workouts, Gewicht und Puls werden gelesen, um deinen Fortschritt und Rang zu berechnen.", systemImage: "heart.text.square")
                    Label("Körperscan und Maße bleiben lokal auf dem Gerät.", systemImage: "figure.stand")
                    Label("Standort nur während eines Trainings draußen, für Karte und Strecke.", systemImage: "location")
                    Label("Teilen passiert nur, wenn du selbst auf „Teilen“ tippst.", systemImage: "square.and.arrow.up")
                }
                .font(.subheadline)
                Text("Wichtig: BFC ersetzt keinen Arzt, alle Angaben sind Richtwerte, die Nutzung erfolgt auf eigene Verantwortung. Der Entwickler haftet nicht für Schäden aus der Nutzung, soweit gesetzlich zulässig (Details unter Profil → Datenschutz → Haftungsausschluss).")
                    .font(.footnote)
                Text("Gesundheitsdaten sind besonders geschützt. Mit „Einverstanden“ willigst du ausdrücklich ein, dass BFC sie wie beschrieben verarbeitet. Du kannst das jederzeit unter Profil → Datenschutz widerrufen. BFC ersetzt keine ärztliche Beratung. Nutzung ab 16 Jahren.")
                    .font(.footnote).foregroundStyle(.secondary)
                Button { health = true; answered = true } label: {
                    Text("Einverstanden").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent).controlSize(.large)
                Button { health = false; answered = true } label: {
                    Text("Ohne Apple Health fortfahren").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered).controlSize(.large)
            }
            .padding(24)
        }
        .interactiveDismissDisabled()
    }
}

/// Datenschutz-Abschnitt im Profil: Widerruf, Export, Löschen, Texte.
struct PrivacySection: View {
    @AppStorage("bfc.consent.health") private var consentHealth = false
    @State private var exportURL: URL?
    @State private var confirmDelete = false
    @State private var deleted = false

    var body: some View {
        Section {
            Toggle("Apple-Health-Daten verwenden", isOn: $consentHealth)
            NavigationLink { LegalTextView() } label: { Label("Datenschutz, Haftung und Impressum", systemImage: "hand.raised") }
            if let url = exportURL {
                ShareLink(item: url) { Label("Meine Daten exportieren (JSON)", systemImage: "square.and.arrow.up") }
            } else {
                Button { exportURL = Self.makeExport() } label: { Label("Export vorbereiten", systemImage: "tray.and.arrow.down") }
            }
            Button(role: .destructive) { confirmDelete = true } label: { Label("Alle Daten in der App löschen", systemImage: "trash") }
        } header: {
            Text("Datenschutz")
        } footer: {
            Text(deleted ? "Gelöscht. Bitte die App einmal schließen und neu öffnen." : "Alle Daten liegen nur auf diesem iPhone. Apple-Health-Daten selbst bleiben in Apple Health und werden hier nicht gelöscht.")
        }
        .confirmationDialog("Wirklich alles in BFC löschen? Profil, Essen, Training, Scans, Rang und Profilbild gehen verloren.",
                            isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Alles löschen", role: .destructive) { Self.wipe(); deleted = true }
            Button("Abbrechen", role: .cancel) {}
        }
    }

    static func makeExport() -> URL? {
        var out: [String: Any] = [:]
        for (k, v) in UserDefaults.standard.dictionaryRepresentation() {
            if k.hasPrefix("Apple") || k.hasPrefix("NS") || k.hasPrefix("com.apple") || k.hasPrefix("AK") { continue }
            switch v {
            case let d as Data:
                if let obj = try? JSONSerialization.jsonObject(with: d) { out[k] = obj } else { out[k] = d.base64EncodedString() }
            case let d as Date: out[k] = ISO8601DateFormatter().string(from: d)
            case is String, is NSNumber, is [Any], is [String: Any]:
                if JSONSerialization.isValidJSONObject([k: v]) { out[k] = v }
            default: break
            }
        }
        guard let data = try? JSONSerialization.data(withJSONObject: out, options: [.prettyPrinted, .sortedKeys]) else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("BFC-Daten-Export.json")
        try? data.write(to: url)
        return url
    }

    static func wipe() {
        if let id = Bundle.main.bundleIdentifier { UserDefaults.standard.removePersistentDomain(forName: id) }
        let fm = FileManager.default
        for dir in [FileManager.SearchPathDirectory.documentDirectory, .applicationSupportDirectory, .cachesDirectory] {
            if let base = fm.urls(for: dir, in: .userDomainMask).first,
               let items = try? fm.contentsOfDirectory(at: base, includingPropertiesForKeys: nil) {
                for u in items { try? fm.removeItem(at: u) }
            }
        }
    }
}

struct LegalTextView: View {
    var body: some View {
        List {
            Section {
                Text("Datenschutzerklärung").font(.title2.bold())
                Text("Dies ist die vollständige Fassung. Sie gilt für BFC und BFC Scanner.").font(.footnote).foregroundStyle(.secondary)
            }
            ForEach(Array(LegalTexts.privacy.enumerated()), id: \.offset) { _, sec in
                Section(sec.title) { Text(sec.body).font(.footnote) }
            }
            Section("Haftungsausschluss") { Text(LegalTexts.disclaimer).font(.footnote) }
            Section("Impressum") {
                Text("\(LegalInfo.responsibleName)\n\(LegalInfo.responsibleAddress)\nE-Mail: \(LegalInfo.contactEmail)").font(.footnote)
            }
            if let u = LegalInfo.privacyURL {
                Section { Link("Datenschutzerklärung online", destination: u) }
            }
        }
        .navigationTitle("Datenschutz")
    }
}
