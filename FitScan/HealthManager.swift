import Combine
import Foundation
import CoreLocation
import HealthKit

struct DaySteps: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
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

    func refresh() async {
        async let steps = sumToday(.stepCount, unit: .count())
        async let energy = sumToday(.activeEnergyBurned, unit: .kilocalorie())
        async let weight = latest(.bodyMass, unit: .gramUnit(with: .kilo))
        async let hr = latest(.restingHeartRate, unit: HKUnit.count().unitDivided(by: .minute()))
        async let workouts = workoutCount(days: 30)
        async let km7 = runningKm(days: 7)
        async let km28 = runningKm(days: 28)
        async let history = stepHistory(days: 7)
        async let life = lifetimeTotal(.stepCount, unit: .count())
        async let lifeKm = lifetimeTotal(.distanceWalkingRunning, unit: .meter())
        async let first = firstSampleDate(.stepCount)

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
        await importWatchWorkouts()
    }

    /// Hält die Werte aktuell: sobald Health neue Schritte meldet (z. B. von der Watch), wird neu gelesen.
    func startLiveUpdates() {
        guard observer == nil, let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let q = HKObserverQuery(sampleType: type, predicate: nil) { [weak self] _, done, _ in
            Task { @MainActor in await self?.refresh() }
            done()
        }
        store.execute(q)
        observer = q
        let wq = HKObserverQuery(sampleType: HKObjectType.workoutType(), predicate: nil) { [weak self] _, done, _ in
            Task { @MainActor in await self?.importWatchWorkouts() }
            done()
        }
        store.execute(wq)
        workoutObserver = wq
        let t = Timer(timeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in await self?.refresh() }
        }
        RunLoop.main.add(t, forMode: .common)
        liveTimer = t
    }

    private func lifetimeTotal(_ id: HKQuantityTypeIdentifier, unit: HKUnit) async -> Double {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return 0 }
        return await withCheckedContinuation { cont in
            let q = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: nil, options: .cumulativeSum) { _, stats, _ in
                cont.resume(returning: stats?.sumQuantity()?.doubleValue(for: unit) ?? 0)
            }
            store.execute(q)
        }
    }

    private func firstSampleDate(_ id: HKQuantityTypeIdentifier) async -> Date? {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return nil }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        return await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
                cont.resume(returning: samples?.first?.startDate)
            }
            store.execute(q)
        }
    }

    private func sumToday(_ id: HKQuantityTypeIdentifier, unit: HKUnit) async -> Double {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return 0 }
        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date())
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
    private func stepHistory(days: Int) async -> [DaySteps] {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return [] }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        guard let start = cal.date(byAdding: .day, value: -(days - 1), to: today),
              let end = cal.date(byAdding: .day, value: 1, to: today) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
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
        guard let log = sessionLog else { return }
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
        if !added.isEmpty {
            log.entries = (log.entries + added).sorted { $0.date > $1.date }
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
            var all: [CLLocation] = []
            let q = HKWorkoutRouteQuery(route: route) { _, batch, done, _ in
                if let batch { all += batch }
                if done { cont.resume(returning: all) }
            }
            store.execute(q)
        }
        let pts = locs.map { RoutePoint(lat: $0.coordinate.latitude, lon: $0.coordinate.longitude) }
        guard pts.count > 1500 else { return pts }
        let step = Double(pts.count) / 1500
        return (0..<1500).map { pts[Int(Double($0) * step)] }
    }
}
