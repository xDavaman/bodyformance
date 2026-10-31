import Combine
import SwiftUI
import Charts

/// Empfehlung, Satz-Eingabe, Verlauf und letzte Sätze für eine Trainingsübung.
struct ExerciseLogSections: View {
    let exercise: Exercise
    @EnvironmentObject var store: TrainingStore
    @EnvironmentObject var profile: UserProfile

    @State private var weight: Double = 20
    @State private var reps: Int = 8
    @State private var prefilled = false

    private var sessions: [[SetLog]] { store.sessions(for: exercise.name) }
    private var plan: GoalPlan { profile.effectivePlan }

    private var rec: Recommendation {
        Progression.recommend(exercise: exercise, goal: profile.goal, plan: plan,
                              sessions: sessions, bodyWeight: profile.weightKg)
    }

    private func describe(_ s: SetLog) -> String {
        switch exercise.kind {
        case .weighted: return "\(formatKg(s.weightKg)) kg × \(s.reps)"
        case .bodyweight: return s.weightKg > 0 ? "+\(formatKg(s.weightKg)) kg × \(s.reps)" : "\(s.reps) Wdh."
        case .seconds: return "\(s.reps) s"
        }
    }

    var body: some View {
        Section("Empfehlung: \(profile.goal.rawValue)") {
            if exercise.kind == .weighted, let w = rec.weightKg {
                LabeledContent("Nächstes Gewicht", value: "\(formatKg(w)) kg")
            }
            LabeledContent("Umfang", value: "\(rec.setsText), \(rec.repsText)")
            LabeledContent("Pause", value: plan.rest)
            Text(rec.message)
                .font(.footnote)
                .foregroundStyle(.secondary)
            if let warning = rec.warning {
                Label(warning, systemImage: "exclamationmark.triangle")
                    .font(.footnote)
                    .foregroundStyle(.orange)
            }
        }

        Section("Satz eintragen") {
            switch exercise.kind {
            case .weighted:
                Stepper(value: $weight, in: 0...500, step: 2.5) {
                    Text("Gewicht: \(formatKg(weight)) kg")
                }
                Stepper(value: $reps, in: 1...50) { Text("Wiederholungen: \(reps)") }
            case .bodyweight:
                Stepper(value: $reps, in: 1...100) { Text("Wiederholungen: \(reps)") }
                Stepper(value: $weight, in: 0...100, step: 2.5) {
                    Text("Zusatzgewicht: \(formatKg(weight)) kg")
                }
            case .seconds:
                Stepper(value: $reps, in: 5...600, step: 5) { Text("Dauer: \(reps) s") }
            }
            let candidate = SetLog(exercise: exercise.name, date: Date(), weightKg: exercise.kind == .seconds ? 0 : weight, reps: reps)
            if let pct = Progression.change(of: candidate, in: store.sets) {
                HStack {
                    Text("Gegenüber der letzten Einheit").font(.footnote).foregroundStyle(.secondary)
                    Spacer()
                    PercentBadge(value: pct)
                }
            }
            Button("Satz speichern") {
                store.addSet(exercise: exercise.name, weightKg: exercise.kind == .seconds ? 0 : weight, reps: reps)
            }
        }
        .onAppear {
            guard !prefilled else { return }
            switch exercise.kind {
            case .weighted:
                if let w = rec.weightKg { weight = w }
                reps = plan.reps.lowerBound
            case .bodyweight:
                weight = rec.weightKg ?? 0
                if let last = sessions.last, let m = last.map(\.reps).min() {
                    reps = min(Progression.bodyweightReps.upperBound, m + 1)
                } else { reps = 8 }
            case .seconds:
                reps = (sessions.last?.map(\.reps).max()).map { $0 + 5 } ?? 30
            }
            prefilled = true
        }

        let points = Progression.sessionPoints(sessions)
        if points.count >= 2 {
            Section(exercise.kind == .weighted ? "Verlauf (geschätztes Maximalgewicht)" : "Verlauf (beste Leistung)") {
                Chart(points) { p in
                    LineMark(x: .value("Datum", p.date), y: .value("Wert", p.e1RM))
                    PointMark(x: .value("Datum", p.date), y: .value("Wert", p.e1RM))
                }
                .chartYScale(domain: .automatic(includesZero: false))
                .frame(height: 160)
            }
        }

        let recent = Array(
            store.sets
                .filter { $0.exercise == exercise.name }
                .sorted { $0.date > $1.date }
                .prefix(12)
        )
        if !recent.isEmpty {
            Section {
                ForEach(recent) { s in
                    HStack {
                        Text(s.date, format: .dateTime.day().month())
                        Spacer()
                        Text(describe(s)).foregroundStyle(.secondary)
                        PercentBadge(value: Progression.change(of: s, in: store.sets))
                    }
                }
                .onDelete { offsets in
                    for i in offsets { store.remove(recent[i]) }
                }
            } header: {
                Text("Letzte Sätze")
            } footer: {
                Text("Prozent: geschätzte Leistung (Gewicht × Wiederholungen) im Vergleich zum besten Satz der Einheit davor. Grün = besser, rot = schwächer.")
            }
        }
    }
}
