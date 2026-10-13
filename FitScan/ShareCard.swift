import SwiftUI
import UIKit

/// Ergebnis-Karte zum Teilen (Instagram, WhatsApp, TikTok …) – wird als Bild gerendert.
struct ShareCard: View {
    let name: String
    let avatar: UIImage?
    let steps: Int
    let stepGoal: Int
    let kcal: Int
    let kcalTarget: Int
    let protein: Int
    let proteinTarget: Int
    let workouts: Int
    let date: Date

    private var dateText: String {
        let f = DateFormatter(); f.locale = Locale(identifier: "de_DE"); f.dateStyle = .long
        return f.string(from: date)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.07, green: 0.07, blue: 0.08), Color(red: 0.22, green: 0.05, blue: 0.05)],
                           startPoint: .top, endPoint: .bottom)
            VStack(spacing: 44) {
                HStack {
                    Text("BFC").font(.system(size: 64, weight: .black, design: .rounded)).foregroundStyle(.white)
                    Rectangle().fill(Color(red: 0.89, green: 0.23, blue: 0.18)).frame(width: 90, height: 8).clipShape(Capsule())
                    Spacer()
                    Text("Bodyformance").font(.system(size: 30, weight: .semibold)).foregroundStyle(.white.opacity(0.7))
                }
                ZStack {
                    Circle().stroke(.white.opacity(0.15), lineWidth: 34)
                    Circle().trim(from: 0, to: min(1, Double(steps) / Double(max(stepGoal, 1))))
                        .stroke(steps >= stepGoal ? Color.green : Color(red: 0.89, green: 0.23, blue: 0.18),
                                style: StrokeStyle(lineWidth: 34, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Group {
                        if let a = avatar {
                            Image(uiImage: a).resizable().scaledToFill()
                        } else {
                            Image(systemName: "figure.walk").resizable().scaledToFit().padding(70).foregroundStyle(.white)
                        }
                    }
                    .frame(width: 330, height: 330).clipShape(Circle())
                }
                .frame(width: 440, height: 440)
                VStack(spacing: 6) {
                    Text("\(steps)").font(.system(size: 120, weight: .black, design: .rounded)).foregroundStyle(.white).monospacedDigit()
                    Text("Schritte · Ziel \(stepGoal)").font(.system(size: 34)).foregroundStyle(.white.opacity(0.7))
                }
                HStack(spacing: 24) {
                    stat("\(kcal)", "von \(kcalTarget) kcal")
                    stat("\(protein) g", "von \(proteinTarget) g Eiweiß")
                    stat("\(workouts)", "Workouts (30 Tage)")
                }
                Spacer(minLength: 0)
                VStack(spacing: 6) {
                    if !name.isEmpty { Text(name).font(.system(size: 40, weight: .bold)).foregroundStyle(.white) }
                    Text(dateText).font(.system(size: 30)).foregroundStyle(.white.opacity(0.6))
                }
            }
            .padding(70)
        }
        .frame(width: 1080, height: 1350)
    }

    private func stat(_ big: String, _ small: String) -> some View {
        VStack(spacing: 8) {
            Text(big).font(.system(size: 52, weight: .heavy, design: .rounded)).foregroundStyle(.white).minimumScaleFactor(0.6).lineLimit(1)
            Text(small).font(.system(size: 24)).foregroundStyle(.white.opacity(0.65)).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 26)
        .background(.white.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

/// Button „Ergebnisse teilen“: rendert die Karte und öffnet das System-Teilen-Menü.
struct ShareResultsButton: View {
    @EnvironmentObject var avatar: AvatarStore
    @AppStorage("profileName") private var name = ""
    let steps: Int, stepGoal: Int, kcal: Int, kcalTarget: Int, protein: Int, proteinTarget: Int, workouts: Int
    @State private var rendered: UIImage?

    private var card: ShareCard {
        ShareCard(name: name, avatar: avatar.image, steps: steps, stepGoal: stepGoal, kcal: kcal, kcalTarget: kcalTarget,
                  protein: protein, proteinTarget: proteinTarget, workouts: workouts, date: Date())
    }

    var body: some View {
        Group {
            if let img = rendered {
                ShareLink(item: Image(uiImage: img), message: Text("Mein Tag mit Bodyformance (BFC)"),
                          preview: SharePreview("Mein Tag mit Bodyformance", image: Image(uiImage: img))) {
                    Label("Ergebnisse teilen (Instagram, TikTok, WhatsApp …)", systemImage: "square.and.arrow.up")
                }
            } else {
                Label("Ergebnis-Bild wird erstellt …", systemImage: "square.and.arrow.up").foregroundStyle(.secondary)
            }
        }
        .task(id: "\(steps)-\(kcal)-\(protein)-\(workouts)-\(name)-\(avatar.image?.size.width ?? 0)") { render() }
    }

    @MainActor private func render() {
        let r = ImageRenderer(content: card)
        r.scale = 1
        rendered = r.uiImage
    }
}
