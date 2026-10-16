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

                Section("Körpermaße (mit dem Maßband)") {
                    Stepper("Alter: \(profile.age)", value: $profile.age, in: 14...90)
                    numberField("Größe (cm)", $profile.heightCm)
                    numberField("Gewicht (kg)", $profile.weightKg)
                    numberField("Taille (cm)", $profile.waistCm)
                    numberField("Hals (cm)", $profile.neckCm)
                    numberField(profile.sex == .female ? "Hüfte (cm)" : "Hüfte (cm, optional)", $profile.hipCm)
                }

                BodyFatSection(showLink: false)

                Section("3D-Scan") {
                    NavigationLink { BodyScanView() } label: { Label("Körper scannen (LiDAR oder Video)", systemImage: "figure.stand") }
                    Text("Nach einem Scan kannst du Größe, Taille und Hals in der Scan-Vorschau direkt hierher übernehmen.")
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
