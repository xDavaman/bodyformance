import Combine
import SwiftUI
import ARKit
import UniformTypeIdentifiers

// Körperscan-Übersicht: LiDAR-Scan (Punktwolke + Netz), 3D aus Video, Import, gespeicherte Scans und der
// Platzhalter für das 3D-Modellprojekt (siehe BodyModelBridge in BodyScanStore.swift).

struct BodyScanView: View {
    @ObservedObject private var store = BodyScanStore.shared
    @State private var importing = false
    @State private var importError: String?

    var body: some View {
        List {
            Section {
                NavigationLink { LiDARScanView() } label: {
                    row("LiDAR-Scan (Punktwolke und Netz)", "dot.radiowaves.left.and.right",
                        LiDARScanModel.supported ? "Live mit der Kamera, so viele Punkte wie möglich, Netz wird darübergelegt" : "Braucht ein iPhone mit LiDAR (Pro-Modelle)")
                }
                .disabled(!LiDARScanModel.supported)
                NavigationLink { VideoScanView() } label: {
                    row("3D-Modell aus Video", "video", "Video um die Person herum filmen, daraus rechnet das iPhone ein Netz")
                }
                Button { importing = true } label: {
                    row("Modell oder Punktwolke importieren", "square.and.arrow.down", "USDZ, OBJ oder PLY, z. B. aus dem 3D-Modellprojekt")
                }
                if let importError { Text(importError).font(.footnote).foregroundStyle(.red) }
            } header: {
                Text("Neuer Scan")
            }

            Section {
                if let p = BodyModelBridge.provider {
                    Label("Verbunden: \(p.name)", systemImage: "checkmark.seal")
                } else {
                    Label("Platzhalter: 3D-Modellprojekt", systemImage: "puzzlepiece.extension")
                    Text("Hier wird das 3D-Modellprojekt eingehängt. Es bekommt jeden Scan (Punktwolke, Netz, Maße) und liefert den fertigen Avatar zurück, der dann in der Übungsansicht trainiert.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            } header: {
                Text("Avatar")
            }

            Section {
                if store.records.isEmpty {
                    Text("Noch keine Scans gespeichert.").foregroundStyle(.secondary)
                }
                ForEach(store.records) { r in
                    NavigationLink { ScanPreviewView(record: r) } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Label(r.date.formatted(date: .abbreviated, time: .shortened), systemImage: r.source.icon)
                            Text(summary(r)).font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { idx in
                    for i in idx { store.delete(store.records[i]) }
                }
            } header: {
                Text("Gespeicherte Scans")
            } footer: {
                Text("Alle Scans bleiben auf deinem iPhone.")
            }
        }
        .navigationTitle("Körper scannen")
        .fileImporter(isPresented: $importing, allowedContentTypes: Self.importTypes) { result in
            switch result {
            case .success(let url): importFile(url)
            case .failure(let e): importError = e.localizedDescription
            }
        }
    }

    static var importTypes: [UTType] {
        [UTType.usdz, UTType(filenameExtension: "obj"), UTType(filenameExtension: "ply")].compactMap { $0 }
    }

    private func row(_ title: String, _ icon: String, _ sub: String) -> some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                Text(sub).font(.footnote).foregroundStyle(.secondary)
            }
        } icon: { Image(systemName: icon) }
    }

    private func summary(_ r: BodyScanRecord) -> String {
        var parts = [r.source.rawValue]
        if r.pointCount > 0 { parts.append("\(r.pointCount.formatted()) Punkte") }
        if r.faceCount > 0 { parts.append("\(r.faceCount.formatted()) Dreiecke") }
        if let w = r.measurements?.waistCm { parts.append(String(format: "Taille %.0f cm", w)) }
        if !r.note.isEmpty { parts.append(r.note) }
        return parts.joined(separator: " · ")
    }

    /// Übernimmt eine Datei aus „Dateien“ als neuen Scan.
    private func importFile(_ url: URL) {
        let access = url.startAccessingSecurityScopedResource()
        defer { if access { url.stopAccessingSecurityScopedResource() } }
        var r = BodyScanRecord(source: .imported)
        let folder = store.folder(for: r)
        let ext = url.pathExtension.lowercased()
        let name: String
        switch ext {
        case "ply": name = "points.ply"
        case "obj": name = "mesh.obj"
        default: name = "model.usdz"
        }
        do {
            try FileManager.default.copyItem(at: url, to: folder.appendingPathComponent(name))
        } catch {
            importError = "Import fehlgeschlagen: \(error.localizedDescription)"
            store.delete(r)
            return
        }
        switch ext {
        case "ply":
            r.pointFile = name
            let pts = ScanFiles.readPLY(folder.appendingPathComponent(name), maxPoints: 2_000_000).points
            r.pointCount = pts.count
            r.measurements = BodyMeasure.estimate(points: pts)
        case "obj":
            r.meshFile = name
            let (v, f) = MeshFileIO.load(folder.appendingPathComponent(name))
            r.vertexCount = v.count; r.faceCount = f.count
            r.measurements = BodyMeasure.estimate(points: v)
        default:
            r.modelFile = name
        }
        r.note = url.lastPathComponent
        importError = nil
        store.add(r)
    }
}
