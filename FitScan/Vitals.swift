import Charts
import Combine
import HealthKit
import SwiftUI

// MARK: - Daten

/// Eine Nacht Schlaf (zugeordnet zum Tag des Aufwachens)
struct NightSleep: Identifiable, Hashable {
    var id: Date { day }
    let day: Date
    /// Sekunden
    var asleep: TimeInterval
    var deep: TimeInterval
    var rem: TimeInterval
    var core: TimeInterval
    var awake: TimeInterval
    var bedtime: Date
    var wake: Date
    var source: String

    var hours: Double { asleep / 3600 }
    /// true, wenn die Quelle Schlafphasen liefert (Apple Watch, manche Garmin)
    var hasStages: Bool { deep + rem + core > 0 }
}

/// Werte eines Tages aus Apple Health
struct DayVitals: Identifiable, Hashable {
    var id: Date { day }
    let day: Date
    var restingHR: Double?
    var hrv: Double?
    var avgHR: Double?
    var respiratory: Double?
    var spo2: Double?
    var exerciseMin: Double = 0
    var activeKcal: Double = 0
    var mindfulMin: Double = 0
}

/// Schlafstück aus Apple Health, vereinfacht
struct SleepSample {
    enum Stage { case inBed, asleep, core, deep, rem, awake }
    let start: Date
    let end: Date
    let stage: Stage
    let source: String
}

enum SleepMath {
    /// Schlaftag: Mittag bis Mittag, also zählt eine Nacht zum Tag des Aufwachens
    static func nightKey(_ start: Date) -> Date {
        Calendar.current.startOfDay(for: start.addingTimeInterval(12 * 3600))
    }

    /// Fasst Schlafstücke zu Nächten zusammen. Schreiben mehrere Quellen (Watch, iPhone, Garmin), zählt pro Nacht
    /// die Quelle mit dem meisten Schlaf – sonst würde doppelt gezählt.
    static func nights(from samples: [SleepSample]) -> [NightSleep] {
        let byNight = Dictionary(grouping: samples) { nightKey($0.start) }
        var out: [NightSleep] = []
        for (day, list) in byNight {
            let bySource = Dictionary(grouping: list, by: \.source)
            var best: NightSleep?
            for (source, parts) in bySource {
                var n = NightSleep(day: day, asleep: 0, deep: 0, rem: 0, core: 0, awake: 0,
                                   bedtime: .distantFuture, wake: .distantPast, source: source)
                for p in parts {
                    let d = p.end.timeIntervalSince(p.start)
                    guard d > 0 else { continue }
                    switch p.stage {
                    case .asleep: n.asleep += d
                    case .core: n.asleep += d; n.core += d
                    case .deep: n.asleep += d; n.deep += d
                    case .rem: n.asleep += d; n.rem += d
                    case .awake: n.awake += d
                    case .inBed: break
                    }
                    if p.stage != .awake {
                        n.bedtime = min(n.bedtime, p.start)
                        n.wake = max(n.wake, p.end)
                    }
                }
                if n.asleep > 0, n.asleep > (best?.asleep ?? 0) { best = n }
            }
            if let best { out.append(best) }
        }
        return out.sorted { $0.day < $1.day }
    }

    /// Minuten seit 12:00 (Mittag) – damit 23:30 und 0:30 nah beieinander liegen
    static func minutesFromNoon(_ d: Date) -> Double {
        let c = Calendar.current.dateComponents([.hour, .minute], from: d)
        let m = Double((c.hour ?? 0) * 60 + (c.minute ?? 0))
        return m >= 720 ? m - 720 : m + 720
    }

    static func clockText(minutesFromNoon m: Double) -> String {
        let total = (Int(m.rounded()) + 720) % 1440
        return String(format: "%02d:%02d", total / 60, total % 60)
    }

    static func mean(_ xs: [Double]) -> Double? { xs.isEmpty ? nil : xs.reduce(0, +) / Double(xs.count) }

    static func stdDev(_ xs: [Double]) -> Double? {
        guard xs.count >= 2, let m = mean(xs) else { return nil }
        return (xs.map { ($0 - m) * ($0 - m) }.reduce(0, +) / Double(xs.count - 1)).squareRoot()
    }
}

/// Schlafrhythmus der letzten Nächte
struct SleepRhythm {
    let nights: Int
    let avgHours: Double
    let avgBedtime: String
    let avgWake: String
    /// Streuung der Einschlafzeit in Minuten
    let bedtimeSpread: Double?
    let deepShare: Double?
    let remShare: Double?

    init?(_ list: [NightSleep]) {
        guard !list.isEmpty else { return nil }
        nights = list.count
        avgHours = list.map(\.hours).reduce(0, +) / Double(list.count)
        let beds = list.map { SleepMath.minutesFromNoon($0.bedtime) }
        let wakes = list.map { SleepMath.minutesFromNoon($0.wake) }
        avgBedtime = SleepMath.clockText(minutesFromNoon: SleepMath.mean(beds) ?? 0)
        avgWake = SleepMath.clockText(minutesFromNoon: SleepMath.mean(wakes) ?? 0)
        bedtimeSpread = SleepMath.stdDev(beds)
        let staged = list.filter(\.hasStages)
        let total = staged.map(\.asleep).reduce(0, +)
        deepShare = total > 0 ? staged.map(\.deep).reduce(0, +) / total * 100 : nil
        remShare = total > 0 ? staged.map(\.rem).reduce(0, +) / total * 100 : nil
    }

    var advice: [String] {
        var out: [String] = []
        if avgHours < 7 {
            out.append(String(format: "Im Schnitt %.1f h Schlaf. Für Muskelaufbau und Regeneration sind 7–9 h ideal; zu wenig Schlaf senkt Kraft und erhöht den Hunger.", avgHours))
        } else if avgHours > 9.5 {
            out.append(String(format: "Im Schnitt %.1f h Schlaf, das ist viel. Fühlst du dich trotzdem müde, sprich das ärztlich ab.", avgHours))
        } else {
            out.append(String(format: "Im Schnitt %.1f h Schlaf, das passt gut für Training und Erholung.", avgHours))
        }
        if let s = bedtimeSpread {
            if s > 60 {
                out.append("Deine Einschlafzeit schwankt um etwa \(Int(s)) Minuten. Ein fester Rhythmus (±30 Min.) verbessert Erholung und Leistung.")
            } else {
                out.append("Dein Schlafrhythmus ist regelmäßig (Streuung etwa \(Int(s)) Min.).")
            }
        }
        if let d = deepShare, d < 10 {
            out.append(String(format: "Tiefschlaf-Anteil %.0f %%. Kein spätes, schweres Essen, wenig Alkohol und ein kühles Schlafzimmer helfen.", d))
        }
        return out
    }
}

/// Erholung und Belastung aus Schlaf, HRV, Ruhepuls und Trainingsminuten
enum Recovery {
    /// 0–100. Schlaf 40 %, HRV 30 %, Ruhepuls 30 % – jeweils gegenüber deinem eigenen Schnitt der letzten 30 Tage.
    static func score(night: NightSleep?, hrv: Double?, hrvBase: Double?, rhr: Double?, rhrBase: Double?) -> Int? {
        var parts: [(Double, Double)] = []
        if let n = night { parts.append((min(1, n.hours / 8), 0.4)) }
        if let h = hrv, let b = hrvBase, b > 0 { parts.append((max(0, min(1, 0.6 + (h / b - 1) * 2)), 0.3)) }
        if let r = rhr, let b = rhrBase, b > 0 { parts.append((max(0, min(1, 0.6 - (r / b - 1) * 5)), 0.3)) }
        let w = parts.map(\.1).reduce(0, +)
        guard w > 0 else { return nil }
        return Int((parts.map { $0.0 * $0.1 }.reduce(0, +) / w * 100).rounded())
    }

    static func verdict(_ score: Int) -> String {
        switch score {
        case 75...: return "Gut erholt: volles Training, gern auch schwer."
        case 55..<75: return "Normal erholt: Training wie geplant."
        case 40..<55: return "Etwas müde: Gewichte halten, eventuell einen Satz weniger."
        default: return "Wenig erholt: lieber leicht trainieren, Mobility oder Pause."
        }
    }

    /// Belastung der letzten 7 Tage gegenüber dem Wochenschnitt der 28 Tage davor (Trainingsminuten)
    static func loadRatio(days: [DayVitals]) -> Double? {
        let sorted = days.sorted { $0.day < $1.day }
        guard sorted.count >= 14 else { return nil }
        let acute = sorted.suffix(7).map(\.exerciseMin).reduce(0, +)
        let chronicDays = sorted.dropLast(7).suffix(28)
        let chronic = chronicDays.map(\.exerciseMin).reduce(0, +) / Double(max(1, chronicDays.count)) * 7
        return chronic > 0 ? acute / chronic : nil
    }

    static func loadText(_ r: Double) -> String {
        switch r {
        case ..<0.8: return "Weniger Belastung als gewohnt. Gut für eine Erholungswoche, sonst langsam wieder steigern."
        case 0.8...1.3: return "Belastung im grünen Bereich."
        case 1.3...1.5: return "Deutlich mehr als gewohnt. Achte auf Schlaf und Essen."
        default: return "Viel mehr als gewohnt. Das Verletzungsrisiko steigt, plane bald einen leichteren Tag."
        }
    }
}

// MARK: - Laden aus Apple Health

@MainActor
final class VitalsStore: ObservableObject {
    static let quantityIDs: [HKQuantityTypeIdentifier] = [
        .heartRateVariabilitySDNN, .respiratoryRate, .oxygenSaturation, .appleExerciseTime, .vo2Max, .walkingHeartRateAverage
    ]
    static let categoryIDs: [HKCategoryTypeIdentifier] = [.sleepAnalysis, .mindfulSession]

    @Published private(set) var nights: [NightSleep] = []
    @Published private(set) var days: [DayVitals] = []
    @Published private(set) var vo2Max: Double?
    @Published private(set) var loading = false
    @Published private(set) var lastLoad: Date?

    private let store = HKHealthStore()

    var lastNight: NightSleep? {
        guard let n = nights.last, Calendar.current.isDateInToday(n.day) else { return nil }
        return n
    }
    var today: DayVitals? { days.last }

    func night(for day: Date) -> NightSleep? {
        let d = Calendar.current.startOfDay(for: day)
        return nights.first { $0.day == d }
    }

    func vitals(for day: Date) -> DayVitals? {
        let d = Calendar.current.startOfDay(for: day)
        return days.first { $0.day == d }
    }

    /// Erholungswert für einen Tag (Schlaf der Nacht davor, HRV und Ruhepuls gegenüber den 30 Tagen davor)
    func recovery(on day: Date) -> Int? {
        let d = Calendar.current.startOfDay(for: day)
        let before = days.filter { $0.day < d }.suffix(30)
        let v = vitals(for: d)
        return Recovery.score(night: night(for: d),
                              hrv: v?.hrv, hrvBase: SleepMath.mean(before.compactMap(\.hrv)),
                              rhr: v?.restingHR, rhrBase: SleepMath.mean(before.compactMap(\.restingHR)))
    }

    func refresh(days n: Int = 90) async {
        guard HKHealthStore.isHealthDataAvailable(), !loading else { return }
        loading = true
        defer { loading = false }
        let bpm = HKUnit.count().unitDivided(by: .minute())
        async let sleep = loadSleep(days: n + 1)
        async let rhr = daily(.restingHeartRate, unit: bpm, sum: false, days: n)
        async let hrv = daily(.heartRateVariabilitySDNN, unit: .secondUnit(with: .milli), sum: false, days: n)
        async let hr = daily(.heartRate, unit: bpm, sum: false, days: n)
        async let resp = daily(.respiratoryRate, unit: bpm, sum: false, days: n)
        async let spo2 = daily(.oxygenSaturation, unit: .percent(), sum: false, days: n)
        async let ex = daily(.appleExerciseTime, unit: .minute(), sum: true, days: n)
        async let kcal = daily(.activeEnergyBurned, unit: .kilocalorie(), sum: true, days: n)
        async let mindful = mindfulMinutes(days: n)
        async let vo2 = latest(.vo2Max, unit: HKUnit(from: "ml/kg*min"))

        let (s, r, h, a, re, o, e, k, m) = await (sleep, rhr, hrv, hr, resp, spo2, ex, kcal, mindful)
        nights = s
        vo2Max = await vo2
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        days = (0..<n).reversed().compactMap { i -> DayVitals? in
            guard let d = cal.date(byAdding: .day, value: -i, to: today) else { return nil }
            return DayVitals(day: d, restingHR: r[d], hrv: h[d], avgHR: a[d], respiratory: re[d],
                             spo2: o[d].map { $0 * 100 }, exerciseMin: e[d] ?? 0, activeKcal: k[d] ?? 0, mindfulMin: m[d] ?? 0)
        }
        lastLoad = Date()
    }

    /// Ein Wert pro Tag (Summe oder Durchschnitt), Schlüssel = Tagesbeginn
    private func daily(_ id: HKQuantityTypeIdentifier, unit: HKUnit, sum: Bool, days: Int) async -> [Date: Double] {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return [:] }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        guard let start = cal.date(byAdding: .day, value: -(days - 1), to: today),
              let end = cal.date(byAdding: .day, value: 1, to: today) else { return [:] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        return await withCheckedContinuation { cont in
            let q = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate,
                                                options: sum ? .cumulativeSum : .discreteAverage, anchorDate: start,
                                                intervalComponents: DateComponents(day: 1))
            q.initialResultsHandler = { _, result, _ in
                var out: [Date: Double] = [:]
                result?.enumerateStatistics(from: start, to: end) { stats, _ in
                    let quantity = sum ? stats.sumQuantity() : stats.averageQuantity()
                    if let v = quantity?.doubleValue(for: unit) { out[stats.startDate] = v }
                }
                cont.resume(returning: out)
            }
            store.execute(q)
        }
    }

    private func latest(_ id: HKQuantityTypeIdentifier, unit: HKUnit) async -> Double? {
        guard let type = HKQuantityType.quantityType(forIdentifier: id) else { return nil }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        return await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
                cont.resume(returning: (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: unit))
            }
            store.execute(q)
        }
    }

    private func categorySamples(_ id: HKCategoryTypeIdentifier, days: Int) async -> [HKCategorySample] {
        guard let type = HKCategoryType.categoryType(forIdentifier: id) else { return [] }
        let cal = Calendar.current
        let start = cal.date(byAdding: .day, value: -days, to: cal.startOfDay(for: Date()))
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date())
        return await withCheckedContinuation { cont in
            let q = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, s, _ in
                cont.resume(returning: (s as? [HKCategorySample]) ?? [])
            }
            store.execute(q)
        }
    }

    private func loadSleep(days: Int) async -> [NightSleep] {
        let raw = await categorySamples(.sleepAnalysis, days: days)
        let samples = raw.map { s -> SleepSample in
            let stage: SleepSample.Stage
            switch HKCategoryValueSleepAnalysis(rawValue: s.value) ?? .asleepUnspecified {
            case .inBed: stage = .inBed
            case .awake: stage = .awake
            case .asleepCore: stage = .core
            case .asleepDeep: stage = .deep
            case .asleepREM: stage = .rem
            default: stage = .asleep
            }
            return SleepSample(start: s.startDate, end: s.endDate, stage: stage, source: s.sourceRevision.source.bundleIdentifier)
        }
        return SleepMath.nights(from: samples)
    }

    private func mindfulMinutes(days: Int) async -> [Date: Double] {
        let raw = await categorySamples(.mindfulSession, days: days)
        var out: [Date: Double] = [:]
        for s in raw {
            out[Calendar.current.startOfDay(for: s.startDate), default: 0] += s.endDate.timeIntervalSince(s.startDate) / 60
        }
        return out
    }
}

// MARK: - Ansicht

struct VitalsView: View {
    @EnvironmentObject var vitals: VitalsStore
    @EnvironmentObject var health: HealthManager
    @EnvironmentObject var store: TrainingStore

    var body: some View {
        List {
            if !health.isAuthorized {
                Section {
                    Label("Erlaube Apple Health (Einstellungen → Datenschutz in der App), dann erscheinen hier Schlaf, Herzfrequenz, HRV und Belastung.",
                          systemImage: "heart.text.square")
                        .font(.footnote)
                }
            }
            recoverySection
            sleepSection
            heartSection
            loadSection
            Section {
                Text("Quelle: Apple Health. Alles, was Apple Watch, Garmin, Oura & Co. dort eintragen, fließt mit ein. Die Werte bleiben auf deinem iPhone. Allgemeine Orientierung, keine medizinische Diagnose.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Vitalwerte und Schlaf")
        .refreshable { await vitals.refresh() }
        .task { if vitals.lastLoad == nil || Date().timeIntervalSince(vitals.lastLoad ?? .distantPast) > 600 { await vitals.refresh() } }
        .overlay { if vitals.loading && vitals.days.isEmpty { ProgressView() } }
    }

    @ViewBuilder
    private var recoverySection: some View {
        Section("Erholung heute") {
            if let score = vitals.recovery(on: Date()) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle().stroke(Color.secondary.opacity(0.2), lineWidth: 9)
                        Circle().trim(from: 0, to: Double(score) / 100)
                            .stroke(score >= 55 ? Color.green : (score >= 40 ? Color.orange : Color.red),
                                    style: StrokeStyle(lineWidth: 9, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        Text("\(score)").font(.title2.bold().monospacedDigit())
                    }
                    .frame(width: 74, height: 74)
                    Text(Recovery.verdict(score)).font(.subheadline)
                }
                .padding(.vertical, 4)
            } else {
                Text("Noch zu wenige Daten. Trage nachts eine Uhr, dann berechnet die App deine Erholung aus Schlaf, HRV und Ruhepuls.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var sleepSection: some View {
        let recent = Array(vitals.nights.suffix(14))
        Section {
            if let n = vitals.lastNight {
                LabeledContent("Letzte Nacht", value: String(format: "%.1f h", n.hours))
                LabeledContent("Eingeschlafen – aufgewacht",
                               value: "\(n.bedtime.formatted(date: .omitted, time: .shortened)) – \(n.wake.formatted(date: .omitted, time: .shortened))")
                if n.hasStages {
                    LabeledContent("Tief · REM · Kern",
                                   value: String(format: "%.1f · %.1f · %.1f h", n.deep / 3600, n.rem / 3600, n.core / 3600))
                }
            }
            if !recent.isEmpty {
                Chart(recent) { n in
                    BarMark(x: .value("Nacht", n.day, unit: .day), y: .value("Stunden", n.hours))
                        .foregroundStyle(n.hours >= 7 ? Color.indigo : Color.orange)
                    RuleMark(y: .value("Ziel", 7)).lineStyle(StrokeStyle(lineWidth: 1, dash: [4])).foregroundStyle(.secondary)
                }
                .frame(height: 150)
            }
            if let r = SleepRhythm(recent) {
                LabeledContent("Schnitt \(r.nights) Nächte", value: String(format: "%.1f h", r.avgHours))
                LabeledContent("Einschlafen · Aufwachen (Schnitt)", value: "\(r.avgBedtime) · \(r.avgWake)")
                ForEach(r.advice, id: \.self) { Label($0, systemImage: "moon.zzz").font(.footnote) }
            } else {
                Text("Keine Schlafdaten. Schlaf zeichnen Apple Watch, iPhone (Schlafenszeit) oder Garmin/Oura über Apple Health auf.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        } header: {
            Text("Schlaf")
        }
    }

    @ViewBuilder
    private var heartSection: some View {
        let recent = Array(vitals.days.suffix(30))
        Section("Herz und Atmung") {
            LabeledContent("Ruhepuls", value: health.restingHeartRate.map { "\($0) bpm" } ?? "–")
            if let h = recent.last(where: { $0.hrv != nil })?.hrv {
                LabeledContent("HRV (Herzfrequenzvariabilität)", value: String(format: "%.0f ms", h))
            }
            if let a = vitals.today?.avgHR { LabeledContent("Puls heute (Schnitt)", value: String(format: "%.0f bpm", a)) }
            if let v = vitals.vo2Max { LabeledContent("VO2max", value: String(format: "%.1f ml/kg/min", v)) }
            if let r = recent.last(where: { $0.respiratory != nil })?.respiratory {
                LabeledContent("Atemfrequenz", value: String(format: "%.1f /min", r))
            }
            if let o = recent.last(where: { $0.spo2 != nil })?.spo2 {
                LabeledContent("Sauerstoffsättigung", value: String(format: "%.0f %%", o))
            }
            let hrvPoints = recent.filter { $0.hrv != nil }
            if hrvPoints.count >= 3 {
                Chart(hrvPoints) { d in
                    LineMark(x: .value("Tag", d.day, unit: .day), y: .value("HRV", d.hrv ?? 0))
                        .foregroundStyle(.green)
                }
                .chartYScale(domain: .automatic(includesZero: false))
                .frame(height: 120)
                Text("HRV-Verlauf (30 Tage): höher als dein Schnitt = gut erholt, deutlich niedriger = Stress, Infekt oder zu viel Training.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            let rhrPoints = recent.filter { $0.restingHR != nil }
            if rhrPoints.count >= 3 {
                Chart(rhrPoints) { d in
                    LineMark(x: .value("Tag", d.day, unit: .day), y: .value("Ruhepuls", d.restingHR ?? 0))
                        .foregroundStyle(.red)
                }
                .chartYScale(domain: .automatic(includesZero: false))
                .frame(height: 120)
            }
        }
    }

    @ViewBuilder
    private var loadSection: some View {
        let week = Array(vitals.days.suffix(14))
        Section {
            if week.contains(where: { $0.exerciseMin > 0 }) {
                Chart(week) { d in
                    BarMark(x: .value("Tag", d.day, unit: .day), y: .value("Minuten", d.exerciseMin)).foregroundStyle(.orange)
                }
                .frame(height: 120)
            }
            if let r = Recovery.loadRatio(days: vitals.days) {
                LabeledContent("Belastung 7 Tage zu Schnitt", value: String(format: "%.2f", r))
                Text(Recovery.loadText(r)).font(.footnote)
            }
            let mindful = vitals.days.suffix(7).map(\.mindfulMin).reduce(0, +)
            LabeledContent("Ruhe und Achtsamkeit (7 Tage)", value: "\(Int(mindful.rounded())) Min.")
            LabeledContent("Aktive Energie heute", value: "\(Int(vitals.today?.activeKcal ?? 0)) kcal")
        } header: {
            Text("Belastung und Ruhe")
        } footer: {
            Text("Belastung = Trainingsminuten der letzten 7 Tage im Verhältnis zu deinem Schnitt der Wochen davor. 0,8–1,3 ist ideal.")
        }
    }
}

/// Kurzer Hinweis zur Erholung im Training (nur wenn Daten da sind)
struct RecoveryHint: View {
    @EnvironmentObject var vitals: VitalsStore

    var body: some View {
        if let score = vitals.recovery(on: Date()) {
            Label("Erholung \(score)/100: \(Recovery.verdict(score))", systemImage: score >= 55 ? "battery.100" : "battery.25")
                .font(.footnote)
                .foregroundStyle(score >= 55 ? Color.green : Color.orange)
        }
    }
}
