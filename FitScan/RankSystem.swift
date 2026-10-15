import Combine
import SwiftUI
import UIKit

// MARK: - Ränge

enum RankTier: Int, CaseIterable, Codable {
    case bronze, silber, gold, platin, diamant

    var name: String { ["Bronze", "Silber", "Gold", "Platin", "Diamant"][rawValue] }
    var colors: [Color] {
        switch self {
        case .bronze: return [Color(red: 0.80, green: 0.50, blue: 0.20), Color(red: 0.52, green: 0.28, blue: 0.10)]
        case .silber: return [Color(red: 0.88, green: 0.90, blue: 0.93), Color(red: 0.55, green: 0.58, blue: 0.64)]
        case .gold: return [Color(red: 1.00, green: 0.85, blue: 0.30), Color(red: 0.78, green: 0.55, blue: 0.08)]
        case .platin: return [Color(red: 0.62, green: 0.90, blue: 0.92), Color(red: 0.25, green: 0.55, blue: 0.62)]
        case .diamant: return [Color(red: 0.70, green: 0.85, blue: 1.00), Color(red: 0.45, green: 0.30, blue: 0.95)]
        }
    }
    var accent: Color { colors[0] }
}

struct Rank: Equatable, Identifiable {
    /// 0 ... 14  (Bronze III = 0, Diamant I = 14)
    let index: Int
    var id: Int { index }
    var tier: RankTier { RankTier(rawValue: index / 3) ?? .diamant }
    /// 3 = unterste Stufe, 1 = oberste Stufe innerhalb der Liga
    var division: Int { 3 - (index % 3) }
    var roman: String { ["", "I", "II", "III"][division] }
    var title: String { "\(tier.name) \(roman)" }
    static let count = 15
    static let all = (0..<count).map { Rank(index: $0) }

    /// Gesamt-XP, ab der der Rang erreicht ist (Lifetime).
    var xpRequired: Int { index == 0 ? 0 : Int((150.0 * pow(Double(index), 1.7)).rounded()) }
}

// MARK: - Punkte

enum RankEvent {
    case workout        // abgeschlossenes Training
    case stepGoal       // Schrittziel erreicht
    case foodLogged     // Essen eingetragen (mind. 3 Einträge)
    case waterGoal      // Wasserziel erreicht
    case bodyScan       // Körperscan gemacht
    case streakWeek     // 7 Tage in Folge aktiv

    var xp: Int {
        switch self {
        case .workout: return 60
        case .stepGoal: return 25
        case .foodLogged: return 15
        case .waterGoal: return 10
        case .bodyScan: return 100
        case .streakWeek: return 80
        }
    }
    var label: String {
        switch self {
        case .workout: return "Training abgeschlossen"
        case .stepGoal: return "Schrittziel erreicht"
        case .foodLogged: return "Ernährung eingetragen"
        case .waterGoal: return "Wasserziel erreicht"
        case .bodyScan: return "Körperscan"
        case .streakWeek: return "7-Tage-Serie"
        }
    }
}

// MARK: - Belohnungen

struct RankReward: Identifiable {
    let rank: Int
    let icon: String
    let title: String
    let detail: String
    var id: Int { rank }
    var rankTitle: String { Rank(index: rank).title }
}

enum RankRewards {
    static let all: [RankReward] = [
        .init(rank: 1, icon: "star.fill", title: "Titel „Starter“", detail: "Erscheint unter deinem Namen auf der Teilen-Karte."),
        .init(rank: 2, icon: "circle.dashed", title: "Bronze-Profilrahmen", detail: "Ein Rahmen in Ranglistenfarbe um dein Profilbild."),
        .init(rank: 3, icon: "flame.fill", title: "Silber-Aura", detail: "Dezentes Leuchten um deine 3D-Figur."),
        .init(rank: 5, icon: "photo.on.rectangle", title: "Gym-Poster", detail: "Ein Motivationsposter an der Wand deines virtuellen Gyms."),
        .init(rank: 6, icon: "crown.fill", title: "Gold-Titel „Eisenwille“", detail: "Neuer Titel für Profil und Teilen-Karte."),
        .init(rank: 8, icon: "paintpalette.fill", title: "Neue Farbwelt", detail: "Zusätzliche Akzentfarben für die App."),
        .init(rank: 9, icon: "figure.strengthtraining.traditional", title: "Signature-Pose", detail: "Deine Figur zeigt nach dem Training eine Siegerpose."),
        .init(rank: 11, icon: "sparkles", title: "Platin-Aura", detail: "Kräftigere Aura mit Funken um die 3D-Figur."),
        .init(rank: 12, icon: "building.2.fill", title: "Neues Gym", detail: "Exklusive Gym-Szene (Dachterrasse bei Nacht)."),
        .init(rank: 13, icon: "bolt.fill", title: "Titel „Unaufhaltsam“", detail: "Seltener Titel für Profil und Teilen-Karte."),
        .init(rank: 14, icon: "diamond.fill", title: "Diamant-Legende", detail: "Diamant-Rahmen, Diamant-Aura und Legenden-Pose für immer."),
    ]
}

// MARK: - Sprüche

enum RankQuotes {
    static let general = [
        "Disziplin schlägt Motivation – jeden einzelnen Tag.",
        "Du musst nicht perfekt sein. Du musst nur anfangen.",
        "Heute ein Prozent besser als gestern. Mehr braucht es nicht.",
        "Schweiß ist nur Fett, das weint.",
        "Der Körper erreicht, was der Kopf glaubt.",
        "Keine Abkürzung. Aber jeder Schritt zählt.",
        "Stark wirst du nicht im Gym – sondern in den Tagen, an denen du keine Lust hast.",
        "Konstanz ist das, was Träume in Muskeln verwandelt.",
        "Wer aufhört, besser zu werden, hat aufgehört, gut zu sein.",
        "Dein zukünftiges Ich schaut dir gerade zu. Mach es stolz.",
        "Müde ist ein Gefühl. Aufgeben ist eine Entscheidung.",
        "Jede Wiederholung ist eine Stimme für die Person, die du werden willst.",
    ]
    static let rankUp: [RankTier: [String]] = [
        .bronze: ["Das Fundament steht. Jetzt wird gebaut.", "Aller Anfang ist Eisen – und du bist dabei."],
        .silber: ["Silber glänzt nicht von allein. Du hast es poliert.", "Die Gewohnheit gehört jetzt dir."],
        .gold: ["Gold gibt es nicht geschenkt – du hast es dir verdient.", "Andere reden. Du lieferst."],
        .platin: ["Platin ist selten. Genau wie dein Durchhaltevermögen.", "Du trainierst nicht mehr. Du lebst es."],
        .diamant: ["Druck macht Diamanten. Du bist der Beweis.", "Legendenstatus. Das hat Zeit, Mut und Willen gekostet."],
    ]

    static func daily(_ date: Date = Date()) -> String {
        let d = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return general[d % general.count]
    }
    static func forRankUp(_ r: Rank) -> String {
        let list = rankUp[r.tier] ?? general
        return list[r.index % list.count]
    }
}

// MARK: - Speicher

final class RankStore: ObservableObject {
    private struct Saved: Codable {
        var xp = 0
        var keys: [String] = []
        var lastSeenRank = 0
        var firstDay: Date = Date()
        var activeDays: [String] = []
    }

    @Published private(set) var xp = 0
    @Published private(set) var activeDayCount = 0
    @Published var pendingRankUp: Rank?
    @Published private(set) var lastAward: String?

    private var saved = Saved()
    private let storeKey = "bfc.rank.v1"

    init() {
        if let d = UserDefaults.standard.data(forKey: storeKey),
           let s = try? JSONDecoder().decode(Saved.self, from: d) { saved = s }
        xp = saved.xp
        activeDayCount = Set(saved.activeDays).count
    }

    // Rang aus Gesamt-XP
    var rank: Rank { Self.rank(forXP: xp) }
    var next: Rank? { rank.index + 1 < Rank.count ? Rank(index: rank.index + 1) : nil }
    var progress: Double {
        guard let n = next else { return 1 }
        let a = Double(rank.xpRequired), b = Double(n.xpRequired)
        return min(1, max(0, (Double(xp) - a) / max(1, b - a)))
    }
    var xpToNext: Int { next.map { max(0, $0.xpRequired - xp) } ?? 0 }

    static func rank(forXP xp: Int) -> Rank {
        var best = Rank(index: 0)
        for r in Rank.all where xp >= r.xpRequired { best = r }
        return best
    }

    /// Wie weit der Körper der Figur schon „aufgebaut“ ist (0 = Startfigur wie dein Scan, 1 = Legende).
    /// Mischung aus Rang (80 %) und Dauer der Nutzung (20 %, voll nach 365 aktiven Tagen).
    var physique: Double {
        let r = (Double(rank.index) + progress) / Double(Rank.count - 1)
        let t = min(1, Double(activeDayCount) / 365)
        return min(1, max(0, r * 0.8 + t * 0.2))
    }

    func unlocked(_ reward: RankReward) -> Bool { rank.index >= reward.rank }
    var nextReward: RankReward? { RankRewards.all.first { $0.rank > rank.index } }

    // Punkte vergeben – jeder Schlüssel nur einmal (z. B. "steps-2026-10-12").
    @discardableResult
    func award(_ e: RankEvent, key: String) -> Bool {
        let k = "\(e)-\(key)"
        guard !saved.keys.contains(k) else { return false }
        saved.keys.append(k)
        let day = Self.dayKey(Date())
        if !saved.activeDays.contains(day) { saved.activeDays.append(day) }
        saved.xp += e.xp
        lastAward = "+\(e.xp) XP · \(e.label)"
        commit()
        return true
    }

    /// Täglicher Abgleich mit den heutigen Werten – kann beliebig oft aufgerufen werden.
    func syncToday(steps: Int, stepGoal: Int, foodEntries: Int, waterGoalReached: Bool) {
        let day = Self.dayKey(Date())
        if stepGoal > 0 && steps >= stepGoal { award(.stepGoal, key: day) }
        if foodEntries >= 3 { award(.foodLogged, key: day) }
        if waterGoalReached { award(.waterGoal, key: day) }
        checkStreak()
    }

    func workoutFinished(id: String = UUID().uuidString) { award(.workout, key: id) }
    func scanDone(day: Date = Date()) { award(.bodyScan, key: Self.dayKey(day)) }

    func dismissRankUp() {
        saved.lastSeenRank = rank.index
        pendingRankUp = nil
        persist()
    }

    private func checkStreak() {
        let days = Set(saved.activeDays)
        var streak = 0
        var d = Date()
        let cal = Calendar.current
        while days.contains(Self.dayKey(d)) {
            streak += 1
            d = cal.date(byAdding: .day, value: -1, to: d) ?? d
        }
        // Schlüssel am Starttag der Serie festmachen, damit ein Monatswechsel den Bonus nicht doppelt auslöst
        if streak >= 7 {
            let start = cal.date(byAdding: .day, value: -(streak - 1), to: Date()) ?? Date()
            award(.streakWeek, key: "w\(streak / 7)-\(Self.dayKey(start))")
        }
    }

    private func commit() {
        xp = saved.xp
        activeDayCount = Set(saved.activeDays).count
        if rank.index > saved.lastSeenRank { pendingRankUp = rank }
        persist()
    }
    private func persist() {
        if let d = try? JSONEncoder().encode(saved) { UserDefaults.standard.set(d, forKey: storeKey) }
    }
    static func dayKey(_ d: Date) -> String {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: d)
        return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
    }
}

// MARK: - Abzeichen

struct HexShape: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: r.midX, y: r.midY), rad = min(r.width, r.height) / 2
        for i in 0..<6 {
            let a = Double(i) * .pi / 3 - .pi / 2
            let pt = CGPoint(x: c.x + rad * cos(a), y: c.y + rad * sin(a))
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

struct RankBadge: View {
    let rank: Rank
    var size: CGFloat = 64
    var locked = false
    var body: some View {
        ZStack {
            HexShape().fill(LinearGradient(colors: locked ? [.gray.opacity(0.5), .gray.opacity(0.3)] : rank.tier.colors,
                                           startPoint: .topLeading, endPoint: .bottomTrailing))
            HexShape().stroke(.white.opacity(locked ? 0.15 : 0.55), lineWidth: size * 0.04).padding(size * 0.07)
            VStack(spacing: 0) {
                Image(systemName: locked ? "lock.fill" : icon).font(.system(size: size * 0.30, weight: .bold))
                Text(rank.roman).font(.system(size: size * 0.22, weight: .heavy, design: .serif))
            }
            .foregroundStyle(.white.opacity(locked ? 0.6 : 1))
            .shadow(color: .black.opacity(0.35), radius: 1, y: 1)
        }
        .frame(width: size, height: size)
        .shadow(color: locked ? .clear : rank.tier.accent.opacity(0.5), radius: size * 0.12)
    }
    private var icon: String {
        ["dumbbell.fill", "shield.fill", "crown.fill", "bolt.shield.fill", "diamond.fill"][rank.tier.rawValue]
    }
}

// MARK: - Ansicht

struct RankView: View {
    @EnvironmentObject var rankStore: RankStore
    @EnvironmentObject var avatar: AvatarStore

    var body: some View {
        List {
            Section {
                VStack(spacing: 14) {
                    figurePreview
                    Text(rankStore.rank.title).font(.system(size: 30, weight: .black, design: .rounded))
                    ProgressView(value: rankStore.progress).tint(rankStore.rank.tier.accent)
                    if let n = rankStore.next {
                        Text("Noch \(rankStore.xpToNext) XP bis \(n.title)").font(.footnote).foregroundStyle(.secondary)
                    } else {
                        Text("Höchster Rang erreicht – Legende!").font(.footnote).foregroundStyle(.secondary)
                    }
                    Text("\(rankStore.xp) XP gesamt · \(rankStore.activeDayCount) aktive Tage").font(.caption).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 8)
            }
            Section("Spruch des Tages") {
                Text("„\(RankQuotes.daily())“").font(.body.italic())
            }
            Section {
                ForEach(XPInfo.rows, id: \.0) { row in
                    HStack { Text(row.0); Spacer(); Text("+\(row.1) XP").foregroundStyle(.secondary).monospacedDigit() }
                }
            } header: { Text("So sammelst du XP") } footer: {
                Text("Jede Aktion zählt pro Tag nur einmal, Trainings jedes Mal. Dein Rang bleibt lebenslang erhalten – er sinkt nie.")
            }
            Section("Belohnungen") {
                ForEach(RankRewards.all) { r in
                    let open = rankStore.unlocked(r)
                    HStack(spacing: 12) {
                        Image(systemName: open ? r.icon : "lock.fill").frame(width: 30).foregroundStyle(open ? rankStore.rank.tier.accent : .secondary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(r.title).foregroundStyle(open ? .primary : .secondary)
                            Text(open ? r.detail : "Ab \(r.rankTitle)").font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            Section("Rangleiter") {
                ForEach(Rank.all.reversed()) { r in
                    HStack(spacing: 14) {
                        RankBadge(rank: r, size: 44, locked: r.index > rankStore.rank.index)
                        VStack(alignment: .leading) {
                            Text(r.title).fontWeight(r == rankStore.rank ? .bold : .regular)
                            Text("ab \(r.xpRequired) XP").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        if r == rankStore.rank { Text("DU").font(.caption.bold()).padding(6).background(r.tier.accent.opacity(0.25)).clipShape(Capsule()) }
                    }
                }
            }
        }
        .navigationTitle("Rang")
    }

    private var figurePreview: some View {
        let p = rankStore.physique
        return ZStack {
            Circle().fill(RadialGradient(colors: [rankStore.rank.tier.accent.opacity(0.45), .clear], center: .center, startRadius: 5, endRadius: 110))
                .frame(width: 220, height: 220)
            if let a = avatar.image {
                Image(uiImage: a).resizable().scaledToFill().frame(width: 84, height: 84).clipShape(Circle())
                    .overlay(Circle().stroke(rankStore.rank.tier.accent, lineWidth: 3)).offset(y: -78)
            }
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 80 + 30 * p)).foregroundStyle(rankStore.rank.tier.accent)
                .offset(y: 12)
            RankBadge(rank: rankStore.rank, size: 58).offset(x: 80, y: 60)
        }
        .frame(height: 230)
    }
}

enum XPInfo {
    static let rows: [(String, Int)] = [
        (RankEvent.workout.label, RankEvent.workout.xp), (RankEvent.stepGoal.label, RankEvent.stepGoal.xp),
        (RankEvent.foodLogged.label, RankEvent.foodLogged.xp), (RankEvent.waterGoal.label, RankEvent.waterGoal.xp),
        (RankEvent.bodyScan.label, RankEvent.bodyScan.xp), (RankEvent.streakWeek.label, RankEvent.streakWeek.xp),
    ]
}

/// Kleine Karte für „Heute“: Rang, Fortschritt, Spruch – führt zur Rang-Ansicht.
struct RankCard: View {
    @EnvironmentObject var rankStore: RankStore
    var body: some View {
        NavigationLink { RankView() } label: {
            HStack(spacing: 14) {
                RankBadge(rank: rankStore.rank, size: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text(rankStore.rank.title).font(.headline)
                    ProgressView(value: rankStore.progress).tint(rankStore.rank.tier.accent)
                    Text(rankStore.next == nil ? "Legende" : "\(rankStore.xpToNext) XP bis \(rankStore.next!.title)")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }
}

/// Feier beim Aufstieg.
struct RankUpOverlay: View {
    @EnvironmentObject var rankStore: RankStore
    var body: some View {
        if let r = rankStore.pendingRankUp {
            ZStack {
                Color.black.opacity(0.78).ignoresSafeArea()
                VStack(spacing: 18) {
                    Text("RANG AUFGESTIEGEN").font(.caption.weight(.heavy)).tracking(3).foregroundStyle(.white.opacity(0.7))
                    RankBadge(rank: r, size: 150)
                    Text(r.title).font(.system(size: 38, weight: .black, design: .rounded)).foregroundStyle(.white)
                    Text("„\(RankQuotes.forRankUp(r))“").font(.body.italic()).multilineTextAlignment(.center).foregroundStyle(.white.opacity(0.9)).padding(.horizontal, 30)
                    if let rw = RankRewards.all.first(where: { $0.rank == r.index }) {
                        Label("Freigeschaltet: \(rw.title)", systemImage: rw.icon).font(.subheadline.bold()).foregroundStyle(r.tier.accent)
                    }
                    Button("Weiter geht’s") { rankStore.dismissRankUp() }
                        .buttonStyle(.borderedProminent).tint(r.tier.accent).padding(.top, 8)
                }
            }
            .transition(.opacity)
        }
    }
}
