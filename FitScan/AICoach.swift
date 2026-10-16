import Combine
import SwiftUI
#if canImport(FoundationModels)
import FoundationModels
#endif

// KI-Coach: Trainingsziel wählen, Wochenplan bauen, Training auswerten und den Plan anpassen.
// Die Auswertung rechnet mit festen Regeln aus deinen eingetragenen Sätzen, Läufen und dem Gewicht.
// Den Begleittext schreibt, wenn verfügbar, Apples Sprachmodell direkt auf dem iPhone (Apple Intelligence);
// sonst entsteht er aus denselben Regeln. Es verlassen keine Daten das Gerät.

// MARK: - Trainingsziele

enum TrainingGoal: String, CaseIterable, Identifiable {
    case athletic = "Athletisch"
    case muscular = "Muskulös"
    case fatLoss = "Fettabbau"
    case muscleGain = "Muskelaufbau"
    case strength = "Kraft"
    case hybrid = "Hybrid"
    case calisthenics = "Calisthenics"
    case runner = "Läufer"
    case health = "Gesund und beweglich"
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .athletic: return "figure.run.circle"
        case .muscular: return "figure.strengthtraining.traditional"
        case .fatLoss: return "flame"
        case .muscleGain: return "dumbbell"
        case .strength: return "scalemass"
        case .hybrid: return "figure.mixed.cardio"
        case .calisthenics: return "figure.gymnastics"
        case .runner: return "figure.run"
        case .health: return "figure.mind.and.body"
        }
    }

    var summary: String {
        switch self {
        case .athletic: return "Kraft, Schnelligkeit und Ausdauer im Gleichgewicht. Definierte Optik, dazu eine Athletik-Einheit."
        case .muscular: return "Maximale Muskelmasse: viel Volumen pro Muskel, 6–12 Wiederholungen, Kalorienüberschuss."
        case .fatLoss: return "Fett verlieren und Muskeln halten: schweres Krafttraining, lockeres Cardio, viele Schritte, Defizit."
        case .muscleGain: return "Sauberer Muskelaufbau mit ausgewogenem Volumen und leichtem Überschuss."
        case .strength: return "Stärker werden in den Grundübungen: 3–6 Wiederholungen, lange Pausen."
        case .hybrid: return "Kraft und Laufen zusammen: 2–3 Krafteinheiten und Läufe in einer Woche."
        case .calisthenics: return "Training mit dem eigenen Körpergewicht: Klimmzüge, Dips, Liegestütze, Beine und Rumpf."
        case .runner: return "Laufen im Mittelpunkt, dazu zwei kurze Krafteinheiten gegen Verletzungen."
        case .health: return "Fit, kräftig und beweglich bleiben: Ganzkörper-Kraft plus Mobility."
        }
    }

    /// Grundziel, Optik und Zusatzsport im Profil
    var profileGoal: Goal {
        switch self {
        case .fatLoss: return .fatLoss
        case .runner, .health: return .maintain
        default: return .muscle
        }
    }
    var aesthetic: Aesthetic {
        switch self {
        case .muscular: return .bulky
        case .strength: return .strength
        case .fatLoss, .runner: return .lean
        default: return .defined
        }
    }
    var sport: Sport {
        switch self {
        case .hybrid, .athletic: return .hybrid
        case .runner: return .running
        case .calisthenics: return .calisthenics
        default: return .none
        }
    }

    /// Wie viele der Trainingstage Krafteinheiten sind
    func strengthDays(of total: Int) -> Int {
        let t = max(2, min(7, total))
        switch self {
        case .runner: return 2
        case .hybrid: return max(2, min(4, Int((Double(t) * 0.55).rounded())))
        case .athletic: return max(2, min(5, t - 1))
        case .fatLoss: return min(t, 4)
        case .health: return min(t, 3)
        default: return min(t, 6)
        }
    }
}

extension UserProfile {
    var trainingGoal: TrainingGoal? {
        get { TrainingGoal(rawValue: UserDefaults.standard.string(forKey: "trainingGoal") ?? "") }
        set {
            UserDefaults.standard.set(newValue?.rawValue ?? "", forKey: "trainingGoal")
            if let g = newValue {
                goal = g.profileGoal
                aesthetic = g.aesthetic
                sport = g.sport
            }
            objectWillChange.send()
        }
    }

    /// Deload: eine leichtere Woche nach langer Belastung oder Stillstand (0 = keine)
    var deloadUntil: Double {
        get { UserDefaults.standard.double(forKey: "deloadUntil") }
        set { UserDefaults.standard.set(newValue, forKey: "deloadUntil"); objectWillChange.send() }
    }
    var deloadActive: Bool { Date().timeIntervalSince1970 < deloadUntil }
}

// MARK: - Woche

struct WeekSession: Identifiable {
    enum Kind { case strength, run, conditioning, mobility, rest }
    let id = UUID()
    let weekday: String
    let kind: Kind
    let title: String
    let detail: String
    /// Index in PlanBuilder.plan bei Krafteinheiten
    var dayIndex: Int?

    var icon: String {
        switch kind {
        case .strength: return "dumbbell.fill"
        case .run: return "figure.run"
        case .conditioning: return "bolt.heart"
        case .mobility: return "figure.cooldown"
        case .rest: return "bed.double"
        }
    }
    var color: Color {
        switch kind {
        case .strength: return .red
        case .run: return .blue
        case .conditioning: return .orange
        case .mobility: return .green
        case .rest: return .secondary
        }
    }
}

enum CoachEngine {
    static let weekdays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]

    /// Wochenplan: Krafttage aus PlanBuilder, dazu Läufe, Athletik oder Mobility je nach Ziel, gleichmäßig verteilt
    static func week(profile: UserProfile) -> [WeekSession] {
        let goal = profile.trainingGoal ?? .muscleGain
        let total = max(2, min(7, profile.trainingDays))
        let days = PlanBuilder.plan(profile: profile)
        var extra: [WeekSession] = []
        let km = max(5, profile.weeklyRunKm)
        let extraCount = max(0, total - days.count)
        func session(_ k: WeekSession.Kind, _ t: String, _ d: String) -> WeekSession {
            WeekSession(weekday: "", kind: k, title: t, detail: d)
        }
        switch goal {
        case .runner, .hybrid:
            let runs = goal == .runner ? max(2, extraCount) : max(1, extraCount)
            let long = km * (runs >= 3 ? 0.4 : 0.5)
            let pool = [session(.run, "Langer Lauf", String(format: "%.0f km ruhig, du kannst dich dabei unterhalten", long)),
                        session(.run, "Intervalle", "Einlaufen, 6 × 3 Min. zügig mit 2 Min. Trabpause, Auslaufen"),
                        session(.run, "Lockerer Dauerlauf", String(format: "%.0f km im Wohlfühltempo", km * 0.25)),
                        session(.run, "Tempodauerlauf", "20 Min. zügig, aber kontrolliert"),
                        session(.run, "Lockerer Dauerlauf", String(format: "%.0f km locker", km * 0.15))]
            extra = Array(pool.prefix(runs))
        case .athletic:
            extra = Array([session(.conditioning, "Athletik", "Sprints 6 × 30 m, Sprünge, Seilspringen, Kniehebelauf"),
                           session(.run, "Lockerer Lauf", "30 Min. im Wohlfühltempo")].prefix(max(1, extraCount)))
        case .fatLoss:
            extra = (0..<extraCount).map { _ in session(.conditioning, "Lockeres Cardio", "30–45 Min. zügig gehen, Rad oder Crosstrainer (Puls im Gesprächstempo)") }
        case .health:
            extra = (0..<extraCount).map { _ in session(.mobility, "Mobility", "20 Min. Beweglichkeit, siehe Bereich Mobility") }
        default:
            extra = []
        }

        // Verteilen: Einheiten gleichmäßig über die Woche, Kraft und Zusatz abwechselnd, Rest Ruhe
        var plan = [WeekSession?](repeating: nil, count: 7)
        let extraUsed = Array(extra.prefix(max(0, 7 - days.count)))
        let all = days.count + extraUsed.count
        let step = 7.0 / Double(max(1, all))
        var order: [WeekSession] = []
        var si = 0, ei = 0
        for k in 0..<all {
            let strengthNow = (k + 1) * days.count / max(1, all) > k * days.count / max(1, all)
            if (strengthNow && si < days.count) || ei >= extraUsed.count {
                order.append(WeekSession(weekday: "", kind: .strength, title: days[si].name, detail: days[si].subtitle, dayIndex: si))
                si += 1
            } else {
                order.append(extraUsed[ei])
                ei += 1
            }
        }
        for (k, s) in order.enumerated() {
            var slot = min(6, Int((Double(k) * step).rounded()))
            while plan[slot] != nil { slot = (slot + 1) % 7 }
            plan[slot] = s
        }
        return plan.enumerated().map { i, s in
            let base = s ?? WeekSession(weekday: "", kind: .rest, title: "Ruhetag",
                                        detail: goal == .fatLoss ? "Schrittziel \(profile.stepGoal) erreichen" : "Spazieren, Dehnen, gut schlafen")
            return WeekSession(weekday: weekdays[i], kind: base.kind, title: base.title, detail: base.detail, dayIndex: base.dayIndex)
        }
    }

    // MARK: Auswertung

    struct Insight: Identifiable {
        enum Tone { case good, info, warn }
        enum Action { case focus([Muscle]), deload, logWeight }
        let id = UUID()
        let tone: Tone
        let title: String
        let text: String
        var action: Action?
    }

    static func analyze(store: TrainingStore, profile: UserProfile) -> [Insight] {
        var out: [Insight] = []
        let goal = profile.trainingGoal ?? .muscleGain
        let planned = PlanBuilder.plan(profile: profile).count
        let cal = Calendar.current

        // Regelmäßigkeit: Trainingstage der letzten 14 Tage
        let cutoff = Date().addingTimeInterval(-14 * 86_400)
        let trainedDays = Set(store.sets.filter { $0.date > cutoff }.map { cal.startOfDay(for: $0.date) }).count
        let perWeek = Double(trainedDays) / 2
        if store.sets.isEmpty {
            out.append(Insight(tone: .info, title: "Noch keine Daten",
                               text: "Trage deine Sätze ein, dann passe ich den Plan an deinen Fortschritt an."))
        } else if perWeek + 0.5 < Double(planned) {
            out.append(Insight(tone: .warn, title: "Weniger Krafteinheiten als geplant",
                               text: String(format: "Zuletzt %.1f statt %d pro Woche. Lieber weniger Tage einplanen und dafür alle schaffen: Regelmäßigkeit bringt mehr als ein perfekter Plan.", perWeek, planned)))
        } else {
            out.append(Insight(tone: .good, title: "Regelmäßig trainiert",
                               text: String(format: "%.1f Krafteinheiten pro Woche, wie geplant.", perWeek)))
        }

        // Kraftverlauf
        let progress = Progression.progress(for: store.sets.filter { $0.date > Date().addingTimeInterval(-56 * 86_400) })
        if !progress.isEmpty {
            let avg = progress.map(\.percent).reduce(0, +) / Double(progress.count)
            out.append(Insight(tone: avg >= 0 ? .good : .warn, title: String(format: "Kraft %+.1f %% in 8 Wochen", avg),
                               text: Progression.strengthVerdict(average: avg, goal: profile.goal)))
        }

        // Stillstand
        let names = Set(store.sets.map(\.exercise))
        let stuck = names.filter { Progression.isStagnating(store.sessions(for: $0)) }.sorted()
        if stuck.count >= 3 && !profile.deloadActive {
            out.append(Insight(tone: .warn, title: "Stillstand bei \(stuck.count) Übungen",
                               text: "\(stuck.prefix(4).joined(separator: ", ")) machen seit drei Einheiten keine Fortschritte. Eine leichtere Woche (Deload) lässt Gelenke und Nervensystem erholen; danach geht es meist weiter.",
                               action: .deload))
        } else if let s = stuck.first {
            out.append(Insight(tone: .info, title: "\(s) stagniert",
                               text: "Wechsle für 4–6 Wochen auf eine Variante derselben Übung (anderer Griff, andere Bank oder Kurzhantel statt Langhantel) oder senke das Gewicht um 10 % und steigere neu."))
        }

        // Lange ohne Pause
        let weeks = (0..<8).map { w -> Bool in
            let start = Date().addingTimeInterval(-Double(w + 1) * 7 * 86_400), end = start.addingTimeInterval(7 * 86_400)
            return Set(store.sets.filter { $0.date >= start && $0.date < end }.map { cal.startOfDay(for: $0.date) }).count >= max(2, planned - 1)
        }
        if weeks.allSatisfy({ $0 }) && stuck.count < 3 && !profile.deloadActive {
            out.append(Insight(tone: .info, title: "Acht Wochen am Stück trainiert",
                               text: "Stark! Plane in den nächsten zwei Wochen eine leichtere Woche ein, bevor die Müdigkeit sich aufstaut.", action: .deload))
        }

        // Volumen je Muskel
        let target = AnalysisEngine.weeklyTarget(goal: profile.goal)
        let sets7 = AnalysisEngine.muscleSets(store.sets, days: 7)
        if !store.sets.isEmpty && goal != .runner {
            let low = AnalysisEngine.trackedMuscles.filter { (sets7[$0] ?? 0) < target.lowerBound * 0.6 }
            if !low.isEmpty && low.count <= 5 {
                out.append(Insight(tone: .info, title: "Zu wenig Sätze: \(low.map(\.rawValue).joined(separator: ", "))",
                                   text: String(format: "Ziel sind %.0f–%.0f Sätze pro Muskel und Woche. Als Schwerpunkt bekommen diese Muskeln eine zusätzliche Übung im Plan.", target.lowerBound, target.upperBound),
                                   action: .focus(low)))
            }
        }

        // Laufumfang
        if goal == .runner || goal == .hybrid {
            let kms = AnalysisEngine.cardioKmPerWeek(store.cardio, weeks: 4).map(\.volume)
            if let last = kms.last, kms.count >= 2 {
                let before = kms.dropLast().max() ?? 0
                if before > 0 && last > before * 1.15 {
                    out.append(Insight(tone: .warn, title: String(format: "Laufumfang +%.0f %%", (last / before - 1) * 100),
                                       text: "Steigere den Wochenumfang um höchstens etwa 10 %, sonst steigt das Verletzungsrisiko (Schienbein, Achillessehne)."))
                } else if last < profile.weeklyRunKm * 0.7 {
                    out.append(Insight(tone: .info, title: String(format: "%.0f von %.0f km gelaufen", last, profile.weeklyRunKm),
                                       text: "Trage Läufe unter Sport und Laufen ein oder passe dein Wochenziel im Profil an."))
                }
            }
        }

        // Körpergewicht
        let bw = Progression.bodyWeightVerdict(entries: store.bodyEntries, goal: profile.goal)
        let hasTrend = store.bodyEntries.count >= 2
        out.append(Insight(tone: .info, title: "Körpergewicht", text: bw, action: hasTrend ? nil : .logWeight))

        if profile.deloadActive {
            let left = Int(ceil((profile.deloadUntil - Date().timeIntervalSince1970) / 86_400))
            out.insert(Insight(tone: .good, title: "Deload-Woche läuft (\(left) Tage)",
                               text: "Halb so viele Sätze und etwa 10 % weniger Gewicht. Danach startest du wieder mit deinen normalen Werten."), at: 0)
        }
        return out
    }

    /// Text aus den Regeln (wenn kein Sprachmodell verfügbar ist)
    static func ruleText(goal: TrainingGoal, insights: [Insight]) -> String {
        let warn = insights.filter { $0.tone == .warn }
        let good = insights.filter { $0.tone == .good }
        var s = "Dein Ziel: \(goal.rawValue). "
        if let g = good.first { s += g.title + ". " }
        if warn.isEmpty {
            s += "Alles im grünen Bereich: Bleib bei deinem Plan und steigere dich in kleinen Schritten."
        } else {
            s += "Worauf du diese Woche achten solltest: " + warn.map(\.title).joined(separator: "; ") + "."
        }
        return s
    }
}

// MARK: - Sprachmodell auf dem Gerät

@MainActor
final class CoachNarrator: ObservableObject {
    @Published var text = ""
    @Published var busy = false
    @Published var onDevice = false

    static var modelAvailable: Bool {
        #if canImport(FoundationModels)
        if case .available = SystemLanguageModel.default.availability { return true }
        #endif
        return false
    }

    func write(goal: TrainingGoal, profile: UserProfile, insights: [CoachEngine.Insight]) {
        let fallback = CoachEngine.ruleText(goal: goal, insights: insights)
        guard Self.modelAvailable else {
            text = fallback
            onDevice = false
            return
        }
        #if canImport(FoundationModels)
        busy = true
        let facts = insights.map { "- \($0.title): \($0.text)" }.joined(separator: "\n")
        let prompt = """
        Ziel: \(goal.rawValue) (\(goal.summary))
        Trainingstage pro Woche: \(profile.trainingDays), Erfahrung: \(profile.experience.rawValue)
        Auswertung:
        \(facts)
        """
        Task {
            do {
                let session = LanguageModelSession(instructions: """
                Du bist ein freundlicher, sachlicher Fitness-Coach in einer deutschen App. Schreibe auf Deutsch in der Du-Form \
                vier bis sechs kurze Sätze: was gut läuft, was diese Woche wichtig ist und ein konkreter nächster Schritt. \
                Nutze nur die genannten Fakten, erfinde keine Zahlen, keine medizinischen Diagnosen, keine Aufzählungszeichen.
                """)
                let r = try await session.respond(to: prompt)
                text = r.content.trimmingCharacters(in: .whitespacesAndNewlines)
                onDevice = true
            } catch {
                text = fallback
                onDevice = false
            }
            busy = false
        }
        #endif
    }
}

// MARK: - Ansicht

struct CoachView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var store: TrainingStore
    @StateObject private var narrator = CoachNarrator()
    @State private var picked: TrainingGoal?

    private var goal: TrainingGoal { profile.trainingGoal ?? .muscleGain }

    var body: some View {
        let insights = CoachEngine.analyze(store: store, profile: profile)
        let week = CoachEngine.week(profile: profile)
        List {
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(TrainingGoal.allCases) { g in
                            Button { picked = g } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: g.icon).font(.title2)
                                    Text(g.rawValue).font(.caption.weight(.semibold)).multilineTextAlignment(.center)
                                }
                                .frame(width: 96, height: 82)
                                .background(profile.trainingGoal == g ? Color.accentColor.opacity(0.25) : Color(.secondarySystemBackground),
                                            in: RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(profile.trainingGoal == g ? Color.accentColor : .clear, lineWidth: 2))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                if let g = profile.trainingGoal {
                    Text(g.summary).font(.subheadline)
                } else {
                    Text("Wähle ein Ziel, dann baue ich deinen Wochenplan darauf auf.").font(.subheadline).foregroundStyle(.secondary)
                }
            } header: {
                Text("Dein Ziel")
            }

            Section {
                Stepper(value: Binding(get: { profile.trainingDays }, set: { profile.trainingDays = $0; profile.objectWillChange.send() }), in: 2...7) {
                    Text("\(profile.trainingDays) Trainingstage pro Woche")
                }
                Picker("Ausstattung", selection: Binding(get: { profile.setup }, set: { profile.setup = $0 })) {
                    ForEach(Setup.allCases) { Text($0.rawValue).tag($0) }
                }
                Picker("Erfahrung", selection: Binding(get: { profile.experience }, set: { profile.experience = $0 })) {
                    ForEach(Experience.allCases) { Text($0.rawValue).tag($0) }
                }
                if goal == .runner || goal == .hybrid {
                    Stepper(value: Binding(get: { profile.weeklyRunKm }, set: { profile.weeklyRunKm = $0; profile.objectWillChange.send() }),
                            in: 5...120, step: 5) {
                        Text("\(Int(profile.weeklyRunKm)) km pro Woche")
                    }
                }
            } header: {
                Text("Rahmen")
            }

            Section {
                ForEach(week) { s in
                    HStack(spacing: 12) {
                        Text(s.weekday).font(.subheadline.bold()).frame(width: 28, alignment: .leading)
                        Image(systemName: s.icon).foregroundStyle(s.color).frame(width: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(s.title)
                            Text(s.detail).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text("Deine Woche")
            } footer: {
                Text("Die Krafttage mit allen Übungen stehen im Trainingsplan. Der Plan passt sich an, sobald du Ziel, Tage oder Ausstattung änderst.")
            }

            Section {
                if narrator.busy {
                    HStack { ProgressView(); Text("Coach schreibt …").foregroundStyle(.secondary) }
                } else if !narrator.text.isEmpty {
                    Text(narrator.text)
                }
                Button { narrator.write(goal: goal, profile: profile, insights: insights) } label: {
                    Label(narrator.text.isEmpty ? "Einschätzung schreiben" : "Neu schreiben", systemImage: "sparkles")
                }
                .disabled(narrator.busy)
            } header: {
                Text("Coach")
            } footer: {
                Text(CoachNarrator.modelAvailable
                     ? "Geschrieben von Apple Intelligence direkt auf deinem iPhone. Es werden keine Daten gesendet."
                     : "Apple Intelligence ist auf diesem Gerät nicht verfügbar; die Einschätzung entsteht aus festen Regeln.")
            }

            Section("Analyse") {
                ForEach(insights) { i in
                    VStack(alignment: .leading, spacing: 6) {
                        Label(i.title, systemImage: i.tone == .good ? "checkmark.seal.fill" : (i.tone == .warn ? "exclamationmark.triangle.fill" : "info.circle.fill"))
                            .foregroundStyle(i.tone == .good ? Color.green : (i.tone == .warn ? Color.orange : Color.accentColor))
                            .font(.subheadline.weight(.semibold))
                        Text(i.text).font(.subheadline)
                        if let a = i.action { actionButton(a) }
                    }
                    .padding(.vertical, 2)
                }
            }

            Section {
                NavigationLink { AnalysisView() } label: { Label("Ausführliche Auswertung", systemImage: "chart.xyaxis.line") }
            }
        }
        .navigationTitle("KI-Coach")
        .confirmationDialog(picked.map { "Ziel „\($0.rawValue)“ übernehmen?" } ?? "", isPresented: Binding(get: { picked != nil }, set: { if !$0 { picked = nil } }),
                            titleVisibility: .visible) {
            Button("Übernehmen") {
                if let p = picked { profile.trainingGoal = p }
                picked = nil
                narrator.text = ""
            }
            Button("Abbrechen", role: .cancel) { picked = nil }
        } message: {
            Text(picked.map { "\($0.summary)\n\nZiel, Optik und Zusatzsport im Profil werden dafür angepasst." } ?? "")
        }
    }

    @ViewBuilder private func actionButton(_ a: CoachEngine.Insight.Action) -> some View {
        switch a {
        case .focus(let muscles):
            let missing = Set(muscles).subtracting(profile.focusMuscles)
            Button(missing.isEmpty ? "Schon als Schwerpunkt im Plan" : "Als Schwerpunkt in den Plan") {
                profile.focusMuscles = profile.focusMuscles.union(muscles)
            }
            .buttonStyle(.bordered).disabled(missing.isEmpty)
        case .deload:
            Button("Deload-Woche starten") { profile.deloadUntil = Date().addingTimeInterval(7 * 86_400).timeIntervalSince1970 }
                .buttonStyle(.bordered)
        case .logWeight:
            NavigationLink("Gewicht eintragen") { AnalysisView() }
        }
    }
}
