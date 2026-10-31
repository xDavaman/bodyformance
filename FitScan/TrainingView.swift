import SwiftUI

struct TrainingView: View {
    @EnvironmentObject var profile: UserProfile
    @ObservedObject private var flow = WorkoutFlow.shared

    var body: some View {
        NavigationStack {
            let days = PlanBuilder.plan(profile: profile)
            let plan = profile.effectivePlan
            List {
                Section {
                    NavigationLink { WorkoutFlowView() } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Label(flow.isActive ? "Training läuft: \(flow.title)" : "Heutiges Training starten",
                                  systemImage: flow.isActive ? "record.circle" : "play.circle.fill")
                                .font(.headline)
                            Text("Aufwärmen und Dehnen → Kraft oder Cardio → Mobility-Abschluss")
                                .font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                    if !profile.gearAsked {
                        NavigationLink { GearSetupView() } label: {
                            Label("Welche Geräte hast du immer? Kurz auswählen, dann passt der Plan.", systemImage: "questionmark.circle")
                                .foregroundStyle(.orange)
                        }
                    }
                }

                Section {
                    LabeledContent("Ziel", value: profile.goal.rawValue)
                    LabeledContent("Optik", value: profile.aesthetic.rawValue)
                    LabeledContent("Aufteilung", value: days.map(\.name).joined(separator: " · "))
                    if !profile.focusMuscles.isEmpty {
                        LabeledContent("Schwerpunkt", value: profile.focusMuscles.map(\.rawValue).sorted().joined(separator: ", "))
                    }
                    Text(plan.note).font(.footnote).foregroundStyle(.secondary)
                    NavigationLink { CoachView() } label: {
                        Label(profile.trainingGoal.map { "KI-Coach: \($0.rawValue)" } ?? "KI-Coach: Ziel wählen und Plan bauen", systemImage: "sparkles")
                            .font(.headline)
                    }
                    NavigationLink("Ziel und Plan anpassen") { ProfileView() }
                    NavigationLink("Meine Geräte und Übungen") { GearSetupView() }
                } header: {
                    Text("Dein Plan")
                } footer: {
                    Text("Der Plan wird aus deinem Profil gebaut und passt sich an, sobald du etwas änderst. Gewichte und Wiederholungen aktualisieren sich nach jedem eingetragenen Satz.")
                }

                Section {
                    NavigationLink { WorkoutTrackerView() } label: {
                        Label("Training aufzeichnen (Zeit, Schritte, Tempo)", systemImage: "play.circle")
                    }
                    NavigationLink { SportView() } label: { Label("Sport und Laufen", systemImage: "figure.run") }
                    NavigationLink { GymExploreView() } label: {
                        Label("Fitnessstudio erkunden", systemImage: "building.2")
                    }
                    NavigationLink { PlanExportView() } label: { Label("Plan als PDF", systemImage: "doc.richtext") }
                }

                ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                    Section {
                        NavigationLink { WorkoutFlowView(dayIndex: index) } label: {
                            Label("Diesen Tag mit Aufwärmen und Mobility starten", systemImage: "play.circle")
                                .font(.subheadline)
                        }
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
                        Label("Alle Übungen (\(ExerciseCatalog.libraryTraining.count))", systemImage: "list.bullet")
                    }
                    NavigationLink {
                        MobilityView()
                    } label: {
                        Label("Mobility (\(ExerciseCatalog.libraryMobility.count) Übungen)", systemImage: "figure.flexibility")
                    }
                }
            }
            .navigationTitle("Trainingsplan")
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
                MuscleChips(primary: exercise.primary, secondary: exercise.secondary)
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
    @State private var muscle: Muscle? = nil
    @State private var equipment: Equipment? = nil
    @State private var onlyMine = false
    @State private var search = ""

    private var items: [Exercise] {
        let q = search.trimmingCharacters(in: .whitespaces)
        return ExerciseCatalog.library.filter { ex in
            (category == nil || ex.category == category)
                && (muscle == nil || ex.primary.contains(muscle!))
                && (equipment == nil || ex.equipment == equipment)
                && (!onlyMine || profile.canDo(ex))
                && (q.isEmpty || ex.name.localizedCaseInsensitiveContains(q)
                    || ex.primary.contains { $0.rawValue.localizedCaseInsensitiveContains(q) })
        }
    }

    var body: some View {
        let list = items
        List {
            Section {
                Picker("Kategorie", selection: $category) {
                    Text("Alle").tag(Category?.none)
                    ForEach(Category.allCases) { Text($0.rawValue).tag(Category?.some($0)) }
                }
                Picker("Muskelgruppe", selection: $muscle) {
                    Text("Alle").tag(Muscle?.none)
                    ForEach(Muscle.allCases) { Text($0.rawValue).tag(Muscle?.some($0)) }
                }
                Picker("Gerät / Ort", selection: $equipment) {
                    Text("Alle").tag(Equipment?.none)
                    ForEach(Equipment.allCases, id: \.self) { Text($0.rawValue).tag(Equipment?.some($0)) }
                }
                Toggle("Nur Übungen für meine Ausstattung", isOn: $onlyMine)
            } footer: {
                Text("\(list.count) von \(ExerciseCatalog.library.count) Übungen")
            }
            Section {
                ForEach(list) { ex in
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
