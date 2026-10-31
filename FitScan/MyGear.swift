import Combine
import SwiftUI

// MARK: - Eigene Geräte und Übungen

/// Feine Auswahl der Ausstattung: welche Geräte immer da sind und welche Übungen jemand nicht machen kann.
/// Ohne eigene Auswahl gilt die grobe Ausstattung aus dem Profil (Setup).
extension UserProfile {
    /// nil = noch nicht eingestellt
    var ownedEquipment: Set<Equipment>? {
        get {
            guard let raw = UserDefaults.standard.string(forKey: "ownedEquipment"), !raw.isEmpty else { return nil }
            return Set(raw.split(separator: "|").compactMap { Equipment(rawValue: String($0)) })
        }
        set {
            if let v = newValue {
                UserDefaults.standard.set(v.union([.none]).map(\.rawValue).sorted().joined(separator: "|"), forKey: "ownedEquipment")
            } else {
                UserDefaults.standard.removeObject(forKey: "ownedEquipment")
            }
            objectWillChange.send()
        }
    }

    /// Übungen, die jemand nicht machen kann oder will (Name der Übung)
    var excludedExercises: Set<String> {
        get { Set(UserDefaults.standard.stringArray(forKey: "excludedExercises") ?? []) }
        set { UserDefaults.standard.set(newValue.sorted(), forKey: "excludedExercises"); objectWillChange.send() }
    }

    /// true, sobald die Geräte-Abfrage einmal beantwortet wurde
    var gearAsked: Bool {
        get { UserDefaults.standard.bool(forKey: "gearAsked") }
        set { UserDefaults.standard.set(newValue, forKey: "gearAsked"); objectWillChange.send() }
    }

    func allows(_ e: Equipment) -> Bool {
        if e == .none { return true }
        return ownedEquipment?.contains(e) ?? setup.allows(e)
    }

    /// Gerät vorhanden und Übung nicht ausgeschlossen
    func canDo(_ ex: Exercise) -> Bool {
        allows(ex.equipment) && !excludedExercises.contains(ex.name)
    }

    func setCanDo(_ ex: Exercise, _ yes: Bool) {
        var s = excludedExercises
        if yes { s.remove(ex.name) } else { s.insert(ex.name) }
        excludedExercises = s
    }
}

extension Equipment {
    var icon: String {
        switch self {
        case .none: return "figure.stand"
        case .dumbbell: return "dumbbell"
        case .barbell: return "figure.strengthtraining.traditional"
        case .bar: return "figure.climbing"
        case .cable: return "cable.connector"
        case .machine: return "gearshape.2"
        case .kettlebell: return "scalemass"
        case .band: return "lasso"
        case .sling: return "circle.circle"
        case .medball: return "basketball"
        case .foam: return "cylinder"
        case .cardioGear: return "figure.indoor.cycle"
        case .outdoor: return "tree"
        case .bike: return "bicycle"
        case .pool: return "figure.pool.swim"
        }
    }
}

/// Abfrage: Welche Geräte hast du immer? Welche Übungen kannst du nicht machen?
struct GearSetupView: View {
    @EnvironmentObject var profile: UserProfile
    @State private var owned: Set<Equipment> = []
    @State private var loaded = false

    var body: some View {
        List {
            Section {
                Text("Hake an, was du in deinem Fitnessstudio oder zu Hause immer zur Verfügung hast. Plan, Aufwärmen und Mobility nehmen dann nur Übungen, die du wirklich machen kannst.")
                    .font(.footnote)
            }
            Section("Schnellauswahl") {
                ForEach(Setup.allCases) { s in
                    Button {
                        owned = Set(Equipment.allCases.filter { s.allows($0) })
                    } label: {
                        Label(s.rawValue, systemImage: "wand.and.stars")
                    }
                }
            }
            Section {
                ForEach(Equipment.allCases, id: \.self) { e in
                    Toggle(isOn: Binding(get: { e == .none || owned.contains(e) },
                                         set: { on in if on { owned.insert(e) } else { owned.remove(e) } })) {
                        Label(e.rawValue, systemImage: e.icon)
                    }
                    .disabled(e == .none)
                }
            } header: {
                Text("Habe ich immer")
            } footer: {
                Text("\(owned.union([.none]).count) von \(Equipment.allCases.count) Gerätearten. Übungen ohne Geräte gehen immer.")
            }
            Section {
                NavigationLink { ExcludedExercisesView() } label: {
                    LabeledContent("Übungen, die ich nicht machen kann", value: "\(profile.excludedExercises.count)")
                }
            } footer: {
                Text("Zum Beispiel wegen Beschwerden oder weil das Gerät oft besetzt ist. Der Plan nimmt dafür eine passende Ersatzübung für denselben Muskel.")
            }
        }
        .navigationTitle("Meine Geräte")
        .onAppear {
            guard !loaded else { return }
            owned = profile.ownedEquipment ?? Set(Equipment.allCases.filter { profile.setup.allows($0) })
            loaded = true
        }
        .onChange(of: owned) { _, v in
            guard loaded else { return }
            profile.ownedEquipment = v
            profile.gearAsked = true
        }
        .onDisappear {
            if profile.ownedEquipment == nil { profile.ownedEquipment = owned }
            profile.gearAsked = true
        }
    }
}

/// Übungen aus dem Plan und der Bibliothek an- oder abwählen
struct ExcludedExercisesView: View {
    @EnvironmentObject var profile: UserProfile
    @State private var search = ""

    var body: some View {
        let excluded = profile.excludedExercises
        let q = search.trimmingCharacters(in: .whitespaces)
        let planNames = Set(PlanBuilder.uniqueExercises(profile: profile).map(\.name))
        let all = ExerciseCatalog.libraryTraining.filter {
            q.isEmpty ? (planNames.contains($0.name) || excluded.contains($0.name)) : $0.name.localizedCaseInsensitiveContains(q)
        }
        List {
            Section {
                ForEach(all) { ex in
                    Toggle(isOn: Binding(get: { !excluded.contains(ex.name) }, set: { profile.setCanDo(ex, $0) })) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(ex.name)
                            Text(ex.equipment.rawValue + (profile.allows(ex.equipment) ? "" : " · Gerät nicht vorhanden"))
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text(q.isEmpty ? "Dein Plan und ausgeschlossene Übungen" : "Suchergebnis")
            } footer: {
                Text("Ausgeschaltet = kann ich nicht machen. Suche oben nach weiteren Übungen.")
            }
        }
        .searchable(text: $search, prompt: "Übung suchen")
        .navigationTitle("Übungen")
    }
}

/// Kleines Prozent-Abzeichen: grün = besser als letztes Mal, rot = schlechter
struct PercentBadge: View {
    let value: Double?
    var prefix = ""

    var body: some View {
        if let v = value {
            Text(prefix + percentText(v))
                .font(.caption.monospacedDigit().bold())
                .padding(.horizontal, 6).padding(.vertical, 2)
                .foregroundStyle(abs(v) < 0.5 ? Color.secondary : (v > 0 ? Color.green : Color.red))
                .background((abs(v) < 0.5 ? Color.secondary : (v > 0 ? Color.green : Color.red)).opacity(0.12), in: Capsule())
        }
    }
}
