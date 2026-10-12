import RealityKit
import UIKit
import simd

// Gym-Raum für die Übungsansicht: Boden, Wände, Decke, Lichter und Geräte (Bank, Kabelturm, Klimmzug-/Kniebeugen-Gestell,
// Hantelablage, Matte). Alles in Metern, der Körper steht bei (0,0,0) und schaut nach +z. Der Raum ist statisch,
// die Kamera kreist um den Körper. Reine Optik – austauschbar, ohne die Körperdateien anzufassen.

/// Aufbau je Bewegung (Kabelturm, Gestelle, Matte, Kamera)
struct GymLayout {
    /// Höhe der Umlenkrolle am Kabelturm; nil = kein Kabelturm (dann Kurzhanteln)
    var cableHeight: Float? = nil
    var pullRig = false
    var squatRack = false
    var mat = false
    /// Überschreibt die Kamerarichtung der Bewegung
    var yaw: Float? = nil
    var fov: Float = 36
    var radius: Float = 3.0

    static func forMotion(_ m: BodyMotion, def: Motion, gear: PropGear = .auto) -> GymLayout {
        var l = GymLayout()
        let wantsCable = gear == .cable ? (def.props == .dumbbell && !def.lying && !def.free)
                                        : (gear == .auto && (m == .curl || m == .lateral))
        if wantsCable {
            l.cableHeight = 0.22
            l.yaw = 1.45
            l.fov = 48
            l.radius = 3.2
        }
        switch m {
        case .squatBar, .squatDb:
            l.squatRack = m == .squatBar
        case .curl, .lateral:
            break
        case .pullup, .hang, .legRaise:
            l.pullRig = true
        case .squat, .deepSquat:
            l.squatRack = true
        default:
            break
        }
        if def.free || (def.lying && !def.bench) { l.mat = true }
        if (def.lying || def.free) && l.cableHeight == nil { l.radius = 2.4 }
        return l
    }
}

enum GymTex {
    static func make(_ w: Int, _ h: Int, _ draw: (CGContext, CGSize) -> Void) -> TextureResource? {
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 1
        fmt.opaque = true
        let r = UIGraphicsImageRenderer(size: CGSize(width: w, height: h), format: fmt)
        let img = r.image { ctx in draw(ctx.cgContext, CGSize(width: w, height: h)) }
        guard let cg = img.cgImage else { return nil }
        return try? TextureResource.generate(from: cg, withName: nil, options: .init(semantic: .color))
    }

    static func mat(_ tex: TextureResource?, color: UIColor = .white, rough: Float = 0.8, metal: Float = 0) -> PhysicallyBasedMaterial {
        var m = PhysicallyBasedMaterial()
        if let t = tex {
            m.baseColor = .init(tint: color, texture: .init(t))
        } else {
            m.baseColor = .init(tint: color)
        }
        m.roughness = .init(floatLiteral: rough)
        m.metallic = .init(floatLiteral: metal)
        return m
    }

    static func steel(_ white: CGFloat = 0.55) -> SimpleMaterial {
        SimpleMaterial(color: UIColor(white: white, alpha: 1), roughness: 0.35, isMetallic: true)
    }
    static func paint(_ c: UIColor, rough: Float = 0.5) -> SimpleMaterial {
        SimpleMaterial(color: c, roughness: .init(floatLiteral: rough), isMetallic: false)
    }
}

final class GymRoom {
    let root = Entity()
    private(set) var layout = GymLayout()

    private let tower = Entity()
    private let pullRig = Entity()
    private let squatRack = Entity()
    private let mat = ModelEntity()
    private var handles: [Entity] = []
    private var cables: [ModelEntity] = []
    private let pulleyX: Float = 0.72
    private let towerZ: Float = 1.10

    init() {
        buildRoom()
        buildLights()
        buildTower()
        buildPullRig()
        buildSquatRack()
        buildDumbbellRack()
        buildMat()
        tower.isEnabled = false
        pullRig.isEnabled = false
        squatRack.isEnabled = false
        mat.isEnabled = false
        root.addChild(tower); root.addChild(pullRig); root.addChild(squatRack); root.addChild(mat)
    }

    func setLayout(_ l: GymLayout) {
        layout = l
        pullRig.isEnabled = l.pullRig
        squatRack.isEnabled = l.squatRack
        mat.isEnabled = l.mat
        tower.isEnabled = l.cableHeight != nil
        if let h = l.cableHeight {
            for k in 0..<2 {
                pulleys[k].position = [k == 0 ? -pulleyX : pulleyX, h, towerZ - 0.12]
            }
        }
    }

    private var pulleys: [Entity] = []

    // MARK: Raum

    private func box(_ size: SIMD3<Float>, _ pos: SIMD3<Float>, _ m: Material, corner: Float = 0, parent: Entity? = nil) -> ModelEntity {
        let e = ModelEntity(mesh: .generateBox(size: size, cornerRadius: corner), materials: [m])
        e.position = pos
        (parent ?? root).addChild(e)
        return e
    }

    private func buildRoom() {
        let half: Float = 4.0, hgt: Float = 3.4
        // Boden: dunkler Gummi mit 1-m-Fugen
        let floorTex = GymTex.make(1024, 1024) { c, s in
            UIColor(white: 0.17, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            for _ in 0..<9000 {
                let g = CGFloat.random(in: 0.10...0.26)
                UIColor(white: g, alpha: 1).setFill()
                c.fill(CGRect(x: CGFloat.random(in: 0..<s.width), y: CGFloat.random(in: 0..<s.height), width: 3, height: 3))
            }
            UIColor(white: 0.07, alpha: 1).setStroke(); c.setLineWidth(5)
            let n = 8
            for i in 0...n {
                let p = s.width * CGFloat(i) / CGFloat(n)
                c.move(to: CGPoint(x: p, y: 0)); c.addLine(to: CGPoint(x: p, y: s.height))
                c.move(to: CGPoint(x: 0, y: p)); c.addLine(to: CGPoint(x: s.width, y: p))
            }
            c.strokePath()
        }
        _ = box([half * 2 + 0.2, 0.1, half * 2 + 0.2], [0, -0.05, 0], GymTex.mat(floorTex, rough: 0.85))

        // Decke mit Platten
        let ceilTex = GymTex.make(1024, 1024) { c, s in
            UIColor(white: 0.80, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            UIColor(white: 0.58, alpha: 1).setStroke(); c.setLineWidth(4)
            let n = 8
            for i in 0...n {
                let p = s.width * CGFloat(i) / CGFloat(n)
                c.move(to: CGPoint(x: p, y: 0)); c.addLine(to: CGPoint(x: p, y: s.height))
                c.move(to: CGPoint(x: 0, y: p)); c.addLine(to: CGPoint(x: s.width, y: p))
            }
            c.strokePath()
        }
        _ = box([half * 2 + 0.2, 0.1, half * 2 + 0.2], [0, hgt + 0.05, 0], GymTex.mat(ceilTex, rough: 0.95))
        // Stahlträger
        for z: Float in [-2.2, 0.0, 2.2] {
            _ = box([half * 2, 0.22, 0.14], [0, hgt - 0.11, z], GymTex.steel(0.30))
        }

        // Wände: dunkles Paneel unten, helle Wand oben, rote Zierleiste
        func wallTex(logo: Bool, mirror: Bool) -> TextureResource? {
            GymTex.make(2048, 870) { c, s in
                UIColor(white: 0.88, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
                let wain = s.height * 0.36
                UIColor(red: 0.16, green: 0.18, blue: 0.22, alpha: 1).setFill()
                c.fill(CGRect(x: 0, y: s.height - wain, width: s.width, height: wain))
                UIColor(red: 0.85, green: 0.16, blue: 0.14, alpha: 1).setFill()
                c.fill(CGRect(x: 0, y: s.height - wain - 14, width: s.width, height: 14))
                UIColor(white: 0.70, alpha: 1).setStroke(); c.setLineWidth(3)
                for i in 0...8 {
                    let x = s.width * CGFloat(i) / 8
                    c.move(to: CGPoint(x: x, y: 0)); c.addLine(to: CGPoint(x: x, y: s.height - wain - 14))
                }
                c.strokePath()
                if mirror {
                    let r = CGRect(x: s.width * 0.12, y: s.height * 0.10, width: s.width * 0.76, height: s.height * 0.78)
                    let cs = CGColorSpaceCreateDeviceRGB()
                    let g = CGGradient(colorsSpace: cs, colors: [UIColor(red: 0.62, green: 0.72, blue: 0.80, alpha: 1).cgColor,
                                                                UIColor(red: 0.25, green: 0.33, blue: 0.40, alpha: 1).cgColor] as CFArray, locations: [0, 1])!
                    c.saveGState(); c.clip(to: r)
                    c.drawLinearGradient(g, start: CGPoint(x: r.minX, y: r.minY), end: CGPoint(x: r.maxX, y: r.maxY), options: [])
                    UIColor(white: 1, alpha: 0.14).setFill()
                    c.fill(CGRect(x: r.minX + r.width * 0.15, y: r.minY, width: r.width * 0.07, height: r.height))
                    c.fill(CGRect(x: r.minX + r.width * 0.30, y: r.minY, width: r.width * 0.02, height: r.height))
                    c.restoreGState()
                    UIColor(white: 0.12, alpha: 1).setStroke(); c.setLineWidth(10); c.stroke(r)
                    UIColor(white: 0.12, alpha: 1).setStroke(); c.setLineWidth(6)
                    for i in 1..<4 {
                        let x = r.minX + r.width * CGFloat(i) / 4
                        c.move(to: CGPoint(x: x, y: r.minY)); c.addLine(to: CGPoint(x: x, y: r.maxY))
                    }
                    c.strokePath()
                }
                if logo {
                    let para = NSMutableParagraphStyle(); para.alignment = .center
                    let a: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 120, weight: .black),
                                                           .foregroundColor: UIColor(red: 0.85, green: 0.16, blue: 0.14, alpha: 1),
                                                           .paragraphStyle: para, .kern: 12]
                    ("BODYFORMANCE" as NSString).draw(in: CGRect(x: 0, y: s.height * 0.12, width: s.width, height: 200), withAttributes: a)
                    let b: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 56, weight: .bold),
                                                           .foregroundColor: UIColor(white: 0.25, alpha: 1), .paragraphStyle: para, .kern: 6]
                    ("TRAIN  ·  MOVE  ·  RECOVER" as NSString).draw(in: CGRect(x: 0, y: s.height * 0.12 + 190, width: s.width, height: 80), withAttributes: b)
                }
            }
        }
        let back = GymTex.mat(wallTex(logo: true, mirror: false), rough: 0.9)
        let side = GymTex.mat(wallTex(logo: false, mirror: false), rough: 0.9)
        let mir = GymTex.mat(wallTex(logo: false, mirror: true), rough: 0.35)
        _ = box([half * 2 + 0.2, hgt, 0.1], [0, hgt / 2, -half - 0.05], back)
        _ = box([half * 2 + 0.2, hgt, 0.1], [0, hgt / 2, half + 0.05], side)
        _ = box([0.1, hgt, half * 2], [half + 0.05, hgt / 2, 0], side)
        _ = box([0.1, hgt, half * 2], [-half - 0.05, hgt / 2, 0], mir)
        // Fußleiste
        _ = box([half * 2, 0.10, 0.03], [0, 0.05, -half + 0.015], GymTex.paint(UIColor(white: 0.1, alpha: 1)))
    }

    private func buildLights() {
        let panel = UnlitMaterial(color: UIColor(red: 1.0, green: 0.97, blue: 0.90, alpha: 1))
        for x: Float in [-1.8, 1.8] {
            for z: Float in [-1.8, 1.8] {
                _ = box([1.3, 0.04, 0.28], [x, 3.30, z], panel)
                let p = PointLight()
                p.light.intensity = 90000
                p.light.attenuationRadius = 12
                p.light.color = UIColor(red: 1.0, green: 0.96, blue: 0.90, alpha: 1)
                p.position = [x, 3.15, z]
                root.addChild(p)
            }
        }
        let key = DirectionalLight()
        key.light.intensity = 2200
        key.shadow = DirectionalLightComponent.Shadow(maximumDistance: 8, depthBias: 2)
        key.look(at: .zero, from: [1.6, 3.0, 2.2], relativeTo: nil)
        root.addChild(key)
        let fill = DirectionalLight()
        fill.light.intensity = 1100
        fill.look(at: .zero, from: [-2.0, 1.6, -2.5], relativeTo: nil)
        root.addChild(fill)
    }

    // MARK: Geräte

    private func buildTower() {
        let frame = GymTex.paint(UIColor(white: 0.14, alpha: 1), rough: 0.4)
        let red = GymTex.paint(UIColor(red: 0.80, green: 0.12, blue: 0.10, alpha: 1), rough: 0.4)
        let plateTex = GymTex.make(256, 512) { c, s in
            UIColor(white: 0.30, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            UIColor(white: 0.12, alpha: 1).setStroke(); c.setLineWidth(3)
            for i in 0...16 {
                let y = s.height * CGFloat(i) / 16
                c.move(to: CGPoint(x: 0, y: y)); c.addLine(to: CGPoint(x: s.width, y: y))
            }
            c.strokePath()
        }
        let stack = GymTex.mat(plateTex, rough: 0.5, metal: 0.6)
        let z = towerZ + 0.10
        for sx: Float in [-1, 1] {
            let x = sx * (pulleyX + 0.10)
            _ = box([0.18, 2.5, 0.18], [x, 1.25, z], frame, corner: 0.01, parent: tower)
            _ = box([0.30, 1.4, 0.22], [x, 0.78, z + 0.20], stack, corner: 0.01, parent: tower)
            _ = box([0.34, 0.06, 0.95], [x, 0.03, z + 0.18], frame, corner: 0.01, parent: tower)
            _ = box([0.20, 0.10, 0.20], [x, 2.55, z], red, corner: 0.01, parent: tower)
        }
        _ = box([pulleyX * 2 + 0.38, 0.14, 0.20], [0, 2.42, z], frame, corner: 0.01, parent: tower)
        _ = box([pulleyX * 2 + 0.38, 0.05, 0.21], [0, 2.30, z], red, parent: tower)

        // Umlenkrollen (werden in setLayout auf die Höhe gesetzt)
        let alu = GymTex.steel(0.75)
        for k in 0..<2 {
            let p = Entity()
            let wheel = ModelEntity(mesh: .generateCylinder(height: 0.025, radius: 0.06), materials: [alu])
            wheel.orientation = simd_quatf(angle: .pi / 2, axis: [0, 0, 1])
            p.addChild(wheel)
            let blk = ModelEntity(mesh: .generateBox(size: [0.07, 0.13, 0.09], cornerRadius: 0.01), materials: [frame])
            blk.position = [0, 0, 0.06]
            p.addChild(blk)
            p.position = [k == 0 ? -pulleyX : pulleyX, 0.22, towerZ - 0.12]
            tower.addChild(p)
            pulleys.append(p)
        }
        // Griffe und Seile
        let handleMat = GymTex.steel(0.6)
        let rubber = GymTex.paint(UIColor(white: 0.08, alpha: 1), rough: 0.9)
        for _ in 0..<2 {
            let h = Entity()
            h.addChild(ModelEntity(mesh: .generateCylinder(height: 0.13, radius: 0.0125), materials: [rubber]))
            for y: Float in [-0.068, 0.068] {
                let cap = ModelEntity(mesh: .generateCylinder(height: 0.012, radius: 0.024), materials: [handleMat])
                cap.position = [0, y, 0]
                h.addChild(cap)
            }
            h.isEnabled = true
            tower.addChild(h)
            handles.append(h)
            let cable = ModelEntity(mesh: .generateCylinder(height: 1, radius: 0.0035), materials: [GymTex.paint(UIColor(white: 0.05, alpha: 1), rough: 0.6)])
            tower.addChild(cable)
            cables.append(cable)
        }
    }

    /// Setzt die Griffe auf die Hantelpositionen und spannt die Seile von den Rollen
    func updateCables(_ props: [(SIMD3<Float>, simd_quatf)]) {
        guard layout.cableHeight != nil else { return }
        for k in 0..<min(2, props.count) {
            let (p, q) = props[k]
            handles[k].position = p
            handles[k].orientation = q
            let a = pulleys[p.x < 0 ? 0 : 1].position + SIMD3<Float>(0, 0, -0.04)
            let d = p - a
            let len = max(simd_length(d), 0.01)
            cables[k].position = a + d * 0.5
            cables[k].scale = [1, len, 1]
            cables[k].orientation = simd_quatf(from: [0, 1, 0], to: d / len)
        }
    }

    private func buildPullRig() {
        let frame = GymTex.paint(UIColor(white: 0.14, alpha: 1), rough: 0.4)
        for sx: Float in [-1, 1] {
            let x = sx * 0.72
            _ = box([0.09, 2.30, 0.09], [x, 1.15, 0.05], frame, corner: 0.01, parent: pullRig)
            _ = box([0.09, 0.05, 0.9], [x, 0.025, 0.05], frame, parent: pullRig)
            _ = box([0.07, 0.07, 0.4], [x, 2.25, -0.15], frame, parent: pullRig)
        }
        _ = box([1.5, 0.07, 0.07], [0, 2.25, -0.35], frame, parent: pullRig)
    }

    private func buildSquatRack() {
        let frame = GymTex.paint(UIColor(white: 0.14, alpha: 1), rough: 0.4)
        let red = GymTex.paint(UIColor(red: 0.80, green: 0.12, blue: 0.10, alpha: 1), rough: 0.4)
        let z: Float = -0.95
        for sx: Float in [-1, 1] {
            let x = sx * 0.65
            _ = box([0.10, 2.30, 0.10], [x, 1.15, z], frame, corner: 0.01, parent: squatRack)
            _ = box([0.10, 0.05, 1.0], [x, 0.025, z + 0.25], frame, parent: squatRack)
            _ = box([0.10, 0.05, 0.12], [x, 1.40, z + 0.10], red, parent: squatRack)
        }
        _ = box([1.50, 0.06, 0.06], [0, 2.28, z], frame, parent: squatRack)
        for sx: Float in [-1, 1] {
            let plate = ModelEntity(mesh: .generateCylinder(height: 0.04, radius: 0.225), materials: [GymTex.paint(UIColor(white: 0.1, alpha: 1))])
            plate.orientation = simd_quatf(angle: .pi / 2, axis: [0, 0, 1])
            plate.position = [sx * 0.88, 1.46, z + 0.10]
            squatRack.addChild(plate)
        }
    }

    /// Hantelablage an der Rückwand (Deko)
    private func buildDumbbellRack() {
        let frame = GymTex.paint(UIColor(white: 0.14, alpha: 1), rough: 0.4)
        let dark = SimpleMaterial(color: UIColor(white: 0.16, alpha: 1), roughness: 0.5, isMetallic: true)
        let rack = Entity()
        rack.position = [1.7, 0, -3.5]
        root.addChild(rack)
        _ = box([2.2, 0.06, 0.55], [0, 0.65, 0], frame, parent: rack)
        _ = box([2.2, 0.06, 0.55], [0, 0.20, 0], frame, parent: rack)
        for x: Float in [-1.05, 0, 1.05] { _ = box([0.07, 0.85, 0.5], [x, 0.42, 0], frame, parent: rack) }
        let proto = Entity()
        proto.addChild(ModelEntity(mesh: .generateCylinder(height: 0.30, radius: 0.012), materials: [dark]))
        for y: Float in [-0.11, 0.11] {
            let plate = ModelEntity(mesh: .generateCylinder(height: 0.07, radius: 0.06), materials: [dark])
            plate.position = [0, y, 0]
            proto.addChild(plate)
        }
        proto.orientation = simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
        for (row, y) in [Float(0.74), 0.29].enumerated() {
            for i in 0..<8 {
                let d = proto.clone(recursive: true)
                let s = 1.0 - 0.06 * Float(i % 4) - Float(row) * 0.0
                d.scale = [s, 1, s]
                d.position = [-0.95 + Float(i) * 0.27, y, 0]
                rack.addChild(d)
            }
        }
        // Hantelscheiben-Baum und Kettlebells an der Seite
        let tree = Entity()
        tree.position = [-0.9, 0, -3.5]
        root.addChild(tree)
        _ = box([0.5, 0.05, 0.5], [0, 0.025, 0], frame, parent: tree)
        let pole = ModelEntity(mesh: .generateCylinder(height: 1.3, radius: 0.025), materials: [frame])
        pole.position = [0, 0.65, 0]
        tree.addChild(pole)
        for i in 0..<5 {
            let pl = ModelEntity(mesh: .generateCylinder(height: 0.04, radius: 0.2 - 0.01 * Float(i)), materials: [dark])
            pl.position = [0, 0.12 + 0.085 * Float(i), 0]
            tree.addChild(pl)
        }
    }

    private func buildMat() {
        mat.model = ModelComponent(mesh: .generateBox(size: [0.95, 0.025, 2.3], cornerRadius: 0.01),
                                   materials: [GymTex.paint(UIColor(red: 0.18, green: 0.30, blue: 0.52, alpha: 1), rough: 0.8)])
        mat.position = [0, 0.0125, 0]
    }
}
