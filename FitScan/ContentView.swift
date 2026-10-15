import Charts
import Combine
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var health: HealthManager
    @EnvironmentObject var tracker: StepTracker
    @EnvironmentObject var nav: AppNav
    @EnvironmentObject var rank: RankStore
    /// Reiter werden beim ersten Öffnen erzeugt und bleiben danach erhalten (Scroll-Stand, Eingaben)
    @State private var visited: Set<Int> = [0]
    @AppStorage("bfc.consent.answered") private var consentAnswered = false
    @AppStorage("bfc.consent.health") private var consentHealth = false

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
        .task(id: consentHealth) {
            if consentHealth { await health.requestAuthorization() } else { health.stopLiveUpdates() }
        }
        .onChange(of: consentAnswered) { _, answered in if answered { tracker.start() } }
        .overlay { RankUpOverlay() }
        .animation(.easeInOut, value: rank.pendingRankUp?.index)
        .fullScreenCover(isPresented: Binding(get: { !consentAnswered }, set: { _ in })) { ConsentView() }
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
    @EnvironmentObject var rank: RankStore
    @EnvironmentObject var sessionLog: SessionLog

    var body: some View {
        NavigationStack {
            let dayType = log.dayType(day: Date(), fallback: profile.defaultDayType)
            let targets = profile.targets(for: dayType)
            let eaten = log.totals(day: Date())
            List {
                TrialBanner()
                Section { RankCard() } footer: { Text("„\(RankQuotes.daily())“") }
                Section {
                    StepsCard(steps: health.displaySteps(phone: tracker.steps), goal: profile.stepGoal, history: health.stepsHistory,
                              live: tracker.live && !health.usesWatchSteps)
                    NavigationLink { StepSourceView() } label: { StepSourceRow() }
                } header: {
                    Text("Schritte")
                } footer: {
                    Text("Empfohlenes Ziel für „\(profile.goal.rawValue)“ (Tempo \(profile.pace.rawValue)): \(profile.recommendedSteps) Schritte. Anpassen im Profil.")
                }
                Section {
                    LifetimeStepsRow()
                    NavigationLink { ShareStudioView() } label: {
                        Label("Ergebnisse teilen (Instagram, TikTok, WhatsApp …)", systemImage: "square.and.arrow.up")
                    }
                } header: {
                    Text("Lifetime und Teilen")
                } footer: {
                    Text("Wähle beim Teilen zwischen Schrittzähler, Gym-Zeit, Essen, Lauf-Strecke (auch transparent) und Rang.")
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
                    NavigationLink { DietCoachView() } label: {
                        Label("Diät-Coach: was essen, ohne Hunger", systemImage: "fork.knife.circle")
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
                    NavigationLink { ReportsView() } label: { Label("Wochen- und Monatsberichte", systemImage: "calendar.badge.clock") }
                    NavigationLink { PlanExportView() } label: { Label("Plan als PDF", systemImage: "doc.richtext") }
                    NavigationLink { BackupView() } label: { Label("Backup und Gerätewechsel", systemImage: "externaldrive") }
                }
            }
            .navigationTitle("Heute")
            .refreshable { await health.refresh() }
            .onChange(of: syncKey()) { _, _ in sync(targets: targets) }
            .onAppear { sync(targets: targets) }
        }
    }

    private func syncKey() -> String {
        "\(health.displaySteps(phone: tracker.steps))-\(log.entries.count)-\(log.waterML(day: Date()))"
    }

    private func sync(targets: DayTargets) {
        let today = FoodLog.key(Date())
        rank.syncToday(steps: health.displaySteps(phone: tracker.steps), stepGoal: profile.stepGoal,
                       foodEntries: log.entries.filter { $0.day == today }.count,
                       waterGoalReached: log.waterML(day: Date()) >= targets.waterML)
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
    @EnvironmentObject var avatar: AvatarStore
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
                    if let img = avatar.image {
                        Image(uiImage: img).resizable().scaledToFill()
                            .frame(width: 62, height: 62).clipShape(Circle())
                    } else {
                        Image(systemName: "figure.walk").font(.title2)
                    }
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


/// Lifetime-Schritte aus Apple Health (alle Quellen: iPhone, Apple Watch, Garmin & Co. über Health).
struct LifetimeStepsRow: View {
    @EnvironmentObject var health: HealthManager
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Label("Lifetime-Schritte", systemImage: "infinity")
                Spacer()
                Text(health.lifetimeSteps.formatted()).font(.headline).monospacedDigit()
            }
            if let d = health.firstStepDate {
                Text("seit \(d.formatted(date: .abbreviated, time: .omitted)) · ca. \(Int(health.lifetimeKm.rounded()).formatted()) km")
                    .font(.footnote).foregroundStyle(.secondary)
            } else if !health.isAuthorized {
                Text("Erlaube Apple Health, damit alle deine Schritte zählen.").font(.footnote).foregroundStyle(.secondary)
            }
            Text("Garmin, Fitbit & Co.: In deren App „Apple Health“ aktivieren, dann zählen die Schritte hier mit.")
                .font(.caption2).foregroundStyle(.secondary)
        }
    }
}
