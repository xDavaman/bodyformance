import Combine
import CoreLocation
import CoreMotion
import MapKit
import SwiftUI

// Live-Schrittzähler (iPhone-Bewegungssensor) und Trainings-Aufzeichnung (Zeit, Schritte, Strecke, Tempo, Kalorien).

@MainActor
final class StepTracker: ObservableObject {
    @Published var steps = 0
    @Published var distanceM = 0.0
    @Published var live = false
    let available = CMPedometer.isStepCountingAvailable()
    private let pedometer = CMPedometer()
    private var startDay = Date.distantPast
    private var dayObserver: NSObjectProtocol?

    init() {
        // Um Mitternacht neu ab 0 zählen, auch wenn die App offen bleibt
        dayObserver = NotificationCenter.default.addObserver(forName: .NSCalendarDayChanged, object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor in self?.restartIfNewDay() }
        }
    }

    private func restartIfNewDay() {
        guard live, !Calendar.current.isDateInToday(startDay) else { return }
        steps = 0
        distanceM = 0
        start()
    }

    /// Zählt ab heute 0 Uhr live mit. Das iPhone liefert die Werte laufend, auch aus der Zeit, in der die App zu war.
    func start() {
        guard available else { return }
        pedometer.stopUpdates()
        let midnight = Calendar.current.startOfDay(for: Date())
        if !Calendar.current.isDateInToday(startDay) { steps = 0; distanceM = 0 }
        startDay = midnight
        pedometer.startUpdates(from: midnight) { [weak self] data, _ in
            guard let d = data else { return }
            let s = d.numberOfSteps.intValue
            let m = d.distance?.doubleValue ?? 0
            Task { @MainActor in
                // verspätete Werte vom Vortag nicht übernehmen
                guard let self, Calendar.current.isDateInToday(self.startDay) else { return }
                self.steps = s
                self.distanceM = m
                self.live = true
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
    case treadmill = "Laufband"
    case outdoor = "Draußen trainieren"
    case home = "Zuhause"
    var id: String { rawValue }
    /// Anzeigename in der Auswahl „Was machst du gerade?“
    var label: String {
        switch self {
        case .strength: return "Gym"
        case .run: return "Laufen draußen"
        case .hybrid: return "Hybrid"
        case .walk: return "Gehen / Spazieren"
        case .treadmill: return "Laufband"
        case .outdoor: return "Draußen trainieren"
        case .home: return "Zuhause"
        }
    }
    /// Arten, bei denen die Strecke per GPS aufgezeichnet und live auf der Karte gezeigt wird.
    var tracksRoute: Bool { self == .run || self == .walk || self == .outdoor }
    static var pickerOrder: [WorkoutKind] { [.strength, .treadmill, .run, .walk, .outdoor, .home] }
    var icon: String {
        switch self {
        case .strength: return "figure.strengthtraining.traditional"
        case .run: return "figure.run"
        case .hybrid: return "figure.cross.training"
        case .walk: return "figure.walk"
        case .treadmill: return "figure.run.treadmill"
        case .outdoor: return "figure.cross.training"
        case .home: return "figure.core.training"
        }
    }
    /// Grober Energieverbrauch (MET)
    var met: Double {
        switch self {
        case .strength: return 5.0
        case .run: return 9.8
        case .hybrid: return 7.0
        case .walk: return 3.8
        case .treadmill: return 9.0
        case .outdoor: return 6.5
        case .home: return 4.5
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
    /// GPS-Strecke (nur bei Laufen, Gehen, Draußen trainieren)
    var route: [RoutePoint]? = nil
    /// UUID des Workouts in Apple Health (Apple Watch, Garmin & Co.), damit nichts doppelt landet
    var healthID: String? = nil
    var source: String? = nil
}

struct RoutePoint: Codable, Equatable {
    var lat: Double
    var lon: Double
    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: lat, longitude: lon) }
}

/// Zeichnet die Strecke per GPS auf (nur während eines Trainings, nur wenn die App Standort darf).
@MainActor
final class RouteRecorder: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var points: [RoutePoint] = []
    @Published var distance = 0.0
    @Published var denied = false
    private let manager = CLLocationManager()
    private var last: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        manager.activityType = .fitness
    }

    func start() {
        points = []; distance = 0; last = nil; denied = false
        manager.requestWhenInUseAuthorization()
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted { denied = true; return }
        // Hintergrund-GPS (gesperrter Bildschirm) nur, wenn die Fähigkeit wirklich im Projekt eingetragen ist – sonst würde iOS die App beenden.
        let modes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String] ?? []
        if modes.contains("location") {
            manager.allowsBackgroundLocationUpdates = true
            manager.pausesLocationUpdatesAutomatically = false
            manager.showsBackgroundLocationIndicator = true
        }
        manager.startUpdatingLocation()
    }

    func stop() {
        manager.stopUpdatingLocation()
        if manager.allowsBackgroundLocationUpdates { manager.allowsBackgroundLocationUpdates = false }
    }

    nonisolated func locationManager(_ m: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        Task { @MainActor in
            for l in locs where l.horizontalAccuracy >= 0 && l.horizontalAccuracy < 40 {
                if let p = self.last { self.distance += l.distance(from: p) }
                self.last = l
                self.points.append(RoutePoint(lat: l.coordinate.latitude, lon: l.coordinate.longitude))
            }
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ m: CLLocationManager) {
        let st = m.authorizationStatus
        Task { @MainActor in self.denied = (st == .denied || st == .restricted) }
    }

    /// Höchstens ~1500 Punkte speichern.
    func compactPoints() -> [RoutePoint] {
        guard points.count > 1500 else { return points }
        let step = Double(points.count) / 1500
        return (0..<1500).map { points[Int(Double($0) * step)] }
    }
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

    let recorder = RouteRecorder()
    private var pedoDistance = 0.0
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
        elapsed = 0; steps = 0; distanceM = 0; pedoDistance = 0; paceSecPerKm = nil; kcal = 0
        running = true
        if kind.tracksRoute { recorder.start() }
        if available {
            pedometer.startUpdates(from: start) { [weak self] data, _ in
                guard let d = data else { return }
                let s = d.numberOfSteps.intValue
                let m = d.distance?.doubleValue ?? 0
                let p = d.currentPace?.doubleValue
                Task { @MainActor in
                    self?.steps = s
                    self?.pedoDistance = m
                    self?.updateDistance()
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

    private func updateDistance() {
        distanceM = kind.tracksRoute ? max(pedoDistance, recorder.distance) : pedoDistance
    }

    private func tick() {
        updateDistance()
        elapsed = Int(Date().timeIntervalSince(start))
        kcal = estimateKcal()
    }

    private func estimateKcal() -> Int {
        let hours = Double(elapsed) / 3600
        if (kind == .run || kind == .treadmill) && distanceM > 200 { return Int((weightKg * distanceM / 1000).rounded()) }  // ca. 1 kcal je kg und km
        return Int((kind.met * weightKg * hours).rounded())
    }

    func finish(into log: SessionLog) {
        guard running else { return }
        timer?.invalidate(); timer = nil
        pedometer.stopUpdates()
        recorder.stop()
        updateDistance()
        elapsed = Int(Date().timeIntervalSince(start))
        kcal = estimateKcal()
        running = false
        if elapsed >= 30 {
            let pts = recorder.compactPoints()
            log.entries.insert(SessionEntry(date: start, kind: kind, seconds: elapsed, steps: steps, distanceM: distanceM, kcal: kcal,
                                            route: pts.count > 2 ? pts : nil), at: 0)
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

/// Live-Karte während Laufen, Gehen oder Training draußen: Position und gelaufene Strecke.
struct LiveRouteMap: View {
    @ObservedObject var recorder: RouteRecorder
    @State private var pos: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Map(position: $pos) {
                UserAnnotation()
                if recorder.points.count > 1 {
                    MapPolyline(coordinates: recorder.points.map(\.coordinate)).stroke(.red, lineWidth: 5)
                }
            }
            .mapControls { MapUserLocationButton(); MapCompass() }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            if recorder.denied {
                Label("Standort ist aus. Unter Einstellungen → BFC → Standort erlauben, sonst keine Karte.", systemImage: "location.slash")
                    .font(.footnote).foregroundStyle(.orange)
            }
        }
    }
}

/// Statt Karte: Status der GPS-Aufzeichnung (läuft auch bei gesperrtem Bildschirm).
struct RouteStatus: View {
    @ObservedObject var recorder: RouteRecorder
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("GPS-Strecke wird aufgezeichnet · \(recorder.points.count) Punkte", systemImage: "location.fill")
                .font(.footnote)
            if recorder.points.count > 2 {
                RouteShape(points: recorder.points).stroke(Color.red, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .frame(height: 120)
            }
            if recorder.denied {
                Label("Standort ist aus. Unter Einstellungen → BFC → Standort erlauben.", systemImage: "location.slash")
                    .font(.footnote).foregroundStyle(.orange)
            }
        }
    }
}

struct WorkoutTrackerView: View {
    @EnvironmentObject var session: WorkoutSession
    @EnvironmentObject var log: SessionLog
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var tracker: StepTracker
    @EnvironmentObject var rank: RankStore

    var body: some View {
        List {
            Section {
                if session.running {
                    VStack(spacing: 6) {
                        Label(session.kind.label, systemImage: session.kind.icon).font(.headline)
                        Text(WorkoutSession.clock(session.elapsed))
                            .font(.system(size: 54, weight: .bold, design: .rounded)).monospacedDigit()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    metric("Schritte im Training", "\(session.steps)", "figure.walk")
                    metric("Strecke", String(format: "%.2f km", session.distanceM / 1000), "point.topleft.down.to.point.bottomright.curvepath")
                    metric("Tempo", WorkoutSession.paceText(session.paceSecPerKm), "speedometer")
                    metric("Kalorien (Schätzung)", "\(session.kcal) kcal", "flame")
                    if session.kind.tracksRoute {
                        RouteStatus(recorder: session.recorder)
                    }
                    Button(role: .destructive) {
                        let before = log.entries.count
                        session.finish(into: log)
                        if log.entries.count > before { rank.workoutFinished(id: log.entries[0].id.uuidString) }
                    } label: {
                        Label("Training beenden", systemImage: "stop.circle.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Text("Was machst du gerade?").font(.headline)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(WorkoutKind.pickerOrder) { k in
                            Button { session.kind = k } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: k.icon).font(.title2)
                                    Text(k.label).font(.footnote.weight(.semibold)).multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, minHeight: 74)
                                .background(session.kind == k ? Color.accentColor.opacity(0.22) : Color.secondary.opacity(0.1))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(session.kind == k ? Color.accentColor : .clear, lineWidth: 2))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                    if session.kind.tracksRoute {
                        Label("Die Strecke wird per GPS aufgezeichnet und live auf der Karte gezeigt.", systemImage: "location.fill")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    Button { session.begin(kind: session.kind, weightKg: profile.weightKg) } label: {
                        Label("\(session.kind.label) starten", systemImage: "play.circle.fill").frame(maxWidth: .infinity)
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
                    NavigationLink { RunDetailView(entry: e) } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Label(e.kind.label, systemImage: e.kind.icon)
                            Spacer()
                            Text(e.date, format: .dateTime.day().month().hour().minute()).font(.footnote).foregroundStyle(.secondary)
                        }
                        if let r = e.route, r.count > 2 {
                            RouteShape(points: r).stroke(Color.red, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .frame(height: 90).padding(.vertical, 4)
                        }
                        Text("\(e.source.map { "\($0) · " } ?? "")\(WorkoutSession.clock(e.seconds)) · \(e.steps) Schritte · \(String(format: "%.2f", e.distanceM / 1000)) km · \(e.kcal) kcal")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
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
