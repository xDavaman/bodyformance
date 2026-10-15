import Combine
import SwiftUI

// Schrittquelle wählen: Garmin (oder eine andere Uhr) 1:1 übernehmen, Apple Health gesamt oder nur iPhone.

/// Kurzinfo unter dem Schrittzähler: woher die Zahl kommt und wann die Uhr zuletzt synchronisiert hat.
struct StepSourceRow: View {
    @EnvironmentObject var health: HealthManager

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label(title, systemImage: health.usesWatchSteps ? "applewatch" : "iphone")
            if let d = health.lastStepSync, health.usesWatchSteps {
                Text("Zuletzt synchronisiert: \(d.formatted(date: .omitted, time: .shortened))\(Calendar.current.isDateInToday(d) ? "" : " (\(d.formatted(date: .abbreviated, time: .omitted)))")")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    private var title: String {
        if health.stepMode == .phone { return "Quelle: iPhone" }
        if let s = health.activeStepSource { return "Quelle: \(s.name) (1:1)" }
        return health.isAuthorized ? "Quelle: Apple Health + iPhone" : "Quelle: iPhone (Apple Health nicht erlaubt)"
    }
}

struct StepSourceView: View {
    @EnvironmentObject var health: HealthManager
    @EnvironmentObject var tracker: StepTracker

    var body: some View {
        Form {
            Section {
                LabeledContent("Heute angezeigt", value: health.displaySteps(phone: tracker.steps).formatted())
                LabeledContent("Apple Health (gewählte Quelle)", value: health.stepsToday.formatted())
                LabeledContent("iPhone-Sensor", value: tracker.available ? tracker.steps.formatted() : "–")
                if let d = health.lastStepSync {
                    LabeledContent("Letzter Eintrag", value: d.formatted(date: .abbreviated, time: .shortened))
                }
            } header: {
                Text("Vergleich")
            }

            Section {
                Picker("Quelle", selection: $health.stepMode) {
                    ForEach(StepSourceMode.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            } header: {
                Text("Schritte übernehmen von")
            } footer: {
                Text(health.stepMode.explanation)
            }

            if health.stepMode == .watch {
                Section("Quelle wählen") {
                    if health.stepSources.isEmpty {
                        Text("Noch keine Quelle gefunden. Erlaube Apple Health und synchronisiere die Uhr einmal.").foregroundStyle(.secondary)
                    }
                    ForEach(health.stepSources) { src in
                        Button {
                            health.stepSourceID = src.bundleID
                        } label: {
                            HStack {
                                Label(src.name, systemImage: src.isGarmin ? "applewatch.side.right" : "app")
                                Spacer()
                                if src.bundleID == health.stepSourceID { Image(systemName: "checkmark").foregroundStyle(.tint) }
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }

            if health.stepMode == .auto && health.activeStepSource == nil {
                Section {
                    Label("Garmin Connect schreibt noch nicht in Apple Health", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                } footer: {
                    Text("Bis dahin zählt Apple Health gesamt.")
                }
            }

            Section {
                Label("Garmin Connect öffnen → Mehr → Einstellungen → Verbundene Apps → Apple Health", systemImage: "1.circle")
                Label("„Schritte“ (und gern Workouts, Ruhepuls, Gewicht) zum Schreiben freigeben", systemImage: "2.circle")
                Label("Hier „Automatisch“ oder „Bestimmte Uhr oder App“ → Garmin Connect wählen", systemImage: "3.circle")
            } header: {
                Text("Garmin verbinden")
            } footer: {
                Text("Garmin Connect überträgt die Schritte in Schüben (meist alle paar Minuten bis Stunden, sobald die Uhr mit dem Handy synchronisiert). Die App aktualisiert sich automatisch, sobald neue Werte in Apple Health ankommen. Mit „Automatisch“ zeigt die App genau die Garmin-Zahl, ohne die iPhone-Schritte dazuzumischen – so stimmt sie 1:1 mit Garmin Connect überein.")
            }
        }
        .navigationTitle("Schrittzähler")
        .refreshable { await health.refresh() }
        .task { await health.refresh() }
    }
}
