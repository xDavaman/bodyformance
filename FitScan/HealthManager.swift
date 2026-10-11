import Combine
import Foundation
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

    private var readTypes: Set<HKObjectType> {
        var types: Set<HKObjectType> = [HKObjectType.workoutType()]
        let ids: [HKQuantityTypeIdentifier] = [
            .stepCount, .activeEnergyBurned, .bodyMass, .restingHeartRate, .bodyFatPercentage, .distanceWalkingRunning
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

        stepsToday = Int(await steps)
        activeEnergyToday = Int(await energy)
        latestWeightKg = await weight
        if let v = await hr { restingHeartRate = Int(v) }
        workoutsLast30Days = await workouts
        runningKm7Days = await km7
        runningKm28Days = await km28
        stepsHistory = await history
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
}
