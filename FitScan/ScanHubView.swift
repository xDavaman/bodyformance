import Combine
import SwiftUI

struct ScanHubView: View {
    var body: some View {
        Group {
            List {
                Section("Körperwerte") {
                    NavigationLink {
                        ScanView()
                    } label: {
                        Label("Körpermaße und Körperfett", systemImage: "ruler")
                    }
                }
                Section("3D-Scan") {
                    NavigationLink {
                        BodyScanView()
                    } label: {
                        Label("Körper scannen", systemImage: "figure.stand")
                    }
                }
                Section("Teilen und weiterverwenden") {
                    Text("Nach jedem Scan kannst du das Ergebnis über das Teilen-Menü an andere Apps schicken: Dateien, AirDrop (z. B. an deinen Mac), Mail oder Nachrichten.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Scan")
        }
    }
}
