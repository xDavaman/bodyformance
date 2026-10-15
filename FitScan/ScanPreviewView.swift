import Combine
import SceneKit
import SwiftUI
import UIKit

// Vorschau eines gespeicherten Scans: farbige Punktwolke, darübergelegtes Netz (Drahtgitter) und – falls vorhanden –
// das texturierte Modell. Mit dem Finger drehen und zoomen. Dazu geschätzte Maße, Teilen und die Übergabe an das
// 3D-Modellprojekt.

struct ScanSceneView: UIViewRepresentable {
    let pointsURL: URL?
    let meshURL: URL?
    let modelURL: URL?
    var showPoints = true
    var showMesh = true
    var showModel = false

    final class Coordinator {
        let scene = SCNScene()
        let pointsNode = SCNNode()
        let meshNode = SCNNode()
        let modelNode = SCNNode()
        var loaded = false
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> SCNView {
        let v = SCNView()
        v.backgroundColor = .black
        v.allowsCameraControl = true
        v.autoenablesDefaultLighting = true
        v.antialiasingMode = .multisampling4X
        let c = context.coordinator
        for n in [c.pointsNode, c.meshNode, c.modelNode] { c.scene.rootNode.addChildNode(n) }
        v.scene = c.scene
        load(into: c, view: v)
        return v
    }

    func updateUIView(_ v: SCNView, context: Context) {
        let c = context.coordinator
        c.pointsNode.isHidden = !showPoints
        c.meshNode.isHidden = !showMesh
        c.modelNode.isHidden = !showModel
    }

    private func load(into c: Coordinator, view: SCNView) {
        guard !c.loaded else { return }
        c.loaded = true
        let pURL = pointsURL, mURL = meshURL, oURL = modelURL
        Task {
            let cloud = await Task.detached(priority: .userInitiated) { () -> ([SIMD3<Float>], [SIMD3<UInt8>]) in
                guard let pURL else { return ([], []) }
                let r = ScanFiles.readPLY(pURL)
                return (r.points, r.colors)
            }.value
            if !cloud.0.isEmpty { c.pointsNode.addChildNode(Self.pointNode(cloud.0, cloud.1)) }
            if let mURL, let s = try? SCNScene(url: mURL) {
                let wire = SCNMaterial()
                wire.fillMode = .lines
                wire.lightingModel = .constant
                wire.diffuse.contents = UIColor(red: 0.20, green: 0.85, blue: 1.0, alpha: 0.85)
                wire.isDoubleSided = true
                for child in s.rootNode.childNodes {
                    child.enumerateHierarchy { n, _ in n.geometry?.materials = [wire] }
                    c.meshNode.addChildNode(child)
                }
            }
            if let oURL, let s = try? SCNScene(url: oURL) {
                for child in s.rootNode.childNodes { c.modelNode.addChildNode(child) }
            }
            // Alles um den Mittelpunkt drehen
            let (minB, maxB) = c.scene.rootNode.boundingBox
            let center = SCNVector3((minB.x + maxB.x) / 2, (minB.y + maxB.y) / 2, (minB.z + maxB.z) / 2)
            for n in [c.pointsNode, c.meshNode, c.modelNode] { n.position = SCNVector3(-center.x, -center.y, -center.z) }
            let size = max(maxB.x - minB.x, maxB.y - minB.y, maxB.z - minB.z)
            let cam = SCNNode()
            cam.camera = SCNCamera()
            cam.camera?.zNear = 0.01
            cam.position = SCNVector3(0, 0, max(1, size) * 1.6)
            c.scene.rootNode.addChildNode(cam)
            view.pointOfView = cam
        }
    }

    /// Punktwolke als SceneKit-Geometrie mit Punkt-Primitiven (Farbe je Punkt)
    static func pointNode(_ pts: [SIMD3<Float>], _ cols: [SIMD3<UInt8>]) -> SCNNode {
        let verts = pts.map { SCNVector3($0.x, $0.y, $0.z) }
        var sources = [SCNGeometrySource(vertices: verts)]
        if cols.count == pts.count {
            var floats: [Float] = []
            floats.reserveCapacity(cols.count * 3)
            for c in cols { floats += [Float(c.x) / 255, Float(c.y) / 255, Float(c.z) / 255] }
            let data = floats.withUnsafeBufferPointer { Data(buffer: $0) }
            sources.append(SCNGeometrySource(data: data, semantic: .color, vectorCount: cols.count, usesFloatComponents: true,
                                             componentsPerVector: 3, bytesPerComponent: 4, dataOffset: 0, dataStride: 12))
        }
        let indices = (0..<Int32(pts.count)).map { $0 }
        let element = SCNGeometryElement(indices: indices, primitiveType: .point)
        element.pointSize = 3
        element.minimumPointScreenSpaceRadius = 1
        element.maximumPointScreenSpaceRadius = 4
        let geo = SCNGeometry(sources: sources, elements: [element])
        let m = SCNMaterial()
        m.lightingModel = .constant
        m.diffuse.contents = cols.count == pts.count ? UIColor.white : UIColor(white: 0.85, alpha: 1)
        geo.materials = [m]
        return SCNNode(geometry: geo)
    }
}

struct ScanPreviewView: View {
    @State var record: BodyScanRecord
    @ObservedObject private var store = BodyScanStore.shared
    @EnvironmentObject var profile: UserProfile
    @State private var showPoints = true
    @State private var showMesh = true
    @State private var showModel = false
    @State private var applied = false
    @State private var working = false
    @State private var bridgeError: String?

    var body: some View {
        List {
            Section {
                ScanSceneView(pointsURL: store.url(record.pointFile, in: record),
                              meshURL: store.url(record.meshFile, in: record),
                              modelURL: store.url(record.modelFile, in: record),
                              showPoints: showPoints, showMesh: showMesh, showModel: showModel)
                    .frame(height: 380)
                    .listRowInsets(EdgeInsets())
                if record.pointFile != nil { Toggle("Punktwolke (\(record.pointCount.formatted()) Punkte)", isOn: $showPoints) }
                if record.meshFile != nil { Toggle("Netz (\(record.faceCount.formatted()) Dreiecke)", isOn: $showMesh) }
                if record.modelFile != nil { Toggle("Texturiertes Modell", isOn: $showModel) }
            } footer: {
                Text("Mit einem Finger drehen, mit zwei Fingern verschieben und zoomen.")
            }

            if let m = record.measurements {
                Section {
                    row("Größe", m.heightCm)
                    row("Hals", m.neckCm)
                    row("Brust", m.chestCm)
                    row("Taille", m.waistCm)
                    row("Hüfte", m.hipCm)
                    row("Oberschenkel", m.thighCm)
                    Button {
                        if let h = m.heightCm { profile.heightCm = h.rounded() }
                        if let w = m.waistCm { profile.waistCm = w.rounded() }
                        if let n = m.neckCm { profile.neckCm = n.rounded() }
                        applied = true
                    } label: {
                        Label(applied ? "Übernommen" : "Größe, Taille und Hals ins Profil übernehmen", systemImage: applied ? "checkmark" : "arrow.down.doc")
                    }
                    .disabled(applied)
                } header: {
                    Text("Maße aus dem Scan (Schätzung)")
                } footer: {
                    Text("Umfänge werden aus der Punktwolke berechnet und fallen meist 1–3 cm größer aus als mit dem Maßband. Für die Körperfett-Schätzung zählen Taille und Hals.")
                }
            }

            Section {
                if let provider = BodyModelBridge.provider {
                    Button {
                        Task { await makeAvatar(provider) }
                    } label: {
                        Label(working ? "Avatar wird erzeugt …" : "Avatar mit \(provider.name) erzeugen", systemImage: "figure.stand")
                    }
                    .disabled(working)
                    if let bridgeError { Text(bridgeError).font(.footnote).foregroundStyle(.red) }
                } else {
                    Label("3D-Modellprojekt noch nicht verbunden", systemImage: "puzzlepiece.extension")
                    Text("Platzhalter: Sobald das 3D-Modellprojekt zusammengeführt ist, entsteht hier aus diesem Scan dein beweglicher Avatar für die Übungsansicht.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            } header: {
                Text("Avatar")
            }

            Section("Teilen und weiterverwenden") {
                let files = [record.pointFile, record.meshFile, record.modelFile].compactMap { store.url($0, in: record) }
                if files.isEmpty {
                    Text("Keine Dateien vorhanden.").foregroundStyle(.secondary)
                } else {
                    ShareLink(items: files) {
                        Label("Dateien teilen (.ply, .obj, .usdz)", systemImage: "square.and.arrow.up")
                    }
                }
                Text("PLY = Punktwolke, OBJ = Netz, USDZ = Modell. Öffnen z. B. mit Blender, MeshLab oder am Mac per AirDrop.")
                    .font(.footnote).foregroundStyle(.secondary)
            }

            Section("Info") {
                LabeledContent("Quelle", value: record.source.rawValue)
                LabeledContent("Datum", value: record.date.formatted(date: .abbreviated, time: .shortened))
                if !record.note.isEmpty { Text(record.note).font(.footnote) }
            }
        }
        .navigationTitle("Scan-Vorschau")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if record.pointFile == nil && record.meshFile == nil { showModel = true } }
    }

    private func row(_ title: String, _ cm: Double?) -> some View {
        LabeledContent(title, value: cm.map { String(format: "%.0f cm", $0) } ?? "–")
    }

    private func makeAvatar(_ provider: BodyModelProvider) async {
        working = true
        defer { working = false }
        let folder = store.folder(for: record)
        do {
            let url = try await provider.makeModel(from: record, folder: folder)
            let dst = folder.appendingPathComponent("avatar.usdz")
            if url != dst {
                try? FileManager.default.removeItem(at: dst)
                try FileManager.default.copyItem(at: url, to: dst)
            }
            var r = record
            r.modelFile = "avatar.usdz"
            if let m = try? await provider.measurements(from: r, folder: folder) { r.measurements = m }
            store.update(r)
            record = r
            showModel = true
            bridgeError = nil
        } catch {
            bridgeError = "Avatar konnte nicht erzeugt werden: \(error.localizedDescription)"
        }
    }
}
