import Charts
import Combine
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var health: HealthManager
    @EnvironmentObject var nav: AppNav
    /// Reiter werden beim ersten Öffnen erzeugt und bleiben danach erhalten (Scroll-Stand, Eingaben)
    @State private var visited: Set<Int> = [0]

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                page(0) { DashboardView() }
                page(1) { TrainingView() }
                page(2) { EssenTabView() }
                page(3) { NavigationStack { MobilityView() } }
                page(4) { NavigationStack { ProfileView() } }
            }
            MainTabBar()
        }
        .onChange(of: nav.tab) { _, t in visited.insert(t) }
        .task { await health.requestAuthorization() }
    }

    @ViewBuilder private func page<Content: View>(_ i: Int, @ViewBuilder content: () -> Content) -> some View {
        if visited.contains(i) || nav.tab == i {
            content()
                .opacity(nav.tab == i ? 1 : 0)
                .allowsHitTesting(nav.tab == i)
                .accessibilityHidden(nav.tab != i)
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var health: HealthManager
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var store: TrainingStore
    @EnvironmentObject var log: FoodLog
    @EnvironmentObject var tracker: StepTracker
    @EnvironmentObject var session: WorkoutSession
    @EnvironmentObject var nav: AppNav
    @EnvironmentObject var scan: ScanSchedule

    var body: some View {
        NavigationStack {
            let dayType = log.dayType(day: Date(), fallback: profile.defaultDayType)
            let targets = profile.targets(for: dayType)
            let eaten = log.totals(day: Date())
            List {
                Section {
                    StepsCard(steps: max(health.stepsToday, tracker.steps), goal: profile.stepGoal, history: health.stepsHistory, live: tracker.live)
                } header: {
                    Text("Schritte")
                } footer: {
                    Text("Live vom iPhone-Bewegungssensor, der Verlauf aus Apple Health. Empfohlenes Ziel für „\(profile.goal.rawValue)“ (Tempo \(profile.pace.rawValue)): \(profile.recommendedSteps) Schritte. Anpassen im Profil.")
                }
                Section {
                    NavigationLink { WorkoutTrackerView() } label: {
                        Label(session.running ? "Training läuft: \(WorkoutSession.clock(session.elapsed))" : "Training aufzeichnen",
                              systemImage: session.running ? "record.circle" : "play.circle")
                    }
                }
                Section("Ernährung heute (\(dayType.rawValue))") {
                    bar("Kalorien", eaten.kcal, Double(targets.kcal), "kcal")
                    bar("Protein", eaten.protein, Double(targets.protein), "g")
                    bar("Kohlenhydrate", eaten.carbs, Double(targets.carbs), "g")
                    bar("Fett", eaten.fat, Double(targets.fat), "g")
                    row("Salz", String(format: "%.1f / %.0f g", eaten.salt, targets.saltMax))
                    row("Wasser", String(format: "%.2f / %.2f l", Double(log.waterML(day: Date())) / 1000, Double(targets.waterML) / 1000))
                    ForEach(Array(log.entries.filter { $0.day == FoodLog.key(Date()) }.suffix(4).reversed())) { e in
                        HStack {
                            Text(e.name).lineLimit(1)
                            Spacer()
                            Text("\(Int(e.kcal.rounded())) kcal").foregroundStyle(.secondary).monospacedDigit()
                        }
                        .font(.footnote)
                    }
                    Button { nav.essenPage = .scan; nav.tab = 2 } label: {
                        Label("Produkt scannen oder suchen", systemImage: "barcode.viewfinder")
                    }
                    NavigationLink { FoodHistoryView() } label: {
                        Label("Ernährungs-Analyse und Verlauf", systemImage: "chart.bar.doc.horizontal")
                    }
                }
                Section("Aus Apple Health") {
                    row("Aktive Energie", "\(health.activeEnergyToday) kcal")
                    row("Gewicht", health.latestWeightKg.map { String(format: "%.1f kg", $0) } ?? "–")
                    row("Ruhepuls", health.restingHeartRate.map { "\($0) bpm" } ?? "–")
                    row("Workouts (30 Tage)", "\(health.workoutsLast30Days)")
                }
                Section("Körperscan") {
                    NavigationLink { ScanCheckInView() } label: {
                        Label(scan.statusText, systemImage: scan.isDue ? "exclamationmark.circle.fill" : "calendar.badge.clock")
                            .foregroundStyle(scan.isDue ? Color.orange : Color.primary)
                    }
                }
                Section("Körperfett (Schätzung)") {
                    row("Aktuell", profile.bodyFatEstimate.map { String(format: "%.1f %%", $0) } ?? "Bitte Maße im Profil eintragen")
                    row("Ziel", String(format: "%.1f %%", profile.targetBodyFat))
                    if let w = profile.weeksToGoal {
                        row("Voraussichtlich", "ca. \(w) Wochen (\(profile.pace.rawValue))")
                    }
                }
                Section("Mehr") {
                    NavigationLink { SportView() } label: { Label("Sport und Laufen", systemImage: "figure.run") }
                    NavigationLink { AnalysisView() } label: { Label("Analyse", systemImage: "chart.line.uptrend.xyaxis") }
                }
            }
            .navigationTitle("Heute")
            .refreshable { await health.refresh() }
        }
    }

    private func bar(_ title: String, _ value: Double, _ goal: Double, _ unit: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                Text("\(Int(value.rounded())) / \(Int(goal)) \(unit)").foregroundStyle(.secondary).monospacedDigit()
            }
            ProgressView(value: min(value / max(goal, 1), 1))
                .tint(value > goal * 1.1 ? Color.orange : Color.accentColor)
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack { Text(title); Spacer(); Text(value).foregroundStyle(.secondary) }
    }
}

/// Schrittzähler: Fortschrittsring für heute und Balken der letzten 7 Tage mit Zielmarke.
struct StepsCard: View {
    let steps: Int
    let goal: Int
    let history: [DaySteps]
    var live = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    Circle().stroke(Color.secondary.opacity(0.2), lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: min(1, Double(steps) / Double(max(goal, 1))))
                        .stroke(steps >= goal ? Color.green : Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "figure.walk").font(.title2)
                }
                .frame(width: 84, height: 84)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("\(steps)").font(.system(size: 34, weight: .bold, design: .rounded)).monospacedDigit()
                        if live { Label("live", systemImage: "dot.radiowaves.left.and.right").font(.caption).foregroundStyle(.green) }
                    }
                    Text("Ziel \(goal) Schritte").font(.footnote).foregroundStyle(.secondary)
                    Text(steps >= goal ? "Ziel erreicht" : "Noch \(max(0, goal - steps)) bis zum Ziel")
                        .font(.footnote)
                }
                Spacer()
            }
            if !history.isEmpty {
                Chart {
                    ForEach(history) { d in
                        BarMark(x: .value("Tag", d.date, unit: .day), y: .value("Schritte", d.steps))
                            .foregroundStyle(d.steps >= goal ? Color.green : Color.accentColor)
                    }
                    RuleMark(y: .value("Ziel", goal))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundStyle(.secondary)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisValueLabel(format: .dateTime.weekday(.narrow))
                    }
                }
                .frame(height: 110)
            }
        }
        .padding(.vertical, 4)
    }
}
