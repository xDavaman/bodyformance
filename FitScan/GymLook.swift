import Metal
import RealityKit
import UIKit
import simd

// Aussehen des Fitnessstudios: warmes, klassisches Gym mit Ziegelwand, Eichenholz, grüner Bilderwand, Fenstern,
// Pendelleuchten, Pflanzen und gerahmten Bildern. Alle Texturen werden einmal im Code gezeichnet (keine Bilddateien)
// und zwischen allen 3D-Ansichten geteilt. Kacheltexturen entsprechen 1 m × 1 m und werden über die Fläche wiederholt.
//
// Raum: 8 m × 8 m, 3,4 m hoch, Körper bei (0,0,0). Rückwand −z (Ziegel, Schriftzug), Vorderwand +z (Fenster,
// Tafel), rechte Wand +x (grün, Bilder), linke Wand −x (Spiegel).

enum GymLook {
    static let oak = UIColor(red: 0.66, green: 0.48, blue: 0.30, alpha: 1)
    static let walnut = UIColor(red: 0.27, green: 0.18, blue: 0.12, alpha: 1)
    static let cream = UIColor(red: 0.95, green: 0.91, blue: 0.84, alpha: 1)
    static let forest = UIColor(red: 0.19, green: 0.32, blue: 0.27, alpha: 1)
    static let terracotta = UIColor(red: 0.76, green: 0.38, blue: 0.25, alpha: 1)
    static let mustard = UIColor(red: 0.88, green: 0.68, blue: 0.27, alpha: 1)
    static let teal = UIColor(red: 0.14, green: 0.40, blue: 0.42, alpha: 1)
    static let brass = UIColor(red: 0.80, green: 0.62, blue: 0.34, alpha: 1)
    static let warmLight = UIColor(red: 1.0, green: 0.89, blue: 0.76, alpha: 1)

    // MARK: Material-Helfer

    /// Wiederholender, anisotrop gefilterter Sampler für Kacheltexturen
    static let repeatSampler: MaterialParameters.Texture.Sampler = {
        let d = MTLSamplerDescriptor()
        d.minFilter = .linear
        d.magFilter = .linear
        d.mipFilter = .linear
        d.sAddressMode = .repeat
        d.tAddressMode = .repeat
        d.maxAnisotropy = 8
        return MaterialParameters.Texture.Sampler(d)
    }()

    /// PBR-Material aus Kacheltextur (+ optional Normalenkarte), `scale` = Wiederholungen über die Fläche
    static func tiled(_ color: TextureResource?, normal: TextureResource? = nil, tint: UIColor = .white,
                      scale: SIMD2<Float>, rough: Float, metal: Float = 0) -> PhysicallyBasedMaterial {
        var m = PhysicallyBasedMaterial()
        if let color {
            m.baseColor = .init(tint: tint, texture: MaterialParameters.Texture(color, sampler: repeatSampler))
        } else {
            m.baseColor = .init(tint: tint)
        }
        if let normal {
            m.normal = .init(texture: MaterialParameters.Texture(normal, sampler: repeatSampler))
        }
        m.roughness = .init(floatLiteral: rough)
        m.metallic = .init(floatLiteral: metal)
        m.textureCoordinateTransform = .init(offset: .zero, scale: scale, rotation: 0)
        return m
    }

    static func unlit(_ tex: TextureResource?, tint: UIColor = .white) -> UnlitMaterial {
        var u = UnlitMaterial(color: tint)
        if let tex { u.color = .init(tint: tint, texture: .init(tex)) }
        return u
    }

    static func picture(_ tex: TextureResource?, rough: Float = 0.45) -> PhysicallyBasedMaterial {
        var m = PhysicallyBasedMaterial()
        if let tex { m.baseColor = .init(tint: .white, texture: .init(tex)) }
        m.roughness = .init(floatLiteral: rough)
        m.metallic = .init(floatLiteral: 0)
        return m
    }

    // MARK: Normalenkarten

    private static var normalCache: [String: TextureResource] = [:]

    /// Zeichnet eine Höhenkarte (hell = hoch) und rechnet sie in eine kachelbare Normalenkarte um
    static func normalMap(_ w: Int, _ h: Int, key: String, strength: Float = 3, _ draw: (CGContext, CGSize) -> Void) -> TextureResource? {
        if let t = normalCache[key] { return t }
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 1
        fmt.opaque = true
        let img = UIGraphicsImageRenderer(size: CGSize(width: w, height: h), format: fmt).image { ctx in
            draw(ctx.cgContext, CGSize(width: w, height: h))
        }
        guard let src = img.cgImage else { return nil }
        var height = [UInt8](repeating: 0, count: w * h)
        let ok = height.withUnsafeMutableBytes { buf -> Bool in
            guard let g = CGContext(data: buf.baseAddress, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w,
                                    space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return false }
            g.draw(src, in: CGRect(x: 0, y: 0, width: w, height: h))
            return true
        }
        guard ok else { return nil }
        var px = [UInt8](repeating: 255, count: w * h * 4)
        for y in 0..<h {
            let up = ((y - 1 + h) % h) * w, dn = ((y + 1) % h) * w, row = y * w
            for x in 0..<w {
                let l = Float(height[row + (x - 1 + w) % w]), r = Float(height[row + (x + 1) % w])
                let u = Float(height[up + x]), d = Float(height[dn + x])
                let n = simd_normalize(SIMD3<Float>(-(r - l) / 255 * strength, (d - u) / 255 * strength, 1))
                let i = (row + x) * 4
                px[i] = UInt8(max(0, min(255, (n.x * 0.5 + 0.5) * 255)))
                px[i + 1] = UInt8(max(0, min(255, (n.y * 0.5 + 0.5) * 255)))
                px[i + 2] = UInt8(max(0, min(255, (n.z * 0.5 + 0.5) * 255)))
            }
        }
        let cg: CGImage? = px.withUnsafeMutableBytes { buf in
            CGContext(data: buf.baseAddress, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4,
                      space: CGColorSpaceCreateDeviceRGB(),
                      bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)?.makeImage()
        }
        guard let cg, let t = try? TextureResource.generate(from: cg, withName: nil, options: .init(semantic: .normal)) else { return nil }
        normalCache[key] = t
        return t
    }

    // MARK: Kacheltexturen (1 m × 1 m)

    private static func noise(_ c: CGContext, _ s: CGSize, count: Int, size: ClosedRange<CGFloat>, white: ClosedRange<CGFloat>, alpha: CGFloat) {
        for _ in 0..<count {
            UIColor(white: .random(in: white), alpha: alpha).setFill()
            let d = CGFloat.random(in: size)
            c.fill(CGRect(x: .random(in: 0..<s.width), y: .random(in: 0..<s.height), width: d, height: d))
        }
    }

    /// Gummiboden mit hellen und farbigen Granulat-Flocken, Fugen am Rand jeder 1-m-Platte
    static func rubber() -> TextureResource? {
        GymTex.make(512, 512, key: "look-rubber") { c, s in
            UIColor(red: 0.13, green: 0.125, blue: 0.12, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            noise(c, s, count: 7000, size: 1...2.5, white: 0.20...0.36, alpha: 1)
            let flecks: [UIColor] = [UIColor(red: 0.45, green: 0.40, blue: 0.33, alpha: 1),
                                     UIColor(red: 0.30, green: 0.36, blue: 0.45, alpha: 1),
                                     UIColor(red: 0.50, green: 0.27, blue: 0.20, alpha: 1)]
            for _ in 0..<900 {
                flecks.randomElement()!.setFill()
                let d = CGFloat.random(in: 1.5...3)
                c.fill(CGRect(x: .random(in: 0..<s.width), y: .random(in: 0..<s.height), width: d, height: d))
            }
            UIColor(white: 0.05, alpha: 1).setFill()
            c.fill(CGRect(x: 0, y: 0, width: s.width, height: 2))
            c.fill(CGRect(x: 0, y: 0, width: 2, height: s.height))
        }
    }

    static func rubberNormal() -> TextureResource? {
        normalMap(512, 512, key: "look-rubber-n", strength: 2) { c, s in
            UIColor(white: 0.6, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            noise(c, s, count: 9000, size: 1...2.5, white: 0.45...0.75, alpha: 1)
            UIColor(white: 0.1, alpha: 1).setFill()
            c.fill(CGRect(x: 0, y: 0, width: s.width, height: 3))
            c.fill(CGRect(x: 0, y: 0, width: 3, height: s.height))
        }
    }

    /// Ziegel im Läuferverband: 14 Reihen und 4 Steine je Meter, warme Rot- und Brauntöne
    private static let brickRows = 14, brickCols = 4

    static func brick() -> TextureResource? {
        GymTex.make(512, 512, key: "look-brick") { c, s in
            UIColor(red: 0.70, green: 0.66, blue: 0.60, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            noise(c, s, count: 3000, size: 1...2, white: 0.55...0.80, alpha: 0.5)
            let rh = s.height / CGFloat(brickRows), bw = s.width / CGFloat(brickCols), m: CGFloat = 4
            for r in 0..<brickRows {
                let off = r % 2 == 0 ? 0 : bw / 2
                for k in -1...brickCols {
                    let rect = CGRect(x: CGFloat(k) * bw + off + m / 2, y: CGFloat(r) * rh + m / 2, width: bw - m, height: rh - m)
                    let t = CGFloat.random(in: 0...1)
                    let base: UIColor
                    if t < 0.12 {
                        base = UIColor(red: .random(in: 0.34...0.42), green: .random(in: 0.16...0.20), blue: .random(in: 0.11...0.14), alpha: 1)
                    } else if t < 0.30 {
                        base = UIColor(red: .random(in: 0.58...0.64), green: .random(in: 0.33...0.38), blue: .random(in: 0.24...0.28), alpha: 1)
                    } else {
                        base = UIColor(red: .random(in: 0.46...0.54), green: .random(in: 0.24...0.29), blue: .random(in: 0.18...0.21), alpha: 1)
                    }
                    base.setFill()
                    c.fill(rect)
                    // Körnung und leichte Verfärbung im Stein
                    c.saveGState(); c.clip(to: rect)
                    for _ in 0..<40 {
                        UIColor(white: Bool.random() ? 0 : 1, alpha: .random(in: 0.04...0.12)).setFill()
                        let d = CGFloat.random(in: 1...4)
                        c.fill(CGRect(x: .random(in: rect.minX..<rect.maxX), y: .random(in: rect.minY..<rect.maxY), width: d, height: d))
                    }
                    UIColor(white: 0, alpha: .random(in: 0...0.10)).setFill()
                    c.fill(CGRect(x: rect.minX, y: rect.maxY - rh * 0.3, width: rect.width, height: rh * 0.3))
                    c.restoreGState()
                }
            }
        }
    }

    static func brickNormal() -> TextureResource? {
        normalMap(512, 512, key: "look-brick-n", strength: 4) { c, s in
            UIColor(white: 0.15, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            let rh = s.height / CGFloat(brickRows), bw = s.width / CGFloat(brickCols), m: CGFloat = 4
            for r in 0..<brickRows {
                let off = r % 2 == 0 ? 0 : bw / 2
                for k in -1...brickCols {
                    let rect = CGRect(x: CGFloat(k) * bw + off + m / 2, y: CGFloat(r) * rh + m / 2, width: bw - m, height: rh - m)
                    UIColor(white: 0.55, alpha: 1).setFill(); c.fill(rect)
                    UIColor(white: 0.85, alpha: 1).setFill(); c.fill(rect.insetBy(dx: 2, dy: 1.5))
                    c.saveGState(); c.clip(to: rect)
                    for _ in 0..<30 {
                        UIColor(white: .random(in: 0.6...1), alpha: 1).setFill()
                        let d = CGFloat.random(in: 1...3)
                        c.fill(CGRect(x: .random(in: rect.minX..<rect.maxX), y: .random(in: rect.minY..<rect.maxY), width: d, height: d))
                    }
                    c.restoreGState()
                }
            }
        }
    }

    /// Feiner Putz: fast weiß mit weichen Flecken, wird über `tint` eingefärbt
    static func plaster() -> TextureResource? {
        GymTex.make(512, 512, key: "look-plaster") { c, s in
            UIColor(white: 0.95, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            for _ in 0..<60 {
                UIColor(white: .random(in: 0.86...1), alpha: 0.10).setFill()
                let d = CGFloat.random(in: 40...160)
                c.fillEllipse(in: CGRect(x: .random(in: -40..<s.width), y: .random(in: -40..<s.height), width: d, height: d * .random(in: 0.6...1.2)))
            }
            noise(c, s, count: 6000, size: 1...2, white: 0.85...1, alpha: 0.35)
        }
    }

    static func plasterNormal() -> TextureResource? {
        normalMap(256, 256, key: "look-plaster-n", strength: 1.2) { c, s in
            UIColor(white: 0.5, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            noise(c, s, count: 5000, size: 1...3, white: 0.3...0.7, alpha: 1)
        }
    }

    /// Senkrechte Eichenbretter (8 je Meter) mit Maserung und Fugen
    static func planks() -> TextureResource? {
        GymTex.make(512, 512, key: "look-planks") { c, s in
            let n = 8
            let bw = s.width / CGFloat(n)
            for i in 0..<n {
                let rect = CGRect(x: CGFloat(i) * bw, y: 0, width: bw, height: s.height)
                let v = CGFloat.random(in: -0.05...0.05)
                UIColor(red: 0.68 + v, green: 0.50 + v, blue: 0.32 + v * 0.8, alpha: 1).setFill()
                c.fill(rect)
                c.saveGState(); c.clip(to: rect)
                // Maserung: leicht gewellte Linien in Brettrichtung
                for _ in 0..<26 {
                    let x0 = CGFloat.random(in: rect.minX...rect.maxX)
                    let amp = CGFloat.random(in: 0.5...3), freq = CGFloat.random(in: 0.01...0.03), ph = CGFloat.random(in: 0...6)
                    c.setStrokeColor(UIColor(red: 0.35, green: 0.22, blue: 0.12, alpha: .random(in: 0.08...0.22)).cgColor)
                    c.setLineWidth(.random(in: 0.6...2.2))
                    c.move(to: CGPoint(x: x0, y: 0))
                    var y: CGFloat = 0
                    while y <= s.height {
                        c.addLine(to: CGPoint(x: x0 + amp * sin(y * freq + ph), y: y))
                        y += 8
                    }
                    c.strokePath()
                }
                // ein Ast pro Brett, nicht bei jedem
                if Bool.random() {
                    let k = CGPoint(x: .random(in: rect.minX + 12...rect.maxX - 12), y: .random(in: 20...s.height - 20))
                    UIColor(red: 0.36, green: 0.22, blue: 0.12, alpha: 0.55).setFill()
                    c.fillEllipse(in: CGRect(x: k.x - 5, y: k.y - 9, width: 10, height: 18))
                }
                c.restoreGState()
                UIColor(red: 0.20, green: 0.13, blue: 0.08, alpha: 1).setFill()
                c.fill(CGRect(x: rect.minX, y: 0, width: 2, height: s.height))
            }
        }
    }

    static func planksNormal() -> TextureResource? {
        normalMap(512, 512, key: "look-planks-n", strength: 3) { c, s in
            UIColor(white: 0.7, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            let bw = s.width / 8
            for i in 0..<8 {
                UIColor(white: 0.1, alpha: 1).setFill()
                c.fill(CGRect(x: CGFloat(i) * bw, y: 0, width: 3, height: s.height))
                for _ in 0..<10 {
                    UIColor(white: .random(in: 0.6...0.8), alpha: 1).setFill()
                    c.fill(CGRect(x: CGFloat(i) * bw + .random(in: 4...bw - 4), y: 0, width: 1, height: s.height))
                }
            }
        }
    }

    /// Kunstrasen für die freie Fläche
    static func turf() -> TextureResource? {
        GymTex.make(512, 512, key: "look-turf") { c, s in
            UIColor(red: 0.20, green: 0.40, blue: 0.18, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            for _ in 0..<9000 {
                let g = CGFloat.random(in: 0.30...0.55)
                c.setStrokeColor(UIColor(red: g * 0.45, green: g, blue: g * 0.35, alpha: 0.8).cgColor)
                c.setLineWidth(1.2)
                let p = CGPoint(x: .random(in: 0..<s.width), y: .random(in: 0..<s.height))
                c.move(to: p); c.addLine(to: CGPoint(x: p.x + .random(in: -2...2), y: p.y + .random(in: 4...9)))
                c.strokePath()
            }
        }
    }

    // MARK: Bilder, Schilder, Fenster

    private static func text(_ s: String, in r: CGRect, size: CGFloat, weight: UIFont.Weight = .black, color: UIColor,
                             kern: CGFloat = 0, font: String? = nil, align: NSTextAlignment = .center) {
        let p = NSMutableParagraphStyle()
        p.alignment = align
        let f = font.flatMap { UIFont(name: $0, size: size) } ?? UIFont.systemFont(ofSize: size, weight: weight)
        (s as NSString).draw(in: r, withAttributes: [.font: f, .foregroundColor: color, .paragraphStyle: p, .kern: kern])
    }

    private static func line(_ c: CGContext, _ pts: [CGPoint], width: CGFloat) {
        c.setLineWidth(width)
        c.setLineCap(.round)
        c.setLineJoin(.round)
        c.move(to: pts[0])
        for p in pts.dropFirst() { c.addLine(to: p) }
        c.strokePath()
    }

    /// Weißes Passepartout um ein Foto
    private static func mount(_ c: CGContext, _ s: CGSize, margin: CGFloat) -> CGRect {
        cream.setFill(); c.fill(CGRect(origin: .zero, size: s))
        let r = CGRect(origin: .zero, size: s).insetBy(dx: margin, dy: margin)
        UIColor(white: 0, alpha: 0.25).setStroke(); c.setLineWidth(3); c.stroke(r.insetBy(dx: -2, dy: -2))
        return r
    }

    /// Retro-Plakat: Gewichtheber vor der Sonne
    static func posterLifter() -> TextureResource? {
        GymTex.make(600, 840, key: "art-lifter") { c, s in
            UIColor(red: 0.95, green: 0.89, blue: 0.77, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            terracotta.setFill(); c.fillEllipse(in: CGRect(x: 90, y: 260, width: 420, height: 420))
            mustard.setFill(); c.fill(CGRect(x: 0, y: 640, width: s.width, height: 30))
            let ink = UIColor(red: 0.15, green: 0.12, blue: 0.10, alpha: 1)
            c.saveGState()
            c.translateBy(x: 45, y: 100)
            c.scaleBy(x: 0.85, y: 0.85)
            ink.setStroke(); ink.setFill()
            line(c, [CGPoint(x: 90, y: 150), CGPoint(x: 510, y: 150)], width: 12)
            for x: CGFloat in [100, 470] { c.fill(CGRect(x: x, y: 80, width: 30, height: 140)) }
            for x: CGFloat in [135, 440] { c.fill(CGRect(x: x, y: 100, width: 22, height: 100)) }
            c.fillEllipse(in: CGRect(x: 266, y: 216, width: 68, height: 68))
            line(c, [CGPoint(x: 300, y: 300), CGPoint(x: 300, y: 470)], width: 56)
            line(c, [CGPoint(x: 215, y: 150), CGPoint(x: 225, y: 240), CGPoint(x: 290, y: 310)], width: 28)
            line(c, [CGPoint(x: 385, y: 150), CGPoint(x: 375, y: 240), CGPoint(x: 310, y: 310)], width: 28)
            line(c, [CGPoint(x: 235, y: 690), CGPoint(x: 248, y: 580), CGPoint(x: 290, y: 470)], width: 36)
            line(c, [CGPoint(x: 365, y: 690), CGPoint(x: 352, y: 580), CGPoint(x: 310, y: 470)], width: 36)
            c.restoreGState()
            text("STÄRKER", in: CGRect(x: 0, y: 26, width: s.width, height: 110), size: 92, color: ink, kern: 6)
            text("JEDEN TAG.", in: CGRect(x: 0, y: 730, width: s.width, height: 80), size: 54, weight: .heavy, color: ink, kern: 10)
        }
    }

    /// Berglandschaft im Abendlicht, als Foto mit Passepartout
    static func photoMountains() -> TextureResource? {
        GymTex.make(840, 600, key: "art-mountains") { c, s in
            let r = mount(c, s, margin: 60)
            c.saveGState(); c.clip(to: r)
            let cs = CGColorSpaceCreateDeviceRGB()
            let sky = CGGradient(colorsSpace: cs, colors: [UIColor(red: 0.42, green: 0.55, blue: 0.75, alpha: 1).cgColor,
                                                          UIColor(red: 0.98, green: 0.80, blue: 0.58, alpha: 1).cgColor] as CFArray,
                                 locations: [0, 1])!
            c.drawLinearGradient(sky, start: CGPoint(x: 0, y: r.minY), end: CGPoint(x: 0, y: r.minY + r.height * 0.62), options: [.drawsAfterEndLocation])
            UIColor(red: 1.0, green: 0.93, blue: 0.75, alpha: 1).setFill()
            c.fillEllipse(in: CGRect(x: r.minX + r.width * 0.62, y: r.minY + r.height * 0.38, width: 46, height: 46))
            let layers: [(UIColor, CGFloat, CGFloat)] = [
                (UIColor(red: 0.55, green: 0.50, blue: 0.62, alpha: 1), 0.42, 0.20),
                (UIColor(red: 0.36, green: 0.35, blue: 0.48, alpha: 1), 0.52, 0.16),
                (UIColor(red: 0.20, green: 0.24, blue: 0.30, alpha: 1), 0.62, 0.12)]
            for (k, (col, base, amp)) in layers.enumerated() {
                col.setFill()
                c.move(to: CGPoint(x: r.minX, y: r.maxY))
                var x = r.minX
                while x <= r.maxX + 20 {
                    let t: CGFloat = (x - r.minX) / r.width
                    let ph: CGFloat = t * (3.1 + CGFloat(k)) + CGFloat(k) * 1.7
                    let ridge: CGFloat = abs(sin(ph)) * (0.6 + 0.4 * sin(t * 17))
                    let y: CGFloat = r.minY + r.height * (base - amp * ridge)
                    c.addLine(to: CGPoint(x: x, y: y))
                    x += 12
                }
                c.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
                c.closePath(); c.fillPath()
            }
            // See mit Spiegelung
            let lake = CGGradient(colorsSpace: cs, colors: [UIColor(red: 0.85, green: 0.70, blue: 0.55, alpha: 1).cgColor,
                                                           UIColor(red: 0.18, green: 0.25, blue: 0.32, alpha: 1).cgColor] as CFArray,
                                  locations: [0, 1])!
            let ly = r.minY + r.height * 0.74
            c.clip(to: CGRect(x: r.minX, y: ly, width: r.width, height: r.maxY - ly))
            c.drawLinearGradient(lake, start: CGPoint(x: 0, y: ly), end: CGPoint(x: 0, y: r.maxY), options: [])
            c.restoreGState()
        }
    }

    /// Abstraktes Bild in Senf, Petrol und Terrakotta
    static func artAbstract() -> TextureResource? {
        GymTex.make(600, 800, key: "art-abstract") { c, s in
            mustard.setFill(); c.fill(CGRect(origin: .zero, size: s))
            teal.setFill(); c.fillEllipse(in: CGRect(x: 60, y: 110, width: 340, height: 340))
            terracotta.setFill()
            c.move(to: CGPoint(x: 600, y: 800)); c.addArc(center: CGPoint(x: 600, y: 800), radius: 330, startAngle: .pi, endAngle: .pi * 1.5, clockwise: false)
            c.closePath(); c.fillPath()
            cream.setFill(); c.fillEllipse(in: CGRect(x: 380, y: 80, width: 120, height: 120))
            UIColor(red: 0.12, green: 0.10, blue: 0.09, alpha: 1).setFill()
            c.fill(CGRect(x: 0, y: 520, width: 420, height: 22))
            c.fill(CGRect(x: 120, y: 520, width: 22, height: 280))
        }
    }

    /// Schwarz-weiß-Foto einer Läuferin mit Passepartout
    static func photoRunner() -> TextureResource? {
        GymTex.make(600, 760, key: "art-runner") { c, s in
            let r = mount(c, s, margin: 55)
            c.saveGState(); c.clip(to: r)
            let cs = CGColorSpaceCreateDeviceRGB()
            let g = CGGradient(colorsSpace: cs, colors: [UIColor(white: 0.82, alpha: 1).cgColor, UIColor(white: 0.42, alpha: 1).cgColor] as CFArray,
                               locations: [0, 1])!
            c.drawLinearGradient(g, start: CGPoint(x: 0, y: r.minY), end: CGPoint(x: 0, y: r.maxY), options: [])
            UIColor(white: 0.30, alpha: 1).setFill(); c.fill(CGRect(x: r.minX, y: r.minY + r.height * 0.80, width: r.width, height: r.height * 0.2))
            UIColor(white: 0.08, alpha: 1).setStroke(); UIColor(white: 0.08, alpha: 1).setFill()
            let ox = r.midX - 300, oy = r.minY + 40
            c.fillEllipse(in: CGRect(x: ox + 316, y: oy + 90, width: 60, height: 60))
            line(c, [CGPoint(x: ox + 330, y: oy + 160), CGPoint(x: ox + 290, y: oy + 330)], width: 50)
            line(c, [CGPoint(x: ox + 320, y: oy + 180), CGPoint(x: ox + 380, y: oy + 250), CGPoint(x: ox + 420, y: oy + 200)], width: 24)
            line(c, [CGPoint(x: ox + 315, y: oy + 185), CGPoint(x: ox + 250, y: oy + 240), CGPoint(x: ox + 210, y: oy + 300)], width: 24)
            line(c, [CGPoint(x: ox + 290, y: oy + 330), CGPoint(x: ox + 380, y: oy + 400), CGPoint(x: ox + 360, y: oy + 500)], width: 32)
            line(c, [CGPoint(x: ox + 285, y: oy + 335), CGPoint(x: ox + 220, y: oy + 430), CGPoint(x: ox + 130, y: oy + 420)], width: 32)
            UIColor(white: 0, alpha: 0.25).setFill()
            c.fillEllipse(in: CGRect(x: ox + 150, y: r.minY + r.height * 0.82, width: 260, height: 26))
            c.restoreGState()
        }
    }

    /// Plakat in Terrakotta
    static func posterExcuses() -> TextureResource? {
        GymTex.make(600, 840, key: "art-excuses") { c, s in
            terracotta.setFill(); c.fill(CGRect(origin: .zero, size: s))
            cream.setStroke(); c.setLineWidth(6); c.stroke(CGRect(origin: .zero, size: s).insetBy(dx: 30, dy: 30))
            text("KEINE", in: CGRect(x: 0, y: 220, width: s.width, height: 130), size: 112, color: cream, kern: 4)
            text("AUSREDEN.", in: CGRect(x: 0, y: 350, width: s.width, height: 130), size: 84, color: cream, kern: 2)
            text("BODYFORMANCE", in: CGRect(x: 0, y: 700, width: s.width, height: 50), size: 30, weight: .bold, color: cream, kern: 8)
        }
    }

    /// Plakat in Waldgrün mit Kettlebell
    static func posterIron() -> TextureResource? {
        GymTex.make(600, 840, key: "art-iron") { c, s in
            forest.setFill(); c.fill(CGRect(origin: .zero, size: s))
            brass.setFill(); brass.setStroke()
            c.fillEllipse(in: CGRect(x: 170, y: 300, width: 260, height: 250))
            c.setLineWidth(34)
            c.addArc(center: CGPoint(x: 300, y: 300), radius: 92, startAngle: .pi * 1.05, endAngle: .pi * 1.95, clockwise: false)
            c.strokePath()
            line(c, [CGPoint(x: 210, y: 300), CGPoint(x: 220, y: 340)], width: 34)
            line(c, [CGPoint(x: 390, y: 300), CGPoint(x: 380, y: 340)], width: 34)
            text("EISEN", in: CGRect(x: 0, y: 70, width: s.width, height: 100), size: 80, color: cream, kern: 14)
            text("SCHWEISS · GEDULD", in: CGRect(x: 0, y: 610, width: s.width, height: 60), size: 40, weight: .heavy, color: cream, kern: 4)
            text("SEIT 2026", in: CGRect(x: 0, y: 700, width: s.width, height: 50), size: 28, weight: .semibold, color: brass, kern: 10)
        }
    }

    /// Kreidetafel mit dem Training des Tages
    static func chalkboard() -> TextureResource? {
        GymTex.make(1200, 800, key: "art-chalk") { c, s in
            UIColor(red: 0.14, green: 0.17, blue: 0.16, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            for _ in 0..<40 {
                UIColor(white: 1, alpha: 0.035).setFill()
                let d = CGFloat.random(in: 80...260)
                c.fillEllipse(in: CGRect(x: .random(in: -60..<s.width), y: .random(in: -60..<s.height), width: d * 1.6, height: d))
            }
            let chalk = UIColor(white: 0.93, alpha: 0.92)
            let font = "ChalkboardSE-Bold"
            text("TRAINING DES TAGES", in: CGRect(x: 0, y: 50, width: s.width, height: 100), size: 74, color: chalk, font: font)
            chalk.setStroke(); line(c, [CGPoint(x: 240, y: 160), CGPoint(x: 960, y: 166)], width: 4)
            let rows = ["A   Kniebeuge   5 × 5", "B   Klimmzüge   4 × 8", "C   Rudern   3 × 12", "D   Plank   3 × 60 s"]
            for (i, r) in rows.enumerated() {
                text(r, in: CGRect(x: 170, y: 210 + CGFloat(i) * 120, width: 900, height: 100), size: 62, color: chalk,
                     font: "ChalkboardSE-Regular", align: .left)
            }
            mustard.withAlphaComponent(0.9).setStroke()
            line(c, [CGPoint(x: 900, y: 620), CGPoint(x: 940, y: 670), CGPoint(x: 1040, y: 560)], width: 10)
        }
    }

    /// Leuchtschild über der Kurzhantel-Ablage
    static func sign() -> TextureResource? {
        GymTex.make(1600, 360, key: "art-sign") { c, s in
            UIColor(red: 0.09, green: 0.08, blue: 0.07, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            text("BODYFORMANCE", in: CGRect(x: 0, y: 40, width: s.width, height: 200), size: 168, color: UIColor(red: 1, green: 0.93, blue: 0.80, alpha: 1), kern: 16)
            text("TRAIN  ·  MOVE  ·  RECOVER", in: CGRect(x: 0, y: 250, width: s.width, height: 80), size: 58, weight: .bold, color: brass, kern: 8)
        }
    }

    /// Blick nach draußen: Abendhimmel, Häuser und Bäume, mit Sprossen
    static func windowView() -> TextureResource? {
        GymTex.make(512, 920, key: "art-window") { c, s in
            let cs = CGColorSpaceCreateDeviceRGB()
            let sky = CGGradient(colorsSpace: cs, colors: [UIColor(red: 0.55, green: 0.72, blue: 0.90, alpha: 1).cgColor,
                                                          UIColor(red: 0.99, green: 0.88, blue: 0.72, alpha: 1).cgColor] as CFArray,
                                 locations: [0, 1])!
            c.drawLinearGradient(sky, start: .zero, end: CGPoint(x: 0, y: s.height * 0.75), options: [.drawsAfterEndLocation])
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).setFill()
            for _ in 0..<5 {
                let w = CGFloat.random(in: 80...200)
                c.fillEllipse(in: CGRect(x: .random(in: -60..<s.width), y: .random(in: 60..<300), width: w, height: w * 0.25))
            }
            // Häuser gegenüber
            var x: CGFloat = -10
            while x < s.width {
                let w = CGFloat.random(in: 70...150), top = s.height * .random(in: 0.48...0.62)
                UIColor(red: .random(in: 0.62...0.72), green: .random(in: 0.60...0.66), blue: .random(in: 0.62...0.70), alpha: 1).setFill()
                c.fill(CGRect(x: x, y: top, width: w, height: s.height - top))
                UIColor(red: 1, green: 0.92, blue: 0.70, alpha: 0.55).setFill()
                var wy = top + 20
                while wy < s.height * 0.8 {
                    var wx = x + 12
                    while wx < x + w - 20 { c.fill(CGRect(x: wx, y: wy, width: 14, height: 20)); wx += 30 }
                    wy += 40
                }
                x += w + 6
            }
            // Bäume
            for _ in 0..<9 {
                UIColor(red: .random(in: 0.18...0.28), green: .random(in: 0.34...0.44), blue: .random(in: 0.18...0.24), alpha: 1).setFill()
                let d = CGFloat.random(in: 120...220)
                c.fillEllipse(in: CGRect(x: .random(in: -60..<s.width - 40), y: s.height * .random(in: 0.68...0.80), width: d, height: d))
            }
            // Sprossen
            UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1).setFill()
            c.fill(CGRect(x: 0, y: 0, width: s.width, height: 22)); c.fill(CGRect(x: 0, y: s.height - 22, width: s.width, height: 22))
            c.fill(CGRect(x: 0, y: 0, width: 22, height: s.height)); c.fill(CGRect(x: s.width - 22, y: 0, width: 22, height: s.height))
            c.fill(CGRect(x: s.width / 2 - 7, y: 0, width: 14, height: s.height))
            for k in 1..<4 { c.fill(CGRect(x: 0, y: s.height * CGFloat(k) / 4 - 7, width: s.width, height: 14)) }
        }
    }

    // MARK: Umgebungslicht

    private static var environment: EnvironmentResource?

    /// Warmes Rundum-Bild des Raums für die bildbasierte Beleuchtung (Reflexionen auf Metall, Spiegel, Lack)
    private static func environmentImage() -> CGImage? {
        let w: CGFloat = 1024, h: CGFloat = 512
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 1
        fmt.opaque = true
        let img = UIGraphicsImageRenderer(size: CGSize(width: w, height: h), format: fmt).image { ctx in
            let c = ctx.cgContext
            let cs = CGColorSpaceCreateDeviceRGB()
            let g = CGGradient(colorsSpace: cs, colors: [
                UIColor(red: 0.30, green: 0.26, blue: 0.22, alpha: 1).cgColor,   // Decke
                UIColor(red: 0.62, green: 0.55, blue: 0.47, alpha: 1).cgColor,
                UIColor(red: 0.86, green: 0.79, blue: 0.68, alpha: 1).cgColor,   // Wände oben
                UIColor(red: 0.52, green: 0.38, blue: 0.25, alpha: 1).cgColor,   // Holzpaneel
                UIColor(red: 0.16, green: 0.15, blue: 0.14, alpha: 1).cgColor,   // Boden
                UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1).cgColor] as CFArray,
                               locations: [0, 0.28, 0.44, 0.56, 0.64, 1])!
            c.drawLinearGradient(g, start: .zero, end: CGPoint(x: 0, y: h), options: [])
            // Ziegelwand, grüne Wand, Fensterreihe
            UIColor(red: 0.55, green: 0.28, blue: 0.20, alpha: 0.7).setFill()
            c.fill(CGRect(x: 0, y: h * 0.30, width: w * 0.16, height: h * 0.30))
            c.fill(CGRect(x: w * 0.84, y: h * 0.30, width: w * 0.16, height: h * 0.30))
            forest.withAlphaComponent(0.7).setFill()
            c.fill(CGRect(x: w * 0.16, y: h * 0.30, width: w * 0.20, height: h * 0.24))
            UIColor(red: 1.0, green: 0.95, blue: 0.85, alpha: 1).setFill()
            for k in 0..<3 { c.fill(CGRect(x: w * (0.42 + CGFloat(k) * 0.06), y: h * 0.30, width: w * 0.05, height: h * 0.18)) }
            // Leuchten an der Decke
            warmLight.setFill()
            for k in 0..<8 {
                c.fillEllipse(in: CGRect(x: w * CGFloat(k) / 8 + 30, y: h * 0.16, width: 46, height: 30))
            }
        }
        return img.cgImage
    }

    /// Setzt das warme Umgebungslicht auf eine 3D-Ansicht (einmal erzeugt, dann geteilt)
    static func applyEnvironment(to view: ARView) {
        view.environment.lighting.intensityExponent = 0.4
        if let environment {
            view.environment.lighting.resource = environment
            return
        }
        guard let img = environmentImage() else { return }
        Task { [weak view] in
            guard let env = try? await EnvironmentResource(equirectangular: img) else { return }
            environment = env
            view?.environment.lighting.resource = env
        }
    }
}

// MARK: Raum, Licht und Deko

extension GymRoom {
    private func add(_ size: SIMD3<Float>, _ pos: SIMD3<Float>, _ m: Material, corner: Float = 0, parent: Entity? = nil) -> ModelEntity {
        GymProps.box(size, pos, m, corner: corner, parent: parent ?? root)
    }

    /// Boden, Wände, Decke, Fenster, Holzpaneele, Spiegel
    func buildInterior() {
        let half: Float = 4.0, hgt: Float = 3.4, span = half * 2 + 0.2
        let L = GymLook.self

        // Boden: Gummiplatten, in der Mitte eine Eichen-Plattform
        _ = add([span, 0.1, span], [0, -0.05, 0], L.tiled(L.rubber(), normal: L.rubberNormal(), scale: [span, span], rough: 0.88))
        _ = add([2.4, 0.006, 2.4], [0, 0.003, 0], L.tiled(L.planks(), normal: L.planksNormal(), scale: [2.4, 2.4], rough: 0.55))
        let edge = GymTex.paint(UIColor(white: 0.12, alpha: 1), rough: 0.5)
        for s: Float in [-1, 1] {
            _ = add([2.46, 0.008, 0.03], [0, 0.004, s * 1.215], edge)
            _ = add([0.03, 0.008, 2.46], [s * 1.215, 0.004, 0], edge)
        }

        // Decke: dunkel gestrichen, offene Stahlträger und Lüftungsrohre
        _ = add([span, 0.1, span], [0, hgt + 0.05, 0],
                L.tiled(L.plaster(), normal: L.plasterNormal(), tint: UIColor(red: 0.28, green: 0.26, blue: 0.24, alpha: 1), scale: [span, span], rough: 0.95))
        let beam = GymTex.paint(UIColor(white: 0.10, alpha: 1), rough: 0.5)
        for z: Float in [-2.2, 0.0, 2.2] {
            _ = add([half * 2, 0.22, 0.03], [0, hgt - 0.11, z], beam)
            _ = add([half * 2, 0.02, 0.14], [0, hgt - 0.21, z], beam)
        }
        let duct = SimpleMaterial(color: UIColor(white: 0.62, alpha: 1), roughness: 0.4, isMetallic: true)
        for z: Float in [-3.0, 3.0] {
            GymProps.cylinder(half * 2, 0.17, [0, 3.0, z], duct, axis: [1, 0, 0], parent: root)
            for x: Float in [-3, -1, 1, 3] {
                GymProps.cylinder(0.24, 0.006, [x, 3.28, z], beam, parent: root)
                GymProps.cylinder(0.03, 0.175, [x, 3.0, z], beam, axis: [1, 0, 0], parent: root)
            }
        }

        // Wände: Ziegel hinten, Putz creme vorn und links, Waldgrün rechts
        let plaster = L.plaster(), plasterN = L.plasterNormal()
        _ = add([span, hgt, 0.1], [0, hgt / 2, -half - 0.05], L.tiled(L.brick(), normal: L.brickNormal(), scale: [span, hgt], rough: 0.92))
        _ = add([span, hgt, 0.1], [0, hgt / 2, half + 0.05], L.tiled(plaster, normal: plasterN, tint: L.cream, scale: [span, hgt], rough: 0.9))
        _ = add([0.1, hgt, half * 2], [-half - 0.05, hgt / 2, 0], L.tiled(plaster, normal: plasterN, tint: L.cream, scale: [half * 2, hgt], rough: 0.9))
        _ = add([0.1, hgt, half * 2], [half + 0.05, hgt / 2, 0], L.tiled(plaster, normal: plasterN, tint: L.forest, scale: [half * 2, hgt], rough: 0.85))

        // Eichen-Wandpaneele (1,1 m) mit Abschlussleiste und Sockel; an der Ziegelwand nur Sockel
        let oak = L.tiled(L.planks(), normal: L.planksNormal(), scale: [half * 2, 1.1], rough: 0.5)
        let walnut = GymTex.paint(L.walnut, rough: 0.45)
        let base = GymTex.paint(UIColor(white: 0.08, alpha: 1), rough: 0.6)
        _ = add([half * 2, 1.1, 0.02], [0, 0.55, half - 0.01], oak)
        _ = add([half * 2, 0.05, 0.05], [0, 1.115, half - 0.025], walnut)
        _ = add([half * 2, 0.10, 0.03], [0, 0.05, half - 0.035], base)
        for s: Float in [-1, 1] {
            _ = add([0.02, 1.1, half * 2], [s * (half - 0.01), 0.55, 0], oak)
            _ = add([0.05, 0.05, half * 2], [s * (half - 0.025), 1.115, 0], walnut)
            _ = add([0.03, 0.10, half * 2], [s * (half - 0.035), 0.05, 0], base)
        }
        _ = add([half * 2, 0.10, 0.03], [0, 0.05, -half + 0.015], base)

        // Fensterreihe an der Vorderwand (über den Cardio-Geräten)
        let view = L.unlit(L.windowView())
        let frame = GymTex.paint(UIColor(white: 0.10, alpha: 1), rough: 0.4)
        for k in 0..<3 {
            let x: Float = -3.0 + Float(k) * 1.05
            let w = ModelEntity(mesh: .generatePlane(width: 0.92, height: 1.65), materials: [view])
            w.position = [x, 2.12, half - 0.005]
            w.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
            root.addChild(w)
            _ = add([0.06, 1.73, 0.08], [x - 0.49, 2.12, half - 0.04], frame)
            _ = add([0.06, 1.73, 0.08], [x + 0.49, 2.12, half - 0.04], frame)
        }
        _ = add([3.26, 0.06, 0.08], [-1.95, 2.975, half - 0.04], frame)
        _ = add([3.36, 0.045, 0.20], [-1.95, 1.28, half - 0.10], walnut)

        // Spiegelwand links über die halbe Länge, schwarzer Rahmen
        var mirror = PhysicallyBasedMaterial()
        mirror.baseColor = .init(tint: UIColor(white: 0.92, alpha: 1))
        mirror.metallic = 1.0
        mirror.roughness = 0.04
        _ = add([0.012, 2.1, 4.8], [-half + 0.035, 1.25, 0.5], mirror)
        for y: Float in [0.19, 2.31] { _ = add([0.03, 0.04, 4.86], [-half + 0.04, y, 0.5], frame) }
        for z: Float in [-1.91, 2.91] { _ = add([0.03, 2.16, 0.04], [-half + 0.04, 1.25, z], frame) }
    }

    /// Pendelleuchten mit grünen Emaille-Schirmen, warmes Punkt- und Richtungslicht
    func buildLighting() {
        let L = GymLook.self
        var enamel = PhysicallyBasedMaterial()
        enamel.baseColor = .init(tint: L.forest)
        enamel.roughness = 0.3
        enamel.clearcoat = .init(scale: 0.8)
        let brass = SimpleMaterial(color: L.brass, roughness: 0.3, isMetallic: true)
        let cord = GymTex.paint(UIColor(white: 0.06, alpha: 1))
        let glow = UnlitMaterial(color: UIColor(red: 1.0, green: 0.92, blue: 0.78, alpha: 1))
        for x: Float in [-2.2, 0, 2.2] {
            for z: Float in [-1.5, 1.5] {
                GymProps.cylinder(0.45, 0.005, [x, 3.17, z], cord, parent: root)
                GymProps.cylinder(0.07, 0.045, [x, 2.97, z], brass, parent: root)
                GymProps.cylinder(0.20, 0.25, [x, 2.85, z], enamel, parent: root)
                GymProps.cylinder(0.008, 0.23, [x, 2.746, z], glow, parent: root)
            }
        }
        for x: Float in [-2.2, 2.2] {
            for z: Float in [-1.5, 1.5] {
                let p = PointLight()
                p.light.intensity = 85000
                p.light.attenuationRadius = 12
                p.light.color = L.warmLight
                p.position = [x, 2.6, z]
                root.addChild(p)
            }
        }
        let key = DirectionalLight()
        key.light.intensity = 2300
        key.light.color = UIColor(red: 1.0, green: 0.94, blue: 0.86, alpha: 1)
        key.shadow = DirectionalLightComponent.Shadow(maximumDistance: 8, depthBias: 2)
        key.look(at: .zero, from: [1.6, 3.0, 2.2], relativeTo: nil)
        root.addChild(key)
        let fill = DirectionalLight()
        fill.light.intensity = 900
        fill.light.color = UIColor(red: 1.0, green: 0.95, blue: 0.90, alpha: 1)
        fill.look(at: .zero, from: [-2.0, 1.6, -2.5], relativeTo: nil)
        root.addChild(fill)
    }

    /// Gerahmtes Bild an einer Wand. `yaw`: 0 = Rückwand, π = Vorderwand, −π/2 = rechte Wand, π/2 = linke Wand
    @discardableResult
    func hangPicture(_ tex: TextureResource?, w: Float, h: Float, frame: Material, border: Float = 0.03,
                     at p: SIMD3<Float>, yaw: Float, unlit: Bool = false) -> Entity {
        let e = Entity()
        e.position = p
        e.orientation = simd_quatf(angle: yaw, axis: [0, 1, 0])
        GymProps.box([w + border * 2, h + border * 2, 0.03], [0, 0, 0.015], frame, corner: 0.004, parent: e)
        let m: Material
        if unlit { m = GymLook.unlit(tex) } else { m = GymLook.picture(tex) }
        let pic = ModelEntity(mesh: .generatePlane(width: w, height: h), materials: [m])
        pic.position = [0, 0, 0.031]
        e.addChild(pic)
        root.addChild(e)
        return e
    }

    /// Bilder, Schild, Tafel, Pflanzen und Handtuchregal
    func buildDecorations() {
        let L = GymLook.self
        let half: Float = 4.0
        let black = GymTex.paint(UIColor(white: 0.08, alpha: 1), rough: 0.4)
        let oakFrame = GymTex.paint(L.oak, rough: 0.5)
        let brassFrame = SimpleMaterial(color: L.brass, roughness: 0.3, isMetallic: true)

        // Rückwand (Ziegel): Leuchtschild und zwei Plakate
        hangPicture(L.sign(), w: 3.2, h: 0.72, frame: black, border: 0.04, at: [0.9, 2.55, -half], yaw: 0, unlit: true)
        hangPicture(L.posterLifter(), w: 0.62, h: 0.87, frame: black, at: [-2.55, 2.15, -half], yaw: 0)
        hangPicture(L.artAbstract(), w: 0.54, h: 0.72, frame: oakFrame, at: [3.35, 2.45, -half], yaw: 0)

        // Rechte Wand (grün): Bildergalerie
        hangPicture(L.photoMountains(), w: 1.12, h: 0.80, frame: brassFrame, at: [half, 2.25, -2.75], yaw: -.pi / 2)
        hangPicture(L.posterIron(), w: 0.56, h: 0.78, frame: oakFrame, at: [half, 2.3, -1.6], yaw: -.pi / 2)
        hangPicture(L.photoRunner(), w: 0.50, h: 0.63, frame: black, at: [half, 2.45, -0.75], yaw: -.pi / 2)
        hangPicture(L.posterExcuses(), w: 0.60, h: 0.84, frame: black, at: [half, 2.3, 1.75], yaw: -.pi / 2)

        // Vorderwand: Kreidetafel über dem Handtuchregal
        hangPicture(L.chalkboard(), w: 1.35, h: 0.90, frame: oakFrame, border: 0.045, at: [1.5, 1.95, half], yaw: .pi)

        // Linke Wand neben dem Spiegel
        hangPicture(L.photoMountains(), w: 0.84, h: 0.60, frame: black, at: [-half, 2.62, -3.1], yaw: .pi / 2)

        buildTowelShelf(at: [1.5, 0, half - 0.20])
        buildPlant(at: [-3.55, 0, 3.55], height: 1.9)
        buildPlant(at: [0.35, 0, 3.62], height: 1.35)
        buildPlant(at: [3.62, 0, -2.95], height: 1.3)
    }

    /// Offenes Eichenregal mit gerollten Handtüchern
    private func buildTowelShelf(at p: SIMD3<Float>) {
        let L = GymLook.self
        let wood = L.tiled(L.planks(), normal: L.planksNormal(), scale: [1, 1], rough: 0.5)
        let shelf = Entity()
        shelf.position = p
        root.addChild(shelf)
        let w: Float = 1.0, h: Float = 0.95, d: Float = 0.36
        for x: Float in [-w / 2, -w / 6, w / 6, w / 2] {
            _ = add([0.025, h, d], [x, h / 2, 0], wood, parent: shelf)
        }
        for y: Float in [0.02, h / 2, h - 0.0125] {
            _ = add([w + 0.025, 0.025, d], [0, y, 0], wood, parent: shelf)
        }
        let colors = [L.cream, L.terracotta, UIColor(red: 0.56, green: 0.64, blue: 0.52, alpha: 1)]
        for col in 0..<3 {
            for row in 0..<2 {
                let m = GymTex.paint(colors[(col + row) % 3], rough: 1)
                let x = -w / 3 + Float(col) * w / 3, y0: Float = row == 0 ? 0.035 : h / 2 + 0.015
                for (dx, dy) in [(Float(-0.07), Float(0.06)), (0.07, 0.06), (0, 0.17)] {
                    GymProps.cylinder(d - 0.04, 0.06, [x + dx, y0 + dy, 0], m, axis: [0, 0, 1], parent: shelf)
                }
            }
        }
    }

    /// Zimmerpflanze im Terrakotta-Topf
    private func buildPlant(at p: SIMD3<Float>, height: Float) {
        let L = GymLook.self
        let plant = Entity()
        plant.position = p
        root.addChild(plant)
        let pot = SimpleMaterial(color: L.terracotta, roughness: 0.85, isMetallic: false)
        GymProps.cylinder(0.42, 0.19, [0, 0.21, 0], pot, parent: plant)
        GymProps.cylinder(0.04, 0.205, [0, 0.40, 0], pot, parent: plant)
        GymProps.cylinder(0.01, 0.18, [0, 0.415, 0], GymTex.paint(UIColor(red: 0.18, green: 0.13, blue: 0.09, alpha: 1), rough: 1), parent: plant)
        let trunk = GymTex.paint(UIColor(red: 0.30, green: 0.22, blue: 0.14, alpha: 1), rough: 0.9)
        GymProps.cylinder(height * 0.55, 0.018, [0, 0.42 + height * 0.275, 0], trunk, parent: plant)
        let greens = [UIColor(red: 0.16, green: 0.36, blue: 0.16, alpha: 1),
                      UIColor(red: 0.22, green: 0.45, blue: 0.20, alpha: 1),
                      UIColor(red: 0.28, green: 0.52, blue: 0.24, alpha: 1)]
        let leaf = greens.map { SimpleMaterial(color: $0, roughness: 0.6, isMetallic: false) }
        let n = 48
        let leafMesh = MeshResource.generateSphere(radius: 0.13)
        for i in 0..<n {
            // Große, flache Blätter auf einer Spirale (Goldener Winkel), oben schmaler
            let t = Float(i) / Float(n - 1)
            let a = Float(i) * 2.39996
            let r = 0.32 * (1 - t * 0.55) * (0.75 + 0.25 * sin(Float(i) * 1.3))
            let y = 0.42 + height * (0.35 + 0.62 * t)
            let size = 0.8 + 0.3 * sin(Float(i) * 2.1)
            let e = ModelEntity(mesh: leafMesh, materials: [leaf[i % 3]])
            e.position = [r * cos(a), y, r * sin(a)]
            e.scale = [size, size * 0.2, size * 0.62]
            // Blatt zeigt nach außen und hängt leicht nach unten
            e.orientation = simd_quatf(angle: -a, axis: [0, 1, 0]) * simd_quatf(angle: -0.1 - 0.4 * (1 - t), axis: [0, 0, 1])
            e.position += SIMD3<Float>(cos(a), 0, sin(a)) * 0.08 * size
            plant.addChild(e)
        }
    }
}
