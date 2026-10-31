import Combine
import Foundation
import CoreLocation
import HealthKit

struct DaySteps: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}

/// Woher die Schritte kommen. Garmin, Fitbit, Polar & Co. schreiben ihre Schritte in Apple Health; von dort übernimmt
/// die App sie. „Automatisch“ nimmt die Garmin-Werte 1:1, sobald Garmin Connect in Apple Health schreibt.
enum StepSourceMode: String, CaseIterable, Identifiable {
    case auto = "Automatisch (Garmin bevorzugt)"
    case watch = "Bestimmte Uhr oder App"
    case health = "Apple Health gesamt"
    case phone = "Nur iPhone"
    var id: String { rawValue }

    var explanation: String {
        switch self {
        case .auto: return "Schreibt Garmin Connect in Apple Health, zählen genau die Schritte deiner Garmin – 1:1 wie in Garmin Connect. Sonst wie „Apple Health gesamt“."
        case .watch: return "Nur die Schritte der gewählten Quelle, ohne Mischung mit dem iPhone."
        case .health: return "Apple Health führt alle Quellen zusammen und zählt doppelte Schritte nur einmal (Reihenfolge in Health → Schritte → Datenquellen)."
        case .phone: return "Nur der Bewegungssensor dieses iPhones."
        }
    }
}

struct StepSourceInfo: Identifiable, Hashable {
    var id: String { bundleID }
    let name: String
    let bundleID: String
    var isGarmin: Bool { bundleID.lowercased().contains("garmin") || name.lowercased().contains("garmin") }
}

@MainActor
final class HealthManager: ObservableObject {
    private let store = HKHealthStore()

    @Published var isAuthorized = false
    @Published var stepsToday: Int = 0
    @Published var activeEnergyToday: Int = 0
    @Published var latestWeightKg: Double?
    @Published var restingHeartRate: Int?
    @Published var workoutsLast30Days: Int = 0
    @Published var runningKm7Days: Double = 0
    @Published var runningKm28Days: Double = 0
    @Published var stepsHistory: [DaySteps] = []
    /// Alle Schritte aller Quellen (iPhone, Apple Watch, Garmin & Co., sofern sie in Apple Health schreiben) seit dem ersten Eintrag.
    @Published var lifetimeSteps: Int = 0
    @Published var firstStepDate: Date?
    @Published var lifetimeKm: Double = 0
    /// Einstellung der Schrittquelle (siehe StepSourceMode)
    @Published var stepMode: StepSourceMode = StepSourceMode(rawValue: UserDefaults.standard.string(forKey: "steps.mode") ?? "") ?? .auto {
        didSet { UserDefaults.standard.set(stepMode.rawValue, forKey: "steps.mode"); Task { await refresh() } }
    }
    /// Bundle-ID der gewählten Quelle bei `.watch`
    @Published var stepSourceID: String = UserDefaults.standard.string(forKey: "steps.sourceID") ?? "" {
        didSet { UserDefaults.standard.set(stepSourceID, forKey: "steps.sourceID"); Task { await refresh() } }
    }
    /// Alle Apps und Geräte, die Schritte in Apple Health schreiben
    @Published private(set) var stepSources: [StepSourceInfo] = []
    /// Quelle, deren Schritte gerade 1:1 übernommen werden (nil = Apple Health gesamt bzw. iPhone)
    @Published private(set) var activeStepSource: StepSourceInfo?
    /// Ende des jüngsten Schritt-Eintrags der aktiven Quelle (zeigt, wann die Uhr zuletzt synchronisiert hat)
    @Published private(set) var lastStepSync: Date?
    private var sourceObjects: [HKSource] = []
    private var importing = false
    /// Training-Protokoll, in das Workouts der Uhr (Apple Watch, Garmin & Co. über Apple Health) laufend übernommen werden
    var sessionLog: SessionLog?
    private var observer: HKObserverQuery?
    private var workoutObserver: HKObserverQuery?
    private var liveTimer: Timer?

    private var readTypes: Set<HKObjectType> {
        var types: Set<HKObjectType> = [HKObjectType.workoutType(), HKSeriesType.workoutRoute()]
        let ids: [HKQuantityTypeIdentifier] = [
            .stepCount, .activeEnergyBurned, .bodyMass, .restingHeartRate, .bodyFatPercentage, .distanceWalkingRunning, .heartRate
        ]
        for id in ids {
            if let t = HKObjectType.quantityType(forIdentifier: id) { types.insert(t) }
        }
        // Vitalwerte und Schlaf für die Analyse (VitalsStore)
        for id in VitalsStore.quantityIDs {
            if let t = HKObjectType.quantityType(forIdentifier: id) { types.insert(t) }
        }
        for id in VitalsStore.categoryIDs {
            if let t = HKObjectType.categoryType(forIdentifier: id) { types.insert(t) }
        }
        return types
    }

    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        do {
            try await store.requestAuthorization(toShare: [], read: readTypes)
            isAuthorized = true
            await refresh()
            startLiveUpdates()
        } catch {
            isAuthorized = false
        }
    }

    /// Angezeigte Schritte für heute: mit Uhr-Quelle exakt deren Wert, sonst das Maximum aus Health und iPhone-Sensor.
    func displaySteps(phone: Int) -> Int {
        switch stepMode {
        case .phone: return phone
        default: return activeStepSource != nil ? stepsToday : max(stepsToday, phone)
        }
    }

    /// true, wenn die Schritte 1:1 von einer Uhr/App kommen (dann kein Mischen mit dem iPhone)
    var usesWatchSteps: Bool { stepMode != .phone && activeStepSource != nil }

    /// Ermittelt die Quellen, die Schritte schreiben, und wählt die aktive Quelle passend zur Einstellung.
    private func resolveStepSource() async {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let sources: Set<HKSource> = await withCheckedContinuation { cont in
            let q = HKSourceQuery(sampleType: type, samplePredicate: nil) { _, set, _ in
                cont.resume(returning: set ?? [])
            }
            store.execute(q)
        }
        sourceObjects = sources.sorted { $0.name < $1.name }
        stepSources = sourceObjects.map { StepSourceInfo(name: $0.name, bundleID: $0.bundleIdentifier) }
        let chosen: StepSourceInfo?
        switch stepMode {
        case .auto: chosen = stepSources.first { $0.isGarmin }
        case .watch: chosen = stepSources.first { $0.bundleID == stepSourceID }
        case .health, .phone: chosen = nil
        }
        activeStepSource = chosen
    }

    /// Filter auf die aktive Schrittquelle (nil = alle Quellen)
    private var stepSourcePredicate: NSPredicate? {
        guard let a = activeStepSource, let src = sourceObjects.first(where: { $0.bundleIdentifier == a.bundleID }) else { return nil }
        return HKQuery.predicateForObjects(from: [src])
    }

    private func and(_ a: NSPredicate?, _ b: NSPredicate?) -> NSPredicate? {
        let parts = [a, b].compactMap { $0 }
        if parts.isEmpty { return nil }
        return parts.count == 1 ? parts[0] : NSCompoundPredicate(andPredicateWithSubpredicates: parts)
    }

    /// Nur die schnell wechselnden Werte von heute (Timer, neue Schritte von der Uhr)
    func refreshToday() async {
        let src = stepSourcePredicate
        async let steps = sumToday(.stepCount, unit: .count(), source: src)
        async let energy = sumToday(.activeEnergyBurned, unit: .kilocalorie())
        async let history = stepHistory(days: 7, source: src)
        async let sync = latestEnd(.stepCount, source: src)
        stepsToday = Int(await steps)
        activeEnergyToday = Int(await energy)
        stepsHistory = await history
        lastStepSync = await sync
    }

    func refresh() async {
        await resolveStepSource()
        let src = stepSourcePredicate
        async let steps = sumToday(.stepCount, unit: .count(), source: src)
        async let energy = sumToday(.activeEnergyBurned, unit: .kilocalorie())
        async let weight = latest(.bodyMass, unit: .gramUnit(with: .kilo))
        async let hr = latest(.restingHeartRate, unit: HKUnit.count().unitDivided(by: .minute()))
        async let workouts = workoutCount(days: 30)
        async let km7 = runningKm(days: 7)
        async let km28 = runningKm(days: 28)
        async let history = stepHistory(days: 7, source: src)
        async let life = lifetimeTotal(.stepCount, unit: .count(), source: src)
        async let lifeKm = lifetimeTotal(.distanceWalkingRunning, unit: .meter(), source: src)
        async let first = firstSampleDate(.stepCount, source: src)
        async let sync = latestEnd(.stepCount, source: src)

        stepsToday = Int(await steps)
        activeEnergyToday = Int(await energy)
        latestWeightKg = await weight
        if let v = await hr { restingHeartRate = Int(v) }
        workoutsLast30Days = await workouts
        runningKm7Days = await km7
        runningKm28Days = await km28
        stepsHistory = await history
        lifetimeSteps = Int(await life)
        lifetimeKm = await lifeKm / 1000
        firstStepDate = await first
        lastStepSync = await sync
        await importWatchWorkouts()
    }

    /// Hält die Werte aktuell: sobald Health neue Schritte meldet (z. B. von der Watch), wird neu gelesen.
    func startLiveUpdates() {
        guard observer == nil, let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let q = HKObserverQuery(sampleType: type, predicate: nil) { [weak self] _, done, _ in
            Task { @MainActor in await self?.refreshToday() }
            done()
        }
        // Garmin Connect synchronisiert in Schüben: Health weckt die App, sobald neue Schritte ankommen
        store.enableBackgroundDelivery(for: type, frequency: .immediate) { _, _ in }
        store.execute(q)
        observer = q
        let wq = HKObserverQuery(sampleType: HKObjectType.workoutType(), predicate: nil) { [weak self] _, done, _ in
            Task { @MainActor in await self?.importWatchWorkouts() }
            done()
        }
        store.execute(wq)
        workoutObserver = wq
        let t = Timer(timeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in await self?.refreshToday() }
        }
        RunLoop.main.add(t, forMode: .common)
        liveTimer = t
    }

    /// Beendet alle Lesevorgänge (z. B. wenn die Einwilligung für Apple Health zurückgenommen wird).
    func stopLiveUpdates() {
        if let observer { store.stop(observer) }
        if let workoutObserver { store.stop(workoutObserver) }
        observer = nil
        workoutObserver = nil
        liveTimer?.invalidate()
        liveTimer = nil
        if let type = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            store.disableBackgroundDelivery(for: type) { _, _ in }
        }
        isAuthorized = false
        stepsToday = 0
        activeEnergyToday = 0
        stepsHistory = []
        lifetimeSteps = 0
        lifetimeKm = 0
        firstStepDate = nil
        lastStepSync = nil
        latestWeightKg = nil
        restingHeartRate = nil
    }

    private func lifetimeTotal(_ id: HKQuantityTypeIdentifier, unit: HKUnit, source: NSPredicate? = nil) async -> Double {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return 0 }
        return await withCheckedContinuation { cont in
            let q = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: source, options: .cumulativeSum) { _, stats, _ in
                cont.resume(returning: stats?.sumQuantity()?.doubleValue(for: unit) ?? 0)
            }
            store.execute(q)
        }
    }

    private func firstSampleDate(_ id: HKQuantityTypeIdentifier, source: NSPredicate? = nil) async -> Date? {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return nil }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        return await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: type, predicate: source, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
                cont.resume(returning: samples?.first?.startDate)
            }
            store.execute(q)
        }
    }

    /// Ende des jüngsten Eintrags (wann die Quelle zuletzt Daten geliefert hat)
    private func latestEnd(_ id: HKQuantityTypeIdentifier, source: NSPredicate? = nil) async -> Date? {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return nil }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        return await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: type, predicate: source, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
                cont.resume(returning: samples?.first?.endDate)
            }
            store.execute(q)
        }
    }

    private func sumToday(_ id: HKQuantityTypeIdentifier, unit: HKUnit, source: NSPredicate? = nil) async -> Double {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return 0 }
        let start = Calendar.current.startOfDay(for: Date())
        let predicate = and(HKQuery.predicateForSamples(withStart: start, end: Date()), source)
        return await withCheckedContinuation { cont in
            let q = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, stats, _ in
                cont.resume(returning: stats?.sumQuantity()?.doubleValue(for: unit) ?? 0)
            }
            store.execute(q)
        }
    }

    private func latest(_ id: HKQuantityTypeIdentifier, unit: HKUnit) async -> Double? {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return nil }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        return await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
                let value = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: unit)
                cont.resume(returning: value)
            }
            store.execute(q)
        }
    }

    private func workoutCount(days: Int) async -> Int {
        let start = Calendar.current.date(byAdding: .day, value: -days, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date())
        return await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicate,
                                  limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                cont.resume(returning: samples?.count ?? 0)
            }
            store.execute(q)
        }
    }

    /// Kilometer aus Lauf-Workouts der letzten Tage.
    private func runningKm(days: Int) async -> Double {
        let start = Calendar.current.date(byAdding: .day, value: -days, to: Date())
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: Date())
        let typePredicate = HKQuery.predicateForWorkouts(with: .running)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, typePredicate])
        return await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicate,
                                  limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                let meters = (samples as? [HKWorkout])?.compactMap {
                    $0.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meter())
                }.reduce(0, +) ?? 0
                cont.resume(returning: meters / 1000)
            }
            store.execute(q)
        }
    }

    /// Schritte der letzten Tage (ein Wert pro Tag), für das Wochendiagramm.
    private func stepHistory(days: Int, source: NSPredicate? = nil) async -> [DaySteps] {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return [] }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        guard let start = cal.date(byAdding: .day, value: -(days - 1), to: today),
              let end = cal.date(byAdding: .day, value: 1, to: today) else { return [] }
        let predicate = and(HKQuery.predicateForSamples(withStart: start, end: end), source)
        return await withCheckedContinuation { cont in
            let q = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate,
                                                options: .cumulativeSum, anchorDate: start,
                                                intervalComponents: DateComponents(day: 1))
            q.initialResultsHandler = { _, result, _ in
                var out: [DaySteps] = []
                result?.enumerateStatistics(from: start, to: end) { stats, _ in
                    out.append(DaySteps(date: stats.startDate, steps: Int(stats.sumQuantity()?.doubleValue(for: .count()) ?? 0)))
                }
                cont.resume(returning: out)
            }
            store.execute(q)
        }
    }

    // MARK: Workouts der Uhr übernehmen

    /// Übernimmt Workouts (inkl. GPS-Strecke) der letzten 90 Tage aus Apple Health ins Protokoll. Die Uhr schreibt sie dorthin,
    /// sobald sie Verbindung zum iPhone hat – auch wenn du das Handy beim Training nicht dabeihattest.
    func importWatchWorkouts() async {
        // nicht zweimal gleichzeitig (Timer, Beobachter, Ziehen zum Aktualisieren) – sonst doppelte Workouts
        guard let log = sessionLog, !importing else { return }
        importing = true
        defer { importing = false }
        let start = Calendar.current.date(byAdding: .day, value: -90, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date())
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let workouts: [HKWorkout] = await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicate, limit: 200, sortDescriptors: [sort]) { _, s, _ in
                cont.resume(returning: (s as? [HKWorkout]) ?? [])
            }
            store.execute(q)
        }
        var added: [SessionEntry] = []
        for w in workouts {
            let id = w.uuid.uuidString
            if log.entries.contains(where: { $0.healthID == id }) { continue }
            // eigene Aufzeichnung der App im selben Zeitraum nicht doppelt zählen
            if log.entries.contains(where: { $0.healthID == nil && abs($0.date.timeIntervalSince(w.startDate)) < 180 }) { continue }
            let kind: WorkoutKind
            let indoor = (w.metadata?[HKMetadataKeyIndoorWorkout] as? Bool) ?? false
            switch w.workoutActivityType {
            case .running: kind = indoor ? .treadmill : .run
            case .walking, .hiking: kind = .walk
            case .traditionalStrengthTraining, .functionalStrengthTraining, .coreTraining: kind = .strength
            case .highIntensityIntervalTraining, .crossTraining, .mixedCardio: kind = .hybrid
            default: kind = indoor ? .home : .outdoor
            }
            let km = w.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meter()) ?? 0
            let steps = Int(w.statistics(for: HKQuantityType(.stepCount))?.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            let kcal = Int(w.statistics(for: HKQuantityType(.activeEnergyBurned))?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0)
            let route = await routePoints(for: w)
            added.append(SessionEntry(date: w.startDate, kind: kind, seconds: Int(w.duration), steps: steps, distanceM: km,
                                      kcal: kcal, route: route.count > 2 ? route : nil, healthID: id,
                                      source: w.sourceRevision.source.name))
        }
        let fresh = added.filter { a in !log.entries.contains { $0.healthID == a.healthID } }
        if !fresh.isEmpty {
            log.entries = (log.entries + fresh).sorted { $0.date > $1.date }
        }
    }

    private func routePoints(for workout: HKWorkout) async -> [RoutePoint] {
        let routes: [HKWorkoutRoute] = await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: HKSeriesType.workoutRoute(), predicate: HKQuery.predicateForObjects(from: workout),
                                  limit: 1, sortDescriptors: nil) { _, s, _ in
                cont.resume(returning: (s as? [HKWorkoutRoute]) ?? [])
            }
            store.execute(q)
        }
        guard let route = routes.first else { return [] }
        let locs: [CLLocation] = await withCheckedContinuation { cont in
            let box = RouteBox()
            let q = HKWorkoutRouteQuery(route: route) { _, batch, done, error in
                if let batch { box.items += batch }
                // bei Fehler sofort beenden, sonst bliebe die Abfrage für immer hängen
                if (done || error != nil) && !box.finished {
                    box.finished = true
                    cont.resume(returning: box.items)
                }
            }
            store.execute(q)
        }
        let pts = locs.map { RoutePoint(lat: $0.coordinate.latitude, lon: $0.coordinate.longitude) }
        guard pts.count > 1500 else { return pts }
        let step = Double(pts.count) / 1500
        return (0..<1500).map { pts[Int(Double($0) * step)] }
    }
}

/// Sammelt die GPS-Punkte einer Workout-Strecke über mehrere Rückrufe von HealthKit.
nonisolated final class RouteBox: @unchecked Sendable {
    var items: [CLLocation] = []
    var finished = false
}
