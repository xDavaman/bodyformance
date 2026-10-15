import PhotosUI
import SwiftUI
import UIKit
import Vision
import VisionKit

// Lebensmittel außerhalb der Rezepte erfassen: Barcode scannen (Open Food Facts), Foto-Vorschlag (Apple Vision),
// Suche in der Grundnahrungsmittel-Datenbank oder selbst anlegen. Danach Menge eingeben und ins Tagebuch eintragen.

private func g0(_ v: Double) -> String { String(Int(v.rounded())) }
private func g1(_ v: Double) -> String { String(format: "%.1f", v) }

// MARK: Open Food Facts

enum OpenFoodFacts {
    static func lookup(_ code: String) async -> FoodItem? {
        let clean = code.filter(\.isNumber)
        guard clean.count >= 6,
              let url = URL(string: "https://world.openfoodfacts.org/api/v2/product/\(clean).json?fields=product_name,brands,nutriments,serving_quantity") else { return nil }
        var req = URLRequest(url: url)
        req.setValue("Bodyformance/1.0 (iOS Fitness App)", forHTTPHeaderField: "User-Agent")
        req.timeoutInterval = 15
        guard let (data, _) = try? await URLSession.shared.data(for: req),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let product = root["product"] as? [String: Any] else { return nil }
        return item(from: product, code: clean)
    }

    /// Freitextsuche (Produktname oder Marke, z. B. „ESN Designer Whey“)
    static func search(_ query: String, page: Int = 1) async -> [FoodItem] {
        guard var comps = URLComponents(string: "https://world.openfoodfacts.org/cgi/search.pl") else { return [] }
        comps.queryItems = [
            URLQueryItem(name: "search_terms", value: query),
            URLQueryItem(name: "search_simple", value: "1"),
            URLQueryItem(name: "action", value: "process"),
            URLQueryItem(name: "json", value: "1"),
            URLQueryItem(name: "page_size", value: "25"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "sort_by", value: "unique_scans_n"),
            URLQueryItem(name: "fields", value: "code,product_name,brands,nutriments,serving_quantity")
        ]
        guard let url = comps.url else { return [] }
        var req = URLRequest(url: url)
        req.setValue("Bodyformance/1.0 (iOS Fitness App)", forHTTPHeaderField: "User-Agent")
        req.timeoutInterval = 20
        guard let (data, _) = try? await URLSession.shared.data(for: req),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let products = root["products"] as? [[String: Any]] else { return [] }
        return products.compactMap { p in
            guard let code = p["code"] as? String else { return nil }
            return item(from: p, code: code)
        }
    }

    private static func item(from product: [String: Any], code clean: String) -> FoodItem? {
        let n = product["nutriments"] as? [String: Any] ?? [:]
        func num(_ key: String) -> Double? {
            if let v = n[key] as? NSNumber { return v.doubleValue }
            if let s = n[key] as? String { return Double(s) }
            return nil
        }
        var kcal = num("energy-kcal_100g")
        if kcal == nil, let kj = num("energy_100g") { kcal = kj / 4.184 }
        guard let k = kcal else { return nil }
        let salt = num("salt_100g") ?? (num("sodium_100g").map { $0 * 2.5 } ?? 0)
        var serving: Double = 100
        if let s = product["serving_quantity"] as? NSNumber, s.doubleValue > 0 { serving = s.doubleValue }
        else if let s = product["serving_quantity"] as? String, let v = Double(s), v > 0 { serving = v }
        let name = (product["product_name"] as? String).flatMap { $0.isEmpty ? nil : $0 } ?? "Produkt \(clean)"
        let brand = (product["brands"] as? String)?.components(separatedBy: ",").first ?? ""
        return FoodItem(id: "ean-\(clean)", name: name, brand: brand, kcal: k, protein: num("proteins_100g") ?? 0,
                        fat: num("fat_100g") ?? 0, carbs: num("carbohydrates_100g") ?? 0, sugar: num("sugars_100g") ?? 0,
                        salt: salt, defaultGrams: serving, barcode: clean)
    }
}

/// Online-Suche nach Produkten und Marken (Open Food Facts, Millionen Produkte), startet automatisch beim Tippen
struct OnlineFoodSearch: View {
    let query: String
    var onPick: (FoodItem) -> Void
    @State private var results: [FoodItem] = []
    @State private var busy = false
    @State private var searchedFor = ""
    @State private var page = 1
    @State private var more = false

    private var q: String { query.trimmingCharacters(in: .whitespaces) }

    var body: some View {
        if q.count >= 3 {
            Section {
                if busy && results.isEmpty { HStack { ProgressView(); Text("Suche in Millionen Produkten …").foregroundStyle(.secondary) } }
                if !busy && searchedFor == q && results.isEmpty {
                    Text("Online nichts gefunden oder keine Internetverbindung. Versuche einen kürzeren Begriff, scanne den Barcode oder lege das Produkt selbst an.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                ForEach(results) { f in
                    Button { onPick(f) } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(f.brand.isEmpty ? f.name : "\(f.name) · \(f.brand)").foregroundStyle(.primary)
                            Text("\(g0(f.kcal)) kcal · \(g0(f.protein)) g Eiweiß · \(g0(f.carbs)) g KH · \(g0(f.fat)) g Fett (je 100 g)")
                                .font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
                if more && !busy {
                    Button { Task { await load(page: page + 1) } } label: { Label("Mehr Treffer laden", systemImage: "arrow.down.circle") }
                }
                if busy && !results.isEmpty { ProgressView() }
            } header: {
                Text("Online (Open Food Facts)")
            } footer: {
                Text("Produkte aller Hersteller, auch ESN, MORE Nutrition, Myprotein, Barebells und Supermarkt-Marken. Die Werte sind von Nutzern eingetragen, bei Pulvern bitte mit der Packung vergleichen.")
            }
            .task(id: q) {
                results = []; searchedFor = ""; page = 1; more = false
                try? await Task.sleep(nanoseconds: 700_000_000)
                if Task.isCancelled { return }
                await load(page: 1)
            }
        }
    }

    private func load(page p: Int) async {
        busy = true
        let r = await OpenFoodFacts.search(q, page: p)
        if Task.isCancelled { busy = false; return }
        let known = Set(results.map(\.id))
        results += r.filter { !known.contains($0.id) }
        page = p
        more = r.count >= 20
        searchedFor = q
        busy = false
    }
}

// MARK: Foto -> Vorschläge

enum FoodVision {
    /// Gibt deutsche Suchbegriffe zurück, die zu dem erkannten Essen passen (nur Vorschläge, keine Garantie).
    static func suggestions(for image: UIImage) async -> [String] {
        guard let cg = image.cgImage else { return [] }
        return await withCheckedContinuation { cont in
            DispatchQueue.global(qos: .userInitiated).async {
                let request = VNClassifyImageRequest()
                let handler = VNImageRequestHandler(cgImage: cg, options: [:])
                try? handler.perform([request])
                var terms: [String] = []
                for o in (request.results ?? []).prefix(40) where o.confidence > 0.06 {
                    let id = o.identifier.lowercased().replacingOccurrences(of: " ", with: "_")
                    if let t = FoodDB.visionMap[id], !terms.contains(t) { terms.append(t) }
                }
                cont.resume(returning: Array(terms.prefix(6)))
            }
        }
    }
}

// MARK: Kamera

struct BarcodeScannerView: UIViewControllerRepresentable {
    var active: Bool = true
    var onCode: (String) -> Void

    static var supported: Bool { DataScannerViewController.isSupported && DataScannerViewController.isAvailable }

    func makeCoordinator() -> Coordinator { Coordinator(onCode: onCode) }

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(recognizedDataTypes: [.barcode(symbologies: [.ean13, .ean8, .upce])],
                                           qualityLevel: .balanced, recognizesMultipleItems: false,
                                           isHighFrameRateTrackingEnabled: false, isPinchToZoomEnabled: true,
                                           isGuidanceEnabled: true, isHighlightingEnabled: true)
        vc.delegate = context.coordinator
        context.coordinator.start(vc)
        return vc
    }

    func updateUIViewController(_ vc: DataScannerViewController, context: Context) {
        context.coordinator.onCode = onCode
        if active { if !vc.isScanning { context.coordinator.start(vc) } }
        else if vc.isScanning { vc.stopScanning() }
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var onCode: (String) -> Void
        private var done = false
        init(onCode: @escaping (String) -> Void) { self.onCode = onCode }
        /// Startet die Kamera neu (auch nach einem früheren Treffer); bei Fehlschlag ein zweiter Versuch.
        func start(_ vc: DataScannerViewController, attempt: Int = 0) {
            done = false
            DispatchQueue.main.async {
                do { try vc.startScanning() }
                catch {
                    if attempt < 3 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { self.start(vc, attempt: attempt + 1) }
                    }
                }
            }
        }
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            guard !done else { return }
            for item in addedItems {
                if case .barcode(let b) = item, let code = b.payloadStringValue {
                    done = true
                    dataScanner.stopScanning()
                    onCode(code)
                    return
                }
            }
        }
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    var onImage: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let p = UIImagePickerController()
        p.sourceType = .camera
        p.delegate = context.coordinator
        return p
    }
    func updateUIViewController(_ vc: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ p: CameraPicker) { parent = p }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let img = info[.originalImage] as? UIImage { parent.onImage(img) }
            parent.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { parent.dismiss() }
    }
}

// MARK: Hinzufügen

struct FoodAddSheet: View {
    let slot: MealSlot
    let day: Date
    @EnvironmentObject var store: FoodStore
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var showScanner = false
    @State private var showCamera = false
    @State private var photoItem: PhotosPickerItem?
    @State private var selected: FoodItem?
    @State private var manualCode = ""
    @State private var status = ""
    @State private var busy = false
    @State private var terms: [String] = []
    @State private var showCustom = false
    @State private var customCode: String?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button { showScanner = true } label: { Label("Barcode scannen", systemImage: "barcode.viewfinder") }
                    HStack {
                        TextField("Oder Barcode eintippen", text: $manualCode).keyboardType(.numberPad)
                        Button("Suchen") { Task { await lookup(manualCode) } }
                            .buttonStyle(.borderless).disabled(manualCode.filter(\.isNumber).count < 6 || busy)
                    }
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        Button { showCamera = true } label: { Label("Essen fotografieren (Vorschläge)", systemImage: "camera") }
                    }
                    PhotosPicker(selection: $photoItem, matching: .images) { Label("Foto aus Mediathek (Vorschläge)", systemImage: "photo") }
                    if busy { HStack { ProgressView(); Text("Einen Moment …").foregroundStyle(.secondary) } }
                    if !status.isEmpty { Text(status).font(.footnote).foregroundStyle(.secondary) }
                } header: {
                    Text("Erfassen für \(slot.rawValue)")
                } footer: {
                    Text("Der Barcode liefert die genauesten Werte (Daten von Open Food Facts, braucht Internet). Die Foto-Erkennung macht nur Vorschläge, bitte prüfen.")
                }

                if !terms.isEmpty {
                    Section("Vorschläge vom Foto") {
                        ForEach(terms, id: \.self) { t in
                            Button { query = t } label: { Label(t, systemImage: "sparkles") }
                        }
                    }
                }

                if query.isEmpty {
                    if !store.recents.isEmpty {
                        Section("Zuletzt benutzt") { ForEach(store.recents) { row($0) } }
                    }
                    if !store.saved.isEmpty {
                        Section("Meine Produkte") {
                            ForEach(store.saved) { row($0) }
                                .onDelete { idx in idx.map { store.saved[$0] }.forEach { store.delete($0) } }
                        }
                    }
                    Section("Beliebt") { ForEach(FoodDB.basics.prefix(12)) { row($0) } }
                } else {
                    let found = store.search(query)
                    Section("\(found.count) Treffer") {
                        ForEach(found) { row($0) }
                        Button { customCode = nil; showCustom = true } label: { Label("„\(query)“ selbst anlegen", systemImage: "plus") }
                    }
                    OnlineFoodSearch(query: query) { item in store.remember(item); selected = item }
                }

                Section {
                    Button { customCode = nil; showCustom = true } label: { Label("Eigenes Lebensmittel anlegen", systemImage: "square.and.pencil") }
                }
            }
            .searchable(text: $query, prompt: "Lebensmittel suchen, z. B. Magerquark")
            .navigationTitle("Lebensmittel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Schließen") { dismiss() } } }
            .sheet(isPresented: $showScanner) { scannerSheet }
            .sheet(isPresented: $showCamera) { CameraPicker { img in Task { await classify(img) } } }
            .sheet(item: $selected) { item in
                FoodAmountSheet(item: item, slot: slot, day: day) { dismiss() }
            }
            .sheet(isPresented: $showCustom) {
                CustomFoodSheet(name: query, barcode: customCode) { item in
                    store.remember(item)
                    // erst öffnen, wenn das Anlegen-Blatt ganz zu ist – sonst verwirft SwiftUI das zweite Blatt
                    Task { try? await Task.sleep(for: .milliseconds(450)); selected = item }
                }
            }
            .onChange(of: photoItem) { _, item in
                guard let item else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self), let img = UIImage(data: data) { await classify(img) }
                    photoItem = nil
                }
            }
        }
    }

    private func row(_ f: FoodItem) -> some View {
        Button { selected = f } label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(f.brand.isEmpty ? f.name : "\(f.name) · \(f.brand)").foregroundStyle(.primary)
                Text("\(g0(f.kcal)) kcal · \(g0(f.protein)) g Eiweiß · \(g0(f.carbs)) g KH · \(g0(f.fat)) g Fett (je 100 g)")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder private var scannerSheet: some View {
        NavigationStack {
            Group {
                if BarcodeScannerView.supported {
                    BarcodeScannerView { code in
                        showScanner = false
                        Task { try? await Task.sleep(for: .milliseconds(450)); await lookup(code) }
                    }
                    .ignoresSafeArea()
                } else {
                    ContentUnavailableView("Scanner nicht verfügbar", systemImage: "barcode.viewfinder",
                                           description: Text("Der Barcode-Scanner läuft nur auf einem iPhone mit Kamera. Du kannst den Barcode auch eintippen oder das Lebensmittel suchen."))
                }
            }
            .navigationTitle("Barcode scannen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Abbrechen") { showScanner = false } } }
        }
    }

    private func lookup(_ raw: String) async {
        let code = raw.filter(\.isNumber)
        if let known = store.saved.first(where: { $0.barcode == code }) { selected = known; return }
        busy = true; status = ""
        let item = await OpenFoodFacts.lookup(code)
        busy = false
        if let item {
            store.remember(item)
            selected = item
            manualCode = ""
        } else {
            status = "Barcode \(code) nicht gefunden oder ohne Nährwerte (oder keine Internetverbindung). Lege das Produkt selbst an, dann ist es beim nächsten Scan sofort da."
            customCode = code
            showCustom = true
        }
    }

    private func classify(_ img: UIImage) async {
        busy = true; status = ""; terms = []
        let t = await FoodVision.suggestions(for: img)
        busy = false
        terms = t
        status = t.isEmpty ? "Auf dem Foto habe ich nichts Eindeutiges erkannt. Bitte suche das Lebensmittel oder scanne den Barcode." : "Tippe auf einen Vorschlag und prüfe, ob er passt."
    }
}

// MARK: Menge wählen

struct FoodAmountSheet: View {
    let item: FoodItem
    let slot: MealSlot
    let day: Date
    var onAdded: () -> Void
    @EnvironmentObject var log: FoodLog
    @EnvironmentObject var store: FoodStore
    @Environment(\.dismiss) private var dismiss
    @State private var gramsText: String

    init(item: FoodItem, slot: MealSlot, day: Date, onAdded: @escaping () -> Void) {
        self.item = item; self.slot = slot; self.day = day; self.onAdded = onAdded
        _gramsText = State(initialValue: String(Int(item.defaultGrams.rounded())))
    }

    /// Menge in Gramm; unsinnige Eingaben (zu groß, „nan“) werden begrenzt, damit Int(…) nicht abstürzt
    private var grams: Double {
        let v = Double(gramsText.replacingOccurrences(of: ",", with: ".")) ?? 0
        return v.isFinite ? min(max(v, 0), 10_000) : 0
    }
    private var m: Macros { item.macros(grams: grams) }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(item.brand.isEmpty ? item.name : "\(item.name) · \(item.brand)").font(.headline)
                    HStack {
                        Text("Menge")
                        Spacer()
                        TextField("g", text: $gramsText).keyboardType(.decimalPad).multilineTextAlignment(.trailing).frame(width: 90)
                        Text("g")
                    }
                    Stepper("± 10 g", onIncrement: { gramsText = String(Int(grams + 10)) },
                            onDecrement: { gramsText = String(Int(max(0, grams - 10))) })
                    if let pg = item.pieceGrams, let pn = item.pieceName {
                        Stepper("Stückzahl: \(g1(grams / pg)) \(pn)", onIncrement: { gramsText = String(Int(((grams / pg).rounded() + 1) * pg)) },
                                onDecrement: { gramsText = String(Int(max(1, (grams / pg).rounded() - 1) * pg)) })
                    }
                }
                Section("Nährwerte für \(g0(grams)) g") {
                    LabeledContent("Kalorien", value: "\(g0(m.kcal)) kcal")
                    LabeledContent("Eiweiß", value: "\(g1(m.protein)) g")
                    LabeledContent("Kohlenhydrate", value: "\(g1(m.carbs)) g")
                    LabeledContent("davon Zucker", value: "\(g1(item.sugar * grams / 100)) g")
                    LabeledContent("Fett", value: "\(g1(m.fat)) g")
                    LabeledContent("Salz", value: "\(g1(m.salt)) g")
                }
                Section {
                    Button {
                        log.addFood(day: day, slot: slot, item: item, grams: grams)
                        store.remember(item)
                        dismiss()
                        onAdded()
                    } label: { Label("In \(slot.rawValue) eintragen", systemImage: "plus.circle.fill").frame(maxWidth: .infinity) }
                        .disabled(grams <= 0)
                }
            }
            .navigationTitle("Menge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Abbrechen") { dismiss() } } }
        }
        .presentationDetents([.large])
    }
}

// MARK: Eigenes Lebensmittel

struct CustomFoodSheet: View {
    @State var name: String
    let barcode: String?
    var onSave: (FoodItem) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var kcal = ""
    @State private var protein = ""
    @State private var fat = ""
    @State private var carbs = ""
    @State private var sugar = ""
    @State private var salt = ""
    @State private var serving = "100"

    init(name: String, barcode: String?, onSave: @escaping (FoodItem) -> Void) {
        _name = State(initialValue: name)
        self.barcode = barcode
        self.onSave = onSave
    }

    private func num(_ s: String) -> Double { Double(s.replacingOccurrences(of: ",", with: ".")) ?? 0 }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name (z. B. Magerquark)", text: $name)
                    if let b = barcode { LabeledContent("Barcode", value: b) }
                } footer: { Text("Nährwerte stehen auf der Packung, immer je 100 g.") }
                Section("Nährwerte je 100 g") {
                    field("Kalorien (kcal)", $kcal)
                    field("Eiweiß (g)", $protein)
                    field("Kohlenhydrate (g)", $carbs)
                    field("davon Zucker (g)", $sugar)
                    field("Fett (g)", $fat)
                    field("Salz (g)", $salt)
                }
                Section("Übliche Menge") { field("Gramm pro Portion / Packung", $serving) }
            }
            .navigationTitle("Eigenes Lebensmittel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Abbrechen") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        let item = FoodItem(id: barcode.map { "ean-\($0)" } ?? "own-\(UUID().uuidString)",
                                            name: name.isEmpty ? "Eigenes Lebensmittel" : name, kcal: num(kcal), protein: num(protein),
                                            fat: num(fat), carbs: num(carbs), sugar: num(sugar), salt: num(salt),
                                            defaultGrams: max(1, num(serving)), barcode: barcode)
                        dismiss()
                        onSave(item)
                    }
                    .disabled(num(kcal) <= 0)
                }
            }
        }
    }

    private func field(_ title: String, _ binding: Binding<String>) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField("0", text: binding).keyboardType(.decimalPad).multilineTextAlignment(.trailing).frame(width: 90)
        }
    }
}
