import SwiftUI
import UIKit

/// Teilen-Auswahl: Schrittzähler, Gym-Zeit, Essen, Lauf-Strecke (auch transparent), Rang, Tagesübersicht.
enum ShareVariant: String, CaseIterable, Identifiable {
    case day = "Tag", steps = "Schritte", gym = "Gym", food = "Essen", run = "Lauf", rank = "Rang"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .day: return "square.grid.2x2"
        case .steps: return "figure.walk"
        case .gym: return "dumbbell"
        case .food: return "fork.knife"
        case .run: return "map"
        case .rank: return "crown"
        }
    }
}

struct ShareData {
    var name: String
    var avatar: UIImage?
    var steps: Int, stepGoal: Int, lifetime: Int
    var kcal: Int, kcalTarget: Int, protein: Int, proteinTarget: Int, carbs: Int, fat: Int
    var workouts30: Int
    var gymSeconds7: Int, gymSessions7: Int
    var lastRun: SessionEntry?
    var rankTitle: String, rankIndex: Int, xp: Int, tierColor: Color, quote: String
}

/// Linienzug der Strecke, passend in ein Rechteck skaliert.
struct RouteShape: Shape {
    let points: [RoutePoint]
    func path(in rect: CGRect) -> Path {
        var p = Path()
        guard points.count > 1 else { return p }
        let midLat = points.map(\.lat).reduce(0, +) / Double(points.count)
        let k = cos(midLat * .pi / 180)
        let xs = points.map { $0.lon * k }, ys = points.map { -$0.lat }
        let minX = xs.min()!, maxX = xs.max()!, minY = ys.min()!, maxY = ys.max()!
        let w = max(maxX - minX, 1e-9), h = max(maxY - minY, 1e-9)
        let scale = min(rect.width / w, rect.height / h)
        let ox = rect.minX + (rect.width - w * scale) / 2, oy = rect.minY + (rect.height - h * scale) / 2
        for (i, _) in points.enumerated() {
            let pt = CGPoint(x: ox + (xs[i] - minX) * scale, y: oy + (ys[i] - minY) * scale)
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        return p
    }
}

enum ShareRoute {
    /// Kürzt Start und Ende (Privatsphäre: Wohnort), wenn die Strecke lang genug ist.
    static func trimmed(_ pts: [RoutePoint], meters: Double) -> [RoutePoint] {
        guard pts.count > 10 else { return pts }
        func d(_ a: RoutePoint, _ b: RoutePoint) -> Double {
            let la = a.lat * .pi / 180, lb = b.lat * .pi / 180
            let dx = (b.lon - a.lon) * .pi / 180 * cos((la + lb) / 2), dy = lb - la
            return sqrt(dx * dx + dy * dy) * 6_371_000
        }
        var total = 0.0
        for i in 1..<pts.count { total += d(pts[i - 1], pts[i]) }
        guard total > meters * 4 else { return pts }
        var from = 0, acc = 0.0
        while from < pts.count - 1 && acc < meters { acc += d(pts[from], pts[from + 1]); from += 1 }
        var to = pts.count - 1; acc = 0
        while to > from + 1 && acc < meters { acc += d(pts[to - 1], pts[to]); to -= 1 }
        return Array(pts[from...to])
    }
}

struct ShareCanvas: View {
    let variant: ShareVariant
    let data: ShareData
    let route: [RoutePoint]
    let transparent: Bool
    private let red = Color(red: 0.89, green: 0.23, blue: 0.18)

    private var dateText: String {
        let f = DateFormatter(); f.locale = Locale(identifier: "de_DE"); f.dateStyle = .long
        return f.string(from: Date())
    }

    var body: some View {
        Group {
            if variant == .day {
                ShareCard(name: data.name, avatar: data.avatar, steps: data.steps, stepGoal: data.stepGoal, kcal: data.kcal,
                          kcalTarget: data.kcalTarget, protein: data.protein, proteinTarget: data.proteinTarget,
                          workouts: data.workouts30, date: Date())
            } else if variant == .run && transparent {
                routeOnly
            } else {
                ZStack {
                    LinearGradient(colors: [Color(red: 0.07, green: 0.07, blue: 0.08), Color(red: 0.22, green: 0.05, blue: 0.05)],
                                   startPoint: .top, endPoint: .bottom)
                    VStack(spacing: 40) {
                        header
                        content
                        Spacer(minLength: 0)
                        footer
                    }
                    .padding(70)
                }
                .frame(width: 1080, height: 1350)
            }
        }
    }

    private var header: some View {
        HStack {
            Text("BFC").font(.system(size: 64, weight: .black, design: .rounded)).foregroundStyle(.white)
            Rectangle().fill(red).frame(width: 90, height: 8).clipShape(Capsule())
            Spacer()
            Text("Bodyformance").font(.system(size: 30, weight: .semibold)).foregroundStyle(.white.opacity(0.7))
        }
    }

    private var footer: some View {
        HStack(spacing: 24) {
            if let a = data.avatar {
                Image(uiImage: a).resizable().scaledToFill().frame(width: 110, height: 110).clipShape(Circle())
                    .overlay(Circle().stroke(data.tierColor, lineWidth: 6))
            }
            VStack(alignment: .leading, spacing: 4) {
                if !data.name.isEmpty { Text(data.name).font(.system(size: 40, weight: .bold)).foregroundStyle(.white) }
                Text("\(data.rankTitle) · \(dateText)").font(.system(size: 28)).foregroundStyle(.white.opacity(0.65))
            }
            Spacer()
        }
    }

    @ViewBuilder private var content: some View {
        switch variant {
        case .steps:
            ZStack {
                Circle().stroke(.white.opacity(0.15), lineWidth: 40)
                Circle().trim(from: 0, to: min(1, Double(data.steps) / Double(max(data.stepGoal, 1))))
                    .stroke(data.steps >= data.stepGoal ? Color.green : red, style: StrokeStyle(lineWidth: 40, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 6) {
                    Text("\(data.steps)").font(.system(size: 150, weight: .black, design: .rounded)).foregroundStyle(.white).monospacedDigit()
                        .minimumScaleFactor(0.5).lineLimit(1)
                    Text("Schritte heute").font(.system(size: 38)).foregroundStyle(.white.opacity(0.7))
                    Text("Ziel \(data.stepGoal)").font(.system(size: 30)).foregroundStyle(.white.opacity(0.5))
                }
                .padding(60)
            }
            .frame(width: 720, height: 720)
            big("\(data.lifetime.formatted())", "Lifetime-Schritte")
        case .gym:
            big(Self.hm(data.gymSeconds7), "Trainingszeit in den letzten 7 Tagen")
            HStack(spacing: 24) {
                stat("\(data.gymSessions7)", "Einheiten (7 Tage)")
                stat("\(data.workouts30)", "Workouts (30 Tage)")
            }
            Image(systemName: "dumbbell.fill").font(.system(size: 220)).foregroundStyle(red.opacity(0.9)).padding(.top, 30)
        case .food:
            big("\(data.kcal) kcal", "von \(data.kcalTarget) kcal")
            ProgressBar(value: Double(data.kcal) / Double(max(data.kcalTarget, 1)), color: red)
            HStack(spacing: 24) {
                stat("\(data.protein) g", "Eiweiß (Ziel \(data.proteinTarget))")
                stat("\(data.carbs) g", "Kohlenhydrate")
                stat("\(data.fat) g", "Fett")
            }
        case .run:
            if let r = data.lastRun {
                RouteShape(points: route).stroke(red, style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round))
                    .frame(height: 620).padding(30)
                    .background(.white.opacity(0.06)).clipShape(RoundedRectangle(cornerRadius: 36))
                HStack(spacing: 24) {
                    stat(String(format: "%.2f km", r.distanceM / 1000), r.kind.label)
                    stat(WorkoutSession.clock(r.seconds), "Zeit")
                    stat(r.distanceM > 200 ? WorkoutSession.paceText(Double(r.seconds) / (r.distanceM / 1000)) : "–", "Tempo")
                }
            } else {
                big("Noch keine Strecke", "Starte ein Training draußen (Laufen, Gehen, Draußen trainieren).")
            }
        case .rank:
            RankBadge(rank: Rank(index: data.rankIndex), size: 420)
            big(data.rankTitle, "\(data.xp) XP")
            Text("„\(data.quote)“").font(.system(size: 36).italic()).foregroundStyle(.white.opacity(0.85)).multilineTextAlignment(.center)
        case .day:
            EmptyView()
        }
    }

    /// Nur die Strecke, durchsichtig – zum Legen über ein eigenes Foto.
    private var routeOnly: some View {
        VStack(spacing: 30) {
            RouteShape(points: route)
                .stroke(.white, style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round))
                .shadow(color: .black.opacity(0.55), radius: 8)
                .frame(width: 900, height: 900)
            if let r = data.lastRun {
                Text(String(format: "%.2f km · %@", r.distanceM / 1000, WorkoutSession.clock(r.seconds)))
                    .font(.system(size: 64, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.55), radius: 8)
            }
            Text("BFC").font(.system(size: 40, weight: .black, design: .rounded)).foregroundStyle(.white.opacity(0.85))
                .shadow(color: .black.opacity(0.55), radius: 6)
        }
        .padding(60)
        .frame(width: 1080, height: 1350)
    }

    private func big(_ value: String, _ caption: String) -> some View {
        VStack(spacing: 8) {
            Text(value).font(.system(size: 110, weight: .black, design: .rounded)).foregroundStyle(.white).monospacedDigit()
                .minimumScaleFactor(0.4).lineLimit(1)
            Text(caption).font(.system(size: 34)).foregroundStyle(.white.opacity(0.7)).multilineTextAlignment(.center)
        }
    }

    private func stat(_ big: String, _ small: String) -> some View {
        VStack(spacing: 8) {
            Text(big).font(.system(size: 52, weight: .heavy, design: .rounded)).foregroundStyle(.white).minimumScaleFactor(0.5).lineLimit(1)
            Text(small).font(.system(size: 24)).foregroundStyle(.white.opacity(0.65)).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 26)
        .background(.white.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 28))
    }

    static func hm(_ s: Int) -> String {
        let h = s / 3600, m = (s % 3600) / 60
        return h > 0 ? "\(h) h \(m) min" : "\(m) min"
    }
}

private struct ProgressBar: View {
    let value: Double, color: Color
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule().fill(.white.opacity(0.15))
            Capsule().fill(color).frame(width: 940 * min(1, max(0, value)))
        }
        .frame(width: 940, height: 28)
    }
}

struct ShareStudioView: View {
    @EnvironmentObject var avatar: AvatarStore
    @EnvironmentObject var health: HealthManager
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var log: FoodLog
    @EnvironmentObject var tracker: StepTracker
    @EnvironmentObject var sessions: SessionLog
    @EnvironmentObject var rank: RankStore
    @AppStorage("profileName") private var name = ""
    @State private var variant: ShareVariant = .day
    @State private var transparent = false
    @State private var trim = true
    @State private var fileURL: URL?
    @State private var preview: UIImage?

    private var lastRun: SessionEntry? { sessions.entries.first { ($0.route?.count ?? 0) > 2 } }

    private var data: ShareData {
        let eaten = log.totals(day: Date())
        let week = Date().addingTimeInterval(-7 * 86400)
        let recent = sessions.entries.filter { $0.date >= week }
        return ShareData(name: name, avatar: avatar.image,
                         steps: max(health.stepsToday, tracker.steps), stepGoal: profile.stepGoal, lifetime: health.lifetimeSteps,
                         kcal: Int(eaten.kcal.rounded()), kcalTarget: profile.targets(for: log.dayType(day: Date(), fallback: profile.defaultDayType)).kcal,
                         protein: Int(eaten.protein.rounded()),
                         proteinTarget: profile.targets(for: log.dayType(day: Date(), fallback: profile.defaultDayType)).protein,
                         carbs: Int(eaten.carbs.rounded()), fat: Int(eaten.fat.rounded()),
                         workouts30: health.workoutsLast30Days,
                         gymSeconds7: recent.reduce(0) { $0 + $1.seconds }, gymSessions7: recent.count,
                         lastRun: lastRun, rankTitle: rank.rank.title, rankIndex: rank.rank.index, xp: rank.xp,
                         tierColor: rank.rank.tier.accent, quote: RankQuotes.daily())
    }

    private var routePoints: [RoutePoint] {
        let pts = lastRun?.route ?? []
        return trim ? ShareRoute.trimmed(pts, meters: 200) : pts
    }

    private var canvas: ShareCanvas {
        ShareCanvas(variant: variant, data: data, route: routePoints, transparent: transparent)
    }

    var body: some View {
        List {
            Section {
                Picker("Was teilen?", selection: $variant) {
                    ForEach(ShareVariant.allCases) { Label($0.rawValue, systemImage: $0.icon).tag($0) }
                }
                .pickerStyle(.menu)
                if variant == .run {
                    Toggle("Transparent (nur Strecke, zum Legen über ein Foto)", isOn: $transparent)
                    Toggle("Start und Ende kürzen (Privatsphäre)", isOn: $trim)
                }
            } footer: {
                if variant == .run && lastRun == nil {
                    Text("Noch keine GPS-Strecke vorhanden. Starte ein Training draußen, dann erscheint sie hier.")
                } else if variant == .run {
                    Text("Tipp: Beim Teilen zeigt die Strecke ungefähr, wo du wohnst. „Start und Ende kürzen“ schneidet die ersten und letzten 200 m ab.")
                } else {
                    Text("Du siehst vor dem Senden genau, was im Bild steht. BFC lädt nichts hoch, du verschickst das Bild selbst.")
                }
            }
            Section {
                if let img = preview {
                    ZStack {
                        if transparent && variant == .run { Checker() }
                        Image(uiImage: img).resizable().scaledToFit()
                    }
                    .frame(maxWidth: .infinity).clipShape(RoundedRectangle(cornerRadius: 12))
                    if let url = fileURL {
                        ShareLink(item: url, subject: Text("Bodyformance (BFC)"),
                                  preview: SharePreview("Mein Ergebnis mit BFC", image: Image(uiImage: img))) {
                            Label("Teilen", systemImage: "square.and.arrow.up").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ProgressView()
                }
            }
        }
        .navigationTitle("Teilen")
        .task(id: "\(variant.rawValue)-\(transparent)-\(trim)-\(data.steps)-\(data.kcal)-\(lastRun?.id.uuidString ?? "")") { render() }
    }

    @MainActor private func render() {
        let r = ImageRenderer(content: canvas)
        r.scale = 1
        r.isOpaque = !(transparent && variant == .run)
        guard let img = r.uiImage, let png = img.pngData() else { return }
        preview = img
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("BFC-\(variant.rawValue)-\(Int(Date().timeIntervalSince1970)).png")
        try? png.write(to: url)
        fileURL = url
    }
}

private struct Checker: View {
    var body: some View {
        Canvas { ctx, size in
            let s: CGFloat = 20
            for y in 0..<Int(size.height / s) + 1 {
                for x in 0..<Int(size.width / s) + 1 where (x + y) % 2 == 0 {
                    ctx.fill(Path(CGRect(x: CGFloat(x) * s, y: CGFloat(y) * s, width: s, height: s)), with: .color(.gray.opacity(0.35)))
                }
            }
        }
    }
}
