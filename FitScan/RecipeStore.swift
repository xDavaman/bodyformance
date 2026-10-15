import Combine
import PhotosUI
import SwiftUI

// Eigene Schritte, eigene Rezepte und Fotos zu Rezepten.
// Eingebaute Rezepte bleiben unverändert; deine Änderungen liegen getrennt auf dem Gerät und lassen sich zurücksetzen.

struct CustomItem: Codable, Identifiable {
    var id = UUID()
    var name: String
    var grams: Double
    // Werte je 100 g
    var kcal: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var salt: Double = 0
    var price: Double = 0
    var sugar: Double? = nil
}

struct CustomRecipe: Codable, Identifiable {
    var id = UUID()
    var name = ""
    var slots: [MealSlot] = [.lunch]
    var minutes = 20
    var prepDays = 0
    var vegetarian = false
    var items: [CustomItem] = []
    var steps: [String] = []
    var note = ""

    var asRecipe: Recipe {
        Recipe(id: "custom-" + id.uuidString, name: name.isEmpty ? "Eigenes Rezept" : name, slots: slots.isEmpty ? [.lunch] : slots,
               minutes: minutes, prepDays: prepDays, vegetarian: vegetarian, vegan: false,
               items: items.map { RecipeItem(ing: Ing(name: $0.name, kcal: $0.kcal, protein: $0.protein, fat: $0.fat,
                                                      carbs: $0.carbs, salt: $0.salt, price: $0.price, sugar: $0.sugar ?? 0), grams: $0.grams) },
               steps: steps, note: note, rating: nil, source: "Eigenes Rezept", isCustom: true)
    }
}

final class RecipeStore: ObservableObject {
    @Published var stepOverrides: [String: [String]] = [:] { didSet { save() } }
    @Published var customs: [CustomRecipe] = [] { didSet { save() } }
    @Published var photoVersion = 0

    private let defaults = UserDefaults.standard

    init() {
        if let d = defaults.data(forKey: "recipes.steps"), let v = try? JSONDecoder().decode([String: [String]].self, from: d) { stepOverrides = v }
        if let d = defaults.data(forKey: "recipes.customs"), let v = try? JSONDecoder().decode([CustomRecipe].self, from: d) { customs = v }
    }

    private func save() {
        if let d = try? JSONEncoder().encode(stepOverrides) { defaults.set(d, forKey: "recipes.steps") }
        if let d = try? JSONEncoder().encode(customs) { defaults.set(d, forKey: "recipes.customs") }
    }

    var all: [Recipe] { RecipeLibrary.all + customs.map { $0.asRecipe } }

    func steps(for r: Recipe) -> [String] { stepOverrides[r.id] ?? r.steps }
    func hasCustomSteps(_ r: Recipe) -> Bool { stepOverrides[r.id] != nil }

    func setSteps(_ steps: [String], for r: Recipe) {
        let clean = steps.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        if r.isCustom, let i = customs.firstIndex(where: { "custom-" + $0.id.uuidString == r.id }) {
            customs[i].steps = clean
        } else {
            stepOverrides[r.id] = clean
        }
    }
    func resetSteps(for r: Recipe) { stepOverrides[r.id] = nil }

    func customIndex(for r: Recipe) -> Int? { customs.firstIndex { "custom-" + $0.id.uuidString == r.id } }
    func deleteCustom(_ r: Recipe) {
        customs.removeAll { "custom-" + $0.id.uuidString == r.id }
        removePhoto(for: r)
    }

    // MARK: Fotos

    /// Verkleinerte Bilder im Speicher, damit Listen mit vielen Rezepten flüssig bleiben
    private let photoCache = NSCache<NSString, UIImage>()

    private func photoURL(_ r: Recipe) -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let folder = dir.appendingPathComponent("RecipePhotos", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder.appendingPathComponent(r.id + ".jpg")
    }

    /// Eigenes Foto, sonst ein mit der App ausgeliefertes Foto (Datei `recipe-<id>.jpg` im App-Bundle), sonst nil.
    func photo(for r: Recipe) -> UIImage? {
        if let img = photoCache.object(forKey: r.id as NSString) { return img }
        var img: UIImage?
        if let url = photoURL(r), let data = try? Data(contentsOf: url) { img = UIImage(data: data) }
        if img == nil { img = Self.bundledPhoto(for: r) }
        if let img { photoCache.setObject(img, forKey: r.id as NSString) }
        return img
    }

    /// Foto, das mit der App ausgeliefert wird (für alle Nutzer gleich)
    static func bundledPhoto(for r: Recipe) -> UIImage? {
        for ext in ["jpg", "jpeg", "png", "heic"] {
            if let url = Bundle.main.url(forResource: "recipe-" + r.id, withExtension: ext)
                ?? Bundle.main.url(forResource: "recipe-" + r.id, withExtension: ext, subdirectory: "RecipePhotos"),
               let img = UIImage(contentsOfFile: url.path) {
                return img
            }
        }
        return nil
    }

    /// true, wenn der Nutzer selbst ein Foto hinterlegt hat (das ausgelieferte zählt nicht)
    func hasOwnPhoto(_ r: Recipe) -> Bool {
        guard let url = photoURL(r) else { return false }
        return FileManager.default.fileExists(atPath: url.path)
    }

    func hasPhoto(_ r: Recipe) -> Bool { hasOwnPhoto(r) || Self.bundledPhoto(for: r) != nil }

    func setPhoto(_ data: Data, for r: Recipe) {
        guard let img = UIImage(data: data) else { return }
        setPhoto(img, for: r)
    }

    func setPhoto(_ img: UIImage, for r: Recipe) {
        guard let url = photoURL(r) else { return }
        // Auf max. 1600 px verkleinern (scharf genug für das große Titelbild, klein genug für Backup)
        let maxSide: CGFloat = 1600
        let scale = min(1, maxSide / max(img.size.width, img.size.height))
        let size = CGSize(width: img.size.width * scale, height: img.size.height * scale)
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 1
        let resized = UIGraphicsImageRenderer(size: size, format: fmt).image { _ in img.draw(in: CGRect(origin: .zero, size: size)) }
        if let jpg = resized.jpegData(compressionQuality: 0.85) {
            try? jpg.write(to: url, options: .atomic)
            photoCache.removeObject(forKey: r.id as NSString)
            photoVersion += 1
        }
    }

    func removePhoto(for r: Recipe) {
        if let url = photoURL(r) { try? FileManager.default.removeItem(at: url) }
        photoCache.removeObject(forKey: r.id as NSString)
        photoVersion += 1
    }

    /// Packt alle eigenen Fotos als `recipe-<id>.jpg` in eine ZIP-Datei – zum Teilen oder um sie fest in die App
    /// aufzunehmen (entpacken nach `FitScan/RecipePhotos/`, dann sieht jeder Nutzer die Bilder).
    func exportPhotosZip() -> URL? {
        let fm = FileManager.default
        let tmp = fm.temporaryDirectory.appendingPathComponent("BFC-Rezeptfotos", isDirectory: true)
        try? fm.removeItem(at: tmp)
        try? fm.createDirectory(at: tmp, withIntermediateDirectories: true)
        var copied = 0
        for r in all where hasOwnPhoto(r) {
            if let src = photoURL(r), (try? fm.copyItem(at: src, to: tmp.appendingPathComponent("recipe-\(r.id).jpg"))) != nil {
                copied += 1
            }
        }
        guard copied > 0 else { return nil }
        var out: URL?
        var err: NSError?
        NSFileCoordinator().coordinate(readingItemAt: tmp, options: .forUploading, error: &err) { zip in
            let dst = fm.temporaryDirectory.appendingPathComponent("BFC-Rezeptfotos.zip")
            try? fm.removeItem(at: dst)
            if (try? fm.copyItem(at: zip, to: dst)) != nil { out = dst }
        }
        return out
    }
}

// MARK: Titelbild

extension Recipe {
    /// Platzhalter-Symbol, solange kein eigenes Foto da ist
    var emoji: String {
        let n = name.lowercased()
        let table: [(String, String)] = [
            ("shake", "🥤"), ("porridge", "🥣"), ("oats", "🥣"), ("skyr", "🥣"), ("quark-creme", "🥣"), ("joghurt mit", "🥣"),
            ("pancake", "🥞"), ("wrap", "🌯"), ("fajita", "🌯"), ("burrito", "🌯"), ("toast", "🍞"), ("brot", "🍞"), ("platte", "🍞"),
            ("omelett", "🍳"), ("rührei", "🍳"), ("shakshuka", "🍳"), ("muffin", "🧁"), ("hash", "🍳"),
            ("pasta", "🍝"), ("nudel", "🍝"), ("spirelli", "🍝"), ("bolognese", "🍝"),
            ("curry", "🍛"), ("dal", "🍛"), ("chili", "🌶️"), ("suppe", "🍲"), ("one-pot", "🍲"),
            ("salat", "🥗"), ("bowl", "🥗"), ("quinoa", "🥗"), ("bulgur", "🥗"), ("hirse", "🥗"), ("couscous", "🥗"),
            ("lachs", "🐟"), ("seelachs", "🐟"), ("thunfisch", "🐟"), ("garnelen", "🍤"),
            ("hähnchen", "🍗"), ("kartoffel", "🥔"), ("hack", "🥘"), ("paprika", "🫑"), ("tofu", "🥢"), ("pfanne", "🥘"),
            ("eier", "🥚"), ("energy", "🍫"), ("reiswaffel", "🍘"), ("röllchen", "🥒"), ("happen", "🥒"), ("taler", "🥦"), ("reis", "🍚")
        ]
        for (k, e) in table where n.contains(k) { return e }
        return "🍽️"
    }
}

extension Ing {
    /// Symbol für die Zutat auf dem Teller (nil bei Gewürzen, Öl, Salz)
    var emoji: String? {
        let n = name.lowercased()
        for skip in ["öl", "salz", "gewürz", "sojasauce", "senf", "tomatenmark"] where n.contains(skip) { return nil }
        let table: [(String, String)] = [
            ("reiswaffel", "🍘"), ("süßkartoffel", "🍠"), ("kartoffel", "🥔"), ("reis", "🍚"), ("haferflocken", "🥣"), ("nudeln", "🍝"),
            ("quinoa", "🌾"), ("couscous", "🌾"), ("bulgur", "🌾"), ("hirse", "🌾"), ("brot", "🍞"), ("wrap", "🌯"),
            ("hähnchen", "🍗"), ("pute", "🦃"), ("hack", "🥩"), ("steak", "🥩"), ("schweinefilet", "🥩"),
            ("räucherlachs", "🍣"), ("lachs", "🐟"), ("thunfisch", "🐟"), ("garnelen", "🦐"), ("eier", "🥚"),
            ("hüttenkäse", "🥛"), ("quark", "🥛"), ("skyr", "🥛"), ("joghurt", "🥛"), ("milch", "🥛"),
            ("feta", "🧀"), ("mozzarella", "🧀"), ("parmesan", "🧀"), ("frischkäse", "🧀"), ("sahne", "🧈"), ("butter", "🧈"),
            ("tofu", "🍢"), ("bohnen", "🫘"), ("linsen", "🫘"), ("kichererbsen", "🫘"), ("edamame", "🫘"),
            ("brokkoli", "🥦"), ("blumenkohl", "🥦"), ("spinat", "🥬"), ("salat", "🥬"), ("weißkohl", "🥬"), ("paprika", "🫑"),
            ("zucchini", "🥒"), ("gurke", "🥒"), ("tomate", "🍅"), ("passierte", "🍅"), ("karotte", "🥕"), ("zwiebel", "🧅"),
            ("champignon", "🍄"), ("avocado", "🥑"), ("banane", "🍌"), ("apfel", "🍎"), ("beeren", "🫐"), ("datteln", "🌴"),
            ("aubergine", "🍆"), ("kürbis", "🎃"), ("mais", "🌽"), ("oliven", "🫒"), ("zitrone", "🍋"),
            ("speck", "🥓"), ("schinken", "🥓"), ("erdnuss", "🥜"), ("mandel", "🥜"), ("walnüsse", "🥜"), ("cashew", "🥜"),
            ("kerne", "🌻"), ("chia", "🌱"), ("leinsamen", "🌱"), ("honig", "🍯"), ("kakao", "🍫"), ("hummus", "🧆"),
            ("pesto", "🌿"), ("proteinpulver", "💪"), ("kokosmilch", "🥥")
        ]
        for (k, e) in table where n.contains(k) { return e }
        return "🍽️"
    }
}

extension Recipe {
    /// Bis zu fünf verschiedene Zutaten-Symbole, nach Menge sortiert
    var plateEmojis: [String] {
        var out: [String] = []
        for it in items.sorted(by: { $0.grams > $1.grams }) {
            if let e = it.ing.emoji, !out.contains(e) { out.append(e) }
            if out.count == 5 { break }
        }
        return out.isEmpty ? [emoji] : out
    }
    /// Die wichtigsten Zutaten für die Bildunterschrift
    var mainItems: [RecipeItem] {
        Array(items.filter { $0.ing.emoji != nil }.sorted { $0.grams > $1.grams }.prefix(5))
    }
}

/// Gezeichneter Teller mit den Hauptzutaten, solange kein eigenes Foto da ist
struct PlateView: View {
    let emojis: [String]
    var size: CGFloat

    var body: some View {
        ZStack {
            Circle().fill(Color.white).shadow(color: .black.opacity(0.25), radius: size * 0.04, y: size * 0.02)
            Circle().stroke(Color.gray.opacity(0.28), lineWidth: max(1, size * 0.02)).padding(size * 0.09)
            let n = emojis.count
            if n == 1 {
                Text(emojis[0]).font(.system(size: size * 0.5))
            } else if n == 2 {
                Text(emojis[0]).font(.system(size: size * 0.34)).offset(x: -size * 0.16, y: -size * 0.04)
                Text(emojis[1]).font(.system(size: size * 0.34)).offset(x: size * 0.16, y: size * 0.06)
            } else {
                Text(emojis[0]).font(.system(size: size * 0.3))
                ForEach(1..<n, id: \.self) { i in
                    let a = -Double.pi / 2 + 2 * Double.pi * Double(i - 1) / Double(n - 1)
                    Text(emojis[i]).font(.system(size: size * 0.22))
                        .offset(x: CGFloat(cos(a)) * size * 0.27, y: CGFloat(sin(a)) * size * 0.27)
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct RecipeCover: View {
    let recipe: Recipe
    var height: CGFloat = 56
    var wide = false
    @EnvironmentObject var store: RecipeStore

    var body: some View {
        let _ = store.photoVersion
        Group {
            if let img = store.photo(for: recipe) {
                Image(uiImage: img).resizable().scaledToFill()
            } else {
                ZStack {
                    LinearGradient(colors: [Color.accentColor.opacity(0.35), Color.orange.opacity(0.25)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                    if wide {
                        HStack(spacing: 18) {
                            PlateView(emojis: recipe.plateEmojis, size: height * 0.88)
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Das isst du").font(.caption.bold()).foregroundStyle(.secondary)
                                ForEach(Array(recipe.mainItems.enumerated()), id: \.offset) { _, it in
                                    Text("\(it.ing.emoji ?? "") \(it.ing.name)")
                                        .font(.subheadline).lineLimit(1).minimumScaleFactor(0.7)
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 16)
                    } else {
                        PlateView(emojis: Array(recipe.plateEmojis.prefix(3)), size: height * 0.9)
                    }
                }
            }
        }
        .frame(maxWidth: wide ? .infinity : height, minHeight: height, maxHeight: height)
        .frame(width: wide ? nil : height)
        .clipShape(RoundedRectangle(cornerRadius: wide ? 12 : 10))
    }
}

// MARK: Schritte bearbeiten

struct StepEditorSheet: View {
    let recipe: Recipe
    @EnvironmentObject var store: RecipeStore
    @Environment(\.dismiss) private var dismiss
    @State private var steps: [String]

    init(recipe: Recipe, initial: [String]) {
        self.recipe = recipe
        _steps = State(initialValue: initial.isEmpty ? [""] : initial)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(steps.indices, id: \.self) { i in
                        HStack(alignment: .top) {
                            Text("\(i + 1).").foregroundStyle(.secondary).padding(.top, 8)
                            TextField("Schritt \(i + 1)", text: $steps[i], axis: .vertical)
                        }
                    }
                    .onDelete { steps.remove(atOffsets: $0) }
                    .onMove { steps.move(fromOffsets: $0, toOffset: $1) }
                    Button { steps.append("") } label: { Label("Schritt hinzufügen", systemImage: "plus") }
                } footer: {
                    Text("Zum Löschen nach links wischen. Mit „Bearbeiten“ oben kannst du die Reihenfolge ändern.")
                }
                if !recipe.isCustom && store.hasCustomSteps(recipe) {
                    Section {
                        Button("Auf Originalschritte zurücksetzen", role: .destructive) {
                            store.resetSteps(for: recipe)
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Eigene Schritte")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Abbrechen") { dismiss() } }
                ToolbarItem(placement: .principal) { EditButton() }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        store.setSteps(steps, for: recipe)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: Eigenes Rezept anlegen / bearbeiten

struct CustomRecipeEditor: View {
    @EnvironmentObject var store: RecipeStore
    @Environment(\.dismiss) private var dismiss
    @State private var draft: CustomRecipe
    @State private var pickIngredient = false
    @State private var shareSheet = false
    private let isNew: Bool

    init(recipe: CustomRecipe?) {
        _draft = State(initialValue: recipe ?? CustomRecipe())
        isNew = recipe == nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Rezept") {
                    TextField("Name", text: $draft.name)
                    Stepper("Zubereitung: \(draft.minutes) Min.", value: $draft.minutes, in: 1...180, step: 5)
                    Stepper(draft.prepDays == 0 ? "Meal Prep: nein" : "Meal Prep: \(draft.prepDays) Tage haltbar", value: $draft.prepDays, in: 0...7)
                    Toggle("Vegetarisch", isOn: $draft.vegetarian)
                }
                Section("Passt zu") {
                    ForEach(MealSlot.allCases) { slot in
                        Toggle(slot.rawValue, isOn: Binding(
                            get: { draft.slots.contains(slot) },
                            set: { on in
                                if on { if !draft.slots.contains(slot) { draft.slots.append(slot) } }
                                else { draft.slots.removeAll { $0 == slot } }
                            }))
                    }
                }
                Section {
                    ForEach($draft.items) { $item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Text("\(Int(item.kcal)) kcal / 100 g").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            TextField("g", value: $item.grams, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 70)
                            Text("g").foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { draft.items.remove(atOffsets: $0) }
                    Button { pickIngredient = true } label: { Label("Zutat hinzufügen", systemImage: "plus") }
                } header: {
                    Text("Zutaten (Menge für 1 Portion)")
                } footer: {
                    Text("Kalorien, Eiweiß, Kohlenhydrate, Fett, Salz und Preis berechnen sich aus den Zutaten.")
                }
                if !draft.items.isEmpty {
                    Section("Summe pro Portion") {
                        let rec = draft.asRecipe
                        LabeledContent("Kalorien", value: "\(Int(rec.kcal.rounded())) kcal")
                        LabeledContent("Eiweiß", value: "\(Int(rec.protein.rounded())) g")
                        LabeledContent("Kohlenhydrate", value: "\(Int(rec.carbs.rounded())) g (davon Zucker \(Int(rec.sugar.rounded())) g)")
                        LabeledContent("Fett", value: "\(Int(rec.fat.rounded())) g")
                        if !rec.tags.isEmpty {
                            Text(rec.tags.map(\.rawValue).joined(separator: " · ")).font(.footnote).foregroundStyle(Color.accentColor)
                        }
                    }
                }
                Section("Schritte") {
                    ForEach(draft.steps.indices, id: \.self) { i in
                        HStack(alignment: .top) {
                            Text("\(i + 1).").foregroundStyle(.secondary).padding(.top, 8)
                            TextField("Schritt \(i + 1)", text: $draft.steps[i], axis: .vertical)
                        }
                    }
                    .onDelete { draft.steps.remove(atOffsets: $0) }
                    .onMove { draft.steps.move(fromOffsets: $0, toOffset: $1) }
                    Button { draft.steps.append("") } label: { Label("Schritt hinzufügen", systemImage: "plus") }
                }
                Section("Notiz") {
                    TextField("Tipps, Lagerung …", text: $draft.note, axis: .vertical)
                }
                if !isNew {
                    Section {
                        Button { shareSheet = true } label: { Label("Mit Community teilen", systemImage: "person.3") }
                        Button("Rezept löschen", role: .destructive) {
                            store.customs.removeAll { $0.id == draft.id }
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle(isNew ? "Neues Rezept" : "Rezept bearbeiten")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Abbrechen") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        draft.steps = draft.steps.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
                        if let i = store.customs.firstIndex(where: { $0.id == draft.id }) { store.customs[i] = draft }
                        else { store.customs.append(draft) }
                        dismiss()
                    }
                    .disabled(draft.name.trimmingCharacters(in: .whitespaces).isEmpty || draft.items.isEmpty)
                }
            }
            .sheet(isPresented: $pickIngredient) {
                IngredientPicker { item in draft.items.append(item) }
            }
            .sheet(isPresented: $shareSheet) { ShareToCommunitySheet(recipe: draft) }
        }
    }
}

struct IngredientPicker: View {
    var onPick: (CustomItem) -> Void
    @EnvironmentObject var foods: FoodStore
    @Environment(\.dismiss) private var dismiss
    @State private var search = ""
    @State private var mode = 1
    @State private var name = ""
    @State private var kcal = ""
    @State private var protein = ""
    @State private var fat = ""
    @State private var carbs = ""
    @State private var sugar = ""
    @State private var barcode = ""
    @State private var status = ""
    @State private var busy = false

    private func num(_ s: String) -> Double { Double(s.replacingOccurrences(of: ",", with: ".")) ?? 0 }

    private var list: [Ing] {
        Ingredients.all.filter { search.isEmpty || $0.name.localizedCaseInsensitiveContains(search) }
            .sorted { $0.name < $1.name }
    }

    private func convert(_ f: FoodItem) -> CustomItem {
        CustomItem(name: f.brand.isEmpty ? f.name : "\(f.name) (\(f.brand))", grams: f.defaultGrams, kcal: f.kcal, protein: f.protein,
                   fat: f.fat, carbs: f.carbs, salt: f.salt, price: 0, sugar: f.sugar)
    }

    private func pick(_ f: FoodItem) {
        foods.remember(f)
        onPick(convert(f))
        dismiss()
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Quelle", selection: $mode) {
                        Text("Produkte").tag(1)
                        Text("Grundzutaten").tag(0)
                        Text("Selbst").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                if mode == 2 {
                    Section("Eigene Zutat (Werte je 100 g)") {
                        TextField("Name", text: $name)
                        TextField("Kalorien", text: $kcal).keyboardType(.decimalPad)
                        TextField("Eiweiß (g)", text: $protein).keyboardType(.decimalPad)
                        TextField("Kohlenhydrate (g)", text: $carbs).keyboardType(.decimalPad)
                        TextField("davon Zucker (g)", text: $sugar).keyboardType(.decimalPad)
                        TextField("Fett (g)", text: $fat).keyboardType(.decimalPad)
                        Button("Hinzufügen (100 g)") {
                            onPick(CustomItem(name: name.isEmpty ? "Zutat" : name, grams: 100, kcal: num(kcal), protein: num(protein),
                                              fat: num(fat), carbs: num(carbs), sugar: num(sugar)))
                            dismiss()
                        }
                    }
                } else if mode == 0 {
                    Section {
                        ForEach(list, id: \.name) { ing in
                            Button {
                                onPick(CustomItem(name: ing.name, grams: 100, kcal: ing.kcal, protein: ing.protein, fat: ing.fat,
                                                  carbs: ing.carbs, salt: ing.salt, price: ing.price, sugar: ing.sugar))
                                dismiss()
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(ing.name).foregroundStyle(.primary)
                                    Text("\(Int(ing.kcal)) kcal · \(Int(ing.protein)) g Eiweiß je 100 g")
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } else {
                    Section {
                        HStack {
                            TextField("Barcode eintippen", text: $barcode).keyboardType(.numberPad)
                            Button("Suchen") {
                                Task {
                                    busy = true; status = ""
                                    if let f = await OpenFoodFacts.lookup(barcode) { pick(f) }
                                    else { status = "Barcode nicht gefunden." }
                                    busy = false
                                }
                            }
                            .buttonStyle(.borderless).disabled(barcode.filter(\.isNumber).count < 6 || busy)
                        }
                        if !status.isEmpty { Text(status).font(.footnote).foregroundStyle(.secondary) }
                    } footer: { Text("Suche oben nach Produktname oder Marke (z. B. „Magerquark“, „ESN Whey“). Gefundene Produkte lassen sich mit Menge als Zutat einfügen.") }
                    let found = search.isEmpty ? foods.recents : foods.search(search)
                    if !found.isEmpty {
                        Section(search.isEmpty ? "Zuletzt benutzt" : "\(found.count) Treffer") {
                            ForEach(found) { f in
                                Button { pick(f) } label: {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(f.brand.isEmpty ? f.name : "\(f.name) · \(f.brand)").foregroundStyle(.primary)
                                        Text("\(Int(f.kcal.rounded())) kcal · \(Int(f.protein.rounded())) g Eiweiß je 100 g")
                                            .font(.caption).foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    OnlineFoodSearch(query: search) { pick($0) }
                }
            }
            .searchable(text: $search, prompt: mode == 0 ? "Zutat suchen" : "Produkt oder Marke suchen")
            .navigationTitle("Zutat wählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Abbrechen") { dismiss() } } }
        }
    }
}
