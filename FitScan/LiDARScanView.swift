import ARKit
import Combine
import RealityKit
import SwiftUI
import simd

// Live-Körperscan mit LiDAR: Aus jedem Tiefenbild werden so viele Punkte wie möglich gesammelt (farbige Punktwolke,
// Voxel-Raster von 4 mm gegen doppelte Punkte), gleichzeitig baut ARKit ein Dreiecksnetz der Oberfläche auf.
// Beim Stopp werden Punktwolke (.ply) und Netz (.obj) gespeichert und in der Vorschau übereinandergelegt.

/// Sammelt Punkte aus den LiDAR-Tiefenbildern auf einer eigenen Warteschlange.
nonisolated final class PointAccumulator: @unchecked Sendable {
    private let queue = DispatchQueue(label: "bfc.pointcloud", qos: .userInitiated)
    private let lock = NSLock()
    private var voxels = Set<SIMD3<Int32>>()
    private var points: [SIMD3<Float>] = []
    private var colors: [SIMD3<UInt8>] = []
    private var busy = false
    private var center: SIMD3<Float>?

    /// Kantenlänge des Rasters: pro Würfel bleibt ein Punkt (kleiner = mehr Punkte)
    let voxelSize: Float = 0.004
    let maxPoints = 4_000_000
    /// Nur Punkte in diesem waagrechten Radius um die anvisierte Person behalten (nil = alles)
    var cropRadius: Float? = 1.0

    var count: Int { lock.withLock { points.count } }
    var focus: SIMD3<Float>? { lock.withLock { center } }

    func reset() {
        queue.sync {
            voxels.removeAll(keepingCapacity: true)
            lock.withLock { points.removeAll(); colors.removeAll(); center = nil; busy = false }
        }
    }

    func snapshot() -> (points: [SIMD3<Float>], colors: [SIMD3<UInt8>]) {
        queue.sync { lock.withLock { (points, colors) } }
    }

    /// Verarbeitet ein Tiefenbild. Ist die vorige Verarbeitung noch nicht fertig, wird das Bild übersprungen.
    func ingest(depth: CVPixelBuffer, confidence: CVPixelBuffer?, image: CVPixelBuffer,
                intrinsics: simd_float3x3, imageSize: CGSize, camera: simd_float4x4) {
        let skip: Bool = lock.withLock {
            if busy || points.count >= maxPoints { return true }
            busy = true
            return false
        }
        if skip { return }
        queue.async { [self] in
            defer { lock.withLock { busy = false } }
            process(depth: depth, confidence: confidence, image: image, intrinsics: intrinsics, imageSize: imageSize, camera: camera)
        }
    }

    private func process(depth: CVPixelBuffer, confidence: CVPixelBuffer?, image: CVPixelBuffer,
                         intrinsics: simd_float3x3, imageSize: CGSize, camera: simd_float4x4) {
        CVPixelBufferLockBaseAddress(depth, .readOnly)
        CVPixelBufferLockBaseAddress(image, .readOnly)
        if let confidence { CVPixelBufferLockBaseAddress(confidence, .readOnly) }
        defer {
            CVPixelBufferUnlockBaseAddress(depth, .readOnly)
            CVPixelBufferUnlockBaseAddress(image, .readOnly)
            if let confidence { CVPixelBufferUnlockBaseAddress(confidence, .readOnly) }
        }
        let w = CVPixelBufferGetWidth(depth), h = CVPixelBufferGetHeight(depth)
        guard w > 0, h > 0, let dBase = CVPixelBufferGetBaseAddress(depth) else { return }
        let dRow = CVPixelBufferGetBytesPerRow(depth)
        let cBase = confidence.flatMap { CVPixelBufferGetBaseAddress($0) }
        let cRow = confidence.map { CVPixelBufferGetBytesPerRow($0) } ?? 0

        // Kamerabild (YCbCr 4:2:0, zwei Ebenen) für die Punktfarbe
        let hasImage = CVPixelBufferGetPlaneCount(image) >= 2
        let yBase = hasImage ? CVPixelBufferGetBaseAddressOfPlane(image, 0) : nil
        let uvBase = hasImage ? CVPixelBufferGetBaseAddressOfPlane(image, 1) : nil
        let yRow = hasImage ? CVPixelBufferGetBytesPerRowOfPlane(image, 0) : 0
        let uvRow = hasImage ? CVPixelBufferGetBytesPerRowOfPlane(image, 1) : 0
        let imgW = hasImage ? CVPixelBufferGetWidthOfPlane(image, 0) : 0
        let imgH = hasImage ? CVPixelBufferGetHeightOfPlane(image, 0) : 0

        // Kameramatrix auf die Auflösung des Tiefenbilds umrechnen
        let sx = Float(w) / Float(imageSize.width), sy = Float(h) / Float(imageSize.height)
        let fx = intrinsics[0][0] * sx, fy = intrinsics[1][1] * sy
        let cx = intrinsics[2][0] * sx, cy = intrinsics[2][1] * sy

        func world(_ u: Int, _ v: Int, _ d: Float) -> SIMD3<Float> {
            let xc = (Float(u) + 0.5 - cx) * d / fx
            let yc = (Float(v) + 0.5 - cy) * d / fy
            let p = camera * SIMD4<Float>(xc, -yc, -d, 1)
            return SIMD3<Float>(p.x, p.y, p.z)
        }
        func depthAt(_ u: Int, _ v: Int) -> Float {
            dBase.advanced(by: v * dRow).assumingMemoryBound(to: Float32.self)[u]
        }

        // Beim ersten Bild: Punkt in der Bildmitte = Person, um die herum gesammelt wird
        let focusPoint: SIMD3<Float>? = lock.withLock { center }
        var c = focusPoint
        if c == nil {
            let d = depthAt(w / 2, h / 2)
            guard d > 0.2, d < 5 else { return }
            c = world(w / 2, h / 2, d)
            lock.withLock { center = c }
        }

        var newPts: [SIMD3<Float>] = []
        var newCols: [SIMD3<UInt8>] = []
        newPts.reserveCapacity(w * h / 2)
        newCols.reserveCapacity(w * h / 2)
        for v in 0..<h {
            for u in 0..<w {
                let d = depthAt(u, v)
                guard d > 0.15, d < 4.5, d.isFinite else { continue }
                if let cBase {
                    // ARConfidenceLevel: 0 niedrig, 1 mittel, 2 hoch – niedrige Werte (Kanten, Rauschen) verwerfen
                    let conf = cBase.advanced(by: v * cRow).assumingMemoryBound(to: UInt8.self)[u]
                    if conf < 1 { continue }
                }
                let p = world(u, v, d)
                if let r = cropRadius, let c {
                    let dx = p.x - c.x, dz = p.z - c.z
                    if dx * dx + dz * dz > r * r { continue }
                }
                let key = SIMD3<Int32>(Int32((p.x / voxelSize).rounded(.down)),
                                       Int32((p.y / voxelSize).rounded(.down)),
                                       Int32((p.z / voxelSize).rounded(.down)))
                guard voxels.insert(key).inserted else { continue }
                newPts.append(p)
                if let yBase, let uvBase, imgW > 0, imgH > 0 {
                    let iu = min(imgW - 1, u * imgW / w), iv = min(imgH - 1, v * imgH / h)
                    let yy = Float(yBase.advanced(by: iv * yRow).assumingMemoryBound(to: UInt8.self)[iu])
                    let uv = uvBase.advanced(by: (iv / 2) * uvRow).assumingMemoryBound(to: UInt8.self)
                    let cb = Float(uv[(iu / 2) * 2]) - 128, cr = Float(uv[(iu / 2) * 2 + 1]) - 128
                    let r = yy + 1.402 * cr, g = yy - 0.344 * cb - 0.714 * cr, b = yy + 1.772 * cb
                    newCols.append(SIMD3<UInt8>(UInt8(max(0, min(255, r))), UInt8(max(0, min(255, g))), UInt8(max(0, min(255, b)))))
                } else {
                    newCols.append(SIMD3<UInt8>(200, 200, 200))
                }
            }
        }
        guard !newPts.isEmpty else { return }
        lock.withLock {
            points.append(contentsOf: newPts)
            colors.append(contentsOf: newCols)
        }
    }
}

/// Nimmt die Kamerabilder von ARKit entgegen und reicht die Tiefendaten weiter.
nonisolated final class ScanFrameDelegate: NSObject, ARSessionDelegate, @unchecked Sendable {
    let accumulator: PointAccumulator
    var collecting = false

    init(accumulator: PointAccumulator) { self.accumulator = accumulator }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard collecting, let depth = frame.smoothedSceneDepth ?? frame.sceneDepth else { return }
        guard case .normal = frame.camera.trackingState else { return }
        accumulator.ingest(depth: depth.depthMap, confidence: depth.confidenceMap, image: frame.capturedImage,
                           intrinsics: frame.camera.intrinsics, imageSize: frame.camera.imageResolution,
                           camera: frame.camera.transform)
    }
}

@MainActor
final class LiDARScanModel: ObservableObject {
    @Published var isRunning = false
    @Published var pointCount = 0
    @Published var meshFaces = 0
    @Published var saving = false
    @Published var errorText: String?
    @Published var onlyPerson = true { didSet { accumulator.cropRadius = onlyPerson ? cropRadius : nil } }
    @Published var cropRadius: Float = 1.0 { didSet { if onlyPerson { accumulator.cropRadius = cropRadius } } }

    let accumulator = PointAccumulator()
    lazy var delegate = ScanFrameDelegate(accumulator: accumulator)
    weak var session: ARSession?

    static var supported: Bool {
        ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth)
    }

    func start() {
        guard Self.supported else {
            errorText = "Dieses Gerät hat keinen LiDAR-Scanner. Nutze „Aus Video erstellen“."
            return
        }
        let config = ARWorldTrackingConfiguration()
        config.frameSemantics.insert(.sceneDepth)
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.smoothedSceneDepth) {
            config.frameSemantics.insert(.smoothedSceneDepth)
        }
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        accumulator.reset()
        accumulator.cropRadius = onlyPerson ? cropRadius : nil
        session?.delegate = delegate
        delegate.collecting = true
        session?.run(config, options: [.resetTracking, .removeExistingAnchors, .resetSceneReconstruction])
        pointCount = 0
        meshFaces = 0
        errorText = nil
        isRunning = true
    }

    func poll() {
        guard isRunning else { return }
        pointCount = accumulator.count
        meshFaces = session?.currentFrame?.anchors.compactMap { $0 as? ARMeshAnchor }.reduce(0) { $0 + $1.geometry.faces.count } ?? 0
    }

    /// Stoppt den Scan, schneidet Boden und Umgebung ab und speichert Punktwolke und Netz.
    func stopAndSave() async -> BodyScanRecord? {
        delegate.collecting = false
        let anchors = session?.currentFrame?.anchors.compactMap { $0 as? ARMeshAnchor } ?? []
        let (verts, faces) = Self.extractMesh(anchors)
        session?.pause()
        isRunning = false
        saving = true
        defer { saving = false }

        let store = BodyScanStore.shared
        let draft = BodyScanRecord(source: .lidar)
        let folder = store.folder(for: draft)
        let acc = accumulator
        let crop: Float? = onlyPerson ? cropRadius : nil
        let result: (BodyScanRecord, String?) = await Task.detached(priority: .userInitiated) {
            var r = draft
            var (pts, cols) = acc.snapshot()
            let focus = acc.focus
            // Boden entfernen: alles knapp über dem tiefsten Bereich
            let floorY = ScanCleanup.floorHeight(pts)
            if let floorY {
                var p2: [SIMD3<Float>] = [], c2: [SIMD3<UInt8>] = []
                p2.reserveCapacity(pts.count); c2.reserveCapacity(cols.count)
                for i in 0..<pts.count where pts[i].y > floorY + 0.015 {
                    p2.append(pts[i])
                    if i < cols.count { c2.append(cols[i]) }
                }
                pts = p2; cols = c2
            }
            let (mv, mf) = ScanCleanup.crop(vertices: verts, faces: faces, center: focus, radius: crop, floorY: floorY)
            do {
                if !pts.isEmpty {
                    try ScanFiles.writePLY(points: pts, colors: cols, to: folder.appendingPathComponent("points.ply"))
                    r.pointFile = "points.ply"
                    r.pointCount = pts.count
                }
                if !mf.isEmpty {
                    try ScanFiles.writeOBJ(vertices: mv, faces: mf, to: folder.appendingPathComponent("mesh.obj"))
                    r.meshFile = "mesh.obj"
                    r.vertexCount = mv.count
                    r.faceCount = mf.count
                }
            } catch {
                return (r, "Speichern fehlgeschlagen: \(error.localizedDescription)")
            }
            r.measurements = BodyMeasure.estimate(points: pts)
            return (r, nil)
        }.value
        let rec = result.0
        if let err = result.1 { errorText = err; return nil }
        guard rec.pointFile != nil || rec.meshFile != nil else {
            errorText = "Noch nichts erfasst. Langsamer um die Person herumgehen und Abstand 0,5–2 m halten."
            store.delete(rec)
            return nil
        }
        store.add(rec)
        return rec
    }

    /// Liest alle ARKit-Netzteile in Weltkoordinaten aus.
    static func extractMesh(_ anchors: [ARMeshAnchor]) -> ([SIMD3<Float>], [SIMD3<UInt32>]) {
        var verts: [SIMD3<Float>] = []
        var faces: [SIMD3<UInt32>] = []
        for anchor in anchors {
            let geo = anchor.geometry
            let base = UInt32(verts.count)
            let vb = geo.vertices
            for i in 0..<vb.count {
                let ptr = vb.buffer.contents().advanced(by: vb.offset + vb.stride * i).assumingMemoryBound(to: Float.self)
                let w = anchor.transform * SIMD4<Float>(ptr[0], ptr[1], ptr[2], 1)
                verts.append(SIMD3<Float>(w.x, w.y, w.z))
            }
            let fb = geo.faces
            guard fb.indexCountPerPrimitive == 3 else { continue }
            let raw = fb.buffer.contents()
            for i in 0..<fb.count {
                var idx = SIMD3<UInt32>(0, 0, 0)
                for j in 0..<3 {
                    let o = (i * 3 + j) * fb.bytesPerIndex
                    let v: UInt32 = fb.bytesPerIndex == 2 ? UInt32(raw.load(fromByteOffset: o, as: UInt16.self))
                                                          : raw.load(fromByteOffset: o, as: UInt32.self)
                    idx[j] = v + base
                }
                faces.append(idx)
            }
        }
        return (verts, faces)
    }
}

/// Aufräumen nach dem Scan: Boden finden, Umgebung abschneiden.
nonisolated enum ScanCleanup {
    /// Bodenhöhe = unteres Perzentil der Punkthöhen (nil bei zu wenigen Punkten)
    static func floorHeight(_ pts: [SIMD3<Float>]) -> Float? {
        guard pts.count > 500 else { return nil }
        let step = max(1, pts.count / 20000)
        var ys: [Float] = []
        var i = 0
        while i < pts.count { ys.append(pts[i].y); i += step }
        ys.sort()
        return ys[Int(Float(ys.count) * 0.01)]
    }

    /// Behält nur Dreiecke im Zylinder um die Person und oberhalb des Bodens; Ecken werden neu nummeriert.
    static func crop(vertices: [SIMD3<Float>], faces: [SIMD3<UInt32>], center: SIMD3<Float>?, radius: Float?,
                     floorY: Float?) -> ([SIMD3<Float>], [SIMD3<UInt32>]) {
        guard !faces.isEmpty else { return ([], []) }
        func keep(_ p: SIMD3<Float>) -> Bool {
            if let floorY, p.y < floorY + 0.015 { return false }
            if let center, let radius {
                let dx = p.x - center.x, dz = p.z - center.z
                if dx * dx + dz * dz > radius * radius { return false }
            }
            return true
        }
        var remap = [Int32](repeating: -1, count: vertices.count)
        var outV: [SIMD3<Float>] = []
        var outF: [SIMD3<UInt32>] = []
        for f in faces {
            let a = Int(f.x), b = Int(f.y), c = Int(f.z)
            guard a < vertices.count, b < vertices.count, c < vertices.count,
                  keep(vertices[a]), keep(vertices[b]), keep(vertices[c]) else { continue }
            var tri = SIMD3<UInt32>(0, 0, 0)
            for (k, i) in [a, b, c].enumerated() {
                if remap[i] < 0 { remap[i] = Int32(outV.count); outV.append(vertices[i]) }
                tri[k] = UInt32(remap[i])
            }
            outF.append(tri)
        }
        return (outV, outF)
    }
}

// MARK: - Ansicht

struct LiDARARView: UIViewRepresentable {
    let model: LiDARScanModel
    var showMesh: Bool

    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: .zero)
        view.automaticallyConfigureSession = false
        model.session = view.session
        return view
    }

    func updateUIView(_ view: ARView, context: Context) {
        // „Netz drüberlegen“: das von ARKit erzeugte Dreiecksnetz live über dem Kamerabild
        if showMesh { view.debugOptions.insert(.showSceneUnderstanding) } else { view.debugOptions.remove(.showSceneUnderstanding) }
    }
}

struct LiDARScanView: View {
    @StateObject private var model = LiDARScanModel()
    @State private var showMesh = true
    @State private var result: BodyScanRecord?
    private let tick = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack(alignment: .bottom) {
            LiDARARView(model: model, showMesh: showMesh)
                .ignoresSafeArea()

            VStack(spacing: 10) {
                if model.isRunning {
                    HStack(spacing: 16) {
                        Label("\(model.pointCount.formatted()) Punkte", systemImage: "circle.grid.3x3.fill")
                        Label("\(model.meshFaces.formatted()) Dreiecke", systemImage: "triangle")
                    }
                    .font(.footnote.monospacedDigit())
                } else if !model.saving {
                    Text("Person in die Bildmitte nehmen, Start drücken und langsam in 0,5–2 m Abstand einmal komplett herumgehen – oben und unten mitnehmen. Die Person steht still, Arme leicht vom Körper weg.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                    Toggle("Nur Person (Umgebung ausblenden)", isOn: $model.onlyPerson).font(.footnote)
                    if model.onlyPerson {
                        Stepper(value: $model.cropRadius, in: 0.5...2.0, step: 0.25) {
                            Text("Radius um die Person: \(String(format: "%.2f", model.cropRadius)) m").font(.footnote)
                        }
                    }
                }
                Toggle("Netz anzeigen", isOn: $showMesh).font(.footnote)
                if model.saving { ProgressView("Speichere Punktwolke und Netz …") }
                if let err = model.errorText {
                    Text(err).font(.footnote).foregroundStyle(.red)
                }
                Button {
                    if model.isRunning {
                        Task { result = await model.stopAndSave() }
                    } else {
                        model.start()
                    }
                } label: {
                    Label(model.isRunning ? "Stopp und speichern" : "Scan starten",
                          systemImage: model.isRunning ? "stop.circle" : "record.circle")
                }
                .buttonStyle(.borderedProminent)
                .tint(model.isRunning ? .red : .blue)
                .disabled(model.saving)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .padding()
        }
        .navigationTitle("LiDAR-Scan")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(tick) { _ in model.poll() }
        .onDisappear { model.session?.pause(); model.delegate.collecting = false }
        .navigationDestination(item: $result) { r in ScanPreviewView(record: r) }
    }
}
