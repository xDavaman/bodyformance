import Combine
import CoreMotion
import SwiftUI

// Live-Schrittzähler (iPhone-Bewegungssensor) und Trainings-Aufzeichnung (Zeit, Schritte, Strecke, Tempo, Kalorien).

@MainActor
final class StepTracker: ObservableObject {
    @Published var steps = 0
    @Published var distanceM = 0.0
    @Published var live = false
    let available = CMPedometer.isStepCountingAvailable()
    private let pedometer = CMPedometer()

    /// Zählt ab heute 0 Uhr live mit. Das iPhone liefert die Werte laufend, auch aus der Zeit, in der die App zu war.
    func start() {
        guard available else { return }
        pedometer.stopUpdates()
        let midnight = Calendar.current.startOfDay(for: Date())
        pedometer.startUpdates(from: midnight) { [weak self] data, _ in
            guard let d = data else { return }
            let s = d.numberOfSteps.intValue
            let m = d.distance?.doubleValue ?? 0
            Task { @MainActor in
                self?.steps = s
                self?.distanceM = m
                self?.live = true
            }
        }
    }

    func stop() {
        pedometer.stopUpdates()
        live = false
    }
}

enum WorkoutKind: String, CaseIterable, Identifiable, Codable {
    case strength = "Krafttraining"
    case run = "Laufen"
    case hybrid = "Hybrid"
    case walk = "Gehen"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .strength: return "figure.strengthtraining.traditional"
        case .run: return "figure.run"
        case .hybrid: return "figure.cross.training"
        case .walk: return "figure.walk"
        }
    }
    /// Grober Energieverbrauch (MET)
    var met: Double {
        switch self {
        case .strength: return 5.0
        case .run: return 9.8
        case .hybrid: return 7.0
        case .walk: return 3.8
        }
    }
}

struct SessionEntry: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var kind: WorkoutKind
    var seconds: Int
    var steps: Int
    var distanceM: Double
    var kcal: Int
}

final class SessionLog: ObservableObject {
    @Published var entries: [SessionEntry] = [] { didSet { save() } }
    init() {
        if let d = UserDefaults.standard.data(forKey: "sessionLog"),
           let v = try? JSONDecoder().decode([SessionEntry].self, from: d) { entries = v }
    }
    private func save() {
        if let d = try? JSONEncoder().encode(entries) { UserDefaults.standard.set(d, forKey: "sessionLog") }
    }
}

@MainActor
final class WorkoutSession: ObservableObject {
    @Published var running = false
    @Published var kind: WorkoutKind = .strength
    @Published var elapsed = 0
    @Published var steps = 0
    @Published var distanceM = 0.0
    /// Aktuelles Lauftempo in Sekunden pro Kilometer (nil, wenn unbekannt)
    @Published var paceSecPerKm: Double?
    @Published var kcal = 0

    private let pedometer = CMPedometer()
    private var start = Date()
    private var timer: Timer?
    private var weightKg = 80.0
    let available = CMPedometer.isStepCountingAvailable()

    func begin(kind: WorkoutKind, weightKg: Double) {
        guard !running else { return }
        self.kind = kind
        self.weightKg = weightKg
        start = Date()
        elapsed = 0; steps = 0; distanceM = 0; paceSecPerKm = nil; kcal = 0
        running = true
        if available {
            pedometer.startUpdates(from: start) { [weak self] data, _ in
                guard let d = data else { return }
                let s = d.numberOfSteps.intValue
                let m = d.distance?.doubleValue ?? 0
                let p = d.currentPace?.doubleValue
                Task { @MainActor in
                    self?.steps = s
                    self?.distanceM = m
                    self?.paceSecPerKm = (p != nil && p! > 0) ? p! * 1000 : nil
                }
            }
        }
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func tick() {
        elapsed = Int(Date().timeIntervalSince(start))
        kcal = estimateKcal()
    }

    private func estimateKcal() -> Int {
        let hours = Double(elapsed) / 3600
        if kind == .run && distanceM > 200 { return Int((weightKg * distanceM / 1000).rounded()) }  // ca. 1 kcal je kg und km
        return Int((kind.met * weightKg * hours).rounded())
    }

    func finish(into log: SessionLog) {
        guard running else { return }
        timer?.invalidate(); timer = nil
        pedometer.stopUpdates()
        elapsed = Int(Date().timeIntervalSince(start))
        kcal = estimateKcal()
        running = false
        if elapsed >= 30 {
            log.entries.insert(SessionEntry(date: start, kind: kind, seconds: elapsed, steps: steps, distanceM: distanceM, kcal: kcal), at: 0)
        }
    }

    static func clock(_ s: Int) -> String {
        let h = s / 3600, m = (s % 3600) / 60, sec = s % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, sec) : String(format: "%02d:%02d", m, sec)
    }
    static func paceText(_ secPerKm: Double?) -> String {
        guard let p = secPerKm, p > 0, p < 1800 else { return "–" }
        return String(format: "%d:%02d /km", Int(p) / 60, Int(p) % 60)
    }
}

struct WorkoutTrackerView: View {
    @EnvironmentObject var session: WorkoutSession
    @EnvironmentObject var log: SessionLog
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var tracker: StepTracker

    var body: some View {
        List {
            Section {
                if session.running {
                    VStack(spacing: 6) {
                        Text(session.kind.rawValue).font(.headline)
                        Text(WorkoutSession.clock(session.elapsed))
                            .font(.system(size: 54, weight: .bold, design: .rounded)).monospacedDigit()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    metric("Schritte im Training", "\(session.steps)", "figure.walk")
                    metric("Strecke", String(format: "%.2f km", session.distanceM / 1000), "point.topleft.down.to.point.bottomright.curvepath")
                    metric("Tempo", WorkoutSession.paceText(session.paceSecPerKm), "speedometer")
                    metric("Kalorien (Schätzung)", "\(session.kcal) kcal", "flame")
                    Button(role: .destructive) { session.finish(into: log) } label: {
                        Label("Training beenden", systemImage: "stop.circle.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Picker("Art", selection: $session.kind) {
                        ForEach(WorkoutKind.allCases) { Label($0.rawValue, systemImage: $0.icon).tag($0) }
                    }
                    Button { session.begin(kind: session.kind, weightKg: profile.weightKg) } label: {
                        Label("Training starten", systemImage: "play.circle.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            } header: {
                Text("Training aufzeichnen")
            } footer: {
                if !session.available {
                    Text("Schritte, Strecke und Tempo werden nur auf dem iPhone gemessen. Hier laufen nur Zeit und Kalorien-Schätzung.")
                } else {
                    Text("Schritte, Strecke und Tempo kommen live vom Bewegungssensor des iPhones. Kalorien sind eine Schätzung aus Zeit, Art und Gewicht.")
                }
            }

            Section("Schritte heute") {
                metric("Live", "\(tracker.steps) von \(profile.stepGoal)", "figure.walk.motion")
            }

            Section("Verlauf") {
                if log.entries.isEmpty {
                    Text("Noch keine Einheiten aufgezeichnet.").foregroundStyle(.secondary)
                }
                ForEach(log.entries.prefix(15)) { e in
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Label(e.kind.rawValue, systemImage: e.kind.icon)
                            Spacer()
                            Text(e.date, format: .dateTime.day().month().hour().minute()).font(.footnote).foregroundStyle(.secondary)
                        }
                        Text("\(WorkoutSession.clock(e.seconds)) · \(e.steps) Schritte · \(String(format: "%.2f", e.distanceM / 1000)) km · \(e.kcal) kcal")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                }
                .onDelete { idx in
                    let ids = idx.map { log.entries[$0].id }
                    log.entries.removeAll { ids.contains($0.id) }
                }
            }
        }
        .navigationTitle("Training aufzeichnen")
    }

    private func metric(_ title: String, _ value: String, _ icon: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Text(value).font(.headline).monospacedDigit()
        }
    }
}
