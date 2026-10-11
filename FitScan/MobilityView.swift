import Combine
import SwiftUI

/// Mobility-Bibliothek nach Körperregion plus tägliche Empfehlung. Wird in einem NavigationStack angezeigt.
struct MobilityView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var store: TrainingStore
    @State private var region: MobilityRegion? = nil

    private var items: [Exercise] {
        ExerciseCatalog.mobility.filter {
            (region == nil || $0.region == region) && profile.setup.allows($0.equipment)
        }
    }

    var body: some View {
        List {
            let picks = MobilityPlanner.picks(profile: profile, logs: store.mobility)
            Section {
                ForEach(picks) { pick in
                    NavigationLink {
                        ExerciseDetailView(exercise: pick.exercise)
                    } label: {
                        ExerciseRow(exercise: pick.exercise,
                                    detail: "\(pick.exercise.dose)\n\(pick.reason)")
                    }
                }
            } header: {
                Text("Empfohlen für heute (ca. \(picks.count * 3) Minuten)")
            } footer: {
                Text("Die Auswahl berücksichtigt deinen Sport und welche Regionen du zuletzt vernachlässigt hast.")
            }

            Section("Nach Körperregion wählen") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        chip("Alle", icon: "square.grid.2x2", selected: region == nil) { region = nil }
                        ForEach(MobilityRegion.allCases) { r in
                            chip(r.rawValue, icon: r.icon, selected: region == r) { region = r }
                        }
                    }
                    .padding(.vertical, 2)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            }

            Section("\(items.count) Übungen") {
                ForEach(items) { ex in
                    NavigationLink {
                        ExerciseDetailView(exercise: ex)
                    } label: {
                        ExerciseRow(exercise: ex, detail: "\(ex.region?.rawValue ?? "") · \(ex.dose)")
                    }
                }
            }

            Section("Zuletzt gemacht") {
                let recent = store.mobility.sorted { $0.date > $1.date }.prefix(5)
                if recent.isEmpty {
                    Text("Noch nichts eingetragen. Öffne eine Übung und starte den Timer. Sie wird danach automatisch eingetragen.")
                        .font(.footnote).foregroundStyle(.secondary)
                } else {
                    ForEach(Array(recent)) { l in
                        HStack {
                            Text(l.exercise)
                            Spacer()
                            Text(l.date, format: .dateTime.day().month()).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Mobility")
    }

    private func chip(_ title: String, icon: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .padding(.horizontal, 12).padding(.vertical, 7)
                .background(selected ? Color.accentColor : Color(.tertiarySystemFill), in: Capsule())
                .foregroundStyle(selected ? Color.white : Color.primary)
        }
        .buttonStyle(.plain)
    }
}
