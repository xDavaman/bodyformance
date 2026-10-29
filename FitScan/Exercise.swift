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
    case cable = "Kabelzug"
    case machine = "Maschine"
    case kettlebell = "Kettlebell"
    case band = "Widerstandsband"
    case sling = "Schlingentrainer / Ringe"
    case medball = "Medizinball"
    case foam = "Faszienrolle"
    case cardioGear = "Cardio-Gerät"
    case outdoor = "Draußen"
    case bike = "Fahrrad"
    case pool = "Schwimmbad"
}

/// Welche Ausstattung jemand hat.
enum Setup: String, CaseIterable, Identifiable {
    case gym = "Fitnessstudio (alles)"
    case home = "Zuhause mit Kurzhanteln"
    case bodyweight = "Nur Körpergewicht (Calisthenics)"
    case outdoor = "Draußen / Park"
    var id: String { rawValue }

    func allows(_ e: Equipment) -> Bool {
        switch self {
        case .gym: return true
        case .home: return [.none, .dumbbell, .band, .kettlebell, .medball, .foam, .sling].contains(e)
        case .bodyweight: return [.none, .bar, .band, .sling, .foam].contains(e)
        case .outdoor: return [.none, .bar, .band, .sling, .foam, .outdoor, .bike, .pool].contains(e)
        }
    }
}

enum Category: String, CaseIterable, Identifiable {
    case strength = "Kraft", calisthenics = "Calisthenics", core = "Rumpf", drill = "Lauf-ABC", mobility = "Mobility"
    case cardio = "Cardio", plyo = "Plyometrie", functional = "Funktionell"
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
    /// Schlüssel der 3D-Bewegung (BodyMotion.rawValue), sonst automatisch aus dem Namen
    var motionKey: String? = nil
    /// Kurzbeschreibung des Trainingsziels (z. B. "Gerade Bauchmuskeln")
    var target: String = ""
    /// Name des gerenderten Übungsvideos im Bundle (ExerciseVideos/bf_XXX_*.mp4), falls vorhanden
    var videoName: String? = nil

    var isMobility: Bool { category == .mobility }
    var allMuscles: [Muscle] { primary + secondary }

    func hash(into hasher: inout Hasher) { hasher.combine(name) }
    static func == (a: Exercise, b: Exercise) -> Bool { a.name == b.name }
}
