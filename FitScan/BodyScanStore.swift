import Combine
import Foundation
import simd

// Gespeicherte 3D-Körperscans (Punktwolke, Netz, Modell) und die Schnittstelle zum 3D-Modellprojekt.
// Alles bleibt auf dem Gerät: Documents/BodyScans/<id>/ mit points.ply, mesh.obj, model.usdz und scan.json.

/// Woher ein Scan stammt
nonisolated enum BodyScanSource: String, Codable, CaseIterable, Hashable {
    case lidar = "LiDAR-Scan"
    case video = "Aus Video"
    case imported = "Importiert"
    case modelProject = "3D-Modellprojekt"

    var icon: String {
        switch self {
        case .lidar: return "dot.radiowaves.left.and.right"
        case .video: return "video"
        case .imported: return "square.and.arrow.down"
        case .modelProject: return "figure.stand"
        }
    }
}

/// Aus dem Scan gemessene Körpermaße (Zentimeter). Fehlt ein Wert, ließ er sich nicht sicher bestimmen.
nonisolated struct BodyMeasurements: Codable, Hashable {
    var heightCm: Double?
    var neckCm: Double?
    var chestCm: Double?
    var waistCm: Double?
    var hipCm: Double?
    var thighCm: Double?
}

nonisolated struct BodyScanRecord: Codable, Identifiable, Hashable {
    var id = UUID()
    var date = Date()
    var source: BodyScanSource
    var pointCount = 0
    var vertexCount = 0
    var faceCount = 0
    /// Dateinamen im Scan-Ordner (nil = nicht vorhanden)
    var pointFile: String?
    var meshFile: String?
    var modelFile: String?
    var measurements: BodyMeasurements?
    var note = ""
}

// MARK: - Platzhalter für das 3D-Modellprojekt

/// Schnittstelle zum separaten 3D-Modellprojekt (Avatar aus Maßen/Scan, Rig, Animationen).
/// Solange das Projekt nicht eingebunden ist, bleibt `BodyModelBridge.provider` leer und die App zeigt einen Platzhalter.
/// Zum Zusammenführen implementiert das Projekt dieses Protokoll und setzt beim App-Start
/// `BodyModelBridge.provider = MeinModellProjekt()`. Mehr ist auf App-Seite nicht nötig: Scan-Übersicht, Vorschau,
/// Teilen und Maße-Übernahme funktionieren dann automatisch auch für die erzeugten Modelle.
protocol BodyModelProvider {
    /// Anzeigename, z. B. „FitScan-Avatar“
    var name: String { get }
    /// Ob sich aus diesem Scan ein Modell erzeugen lässt (sonst blendet die Vorschau den Knopf aus).
    func canMakeModel(from scan: BodyScanRecord, folder: URL) -> Bool
    /// Erzeugt aus einem gespeicherten Scan (Punktwolke und/oder Netz) ein bewegliches Körpermodell (USDZ) und gibt die Datei zurück.
    func makeModel(from scan: BodyScanRecord, folder: URL) async throws -> URL
    /// Optional genauere Maße, als die App selbst aus der Punktwolke schätzt.
    func measurements(from scan: BodyScanRecord, folder: URL) async throws -> BodyMeasurements?
}

extension BodyModelProvider {
    func canMakeModel(from scan: BodyScanRecord, folder: URL) -> Bool { true }
}

enum BodyModelBridge {
    /// Hier hängt sich das 3D-Modellprojekt ein (nil = noch nicht verbunden). FitScan: siehe FitScanBridge.swift.
    static var provider: BodyModelProvider? = FitScanProvider()
}

// MARK: - Ablage

@MainActor
final class BodyScanStore: ObservableObject {
    static let shared = BodyScanStore()

    @Published private(set) var records: [BodyScanRecord] = []

    let root: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent("BodyScans", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    private var indexURL: URL { root.appendingPathComponent("index.json") }

    init() {
        if let d = try? Data(contentsOf: indexURL), let r = try? JSONDecoder().decode([BodyScanRecord].self, from: d) {
            records = r.sorted { $0.date > $1.date }
        }
    }

    func folder(for r: BodyScanRecord) -> URL {
        let f = root.appendingPathComponent(r.id.uuidString, isDirectory: true)
        try? FileManager.default.createDirectory(at: f, withIntermediateDirectories: true)
        return f
    }

    func url(_ file: String?, in r: BodyScanRecord) -> URL? {
        guard let file else { return nil }
        let u = folder(for: r).appendingPathComponent(file)
        return FileManager.default.fileExists(atPath: u.path) ? u : nil
    }

    func add(_ r: BodyScanRecord) {
        records.removeAll { $0.id == r.id }
        records.insert(r, at: 0)
        persist()
    }

    func update(_ r: BodyScanRecord) {
        guard let i = records.firstIndex(where: { $0.id == r.id }) else { return add(r) }
        records[i] = r
        persist()
    }

    func delete(_ r: BodyScanRecord) {
        try? FileManager.default.removeItem(at: root.appendingPathComponent(r.id.uuidString, isDirectory: true))
        records.removeAll { $0.id == r.id }
        persist()
    }

    private func persist() {
        if let d = try? JSONEncoder().encode(records) { try? d.write(to: indexURL, options: .atomic) }
    }
}

// MARK: - Dateiformate

nonisolated enum ScanFiles {
    /// Binäre PLY-Punktwolke mit Farbe (öffnet in Blender, MeshLab, CloudCompare)
    static func writePLY(points: [SIMD3<Float>], colors: [SIMD3<UInt8>], to url: URL) throws {
        let hasColor = colors.count == points.count
        var header = "ply\nformat binary_little_endian 1.0\ncomment Bodyformance Koerperscan\nelement vertex \(points.count)\n"
        header += "property float x\nproperty float y\nproperty float z\n"
        if hasColor { header += "property uchar red\nproperty uchar green\nproperty uchar blue\n" }
        header += "end_header\n"
        var data = Data(header.utf8)
        data.reserveCapacity(data.count + points.count * (hasColor ? 15 : 12))
        for i in 0..<points.count {
            var p = points[i]
            withUnsafeBytes(of: &p.x) { data.append(contentsOf: $0) }
            withUnsafeBytes(of: &p.y) { data.append(contentsOf: $0) }
            withUnsafeBytes(of: &p.z) { data.append(contentsOf: $0) }
            if hasColor { data.append(contentsOf: [colors[i].x, colors[i].y, colors[i].z]) }
        }
        try data.write(to: url, options: .atomic)
    }

    /// OBJ-Netz (Dreiecke, Indizes ab 0)
    static func writeOBJ(vertices: [SIMD3<Float>], faces: [SIMD3<UInt32>], to url: URL) throws {
        var out = "# Bodyformance Koerperscan\n"
        out.reserveCapacity(vertices.count * 36 + faces.count * 24)
        for v in vertices { out += "v \(v.x) \(v.y) \(v.z)\n" }
        for f in faces { out += "f \(f.x + 1) \(f.y + 1) \(f.z + 1)\n" }
        try out.write(to: url, atomically: true, encoding: .utf8)
    }

    /// Liest eine PLY-Punktwolke (binär, wie von writePLY geschrieben, oder ASCII) für die Vorschau.
    static func readPLY(_ url: URL, maxPoints: Int = 400_000) -> (points: [SIMD3<Float>], colors: [SIMD3<UInt8>]) {
        guard let data = try? Data(contentsOf: url),
              let headerEnd = data.range(of: Data("end_header\n".utf8)) else { return ([], []) }
        let header = String(decoding: data[..<headerEnd.lowerBound], as: UTF8.self)
        var count = 0
        for line in header.split(separator: "\n") where line.hasPrefix("element vertex") {
            count = Int(line.split(separator: " ").last ?? "") ?? 0
        }
        let hasColor = header.contains("property uchar red")
        let binary = header.contains("binary_little_endian")
        let body = data[headerEnd.upperBound...]
        var pts: [SIMD3<Float>] = [], cols: [SIMD3<UInt8>] = []
        let step = max(1, count / maxPoints)
        if binary {
            let stride = hasColor ? 15 : 12
            guard body.count >= count * stride else { return ([], []) }
            body.withUnsafeBytes { raw in
                var i = 0
                while i < count {
                    let o = i * stride
                    let x = raw.loadUnaligned(fromByteOffset: o, as: Float.self)
                    let y = raw.loadUnaligned(fromByteOffset: o + 4, as: Float.self)
                    let z = raw.loadUnaligned(fromByteOffset: o + 8, as: Float.self)
                    pts.append([x, y, z])
                    if hasColor { cols.append([raw[o + 12], raw[o + 13], raw[o + 14]]) }
                    i += step
                }
            }
        } else {
            let lines = String(decoding: body, as: UTF8.self).split(separator: "\n")
            var i = 0
            while i < min(count, lines.count) {
                let v = lines[i].split(separator: " ").compactMap { Float($0) }
                if v.count >= 3 {
                    pts.append([v[0], v[1], v[2]])
                    if hasColor && v.count >= 6 { cols.append([UInt8(clamping: Int(v[3])), UInt8(clamping: Int(v[4])), UInt8(clamping: Int(v[5]))]) }
                }
                i += step
            }
        }
        return (pts, cols.count == pts.count ? cols : [])
    }
}

// MARK: - Maße aus der Punktwolke

nonisolated enum BodyMeasure {
    /// Schätzt Körpermaße aus einer Punktwolke, in der eine Person aufrecht steht (y = oben).
    /// Umfänge: konvexe Hülle einer 2 cm dicken Scheibe auf typischer Höhe – bei Taille und Hals eher etwas zu groß,
    /// darum als Schätzung gekennzeichnet. Für genaue Werte nach wie vor Maßband.
    static func estimate(points: [SIMD3<Float>]) -> BodyMeasurements? {
        guard points.count > 2000 else { return nil }
        let ys = points.map(\.y).sorted()
        let floor = ys[Int(Double(ys.count) * 0.005)]
        let top = ys[Int(Double(ys.count) * 0.998)]
        let h = top - floor
        guard h > 1.0, h < 2.4 else { return nil }
        func girth(at rel: Float, keepCenter: Bool = true) -> Double? {
            let y = floor + h * rel
            var slice = points.filter { abs($0.y - y) < 0.01 }.map { SIMD2<Float>($0.x, $0.z) }
            guard slice.count > 40 else { return nil }
            if keepCenter {
                // Arme ausschließen: nur Punkte nahe der Körpermitte dieser Höhe
                let c = slice.reduce(SIMD2<Float>(0, 0), +) / Float(slice.count)
                slice = slice.filter { simd_distance($0, c) < 0.25 }
                guard slice.count > 30 else { return nil }
            }
            let p = hullPerimeter(slice)
            return p > 0.2 && p < 2.2 ? Double(p * 100) : nil
        }
        var m = BodyMeasurements()
        m.heightCm = Double(h * 100)
        m.neckCm = girth(at: 0.83)
        m.chestCm = girth(at: 0.72)
        m.waistCm = girth(at: 0.60)
        m.hipCm = girth(at: 0.52)
        m.thighCm = girth(at: 0.42, keepCenter: false).map { $0 / 2 }
        return m
    }

    /// Umfang der konvexen Hülle (Andrew-Monotone-Chain)
    static func hullPerimeter(_ pts: [SIMD2<Float>]) -> Float {
        let p = pts.sorted { $0.x == $1.x ? $0.y < $1.y : $0.x < $1.x }
        guard p.count >= 3 else { return 0 }
        func cross(_ o: SIMD2<Float>, _ a: SIMD2<Float>, _ b: SIMD2<Float>) -> Float {
            (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x)
        }
        var lower: [SIMD2<Float>] = [], upper: [SIMD2<Float>] = []
        for q in p {
            while lower.count >= 2 && cross(lower[lower.count - 2], lower[lower.count - 1], q) <= 0 { lower.removeLast() }
            lower.append(q)
        }
        for q in p.reversed() {
            while upper.count >= 2 && cross(upper[upper.count - 2], upper[upper.count - 1], q) <= 0 { upper.removeLast() }
            upper.append(q)
        }
        let hull = Array(lower.dropLast() + upper.dropLast())
        guard hull.count >= 3 else { return 0 }
        var per: Float = 0
        for i in 0..<hull.count { per += simd_distance(hull[i], hull[(i + 1) % hull.count]) }
        return per
    }
}
