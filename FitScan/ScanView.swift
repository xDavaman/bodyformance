import Combine
import SwiftUI
import ARKit

struct ScanView: View {
    @EnvironmentObject var profile: UserProfile

    private var lidarAvailable: Bool {
        ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
    }

    var body: some View {
        Group {
            Form {
                Section("Gerät") {
                    Label(lidarAvailable ? "LiDAR verfügbar" : "Kein LiDAR erkannt",
                          systemImage: lidarAvailable ? "checkmark.seal" : "xmark.seal")
                }

                Section("Körpermaße (Zwischenlösung)") {
                    Stepper("Alter: \(profile.age)", value: $profile.age, in: 14...90)
                    numberField("Größe (cm)", $profile.heightCm)
                    numberField("Gewicht (kg)", $profile.weightKg)
                    numberField("Taille (cm)", $profile.waistCm)
                    numberField("Hals (cm)", $profile.neckCm)
                    if let bf = profile.bodyFatEstimate {
                        LabeledContent("Geschätzter Körperfettanteil", value: String(format: "%.1f %%", bf))
                    }
                }

                Section("3D-Scan") {
                    Text("Den 3D-Körperscan und das Scan-Intervall findest du im Profil unter \"Scan\". Daraus automatisch Umfänge und Körperfett zu berechnen kommt als Nächstes, bis dahin gelten die Maße oben.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Maße")
        }
    }

    private func numberField(_ title: String, _ value: Binding<Double>) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField("", value: value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
        }
    }
}
