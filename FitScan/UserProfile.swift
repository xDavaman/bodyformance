import Combine
import SwiftUI

enum Goal: String, CaseIterable, Identifiable {
    case muscle = "Muskelaufbau"
    case maintain = "Muskelerhalt"
    case fatLoss = "Diät (Fett abbauen)"
    var id: String { rawValue }
}

/// Wunschoptik / Schwerpunkt
enum Aesthetic: String, CaseIterable, Identifiable {
    case bulky = "Sehr muskulös"
    case defined = "Definiert und athletisch"
    case lean = "Schlank, wenig Körperfett"
    case strength = "Kraft im Vordergrund"
    var id: String { rawValue }

    var note: String {
        switch self {
        case .bulky: return "Mehr Sätze pro Muskel und Fokus auf schwere Grundübungen mit 6–12 Wiederholungen."
        case .defined: return "Ausgewogenes Volumen mit 8–12 Wiederholungen, dazu etwas Ausdauer."
        case .lean: return "Höhere Wiederholungszahlen (8–15), regelmäßige Bewegung und ein leichtes Defizit."
        case .strength: return "Schwere Sätze mit 3–6 Wiederholungen und lange Pausen."
        }
    }
}

enum Experience: String, CaseIterable, Identifiable {
    case beginner = "Einsteiger (unter 1 Jahr)"
    case intermediate = "Fortgeschritten (1–3 Jahre)"
    case advanced = "Erfahren (über 3 Jahre)"
    var id: String { rawValue }
}

enum Sport: String, CaseIterable, Identifiable {
    case none = "Kein Zusatzsport"
    case running = "Laufen"
    case hybrid = "Hybrid (Kraft und Laufen)"
    case calisthenics = "Calisthenics"
    case other = "Anderer Kraft- oder Bewegungssport"
    var id: String { rawValue }
}

final class UserProfile: ObservableObject {
    @AppStorage("age") var age: Int = 34
    @AppStorage("heightCm") var heightCm: Double = 180
    @AppStorage("weightKg") var weightKg: Double = 80
    @AppStorage("waistCm") var waistCm: Double = 85
    @AppStorage("neckCm") var neckCm: Double = 38
    @AppStorage("trainingDays") var trainingDays: Int = 4
    @AppStorage("goal") var goalRaw: String = Goal.maintain.rawValue
    @AppStorage("aesthetic") var aestheticRaw: String = Aesthetic.defined.rawValue
    @AppStorage("experience") var experienceRaw: String = Experience.intermediate.rawValue
    @AppStorage("setup") var setupRaw: String = Setup.gym.rawValue
    @AppStorage("sport") var sportRaw: String = Sport.none.rawValue
    @AppStorage("focusMuscles") var focusRaw: String = ""
    @AppStorage("targetBodyFat") var targetBodyFat: Double = 15
    @AppStorage("weeklyRunKm") var weeklyRunKm: Double = 20
    @AppStorage("pace") var paceRaw: String = Pace.normal.rawValue
    @AppStorage("stepGoalCustom") var stepGoalCustom: Int = 0

    var goal: Goal {
        get { Goal(rawValue: goalRaw) ?? .maintain }
        set { goalRaw = newValue.rawValue; objectWillChange.send() }
    }
    var aesthetic: Aesthetic {
        get { Aesthetic(rawValue: aestheticRaw) ?? .defined }
        set { aestheticRaw = newValue.rawValue; objectWillChange.send() }
    }
    var experience: Experience {
        get { Experience(rawValue: experienceRaw) ?? .intermediate }
        set { experienceRaw = newValue.rawValue; objectWillChange.send() }
    }
    var setup: Setup {
        get { Setup(rawValue: setupRaw) ?? .gym }
        set { setupRaw = newValue.rawValue; objectWillChange.send() }
    }
    var sport: Sport {
        get { Sport(rawValue: sportRaw) ?? .none }
        set { sportRaw = newValue.rawValue; objectWillChange.send() }
    }
    /// Beginn des bestätigten Extrem-Tempos (0 = nie bestätigt). Läuft nach 28 Tagen ab.
    @AppStorage("extremeConfirmedAt") var extremeConfirmedAt: Double = 0
    var extremeActive: Bool { goal == .fatLoss && extremeConfirmedAt > 0 && Date().timeIntervalSince1970 - extremeConfirmedAt < 28 * 86400 }
    var extremeDaysLeft: Int { max(0, 28 - Int((Date().timeIntervalSince1970 - extremeConfirmedAt) / 86400)) }
    var pace: Pace {
        get {
            let p = Pace(rawValue: paceRaw) ?? .normal
            // Extrem nur bei Diät und nur, solange die Bestätigung gilt – sonst zurück auf Schnell
            if p == .extreme && !extremeActive { return .fast }
            return p
        }
        set { paceRaw = newValue.rawValue; objectWillChange.send() }
    }
    var focusMuscles: Set<Muscle> {
        get { Set(focusRaw.split(separator: ",").compactMap { Muscle(rawValue: String($0)) }) }
        set { focusRaw = newValue.map(\.rawValue).sorted().joined(separator: ","); objectWillChange.send() }
    }

    /// Ziel-Vorgaben unter Berücksichtigung von Ziel, Optik und Erfahrung.
    var effectivePlan: GoalPlan {
        let base = goal.plan
        var sets = base.sets
        var reps = base.reps
        var rest = base.rest
        switch aesthetic {
        case .bulky:
            if goal == .muscle { sets = 4...5 }
        case .defined:
            if goal != .maintain { reps = 8...12 }
        case .lean:
            reps = 8...15
        case .strength:
            reps = 3...6
            rest = "3–4 Minuten"
        }
        switch experience {
        case .beginner:
            sets = max(2, sets.lowerBound - 1)...max(3, sets.upperBound - 1)
        case .advanced:
            if goal == .muscle { sets = sets.lowerBound...(sets.upperBound + 1) }
        case .intermediate:
            break
        }
        switch pace {
        case .fast, .extreme: sets = sets.lowerBound...(sets.upperBound + 1)
        case .slow: sets = sets.lowerBound...max(sets.lowerBound, sets.upperBound - 1)
        case .normal: break
        }
        return GoalPlan(sets: sets, reps: reps, rest: rest, note: base.note + " " + aesthetic.note + " " + pace.note(for: goal))
    }

    /// US-Navy-Formel (Männer) als Zwischenlösung, bis der Kamerascan fertig ist.
    var bodyFatEstimate: Double? {
        guard waistCm > neckCm, heightCm > 0 else { return nil }
        let bf = 495 / (1.0324 - 0.19077 * log10(waistCm - neckCm) + 0.15456 * log10(heightCm)) - 450
        return max(3, min(60, bf))
    }

    var bmi: Double { heightCm > 0 ? weightKg / pow(heightCm / 100, 2) : 0 }

    /// Fettfreie Masse und Differenz zum Zielkörperfett (grobe Orientierung).
    var leanMassKg: Double? {
        bodyFatEstimate.map { weightKg * (1 - $0 / 100) }
    }
    var weightAtTargetBodyFat: Double? {
        leanMassKg.map { $0 / (1 - targetBodyFat / 100) }
    }

    /// Mifflin-St-Jeor (Männer) mit Aktivitätsfaktor aus Trainingstagen.
    var targetCalories: Int {
        let bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) + 5
        let activity = 1.3 + 0.05 * Double(trainingDays) + (sport == .none ? 0 : 0.05)
        var kcal = bmr * activity
        switch goal {
        case .fatLoss:
            kcal -= pace.deficit
            if pace == .extreme {
                kcal = max(kcal, max(bmr, 1500))   // harte Untergrenze
                return Int(kcal.rounded())
            }
        case .muscle: kcal += pace.surplus
        case .maintain: break
        }
        // Nie unter 115 % des Grundumsatzes
        return Int(max(kcal, bmr * 1.15).rounded())
    }

    /// Empfohlene Schritte pro Tag: Diät 8 500–12 000 je nach Tempo, Erhalt 8 500, Muskelaufbau 7 000–9 000
    var recommendedSteps: Int {
        switch goal {
        case .fatLoss:
            switch pace { case .fast, .extreme: return 12000; case .normal: return 10000; case .slow: return 8500 }
        case .maintain:
            return 8500
        case .muscle:
            switch pace { case .fast, .extreme: return 9000; case .normal: return 8000; case .slow: return 7000 }
        }
    }
    var stepGoal: Int { stepGoalCustom > 0 ? stepGoalCustom : recommendedSteps }
    var stepAdvice: String {
        switch goal {
        case .fatLoss:
            return "Bei der Diät helfen viele Schritte, ohne zusätzliche Erschöpfung. Studien zeigen: Rund 8 500 Schritte pro Tag halfen, abgenommenes Gewicht zu halten; für schnelleres Abnehmen sind 10 000–12 000 sinnvoll."
        case .maintain:
            return "Zum Erhalt reichen etwa 8 500 Schritte. Schon 7 000–9 000 pro Tag senken das Gesundheitsrisiko deutlich; mehr bringt danach nur noch wenig."
        case .muscle:
            return "Beim Muskelaufbau sind 7 000–9 000 Schritte genug: gut für Kreislauf und Erholung, ohne zu viel Energie zu verbrennen. Laufschritte zählen mit."
        }
    }

    /// Grobe Dauer bis zum Ziel-Körperfett bei Diät (7700 kcal ≈ 1 kg)
    var weeksToGoal: Int? {
        guard goal == .fatLoss, let target = weightAtTargetBodyFat, target < weightKg else { return nil }
        let perWeek = pace.deficit * 7 / 7700
        return max(1, Int(((weightKg - target) / perWeek).rounded(.up)))
    }

    var proteinGrams: Int { Int((weightKg * 2.0).rounded()) }
    var fatGrams: Int { Int((Double(targetCalories) * 0.25 / 9).rounded()) }
    var carbGrams: Int {
        let rest = Double(targetCalories) - Double(proteinGrams) * 4 - Double(fatGrams) * 9
        return max(0, Int((rest / 4).rounded()))
    }
}
