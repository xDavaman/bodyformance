import Combine
import SwiftUI
import UIKit

/// Detailseite: animiertes Bild, Ausführung, 3D-Muskelmodell und Tagebuch bzw. Timer.
struct ExerciseDetailView: View {
    let exercise: Exercise
    @EnvironmentObject var profile: UserProfile

    var body: some View {
        List {
            Section(exercise.isMobility ? "Bewegung und gedehnte Muskeln" : "Bewegung und trainierte Muskeln") {
                MuscleModelView(primary: exercise.primary, secondary: exercise.secondary, height: 340,
                                motion: BodyMotion.scene(for: exercise).0, gear: BodyMotion.scene(for: exercise).1)
                    .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            }

            Section("Details") {
                LabeledContent("Bereich", value: exercise.region?.rawValue ?? exercise.category.rawValue)
                LabeledContent("Geräte", value: exercise.equipment.rawValue)
                if !exercise.target.isEmpty { LabeledContent("Ziel", value: exercise.target) }
                if exercise.isMobility {
                    LabeledContent("Dauer", value: exercise.dose)
                } else {
                    LabeledContent("Dein Umfang",
                                   value: Progression.prescription(for: exercise, plan: profile.effectivePlan))
                }
            }

            Section("Ausführung") {
                ForEach(Array(exercise.tips.enumerated()), id: \.offset) { i, tip in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(i + 1)").bold().foregroundStyle(.tint)
                        Text(tip)
                    }
                }
            }

            if exercise.isMobility {
                MobilityTimerSection(exercise: exercise)
            } else {
                ExerciseLogSections(exercise: exercise)
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MobilityTimerSection: View {
    let exercise: Exercise
    @EnvironmentObject var store: TrainingStore

    @State private var remaining: Int = 0
    @State private var running = false
    @State private var side = 1
    @State private var logged = false
    private let tick = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var total: Int { exercise.seconds ?? 30 }
    private var sides: Int { exercise.perSide ? 2 : 1 }

    var body: some View {
        Section("Timer") {
            VStack(spacing: 8) {
                Text(running || remaining > 0 ? "\(remaining) s" : "\(total) s")
                    .font(.system(size: 44, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                if sides == 2 {
                    Text(running ? "Seite \(side) von 2" : "Pro Seite")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)

            Button(running ? "Stopp" : "Start") {
                if running { running = false } else {
                    if remaining == 0 { remaining = total; side = 1 }
                    running = true
                }
            }
            Button("Als erledigt eintragen") {
                store.addMobility(exercise)
                logged = true
            }
            .disabled(logged)
            if logged {
                Label("Eingetragen. Fließt in deine Analyse ein.", systemImage: "checkmark.circle")
                    .font(.footnote).foregroundStyle(.green)
            }
        }
        .onReceive(tick) { _ in
            guard running else { return }
            if remaining > 1 {
                remaining -= 1
            } else if side < sides {
                side += 1
                remaining = total
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } else {
                remaining = 0
                running = false
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                store.addMobility(exercise)
                logged = true
            }
        }
    }
}
