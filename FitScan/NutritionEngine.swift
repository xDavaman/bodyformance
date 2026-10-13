import Combine
import Foundation
import SwiftUI

// Ernährungs-Logik: Mahlzeiten-Slots, Tagestyp (Kraft / Lauf / Hybrid / Ruhe), Tempo, Tagesziele,
// Tagebuch (Kalorien, Protein, Fett, Kohlenhydrate, Salz, Wasser) und Tagesplaner.

enum MealSlot: String, CaseIterable, Identifiable, Codable {
    case breakfast = "Frühstück"
    case lunch = "Mittag"
    case dinner = "Abend"
    case snack = "Zwischenmahlzeit"
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .breakfast: return "sunrise"
        case .lunch: return "sun.max"
        case .dinner: return "moon.stars"
        case .snack: return "carrot"
        }
    }
    /// Anteil an den Tageskalorien
    var share: Double {
        switch self {
        case .breakfast: return 0.25
        case .lunch: return 0.30
        case .dinner: return 0.30
        case .snack: return 0.15
        }
    }
}

enum DayType: String, CaseIterable, Identifiable, Codable {
    case kraft = "Krafttag"
    case lauf = "Lauftag"
    case hybrid = "Hybridtag"
    case ruhe = "Ruhetag"
    var id: String { rawValue }

    var kcalAdjust: Double {
        switch self {
        case .kraft: return 0
        case .lauf: return 150
        case .hybrid: return 200
        case .ruhe: return -200
        }
    }
    var fatShare: Double {
        switch self {
        case .kraft: return 0.25
        case .lauf: return 0.22
        case .hybrid: return 0.24
        case .ruhe: return 0.30
        }
    }
    var waterBonusML: Double {
        switch self {
        case .kraft: return 500
        case .lauf, .hybrid: return 750
        case .ruhe: return 0
        }
    }
    /// Gewünschter Kohlenhydrat-Anteil der Kalorien je Mahlzeit (Abendessen immer eher kohlenhydratärmer)
    func carbShare(for slot: MealSlot) -> Double {
        switch (self, slot) {
        case (.lauf, .breakfast), (.hybrid, .breakfast): return 0.50
        case (.lauf, .lunch): return 0.58
        case (.hybrid, .lunch): return 0.52
        case (.lauf, .dinner), (.hybrid, .dinner): return 0.32
        case (.lauf, .snack), (.hybrid, .snack): return 0.45
        case (.kraft, .breakfast): return 0.40
        case (.kraft, .lunch): return 0.45
        case (.kraft, .dinner): return 0.30
        case (.kraft, .snack): return 0.40
        case (.ruhe, .breakfast), (.ruhe, .lunch), (.ruhe, .snack): return 0.25
        case (.ruhe, .dinner): return 0.15
        }
    }
    var note: String {
        switch self {
        case .kraft: return "Ausgewogen mit viel Eiweiß; Kohlenhydrate vor und nach dem Training."
        case .lauf: return "Mehr Kohlenhydrate vor und nach dem Lauf, weniger Fett."
        case .hybrid: return "Kraft und Laufen am selben Tag: viel Energie, viel Eiweiß, Kohlenhydrate rund ums Training."
        case .ruhe: return "Etwas weniger Kalorien und Kohlenhydrate, Eiweiß bleibt hoch, gesunde Fette dürfen mehr sein."
        }
    }
}

/// Wie schnell das Ziel erreicht werden soll. Ändert Kalorien, Trainingsumfang, Schrittziel und Wasser.
enum Pace: String, CaseIterable, Identifiable {
    case fast = "Schnell"
    case normal = "Normal"
    case slow = "Langsam"
    /// Kurz-Kur nur bei Diät: sehr großes Defizit, nur nach ausdrücklicher Bestätigung, nicht gesund auf Dauer
    case extreme = "Extrem"
    var id: String { rawValue }

    var deficit: Double {
        switch self {
        case .fast: return 750
        case .extreme: return 1000
        case .normal: return 500
        case .slow: return 300
        }
    }
    var surplus: Double {
        switch self {
        case .fast: return 400
        case .extreme: return 400
        case .normal: return 250
        case .slow: return 120
        }
    }
    var stepGoal: Int {
        switch self {
        case .fast, .extreme: return 12000
        case .normal: return 10000
        case .slow: return 8500
        }
    }
    func note(for goal: Goal) -> String {
        switch (goal, self) {
        case (.fatLoss, .fast): return "Schnell: großes Defizit (−750 kcal), ein Satz mehr pro Übung, 12 000 Schritte. Anstrengend; nicht länger als 8–12 Wochen am Stück."
        case (.fatLoss, .normal): return "Normal: moderates Defizit (−500 kcal), etwa 0,5 kg Fettverlust pro Woche, 10 000 Schritte."
        case (.fatLoss, .slow): return "Langsam: kleines Defizit (−300 kcal), schont Muskeln und Energie, ein Satz weniger, 8 500 Schritte."
        case (.fatLoss, .extreme): return "Extrem schnell: sehr großes Defizit (bis −1 000 kcal, nie unter Grundumsatz oder 1 500 kcal). Nicht gesund auf Dauer und kann deiner Gesundheit schaden: höchstens 4 Wochen, danach Pause, vorher mit der Ärztin oder dem Arzt sprechen."
        case (.muscle, .extreme): return "Extrem ist nur bei Diät verfügbar."
        case (.muscle, .fast): return "Schnell: größerer Überschuss (+400 kcal), ein Satz mehr pro Übung. Etwas mehr Fettzunahme möglich."
        case (.muscle, .normal): return "Normal: +250 kcal für sauberen Muskelaufbau."
        case (.muscle, .slow): return "Langsam: nur +120 kcal, sehr wenig Fettzunahme."
        case (.maintain, _): return "Beim Erhalt ändert das Tempo nur Trainingsumfang und Schrittziel."
        }
    }
}

struct DayTargets {
    var kcal: Int
    var protein: Int
    var fat: Int
    var carbs: Int
    var saltMax: Double = 6
    var waterML: Int
}

extension UserProfile {
    /// Standard-Tagestyp aus dem Zusatzsport
    var defaultDayType: DayType {
        switch sport {
        case .running: return .lauf
        case .hybrid: return .hybrid
        default: return .kraft
        }
    }

    func targets(for day: DayType) -> DayTargets {
        let kcal = max(1200, Double(targetCalories) + day.kcalAdjust)
        let protein = Double(proteinGrams)
        let fat = kcal * day.fatShare / 9
        let carbs = max(0, (kcal - protein * 4 - fat * 9) / 4)
        let water = ((weightKg * 35 + day.waterBonusML) / 50).rounded() * 50
        return DayTargets(kcal: Int(kcal.rounded()), protein: Int(protein.rounded()), fat: Int(fat.rounded()),
                          carbs: Int(carbs.rounded()), waterML: Int(water))
    }
}

// MARK: Tagebuch

struct Macros {
    var kcal = 0.0, protein = 0.0, fat = 0.0, carbs = 0.0, salt = 0.0, price = 0.0
    static func + (a: Macros, b: Macros) -> Macros {
        Macros(kcal: a.kcal + b.kcal, protein: a.protein + b.protein, fat: a.fat + b.fat,
               carbs: a.carbs + b.carbs, salt: a.salt + b.salt, price: a.price + b.price)
    }
}

struct LogEntry: Identifiable, Codable {
    var id = UUID()
    var day: String
    var slot: MealSlot
    var name: String
    var kcal: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var salt: Double
    var price: Double
    var macros: Macros { Macros(kcal: kcal, protein: protein, fat: fat, carbs: carbs, salt: salt, price: price) }
}

final class FoodLog: ObservableObject {
    @Published var entries: [LogEntry] = [] { didSet { save() } }
    @Published var water: [String: Int] = [:] { didSet { save() } }
    @Published var dayTypes: [String: String] = [:] { didSet { save() } }

    private let defaults = UserDefaults.standard

    init() {
        if let d = defaults.data(forKey: "foodLog.entries"), let e = try? JSONDecoder().decode([LogEntry].self, from: d) { entries = e }
        if let d = defaults.data(forKey: "foodLog.water"), let w = try? JSONDecoder().decode([String: Int].self, from: d) { water = w }
        if let d = defaults.data(forKey: "foodLog.dayTypes"), let t = try? JSONDecoder().decode([String: String].self, from: d) { dayTypes = t }
    }

    private func save() {
        // Nur die letzten 120 Tage behalten
        if let enc = try? JSONEncoder().encode(entries) { defaults.set(enc, forKey: "foodLog.entries") }
        if let enc = try? JSONEncoder().encode(water) { defaults.set(enc, forKey: "foodLog.water") }
        if let enc = try? JSONEncoder().encode(dayTypes) { defaults.set(enc, forKey: "foodLog.dayTypes") }
    }

    static func key(_ date: Date) -> String {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
    }

    func entries(day: Date, slot: MealSlot) -> [LogEntry] {
        let k = Self.key(day)
        return entries.filter { $0.day == k && $0.slot == slot }
    }

    func totals(day: Date) -> Macros {
        let k = Self.key(day)
        return entries.filter { $0.day == k }.reduce(Macros()) { $0 + $1.macros }
    }

    func add(day: Date, slot: MealSlot, recipe: Recipe, factor: Double) {
        entries.append(LogEntry(day: Self.key(day), slot: slot,
                                name: factor == 1 ? recipe.name : "\(recipe.name) (×\(Self.fmt(factor)))",
                                kcal: recipe.kcal * factor, protein: recipe.protein * factor, fat: recipe.fat * factor,
                                carbs: recipe.carbs * factor, salt: recipe.salt * factor, price: recipe.price * factor))
    }

    func addCustom(day: Date, slot: MealSlot, name: String, kcal: Double, protein: Double, fat: Double, carbs: Double) {
        entries.append(LogEntry(day: Self.key(day), slot: slot, name: name.isEmpty ? "Eigener Eintrag" : name,
                                kcal: kcal, protein: protein, fat: fat, carbs: carbs, salt: 0, price: 0))
    }

    func addFood(day: Date, slot: MealSlot, item: FoodItem, grams: Double) {
        let m = item.macros(grams: grams)
        entries.append(LogEntry(day: Self.key(day), slot: slot, name: "\(item.name) (\(Int(grams.rounded())) g)",
                                kcal: m.kcal, protein: m.protein, fat: m.fat, carbs: m.carbs, salt: m.salt, price: 0))
    }

    func remove(_ id: UUID) { entries.removeAll { $0.id == id } }

    func waterML(day: Date) -> Int { water[Self.key(day)] ?? 0 }
    func addWater(day: Date, ml: Int) {
        let k = Self.key(day)
        water[k] = max(0, (water[k] ?? 0) + ml)
    }

    func dayType(day: Date, fallback: DayType) -> DayType {
        dayTypes[Self.key(day)].flatMap { DayType(rawValue: $0) } ?? fallback
    }
    func setDayType(day: Date, _ t: DayType) { dayTypes[Self.key(day)] = t.rawValue }

    static func fmt(_ v: Double) -> String {
        v == v.rounded() ? String(Int(v)) : String(format: "%.2f", v).replacingOccurrences(of: ".00", with: "")
    }
}

// MARK: Tagesplaner

struct PlannedMeal {
    let recipe: Recipe
    /// Portionsfaktor, damit die Mahlzeit zum Kalorienziel des Slots passt
    let factor: Double
    var kcal: Double { recipe.kcal * factor }
    var protein: Double { recipe.protein * factor }
    var fat: Double { recipe.fat * factor }
    var carbs: Double { recipe.carbs * factor }
    var price: Double { recipe.price * factor }
}

enum DayPlanner {
    /// Wählt je Mahlzeit ein Rezept, das zu Tagestyp, Kochzeit, Meal Prep und Ernährungsform passt.
    /// `shuffle` verschiebt die Auswahl (Button „anderes Rezept“).
    static func plan(day: Date, type: DayType, targets: DayTargets, maxMinutes: Int?, mealPrep: Bool,
                     vegetarian: Bool, shuffle: [MealSlot: Int], recipes: [Recipe] = RecipeLibrary.all) -> [MealSlot: PlannedMeal] {
        var result: [MealSlot: PlannedMeal] = [:]
        let ordinal = Calendar.current.ordinality(of: .day, in: .era, for: day) ?? 0
        let wantProteinShare = min(0.45, max(0.2, Double(targets.protein) * 4 / Double(max(1, targets.kcal))))
        var usedToday = Set<String>()

        for (si, slot) in MealSlot.allCases.enumerated() {
            var pool = recipes.filter { $0.slots.contains(slot) }
            if vegetarian { pool = pool.filter { $0.vegetarian } }
            if let m = maxMinutes {
                let fast = pool.filter { $0.minutes <= m }
                if !fast.isEmpty { pool = fast }
            }
            let prepSlot = (slot == .lunch || slot == .dinner)
            if mealPrep && prepSlot {
                let p = pool.filter { $0.isMealPrep }
                if !p.isEmpty { pool = p }
            }
            let wantCarb = type.carbShare(for: slot)
            var scored = pool.map { rec -> (Recipe, Double) in
                let s = abs(rec.carbShare - wantCarb) + max(0, wantProteinShare - rec.proteinShare) * 1.2
                return (rec, s)
            }
            scored.sort { $0.1 == $1.1 ? $0.0.name < $1.0.name : $0.1 < $1.1 }
            var top = Array(scored.prefix(5)).map { $0.0 }
            top.removeAll { usedToday.contains($0.id) }
            if top.isEmpty { top = Array(scored.prefix(5)).map { $0.0 } }
            guard !top.isEmpty else { continue }

            // Meal Prep: gleiches Gericht für 3 Tage in Folge
            let seedDay = (mealPrep && prepSlot) ? ordinal / 3 : ordinal
            let h = (seedDay &* 1103515245 &+ 12345 &+ si &* 7919 &+ (shuffle[slot] ?? 0) &* 104729) & 0x7fffffff
            let rec = top[h % top.count]
            usedToday.insert(rec.id)

            let target = Double(targets.kcal) * slot.share
            let raw = target / max(1, rec.kcal)
            let factor = min(2.0, max(0.5, (raw * 4).rounded() / 4))
            result[slot] = PlannedMeal(recipe: rec, factor: factor)
        }
        return result
    }
}
