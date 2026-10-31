import Foundation
import RealityKit
import UIKit
import simd

// Muskelkarte für die 3D-Figur: Statt harter Farbflächen werden die Muskeln wie echte Muskeln gezeichnet, mit ihrer
// anatomischen Form, dem Faserverlauf, hellen Sehnen und weichen Rändern. Grundlage ist FitScan_Muscles.bin, erzeugt
// mit tools/muskeln (python -m muskeln backen): je Texel der Figur die zwei stärksten Muskeln mit Gewicht,
// Faserhelligkeit und Sehnenanteil. Je Übung entsteht daraus eine Farbtextur (aktiv rot, passiv gelb), in drei
// Helligkeitsstufen für die Anstrengung. Die Farbe steckt ganz in der Grundfarbe: Eine Leuchttextur hat RealityKit
// als weißes Leuchten über die ganze Figur gezeigt (blasse, milchige Figur).
// Die Figur (FitScan_Skin.usdz) trägt dazu Texturkoordinaten; die Karte liegt oben in der Textur und gespiegelt
// darunter, so passt sie unabhängig davon, ob v von oben oder von unten gezählt wird.

enum MuscleAtlas {
    private struct Atlas {
        let n: Int
        let texels: [UInt8]
    }

    /// Helligkeitsstufen der aktiven Muskeln (Anstrengung der Bewegung)
    static let glowSteps = 3

    private static let atlas: Atlas? = load()
    private static var cache: [String: [TextureResource]] = [:]
    private static var cacheOrder: [String] = []

    /// true, wenn die Muskelkarte geladen werden konnte
    static var available: Bool { atlas != nil }

    private static func load() -> Atlas? {
        guard let url = Bundle.main.url(forResource: "FitScan_Muscles", withExtension: "bin"),
              let d = try? Data(contentsOf: url), d.count > 16, d.prefix(4) == Data("BFMK".utf8) else {
            print("FitScan: Muskelkarte fehlt")
            return nil
        }
        func u32(_ o: Int) -> Int { Int(d[o]) | Int(d[o + 1]) << 8 | Int(d[o + 2]) << 16 | Int(d[o + 3]) << 24 }
        let n = u32(8), length = u32(12)
        guard u32(4) == 1, n > 0, length == n * n * 8,
              let raw = try? (d.subdata(in: 16..<d.count) as NSData).decompressed(using: .zlib) as Data,
              raw.count == length else {
            print("FitScan: Muskelkarte unlesbar")
            return nil
        }
        return Atlas(n: n, texels: [UInt8](raw))
    }

    /// Farbtextur für die Übung in der Stufe `level` (0 … glowSteps-1), falls schon berechnet.
    static func texture(primary: [Muscle], secondary: [Muscle], neutral: UIColor, level: Int) -> TextureResource? {
        let step = max(0, min(glowSteps - 1, level))
        return cache[key(primary, secondary, neutral)]?[step]
    }

    /// Berechnet die Texturen der Übung im Hintergrund (sonst stockt die Animation, im Debug-Build sekundenlang)
    /// und ruft `ready` auf dem Hauptthread, sobald sie da sind. Ohne Muskelkarte passiert nichts.
    static func prepare(primary: [Muscle], secondary: [Muscle], neutral: UIColor, ready: @escaping () -> Void) {
        guard let atlas else { return }
        let k = key(primary, secondary, neutral)
        if cache[k] != nil { ready(); return }
        waiting[k, default: []].append(ready)
        guard waiting[k]?.count == 1 else { return }
        // Rolle je Muskel-Kennung: 0 Haut, 1 passiv, 2 aktiv
        var role = [UInt8](repeating: 0, count: 256)
        for m in secondary { role[MuscleSegmenter.materialIndex(of: m)] = 1 }
        for m in primary { role[MuscleSegmenter.materialIndex(of: m)] = 2 }
        let skin = rgb(neutral), passive = rgb(MuscleHighlight.passive), active = rgb(MuscleHighlight.active)
        let n = atlas.n, texels = atlas.texels, roles = role, steps = glowSteps
        Task.detached(priority: .userInitiated) {
            let images = (0..<steps).map { step in
                composePixels(n: n, texels: texels, role: roles, skin: skin, passive: passive, active: active,
                              glow: Float(step) / Float(max(steps - 1, 1)))
            }
            await MainActor.run { finish(k, images: images, n: n) }
        }
    }

    private static var waiting: [String: [() -> Void]] = [:]

    private static func key(_ primary: [Muscle], _ secondary: [Muscle], _ neutral: UIColor) -> String {
        primary.map(\.rawValue).joined(separator: ",") + "|" + secondary.map(\.rawValue).joined(separator: ",")
            + "|\(neutral.hashValue)"
    }

    private static func finish(_ k: String, images: [[UInt8]], n: Int) {
        var list: [TextureResource] = []
        for var px in images {
            guard let t = texture(&px, width: n, height: 2 * n) else { break }
            list.append(t)
        }
        if list.count == glowSteps {
            cache[k] = list
            cacheOrder.append(k)
            // mehrere Ansichten (Profil, Analyse, Übung) gleichzeitig: bei zu kleinem Speicher verdrängten sie sich
            // gegenseitig und die Farben fielen bei jedem Stufenwechsel auf Hautfarbe zurück
            if cacheOrder.count > 8 { cache[cacheOrder.removeFirst()] = nil }
        }
        let calls = waiting.removeValue(forKey: k) ?? []
        if list.count == glowSteps { calls.forEach { $0() } }
    }

    private static func rgb(_ c: UIColor) -> SIMD3<Float> {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        c.getRed(&r, green: &g, blue: &b, alpha: &a)
        return SIMD3(Float(r), Float(g), Float(b))
    }

    /// Muskelgewebe: kräftige Grundfarbe, dunklere Rillen, hellere Faserbündel, zur Sehne hin blass
    /// (wie tools/muskeln/vorschau.py)
    nonisolated private static func tissue(_ c: SIMD3<Float>, fiber f: Float, tendon s: Float) -> SIMD3<Float> {
        let dark = c * 0.62
        let light = c + (SIMD3<Float>(repeating: 1) - c) * 0.12
        let m = dark + (light - dark) * f
        let pale = c + (SIMD3<Float>(0.97, 0.93, 0.88) - c) * 0.6
        return m + (pale - m) * s
    }

    /// RGBA-Bild (Breite n, Höhe 2n: Karte oben, gespiegelt darunter). Läuft im Hintergrund.
    nonisolated private static func composePixels(n: Int, texels: [UInt8], role: [UInt8], skin: SIMD3<Float>,
                                                  passive: SIMD3<Float>, active: SIMD3<Float>, glow: Float) -> [UInt8] {
        // Farbe je Rolle, Faser- und Sehnenwert vorab als Tabelle (256 × 256), das hält die Schleife schlank.
        // Bei Anstrengung werden aktive Muskeln heller und leuchtender, passive etwas.
        var lut = [Float](repeating: 0, count: 3 * 65536 * 3)
        let colors = [skin, passive, active]
        // Ziel bleibt kräftig rot bzw. gelb: ein blasses Lachsrot verschwamm oben im Curl mit der Hautfarbe
        let hot = [skin, SIMD3<Float>(1.0, 0.88, 0.25), SIMD3<Float>(1.0, 0.22, 0.14)]
        let heat: [Float] = [0, 0.25 * glow, 0.45 * glow]
        for r in 1...2 {
            for fi in 0..<256 {
                for si in 0..<256 {
                    let f = Float(fi) / 255, s = Float(si) / 255
                    var m = tissue(colors[r], fiber: f, tendon: s)
                    m += (hot[r] - m) * (heat[r] * (0.4 + 0.6 * f) * (1 - s))
                    let o = ((r * 256 + fi) * 256 + si) * 3
                    lut[o] = m.x; lut[o + 1] = m.y; lut[o + 2] = m.z
                }
            }
        }
        var px = [UInt8](repeating: 255, count: n * n * 8)
        let sr = max(0, min(1, skin.x)) * 255, sg = max(0, min(1, skin.y)) * 255, sbl = max(0, min(1, skin.z)) * 255
        texels.withUnsafeBufferPointer { t in
            role.withUnsafeBufferPointer { rl in
                lut.withUnsafeBufferPointer { l in
                    px.withUnsafeMutableBufferPointer { b in
                        for y in 0..<n {
                            // Zeile oben und gespiegelt in der unteren Hälfte
                            let rowA = y * n * 4, rowB = (2 * n - 1 - y) * n * 4
                            for x in 0..<n {
                                let i = (y * n + x) * 8
                                var cr = sr / 255, cg = sg / 255, cb = sbl / 255
                                // erst der schwächere Platz (i + 4), darüber der stärkere (i)
                                for o in [i + 4, i] {
                                    let r = Int(rl[Int(t[o])])
                                    let w = Float(t[o + 1]) / 255
                                    if r == 0 || w == 0 { continue }
                                    let k = ((r * 256 + Int(t[o + 2])) * 256 + Int(t[o + 3])) * 3
                                    cr += (l[k] - cr) * w
                                    cg += (l[k + 1] - cg) * w
                                    cb += (l[k + 2] - cb) * w
                                }
                                let vr = UInt8(max(0, min(255, cr * 255)))
                                let vg = UInt8(max(0, min(255, cg * 255)))
                                let vb = UInt8(max(0, min(255, cb * 255)))
                                let pa = rowA + x * 4, pb = rowB + x * 4
                                b[pa] = vr; b[pa + 1] = vg; b[pa + 2] = vb
                                b[pb] = vr; b[pb + 1] = vg; b[pb + 2] = vb
                            }
                        }
                    }
                }
            }
        }
        return px
    }

    private static func texture(_ px: inout [UInt8], width: Int, height: Int) -> TextureResource? {
        let cg: CGImage? = px.withUnsafeMutableBytes { buf in
            CGContext(data: buf.baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4,
                      // sRGB: sonst liest RealityKit die Werte linear, und alles wirkt hell und blass
                      space: CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB(),
                      bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)?.makeImage()
        }
        guard let cg else { return nil }
        return try? TextureResource(image: cg, withName: nil, options: .init(semantic: .color))
    }
}
