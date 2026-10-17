import Foundation
import SceneKit

// Anschluss an das 3D-Modellprojekt FitScan (läuft am PC: Video + Maße → Anny-Körpermodell).
// Der PC rechnet, die App übernimmt: Aus dem Scanordner von FitScan (daten/personen/<name>/scans/<datum>/)
// werden koerper.obj (mit koerper.mtl, koerper_haut.jpg, koerper_augen.jpg) oder ein USDZ sowie scan.json
// per AirDrop oder „Dateien“ importiert. Die App zeigt das Modell als Avatar und übernimmt die genauen Maße.

nonisolated enum FitScanFiles {
    /// Dateiendungen, die zu einem FitScan-Scanordner gehören
    static let extensions: Set<String> = ["obj", "mtl", "jpg", "jpeg", "png", "json", "usdz"]

    /// Erkennt eine FitScan-Auswahl: scan.json oder Dateien, die mit „koerper“ beginnen.
    static func isFitScanSelection(_ urls: [URL]) -> Bool {
        urls.contains { $0.lastPathComponent.lowercased() == "scan.json" || $0.lastPathComponent.lowercased().hasPrefix("koerper") }
    }

    /// Modelldatei im Ordner: zuerst ein USDZ, sonst das OBJ von FitScan.
    static func modelFile(in folder: URL) -> URL? {
        let files = (try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)) ?? []
        if let usdz = files.first(where: { $0.pathExtension.lowercased() == "usdz" }) { return usdz }
        return files.first { $0.lastPathComponent.lowercased() == "koerper.obj" }
            ?? files.first { $0.pathExtension.lowercased() == "obj" && $0.lastPathComponent != "mesh.obj" }
    }

    /// Maße aus FitScans scan.json („measures“ = am Modell gemessen, sonst „inputs“ = eingegeben). Zentimeter.
    static func measurements(in folder: URL) -> BodyMeasurements? {
        let url = folder.appendingPathComponent("scan.json")
        guard let data = try? Data(contentsOf: url),
              let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else { return nil }
        let measures = json["measures"] as? [String: Any] ?? [:]
        let inputs = json["inputs"] as? [String: Any] ?? [:]
        func value(_ key: String) -> Double? {
            for source in [measures, inputs] {
                if let n = source[key] as? NSNumber, n.doubleValue > 0 { return n.doubleValue }
            }
            return nil
        }
        let m = BodyMeasurements(heightCm: value("height"), neckCm: value("neck"), chestCm: value("chest"),
                                 waistCm: value("waist"), hipCm: value("hips"), thighCm: value("thigh"))
        return [m.heightCm, m.neckCm, m.chestCm, m.waistCm, m.hipCm, m.thighCm].contains { $0 != nil } ? m : nil
    }
}

enum FitScanError: LocalizedError {
    case noModel
    case unreadable

    var errorDescription: String? {
        switch self {
        case .noModel:
            return "In diesem Scan liegt kein FitScan-Modell. Werte das Video am PC mit FitScan aus und importiere koerper.obj (mit .mtl und Hautbildern) und scan.json."
        case .unreadable:
            return "Das FitScan-Modell ließ sich nicht öffnen."
        }
    }
}

/// Liefert den Avatar aus einem importierten FitScan-Scan.
struct FitScanProvider: BodyModelProvider {
    var name: String { "FitScan" }

    func canMakeModel(from scan: BodyScanRecord, folder: URL) -> Bool {
        scan.source == .modelProject && FitScanFiles.modelFile(in: folder) != nil
    }

    func makeModel(from scan: BodyScanRecord, folder: URL) async throws -> URL {
        guard let src = FitScanFiles.modelFile(in: folder) else { throw FitScanError.noModel }
        if src.pathExtension.lowercased() == "usdz" { return src }
        // OBJ samt Material und Hautbild als USDZ verpacken, damit es sich teilen und in AR öffnen lässt
        let dst = folder.appendingPathComponent("avatar.usdz")
        if FileManager.default.fileExists(atPath: dst.path) { return dst }
        guard let scene = try? SCNScene(url: src, options: [.checkConsistency: false]) else { throw FitScanError.unreadable }
        try? FileManager.default.removeItem(at: dst)
        if scene.write(to: dst, options: nil, delegate: nil, progressHandler: nil),
           FileManager.default.fileExists(atPath: dst.path) {
            return dst
        }
        // Ohne USDZ-Export bleibt das OBJ das Modell (die Vorschau öffnet es ebenso)
        return src
    }

    func measurements(from scan: BodyScanRecord, folder: URL) async throws -> BodyMeasurements? {
        FitScanFiles.measurements(in: folder)
    }
}
