import SwiftUI

enum Muscle: String, CaseIterable, Identifiable, Codable {
    case chest = "Brust", lats = "Latissimus", traps = "Trapez / oberer Rücken"
    case shoulders = "Schultern", biceps = "Bizeps", triceps = "Trizeps", forearms = "Unterarme"
    case abs = "Bauch", lowerBack = "Unterer Rücken"
    case glutes = "Gesäß", quads = "Oberschenkel vorne", hamstrings = "Beinbeuger"
    case adductors = "Adduktoren", hipFlexors = "Hüftbeuger", calves = "Waden", neck = "Nacken"
    var id: String { rawValue }

    /// Muskeln, die man hauptsächlich von hinten sieht.
    var isBackSide: Bool {
        [.lats, .traps, .triceps, .lowerBack, .glutes, .hamstrings, .calves, .neck].contains(self)
    }
    /// Muskeln, die als Schwerpunkt im Profil wählbar sind.
    static var focusChoices: [Muscle] {
        [.chest, .lats, .traps, .shoulders, .biceps, .triceps, .abs, .glutes, .quads, .hamstrings, .calves]
    }
}

enum Equipment: String, CaseIterable, Codable {
    case none = "Ohne Geräte"
    case dumbbell = "Kurzhanteln"
    case barbell = "Langhantel und Bank"
    case bar = "Klimmzugstange / Barren"
}

/// Welche Ausstattung jemand hat.
enum Setup: String, CaseIterable, Identifiable {
    case gym = "Fitnessstudio (alles)"
    case home = "Zuhause mit Kurzhanteln"
    case bodyweight = "Nur Körpergewicht (Calisthenics)"
    var id: String { rawValue }

    func allows(_ e: Equipment) -> Bool {
        switch self {
        case .gym: return true
        case .home: return e == .none || e == .dumbbell
        case .bodyweight: return e == .none || e == .bar
        }
    }
}

enum Category: String, CaseIterable, Identifiable {
    case strength = "Kraft", calisthenics = "Calisthenics", core = "Rumpf", drill = "Lauf-ABC", mobility = "Mobility"
    var id: String { rawValue }
}

enum MobilityRegion: String, CaseIterable, Identifiable {
    case hip = "Hüfte", ankle = "Sprunggelenk", shoulder = "Schulter", back = "Rücken"
    case neck = "Nacken", legs = "Oberschenkel", wrist = "Handgelenk"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .hip: return "figure.cooldown"
        case .ankle: return "shoeprints.fill"
        case .shoulder: return "figure.arms.open"
        case .back: return "figure.mind.and.body"
        case .neck: return "person.crop.circle"
        case .legs: return "figure.walk"
        case .wrist: return "hand.raised"
        }
    }
}

/// Wie ein Satz erfasst wird.
enum LogKind {
    case weighted      // Gewicht und Wiederholungen
    case bodyweight    // Wiederholungen (optional Zusatzgewicht)
    case seconds       // Haltezeit in Sekunden
}

struct Exercise: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let category: Category
    var region: MobilityRegion? = nil
    let primary: [Muscle]
    var secondary: [Muscle] = []
    var equipment: Equipment = .none
    var kind: LogKind = .weighted
    /// Textdosierung (z. B. "2 × 30 s pro Seite")
    var dose: String = ""
    /// Sekunden für den Timer (Mobility), pro Seite
    var seconds: Int? = nil
    var perSide: Bool = false
    let tips: [String]
    /// Grobe Orientierung für das Eintragen: Startgewicht als Faktor des Körpergewichts
    var startFactor: Double? = nil

    var isMobility: Bool { category == .mobility }
    var allMuscles: [Muscle] { primary + secondary }

    func hash(into hasher: inout Hasher) { hasher.combine(name) }
    static func == (a: Exercise, b: Exercise) -> Bool { a.name == b.name }
}
