import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

@main
struct BFCWidgetsBundle: WidgetBundle {
    var body: some Widget {
        NextWorkoutWidget()
        WorkoutLiveActivity()
    }
}

// MARK: - Homescreen und Sperrbildschirm: heutige Einheit und nächste Übung

struct WorkoutEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetSnapshot
}

struct WorkoutProvider: TimelineProvider {
    func placeholder(in context: Context) -> WorkoutEntry {
        WorkoutEntry(date: Date(), snapshot: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (WorkoutEntry) -> Void) {
        completion(WorkoutEntry(date: Date(), snapshot: WidgetSnapshot.load() ?? .placeholder))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WorkoutEntry>) -> Void) {
        let entry = WorkoutEntry(date: Date(), snapshot: WidgetSnapshot.load() ?? .placeholder)
        // Die App lädt die Widgets bei jeder Änderung neu; sonst stündlich
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))))
    }
}

struct NextWorkoutWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "BFCNextWorkout", provider: WorkoutProvider()) { entry in
            NextWorkoutView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Nächste Übung")
        .description("Heutige Einheit, nächste Übung mit Gerät und Gewicht, Start und Pause.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular, .accessoryInline, .accessoryCircular])
    }
}

struct NextWorkoutView: View {
    @Environment(\.widgetFamily) private var family
    let entry: WorkoutEntry

    private var s: WidgetSnapshot { entry.snapshot }

    var body: some View {
        switch family {
        case .accessoryInline:
            Text(s.active ? "BFC: \(s.current ?? s.title)" : "BFC: \(s.items.first?.name ?? s.title)")
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 0) {
                    Image(systemName: s.active ? (s.paused ? "pause.fill" : "figure.strengthtraining.traditional") : "dumbbell.fill")
                    if s.active, let start = s.timerStart, !s.paused {
                        Text(start, style: .timer).font(.system(size: 9)).monospacedDigit().multilineTextAlignment(.center)
                    } else {
                        Text("\(s.items.count)").font(.caption2)
                    }
                }
            }
            .widgetURL(WorkoutLinks.open)
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 1) {
                Text(s.active ? (s.paused ? "Pausiert" : "Jetzt") : "Nächste Übung").font(.caption2).foregroundStyle(.secondary)
                Text(s.active ? (s.current ?? "") : (s.items.first?.name ?? s.title)).font(.headline).lineLimit(1)
                Text(s.active ? (s.currentDetail ?? "") : (s.items.first?.detail ?? s.subtitle)).font(.caption).lineLimit(1)
            }
            .widgetURL(WorkoutLinks.open)
        case .systemSmall:
            small
        default:
            medium
        }
    }

    private var small: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(s.active ? (s.paused ? "Pausiert" : "Training läuft") : "Heute", systemImage: "dumbbell.fill")
                .font(.caption).foregroundStyle(.tint)
            Text(s.active ? (s.current ?? s.title) : (s.items.first?.name ?? s.title))
                .font(.headline).lineLimit(2)
            Text(s.active ? (s.currentDetail ?? "") : (s.items.first?.detail ?? s.subtitle))
                .font(.caption2).foregroundStyle(.secondary).lineLimit(2)
            Spacer(minLength: 0)
            if s.active {
                HStack {
                    Button(intent: TogglePauseWorkoutIntent()) {
                        Image(systemName: s.paused ? "play.fill" : "pause.fill")
                    }
                    Button(intent: SetDoneWorkoutIntent()) { Image(systemName: "checkmark") }
                }
                .font(.caption)
            } else {
                Link(destination: WorkoutLinks.start) {
                    Label("Start", systemImage: "play.fill").font(.caption.bold())
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetURL(WorkoutLinks.open)
    }

    private var medium: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Label(s.title, systemImage: "dumbbell.fill").font(.caption.bold()).foregroundStyle(.tint).lineLimit(1)
                if s.active {
                    Text(s.current ?? "").font(.headline).lineLimit(1)
                    Text(s.currentDetail ?? "").font(.caption).foregroundStyle(.secondary).lineLimit(1)
                    if let start = s.timerStart, !s.paused {
                        Text(start, style: .timer).font(.caption.monospacedDigit())
                    } else {
                        Text("Pausiert · \(WorkoutLinks.clock(s.elapsed))").font(.caption.monospacedDigit())
                    }
                    if let next = s.items.first {
                        Text("Danach: \(next.name) · \(next.detail)").font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                    }
                } else {
                    Text(s.subtitle).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                    ForEach(s.items.prefix(3), id: \.self) { item in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(item.name).font(.subheadline.bold()).lineLimit(1)
                            Text(item.detail).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 8) {
                if s.active {
                    Button(intent: TogglePauseWorkoutIntent()) {
                        Image(systemName: s.paused ? "play.fill" : "pause.fill").frame(width: 30)
                    }
                    Button(intent: SetDoneWorkoutIntent()) { Image(systemName: "checkmark").frame(width: 30) }
                    Button(intent: NextExerciseWorkoutIntent()) { Image(systemName: "forward.end.fill").frame(width: 30) }
                } else {
                    Link(destination: WorkoutLinks.start) {
                        Image(systemName: "play.circle.fill").font(.largeTitle)
                    }
                }
            }
        }
        .widgetURL(WorkoutLinks.open)
    }
}

// MARK: - Live Activity: Sperrbildschirm und Dynamic Island

struct WorkoutLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkoutActivityAttributes.self) { context in
            LockScreenWorkoutView(title: context.attributes.title, state: context.state)
                .padding(14)
                .activityBackgroundTint(Color.black.opacity(0.75))
                .activitySystemActionForegroundColor(.white)
                .widgetURL(WorkoutLinks.open)
        } dynamicIsland: { context in
            let st = context.state
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label(st.phase, systemImage: st.phaseIcon).font(.caption).lineLimit(1)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    WorkoutClockText(state: st).font(.caption.monospacedDigit())
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(st.exercise).font(.headline).lineLimit(1)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 6) {
                        Text([st.equipment, st.weight, st.target].filter { !$0.isEmpty }.joined(separator: " · "))
                            .font(.caption).lineLimit(1)
                        if !st.nextExercise.isEmpty {
                            Text("Danach: \(st.nextExercise)").font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                        }
                        WorkoutButtons(state: st)
                    }
                }
            } compactLeading: {
                Image(systemName: st.paused ? "pause.fill" : st.phaseIcon)
            } compactTrailing: {
                WorkoutClockText(state: st).monospacedDigit().frame(maxWidth: 52)
            } minimal: {
                Image(systemName: st.paused ? "pause.fill" : "dumbbell.fill")
            }
            .widgetURL(WorkoutLinks.open)
        }
    }
}

struct WorkoutClockText: View {
    let state: WorkoutActivityAttributes.ContentState
    var body: some View {
        if state.paused || state.finished {
            Text(WorkoutLinks.clock(state.elapsed))
        } else {
            Text(state.timerStart, style: .timer)
        }
    }
}

struct WorkoutButtons: View {
    let state: WorkoutActivityAttributes.ContentState
    var body: some View {
        if !state.finished {
            HStack(spacing: 8) {
                Button(intent: TogglePauseWorkoutIntent()) {
                    Label(state.paused ? "Weiter" : "Pause", systemImage: state.paused ? "play.fill" : "pause.fill")
                }
                .tint(.orange)
                Button(intent: SetDoneWorkoutIntent()) {
                    Label(state.isTimed ? "Erledigt" : "Satz", systemImage: "checkmark")
                }
                .tint(.green)
                Button(intent: NextExerciseWorkoutIntent()) {
                    Label("Nächste", systemImage: "forward.end.fill")
                }
                .tint(.blue)
                Button(intent: EndWorkoutIntent()) {
                    Label("Ende", systemImage: "stop.fill")
                }
                .tint(.red)
            }
            .font(.caption2.bold())
            .buttonStyle(.borderedProminent)
            .labelStyle(.titleAndIcon)
        }
    }
}

struct LockScreenWorkoutView: View {
    let title: String
    let state: WorkoutActivityAttributes.ContentState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(state.finished ? "Training beendet" : state.phase, systemImage: state.finished ? "checkmark.seal.fill" : state.phaseIcon)
                    .font(.caption.bold())
                    .foregroundStyle(.orange)
                Spacer()
                if state.paused { Text("Pausiert").font(.caption.bold()).foregroundStyle(.yellow) }
                WorkoutClockText(state: state).font(.caption.monospacedDigit()).foregroundStyle(.white)
            }
            HStack(alignment: .firstTextBaseline) {
                Text(state.exercise).font(.title3.bold()).foregroundStyle(.white).lineLimit(1)
                Spacer()
                Text("\(state.step)/\(state.stepCount)").font(.caption2).foregroundStyle(.white.opacity(0.7))
            }
            Text([state.equipment, state.weight, state.target].filter { !$0.isEmpty }.joined(separator: " · "))
                .font(.subheadline).foregroundStyle(.white.opacity(0.9)).lineLimit(1)
            if let rest = state.restEnd, rest > Date(), !state.paused {
                HStack(spacing: 4) {
                    Image(systemName: "hourglass")
                    Text("Satzpause")
                    Text(timerInterval: Date()...rest, countsDown: true).monospacedDigit()
                }
                .font(.caption).foregroundStyle(.cyan)
            }
            if !state.nextExercise.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.turn.down.right")
                    Text("Als Nächstes: \(state.nextExercise)").bold()
                    if !state.nextDetail.isEmpty { Text("· \(state.nextDetail)") }
                }
                .font(.caption).foregroundStyle(.white.opacity(0.8)).lineLimit(1)
            }
            WorkoutButtons(state: state)
        }
    }
}
