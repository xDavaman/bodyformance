import RealityKit
import UIKit
import simd

// Muskelfarben auf dem 3D-Körper: aktiv (Hauptmuskeln) rot, passiv (Hilfsmuskeln) gelb.
// Das Körpernetz (FitScan_Skin.usdz) ist ein durchgehendes Netz ohne Muskel-Teilnetze. Deshalb wird es beim ersten Laden
// einmal in Bereiche je Muskelgruppe zerlegt: jedes Dreieck bekommt anhand seiner Lage in der Grundhaltung (Ruhepose)
// eine Muskelgruppe und damit einen eigenen Materialplatz. Skelett, Gewichte und Animationen bleiben unverändert,
// die Teile teilen sich dieselben Vertex-Puffer. Wird die Figur später ersetzt (3D-Modellprojekt), passen nur die
// Gelenkpositionen unten an – oder das neue Modell bringt eigene Muskel-Teilnetze mit.

enum MuscleHighlight {
    static let active = UIColor(red: 0.90, green: 0.12, blue: 0.10, alpha: 1)
    static let passive = UIColor(red: 1.00, green: 0.80, blue: 0.10, alpha: 1)
}

enum MuscleSegmenter {
    /// Materialplatz 0 = Haut/neutral, danach je Muskelgruppe in dieser Reihenfolge.
    static let order: [Muscle] = Muscle.allCases

    static func materialIndex(of m: Muscle) -> Int { (order.firstIndex(of: m) ?? -1) + 1 }

    /// Zerlegtes Netz, einmal pro App-Start berechnet und von allen 3D-Ansichten geteilt.
    private static var cache: [String: MeshResource] = [:]

    /// Gibt eine Kopie des Netzes zurück, deren Teile nach Muskelgruppen getrennt sind (nil, wenn es nicht klappt).
    /// `key` benennt das Modell (z. B. "FitScan_Skin"), damit es nur einmal zerlegt wird.
    static func segmented(_ mesh: MeshResource, key: String) -> MeshResource? {
        if let m = cache[key] { return m }
        var contents = mesh.contents
        var models: [MeshResource.Model] = []
        var changed = false
        for model in contents.models {
            var parts: [MeshResource.Part] = []
            for part in model.parts {
                guard let indices = part.triangleIndices?.elements, indices.count >= 3 else {
                    parts.append(part)
                    continue
                }
                let positions = part.positions.elements
                let normals = part.normals?.elements
                var labels = [Int](repeating: 0, count: positions.count)
                for i in 0..<positions.count {
                    let n = (normals != nil && i < normals!.count) ? normals![i] : SIMD3<Float>(0, 0, 0)
                    labels[i] = label(positions[i], normal: n)
                }
                var buckets = [[UInt32]](repeating: [], count: order.count + 1)
                var t = 0
                while t + 2 < indices.count {
                    let a = labels[Int(indices[t])], b = labels[Int(indices[t + 1])], c = labels[Int(indices[t + 2])]
                    let l = (a == b || a == c) ? a : (b == c ? b : a)
                    buckets[l].append(indices[t]); buckets[l].append(indices[t + 1]); buckets[l].append(indices[t + 2])
                    t += 3
                }
                for (k, tris) in buckets.enumerated() where !tris.isEmpty {
                    var p = part
                    p.id = "\(part.id)-m\(k)"
                    p.materialIndex = k
                    p.triangleIndices = MeshBuffer(tris)
                    parts.append(p)
                }
                changed = true
            }
            models.append(MeshResource.Model(id: model.id, parts: parts))
        }
        guard changed else { return nil }
        contents.models = MeshModelCollection(models)
        guard let out = try? MeshResource.generate(from: contents) else { return nil }
        cache[key] = out
        return out
    }

    // MARK: Zuordnung Punkt → Muskelgruppe

    /// Gelenkpositionen der Ruhepose von FitScan_Skin.usdz (Meter, Körper schaut nach +z, links = +x).
    private static let joint: [String: SIMD3<Float>] = [
        "uaL": [0.20, 1.40, 0.00], "faL": [0.41, 1.21, 0.06], "haL": [0.53, 1.09, 0.27], "midL": [0.596, 0.992, 0.356],
        "thL": [0.10, 0.90, 0.02], "shL": [0.16, 0.48, 0.00], "ftL": [0.20, 0.08, -0.01], "toeL": [0.205, 0.03, 0.10],
        "head": [0, 1.63, 0.03]
    ]

    private static func j(_ name: String, _ left: Bool) -> SIMD3<Float> {
        if name == "head" { return joint["head"]! }
        var p = joint[name + "L"]!
        if !left { p.x = -p.x }
        return p
    }

    private struct Capsule { let name: String; let a: SIMD3<Float>; let b: SIMD3<Float>; let r: Float }

    private static func distance(_ p: SIMD3<Float>, _ c: Capsule) -> Float {
        let ab = c.b - c.a
        let t = simd_clamp(simd_dot(p - c.a, ab) / max(simd_dot(ab, ab), 1e-6), 0, 1)
        return simd_length(p - (c.a + ab * t)) - c.r
    }

    /// Anteil der Strecke a→b, auf dem der Punkt liegt (0 = bei a, 1 = bei b)
    private static func along(_ p: SIMD3<Float>, _ a: SIMD3<Float>, _ b: SIMD3<Float>) -> Float {
        let ab = b - a
        return simd_dot(p - a, ab) / max(simd_dot(ab, ab), 1e-6)
    }

    /// Lage eines Punkts um eine Knochenachse: t entlang, f = nach vorn (+z), o = nach außen, m = zur Körpermitte
    private static func boneFrame(_ p: SIMD3<Float>, _ a: SIMD3<Float>, _ b: SIMD3<Float>, left: Bool) -> (t: Float, f: Float, o: Float, m: Float) {
        let axis = simd_normalize(b - a)
        let len = simd_length(b - a)
        let t = simd_dot(p - a, axis) / len
        let radial = p - a - axis * (t * len)
        let r = simd_length(radial) > 1e-6 ? simd_normalize(radial) : SIMD3<Float>(0, 0, 1)
        let fwdRaw = SIMD3<Float>(0, 0, 1) - axis * axis.z
        let outRaw = SIMD3<Float>(left ? 1 : -1, 0, 0) - axis * axis.x * (left ? 1 : -1)
        let fwd = simd_length(fwdRaw) > 1e-6 ? simd_normalize(fwdRaw) : SIMD3<Float>(0, 0, 1)
        let out = simd_length(outRaw) > 1e-6 ? simd_normalize(outRaw) : SIMD3<Float>(left ? 1 : -1, 0, 0)
        return (t, simd_dot(r, fwd), simd_dot(r, out), simd_dot(r, SIMD3<Float>(left ? -1 : 1, 0, 0)))
    }

    /// Materialplatz (0 = neutral) für einen Punkt der Ruhepose.
    static func label(_ p: SIMD3<Float>, normal n: SIMD3<Float>) -> Int {
        let left = p.x >= 0
        let caps: [Capsule] = [
            Capsule(name: "ua", a: j("ua", left), b: j("fa", left), r: 0.055),
            Capsule(name: "fa", a: j("fa", left), b: j("ha", left), r: 0.04),
            Capsule(name: "ha", a: j("ha", left), b: j("mid", left), r: 0.03),
            Capsule(name: "th", a: j("th", left), b: j("sh", left), r: 0.085),
            Capsule(name: "sh", a: j("sh", left), b: j("ft", left), r: 0.055),
            Capsule(name: "ft", a: j("ft", left), b: j("toe", left), r: 0.04),
            Capsule(name: "torso", a: [0, 0.95, 0], b: [0, 1.45, -0.02], r: 0.15),
            Capsule(name: "head", a: j("head", left), b: j("head", left) + SIMD3<Float>(0, 0.12, 0), r: 0.09)
        ]
        var base = caps.min { distance(p, $0) < distance(p, $1) }!.name
        if base == "head" && p.y < 1.6 { base = "torso" }
        if base == "ua" || base == "fa" || base == "ha" {
            base = along(p, j("ua", left), j("fa", left)) < 0.97 ? "ua" : (along(p, j("fa", left), j("ha", left)) < 1.0 ? "fa" : "ha")
        }
        if base == "th" || base == "sh" || base == "ft" {
            base = along(p, j("th", left), j("sh", left)) < 1.0 ? "th" : (along(p, j("sh", left), j("ft", left)) < 0.95 ? "sh" : "ft")
        }
        let m: Muscle?
        switch base {
        case "ha", "ft", "head": m = nil
        case "fa": m = .forearms
        case "ua":
            let b = boneFrame(p, j("ua", left), j("fa", left), left: left)
            if (b.t < 0.32 && b.o > -0.5) || b.t < 0.15 { m = .shoulders } else { m = b.f > 0.05 ? .biceps : .triceps }
        case "th":
            let b = boneFrame(p, j("th", left), j("sh", left), left: left)
            if b.t > 0.92 { m = nil }
            else if b.f < -0.25 && (b.t < 0.18 || p.y > 0.80) { m = .glutes }
            else if b.m > 0.55 && b.t < 0.7 { m = .adductors }
            else if b.f < -0.2 { m = .hamstrings }
            else if b.t < 0.12 && b.f > 0.3 && b.m > 0.1 { m = .hipFlexors }
            else { m = .quads }
        case "sh":
            let b = boneFrame(p, j("sh", left), j("ft", left), left: left)
            m = (b.t >= 0.08 && b.f < 0.1 && b.t < 0.62) ? .calves : nil
        default:
            m = torso(p, normal: n)
        }
        return m.map(materialIndex(of:)) ?? 0
    }

    private static func torso(_ p: SIMD3<Float>, normal n: SIMD3<Float>) -> Muscle? {
        let ax = abs(p.x), y = p.y, nz = n.z
        if y > 1.62 { return nil }
        if y > 1.47 {
            if nz > -0.2 {
                if ax < 0.075 && p.z < 0.1 && y < 1.56 { return .neck }
                return ax >= 0.075 && y < 1.56 ? .traps : nil
            }
            if ax < 0.16 && y < 1.58 { return .traps }
            return ax >= 0.16 ? .shoulders : nil
        }
        if ax > 0.165 && y > 1.30 { return .shoulders }
        if nz > 0.15 {
            if y > 1.22 { return ax < 0.2 ? .chest : .lats }
            if y > 0.95 { return .abs }
            if y > 0.84 && ax < 0.16 { return ax > 0.06 ? .hipFlexors : nil }
            return nil
        }
        if nz < -0.15 {
            if y > 1.40 { return .traps }
            if y > 1.22 { return ax < 0.085 ? .traps : .lats }
            if y > 1.06 { return ax > 0.05 ? .lats : .lowerBack }
            if y > 0.93 { return .lowerBack }
            return .glutes
        }
        if y > 1.12 { return .lats }
        if y > 0.93 { return .abs }
        return nz < 0 ? .glutes : nil
    }
}
