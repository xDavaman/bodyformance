import AudioToolbox
import Combine
import PhotosUI
import SwiftUI

// Kochen Schritt für Schritt, eigene Kochfotos (Galerie und je Schritt) und die Nährwert-Übersicht eines Rezepts.
// Alle Fotos bleiben auf dem Gerät (Dokumente/RecipePhotos/<Rezept-ID>/).

private func g0(_ v: Double) -> String { String(Int(v.rounded())) }
private func eur(_ v: Double) -> String { String(format: "%.2f €", v) }

// MARK: Fotos speichern

extension RecipeStore {
    private static let thumbs = NSCache<NSString, UIImage>()

    private func folder(_ r: Recipe) -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let f = dir.appendingPathComponent("RecipePhotos", isDirectory: true).appendingPathComponent(r.id, isDirectory: true)
        try? FileManager.default.createDirectory(at: f, withIntermediateDirectories: true)
        return f
    }

    static func jpeg(_ img: UIImage, maxSide: CGFloat = 1600) -> Data? {
        let scale = min(1, maxSide / max(img.size.width, img.size.height))
        let size = CGSize(width: img.size.width * scale, height: img.size.height * scale)
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 1
        return UIGraphicsImageRenderer(size: size, format: fmt).image { _ in img.draw(in: CGRect(origin: .zero, size: size)) }
            .jpegData(compressionQuality: 0.85)
    }

    static func image(at url: URL) -> UIImage? {
        if let img = thumbs.object(forKey: url.path as NSString) { return img }
        guard let data = try? Data(contentsOf: url), let img = UIImage(data: data) else { return nil }
        thumbs.setObject(img, forKey: url.path as NSString)
        return img
    }

    private func write(_ img: UIImage, to url: URL) {
        guard let data = Self.jpeg(img) else { return }
        try? data.write(to: url, options: .atomic)
        Self.thumbs.removeObject(forKey: url.path as NSString)
        photoVersion += 1
    }

    // Foto je Zubereitungsschritt
    private func stepURL(_ r: Recipe, _ step: Int) -> URL? { folder(r)?.appendingPathComponent("schritt-\(step + 1).jpg") }

    func stepPhoto(_ r: Recipe, step: Int) -> UIImage? {
        guard let url = stepURL(r, step), FileManager.default.fileExists(atPath: url.path) else { return nil }
        return Self.image(at: url)
    }

    func setStepPhoto(_ img: UIImage, _ r: Recipe, step: Int) {
        if let url = stepURL(r, step) { write(img, to: url) }
    }

    func removeStepPhoto(_ r: Recipe, step: Int) {
        guard let url = stepURL(r, step) else { return }
        try? FileManager.default.removeItem(at: url)
        Self.thumbs.removeObject(forKey: url.path as NSString)
        photoVersion += 1
    }

    // Galerie: eigene Fotos vom fertigen Gericht, neueste zuerst
    func gallery(_ r: Recipe) -> [URL] {
        guard let f = folder(r) else { return [] }
        let files = (try? FileManager.default.contentsOfDirectory(at: f, includingPropertiesForKeys: [.creationDateKey])) ?? []
        return files.filter { $0.lastPathComponent.hasPrefix("galerie-") }
            .sorted { $0.lastPathComponent > $1.lastPathComponent }
    }

    func addToGallery(_ img: UIImage, _ r: Recipe) {
        let stamp = Int(Date().timeIntervalSince1970 * 1000)
        if let url = folder(r)?.appendingPathComponent("galerie-\(stamp).jpg") { write(img, to: url) }
    }

    func removeFromGallery(_ url: URL) {
        try? FileManager.default.removeItem(at: url)
        Self.thumbs.removeObject(forKey: url.path as NSString)
        photoVersion += 1
    }

    /// Löscht Galerie und Schrittfotos eines Rezepts (beim Löschen eigener Rezepte)
    func removeAllPhotos(_ r: Recipe) {
        if let f = folder(r) { try? FileManager.default.removeItem(at: f) }
        Self.thumbs.removeAllObjects()
        photoVersion += 1
    }
}

// MARK: Schritte auswerten

enum StepParser {
    /// Zeitangaben im Schritt („15 Minuten“, „3–4 Min.“, „30 Sekunden“, „1 Stunde“) in Sekunden; bei Spannen der kleinere Wert
    static func timers(in step: String) -> [Int] {
        let pattern = #"(\d+(?:[,.]\d+)?)(?:\s*(?:–|-|bis)\s*\d+(?:[,.]\d+)?)?\s*(Stunden|Stunde|Std\.?|Minuten|Minute|Min\.?|Sekunden|Sek\.?)(?![a-zäöüß])"#
        guard let re = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return [] }
        let ns = step as NSString
        var out: [Int] = []
        for m in re.matches(in: step, range: NSRange(location: 0, length: ns.length)) {
            let n = Double(ns.substring(with: m.range(at: 1)).replacingOccurrences(of: ",", with: ".")) ?? 0
            let unit = ns.substring(with: m.range(at: 2)).lowercased()
            let factor: Double = unit.hasPrefix("s") && !unit.hasPrefix("st") ? 1 : (unit.hasPrefix("st") ? 3600 : 60)
            let secs = Int(n * factor)
            if secs > 0 && !out.contains(secs) { out.append(secs) }
        }
        return out
    }

    private static func words(_ s: String) -> [String] {
        s.lowercased().components(separatedBy: CharacterSet.letters.inverted).filter { $0.count >= 4 }
    }

    /// Zutaten, die im Schritt vorkommen („Nudeln kochen“ findet „Vollkornnudeln (trocken)“)
    static func ingredients(of recipe: Recipe, in step: String) -> [RecipeItem] {
        let sw = words(step)
        return recipe.items.filter { item in
            let iw = words(item.ing.name)
            return iw.contains { w in sw.contains { s in s.hasPrefix(String(w.prefix(max(4, w.count - 2)))) } }
                || sw.contains { s in s.count >= 5 && item.ing.name.lowercased().contains(s) }
        }
    }

    static func clock(_ secs: Int) -> String {
        secs >= 3600 ? String(format: "%d:%02d:%02d", secs / 3600, secs / 60 % 60, secs % 60)
            : String(format: "%d:%02d", secs / 60, secs % 60)
    }
}

// MARK: Kochmodus

/// Läuft im Hintergrund weiter, solange der Kochmodus offen ist; mehrere Timer gleichzeitig möglich
final class CookTimers: ObservableObject {
    struct Item: Identifiable { let id = UUID(); let label: String; var end: Date; let total: Int }
    @Published var items: [Item] = []
    @Published var now = Date()
    @Published var rang: Set<UUID> = []
    private var tick: AnyCancellable?

    init() {
        tick = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in self?.update() }
    }

    func start(_ secs: Int, label: String) { items.append(Item(label: label, end: Date().addingTimeInterval(Double(secs)), total: secs)) }
    func remaining(_ i: Item) -> Int { max(0, Int(i.end.timeIntervalSince(now).rounded(.up))) }
    func extend(_ i: Item) {
        if let k = items.firstIndex(where: { $0.id == i.id }) {
            items[k].end = max(items[k].end, now).addingTimeInterval(60)
            rang.remove(i.id)
        }
    }
    func stop(_ i: Item) { items.removeAll { $0.id == i.id }; rang.remove(i.id) }

    private func update() {
        now = Date()
        for i in items where remaining(i) == 0 && !rang.contains(i.id) {
            rang.insert(i.id)
            AudioServicesPlayAlertSound(SystemSoundID(1005))
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}

struct CookModeView: View {
    let recipe: Recipe
    let scale: Double
    @EnvironmentObject var store: RecipeStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var timers = CookTimers()
    @State private var page = 0
    @State private var checked: Set<Int> = []
    @State private var photoItem: PhotosPickerItem?
    @State private var cameraStep: Int?
    @State private var finishPhoto = false

    private var steps: [String] { store.steps(for: recipe) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProgressView(value: Double(page), total: Double(max(1, steps.count + 1)))
                    .padding(.horizontal)
                TabView(selection: $page) {
                    prepPage.tag(0)
                    ForEach(Array(steps.enumerated()), id: \.offset) { i, s in
                        stepPage(i, s).tag(i + 1)
                    }
                    donePage.tag(steps.count + 1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                if !timers.items.isEmpty { timerBar }
                HStack {
                    Button { withAnimation { page = max(0, page - 1) } } label: {
                        Label("Zurück", systemImage: "chevron.left").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered).disabled(page == 0)
                    Button { withAnimation { page = min(steps.count + 1, page + 1) } } label: {
                        Label(page == 0 ? "Los geht's" : "Weiter", systemImage: "chevron.right").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent).disabled(page > steps.count)
                }
                .controlSize(.large)
                .padding()
            }
            .navigationTitle(page == 0 ? "Vorbereiten" : (page > steps.count ? "Fertig" : "Schritt \(page) von \(steps.count)"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Schließen") { dismiss() } }
            }
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
        .fullScreenCover(item: Binding(get: { cameraStep.map { CamTarget(step: $0) } }, set: { cameraStep = $0?.step })) { t in
            CameraPicker { img in
                if t.step < 0 { store.addToGallery(img, recipe) } else { store.setStepPhoto(img, recipe, step: t.step) }
            }
            .ignoresSafeArea()
        }
    }

    private struct CamTarget: Identifiable { let step: Int; var id: Int { step } }

    private func amount(_ item: RecipeItem) -> String {
        let grams = item.grams * scale
        var s = "\(g0(grams)) g"
        if let pg = item.ing.pieceGrams, let pn = item.ing.pieceName {
            let n = grams / pg
            s += " (≈ \(n == n.rounded() ? String(Int(n)) : String(format: "%.1f", n)) \(pn))"
        }
        return s
    }

    private var prepPage: some View {
        List {
            Section {
                Text("Leg dir alles bereit. Tippe Zutaten an, die du schon hast.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Section("Zutaten") {
                ForEach(Array(recipe.items.enumerated()), id: \.offset) { i, item in
                    Button {
                        if checked.contains(i) { checked.remove(i) } else { checked.insert(i) }
                    } label: {
                        HStack {
                            Image(systemName: checked.contains(i) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(checked.contains(i) ? Color.green : Color.secondary)
                            Text(item.ing.name).strikethrough(checked.contains(i))
                            Spacer()
                            Text(amount(item)).foregroundStyle(.secondary)
                        }
                        .font(.title3)
                    }
                    .buttonStyle(.plain)
                }
            }
            Section {
                LabeledContent("Zeit", value: "\(recipe.minutes) Min.")
                LabeledContent("Schritte", value: "\(steps.count)")
            }
        }
    }

    private func stepPage(_ i: Int, _ s: String) -> some View {
        let used = StepParser.ingredients(of: recipe, in: s)
        let times = StepParser.timers(in: s)
        return ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let img = store.stepPhoto(recipe, step: i) {
                    Image(uiImage: img).resizable().scaledToFill()
                        .frame(maxWidth: .infinity).frame(height: 220).clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .contextMenu {
                            Button("Foto entfernen", role: .destructive) { store.removeStepPhoto(recipe, step: i) }
                        }
                }
                Text(s).font(.title2.weight(.medium)).fixedSize(horizontal: false, vertical: true)
                if !used.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Dafür brauchst du").font(.footnote).foregroundStyle(.secondary)
                        ForEach(Array(used.enumerated()), id: \.offset) { _, item in
                            HStack { Text(item.ing.name); Spacer(); Text(amount(item)).foregroundStyle(.secondary) }
                        }
                    }
                    .padding().background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                }
                ForEach(times, id: \.self) { secs in
                    Button { timers.start(secs, label: "Schritt \(i + 1)") } label: {
                        Label("Timer \(StepParser.clock(secs)) starten", systemImage: "timer").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered).controlSize(.large)
                }
                HStack {
                    PhotosPicker(selection: Binding(get: { photoItem }, set: { item in
                        photoItem = item
                        load(item) { store.setStepPhoto($0, recipe, step: i) }
                    }), matching: .images) {
                        Label(store.stepPhoto(recipe, step: i) == nil ? "Foto zum Schritt" : "Foto ersetzen", systemImage: "photo")
                    }
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        Spacer()
                        Button { cameraStep = i } label: { Label("Aufnehmen", systemImage: "camera") }
                    }
                }
                .font(.subheadline)
            }
            .padding()
            .id(store.photoVersion)
        }
    }

    private var donePage: some View {
        VStack(spacing: 18) {
            Spacer()
            Text("🍽️").font(.system(size: 72))
            Text("Guten Appetit!").font(.title.bold())
            Text("Halte dein Ergebnis fest. Das Foto landet in deinen Kochfotos zu diesem Rezept.")
                .multilineTextAlignment(.center).foregroundStyle(.secondary).padding(.horizontal)
            HStack {
                PhotosPicker(selection: Binding(get: { photoItem }, set: { item in
                    photoItem = item
                    load(item) { store.addToGallery($0, recipe) }
                }), matching: .images) {
                    Label("Foto wählen", systemImage: "photo").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button { cameraStep = -1 } label: { Label("Aufnehmen", systemImage: "camera").frame(maxWidth: .infinity) }
                        .buttonStyle(.borderedProminent)
                }
            }
            .controlSize(.large).padding(.horizontal)
            Spacer()
        }
    }

    private var timerBar: some View {
        VStack(spacing: 6) {
            ForEach(timers.items) { t in
                let rest = timers.remaining(t)
                HStack {
                    Image(systemName: rest == 0 ? "bell.fill" : "timer")
                    Text(t.label).font(.subheadline)
                    Spacer()
                    Text(rest == 0 ? "Fertig" : StepParser.clock(rest)).monospacedDigit().bold()
                    Button("+1 Min.") { timers.extend(t) }.buttonStyle(.bordered).controlSize(.small)
                    Button { timers.stop(t) } label: { Image(systemName: "xmark") }.buttonStyle(.borderless)
                }
                .padding(10)
                .background(rest == 0 ? Color.red.opacity(0.25) : Color(.secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.horizontal)
    }

    private func load(_ item: PhotosPickerItem?, then use: @escaping (UIImage) -> Void) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self), let img = UIImage(data: data) {
                await MainActor.run { use(img) }
            }
            await MainActor.run { photoItem = nil }
        }
    }
}

// MARK: Eigene Kochfotos im Rezept

struct RecipeGallerySection: View {
    let recipe: Recipe
    @EnvironmentObject var store: RecipeStore
    @State private var items: [PhotosPickerItem] = []
    @State private var camera = false
    @State private var shown: URL?

    var body: some View {
        let urls = store.gallery(recipe)
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(urls, id: \.self) { url in
                        if let img = RecipeStore.image(at: url) {
                            Button { shown = url } label: {
                                Image(uiImage: img).resizable().scaledToFill()
                                    .frame(width: 96, height: 96).clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    PhotosPicker(selection: $items, maxSelectionCount: 10, matching: .images) {
                        VStack(spacing: 4) {
                            Image(systemName: "plus").font(.title2)
                            Text("Fotos").font(.caption)
                        }
                        .frame(width: 96, height: 96)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
                    }
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        Button { camera = true } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "camera").font(.title2)
                                Text("Aufnehmen").font(.caption)
                            }
                            .frame(width: 96, height: 96)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .id(store.photoVersion)
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        } header: {
            Text(urls.isEmpty ? "Meine Kochfotos" : "Meine Kochfotos (\(urls.count))")
        } footer: {
            Text("Bleiben auf deinem iPhone. Antippen, um ein Foto als Titelbild zu nehmen oder zu löschen.")
        }
        .onChange(of: items) { _, list in
            guard !list.isEmpty else { return }
            Task {
                for item in list {
                    if let data = try? await item.loadTransferable(type: Data.self), let img = UIImage(data: data) {
                        await MainActor.run { store.addToGallery(img, recipe) }
                    }
                }
                await MainActor.run { items = [] }
            }
        }
        .fullScreenCover(isPresented: $camera) {
            CameraPicker { img in store.addToGallery(img, recipe) }.ignoresSafeArea()
        }
        .sheet(item: Binding(get: { shown.map { GalleryPhoto(url: $0) } }, set: { shown = $0?.url })) { p in
            NavigationStack {
                VStack {
                    if let img = RecipeStore.image(at: p.url) {
                        Image(uiImage: img).resizable().scaledToFit()
                    }
                    Text(Self.date(p.url)).font(.footnote).foregroundStyle(.secondary)
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Fertig") { shown = nil } }
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button { if let img = RecipeStore.image(at: p.url) { store.setPhoto(img, for: recipe) }; shown = nil } label: {
                                Label("Als Titelbild nehmen", systemImage: "photo")
                            }
                            if let img = RecipeStore.image(at: p.url) {
                                ShareLink(item: Image(uiImage: img), preview: SharePreview(recipe.name, image: Image(uiImage: img))) {
                                    Label("Teilen", systemImage: "square.and.arrow.up")
                                }
                            }
                            Button(role: .destructive) { store.removeFromGallery(p.url); shown = nil } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        } label: { Image(systemName: "ellipsis.circle") }
                    }
                }
            }
        }
    }

    private struct GalleryPhoto: Identifiable { let url: URL; var id: URL { url } }

    static func date(_ url: URL) -> String {
        let name = url.deletingPathExtension().lastPathComponent.replacingOccurrences(of: "galerie-", with: "")
        guard let ms = Double(name) else { return "" }
        return Date(timeIntervalSince1970: ms / 1000).formatted(date: .long, time: .shortened)
    }
}

// MARK: Nährwerte auf einen Blick

struct MacroOverview: View {
    let recipe: Recipe
    let factor: Double
    /// Orientierungswert der DGE für Erwachsene
    static let saltMax = 6.0

    var body: some View {
        let kcal = recipe.kcal * factor
        let p = recipe.protein * factor
        let c = recipe.carbs * factor
        let f = recipe.fat * factor
        let total = max(1, p * 4 + c * 4 + f * 9)
        let salt = recipe.salt * factor
        let saltShare = salt / Self.saltMax
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(g0(kcal)).font(.system(size: 34, weight: .bold, design: .rounded))
                Text("kcal").foregroundStyle(.secondary)
                Spacer()
                Text(eur(recipe.price * factor)).font(.title3.weight(.semibold))
            }
            GeometryReader { geo in
                HStack(spacing: 2) {
                    Rectangle().fill(Color.red).frame(width: geo.size.width * p * 4 / total)
                    Rectangle().fill(Color.orange).frame(width: geo.size.width * c * 4 / total)
                    Rectangle().fill(Color.yellow).frame(width: geo.size.width * f * 9 / total)
                }
                .clipShape(Capsule())
            }
            .frame(height: 12)
            HStack {
                macro("Eiweiß", p, p * 4 / total, .red)
                Spacer()
                macro("Kohlenh.", c, c * 4 / total, .orange)
                Spacer()
                macro("Fett", f, f * 9 / total, .yellow)
            }
            HStack {
                Image(systemName: "drop.triangle")
                    .foregroundStyle(saltShare > 0.4 ? Color.red : (saltShare > 0.25 ? Color.orange : Color.green))
                Text(String(format: "Salz %.1f g", salt))
                Text("· \(g0(saltShare * 100)) % von \(g0(Self.saltMax)) g am Tag").foregroundStyle(.secondary)
            }
            .font(.subheadline)
            if recipe.price > 0 {
                Text("\(g0(recipe.protein / recipe.price)) g Eiweiß pro Euro · \(g0(recipe.kcal / recipe.price)) kcal pro Euro")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func macro(_ name: String, _ grams: Double, _ share: Double, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Circle().fill(color).frame(width: 8, height: 8)
                Text(name).font(.caption).foregroundStyle(.secondary)
            }
            Text("\(g0(grams)) g").font(.headline)
            Text("\(g0(share * 100)) %").font(.caption2).foregroundStyle(.secondary)
        }
    }
}

/// Preis je Zutat für die gewählte Menge
struct PriceBreakdown: View {
    let recipe: Recipe
    let scale: Double

    var body: some View {
        DisclosureGroup("Preis aufschlüsseln") {
            ForEach(Array(recipe.items.sorted { $0.ing.price * $0.grams > $1.ing.price * $1.grams }.enumerated()), id: \.offset) { _, item in
                LabeledContent(item.ing.name, value: eur(item.ing.price * item.grams / 100 * scale))
            }
            Text("Durchschnittspreise im Supermarkt, je nach Laden und Angebot abweichend.")
                .font(.footnote).foregroundStyle(.secondary)
        }
    }
}

// MARK: Sortierung der Bibliothek

enum RecipeSort: String, CaseIterable, Identifiable {
    case standard = "Standard", protein = "Meiste Eiweiß", value = "Eiweiß pro Euro", cheap = "Günstigste",
         light = "Wenigste kcal", fast = "Schnellste", salt = "Wenig Salz"
    var id: String { rawValue }

    func apply(_ list: [Recipe]) -> [Recipe] {
        switch self {
        case .standard: return list
        case .protein: return list.sorted { $0.protein > $1.protein }
        case .value: return list.sorted { $0.protein / max(0.01, $0.price) > $1.protein / max(0.01, $1.price) }
        case .cheap: return list.sorted { $0.price < $1.price }
        case .light: return list.sorted { $0.kcal < $1.kcal }
        case .fast: return list.sorted { $0.minutes < $1.minutes }
        case .salt: return list.sorted { $0.salt < $1.salt }
        }
    }
}
