import Combine
import SwiftUI

// MARK: - Zeitraum

struct ReportPeriod: Equatable {
    let start: Date
    let end: Date
    let title: String
    /// gleich langer Zeitraum davor (Vormonat)
    let previousStart: Date

    static func month(offset: Int) -> ReportPeriod {
        let cal = Calendar.current
        let base = cal.dateInterval(of: .month, for: Date())?.start ?? cal.startOfDay(for: Date())
        let start = cal.date(byAdding: .month, value: -offset, to: base) ?? base
        let end = cal.date(byAdding: .month, value: 1, to: start) ?? Date()
        let prev = cal.date(byAdding: .month, value: -1, to: start) ?? start
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateFormat = "LLLL yyyy"
        return ReportPeriod(start: start, end: end, title: f.string(from: start), previousStart: prev)
    }

    var fileStem: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM"
        return "BFC-Monatsbericht-\(f.string(from: start))"
    }

    /// Tage des Zeitraums bis heute
    var days: [Date] {
        let cal = Calendar.current
        var out: [Date] = []
        var d = start
        let last = min(end, Date())
        while d < last {
            out.append(d)
            guard let n = cal.date(byAdding: .day, value: 1, to: d) else { break }
            d = n
        }
        return out
    }
}

// MARK: - Inhalt

struct ExerciseReportRow: Identifiable {
    var id: String { name }
    let name: String
    let equipment: String
    let sessions: Int
    let sets: Int
    let bestWeight: Double
    let repsAtBest: Int
    let volume: Double
    let firstE1RM: Double
    let lastE1RM: Double
    let bestE1RM: Double
    /// beste Leistung im Vormonat
    let previousBest: Double?

    /// Veränderung von der ersten zur letzten Einheit im Zeitraum
    var changeInPeriod: Double? {
        sessions >= 2 && firstE1RM > 0 ? (lastE1RM - firstE1RM) / firstE1RM * 100 : nil
    }
    /// Veränderung gegenüber dem Vormonat (bestes geschätztes Maximum)
    var changeVsPrevious: Double? {
        guard let p = previousBest, p > 0 else { return nil }
        return (bestE1RM - p) / p * 100
    }
    /// geschätzte Leistungsveränderung: bevorzugt gegenüber dem Vormonat
    var performance: Double? { changeVsPrevious ?? changeInPeriod }
}

struct NutritionReportDay: Identifiable {
    var id: Date { day }
    let day: Date
    let kcal: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    let kcalTarget: Int
    let proteinTarget: Int
}

struct MonthlyReport {
    let period: ReportPeriod
    let goal: String
    let exercises: [ExerciseReportRow]
    let sets: [SetLog]
    /// Veränderung jedes Satzes zur Einheit davor (auch aus dem Vormonat)
    let setChanges: [UUID: Double]
    let workouts: Int
    let trainingMinutes: Int
    let cardioKm: Double
    let mobilityCount: Int
    let volume: Double
    let nutrition: [NutritionReportDay]
    let supplements: [SupplementSummary]
    let supplementEntries: [SupplementEntry]
    let creatineStatus: String?
    let nights: [NightSleep]
    let vitals: [DayVitals]
    let bodyStart: Double?
    let bodyEnd: Double?
    let performanceIndex: Double?
    let insights: [String]
    let adjustments: [String]

    var avgProtein: Double? { SleepMath.mean(nutrition.map(\.protein)) }
    var avgKcal: Double? { SleepMath.mean(nutrition.map(\.kcal)) }
    var proteinDaysHit: Int { nutrition.filter { $0.protein >= Double($0.proteinTarget) * 0.9 }.count }
    var avgSleep: Double? { SleepMath.mean(nights.map(\.hours)) }
    var avgHRV: Double? { SleepMath.mean(vitals.compactMap(\.hrv)) }
    var avgRHR: Double? { SleepMath.mean(vitals.compactMap(\.restingHR)) }

    @MainActor
    static func build(period: ReportPeriod, store: TrainingStore, sessions: SessionLog, food: FoodLog,
                      supplements: SupplementStore, vitals: VitalsStore, profile: UserProfile) -> MonthlyReport {
        let inPeriod: (Date) -> Bool = { $0 >= period.start && $0 < period.end }
        let sets = store.sets.filter { inPeriod($0.date) }.sorted { $0.date < $1.date }
        let prevSets = store.sets.filter { $0.date >= period.previousStart && $0.date < period.start }

        // Übungen
        var rows: [ExerciseReportRow] = []
        for (name, logs) in Dictionary(grouping: sets, by: \.exercise) {
            let points = Progression.sessionPoints(Progression.sessions(from: logs))
            guard let first = points.first, let last = points.last else { continue }
            let top = logs.max { $0.weightKg == $1.weightKg ? $0.reps < $1.reps : $0.weightKg < $1.weightKg }
            let prev = prevSets.filter { $0.exercise == name }.map(\.e1RM).max()
            rows.append(ExerciseReportRow(
                name: name, equipment: ExerciseCatalog.exercise(named: name)?.equipment.rawValue ?? "",
                sessions: points.count, sets: logs.count, bestWeight: top?.weightKg ?? 0, repsAtBest: top?.reps ?? 0,
                volume: logs.reduce(0) { $0 + $1.weightKg * Double($1.reps) },
                firstE1RM: first.e1RM, lastE1RM: last.e1RM, bestE1RM: points.map(\.e1RM).max() ?? 0, previousBest: prev))
        }
        rows.sort { $0.name < $1.name }
        let perf = rows.compactMap(\.performance)
        let index = perf.isEmpty ? nil : perf.reduce(0, +) / Double(perf.count)

        // Einheiten
        let entries = sessions.entries.filter { inPeriod($0.date) }
        let cardio = store.cardio.filter { inPeriod($0.date) }

        // Ernährung (nur Tage mit Einträgen)
        let nutrition: [NutritionReportDay] = period.days.compactMap { d in
            let t = food.totals(day: d)
            guard t.kcal > 0 else { return nil }
            let targets = profile.targets(for: food.dayType(day: d, fallback: profile.defaultDayType))
            return NutritionReportDay(day: d, kcal: t.kcal, protein: t.protein, carbs: t.carbs, fat: t.fat,
                                      kcalTarget: targets.kcal, proteinTarget: targets.protein)
        }

        // Supplements
        let supp = supplements.entries(from: period.start, to: period.end)

        // Schlaf und Vitalwerte
        let nights = vitals.nights.filter { inPeriod($0.day) }
        let days = vitals.days.filter { inPeriod($0.day) }

        // Körpergewicht
        let body = store.bodyEntries.filter { inPeriod($0.date) }.sorted { $0.date < $1.date }

        var report = MonthlyReport(
            period: period, goal: profile.trainingGoal?.rawValue ?? profile.goal.rawValue,
            exercises: rows, sets: sets,
            setChanges: Dictionary(sets.compactMap { s in Progression.change(of: s, in: store.sets).map { (s.id, $0) } },
                                   uniquingKeysWith: { a, _ in a }),
            workouts: entries.count,
            trainingMinutes: entries.reduce(0) { $0 + $1.seconds } / 60,
            cardioKm: max(cardio.reduce(0) { $0 + $1.km }, entries.reduce(0) { $0 + $1.distanceM } / 1000),
            mobilityCount: store.mobility.filter { inPeriod($0.date) }.count,
            volume: sets.reduce(0) { $0 + $1.weightKg * Double($1.reps) },
            nutrition: nutrition, supplements: SupplementSummary.make(supp), supplementEntries: supp,
            creatineStatus: SupplementSummary.creatineStatus(supplements.entries, until: min(period.end, Date())),
            nights: nights, vitals: days, bodyStart: body.first?.weightKg, bodyEnd: body.last?.weightKg,
            performanceIndex: index, insights: [], adjustments: [])
        report = report.with(insights: report.makeInsights(profile: profile, sleepFor: { d in vitals.night(for: d) }),
                             adjustments: report.makeAdjustments(profile: profile))
        return report
    }

    private func with(insights: [String], adjustments: [String]) -> MonthlyReport {
        MonthlyReport(period: period, goal: goal, exercises: exercises, sets: sets, setChanges: setChanges, workouts: workouts,
                      trainingMinutes: trainingMinutes, cardioKm: cardioKm, mobilityCount: mobilityCount, volume: volume,
                      nutrition: nutrition, supplements: supplements, supplementEntries: supplementEntries,
                      creatineStatus: creatineStatus, nights: nights, vitals: vitals, bodyStart: bodyStart, bodyEnd: bodyEnd,
                      performanceIndex: performanceIndex, insights: insights, adjustments: adjustments)
    }

    // MARK: Auswertung

    private func makeInsights(profile: UserProfile, sleepFor: (Date) -> NightSleep?) -> [String] {
        var out: [String] = []
        if let i = performanceIndex {
            out.append("Geschätzte Leistung: \(percentText(i)) im Schnitt über \(exercises.compactMap(\.performance).count) Übungen. "
                       + Progression.strengthVerdict(average: i, goal: profile.goal))
        } else if sets.isEmpty {
            out.append("In diesem Zeitraum sind keine Kraftsätze eingetragen.")
        } else {
            out.append("Für eine Leistungsschätzung braucht jede Übung mindestens zwei Einheiten oder Werte aus dem Vormonat.")
        }
        if let p = avgProtein, let target = nutrition.first?.proteinTarget {
            let perKg = profile.weightKg > 0 ? p / profile.weightKg : 0
            out.append(String(format: "Eiweiß: Ø %.0f g pro Tag (%.1f g/kg, Ziel %d g), Ziel an %d von %d erfassten Tagen erreicht.",
                              p, perKg, target, proteinDaysHit, nutrition.count))
            if perKg > 0 && perKg < 1.6 {
                out.append("Unter 1,6 g Eiweiß pro kg fällt der Muskelaufbau messbar schwächer aus. Ein Shake oder Quark am Abend schließt die Lücke.")
            }
        } else {
            out.append("Ernährung: keine Einträge im Zeitraum. Trage Mahlzeiten ein, dann wertet der Bericht Kalorien und Eiweiß aus.")
        }
        if let c = creatineStatus { out.append(c) }
        if let s = avgSleep {
            out.append(String(format: "Schlaf: Ø %.1f h pro Nacht (%d Nächte).", s, nights.count))
        }
        // Leistung nach gutem und kurzem Schlaf vergleichen
        var good: [Double] = [], short: [Double] = []
        for (_, logs) in Dictionary(grouping: sets, by: \.exercise) {
            let pts = Progression.sessionPoints(Progression.sessions(from: logs))
            guard pts.count >= 2, let mean = SleepMath.mean(pts.map(\.e1RM)), mean > 0 else { continue }
            for p in pts {
                guard let n = sleepFor(p.date) else { continue }
                if n.hours >= 7 { good.append(p.e1RM / mean) } else { short.append(p.e1RM / mean) }
            }
        }
        if good.count >= 3, short.count >= 3, let g = SleepMath.mean(good), let s = SleepMath.mean(short), s > 0 {
            let diff = (g - s) / s * 100
            out.append("Nach mindestens 7 h Schlaf war deine Leistung im Schnitt \(percentText(diff)) gegenüber kürzeren Nächten.")
        }
        if let a = bodyStart, let b = bodyEnd, a > 0, a != b {
            out.append("Körpergewicht: \(formatKg(a)) → \(formatKg(b)) kg (\(percentText((b - a) / a * 100))).")
        }
        return out
    }

    /// Konkrete Anpassungen pro Übung für den nächsten Monat
    private func makeAdjustments(profile: UserProfile) -> [String] {
        var out: [String] = []
        for r in exercises {
            guard let p = r.performance else { continue }
            if p <= -5 {
                out.append("\(r.name): \(percentText(p)). Gewicht 5–10 % senken, sauber im Zielbereich arbeiten, Schlaf und Eiweiß prüfen.")
            } else if abs(p) < 1, r.sessions >= 3, profile.goal == .muscle {
                out.append("\(r.name): Stillstand. Wiederholungsbereich wechseln oder eine Variante probieren.")
            } else if p >= 5 {
                out.append("\(r.name): \(percentText(p)). Weiter steigern, nächstes Mal +\(formatKg(r.bestWeight >= 60 ? 5 : 2.5)) kg versuchen.")
            }
        }
        if out.isEmpty && !exercises.isEmpty {
            out.append("Keine großen Ausreißer. Bleib beim Plan und steigere in kleinen Schritten.")
        }
        return out
    }

    // MARK: Tabellen

    var sheets: [ExportSheet] {
        let day = Date.FormatStyle(date: .numeric, time: .omitted)
        let dayTime = Date.FormatStyle(date: .numeric, time: .shortened)
        typealias C = ExportSheet.Cell

        var overview: [[C]] = [
            [.text("Zeitraum"), .text(period.title)],
            [.text("Ziel"), .text(goal)],
            [.text("Geschätzte Leistung (%)"), .num(performanceIndex)],
            [.text("Einheiten"), .int(workouts)],
            [.text("Trainingszeit (min)"), .int(trainingMinutes)],
            [.text("Kraftsätze"), .int(sets.count)],
            [.text("Volumen (kg)"), .number(volume)],
            [.text("Cardio (km)"), .number(cardioKm)],
            [.text("Mobility-Übungen"), .int(mobilityCount)],
            [.text("Essensfotos"), .int(MealPhotos.count(from: period.start, to: period.end))],
            [.text("Ø Kalorien pro Tag"), .num(avgKcal)],
            [.text("Ø Eiweiß pro Tag (g)"), .num(avgProtein)],
            [.text("Tage mit Eiweißziel"), .text("\(proteinDaysHit) von \(nutrition.count)")],
            [.text("Ø Schlaf (h)"), .num(avgSleep)],
            [.text("Ø HRV (ms)"), .num(avgHRV)],
            [.text("Ø Ruhepuls (bpm)"), .num(avgRHR)],
            [.text("Körpergewicht Anfang (kg)"), .num(bodyStart)],
            [.text("Körpergewicht Ende (kg)"), .num(bodyEnd)]
        ]
        for s in supplements {
            overview.append([.text("\(s.name) gesamt (\(s.unit))"), .number(s.total)])
        }
        overview += insights.map { [C.text("Auswertung"), C.text($0)] }
        overview += adjustments.map { [C.text("Anpassung"), C.text($0)] }

        let exerciseRows: [[C]] = exercises.map { r in
            [.text(r.name), .text(r.equipment), .int(r.sessions), .int(r.sets), .number(r.bestWeight), .int(r.repsAtBest),
             .number(r.volume), .number(r.firstE1RM), .number(r.lastE1RM), .num(r.previousBest),
             .num(r.changeInPeriod), .num(r.changeVsPrevious)]
        }
        let setRows: [[C]] = sets.map { s in
            [.text(s.date.formatted(dayTime)), .text(s.exercise), .number(s.weightKg), .int(s.reps), .number(s.e1RM),
             .num(setChanges[s.id])]
        }
        let foodRows: [[C]] = nutrition.map { n in
            [.text(n.day.formatted(day)), .number(n.kcal), .int(n.kcalTarget), .number(n.protein), .int(n.proteinTarget),
             .number(n.carbs), .number(n.fat)]
        }
        let suppRows: [[C]] = supplementEntries.map { e in
            [.text(e.date.formatted(dayTime)), .text(e.name), .number(e.amount), .text(e.unit)]
        }
        let vitalRows: [[C]] = period.days.map { d in
            let n = nights.first { $0.day == d }
            let v = vitals.first { $0.day == d }
            return [.text(d.formatted(day)), .num(n?.hours), .num(n.map { $0.deep / 3600 }), .num(n.map { $0.rem / 3600 }),
                    .text(n.map { $0.bedtime.formatted(date: .omitted, time: .shortened) } ?? ""),
                    .text(n.map { $0.wake.formatted(date: .omitted, time: .shortened) } ?? ""),
                    .num(v?.restingHR), .num(v?.hrv), .num(v?.avgHR), .num(v?.exerciseMin), .num(v?.activeKcal), .num(v?.mindfulMin)]
        }
        return [
            ExportSheet(name: "Übersicht", header: ["Kennzahl", "Wert"], rows: overview, widths: [30, 90]),
            ExportSheet(name: "Übungen", header: ["Übung", "Gerät", "Einheiten", "Sätze", "Bestes Gewicht (kg)", "Wdh. dabei",
                                                 "Volumen (kg)", "Leistung Anfang", "Leistung Ende", "Vormonat bestes",
                                                 "Veränderung im Monat (%)", "Veränderung zum Vormonat (%)"], rows: exerciseRows),
            ExportSheet(name: "Sätze", header: ["Datum", "Übung", "Gewicht (kg)", "Wdh./Sekunden", "Geschätztes Maximum",
                                               "Zur Einheit davor (%)"], rows: setRows),
            ExportSheet(name: "Ernährung", header: ["Tag", "kcal", "kcal Ziel", "Eiweiß (g)", "Eiweiß Ziel (g)",
                                                   "Kohlenhydrate (g)", "Fett (g)"], rows: foodRows),
            ExportSheet(name: "Supplements", header: ["Zeitpunkt", "Mittel", "Menge", "Einheit"], rows: suppRows),
            ExportSheet(name: "Schlaf und Vitalwerte", header: ["Tag", "Schlaf (h)", "Tiefschlaf (h)", "REM (h)", "Eingeschlafen",
                                                               "Aufgewacht", "Ruhepuls", "HRV (ms)", "Puls Ø", "Trainingsminuten",
                                                               "Aktive kcal", "Achtsamkeit (min)"], rows: vitalRows)
        ]
    }

    // MARK: Dateien

    func xlsxFile() -> URL? { SheetExport.write(SheetExport.xlsx(sheets), name: period.fileStem + ".xlsx") }

    func csvFile() -> URL? { SheetExport.write(Data(SheetExport.csv(sheets).utf8), name: period.fileStem + ".csv") }

    func pdfFile(name: String) -> URL? {
        let all = sheets
        var blocks: [ReportPDF.Block] = [.heading("Auswertung"), .bullets(insights)]
        if !adjustments.isEmpty { blocks += [.heading("Anpassungen für den nächsten Monat"), .bullets(adjustments)] }
        blocks.append(.heading("Kennzahlen"))
        let keyRows: [[ExportSheet.Cell]] = all[0].rows.filter { row in
            if case .text(let t)? = row.first { return t != "Auswertung" && t != "Anpassung" }
            return true
        }
        blocks.append(.table(ExportSheet(name: "", header: all[0].header, rows: keyRows, widths: [40, 60])))
        if !exercises.isEmpty {
            blocks.append(.heading("Übungen und Fortschritt"))
            let rows: [[ExportSheet.Cell]] = exercises.map { r in
                let best: String = r.bestWeight > 0 ? "\(formatKg(r.bestWeight)) kg × \(r.repsAtBest)" : "\(r.repsAtBest)"
                let inMonth: String = r.changeInPeriod.map { percentText($0) } ?? "–"
                let vsPrev: String = r.changeVsPrevious.map { percentText($0) } ?? "–"
                return [.text(r.name), .int(r.sets), .text(best), .number(r.lastE1RM), .text(inMonth), .text(vsPrev)]
            }
            blocks.append(.table(ExportSheet(name: "", header: ["Übung", "Sätze", "Bestes Gewicht", "Leistung Ende", "Im Monat", "Zum Vormonat"],
                                             rows: rows, widths: [34, 8, 16, 12, 11, 12])))
        }
        if !supplements.isEmpty {
            blocks.append(.heading("Supplements"))
            let rows: [[ExportSheet.Cell]] = supplements.map { s in
                [.text(s.name), .int(s.days), .text("\(amountText(s.total)) \(s.unit)"), .text("\(amountText(s.perTakenDay)) \(s.unit)")]
            }
            blocks.append(.table(ExportSheet(name: "", header: ["Mittel", "Tage", "Gesamt", "Ø pro Einnahmetag"],
                                             rows: rows, widths: [34, 8, 16, 18])))
        }
        if !nutrition.isEmpty {
            blocks.append(.heading("Ernährung"))
            blocks.append(.table(all[3]))
        }
        if !nights.isEmpty || !vitals.isEmpty {
            blocks.append(.heading("Schlaf und Vitalwerte"))
            let s = all[5]
            let rows: [[ExportSheet.Cell]] = s.rows.map { Array($0.prefix(8)) }.filter { r in
                r.dropFirst().contains { cell in
                    if case .number = cell { return true }
                    return false
                }
            }
            blocks.append(.table(ExportSheet(name: "", header: Array(s.header.prefix(8)), rows: rows)))
        }
        if !sets.isEmpty {
            blocks.append(.heading("Alle Sätze"))
            blocks.append(.table(all[2]))
        }
        blocks.append(.paragraph("Die Prozentwerte sind Schätzungen aus Gewicht und Wiederholungen (geschätztes Maximum nach Epley) und ersetzen keine Beratung durch Arzt oder Trainer."))
        let subtitle = (name.isEmpty ? "" : name + " · ") + "Ziel: \(goal) · erstellt am \(Date().formatted(date: .long, time: .omitted))"
        let data = ReportPDF.make(title: "Monatsbericht \(period.title)", subtitle: subtitle, blocks: blocks)
        return SheetExport.write(data, name: period.fileStem + ".pdf")
    }
}

// MARK: - Ansicht

struct MonthlyReportView: View {
    @EnvironmentObject var premium: PremiumStore
    @EnvironmentObject var store: TrainingStore
    @EnvironmentObject var sessions: SessionLog
    @EnvironmentObject var food: FoodLog
    @EnvironmentObject var supplements: SupplementStore
    @EnvironmentObject var vitals: VitalsStore
    @EnvironmentObject var profile: UserProfile
    @AppStorage("profileName") private var name = ""

    @State private var offset = 0
    @State private var files: [URL] = []
    @State private var working = false

    var body: some View {
        let period = ReportPeriod.month(offset: offset)
        let report = MonthlyReport.build(period: period, store: store, sessions: sessions, food: food,
                                         supplements: supplements, vitals: vitals, profile: profile)
        List {
            Section {
                HStack {
                    Button { offset += 1 } label: { Image(systemName: "chevron.left") }
                    Spacer()
                    Text(period.title).font(.headline)
                    Spacer()
                    Button { offset = max(0, offset - 1) } label: { Image(systemName: "chevron.right") }
                        .disabled(offset == 0)
                }
                .buttonStyle(.borderless)
            }

            if premium.has(.reports) {
                Section {
                    if files.isEmpty {
                        Button {
                            working = true
                            files = [report.xlsxFile(), report.pdfFile(name: name), report.csvFile()].compactMap { $0 }
                            working = false
                        } label: {
                            Label(working ? "Wird erstellt …" : "Excel- und PDF-Datei erstellen", systemImage: "doc.badge.arrow.up")
                        }
                    } else {
                        ForEach(files, id: \.self) { url in
                            ShareLink(item: url) {
                                Label(label(for: url), systemImage: icon(for: url))
                            }
                        }
                    }
                } header: {
                    Text("Teilen")
                } footer: {
                    Text("Excel enthält je ein Blatt für Übersicht, Übungen, Sätze, Ernährung, Supplements sowie Schlaf und Vitalwerte. Die Dateien entstehen auf deinem iPhone; du entscheidest, wem du sie schickst.")
                }

                Section("Auswertung") {
                    if let i = report.performanceIndex {
                        HStack {
                            Text("Geschätzte Leistung").bold()
                            Spacer()
                            PercentBadge(value: i)
                        }
                    }
                    ForEach(report.insights, id: \.self) { Label($0, systemImage: "lightbulb").font(.subheadline) }
                }
                if !report.adjustments.isEmpty {
                    Section("Anpassungen für den nächsten Monat") {
                        ForEach(report.adjustments, id: \.self) { Label($0, systemImage: "slider.horizontal.3").font(.subheadline) }
                    }
                }

                Section("Training") {
                    LabeledContent("Einheiten", value: "\(report.workouts)")
                    LabeledContent("Trainingszeit", value: "\(report.trainingMinutes) min")
                    LabeledContent("Kraftsätze", value: "\(report.sets.count)")
                    LabeledContent("Volumen", value: "\(formatKg(report.volume)) kg")
                    LabeledContent("Cardio", value: String(format: "%.1f km", report.cardioKm))
                    LabeledContent("Mobility-Übungen", value: "\(report.mobilityCount)")
                }

                if !report.exercises.isEmpty {
                    Section {
                        ForEach(report.exercises) { r in
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(r.name).bold()
                                    Spacer()
                                    PercentBadge(value: r.performance)
                                }
                                Text("\(r.sets) Sätze in \(r.sessions) Einheiten · bestes Gewicht \(formatKg(r.bestWeight)) kg × \(r.repsAtBest)")
                                    .font(.caption).foregroundStyle(.secondary)
                                HStack(spacing: 12) {
                                    if let c = r.changeInPeriod { Text("im Monat \(percentText(c))") }
                                    if let c = r.changeVsPrevious { Text("zum Vormonat \(percentText(c))") }
                                }
                                .font(.caption2).foregroundStyle(.secondary)
                            }
                        }
                    } header: {
                        Text("Übungen")
                    } footer: {
                        Text("Leistung = geschätztes Maximum aus Gewicht und Wiederholungen. Grün = stärker, rot = schwächer.")
                    }
                }

                Section {
                    LabeledContent("Ø Kalorien", value: report.avgKcal.map { "\(Int($0.rounded())) kcal" } ?? "–")
                    LabeledContent("Ø Eiweiß", value: report.avgProtein.map { "\(Int($0.rounded())) g" } ?? "–")
                    LabeledContent("Eiweißziel erreicht", value: "\(report.proteinDaysHit) von \(report.nutrition.count) Tagen")
                    ForEach(report.supplements) { s in
                        LabeledContent(s.name, value: "\(amountText(s.total)) \(s.unit) · \(s.days) Tage")
                    }
                    NavigationLink { SupplementsView() } label: { Label("Supplements eintragen", systemImage: "pills") }
                } header: {
                    Text("Ernährung und Supplements")
                }

                Section {
                    LabeledContent("Ø Schlaf", value: report.avgSleep.map { String(format: "%.1f h", $0) } ?? "–")
                    LabeledContent("Ø HRV", value: report.avgHRV.map { String(format: "%.0f ms", $0) } ?? "–")
                    LabeledContent("Ø Ruhepuls", value: report.avgRHR.map { String(format: "%.0f bpm", $0) } ?? "–")
                    NavigationLink { VitalsView() } label: { Label("Vitalwerte und Schlaf", systemImage: "waveform.path.ecg") }
                } header: {
                    Text("Schlaf und Erholung")
                }
            } else {
                Section { LockedRow(feature: .reports) }
            }
        }
        .navigationTitle("Monatsbericht")
        .onChange(of: offset) { _, _ in files = [] }
        .task { if vitals.lastLoad == nil { await vitals.refresh() } }
    }

    private func label(for url: URL) -> String {
        switch url.pathExtension {
        case "xlsx": return "Excel-Datei teilen (.xlsx)"
        case "pdf": return "PDF teilen"
        default: return "CSV teilen (für Numbers, Google Tabellen)"
        }
    }

    private func icon(for url: URL) -> String {
        switch url.pathExtension {
        case "xlsx": return "tablecells"
        case "pdf": return "doc.richtext"
        default: return "doc.plaintext"
        }
    }
}
