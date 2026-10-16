import Combine
import SwiftUI

/// Körperdaten und Ziele: Körperdaten, Ziel, Optik, Ausstattung und Schwerpunkt-Muskeln.
/// Erreichbar aus dem Profil (oben rechts) und aus den Einstellungen.
struct ProfileView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var schedule: ScanSchedule
    @State private var showExtremeConfirm = false

    var body: some View {
        Form {
            Section { AvatarEditor() }

            Section("Körper") {
                Picker("Geschlecht", selection: Binding(get: { profile.sex }, set: { profile.sex = $0 })) {
                    ForEach(Sex.allCases) { Text($0.rawValue).tag($0) }
                }
                Stepper(value: $profile.age, in: 14...90) { Text("Alter: \(profile.age)") }
                Stepper(value: $profile.heightCm, in: 120...230, step: 1) { Text("Größe: \(Int(profile.heightCm)) cm") }
                Stepper(value: $profile.weightKg, in: 35...250, step: 0.5) { Text("Gewicht: \(formatKg(profile.weightKg)) kg") }
                if let bf = profile.bodyFatEstimate {
                    LabeledContent("Körperfett (Schätzung)", value: String(format: "%.1f %%", bf))
                }
                NavigationLink("Körperfett genauer bestimmen (Maße)") { ScanView() }
                NavigationLink("3D-Figur an deinen Körper anpassen") { BodyShapeView() }
                LabeledContent("BMI", value: String(format: "%.1f", profile.bmi))
            }

            Section("Scan") {
                NavigationLink { ScanView() } label: { Label("Körpermaße und Körperfett", systemImage: "ruler") }
                NavigationLink { BodyScanView() } label: { Label("Körper scannen", systemImage: "figure.stand") }
                NavigationLink { ScanCheckInView() } label: {
                    HStack {
                        Label("Scan-Intervall und Verlauf", systemImage: "calendar.badge.clock")
                        Spacer()
                        Text(schedule.isDue ? "fällig" : "alle \(schedule.intervalWeeks) Wo.")
                            .font(.footnote)
                            .foregroundStyle(schedule.isDue ? Color.orange : Color.secondary)
                    }
                }
            }

            Section {
                Picker("Ziel", selection: Binding(get: { profile.goal }, set: { profile.goal = $0 })) {
                    ForEach(Goal.allCases) { Text($0.rawValue).tag($0) }
                }
                Picker("Wunsch-Optik", selection: Binding(get: { profile.aesthetic }, set: { profile.aesthetic = $0 })) {
                    ForEach(Aesthetic.allCases) { Text($0.rawValue).tag($0) }
                }
                Stepper(value: $profile.targetBodyFat, in: 6...30, step: 0.5) {
                    Text("Ziel-Körperfett: \(formatKg(profile.targetBodyFat)) %")
                }
                if let target = profile.weightAtTargetBodyFat, let bf = profile.bodyFatEstimate {
                    let diff = target - profile.weightKg
                    Text(bf > profile.targetBodyFat
                         ? "Bei gleicher Muskelmasse wären das etwa \(formatKg(target)) kg (\(formatKg(abs(diff))) kg weniger)."
                         : "Dein geschätztes Körperfett liegt schon unter dem Ziel.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            } header: {
                Text("Ziel")
            } footer: {
                Text(profile.aesthetic.note)
            }

            Section {
                Picker("Tempo", selection: Binding(get: { profile.pace }, set: { new in
                    if new == .extreme && !profile.extremeActive { showExtremeConfirm = true } else { profile.pace = new }
                })) {
                    ForEach(Pace.allCases.filter { $0 != .extreme || profile.goal == .fatLoss }) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                if profile.pace == .extreme {
                    Label("Extrem schnell ist nicht gesund und kann zu Gesundheitsschäden führen. Sprich vorher mit deinem Arzt. Noch \(profile.extremeDaysLeft) Tage, dann geht es automatisch auf „Schnell“ zurück.", systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote).foregroundStyle(.red)
                    Button(role: .destructive) { profile.extremeConfirmedAt = 0; profile.pace = .fast } label: {
                        Label("Extrem-Modus abschalten", systemImage: "stop.circle")
                    }
                    Text("Bei erneutem Aktivieren musst du wieder alles bestätigen.").font(.caption2).foregroundStyle(.secondary)
                }
                Text(profile.pace.note(for: profile.goal)).font(.footnote).foregroundStyle(.secondary)
                if let w = profile.weeksToGoal {
                    LabeledContent("Voraussichtliche Dauer", value: "ca. \(w) Wochen")
                }
            } header: {
                Text("Wie schnell?")
            } footer: {
                Text("Das Tempo passt Kalorien, Mahlzeiten, Trainingsumfang, Schrittziel und Wasser an. Trainingsplan und Essensvorschläge rechnen sich sofort neu.")
            }

            Section {
                LabeledContent("Empfehlung", value: "\(profile.recommendedSteps) Schritte pro Tag")
                Toggle("Empfehlung verwenden", isOn: Binding(
                    get: { profile.stepGoalCustom == 0 },
                    set: { profile.stepGoalCustom = $0 ? 0 : profile.recommendedSteps }))
                if profile.stepGoalCustom > 0 {
                    Stepper(value: $profile.stepGoalCustom, in: 3000...25000, step: 500) {
                        Text("Eigenes Ziel: \(profile.stepGoalCustom) Schritte")
                    }
                }
                Text(profile.stepAdvice).font(.footnote).foregroundStyle(.secondary)
            } header: {
                Text("Schritte")
            } footer: {
                Text("Aktuelles Tagesziel: \(profile.stepGoal) Schritte. Es wird live gezählt und im Profil angezeigt.")
            }

            Section {
                Picker("Erfahrung", selection: Binding(get: { profile.experience }, set: { profile.experience = $0 })) {
                    ForEach(Experience.allCases) { Text($0.rawValue).tag($0) }
                }
                Picker("Ausstattung", selection: Binding(get: { profile.setup }, set: { profile.setup = $0 })) {
                    ForEach(Setup.allCases) { Text($0.rawValue).tag($0) }
                }
                Stepper(value: $profile.trainingDays, in: 2...6) { Text("Trainingstage pro Woche: \(profile.trainingDays)") }
                Picker("Zusatzsport", selection: Binding(get: { profile.sport }, set: { profile.sport = $0 })) {
                    ForEach(Sport.allCases) { Text($0.rawValue).tag($0) }
                }
            } header: {
                Text("Training")
            } footer: {
                Text("Ab 2 Tagen: Ganzkörper, 3: Push/Pull/Beine, 4: Ober-/Unterkörper, 5–6: Push/Pull/Beine mit Ergänzung bzw. doppelt.")
            }

            Section {
                ForEach(Muscle.focusChoices) { m in
                    Toggle(m.rawValue, isOn: Binding(
                        get: { profile.focusMuscles.contains(m) },
                        set: { on in
                            var set = profile.focusMuscles
                            if on { set.insert(m) } else { set.remove(m) }
                            profile.focusMuscles = set
                        }))
                }
            } header: {
                Text("Schwerpunkt-Muskeln")
            } footer: {
                Text("Für diese Muskeln bekommst du im Plan eine zusätzliche Übung und einen zusätzlichen Satz. Wähle höchstens 2–3, sonst ist der Schwerpunkt keiner mehr.")
            }

            Section {
                MuscleModelView(primary: Array(profile.focusMuscles), height: 260, primaryLabel: "Schwerpunkt")
                    .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            } header: {
                Text("Dein Schwerpunkt im 3D-Modell")
            }

            Section("Vorschau Tagesziele") {
                LabeledContent("Kalorien", value: "\(profile.targetCalories) kcal")
                LabeledContent("Protein", value: "\(profile.proteinGrams) g")
            }

        }
        .sheet(isPresented: $showExtremeConfirm) {
            RadicalConfirmView { profile.extremeConfirmedAt = Date().timeIntervalSince1970; profile.pace = .extreme }
        }
        .navigationTitle("Körperdaten und Ziele")
    }
}
