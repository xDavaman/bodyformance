import Combine
import SwiftUI

/// Art der Übung im Bereich Mobility (aus dem Übungsnamen abgeleitet)
enum MobilityStyle: String, CaseIterable, Identifiable {
    case mobility = "Mobility", yoga = "Yoga", pilates = "Pilates", stretch = "Dehnen", rehab = "Reha", fascia = "Faszien"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .mobility: return "figure.flexibility"
        case .yoga: return "figure.yoga"
        case .pilates: return "figure.pilates"
        case .stretch: return "figure.cooldown"
        case .rehab: return "cross.case"
        case .fascia: return "cylinder"
        }
    }

    static func of(_ ex: Exercise) -> MobilityStyle {
        let n = ex.name.lowercased()
        if n.hasPrefix("yoga") { return .yoga }
        if n.hasPrefix("pilates") { return .pilates }
        if n.hasPrefix("rehab") { return .rehab }
        if n.hasPrefix("faszienrolle") || (ex.equipment == .foam && !n.contains("dehnung")) { return .fascia }
        if n.contains("dehnung") { return .stretch }
        return .mobility
    }
}

/// Bereich „Mobility“: Mobility, Yoga, Pilates, Dehnen und Reha nach Art und Körperregion plus tägliche Empfehlung.
/// Jede Übung öffnet die 3D-Figur mit ihrer Bewegung. Wird in einem NavigationStack angezeigt.
struct MobilityView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var store: TrainingStore
    @State private var region: MobilityRegion? = nil
    @State private var style: MobilityStyle? = nil
    @State private var search = ""

    private var items: [Exercise] {
        let q = search.trimmingCharacters(in: .whitespaces)
        return ExerciseCatalog.libraryMobility.filter {
            (region == nil || $0.region == region) && (style == nil || MobilityStyle.of($0) == style)
                && profile.canDo($0)
                && (q.isEmpty || $0.name.localizedCaseInsensitiveContains(q))
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

            Section("Art") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        chip("Alle", icon: "square.grid.2x2", selected: style == nil) { style = nil }
                        ForEach(MobilityStyle.allCases) { s in
                            chip(s.rawValue, icon: s.icon, selected: style == s) { style = s }
                        }
                    }
                    .padding(.vertical, 2)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
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
                        ExerciseRow(exercise: ex, detail: "\(MobilityStyle.of(ex).rawValue) · \(ex.region?.rawValue ?? "") · \(ex.dose)")
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
        .searchable(text: $search, prompt: "Übung suchen, z. B. Krieger")
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
