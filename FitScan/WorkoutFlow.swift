import Combine
import SwiftUI
import UIKit

// MARK: - Ablauf eines Trainingstags: Aufwärmen → Hauptteil → Mobility-Abschluss

enum FlowPhase: String, CaseIterable, Codable {
    case warmup = "Aufwärmen"
    case main = "Hauptteil"
    case cooldown = "Mobility-Abschluss"

    var icon: String {
        switch self {
        case .warmup: return "flame"
        case .main: return "dumbbell.fill"
        case .cooldown: return "figure.cooldown"
        }
    }
}

/// Ein Schritt im Ablauf: Übung mit Sätzen (Kraft) oder Zeitvorgabe (Aufwärmen, Mobility, Cardio)
struct FlowStep: Identifiable {
    let id = UUID()
    let phase: FlowPhase
    /// nil bei freien Blöcken (z. B. „5 Min. locker warm werden“ oder ein Lauf)
    let exercise: Exercise?
    let title: String
    let detail: String
    /// Kraft: Anzahl Sätze; zeitbasiert: 1
    let sets: Int
    /// Vorschlag fürs Eintragen (Kraft)
    var weightKg: Double?
    var reps: Int
    /// Zeitvorgabe in Sekunden (nil = Sätze mit Gewicht und Wiederholungen)
    let seconds: Int?
    var note: String? = nil

    var isTimed: Bool { seconds != nil }
    var equipmentText: String { exercise?.equipment.rawValue ?? "" }
    /// „60 kg“, „+10 kg“ oder leer
    var weightText: String {
        guard let w = weightKg, let ex = exercise else { return "" }
        switch ex.kind {
        case .weighted: return "\(formatKg(w)) kg"
        case .bodyweight: return w > 0 ? "+\(formatKg(w)) kg" : ""
        case .seconds: return ""
        }
    }
    var targetText: String {
        if let s = seconds { return s >= 120 ? "\(s / 60) Min." : "\(s) s" }
        guard let ex = exercise else { return detail }
        return ex.kind == .seconds ? "\(sets) × \(reps) s" : "\(sets) × \(reps)"
    }
}

enum WorkoutFlowBuilder {
    /// Dynamische Übungen fürs Aufwärmen (bewegen statt halten)
    private static let dynamicNames: [String] = [
        "World's Greatest Stretch", "Beinschwingen", "Katze-Kuh", "BWS-Rotation", "Wall Slides",
        "Stab-Dislokation", "Knie zur Wand", "Cossack-Squat", "Handgelenk-Rocking", "Tiefe Hocke"
    ]

    /// Körperregionen, die zu den Übungen des Tages passen
    static func regions(for exercises: [Exercise]) -> [MobilityRegion] {
        let m = Set(exercises.flatMap(\.primary))
        var r: [MobilityRegion] = []
        let legs = !m.isDisjoint(with: [.quads, .hamstrings, .glutes, .adductors, .hipFlexors, .calves])
        let upper = !m.isDisjoint(with: [.chest, .shoulders, .triceps, .lats, .traps, .biceps])
        if legs { r += [.hip, .legs, .ankle] }
        if upper { r += [.shoulder, .back] }
        if r.isEmpty { r = [.hip, .shoulder, .back] }
        return r
    }

    static func warmup(regions: [MobilityRegion], profile: UserProfile) -> [FlowStep] {
        let general = FlowStep(
            phase: .warmup, exercise: nil, title: "Locker warm werden",
            detail: profile.allows(.cardioGear)
                ? "5 Min. Rad, Crosstrainer oder Rudergerät, bis du leicht ins Schwitzen kommst"
                : "5 Min. Hampelmänner, Kniehebelauf und Armkreisen im Wechsel",
            sets: 1, weightKg: nil, reps: 0, seconds: 300)
        var picks: [Exercise] = []
        for region in regions {
            let options = dynamicNames.compactMap { ExerciseCatalog.exercise(named: $0) }
                .filter { $0.region == region && profile.canDo($0) && !picks.contains($0) }
            if let ex = options.first { picks.append(ex) }
            if picks.count == 3 { break }
        }
        if picks.count < 3 {
            for n in dynamicNames {
                guard let ex = ExerciseCatalog.exercise(named: n), profile.canDo(ex), !picks.contains(ex) else { continue }
                picks.append(ex)
                if picks.count == 3 { break }
            }
        }
        let dynamic: [FlowStep] = picks.map { ex in
            let s = min(ex.seconds ?? 30, 30) * (ex.perSide ? 2 : 1)
            return FlowStep(phase: .warmup, exercise: ex, title: ex.name, detail: "Locker und kontrolliert, nicht in den Schmerz",
                            sets: 1, weightKg: nil, reps: 0, seconds: s)
        }
        return [general] + dynamic
    }

    static func cooldown(regions: [MobilityRegion], avoid: [Exercise], profile: UserProfile, logs: [MobilityLog]) -> [FlowStep] {
        let lastDone: (Exercise) -> Date = { ex in logs.filter { $0.exercise == ex.name }.map(\.date).max() ?? .distantPast }
        var picks: [Exercise] = []
        for region in regions {
            let options = ExerciseCatalog.mobility(in: region)
                .filter { profile.canDo($0) && !avoid.contains($0) && !picks.contains($0) }
            if let ex = options.min(by: { lastDone($0) < lastDone($1) }) { picks.append(ex) }
            if picks.count == 3 { break }
        }
        // eine vernachlässigte Region dazu (wie in der Mobility-Empfehlung)
        if let extra = MobilityPlanner.picks(profile: profile, logs: logs, count: 3)
            .map(\.exercise).first(where: { !picks.contains($0) && !avoid.contains($0) }), picks.count < 4 {
            picks.append(extra)
        }
        return picks.map { ex in
            FlowStep(phase: .cooldown, exercise: ex, title: ex.name, detail: ex.dose.isEmpty ? "Ruhig atmen und halten" : ex.dose,
                     sets: 1, weightKg: nil, reps: 0, seconds: (ex.seconds ?? 40) * (ex.perSide ? 2 : 1))
        }
    }

    /// Hauptteil aus einem Krafttag des Plans, mit Gewichtsvorschlag aus dem Verlauf
    static func strength(day: TrainingDay, profile: UserProfile, store: TrainingStore) -> [FlowStep] {
        let plan = profile.effectivePlan
        return day.items.enumerated().map { i, item in
            let ex = item.exercise
            let rec = Progression.recommend(exercise: ex, goal: profile.goal, plan: plan,
                                            sessions: store.sessions(for: ex.name), bodyWeight: profile.weightKg)
            let last = store.sessions(for: ex.name).last
            let reps: Int
            switch ex.kind {
            case .weighted: reps = plan.reps.lowerBound
            case .bodyweight: reps = min(Progression.bodyweightReps.upperBound, (last?.map(\.reps).min() ?? 7) + 1)
            case .seconds: reps = (last?.map(\.reps).max()).map { $0 + 5 } ?? 30
            }
            var step = FlowStep(phase: .main, exercise: ex, title: ex.name,
                                detail: Progression.prescription(for: ex, plan: plan),
                                sets: plan.sets.lowerBound, weightKg: rec.weightKg, reps: reps, seconds: nil)
            if i == 0 && ex.kind == .weighted {
                step.note = "Vorher 2 leichte Aufwärmsätze: etwa 50 % × 10 und 70 % × 5."
            }
            return step
        }
    }

    /// Lauf, Athletik oder lockeres Cardio als Hauptteil
    static func cardio(_ s: WeekSession) -> [FlowStep] {
        [FlowStep(phase: .main, exercise: nil, title: s.title, detail: s.detail, sets: 1, weightKg: nil, reps: 0, seconds: 30 * 60)]
    }

    /// Mobility-Tag: längerer Block aus der Mobility-Empfehlung
    static func mobilityDay(profile: UserProfile, logs: [MobilityLog]) -> [FlowStep] {
        MobilityPlanner.picks(profile: profile, logs: logs, count: 6).map { p in
            let ex = p.exercise
            return FlowStep(phase: .main, exercise: ex, title: ex.name, detail: p.reason,
                            sets: 1, weightKg: nil, reps: 0, seconds: (ex.seconds ?? 40) * (ex.perSide ? 2 : 1))
        }
    }

    /// Vollständiger Tag: Aufwärmen, Hauptteil, Mobility-Abschluss
    static func build(main: [FlowStep], profile: UserProfile, store: TrainingStore) -> [FlowStep] {
        let exercises = main.compactMap(\.exercise)
        var areas = regions(for: exercises.filter { !$0.isMobility })
        if exercises.isEmpty || exercises.allSatisfy(\.isMobility) {
            // Lauf/Cardio: Hüfte, Beine, Sprunggelenk
            areas = [.hip, .legs, .ankle]
        }
        let warm = warmup(regions: areas, profile: profile)
        let cool = cooldown(regions: areas, avoid: warm.compactMap(\.exercise) + exercises, profile: profile, logs: store.mobility)
        return warm + main + cool
    }

    /// Index des heutigen Tages in der Woche (Mo = 0)
    static var todayIndex: Int { (Calendar.current.component(.weekday, from: Date()) + 5) % 7 }
}

// MARK: - Laufender Trainingstag

/// Steuert den Ablauf: Start, Pause, Fortsetzen, Satz fertig, Übung fertig, Beenden.
/// Eine Instanz für die ganze App, damit Sperrbildschirm und Widgets dieselbe Einheit steuern.
@MainActor
final class WorkoutFlow: ObservableObject {
    static let shared = WorkoutFlow()

    enum State: String { case idle, running, paused, finished }

    @Published private(set) var title = ""
    @Published private(set) var steps: [FlowStep] = []
    @Published private(set) var index = 0
    /// erledigte Sätze der aktuellen Übung
    @Published private(set) var setIndex = 0
    @Published private(set) var state: State = .idle
    /// Trainingszeit ohne Pausen
    @Published private(set) var elapsed = 0
    /// Zeit in der aktuellen Übung
    @Published private(set) var stepElapsed = 0
    @Published private(set) var restEnd: Date?
    @Published private(set) var loggedSets = 0
    @Published private(set) var done: Set<UUID> = []
    @Published private(set) var startedAt: Date?

    weak var store: TrainingStore?
    weak var sessionLog: SessionLog?
    var bodyWeightKg = 80.0
    var restSeconds = 90

    private var accumulated: TimeInterval = 0
    private var runningSince: Date?
    private var stepStartElapsed = 0
    private var timer: Timer?

    var current: FlowStep? { steps.indices.contains(index) ? steps[index] : nil }
    var next: FlowStep? { steps.indices.contains(index + 1) ? steps[index + 1] : nil }
    var isActive: Bool { state == .running || state == .paused }
    var phase: FlowPhase? { current?.phase }
    /// Startzeitpunkt, so verschoben, dass „jetzt − Start“ die Trainingszeit ohne Pausen ergibt (für Live-Timer)
    var timerStart: Date { Date().addingTimeInterval(-Double(elapsed)) }

    func load(title: String, steps: [FlowStep]) {
        guard !isActive else { return }
        self.title = title
        self.steps = steps
        index = 0; setIndex = 0; elapsed = 0; stepElapsed = 0; loggedSets = 0
        done = []; restEnd = nil; startedAt = nil
        accumulated = 0; runningSince = nil; stepStartElapsed = 0
        state = .idle
        changed()
    }

    func start() {
        guard state == .idle, !steps.isEmpty else { return }
        startedAt = Date()
        runningSince = Date()
        state = .running
        startTimer()
        changed()
    }

    func pause() {
        guard state == .running else { return }
        tick()
        accumulated = Double(elapsed)
        runningSince = nil
        restEnd = nil
        state = .paused
        changed()
    }

    func resume() {
        guard state == .paused else { return }
        runningSince = Date()
        state = .running
        changed()
    }

    func togglePause() { state == .running ? pause() : resume() }

    /// Satz eintragen und weiterzählen; nach dem letzten Satz geht es zur nächsten Übung
    func logSet(weightKg: Double, reps: Int) {
        guard let step = current, let ex = step.exercise, !step.isTimed else { return }
        if state == .idle { start() }
        if state == .paused { resume() }
        store?.addSet(exercise: ex.name, weightKg: ex.kind == .seconds ? 0 : weightKg, reps: reps)
        steps[index].weightKg = weightKg
        steps[index].reps = reps
        loggedSets += 1
        setIndex += 1
        if setIndex >= step.sets {
            advance()
        } else {
            restEnd = Date().addingTimeInterval(Double(restSeconds))
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            changed()
        }
    }

    /// Satz mit dem Vorschlag eintragen (Sperrbildschirm)
    func logSuggestedSet() {
        guard let step = current else { return }
        if step.isTimed { completeStep() } else { logSet(weightKg: step.weightKg ?? 0, reps: step.reps) }
    }

    /// Übung fertig (restliche Sätze auslassen) und weiter
    func completeStep() {
        guard current != nil else { return }
        if state == .idle { start() }
        if state == .paused { resume() }
        advance()
    }

    /// Springt zu einem Schritt (z. B. Übung vorziehen, weil das Gerät besetzt ist)
    func jump(to id: UUID) {
        guard let i = steps.firstIndex(where: { $0.id == id }), i != index else { return }
        index = i
        setIndex = 0
        restEnd = nil
        stepStartElapsed = elapsed
        stepElapsed = 0
        changed()
    }

    func skipRest() {
        restEnd = nil
        changed()
    }

    /// Training beenden und als Einheit ins Protokoll schreiben
    func finish() {
        guard isActive else { return }
        tick()
        timer?.invalidate(); timer = nil
        runningSince = nil
        restEnd = nil
        state = .finished
        if elapsed >= 60, let log = sessionLog, let start = startedAt {
            let kcal = Int((WorkoutKind.strength.met * bodyWeightKg * Double(elapsed) / 3600).rounded())
            log.entries.insert(SessionEntry(date: start, kind: .strength, seconds: elapsed, steps: 0, distanceM: 0, kcal: kcal), at: 0)
        }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        changed()
    }

    /// Nach dem Ende wieder auf Anfang (neuer Tag kann geladen werden)
    func reset() {
        guard !isActive else { return }
        state = .idle
        steps = []
        title = ""
        changed()
    }

    private func advance() {
        guard let step = current else { return }
        done.insert(step.id)
        if let ex = step.exercise, ex.isMobility { store?.addMobility(ex) }
        restEnd = nil
        setIndex = 0
        stepStartElapsed = elapsed
        stepElapsed = 0
        if let nextIndex = steps.indices.first(where: { $0 > index && !done.contains(steps[$0].id) })
            ?? steps.indices.first(where: { !done.contains(steps[$0].id) }) {
            index = nextIndex
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            changed()
        } else {
            finish()
        }
    }

    private func startTimer() {
        timer?.invalidate()
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func tick() {
        guard let since = runningSince else { return }
        elapsed = Int(accumulated + Date().timeIntervalSince(since))
        stepElapsed = max(0, elapsed - stepStartElapsed)
        if let r = restEnd, r <= Date() {
            restEnd = nil
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            changed()
        }
    }

    /// Hook für Sperrbildschirm und Widgets (wird im Widget-Teil gesetzt)
    var onChange: (() -> Void)?
    private func changed() { onChange?() }
}

// MARK: - Ansicht

struct WorkoutFlowView: View {
    /// fester Krafttag aus dem Plan (nil = heutige Einheit laut Wochenplan)
    var dayIndex: Int? = nil

    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var store: TrainingStore
    @EnvironmentObject var sessionLog: SessionLog
    @ObservedObject private var flow = WorkoutFlow.shared

    @State private var weight: Double = 20
    @State private var reps: Int = 8
    @State private var choice: Int? = nil
    @State private var confirmEnd = false

    private var days: [TrainingDay] { PlanBuilder.plan(profile: profile) }
    private var today: WeekSession? {
        let week = CoachEngine.week(profile: profile)
        return week.indices.contains(WorkoutFlowBuilder.todayIndex) ? week[WorkoutFlowBuilder.todayIndex] : nil
    }

    var body: some View {
        List {
            if flow.steps.isEmpty {
                chooser
            } else if flow.state == .finished {
                summary
            } else {
                phaseHeader
                currentSection
                controls
                nextSection
                overview
            }
        }
        .navigationTitle(flow.title.isEmpty ? "Trainingstag" : flow.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: prepare)
        .onChange(of: flow.index) { _, _ in prefill() }
        .onChange(of: flow.setIndex) { _, _ in prefill() }
        .confirmationDialog("Training beenden?", isPresented: $confirmEnd, titleVisibility: .visible) {
            Button("Beenden und speichern", role: .destructive) { flow.finish() }
            Button("Weiter trainieren", role: .cancel) {}
        } message: {
            Text("Eingetragene Sätze bleiben gespeichert. Die Einheit landet mit Dauer im Trainingsprotokoll.")
        }
    }

    // MARK: Vorbereitung

    private func prepare() {
        flow.store = store
        flow.sessionLog = sessionLog
        flow.bodyWeightKg = profile.weightKg
        flow.restSeconds = profile.restSeconds
        if flow.isActive { prefill(); return }
        if flow.state == .finished { return }
        if let i = dayIndex ?? choice {
            load(dayAt: i)
        } else if let s = today {
            switch s.kind {
            case .strength:
                load(dayAt: s.dayIndex ?? 0)
            case .run, .conditioning:
                flow.load(title: s.title, steps: WorkoutFlowBuilder.build(main: WorkoutFlowBuilder.cardio(s), profile: profile, store: store))
            case .mobility:
                flow.load(title: "Mobility", steps: WorkoutFlowBuilder.build(
                    main: WorkoutFlowBuilder.mobilityDay(profile: profile, logs: store.mobility), profile: profile, store: store))
            case .rest:
                flow.reset()
            }
        }
        prefill()
    }

    private func load(dayAt i: Int) {
        guard days.indices.contains(i) else { return }
        let d = days[i]
        flow.load(title: "Tag \(i + 1): \(d.name)",
                  steps: WorkoutFlowBuilder.build(main: WorkoutFlowBuilder.strength(day: d, profile: profile, store: store),
                                                  profile: profile, store: store))
        prefill()
    }

    private func prefill() {
        guard let s = flow.current else { return }
        weight = s.weightKg ?? (s.exercise?.kind == .weighted ? 20 : 0)
        reps = max(1, s.reps)
    }

    // MARK: Auswahl (Ruhetag oder nach dem Training)

    private var chooser: some View {
        Group {
            Section {
                if let s = today, s.kind == .rest {
                    Label("Heute ist laut Wochenplan Ruhetag: \(s.detail).", systemImage: "bed.double")
                }
                Text("Wähle eine Einheit. Jede beginnt mit lockerem Aufwärmen und dynamischer Mobility und endet mit einem Mobility-Abschluss.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Section("Krafttage") {
                ForEach(Array(days.enumerated()), id: \.element.id) { i, d in
                    Button {
                        choice = i
                        load(dayAt: i)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tag \(i + 1): \(d.name)").foregroundStyle(.primary)
                            Text(d.subtitle).font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            Section {
                Button {
                    flow.load(title: "Mobility", steps: WorkoutFlowBuilder.build(
                        main: WorkoutFlowBuilder.mobilityDay(profile: profile, logs: store.mobility), profile: profile, store: store))
                    prefill()
                } label: { Label("Mobility-Einheit", systemImage: "figure.flexibility") }
            }
        }
    }

    // MARK: Phasen

    private var phaseHeader: some View {
        Section {
            HStack(spacing: 8) {
                ForEach(FlowPhase.allCases, id: \.self) { p in
                    let stepsIn = flow.steps.filter { $0.phase == p }
                    let finished = !stepsIn.isEmpty && stepsIn.allSatisfy { flow.done.contains($0.id) }
                    let active = flow.phase == p
                    VStack(spacing: 4) {
                        Image(systemName: finished ? "checkmark.circle.fill" : p.icon)
                            .font(.title3)
                            .foregroundStyle(finished ? Color.green : (active ? Color.accentColor : Color.secondary))
                        Text(p.rawValue).font(.caption2).multilineTextAlignment(.center)
                            .foregroundStyle(active ? Color.primary : Color.secondary)
                        Text("\(stepsIn.filter { flow.done.contains($0.id) }.count)/\(stepsIn.count)")
                            .font(.caption2.monospacedDigit()).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .opacity(stepsIn.isEmpty ? 0.4 : 1)
                }
            }
            HStack {
                Label(WorkoutSession.clock(flow.elapsed), systemImage: flow.state == .paused ? "pause.circle" : "timer")
                    .font(.headline.monospacedDigit())
                Spacer()
                Text("\(flow.loggedSets) Sätze").font(.subheadline).foregroundStyle(.secondary)
            }
        }
    }

    // MARK: Aktuelle Übung

    @ViewBuilder
    private var currentSection: some View {
        if let s = flow.current {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Label(s.phase.rawValue, systemImage: s.phase.icon).font(.caption).foregroundStyle(.tint)
                    Text(s.title).font(.title2.bold())
                    Text(s.detail).font(.subheadline).foregroundStyle(.secondary)
                    HStack(spacing: 12) {
                        if !s.equipmentText.isEmpty { Label(s.equipmentText, systemImage: s.exercise?.equipment.icon ?? "dumbbell") }
                        if !s.weightText.isEmpty { Label(s.weightText, systemImage: "scalemass") }
                        if !s.isTimed { Label("Satz \(min(flow.setIndex + 1, s.sets)) von \(s.sets)", systemImage: "number") }
                    }
                    .font(.footnote)
                    if let note = s.note, flow.setIndex == 0 {
                        Label(note, systemImage: "info.circle").font(.footnote).foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)

                if let end = flow.restEnd, flow.state == .running {
                    HStack {
                        Label("Pause", systemImage: "hourglass")
                        Spacer()
                        Text(timerInterval: Date()...max(Date(), end), countsDown: true)
                            .font(.title3.monospacedDigit().bold())
                        Button("Überspringen") { flow.skipRest() }.buttonStyle(.borderless)
                    }
                }

                if let total = s.seconds {
                    let left = max(0, total - flow.stepElapsed)
                    VStack(spacing: 6) {
                        Text(flow.state == .idle ? s.targetText : (left > 0 ? WorkoutSession.clock(left) : "Geschafft"))
                            .font(.system(size: 40, weight: .semibold, design: .rounded)).monospacedDigit()
                        ProgressView(value: Double(min(flow.stepElapsed, total)), total: Double(max(total, 1)))
                    }
                    .frame(maxWidth: .infinity)
                    Button {
                        flow.completeStep()
                    } label: {
                        Label("Erledigt, weiter", systemImage: "checkmark.circle.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else if let ex = s.exercise {
                    switch ex.kind {
                    case .weighted:
                        Stepper(value: $weight, in: 0...500, step: 2.5) { Text("Gewicht: \(formatKg(weight)) kg") }
                        Stepper(value: $reps, in: 1...50) { Text("Wiederholungen: \(reps)") }
                    case .bodyweight:
                        Stepper(value: $reps, in: 1...100) { Text("Wiederholungen: \(reps)") }
                        Stepper(value: $weight, in: 0...100, step: 2.5) { Text("Zusatzgewicht: \(formatKg(weight)) kg") }
                    case .seconds:
                        Stepper(value: $reps, in: 5...600, step: 5) { Text("Dauer: \(reps) s") }
                    }
                    let candidate = SetLog(exercise: ex.name, date: Date(), weightKg: ex.kind == .seconds ? 0 : weight, reps: reps)
                    if let pct = Progression.change(of: candidate, in: store.sets) {
                        HStack {
                            Text("Gegenüber der letzten Einheit").font(.footnote).foregroundStyle(.secondary)
                            Spacer()
                            PercentBadge(value: pct)
                        }
                    }
                    Button {
                        flow.logSet(weightKg: weight, reps: reps)
                    } label: {
                        Label("Satz fertig", systemImage: "checkmark.circle.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    let todaySets = store.sets.filter { $0.exercise == ex.name && Calendar.current.isDateInToday($0.date) }
                    ForEach(todaySets) { set in
                        HStack {
                            Text(set.date, format: .dateTime.hour().minute()).foregroundStyle(.secondary)
                            Spacer()
                            Text(ex.kind == .seconds ? "\(set.reps) s" : "\(formatKg(set.weightKg)) kg × \(set.reps)")
                            PercentBadge(value: Progression.change(of: set, in: store.sets))
                        }
                        .font(.footnote)
                    }
                }
            }
        }
    }

    // MARK: Steuerung

    private var controls: some View {
        Section {
            switch flow.state {
            case .idle:
                Button { flow.start() } label: {
                    Label("Training starten", systemImage: "play.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            case .running, .paused:
                HStack {
                    Button { flow.togglePause() } label: {
                        Label(flow.state == .paused ? "Fortsetzen" : "Pause",
                              systemImage: flow.state == .paused ? "play.fill" : "pause.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    Button { flow.completeStep() } label: {
                        Label("Übung fertig", systemImage: "forward.end.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                Button(role: .destructive) { confirmEnd = true } label: {
                    Label("Training beenden", systemImage: "stop.fill").frame(maxWidth: .infinity)
                }
            case .finished:
                EmptyView()
            }
        } footer: {
            Text("Pause hält die Trainingszeit an. „Übung fertig“ springt zur nächsten Übung, auch wenn noch Sätze offen sind.")
        }
    }

    @ViewBuilder
    private var nextSection: some View {
        if let n = flow.next {
            Section("Als Nächstes") {
                HStack(spacing: 12) {
                    Image(systemName: n.phase.icon).foregroundStyle(.tint).frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(n.title).bold()
                        Text([n.equipmentText, n.weightText, n.targetText].filter { !$0.isEmpty }.joined(separator: " · "))
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var overview: some View {
        ForEach(FlowPhase.allCases, id: \.self) { p in
            let stepsIn = flow.steps.filter { $0.phase == p }
            if !stepsIn.isEmpty {
                Section(p.rawValue) {
                    ForEach(stepsIn) { s in
                        Button { flow.jump(to: s.id) } label: {
                            HStack {
                                Image(systemName: flow.done.contains(s.id) ? "checkmark.circle.fill"
                                      : (s.id == flow.current?.id ? "arrow.right.circle.fill" : "circle"))
                                    .foregroundStyle(flow.done.contains(s.id) ? Color.green : Color.accentColor)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(s.title).foregroundStyle(.primary)
                                    Text([s.equipmentText, s.weightText, s.targetText].filter { !$0.isEmpty }.joined(separator: " · "))
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: Abschluss

    private var summary: some View {
        Group {
            Section {
                Label("Training abgeschlossen", systemImage: "checkmark.seal.fill").font(.title3.bold()).foregroundStyle(.green)
                LabeledContent("Dauer", value: WorkoutSession.clock(flow.elapsed))
                LabeledContent("Sätze", value: "\(flow.loggedSets)")
                LabeledContent("Erledigte Übungen", value: "\(flow.done.count) von \(flow.steps.count)")
            }
            let names = Set(flow.steps.filter { $0.phase == .main }.compactMap { $0.exercise?.name })
            let todays = store.sets.filter { names.contains($0.exercise) && Calendar.current.isDateInToday($0.date) }
            let byExercise = Dictionary(grouping: todays, by: \.exercise)
            if !byExercise.isEmpty {
                Section("Leistung gegenüber der letzten Einheit") {
                    ForEach(byExercise.keys.sorted(), id: \.self) { name in
                        let best = byExercise[name]?.max { $0.e1RM < $1.e1RM }
                        HStack {
                            Text(name)
                            Spacer()
                            PercentBadge(value: best.flatMap { Progression.change(of: $0, in: store.sets) })
                        }
                    }
                }
            }
            Section {
                Button("Neue Einheit wählen") { flow.reset(); choice = nil }
            }
        }
    }
}
