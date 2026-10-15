import Combine
import SwiftUI
import ARKit
import RealityKit

// MARK: - Modell

@MainActor
final class MeshScanModel: ObservableObject {
    @Published var isRunning = false
    @Published var vertexCount = 0
    @Published var objURL: URL?
    @Published var errorText: String?

    weak var session: ARSession?

    func start() {
        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {
            errorText = "Dieses Gerät hat keinen LiDAR-Scanner."
            return
        }
        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .mesh
        session?.run(config, options: [.resetTracking, .removeExistingAnchors])
        objURL = nil
        errorText = nil
        isRunning = true
    }

    func stopAndExport() {
        guard let session, let frame = session.currentFrame else { return }
        let anchors = frame.anchors.compactMap { $0 as? ARMeshAnchor }
        session.pause()
        isRunning = false
        guard !anchors.isEmpty else {
            errorText = "Noch kein Mesh erfasst. Bewege dich langsamer um das Objekt."
            return
        }
        vertexCount = anchors.reduce(0) { $0 + $1.geometry.vertices.count }
        do {
            objURL = try Self.writeOBJ(anchors: anchors)
        } catch {
            errorText = "Export fehlgeschlagen: \(error.localizedDescription)"
        }
    }

    /// Schreibt alle Mesh-Anker in Weltkoordinaten in eine OBJ-Datei.
    private static func writeOBJ(anchors: [ARMeshAnchor]) throws -> URL {
        var out = "# Bodyformance Mesh\n"
        var vertexOffset = 0

        for anchor in anchors {
            let geo = anchor.geometry
            let vCount = geo.vertices.count

            for i in 0..<vCount {
                let ptr = geo.vertices.buffer.contents()
                    .advanced(by: geo.vertices.offset + geo.vertices.stride * i)
                    .assumingMemoryBound(to: Float.self)
                let local = SIMD4<Float>(ptr[0], ptr[1], ptr[2], 1)
                let world = anchor.transform * local
                out += "v \(world.x) \(world.y) \(world.z)\n"
            }

            let faces = geo.faces
            for i in 0..<faces.count {
                let base = faces.buffer.contents().advanced(by: i * faces.indexCountPerPrimitive * faces.bytesPerIndex)
                var idx: [Int] = []
                for j in 0..<faces.indexCountPerPrimitive {
                    let v = base.load(fromByteOffset: j * faces.bytesPerIndex, as: UInt32.self)
                    idx.append(Int(v) + vertexOffset + 1)
                }
                out += "f \(idx.map(String.init).joined(separator: " "))\n"
            }
            vertexOffset += vCount
        }

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("Koerperscan-\(Int(Date().timeIntervalSince1970)).obj")
        try out.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}

// MARK: - ARView mit Live-Mesh

struct MeshARView: UIViewRepresentable {
    let model: MeshScanModel

    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: .zero)
        view.automaticallyConfigureSession = false
        view.debugOptions.insert(.showSceneUnderstanding)
        model.session = view.session
        return view
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

// MARK: - Screen

struct BodyScanView: View {
    @StateObject private var model = MeshScanModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            MeshARView(model: model)
                .ignoresSafeArea()

            VStack(spacing: 10) {
                if !model.isRunning && model.objURL == nil {
                    Text("Stelle das iPhone auf ein Stativ oder lass jemanden langsam in 1–2 m Abstand einmal um dich herumgehen. Stehe still, Arme leicht vom Körper weg.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
                if let err = model.errorText {
                    Text(err).font(.footnote).foregroundStyle(.red)
                }
                if let url = model.objURL {
                    Text("\(model.vertexCount) Punkte erfasst")
                        .font(.footnote).foregroundStyle(.secondary)
                    ShareLink(item: url) { Label("3D-Scan teilen (.obj)", systemImage: "square.and.arrow.up") }
                        .buttonStyle(.borderedProminent)
                }
                Button(model.isRunning ? "Stopp und exportieren" : "Scan starten") {
                    model.isRunning ? model.stopAndExport() : model.start()
                }
                .buttonStyle(.borderedProminent)
                .tint(model.isRunning ? .red : .blue)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .padding()
        }
        .navigationTitle("Körper scannen")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { model.session?.pause() }
    }
}
