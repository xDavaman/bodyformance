import Combine
import SwiftUI
import Charts

// MARK: - Auswertung

enum AnalysisEngine {
    /// Sätze pro Muskel in den letzten Tagen (Hauptmuskel = 1, Hilfsmuskel = 0,5).
    static func muscleSets(_ sets: [SetLog], days: Int) -> [Muscle: Double] {
        let cutoff = Date().addingTimeInterval(-Double(days) * 86_400)
        var result: [Muscle: Double] = [:]
        for s in sets where s.date > cutoff {
            guard let ex = ExerciseCatalog.exercise(named: s.exercise) else { continue }
            for m in ex.primary { result[m, default: 0] += 1 }
            for m in ex.secondary { result[m, default: 0] += 0.5 }
        }
        return result
    }

    /// Wochenziel in Sätzen je Muskel (Orientierung).
    static func weeklyTarget(goal: Goal) -> ClosedRange<Double> {
        switch goal {
        case .muscle: return 10...16
        case .maintain, .fatLoss: return 5...9
        }
    }

    static let trackedMuscles: [Muscle] = [.chest, .lats, .traps, .shoulders, .biceps, .triceps, .abs, .quads, .hamstrings, .glutes, .calves]

    static func cardioKmPerWeek(_ logs: [CardioLog], weeks: Int) -> [WeekVolume] {
        let cal = Calendar.current
        guard let thisWeek = cal.dateInterval(of: .weekOfYear, for: Date())?.start else { return [] }
        return (0..<weeks).reversed().compactMap { i in
            guard let start = cal.date(byAdding: .weekOfYear, value: -i, to: thisWeek),
                  let end = cal.date(byAdding: .weekOfYear, value: 1, to: start) else { return nil }
            let km = logs.filter { $0.date >= start && $0.date < end }.reduce(0) { $0 + $1.km }
            return WeekVolume(start: start, volume: km)
        }
    }
}

struct AnalysisView: View {
    @EnvironmentObject var store: TrainingStore
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var health: HealthManager
    @EnvironmentObject var premium: PremiumStore

    @State private var bodyWeight: Double = 80

    var body: some View {
        List {
            summarySection
            nextSessionSection
            if premium.has(.fullAnalyses) {
                progressSection
                volumeSection
                muscleSection
                cardioSection
                mobilitySection
                bodyWeightSection
            } else {
                Section { LockedRow(feature: .fullAnalyses) }
            }
        }
        .navigationTitle("Analyse")
        .onAppear { bodyWeight = profile.weightKg }
    }

    // MARK: Zusammenfassung

    private var advice: [String] {
        var lines: [String] = []
        let sets7 = AnalysisEngine.muscleSets(store.sets, days: 7)
        let target = AnalysisEngine.weeklyTarget(goal: profile.goal)
        let low = AnalysisEngine.trackedMuscles.filter { (sets7[$0] ?? 0) < target.lowerBound }
        if store.sets.isEmpty {
            lines.append("Trage deine ersten Sätze ein, dann beginnt die Auswertung.")
        } else if !low.isEmpty {
            lines.append("Diese Woche noch zu wenig Training für: \(low.prefix(4).map(\.rawValue).joined(separator: ", ")).")
        }
        let push = [Muscle.chest, .shoulders, .triceps].map { sets7[$0] ?? 0 }.reduce(0, +)
        let pull = [Muscle.lats, .traps, .biceps].map { sets7[$0] ?? 0 }.reduce(0, +)
        if push > 6, pull < push * 0.7 {
            lines.append("Du drückst deutlich mehr als du ziehst. Ergänze Rudern oder Klimmzüge, das schont die Schultern.")
        } else if pull > 6, push < pull * 0.5 {
            lines.append("Du ziehst deutlich mehr als du drückst. Ergänze Druckübungen für ein ausgewogenes Verhältnis.")
        }
        let counts = MobilityPlanner.recentCounts(store.mobility)
        let weights = MobilityRegion.allCases.map { ($0, MobilityPlanner.weight(of: $0, sport: profile.sport)) }.filter { $0.1 >= 2.5 }
        let neglected = weights.filter { (counts[$0.0] ?? 0) == 0 }.map { $0.0.rawValue }
        if !neglected.isEmpty {
            lines.append("Mobility: Für \(neglected.joined(separator: ", ")) hast du in 14 Tagen nichts gemacht, das ist für deinen Sport wichtig.")
        }
        if profile.sport == .running || profile.sport == .hybrid {
            let km = max(health.runningKm7Days, store.cardio.filter { $0.date > Date().addingTimeInterval(-7 * 86_400) }.map(\.km).reduce(0, +))
            if km < profile.weeklyRunKm * 0.5 {
                lines.append("Laufumfang: erst \(String(format: "%.0f", km)) von \(Int(profile.weeklyRunKm)) km diese Woche.")
            }
        }
        if lines.isEmpty { lines.append("Alles im grünen Bereich. Bleib bei deinem Plan.") }
        return lines
    }

    private var summarySection: some View {
        Section {
            ForEach(advice, id: \.self) { line in
                Label(line, systemImage: "lightbulb")
                    .font(.subheadline)
            }
            NavigationLink("Ziel, Optik und Schwerpunkt ändern") { ProfileView() }
        } header: {
            Text("Empfehlungen für \(profile.goal.rawValue)")
        }
    }

    // MARK: Plan-Update

    private var nextSessionSection: some View {
        let plan = profile.effectivePlan
        return Section {
            ForEach(PlanBuilder.uniqueExercises(profile: profile)) { ex in
                let rec = Progression.recommend(
                    exercise: ex, goal: profile.goal, plan: plan,
                    sessions: store.sessions(for: ex.name), bodyWeight: profile.weightKg)
                NavigationLink {
                    ExerciseDetailView(exercise: ex)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(ex.name)
                            Spacer()
                            if ex.kind == .weighted, let w = rec.weightKg {
                                Text("\(formatKg(w)) kg").bold()
                            }
                        }
                        Text(Progression.prescription(for: ex, plan: plan))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        if let warning = rec.warning {
                            Text(warning).font(.footnote).foregroundStyle(.orange)
                        }
                    }
                }
            }
        } header: {
            Text("Plan für die nächste Einheit")
        } footer: {
            Text("Der Plan passt sich nach jedem eingetragenen Satz automatisch an dein Ziel und deine Leistung an.")
        }
    }

    // MARK: Fortschritt

    @ViewBuilder
    private var progressSection: some View {
        let progress = Progression.progress(for: store.sets)
        Section("Fortschritt seit der ersten Einheit") {
            if progress.isEmpty {
                Text("Trage pro Übung an mindestens zwei Trainingstagen Sätze ein, dann siehst du hier deinen Fortschritt in Prozent.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                let average = progress.map(\.percent).reduce(0, +) / Double(progress.count)
                LabeledContent("Durchschnitt", value: percentText(average))
                    .bold()
                ForEach(progress) { p in
                    HStack {
                        Text(p.name)
                        Spacer()
                        Text(percentText(p.percent))
                            .foregroundStyle(p.percent >= 0 ? .green : .red)
                    }
                }
                Text(Progression.strengthVerdict(average: average, goal: profile.goal))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: Volumen

    @ViewBuilder
    private var volumeSection: some View {
        let volumes = Progression.weeklyVolume(sets: store.sets.filter { $0.weightKg > 0 }, weeks: 4)
        if volumes.contains(where: { $0.volume > 0 }) {
            Section("Wochenvolumen (Gewicht × Wiederholungen)") {
                Chart(volumes) { w in
                    BarMark(x: .value("Woche", w.start, unit: .weekOfYear),
                            y: .value("Volumen in kg", w.volume))
                }
                .frame(height: 160)
            }
        }
    }

    // MARK: Muskeln

    @ViewBuilder
    private var muscleSection: some View {
        let sets7 = AnalysisEngine.muscleSets(store.sets, days: 7)
        let target = AnalysisEngine.weeklyTarget(goal: profile.goal)
        let low = AnalysisEngine.trackedMuscles.filter { (sets7[$0] ?? 0) < target.lowerBound }
        let done = AnalysisEngine.trackedMuscles.filter { (sets7[$0] ?? 0) >= target.lowerBound }
        Section {
            ForEach(AnalysisEngine.trackedMuscles) { m in
                let v = sets7[m] ?? 0
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(m.rawValue)
                        Spacer()
                        Text("\(String(format: "%.1f", v)) / \(Int(target.lowerBound))–\(Int(target.upperBound)) Sätze")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    ProgressView(value: min(1, v / target.lowerBound))
                        .tint(v >= target.lowerBound ? .green : .orange)
                }
            }
            if !store.sets.isEmpty {
                MuscleModelView(primary: low, secondary: done, height: 260)
                    .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            }
        } header: {
            Text("Muskeln: Sätze in den letzten 7 Tagen")
        } footer: {
            Text("3D-Ansicht: rot = noch zu wenig trainiert, orange = Wochenziel erreicht. Hilfsmuskeln zählen halb.")
        }
    }

    // MARK: Cardio

    @ViewBuilder
    private var cardioSection: some View {
        if profile.sport == .running || profile.sport == .hybrid || !store.cardio.isEmpty {
            let weeks = AnalysisEngine.cardioKmPerWeek(store.cardio, weeks: 6)
            Section {
                if weeks.contains(where: { $0.volume > 0 }) {
                    Chart(weeks) { w in
                        BarMark(x: .value("Woche", w.start, unit: .weekOfYear), y: .value("km", w.volume))
                    }
                    .frame(height: 140)
                } else {
                    Text("Trage Läufe im Tab Sport ein, dann erscheint hier dein Wochenumfang.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                LabeledContent("Apple Health: Laufen 28 Tage", value: String(format: "%.1f km", health.runningKm28Days))
            } header: {
                Text("Laufen: Kilometer pro Woche")
            }
        }
    }

    // MARK: Mobility

    private var mobilitySection: some View {
        let counts = MobilityPlanner.recentCounts(store.mobility)
        return Section {
            ForEach(MobilityRegion.allCases) { r in
                HStack {
                    Label(r.rawValue, systemImage: r.icon)
                    Spacer()
                    Text("\(counts[r] ?? 0)× in 14 Tagen")
                        .font(.footnote)
                        .foregroundStyle((counts[r] ?? 0) == 0 ? .orange : .secondary)
                }
            }
            NavigationLink { MobilityView() } label: { Text("Mobility-Empfehlung öffnen") }
        } header: {
            Text("Mobility")
        } footer: {
            Text("Regionen, die für deinen Sport wichtig sind und länger nicht dran waren, schlägt dir die App zuerst vor.")
        }
    }

    // MARK: Körpergewicht

    private var bodyWeightSection: some View {
        Section {
            Stepper(value: $bodyWeight, in: 30...250, step: 0.1) {
                Text("Heute: \(formatKg(bodyWeight)) kg")
            }
            Button("Gewicht eintragen") {
                store.addBody(weightKg: bodyWeight)
                profile.weightKg = bodyWeight
            }
            if let hw = health.latestWeightKg {
                Button("Aus Apple Health übernehmen (\(formatKg(hw)) kg)") {
                    store.addBody(weightKg: hw)
                    profile.weightKg = hw
                    bodyWeight = hw
                }
            }
            if store.bodyEntries.count >= 2 {
                Chart(store.bodyEntries.sorted { $0.date < $1.date }) { e in
                    LineMark(x: .value("Datum", e.date), y: .value("kg", e.weightKg))
                    PointMark(x: .value("Datum", e.date), y: .value("kg", e.weightKg))
                }
                .chartYScale(domain: .automatic(includesZero: false))
                .frame(height: 160)
            }
            Text(Progression.bodyWeightVerdict(entries: store.bodyEntries, goal: profile.goal))
                .font(.footnote)
                .foregroundStyle(.secondary)
        } header: {
            Text("Körpergewicht")
        } footer: {
            Text("Die Zahlen sind allgemeine Faustregeln und ersetzen keine Beratung durch Arzt oder Trainer. Bei Schmerzen oder Beschwerden das Training abbrechen.")
        }
    }
}
