import ActivityKit
import Combine
import SwiftUI
import WidgetKit

// MARK: - Sperrbildschirm (Live Activity) und Homescreen-Widgets mit dem laufenden Training verbinden

@MainActor
enum LiveWorkout {
    private static var activity: Activity<WorkoutActivityAttributes>?
    private static weak var profile: UserProfile?
    private static weak var store: TrainingStore?

    /// Einmal beim App-Start: Knöpfe verbinden, alte Live Activities aufräumen
    static func install(profile: UserProfile, store: TrainingStore) {
        self.profile = profile
        self.store = store
        let flow = WorkoutFlow.shared
        flow.onChange = { update() }
        WorkoutControl.handler = { action in
            switch action {
            case .togglePause:
                if flow.state == .idle { flow.start() } else { flow.togglePause() }
            case .setDone: flow.logSuggestedSet()
            case .nextExercise: flow.completeStep()
            case .end: flow.finish()
            }
        }
        // Nach einem Neustart der App gibt es kein laufendes Training mehr
        if !flow.isActive {
            for a in Activity<WorkoutActivityAttributes>.activities {
                Task { await a.end(nil, dismissalPolicy: .immediate) }
            }
        }
        refreshPlan()
    }

    /// Heutige Einheit für die Widgets (wenn gerade kein Training läuft)
    static func refreshPlan() {
        guard !WorkoutFlow.shared.isActive, let profile, let store else { return }
        let week = CoachEngine.week(profile: profile)
        let i = WorkoutFlowBuilder.todayIndex
        guard week.indices.contains(i) else { return }
        let today = week[i]
        let days = PlanBuilder.plan(profile: profile)
        var items: [WidgetSnapshot.Item] = []
        switch today.kind {
        case .strength:
            if let d = today.dayIndex, days.indices.contains(d) {
                items = WorkoutFlowBuilder.strength(day: days[d], profile: profile, store: store).prefix(4).map(item)
            }
        case .run, .conditioning, .mobility:
            items = [WidgetSnapshot.Item(name: today.title, detail: today.detail)]
        case .rest:
            items = []
        }
        let snap = WidgetSnapshot(
            title: today.kind == .rest ? "Heute: Ruhetag" : "Heute: \(today.title)",
            subtitle: today.kind == .rest ? today.detail : "Aufwärmen → \(today.title) → Mobility",
            items: items, active: false, paused: false, current: nil, currentDetail: nil,
            timerStart: nil, elapsed: 0, updated: Date())
        if snap.save() { WidgetCenter.shared.reloadAllTimelines() }
    }

    private static func item(_ s: FlowStep) -> WidgetSnapshot.Item {
        WidgetSnapshot.Item(name: s.title, detail: [s.equipmentText, s.weightText, s.targetText].filter { !$0.isEmpty }.joined(separator: " · "))
    }

    /// Bei jeder Änderung des Trainings: Live Activity und Widgets aktualisieren
    static func update() {
        let flow = WorkoutFlow.shared
        writeSnapshot(flow)
        let state = contentState(flow)
        let content = ActivityContent(state: state, staleDate: nil)
        switch flow.state {
        case .running, .paused:
            if let a = activity ?? Activity<WorkoutActivityAttributes>.activities.first {
                activity = a
                Task { await a.update(content) }
            } else if ActivityAuthorizationInfo().areActivitiesEnabled {
                activity = try? Activity.request(attributes: WorkoutActivityAttributes(title: flow.title),
                                                 content: content, pushType: nil)
            }
        case .finished, .idle:
            let all = Activity<WorkoutActivityAttributes>.activities
            activity = nil
            for a in all {
                // Abschluss noch eine Weile auf dem Sperrbildschirm zeigen
                let policy: ActivityUIDismissalPolicy = flow.state == .finished ? .after(Date().addingTimeInterval(10 * 60)) : .immediate
                Task { await a.end(content, dismissalPolicy: policy) }
            }
            if flow.state == .idle { refreshPlan() }
        }
    }

    private static func contentState(_ flow: WorkoutFlow) -> WorkoutActivityAttributes.ContentState {
        let s = flow.current
        let n = flow.next
        let target: String
        if let s {
            target = s.isTimed ? s.targetText : "Satz \(min(flow.setIndex + 1, s.sets)) von \(s.sets) · \(s.reps) Wdh."
        } else {
            target = ""
        }
        return WorkoutActivityAttributes.ContentState(
            phase: s?.phase.rawValue ?? "Fertig", phaseIcon: s?.phase.icon ?? "checkmark.seal.fill",
            exercise: flow.state == .finished ? "\(flow.loggedSets) Sätze in \(WorkoutSession.clock(flow.elapsed))" : (s?.title ?? ""),
            equipment: s?.equipmentText ?? "", weight: s?.weightText ?? "", target: flow.state == .finished ? "" : target,
            isTimed: s?.isTimed ?? false,
            nextExercise: flow.state == .finished ? "" : (n?.title ?? ""),
            nextDetail: n.map { [$0.equipmentText, $0.weightText, $0.targetText].filter { !$0.isEmpty }.joined(separator: " · ") } ?? "",
            paused: flow.state == .paused, finished: flow.state == .finished,
            timerStart: flow.timerStart, elapsed: flow.elapsed, restEnd: flow.restEnd,
            step: min(flow.done.count + 1, flow.steps.count), stepCount: flow.steps.count)
    }

    private static func writeSnapshot(_ flow: WorkoutFlow) {
        guard flow.isActive else { return }
        let upcoming = flow.steps.enumerated()
            .filter { $0.offset > flow.index && !flow.done.contains($0.element.id) }
            .map(\.element)
        let cur = flow.current
        let snap = WidgetSnapshot(
            title: flow.title, subtitle: cur?.phase.rawValue ?? "",
            items: upcoming.prefix(3).map(item), active: true, paused: flow.state == .paused,
            current: cur?.title,
            currentDetail: cur.map { c in
                [c.equipmentText, c.weightText, c.isTimed ? c.targetText : "Satz \(min(flow.setIndex + 1, c.sets))/\(c.sets)"]
                    .filter { !$0.isEmpty }.joined(separator: " · ")
            },
            timerStart: flow.state == .running ? flow.timerStart : nil, elapsed: flow.elapsed, updated: Date())
        if snap.save() { WidgetCenter.shared.reloadAllTimelines() }
    }
}
