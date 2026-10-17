import Foundation
import RealityKit
import UIKit
import simd

// Muskelkarte für die 3D-Figur: Statt harter Farbflächen werden die Muskeln wie echte Muskeln gezeichnet, mit ihrer
// anatomischen Form, dem Faserverlauf, hellen Sehnen und weichen Rändern. Grundlage ist FitScan_Muscles.bin, erzeugt
// mit tools/muskeln (python -m muskeln backen): je Texel der Figur die zwei stärksten Muskeln mit Gewicht,
// Faserhelligkeit und Sehnenanteil. Je Übung entsteht daraus eine Farb- und eine Leuchttextur (aktiv rot, passiv gelb).
// Die Figur (FitScan_Skin.usdz) trägt dazu Texturkoordinaten; die Karte liegt oben in der Textur und gespiegelt
// darunter, so passt sie unabhängig davon, ob v von oben oder von unten gezählt wird.

enum MuscleAtlas {
    struct Textures {
        let base: TextureResource
        let glow: TextureResource
    }

    private struct Atlas {
        let n: Int
        let texels: [UInt8]
    }

    private static let atlas: Atlas? = load()
    private static var cache: [String: Textures] = [:]
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

    /// Farb- und Leuchttextur für die Übung (zwischengespeichert). nil, wenn die Karte fehlt.
    static func textures(primary: [Muscle], secondary: [Muscle], neutral: UIColor) -> Textures? {
        guard let atlas else { return nil }
        let key = primary.map(\.rawValue).joined(separator: ",") + "|" + secondary.map(\.rawValue).joined(separator: ",")
            + "|\(neutral.hashValue)"
        if let t = cache[key] { return t }
        guard let t = compose(atlas, primary: primary, secondary: secondary, neutral: neutral) else { return nil }
        cache[key] = t
        cacheOrder.append(key)
        if cacheOrder.count > 6 { cache[cacheOrder.removeFirst()] = nil }
        return t
    }

    private static func rgb(_ c: UIColor) -> SIMD3<Float> {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        c.getRed(&r, green: &g, blue: &b, alpha: &a)
        return SIMD3(Float(r), Float(g), Float(b))
    }

    /// Muskelgewebe: dunkle Rillen, hellere Faserbündel, zur Sehne hin blass (wie tools/muskeln/vorschau.py)
    private static func tissue(_ c: SIMD3<Float>, fiber f: Float, tendon s: Float) -> SIMD3<Float> {
        let dark = c * 0.32
        let light = c + (SIMD3<Float>(repeating: 1) - c) * 0.28
        let m = dark + (light - dark) * f
        let pale = c + (SIMD3<Float>(0.97, 0.93, 0.88) - c) * 0.75
        return m + (pale - m) * s
    }

    private static func compose(_ atlas: Atlas, primary: [Muscle], secondary: [Muscle], neutral: UIColor) -> Textures? {
        let n = atlas.n
        // Rolle je Muskel-Kennung: 0 Haut, 1 passiv, 2 aktiv
        var role = [UInt8](repeating: 0, count: 256)
        for m in secondary { role[MuscleSegmenter.materialIndex(of: m)] = 1 }
        for m in primary { role[MuscleSegmenter.materialIndex(of: m)] = 2 }
        let skin = rgb(neutral)
        let colors = [skin, rgb(MuscleHighlight.passive), rgb(MuscleHighlight.active)]
        let lightOf: [Float] = [0, 0.4, 1]
        var base = [UInt8](repeating: 255, count: n * n * 8)
        var glow = [UInt8](repeating: 255, count: n * n * 8)
        let sb = simd_clamp(skin, .zero, SIMD3(repeating: 1)) * 255
        let skinBytes = (UInt8(sb.x), UInt8(sb.y), UInt8(sb.z))

        atlas.texels.withUnsafeBufferPointer { t in
            base.withUnsafeMutableBufferPointer { b in
                glow.withUnsafeMutableBufferPointer { g in
                    for y in 0..<n {
                        // Zeile oben und gespiegelt in der unteren Hälfte
                        let rowA = y * n * 4, rowB = (2 * n - 1 - y) * n * 4
                        for x in 0..<n {
                            let i = (y * n + x) * 8
                            let r2 = role[Int(t[i + 4])], r1 = role[Int(t[i])]
                            let pa = rowA + x * 4, pb = rowB + x * 4
                            if r1 == 0 && r2 == 0 {
                                b[pa] = skinBytes.0; b[pa + 1] = skinBytes.1; b[pa + 2] = skinBytes.2
                                b[pb] = skinBytes.0; b[pb + 1] = skinBytes.1; b[pb + 2] = skinBytes.2
                                g[pa] = 0; g[pa + 1] = 0; g[pa + 2] = 0
                                g[pb] = 0; g[pb + 1] = 0; g[pb + 2] = 0
                                continue
                            }
                            var c = skin
                            var e = SIMD3<Float>(repeating: 0)
                            func paint(_ o: Int, _ r: UInt8) {
                                let w = Float(t[o + 1]) / 255
                                guard r != 0, w > 0 else { return }
                                let f = Float(t[o + 2]) / 255, s = Float(t[o + 3]) / 255
                                let col = colors[Int(r)]
                                c += (tissue(col, fiber: f, tendon: s) - c) * w
                                let light = lightOf[Int(r)] * (0.2 + 0.8 * f) * (1 - 0.9 * s)
                                e += (col * light - e) * w
                            }
                            // erst der schwächere Platz, darüber der stärkere
                            paint(i + 4, r2)
                            paint(i, r1)
                            let cb = simd_clamp(c, .zero, SIMD3(repeating: 1)) * 255
                            let eb = simd_clamp(e, .zero, SIMD3(repeating: 1)) * 255
                            b[pa] = UInt8(cb.x); b[pa + 1] = UInt8(cb.y); b[pa + 2] = UInt8(cb.z)
                            b[pb] = UInt8(cb.x); b[pb + 1] = UInt8(cb.y); b[pb + 2] = UInt8(cb.z)
                            g[pa] = UInt8(eb.x); g[pa + 1] = UInt8(eb.y); g[pa + 2] = UInt8(eb.z)
                            g[pb] = UInt8(eb.x); g[pb + 1] = UInt8(eb.y); g[pb + 2] = UInt8(eb.z)
                        }
                    }
                }
            }
        }
        guard let bt = texture(&base, width: n, height: 2 * n), let gt = texture(&glow, width: n, height: 2 * n) else { return nil }
        return Textures(base: bt, glow: gt)
    }

    private static func texture(_ px: inout [UInt8], width: Int, height: Int) -> TextureResource? {
        let cg: CGImage? = px.withUnsafeMutableBytes { buf in
            CGContext(data: buf.baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4,
                      // sRGB: sonst liest RealityKit die Werte linear, und alles wirkt hell und blass
                      space: CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB(),
                      bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)?.makeImage()
        }
        guard let cg else { return nil }
        return try? TextureResource.generate(from: cg, withName: nil, options: .init(semantic: .color))
    }
}
