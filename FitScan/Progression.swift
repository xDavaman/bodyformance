import Combine
import Foundation

func formatKg(_ value: Double) -> String {
    value.formatted(.number.precision(.fractionLength(0...1)))
}

func percentText(_ value: Double) -> String {
    String(format: "%+.1f %%", value)
}

// MARK: - Zielvorgaben

struct GoalPlan {
    let sets: ClosedRange<Int>
    let reps: ClosedRange<Int>
    let rest: String
    let note: String
    /// leichtere Woche: Gewichtsvorschlag 10 % niedriger
    var deload = false
}

extension Goal {
    var plan: GoalPlan {
        switch self {
        case .muscle:
            return GoalPlan(
                sets: 3...4, reps: 6...12, rest: "90–120 Sekunden",
                note: "Trainiere nah am Muskelversagen (1–3 Wiederholungen in Reserve). Sobald du in allen Sätzen die obere Wiederholungszahl schaffst, steigerst du das Gewicht."
            )
        case .maintain:
            return GoalPlan(
                sets: 2...3, reps: 5...8, rest: "2–3 Minuten",
                note: "Zum Erhalt zählt die Intensität: Gewichte halten, aber etwa ein Drittel weniger Sätze machen als im Aufbau."
            )
        case .fatLoss:
            return GoalPlan(
                sets: 2...3, reps: 5...8, rest: "2–3 Minuten",
                note: "Im Kaloriendefizit geht es darum, die Kraft zu halten. Behalte schwere Sätze bei, senke das Volumen leicht und erwarte keine Steigerungen."
            )
        }
    }
}

// MARK: - Datentypen für Analyse

struct Recommendation {
    var weightKg: Double?
    var setsText: String
    var repsText: String
    var message: String
    var warning: String?
}

struct ExerciseProgress: Identifiable {
    var id: String { name }
    let name: String
    let first: Double
    let latest: Double
    let sessions: Int
    var percent: Double { first > 0 ? (latest - first) / first * 100 : 0 }
}

struct SessionPoint: Identifiable {
    var id: Date { date }
    let date: Date
    let e1RM: Double
}

struct WeekVolume: Identifiable {
    var id: Date { start }
    let start: Date
    let volume: Double
}

// MARK: - Logik

enum Progression {
    static func roundToPlate(_ weight: Double) -> Double {
        max(0, (weight / 2.5).rounded() * 2.5)
    }

    static func increment(for exercise: Exercise) -> Double {
        let lower: [Muscle] = [.quads, .hamstrings, .glutes, .calves]
        return exercise.primary.contains { lower.contains($0) } ? 5 : 2.5
    }

    /// Bereich für Körpergewichtsübungen, unabhängig vom Ziel.
    static let bodyweightReps = 6...15

    static func prescription(for exercise: Exercise, plan: GoalPlan) -> String {
        switch exercise.kind {
        case .seconds:
            return "\(plan.sets.lowerBound) × 30–60 s"
        case .bodyweight:
            return "\(plan.sets.lowerBound)–\(plan.sets.upperBound) × \(bodyweightReps.lowerBound)–\(bodyweightReps.upperBound)"
        case .weighted:
            return "\(plan.sets.lowerBound)–\(plan.sets.upperBound) × \(plan.reps.lowerBound)–\(plan.reps.upperBound)"
        }
    }

    static func sessions(from sets: [SetLog]) -> [[SetLog]] {
        let grouped = Dictionary(grouping: sets) { Calendar.current.startOfDay(for: $0.date) }
        return grouped.keys.sorted().map { key in
            (grouped[key] ?? []).sorted { $0.date < $1.date }
        }
    }

    static func sessionPoints(_ sessions: [[SetLog]]) -> [SessionPoint] {
        sessions.compactMap { s in
            guard let date = s.first?.date, let best = s.map(\.e1RM).max() else { return nil }
            return SessionPoint(date: Calendar.current.startOfDay(for: date), e1RM: best)
        }
    }

    /// Keine neue Bestleistung in den letzten 3 Einheiten.
    static func isStagnating(_ sessions: [[SetLog]]) -> Bool {
        guard sessions.count >= 4 else { return false }
        let best = sessions.map { $0.map(\.e1RM).max() ?? 0 }
        let recent = best.suffix(3).max() ?? 0
        let before = best.dropLast(3).max() ?? 0
        return recent <= before
    }

    static func recommend(exercise: Exercise, goal: Goal, plan: GoalPlan,
                          sessions: [[SetLog]], bodyWeight: Double) -> Recommendation {
        let setsText = "\(plan.sets.lowerBound)–\(plan.sets.upperBound) Sätze"

        // Haltezeiten
        if exercise.kind == .seconds {
            let best = sessions.last?.map(\.reps).max()
            let msg: String
            if let best {
                msg = "Zuletzt \(best) s. Versuche heute \(best + 5) s mit sauberer Haltung."
            } else {
                msg = "Starte mit 20–30 s und steigere dich in kleinen Schritten, solange die Haltung sauber bleibt."
            }
            return Recommendation(weightKg: nil, setsText: setsText, repsText: "30–60 Sekunden", message: msg, warning: nil)
        }

        // Körpergewicht
        if exercise.kind == .bodyweight {
            let r = bodyweightReps
            let repsText = "\(r.lowerBound)–\(r.upperBound) Wiederholungen"
            guard let last = sessions.last, let minReps = last.map(\.reps).min(), let maxAdded = last.map(\.weightKg).max() else {
                return Recommendation(weightKg: nil, setsText: setsText, repsText: repsText,
                    message: "Mache so viele saubere Wiederholungen wie möglich, bis ca. 2 vor dem Versagen, und trage sie ein.",
                    warning: nil)
            }
            var message: String
            if minReps >= r.upperBound {
                message = maxAdded > 0
                    ? "Alle Sätze mit \(r.upperBound) Wiederholungen. Erhöhe das Zusatzgewicht um 2,5 kg."
                    : "Alle Sätze mit \(r.upperBound) Wiederholungen. Nimm eine schwerere Variante oder 2,5 kg Zusatzgewicht."
            } else if minReps < r.lowerBound {
                message = "Unter \(r.lowerBound) Wiederholungen. Wähle eine leichtere Variante, damit du im Zielbereich bleibst."
            } else {
                message = "Versuche in jedem Satz eine Wiederholung mehr als zuletzt (\(minReps))."
            }
            var warning: String?
            if isStagnating(sessions) {
                warning = "Seit 3 Einheiten keine Steigerung. Variiere die Übung oder plane eine leichtere Woche."
            }
            return Recommendation(weightKg: maxAdded > 0 ? maxAdded : nil, setsText: setsText, repsText: repsText,
                                  message: message, warning: warning)
        }

        // Mit Gewicht
        let repsText = "\(plan.reps.lowerBound)–\(plan.reps.upperBound) Wiederholungen"
        guard let last = sessions.last, let top = last.map(\.weightKg).max() else {
            if let factor = exercise.startFactor, bodyWeight > 0 {
                return Recommendation(
                    weightKg: roundToPlate(bodyWeight * factor), setsText: setsText, repsText: repsText,
                    message: "Startwert als grobe Orientierung für Einsteiger. Beginne lieber etwas leichter, bis die Technik sitzt, und trage deine Sätze ein.",
                    warning: nil)
            }
            return Recommendation(
                weightKg: nil, setsText: setsText, repsText: repsText,
                message: "Noch keine Daten. Starte mit einem Gewicht, bei dem du die obere Wiederholungszahl sicher schaffst, und trage deine Sätze ein.",
                warning: nil)
        }

        let topSets = last.filter { $0.weightKg == top }
        let minReps = topSets.map(\.reps).min() ?? 0
        let allHitTop = topSets.count >= plan.sets.lowerBound && minReps >= plan.reps.upperBound

        var weight = top
        var message: String

        switch goal {
        case .muscle:
            if allHitTop {
                weight = roundToPlate(top + increment(for: exercise))
                message = "Zuletzt hast du alle Sätze mit \(formatKg(top)) kg und \(plan.reps.upperBound) Wiederholungen geschafft. Erhöhe das Gewicht."
            } else if minReps < plan.reps.lowerBound {
                weight = roundToPlate(top * 0.95)
                message = "Zuletzt unter \(plan.reps.lowerBound) Wiederholungen. Gehe etwas leichter, damit du im Zielbereich trainierst."
            } else {
                message = "Bleib bei \(formatKg(top)) kg und versuche, in jedem Satz eine Wiederholung mehr zu schaffen."
            }
        case .maintain:
            if minReps < plan.reps.lowerBound {
                weight = roundToPlate(top * 0.95)
                message = "Zuletzt unter \(plan.reps.lowerBound) Wiederholungen. Gehe etwas leichter und halte die Technik sauber."
            } else {
                message = "Halte \(formatKg(top)) kg. Zum Erhalt zählt Intensität statt Steigerung, weniger Sätze genügen."
            }
        case .fatLoss:
            if minReps < plan.reps.lowerBound {
                weight = roundToPlate(top * 0.95)
                message = "Im Kaloriendefizit sinkt die Leistung manchmal leicht. Gehe etwas leichter und halte die Technik sauber."
            } else {
                message = "Halte \(formatKg(top)) kg. In der Diät ist es ein Erfolg, wenn du deine Kraft hältst."
            }
        }

        var warning: String?
        let points = sessionPoints(sessions)
        if goal == .muscle, isStagnating(sessions) {
            warning = "Seit 3 Einheiten keine neue Bestleistung. Plane eine Entlastungswoche (ca. 10 % weniger Gewicht) oder ändere den Wiederholungsbereich."
        } else if goal == .fatLoss, let latest = points.last?.e1RM, let best = points.map(\.e1RM).max(), latest < best * 0.9 {
            warning = "Deine Kraft liegt über 10 % unter deiner Bestleistung. Prüfe Kaloriendefizit, Protein und Schlaf."
        }

        if plan.deload {
            return Recommendation(weightKg: roundToPlate(weight * 0.9), setsText: setsText, repsText: repsText,
                                  message: "Deload-Woche: etwa 10 % leichter als sonst. " + message, warning: nil)
        }
        return Recommendation(weightKg: weight, setsText: setsText, repsText: repsText, message: message, warning: warning)
    }

    static func progress(for sets: [SetLog]) -> [ExerciseProgress] {
        let byExercise = Dictionary(grouping: sets, by: \.exercise)
        return byExercise.compactMap { name, logs in
            let points = sessionPoints(sessions(from: logs))
            guard points.count >= 2, let first = points.first, let last = points.last else { return nil }
            return ExerciseProgress(name: name, first: first.e1RM, latest: last.e1RM, sessions: points.count)
        }
        .sorted { $0.name < $1.name }
    }

    static func weeklyVolume(sets: [SetLog], weeks: Int) -> [WeekVolume] {
        let cal = Calendar.current
        guard let thisWeek = cal.dateInterval(of: .weekOfYear, for: Date())?.start else { return [] }
        return (0..<weeks).reversed().compactMap { i in
            guard let start = cal.date(byAdding: .weekOfYear, value: -i, to: thisWeek),
                  let end = cal.date(byAdding: .weekOfYear, value: 1, to: start) else { return nil }
            let volume = sets
                .filter { $0.date >= start && $0.date < end }
                .reduce(0) { $0 + $1.weightKg * Double($1.reps) }
            return WeekVolume(start: start, volume: volume)
        }
    }

    static func strengthVerdict(average: Double, goal: Goal) -> String {
        switch goal {
        case .muscle:
            if average < 0 { return "Deine Kraft sinkt. Prüfe Kalorienüberschuss, Protein, Schlaf und ob du dich ausreichend erholst." }
            if average < 2 { return "Der Fortschritt ist langsam. Das ist bei längerer Trainingserfahrung normal. Achte auf kleine Steigerungen und genug Schlaf." }
            return "Guter Fortschritt. Bleib bei der doppelten Progression: erst Wiederholungen, dann Gewicht."
        case .maintain:
            if abs(average) <= 5 { return "Deine Kraft ist stabil, das ist das Ziel beim Muskelerhalt." }
            return average > 0 ? "Du wirst stärker. Wenn du Muskeln aufbauen willst, wechsle das Ziel auf Muskelaufbau." : "Deine Kraft sinkt. Prüfe Schlaf, Kalorien und Protein."
        case .fatLoss:
            if average >= -5 { return "Du hältst deine Kraft im Defizit, das ist genau das Ziel." }
            return "Deine Kraft sinkt deutlich. Das Defizit ist vielleicht zu groß oder Protein und Schlaf sind zu knapp."
        }
    }

    static func bodyWeightVerdict(entries: [BodyEntry], goal: Goal) -> String {
        let cutoff = Date().addingTimeInterval(-42 * 86_400)
        let recent = entries.filter { $0.date > cutoff }.sorted { $0.date < $1.date }
        guard let first = recent.first, let last = recent.last, first.weightKg > 0,
              last.date.timeIntervalSince(first.date) >= 7 * 86_400 else {
            return "Trage über mindestens eine Woche regelmäßig dein Gewicht ein, dann bewerte ich den Trend."
        }
        let weeks = last.date.timeIntervalSince(first.date) / (7 * 86_400)
        let pct = (last.weightKg - first.weightKg) / first.weightKg * 100 / weeks
        let rate = String(format: "%+.2f %% pro Woche", pct)

        switch goal {
        case .fatLoss:
            if pct > -0.25 { return "\(rate): Zu langsam für eine Diät. Faustregel: 0,5–1 % Körpergewicht pro Woche. Senke die Kalorien um ca. 100–200 kcal oder bewege dich mehr." }
            if pct < -1.0 { return "\(rate): Sehr schnell. Das erhöht das Risiko, Muskeln zu verlieren. Erhöhe die Kalorien etwas und halte das Protein hoch." }
            return "\(rate): Im Zielbereich (0,5–1 % pro Woche). Halte Protein und Krafttraining bei."
        case .muscle:
            if pct < 0.1 { return "\(rate): Zu wenig Überschuss für den Muskelaufbau. Faustregel: +0,1–0,5 % pro Woche. Erhöhe die Kalorien um ca. 150–250 kcal." }
            if pct > 0.5 { return "\(rate): Recht schnell, ein größerer Teil davon wird Fett sein. Reduziere die Kalorien um ca. 150–200 kcal." }
            return "\(rate): Im Zielbereich für sauberen Muskelaufbau."
        case .maintain:
            if abs(pct) <= 0.25 { return "\(rate): Dein Gewicht ist stabil." }
            return pct > 0
                ? "\(rate): Du nimmst zu. Wenn du das Gewicht halten willst, senke die Kalorien leicht."
                : "\(rate): Du nimmst ab. Wenn du das Gewicht halten willst, iss etwas mehr."
        }
    }
}

// MARK: - Vergleich mit der letzten Einheit

extension Progression {
    /// Bester Vergleichswert (geschätztes Maximum) der letzten Einheit vor dem Tag von `date`
    static func previousBest(exercise: String, before date: Date, in sets: [SetLog]) -> Double? {
        let cal = Calendar.current
        let day = cal.startOfDay(for: date)
        let earlier = sets.filter { $0.exercise == exercise && $0.date < day }
        guard let lastDay = earlier.map({ cal.startOfDay(for: $0.date) }).max() else { return nil }
        return earlier.filter { cal.startOfDay(for: $0.date) == lastDay }.map(\.e1RM).max()
    }

    /// Veränderung in Prozent gegenüber dem Vergleichswert (nil ohne Vergleich)
    static func change(_ value: Double, vs reference: Double?) -> Double? {
        guard let r = reference, r > 0, value > 0 else { return nil }
        return (value - r) / r * 100
    }

    /// Veränderung eines eingetragenen Satzes gegenüber der besten Leistung der Einheit davor
    static func change(of set: SetLog, in sets: [SetLog]) -> Double? {
        change(set.e1RM, vs: previousBest(exercise: set.exercise, before: set.date, in: sets))
    }
}

extension UserProfile {
    /// Satzpause in Sekunden (erste Zahl der Pausen-Angabe, z. B. „2–3 Minuten“ → 120)
    var restSeconds: Int {
        let text = effectivePlan.rest
        let digits = text.prefix { $0.isNumber }
        let n = Int(digits) ?? 90
        return text.contains("Minute") ? n * 60 : n
    }
}
