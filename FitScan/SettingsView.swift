import SwiftUI

/// Bereich „Einstellungen“: Hinweis zur Nutzung (Haftungsausschluss), Körperdaten und Ziele, 3D-Modell und Scan,
/// Geräte und Daten, Premium/Statistik, Datenschutz und Rechtliches. Alles, was vorher im Profil stand, ist hier.
struct SettingsView: View {
    @EnvironmentObject var schedule: ScanSchedule

    var body: some View {
        NavigationStack {
            Form {
                UsageNoticeSection()

                Section {
                    NavigationLink { ProfileView() } label: {
                        Label("Körperdaten und Ziele", systemImage: "person.text.rectangle")
                    }
                } header: {
                    Text("Profil")
                } footer: {
                    Text("Alter, Größe, Gewicht, Ziel, Tempo, Schrittziel, Trainingstage, Ausstattung und Schwerpunkt-Muskeln.")
                }

                Section {
                    NavigationLink { BodyShapeView() } label: { Label("3D-Figur an deinen Körper anpassen", systemImage: "figure.arms.open") }
                    NavigationLink { BodyScanView() } label: { Label("Eigenes 3D-Modell scannen", systemImage: "figure.stand") }
                    NavigationLink { ScanView() } label: { Label("Körpermaße und Körperfett", systemImage: "ruler") }
                    NavigationLink { ScanCheckInView() } label: {
                        HStack {
                            Label("Scan-Intervall und Verlauf", systemImage: "calendar.badge.clock")
                            Spacer()
                            Text(schedule.isDue ? "fällig" : "alle \(schedule.intervalWeeks) Wo.")
                                .font(.footnote)
                                .foregroundStyle(schedule.isDue ? Color.orange : Color.secondary)
                        }
                    }
                } header: {
                    Text("3D-Modell und Körperscan")
                } footer: {
                    Text("Die Figur folgt Größe, Gewicht, Körperfett und auf Wunsch deinem Scan (LiDAR-Kamera oder Video); einzelne Regionen lassen sich nachstellen. Alles bleibt auf diesem iPhone.")
                }

                Section("Geräte und Daten") {
                    NavigationLink { StepSourceView() } label: { StepSourceRow() }
                    NavigationLink { BackupView() } label: { Label("Backup und Gerätewechsel", systemImage: "externaldrive") }
                }

                PremiumAndAdsSection()
                PrivacySection()

                Section("Über die App") {
                    LabeledContent("Version", value: Self.version)
                    NavigationLink { LegalTextView() } label: { Label("Rechtliches", systemImage: "doc.text") }
                }
            }
            .navigationTitle("Einstellungen")
        }
    }

    static var version: String {
        let info = Bundle.main.infoDictionary
        let v = info?["CFBundleShortVersionString"] as? String ?? "–"
        let b = info?["CFBundleVersion"] as? String ?? "–"
        return "\(v) (\(b))"
    }
}

/// Hinweis zur Nutzung: Die App ist nur eine Hilfestellung und hat keine rechtliche Verbindlichkeit.
/// Steht ganz oben in den Einstellungen; die Bestätigung wird nur lokal gespeichert.
struct UsageNoticeSection: View {
    @AppStorage("bfc.notice.acknowledged") private var acknowledged = false

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Label("Nur eine Hilfestellung", systemImage: "exclamationmark.shield.fill")
                    .font(.headline)
                    .foregroundStyle(.orange)
                Text(LegalTexts.usageNotice.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(.footnote)
            }
            .padding(.vertical, 4)
            Toggle("Gelesen und verstanden", isOn: $acknowledged)
            NavigationLink { DisclaimerView() } label: {
                Label("Vollständiger Haftungsausschluss", systemImage: "doc.text.magnifyingglass")
            }
        } header: {
            Text("Hinweis zur Nutzung")
        }
    }
}
