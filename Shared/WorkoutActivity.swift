import ActivityKit
import AppIntents
import Foundation

// Gemeinsam für App und Widget-Erweiterung (Sperrbildschirm, Dynamic Island, Homescreen-Widgets).

// MARK: - Live Activity

nonisolated struct WorkoutActivityAttributes: ActivityAttributes {
    nonisolated struct ContentState: Codable, Hashable {
        var phase: String
        var phaseIcon: String
        var exercise: String
        var equipment: String
        var weight: String
        /// „Satz 2 von 3“ oder „45 s“
        var target: String
        var isTimed: Bool
        var nextExercise: String
        /// Gerät · Gewicht · Umfang der nächsten Übung
        var nextDetail: String
        var paused: Bool
        var finished: Bool
        /// Trainingsbeginn ohne Pausen (für die laufende Uhr)
        var timerStart: Date
        /// Trainingszeit in Sekunden (angezeigt, solange pausiert)
        var elapsed: Int
        var restEnd: Date?
        var step: Int
        var stepCount: Int
    }

    var title: String
}

// MARK: - Daten für die Homescreen-Widgets

/// Was die Widgets zeigen: heutige Einheit, nächste Übungen, Status. Die App schreibt es in die App Group.
nonisolated struct WidgetSnapshot: Codable, Hashable {
    nonisolated struct Item: Codable, Hashable {
        var name: String
        var detail: String
    }

    var title: String
    var subtitle: String
    var items: [Item]
    var active: Bool
    var paused: Bool
    var current: String?
    var currentDetail: String?
    var timerStart: Date?
    var elapsed: Int
    var updated: Date

    static let appGroup = "group.test.FitScan"
    private static let key = "widget.snapshot"

    static var placeholder: WidgetSnapshot {
        WidgetSnapshot(title: "Heute: Oberkörper", subtitle: "Aufwärmen → Hauptteil → Mobility",
                       items: [Item(name: "Bankdrücken", detail: "Langhantel und Bank · 60 kg · 3 × 8"),
                               Item(name: "Klimmzüge", detail: "Klimmzugstange · 3 × 8"),
                               Item(name: "Schulterdrücken", detail: "Kurzhanteln · 18 kg · 3 × 10")],
                       active: false, paused: false, current: nil, currentDetail: nil, timerStart: nil, elapsed: 0, updated: Date())
    }

    static func load() -> WidgetSnapshot? {
        guard let d = UserDefaults(suiteName: appGroup)?.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(WidgetSnapshot.self, from: d)
    }

    /// Speichert und meldet, ob sich etwas geändert hat
    @discardableResult
    func save() -> Bool {
        guard let d = try? JSONEncoder().encode(self), let defaults = UserDefaults(suiteName: Self.appGroup) else { return false }
        var old = Self.load()
        old?.updated = updated
        if old == self { return false }
        defaults.set(d, forKey: Self.key)
        return true
    }
}

// MARK: - Knöpfe auf Sperrbildschirm und Widget

nonisolated enum WorkoutAction: String, Sendable {
    case togglePause, setDone, nextExercise, end
}

/// Die App setzt den Empfänger beim Start; die Knöpfe laufen im Prozess der App.
@MainActor
enum WorkoutControl {
    static var handler: ((WorkoutAction) -> Void)?

    static func run(_ action: WorkoutAction) {
        handler?(action)
    }
}

nonisolated struct TogglePauseWorkoutIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Training pausieren oder fortsetzen"
    init() {}
    func perform() async throws -> some IntentResult {
        await WorkoutControl.run(.togglePause)
        return .result()
    }
}

nonisolated struct SetDoneWorkoutIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Satz fertig"
    init() {}
    func perform() async throws -> some IntentResult {
        await WorkoutControl.run(.setDone)
        return .result()
    }
}

nonisolated struct NextExerciseWorkoutIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Übung fertig"
    init() {}
    func perform() async throws -> some IntentResult {
        await WorkoutControl.run(.nextExercise)
        return .result()
    }
}

nonisolated struct EndWorkoutIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Training beenden"
    init() {}
    func perform() async throws -> some IntentResult {
        await WorkoutControl.run(.end)
        return .result()
    }
}

nonisolated enum WorkoutLinks {
    static let open = URL(string: "bodyformance://training")!
    static let start = URL(string: "bodyformance://training/start")!

    static func clock(_ s: Int) -> String {
        let h = s / 3600, m = (s % 3600) / 60, sec = s % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, sec) : String(format: "%02d:%02d", m, sec)
    }
}
