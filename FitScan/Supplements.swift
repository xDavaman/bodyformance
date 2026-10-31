import Combine
import SwiftUI

// MARK: - Supplements und Mittel

struct SupplementEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var name: String
    var amount: Double
    var unit: String
}

/// Eigene Liste für das schnelle Abhaken („heute genommen“)
struct SupplementFavorite: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var amount: Double
    var unit: String
}

/// Häufige Supplements mit üblicher Tagesmenge (nur zum Vorausfüllen)
enum SupplementPreset: String, CaseIterable, Identifiable {
    case creatine = "Kreatin (Monohydrat)"
    case whey = "Proteinpulver"
    case caffeine = "Koffein"
    case vitaminD = "Vitamin D3"
    case omega3 = "Omega-3"
    case magnesium = "Magnesium"
    case zinc = "Zink"
    case betaAlanine = "Beta-Alanin"
    case citrulline = "Citrullin"
    case electrolytes = "Elektrolyte"
    var id: String { rawValue }

    var amount: Double {
        switch self {
        case .creatine: return 5
        case .whey: return 30
        case .caffeine: return 200
        case .vitaminD: return 2000
        case .omega3: return 1000
        case .magnesium: return 300
        case .zinc: return 10
        case .betaAlanine: return 3.2
        case .citrulline: return 6
        case .electrolytes: return 1
        }
    }

    var unit: String {
        switch self {
        case .creatine, .whey, .betaAlanine, .citrulline, .electrolytes: return "g"
        case .caffeine, .omega3, .magnesium, .zinc: return "mg"
        case .vitaminD: return "IE"
        }
    }

    var note: String {
        switch self {
        case .creatine: return "Gut untersucht für Kraft und Muskelaufbau. Täglich 3–5 g, auch an trainingsfreien Tagen; nach etwa 3–4 Wochen sind die Speicher voll."
        case .whey: return "Zählt als Eiweiß. Auf Wunsch trägt die App es zusätzlich ins Ernährungstagebuch ein."
        case .caffeine: return "Etwa 3 mg pro kg Körpergewicht 30–60 Minuten vor dem Training. Spät am Tag stört es den Schlaf."
        case .vitaminD: return "Sinnvoll vor allem im Winter. Am besten den Blutwert ärztlich prüfen lassen."
        case .omega3: return "EPA und DHA, z. B. aus Fischöl oder Algenöl."
        case .magnesium: return "Bei viel Schwitzen oder Krämpfen; abends genommen bei manchen gut für den Schlaf."
        case .zinc: return "Nur bei Bedarf, nicht dauerhaft hoch dosieren."
        case .betaAlanine: return "Für intensive Belastungen von 1–4 Minuten. Kribbeln ist harmlos."
        case .citrulline: return "Vor dem Training für mehr Pump und Ausdauer im Satz."
        case .electrolytes: return "Bei langen oder heißen Einheiten."
        }
    }

    /// Erkennung von Kreatin in frei eingegebenen Namen
    static func isCreatine(_ name: String) -> Bool {
        let n = name.lowercased()
        return n.contains("kreatin") || n.contains("creatin")
    }

    static func isProteinPowder(_ name: String) -> Bool {
        let n = name.lowercased()
        return n.contains("protein") || n.contains("whey") || n.contains("casein")
    }
}

/// Speichert eingenommene Supplements dauerhaft als JSON im App-Ordner (supplements.json, im Backup enthalten).
final class SupplementStore: ObservableObject {
    @Published private(set) var entries: [SupplementEntry] = []
    @Published private(set) var favorites: [SupplementFavorite] = []

    static let fileName = "supplements.json"
    private let fileURL: URL

    private struct Payload: Codable {
        var entries: [SupplementEntry]
        var favorites: [SupplementFavorite]
    }

    init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = dir.appendingPathComponent(Self.fileName)
        if let d = try? Data(contentsOf: fileURL), let p = try? JSONDecoder().decode(Payload.self, from: d) {
            entries = p.entries
            favorites = p.favorites
        }
    }

    private func save() {
        if let d = try? JSONEncoder().encode(Payload(entries: entries, favorites: favorites)) {
            try? d.write(to: fileURL, options: .atomic)
        }
    }

    func add(name: String, amount: Double, unit: String, date: Date = Date()) {
        let n = name.trimmingCharacters(in: .whitespaces)
        guard !n.isEmpty, amount > 0 else { return }
        entries.append(SupplementEntry(date: date, name: n, amount: amount, unit: unit))
        entries.sort { $0.date < $1.date }
        save()
    }

    func remove(_ e: SupplementEntry) {
        entries.removeAll { $0.id == e.id }
        save()
    }

    func addFavorite(name: String, amount: Double, unit: String) {
        guard !favorites.contains(where: { $0.name == name }) else { return }
        favorites.append(SupplementFavorite(name: name, amount: amount, unit: unit))
        save()
    }

    func removeFavorite(_ f: SupplementFavorite) {
        favorites.removeAll { $0.id == f.id }
        save()
    }

    func entries(from: Date, to: Date) -> [SupplementEntry] {
        entries.filter { $0.date >= from && $0.date < to }
    }

    func taken(_ name: String, on day: Date) -> Double {
        entries.filter { $0.name == name && Calendar.current.isDate($0.date, inSameDayAs: day) }.map(\.amount).reduce(0, +)
    }
}

/// Auswertung über einen Zeitraum
struct SupplementSummary: Identifiable {
    var id: String { name + unit }
    let name: String
    let unit: String
    let days: Int
    let total: Double
    var perTakenDay: Double { days > 0 ? total / Double(days) : 0 }

    static func make(_ list: [SupplementEntry]) -> [SupplementSummary] {
        let groups = Dictionary(grouping: list) { $0.name + "\u{1}" + $0.unit }
        return groups.values.compactMap { items -> SupplementSummary? in
            guard let f = items.first else { return nil }
            let days = Set(items.map { Calendar.current.startOfDay(for: $0.date) }).count
            return SupplementSummary(name: f.name, unit: f.unit, days: days, total: items.map(\.amount).reduce(0, +))
        }
        .sorted { $0.name < $1.name }
    }

    /// Einschätzung, ob die Kreatinspeicher voll sind (Faustregel: ≥ 3 g an 21 der letzten 28 Tage,
    /// oder Ladephase mit ≥ 15 g an 5 Tagen und danach weiter genommen)
    static func creatineStatus(_ list: [SupplementEntry], until end: Date = Date()) -> String? {
        let cal = Calendar.current
        let creatine = list.filter { SupplementPreset.isCreatine($0.name) && $0.unit == "g" && $0.date < end }
        guard !creatine.isEmpty else { return nil }
        var perDay: [Date: Double] = [:]
        for e in creatine { perDay[cal.startOfDay(for: e.date), default: 0] += e.amount }
        let endDay = cal.startOfDay(for: end)
        let last28 = (0..<28).compactMap { cal.date(byAdding: .day, value: -$0, to: endDay) }
        let covered = last28.filter { (perDay[$0] ?? 0) >= 3 }.count
        let loading = last28.filter { (perDay[$0] ?? 0) >= 15 }.count
        let last7 = last28.prefix(7).filter { (perDay[$0] ?? 0) >= 3 }.count
        if covered >= 21 || (loading >= 5 && last7 >= 5) {
            return "Kreatin: an \(covered) der letzten 28 Tage genommen. Die Speicher sind sehr wahrscheinlich voll."
        }
        if covered == 0 {
            return "Kreatin: in den letzten 28 Tagen nicht genommen. Die Speicher leeren sich nach etwa 4–6 Wochen."
        }
        return "Kreatin: an \(covered) der letzten 28 Tage genommen. Für volle Speicher täglich 3–5 g, auch an Ruhetagen."
    }
}

func amountText(_ v: Double) -> String {
    v.formatted(.number.precision(.fractionLength(0...2)))
}

// MARK: - Ansicht

struct SupplementsView: View {
    @EnvironmentObject var supplements: SupplementStore
    @EnvironmentObject var log: FoodLog
    @EnvironmentObject var profile: UserProfile

    @State private var preset: SupplementPreset? = .creatine
    @State private var name = ""
    @State private var amount = "5"
    @State private var unit = "g"
    @State private var date = Date()
    @State private var asProtein = true
    @State private var keep = true

    private let units = ["g", "mg", "µg", "IE", "ml", "Stück"]

    var body: some View {
        let month = supplements.entries(from: Date().addingTimeInterval(-30 * 86_400), to: Date().addingTimeInterval(1))
        List {
            if !supplements.favorites.isEmpty {
                Section {
                    ForEach(supplements.favorites) { f in
                        let today = supplements.taken(f.name, on: Date())
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(f.name)
                                Text(today > 0 ? "Heute: \(amountText(today)) \(f.unit)" : "Heute noch nicht")
                                    .font(.caption).foregroundStyle(today > 0 ? Color.green : Color.secondary)
                            }
                            Spacer()
                            Button("+ \(amountText(f.amount)) \(f.unit)") { take(f.name, f.amount, f.unit, Date()) }
                                .buttonStyle(.bordered)
                        }
                    }
                    .onDelete { idx in idx.map { supplements.favorites[$0] }.forEach(supplements.removeFavorite) }
                } header: {
                    Text("Heute abhaken")
                }
            }

            Section {
                Picker("Mittel", selection: $preset) {
                    ForEach(SupplementPreset.allCases) { Text($0.rawValue).tag(SupplementPreset?.some($0)) }
                    Text("Eigenes eingeben").tag(SupplementPreset?.none)
                }
                if preset == nil {
                    TextField("Name (z. B. Präparat oder Medikament)", text: $name)
                }
                HStack {
                    TextField("Menge", text: $amount).keyboardType(.decimalPad)
                    Picker("Einheit", selection: $unit) { ForEach(units, id: \.self) { Text($0) } }
                        .labelsHidden()
                }
                DatePicker("Zeitpunkt", selection: $date, in: ...Date())
                if isProtein {
                    Toggle("Als Eiweiß ins Ernährungstagebuch", isOn: $asProtein)
                }
                Toggle("Zu „Heute abhaken“ hinzufügen", isOn: $keep)
                Button {
                    take(currentName, number(amount), unit, date)
                    if keep { supplements.addFavorite(name: currentName, amount: number(amount), unit: unit) }
                } label: { Label("Eintragen", systemImage: "plus.circle.fill") }
                .disabled(currentName.isEmpty || number(amount) <= 0)
                if let p = preset {
                    Text(p.note).font(.footnote).foregroundStyle(.secondary)
                }
            } header: {
                Text("Eintragen")
            } footer: {
                Text("Die App protokolliert nur und gibt keine Dosierempfehlung für Medikamente, Hormone oder anabole Substanzen. So etwas gehört in ärztliche Begleitung. Eingetragenes fließt in den Monatsbericht ein.")
            }

            let summary = SupplementSummary.make(month)
            if !summary.isEmpty {
                Section("Letzte 30 Tage") {
                    if let c = SupplementSummary.creatineStatus(supplements.entries) {
                        Label(c, systemImage: "bolt.fill").font(.footnote)
                    }
                    ForEach(summary) { s in
                        LabeledContent(s.name, value: "\(amountText(s.total)) \(s.unit) an \(s.days) Tagen (Ø \(amountText(s.perTakenDay)) \(s.unit))")
                    }
                }
            }

            let recent = Array(supplements.entries.suffix(40).reversed())
            if !recent.isEmpty {
                Section("Verlauf") {
                    ForEach(recent) { e in
                        HStack {
                            Text(e.date, format: .dateTime.day().month().hour().minute()).foregroundStyle(.secondary)
                            Spacer()
                            Text("\(e.name) · \(amountText(e.amount)) \(e.unit)")
                        }
                        .font(.footnote)
                    }
                    .onDelete { idx in idx.map { recent[$0] }.forEach(supplements.remove) }
                }
            }
        }
        .navigationTitle("Supplements")
        .onChange(of: preset) { _, p in
            if let p { amount = amountText(p.amount); unit = p.unit }
        }
    }

    private var currentName: String {
        preset?.rawValue ?? name.trimmingCharacters(in: .whitespaces)
    }

    private var isProtein: Bool { SupplementPreset.isProteinPowder(currentName) && unit == "g" }

    private func number(_ s: String) -> Double { Double(s.replacingOccurrences(of: ",", with: ".")) ?? 0 }

    private func take(_ name: String, _ amount: Double, _ unit: String, _ when: Date) {
        supplements.add(name: name, amount: amount, unit: unit, date: when)
        // Proteinpulver: grob 80 % Eiweiß, je 7 % Fett und Kohlenhydrate
        if SupplementPreset.isProteinPowder(name) && unit == "g" && asProtein {
            log.addCustom(day: when, slot: FoodScanTab.defaultSlot(), name: "\(name) (\(amountText(amount)) g)",
                          kcal: amount * 3.9, protein: amount * 0.8, fat: amount * 0.07, carbs: amount * 0.07)
        }
    }
}
