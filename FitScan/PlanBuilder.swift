import Combine
import Foundation

struct PlannedExercise: Identifiable {
    var id: String { exercise.name }
    let exercise: Exercise
    let isFocus: Bool
}

struct TrainingDay: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let items: [PlannedExercise]
}

/// Baut aus Trainingstagen, Ausstattung, Erfahrung und Schwerpunkt-Muskeln einen Plan (Push/Pull/Beine usw.).
enum PlanBuilder {

    /// Jede Zeile ist ein Platz im Plan; es wird die erste Übung genommen, die zur Ausstattung passt und noch nicht dabei ist.
    private typealias Slots = [[String]]

    private static let push: Slots = [
        ["Bankdrücken", "Schrägbankdrücken (Kurzhantel)", "Liegestütze"],
        ["Schrägbankdrücken (Kurzhantel)", "Dips", "Liegestütze"],
        ["Schulterdrücken", "Liegestütze"],
        ["Seitheben"],
        ["Trizeps-Überkopfdrücken", "Dips"]
    ]
    private static let pull: Slots = [
        ["Klimmzüge", "Australian Pull-ups"],
        ["Rudern", "Einarmiges Kurzhantelrudern", "Australian Pull-ups"],
        ["Einarmiges Kurzhantelrudern", "Australian Pull-ups"],
        ["Bizeps-Curl", "Klimmzüge"],
        ["Hängendes Beinheben", "Dead Bug"]
    ]
    private static let legs: Slots = [
        ["Kniebeuge", "Kniebeuge ohne Gewicht"],
        ["Rumänisches Kreuzheben", "Glute Bridge"],
        ["Ausfallschritte", "Kniebeuge ohne Gewicht"],
        ["Hip Thrust", "Glute Bridge"],
        ["Wadenheben", "Seilspringen"],
        ["Plank", "Hollow Hold"]
    ]
    private static let upper: Slots = [
        ["Bankdrücken", "Schrägbankdrücken (Kurzhantel)", "Liegestütze"],
        ["Klimmzüge", "Australian Pull-ups"],
        ["Schulterdrücken", "Dips"],
        ["Rudern", "Einarmiges Kurzhantelrudern", "Australian Pull-ups"],
        ["Bizeps-Curl", "Klimmzüge"],
        ["Trizeps-Überkopfdrücken", "Dips"]
    ]
    private static let lower: Slots = [
        ["Kniebeuge", "Kniebeuge ohne Gewicht"],
        ["Rumänisches Kreuzheben", "Glute Bridge"],
        ["Ausfallschritte", "Kniebeuge ohne Gewicht"],
        ["Hip Thrust", "Glute Bridge"],
        ["Wadenheben", "Seilspringen"],
        ["Plank", "Hollow Hold"]
    ]
    private static let fullA: Slots = [
        ["Kniebeuge", "Kniebeuge ohne Gewicht"],
        ["Bankdrücken", "Schrägbankdrücken (Kurzhantel)", "Liegestütze"],
        ["Rudern", "Einarmiges Kurzhantelrudern", "Australian Pull-ups"],
        ["Schulterdrücken", "Dips"],
        ["Plank", "Hollow Hold"]
    ]
    private static let fullB: Slots = [
        ["Rumänisches Kreuzheben", "Glute Bridge"],
        ["Klimmzüge", "Australian Pull-ups"],
        ["Schrägbankdrücken (Kurzhantel)", "Dips", "Liegestütze"],
        ["Ausfallschritte", "Kniebeuge ohne Gewicht"],
        ["Hängendes Beinheben", "Dead Bug"]
    ]

    private static let pushMuscles: Set<Muscle> = [.chest, .shoulders, .triceps]
    private static let pullMuscles: Set<Muscle> = [.lats, .traps, .biceps]
    private static let legMuscles: Set<Muscle> = [.quads, .hamstrings, .glutes, .calves]

    static func plan(profile: UserProfile) -> [TrainingDay] {
        // Mit Trainingsziel (KI-Coach): nur die Krafttage, Calisthenics immer mit Körpergewicht
        let goal = profile.trainingGoal
        let days = max(2, min(6, goal?.strengthDays(of: profile.trainingDays) ?? profile.trainingDays))
        let focus = profile.focusMuscles
        let excluded = profile.excludedExercises
        // Calisthenics immer mit Körpergewicht, sonst die eigenen Geräte (Meine Geräte) bzw. die Ausstattung
        let can: (Exercise) -> Bool = { ex in
            !excluded.contains(ex.name) && (goal == .calisthenics ? Setup.bodyweight.allows(ex.equipment) : profile.allows(ex.equipment))
        }

        func day(_ name: String, _ sub: String, _ slots: Slots, _ muscles: Set<Muscle>) -> TrainingDay {
            var used = Set<String>()
            var items: [PlannedExercise] = []
            for options in slots {
                var picked = false
                for n in options {
                    guard let ex = ExerciseCatalog.exercise(named: n), can(ex), !used.contains(n) else { continue }
                    used.insert(n)
                    items.append(PlannedExercise(exercise: ex, isFocus: !focus.isDisjoint(with: ex.primary)))
                    picked = true
                    break
                }
                // keine Variante möglich (Gerät fehlt oder Übung ausgeschlossen): Ersatz für denselben Hauptmuskel
                if !picked, let target = options.compactMap({ ExerciseCatalog.exercise(named: $0) }).first?.primary.first,
                   let sub = ExerciseCatalog.libraryTraining.first(where: {
                       $0.primary.first == target && [.strength, .calisthenics, .core].contains($0.category)
                           && can($0) && !used.contains($0.name)
                   }) {
                    used.insert(sub.name)
                    items.append(PlannedExercise(exercise: sub, isFocus: !focus.isDisjoint(with: sub.primary)))
                }
            }
            // Zusätzliche Übung für jeden Schwerpunkt-Muskel dieses Tages
            for m in focus where muscles.contains(m) {
                if items.filter({ $0.exercise.primary.contains(m) }).count >= 2 { continue }
                if let extra = ExerciseCatalog.training.first(where: {
                    $0.primary.contains(m) && $0.category != .drill && $0.category != .core
                        && can($0) && !used.contains($0.name)
                }) {
                    used.insert(extra.name)
                    items.append(PlannedExercise(exercise: extra, isFocus: true))
                }
            }
            // Einsteiger: kürzere Einheiten
            if profile.experience == .beginner && items.count > 5 {
                items = Array(items.prefix(5))
            }
            return TrainingDay(name: name, subtitle: sub, items: items)
        }

        let all: Set<Muscle> = pushMuscles.union(pullMuscles).union(legMuscles).union([.abs])
        let pushDay = { day("Push", "Brust, Schultern, Trizeps", push, pushMuscles) }
        let pullDay = { day("Pull", "Rücken, Bizeps", pull, pullMuscles.union([.abs])) }
        let legDay = { day("Beine", "Oberschenkel, Gesäß, Waden", legs, legMuscles) }
        let upperDay = { (n: String) in day(n, "Oberkörper", upper, pushMuscles.union(pullMuscles)) }
        let lowerDay = { (n: String) in day(n, "Unterkörper", lower, legMuscles) }

        if goal == .runner || goal == .health {
            return [day("Ganzkörper A", "Beine, Druck, Zug", fullA, all),
                    day("Ganzkörper B", "Hüfte, Zug, Druck", fullB, all),
                    day("Ganzkörper A", "Beine, Druck, Zug", fullA, all)].prefix(days).map { $0 }
        }

        switch days {
        case 2:
            return [day("Ganzkörper A", "Beine, Druck, Zug", fullA, all),
                    day("Ganzkörper B", "Hüfte, Zug, Druck", fullB, all)]
        case 3:
            if profile.experience == .beginner {
                return [day("Ganzkörper A", "Beine, Druck, Zug", fullA, all),
                        day("Ganzkörper B", "Hüfte, Zug, Druck", fullB, all),
                        day("Ganzkörper A", "Beine, Druck, Zug", fullA, all)]
            }
            return [pushDay(), pullDay(), legDay()]
        case 4:
            return [upperDay("Oberkörper 1"), lowerDay("Unterkörper 1"), upperDay("Oberkörper 2"), lowerDay("Unterkörper 2")]
        case 5:
            return [pushDay(), pullDay(), legDay(), upperDay("Oberkörper"), lowerDay("Unterkörper")]
        default:
            return [pushDay(), pullDay(), legDay(), pushDay(), pullDay(), legDay()]
        }
    }

    /// Alle verschiedenen Übungen des Plans (für Analyse).
    static func uniqueExercises(profile: UserProfile) -> [Exercise] {
        var seen = Set<String>()
        return plan(profile: profile).flatMap(\.items).map(\.exercise).filter { seen.insert($0.name).inserted }
    }
}

// MARK: - Mobility-Auswahl

enum MobilityPlanner {
    struct Pick: Identifiable {
        var id: String { exercise.name }
        let exercise: Exercise
        let reason: String
    }

    /// Wie wichtig eine Region für den gewählten Sport ist (Grundgewichtung).
    static func weight(of region: MobilityRegion, sport: Sport) -> Double {
        switch sport {
        case .running:
            return [.hip: 3, .ankle: 3, .legs: 2.5, .back: 1][region] ?? 0.5
        case .hybrid:
            return [.hip: 3, .ankle: 2.5, .legs: 2, .shoulder: 2, .back: 1.5][region] ?? 0.5
        case .calisthenics:
            return [.shoulder: 3, .wrist: 3, .back: 2, .hip: 2, .neck: 1][region] ?? 0.5
        case .other:
            return [.hip: 2, .shoulder: 2, .back: 2, .ankle: 1.5][region] ?? 1
        case .none:
            return [.hip: 2.5, .shoulder: 2.5, .back: 2, .legs: 1.5][region] ?? 1
        }
    }

    /// Anzahl der Übungen je Region in den letzten 14 Tagen.
    static func recentCounts(_ logs: [MobilityLog]) -> [MobilityRegion: Int] {
        let cutoff = Date().addingTimeInterval(-14 * 86_400)
        var counts: [MobilityRegion: Int] = [:]
        for l in logs where l.date > cutoff {
            if let r = MobilityRegion(rawValue: l.region) { counts[r, default: 0] += 1 }
        }
        return counts
    }

    static func picks(profile: UserProfile, logs: [MobilityLog], count: Int = 5) -> [Pick] {
        let counts = recentCounts(logs)
        let scored = MobilityRegion.allCases.map { r -> (MobilityRegion, Double) in
            (r, weight(of: r, sport: profile.sport) - Double(counts[r] ?? 0) * 0.6)
        }.sorted { $0.1 > $1.1 }

        var result: [Pick] = []
        for (region, _) in scored {
            let options = ExerciseCatalog.mobility(in: region).filter { profile.canDo($0) }
            // am längsten nicht gemacht zuerst
            let lastDone: (Exercise) -> Date = { ex in
                logs.filter { $0.exercise == ex.name }.map(\.date).max() ?? .distantPast
            }
            guard let ex = options.min(by: { lastDone($0) < lastDone($1) }) else { continue }
            let done = counts[region] ?? 0
            let why = done == 0
                ? "\(region.rawValue): seit 14 Tagen nicht trainiert"
                : "\(region.rawValue): passt zu deinem Training (\(done)× in 14 Tagen)"
            result.append(Pick(exercise: ex, reason: why))
            if result.count == count { break }
        }
        return result
    }
}
