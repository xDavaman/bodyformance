import SwiftUI

struct TrainingView: View {
    @EnvironmentObject var profile: UserProfile

    var body: some View {
        NavigationStack {
            let days = PlanBuilder.plan(profile: profile)
            let plan = profile.effectivePlan
            List {
                Section {
                    LabeledContent("Ziel", value: profile.goal.rawValue)
                    LabeledContent("Optik", value: profile.aesthetic.rawValue)
                    LabeledContent("Aufteilung", value: days.map(\.name).joined(separator: " · "))
                    if !profile.focusMuscles.isEmpty {
                        LabeledContent("Schwerpunkt", value: profile.focusMuscles.map(\.rawValue).sorted().joined(separator: ", "))
                    }
                    Text(plan.note).font(.footnote).foregroundStyle(.secondary)
                    NavigationLink("Profil und Plan anpassen") { ProfileView() }
                } header: {
                    Text("Dein Plan")
                } footer: {
                    Text("Der Plan wird aus deinem Profil gebaut und passt sich an, sobald du etwas änderst. Gewichte und Wiederholungen aktualisieren sich nach jedem eingetragenen Satz.")
                }

                Section {
                    NavigationLink { WorkoutTrackerView() } label: {
                        Label("Training aufzeichnen (Zeit, Schritte, Tempo)", systemImage: "play.circle")
                    }
                }

                ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                    Section {
                        ForEach(day.items) { item in
                            NavigationLink {
                                ExerciseDetailView(exercise: item.exercise)
                            } label: {
                                ExerciseRow(exercise: item.exercise,
                                            detail: Progression.prescription(for: item.exercise, plan: plan),
                                            badge: item.isFocus ? "Schwerpunkt" : nil)
                            }
                        }
                    } header: {
                        Text("Tag \(index + 1): \(day.name) – \(day.subtitle)")
                    }
                }

                Section("Bibliothek") {
                    NavigationLink {
                        ExerciseLibraryView()
                    } label: {
                        Label("Alle Übungen (\(ExerciseCatalog.training.count))", systemImage: "list.bullet")
                    }
                    NavigationLink {
                        MobilityView()
                    } label: {
                        Label("Mobility (\(ExerciseCatalog.mobility.count) Übungen)", systemImage: "figure.flexibility")
                    }
                }
            }
            .navigationTitle("Training")
        }
    }
}

/// Zeile mit kleinem Bild, Name und Kurzinfo.
struct ExerciseRow: View {
    let exercise: Exercise
    var detail: String
    var badge: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: exercise.isMobility ? "figure.flexibility" : "figure.strengthtraining.traditional")
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 44, height: 44)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name)
                Text(detail).font(.footnote).foregroundStyle(.secondary)
                Text(exercise.primary.map(\.rawValue).joined(separator: ", "))
                    .font(.caption).foregroundStyle(.secondary)
                if let badge {
                    Text(badge).font(.caption2).bold().foregroundStyle(.tint)
                }
            }
        }
    }
}

struct ExerciseLibraryView: View {
    @EnvironmentObject var profile: UserProfile
    @State private var category: Category? = nil
    @State private var onlyMine = true
    @State private var search = ""

    private var items: [Exercise] {
        ExerciseCatalog.training.filter { ex in
            (category == nil || ex.category == category)
                && (!onlyMine || profile.setup.allows(ex.equipment))
                && (search.isEmpty || ex.name.localizedCaseInsensitiveContains(search)
                    || ex.primary.contains { $0.rawValue.localizedCaseInsensitiveContains(search) })
        }
    }

    var body: some View {
        List {
            Section {
                Picker("Kategorie", selection: $category) {
                    Text("Alle").tag(Category?.none)
                    ForEach([Category.strength, .calisthenics, .core, .drill]) { Text($0.rawValue).tag(Category?.some($0)) }
                }
                .pickerStyle(.segmented)
                Toggle("Nur Übungen für meine Ausstattung", isOn: $onlyMine)
            }
            Section {
                ForEach(items) { ex in
                    NavigationLink {
                        ExerciseDetailView(exercise: ex)
                    } label: {
                        ExerciseRow(exercise: ex, detail: "\(ex.category.rawValue) · \(ex.equipment.rawValue)")
                    }
                }
            }
        }
        .searchable(text: $search, prompt: "Übung oder Muskel suchen")
        .navigationTitle("Übungen")
    }
}
