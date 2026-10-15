import AVFoundation
import Combine
import CoreTransferable
import ModelIO
import PhotosUI
import RealityKit
import SwiftUI
import UIKit
import UniformTypeIdentifiers

// 3D-Modell aus einem Video: Aus dem Video werden gleichmäßig Einzelbilder gezogen, daraus rechnet Apples
// Photogrammetrie (RealityKit Object Capture, auf dem Gerät) ein texturiertes Netz. Aus dessen Eckpunkten entsteht
// zusätzlich eine Punktwolke, damit die Vorschau Punkte und Netz übereinander zeigen kann.

/// Video aus der Mediathek als Datei übernehmen
nonisolated struct ScanMovie: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let ext = received.file.pathExtension.isEmpty ? "mov" : received.file.pathExtension
            let dst = FileManager.default.temporaryDirectory.appendingPathComponent("scanvideo-\(UUID().uuidString).\(ext)")
            try FileManager.default.copyItem(at: received.file, to: dst)
            return ScanMovie(url: dst)
        }
    }
}

@MainActor
final class VideoScanModel: ObservableObject {
    enum Phase: Equatable {
        case idle, extracting, reconstructing, saving, done, failed(String)
    }

    @Published var phase: Phase = .idle
    @Published var progress = 0.0
    @Published var frameCount = 0
    /// Wie viele Einzelbilder aus dem Video gezogen werden (mehr = genauer, aber langsamer)
    @Published var targetFrames = 80

    static var supported: Bool { PhotogrammetrySession.isSupported }

    func run(video: URL) async -> BodyScanRecord? {
        let store = BodyScanStore.shared
        let draft = BodyScanRecord(source: .video)
        let folder = store.folder(for: draft)
        let frames = folder.appendingPathComponent("frames", isDirectory: true)
        try? FileManager.default.createDirectory(at: frames, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: video) }

        // 1. Einzelbilder
        phase = .extracting
        progress = 0
        do {
            frameCount = try await extractFrames(from: video, to: frames, count: targetFrames)
        } catch {
            phase = .failed("Video konnte nicht gelesen werden: \(error.localizedDescription)")
            store.delete(draft)
            return nil
        }
        guard frameCount >= 20 else {
            phase = .failed("Zu wenige brauchbare Bilder (\(frameCount)). Das Video sollte mindestens 20 Sekunden lang sein.")
            store.delete(draft)
            return nil
        }

        // 2. Photogrammetrie
        guard Self.supported else {
            phase = .failed("Dieses iPhone kann aus Bildern kein 3D-Modell rechnen (nötig: iPhone mit LiDAR, iOS 17 oder neuer). Die Einzelbilder liegen im Scan-Ordner und lassen sich am Mac mit Reality Composer weiterverarbeiten.")
            var r = draft
            r.note = "Nur Einzelbilder (\(frameCount))"
            store.add(r)
            return nil
        }
        phase = .reconstructing
        progress = 0
        let modelURL = folder.appendingPathComponent("model.usdz")
        do {
            var config = PhotogrammetrySession.Configuration()
            config.sampleOrdering = .sequential
            config.featureSensitivity = .high
            let session = try PhotogrammetrySession(input: frames, configuration: config)
            try session.process(requests: [.modelFile(url: modelURL, detail: .reduced)])
            outer: for try await output in session.outputs {
                switch output {
                case .requestProgress(_, let fraction):
                    progress = fraction
                case .requestError(_, let error):
                    throw error
                case .processingComplete:
                    break outer
                default:
                    break
                }
            }
        } catch {
            phase = .failed("3D-Berechnung fehlgeschlagen: \(error.localizedDescription). Tipp: gleichmäßiges Licht, Person steht still, einmal langsam ganz herum filmen.")
            store.delete(draft)
            return nil
        }
        guard FileManager.default.fileExists(atPath: modelURL.path) else {
            phase = .failed("Es wurde kein Modell erzeugt.")
            store.delete(draft)
            return nil
        }

        // 3. Netz und Punktwolke für Vorschau und Maße
        phase = .saving
        let rec: BodyScanRecord = await Task.detached(priority: .userInitiated) {
            var r = draft
            r.modelFile = "model.usdz"
            let (verts, faces) = MeshFileIO.load(modelURL)
            if !faces.isEmpty, (try? ScanFiles.writeOBJ(vertices: verts, faces: faces, to: folder.appendingPathComponent("mesh.obj"))) != nil {
                r.meshFile = "mesh.obj"
                r.vertexCount = verts.count
                r.faceCount = faces.count
            }
            if !verts.isEmpty, (try? ScanFiles.writePLY(points: verts, colors: [], to: folder.appendingPathComponent("points.ply"))) != nil {
                r.pointFile = "points.ply"
                r.pointCount = verts.count
            }
            r.measurements = BodyMeasure.estimate(points: verts)
            try? FileManager.default.removeItem(at: frames)
            return r
        }.value
        store.add(rec)
        phase = .done
        return rec
    }

    /// Zieht `count` gleichmäßig verteilte Bilder (max. 2048 px) aus dem Video und speichert sie als JPEG.
    private func extractFrames(from video: URL, to folder: URL, count: Int) async throws -> Int {
        let asset = AVURLAsset(url: video)
        let duration = try await asset.load(.duration).seconds
        guard duration > 0 else { return 0 }
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        gen.maximumSize = CGSize(width: 2048, height: 2048)
        let tol = CMTime(seconds: 0.05, preferredTimescale: 600)
        gen.requestedTimeToleranceBefore = tol
        gen.requestedTimeToleranceAfter = tol
        var saved = 0
        for i in 0..<count {
            let t = CMTime(seconds: duration * (Double(i) + 0.5) / Double(count), preferredTimescale: 600)
            guard let img = try? await gen.image(at: t).image else { continue }
            if let data = UIImage(cgImage: img).jpegData(compressionQuality: 0.9) {
                let name = String(format: "frame_%04d.jpg", i)
                if (try? data.write(to: folder.appendingPathComponent(name))) != nil { saved += 1 }
            }
            progress = Double(i + 1) / Double(count)
        }
        return saved
    }
}

/// Liest Eckpunkte und Dreiecke eines Modells (USDZ, OBJ …) über ModelIO.
nonisolated enum MeshFileIO {
    static func load(_ url: URL) -> ([SIMD3<Float>], [SIMD3<UInt32>]) {
        let asset = MDLAsset(url: url)
        var verts: [SIMD3<Float>] = []
        var faces: [SIMD3<UInt32>] = []
        let meshes = asset.childObjects(of: MDLMesh.self).compactMap { $0 as? MDLMesh }
        for mesh in meshes {
            guard let attr = mesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributePosition, as: .float3) else { continue }
            let base = UInt32(verts.count)
            for i in 0..<mesh.vertexCount {
                let p = attr.dataStart.advanced(by: i * attr.stride).assumingMemoryBound(to: Float.self)
                verts.append(SIMD3<Float>(p[0], p[1], p[2]))
            }
            for case let sub as MDLSubmesh in mesh.submeshes ?? [] where sub.geometryType == .triangles {
                let ib = sub.indexBuffer(asIndexType: .uInt32)
                let ptr = ib.map().bytes.assumingMemoryBound(to: UInt32.self)
                var k = 0
                while k + 2 < sub.indexCount {
                    faces.append(SIMD3<UInt32>(ptr[k] + base, ptr[k + 1] + base, ptr[k + 2] + base))
                    k += 3
                }
            }
        }
        return (verts, faces)
    }
}

struct VideoScanView: View {
    @StateObject private var model = VideoScanModel()
    @State private var item: PhotosPickerItem?
    @State private var result: BodyScanRecord?

    var body: some View {
        Form {
            Section {
                Label("Person steht still, Arme leicht vom Körper weg", systemImage: "figure.stand")
                Label("Einmal langsam komplett herum filmen (30–60 s), dann eine zweite Runde etwas höher", systemImage: "arrow.triangle.2.circlepath")
                Label("Gleichmäßiges Licht, ruhiger Hintergrund, eng anliegende Kleidung", systemImage: "sun.max")
            } header: {
                Text("So gelingt das Video")
            } footer: {
                Text(VideoScanModel.supported
                     ? "Die Berechnung läuft komplett auf dem iPhone und dauert je nach Video einige Minuten."
                     : "Hinweis: Dieses iPhone kann das 3D-Modell nicht selbst rechnen. Die Einzelbilder werden trotzdem gespeichert.")
            }

            Section {
                Stepper(value: $model.targetFrames, in: 30...200, step: 10) {
                    Text("Einzelbilder aus dem Video: \(model.targetFrames)")
                }
                PhotosPicker(selection: $item, matching: .videos) {
                    Label("Video auswählen und 3D-Modell erstellen", systemImage: "video.badge.plus")
                }
                .disabled(busy)
            } header: {
                Text("Video")
            } footer: {
                Text("Aufnehmen mit der Kamera-App, dann hier auswählen. Mehr Bilder = mehr Punkte und ein feineres Netz.")
            }

            if model.phase != .idle {
                Section("Fortschritt") {
                    switch model.phase {
                    case .extracting:
                        ProgressView("Einzelbilder werden gezogen …", value: model.progress)
                    case .reconstructing:
                        ProgressView("3D-Netz wird berechnet (\(model.frameCount) Bilder) …", value: model.progress)
                    case .saving:
                        ProgressView("Punktwolke und Netz werden gespeichert …")
                    case .done:
                        Label("Fertig", systemImage: "checkmark.circle.fill").foregroundStyle(.green)
                    case .failed(let text):
                        Text(text).foregroundStyle(.red).font(.footnote)
                    case .idle:
                        EmptyView()
                    }
                }
            }
        }
        .navigationTitle("3D aus Video")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: item) { _, newItem in
            guard let newItem else { return }
            Task {
                guard let movie = try? await newItem.loadTransferable(type: ScanMovie.self) else {
                    model.phase = .failed("Das Video konnte nicht geladen werden.")
                    return
                }
                item = nil
                result = await model.run(video: movie.url)
            }
        }
        .navigationDestination(item: $result) { r in ScanPreviewView(record: r) }
    }

    private var busy: Bool {
        [.extracting, .reconstructing, .saving].contains(model.phase)
    }
}
