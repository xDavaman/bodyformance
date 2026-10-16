import RealityKit
import UIKit
import simd

// Gym-Raum für die Übungsansicht: Boden, Wände, Decke, Lichter und Geräte (Aussehen des Raums: GymLook.swift). Alles in Metern, der Körper steht bei (0,0,0)
// und schaut nach +z. Der Raum ist statisch, die Kamera kreist um den Körper. Reine Optik – austauschbar, ohne die
// Körperdateien anzufassen.
//
// Funktionale Geräte (je Übung ein- und ausgeblendet): Kabelturm (unten, oben, Kabel-Crossover), Bankdrück-Ständer,
// Klimmzug-Gestell, Kniebeugen-Ständer, Matte. Die Bank selbst gehört zum Körper-Rig (BodyRig.bench), weil ihre
// Höhe zu den Bewegungsdaten passen muss.
// Deko (immer sichtbar, an den Wänden, außerhalb der Kamerabahn): Kurzhantel-Ablage mit 10 Paaren, Kettlebells,
// Scheibenbaum, Power-Rack mit Langhantel, Kabelzug-Station, Hantelbänke, Langhantel-Halter.
// In der Studio-Ansicht (GymExplore.swift) sind diese Geräte antippbar und kommen weitere dazu.

/// Wo die Umlenkrollen am Kabelturm sitzen
enum CableSetup: Equatable {
    /// Zwei Rollen vor dem Körper, links und rechts (Curls, Seitheben, Frontheben …)
    case sides
    /// Eine Doppelrolle mittig vor dem Körper (Trizepsdrücken, Face Pulls)
    case center
    /// Zwei hohe Rollen seitlich neben dem Körper (Kabel-Crossover / Cable Fly)
    case crossover
}

/// Aufbau je Bewegung (Kabelturm, Gestelle, Matte, Kamera)
struct GymLayout {
    /// Höhe der Umlenkrolle am Kabelturm; nil = kein Kabelturm (dann Kurzhanteln)
    var cableHeight: Float? = nil
    var cableSetup: CableSetup = .sides
    var pullRig = false
    var squatRack = false
    /// Ablage-Ständer für die Langhantel am Kopfende der Bank
    var benchRack = false
    var mat = false
    /// Überschreibt die Kamerarichtung der Bewegung
    var yaw: Float? = nil
    var fov: Float = 36
    var radius: Float = 3.0

    static func forMotion(_ m: BodyMotion, def: Motion, gear: PropGear = .auto) -> GymLayout {
        var l = GymLayout()
        // Reine Kabelübungen stehen immer am Kabelturm, egal welches Gerät die Übung angibt
        let cableOnly: Set<BodyMotion> = [.pushdown, .facePull, .flyCable]
        let wantsCable = cableOnly.contains(m)
            || (gear == .cable ? (def.props == .dumbbell && !def.lying && !def.free)
                               : (gear == .auto && (m == .curl || m == .lateral)))
        if wantsCable {
            switch m {
            case .pushdown:
                l.cableSetup = .center; l.cableHeight = 2.05
            case .facePull:
                l.cableSetup = .center; l.cableHeight = 1.62
            case .flyCable:
                l.cableSetup = .crossover; l.cableHeight = 2.0
            default:
                l.cableSetup = .sides; l.cableHeight = 0.22
            }
            l.yaw = l.cableSetup == .crossover ? 0.45 : 1.45
            l.fov = 48
            l.radius = 3.2
        }
        switch m {
        case .squatBar:
            l.squatRack = true
        case .pullup, .hang, .legRaise:
            l.pullRig = true
        case .squat, .deepSquat:
            l.squatRack = true
        case .benchBar:
            l.benchRack = true
        default:
            break
        }
        if def.free || (def.lying && !def.bench) { l.mat = true }
        if (def.lying || def.free) && l.cableHeight == nil { l.radius = 2.4 }
        return l
    }
}

enum GymTex {
    /// Einmal erzeugte Texturen (Boden, Wände …) werden von allen 3D-Ansichten geteilt
    private static var cache: [String: TextureResource] = [:]

    static func make(_ w: Int, _ h: Int, key: String? = nil, _ draw: (CGContext, CGSize) -> Void) -> TextureResource? {
        if let key, let t = cache[key] { return t }
        let t = render(w, h, draw)
        if let key, let t { cache[key] = t }
        return t
    }

    private static func render(_ w: Int, _ h: Int, _ draw: (CGContext, CGSize) -> Void) -> TextureResource? {
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
    static let brandRed = UIColor(red: 0.80, green: 0.12, blue: 0.10, alpha: 1)
    static let frameBlack = UIColor(white: 0.14, alpha: 1)
}

/// Bausteine für Geräte, die an mehreren Stellen gebraucht werden (Bank, Kurzhantel, Kettlebell, Langhantel).
enum GymProps {
    @discardableResult
    static func box(_ size: SIMD3<Float>, _ pos: SIMD3<Float>, _ m: Material, corner: Float = 0, parent: Entity) -> ModelEntity {
        let e = ModelEntity(mesh: .generateBox(size: size, cornerRadius: corner), materials: [m])
        e.position = pos
        parent.addChild(e)
        return e
    }

    /// Zylinder, dessen Achse entlang `axis` liegt (Standard: y)
    @discardableResult
    static func cylinder(_ h: Float, _ r: Float, _ pos: SIMD3<Float>, _ m: Material, axis: SIMD3<Float> = [0, 1, 0], parent: Entity) -> ModelEntity {
        let e = ModelEntity(mesh: .generateCylinder(height: h, radius: r), materials: [m])
        e.position = pos
        if axis != [0, 1, 0] { e.orientation = simd_quatf(from: [0, 1, 0], to: simd_normalize(axis)) }
        parent.addChild(e)
        return e
    }

    /// Hantelbank: gepolsterte Rücken- und Sitzfläche (Oberkante 0,30 m), Stahlrahmen, Füße mit Gummikappen,
    /// Transportrollen und Griff am Fußende. Liegt entlang z, Kopfende bei -z. `incline` stellt die Rückenlehne schräg (Deko).
    static func bench(incline: Float = 0) -> Entity {
        let e = Entity()
        let vinyl = SimpleMaterial(color: UIColor(white: 0.09, alpha: 1), roughness: 0.6, isMetallic: false)
        let seam = SimpleMaterial(color: GymTex.brandRed, roughness: 0.5, isMetallic: false)
        let steel = SimpleMaterial(color: UIColor(white: 0.16, alpha: 1), roughness: 0.35, isMetallic: true)
        let chrome = GymTex.steel(0.75)
        let rubber = GymTex.paint(UIColor(white: 0.05, alpha: 1), rough: 0.9)
        let top: Float = 0.30, padH: Float = 0.07

        // Rückenpolster (z -0.83 … -0.02), optional schräg gestellt
        let back = Entity()
        back.position = [0, top - padH / 2, -0.02]
        e.addChild(back)
        box([0.30, padH, 0.81], [0, 0, -0.405], vinyl, corner: 0.03, parent: back)
        box([0.302, 0.006, 0.79], [0, -padH / 2 + 0.008, -0.405], seam, parent: back)
        box([0.24, 0.035, 0.70], [0, -padH / 2 - 0.02, -0.40], steel, corner: 0.005, parent: back)
        if incline > 0 { back.orientation = simd_quatf(angle: incline, axis: [1, 0, 0]) }

        // Sitzpolster (z 0 … 0.42)
        box([0.30, padH, 0.42], [0, top - padH / 2, 0.21], vinyl, corner: 0.03, parent: e)
        box([0.302, 0.006, 0.40], [0, top - padH + 0.008, 0.21], seam, parent: e)

        // Rahmen: Mittelholm, zwei Stützen, Verstellleiter
        box([0.07, 0.07, 1.10], [0, 0.17, -0.20], steel, corner: 0.008, parent: e)
        box([0.06, 0.17, 0.06], [0, 0.085, 0.30], steel, corner: 0.006, parent: e)
        box([0.06, 0.17, 0.06], [0, 0.085, -0.68], steel, corner: 0.006, parent: e)
        for k in 0..<5 {
            box([0.09, 0.012, 0.03], [0, 0.215, -0.55 + Float(k) * 0.07], chrome, parent: e)
        }
        // Füße mit Gummikappen
        for z: Float in [0.30, -0.68] {
            box([0.50, 0.045, 0.07], [0, 0.0225, z], steel, corner: 0.008, parent: e)
            for x: Float in [-0.25, 0.25] {
                box([0.04, 0.05, 0.075], [x, 0.025, z], rubber, corner: 0.01, parent: e)
            }
        }
        // Rollen und Griff am Fußende
        for x: Float in [-0.20, 0.20] {
            cylinder(0.03, 0.035, [x, 0.035, 0.36], rubber, axis: [1, 0, 0], parent: e)
        }
        cylinder(0.28, 0.012, [0, 0.10, 0.40], chrome, axis: [1, 0, 0], parent: e)
        return e
    }

    /// Sechskant-Kurzhantel (Kopfgröße wächst mit dem Gewicht), Achse = y
    static func dumbbell(scale s: Float, accent: UIColor? = nil) -> Entity {
        let e = Entity()
        let rubber = SimpleMaterial(color: UIColor(white: 0.10, alpha: 1), roughness: 0.75, isMetallic: false)
        let chrome = GymTex.steel(0.78)
        let head = 0.075 * s, len = 0.045 + 0.035 * s
        cylinder(0.14, 0.0135, .zero, chrome, parent: e)
        for sy: Float in [-1, 1] {
            box([head, len, head], [0, sy * (0.07 + len / 2), 0], rubber, corner: head * 0.18, parent: e)
            if let accent {
                cylinder(0.008, head * 0.36, [0, sy * (0.07 + 0.004), 0], GymTex.paint(accent, rough: 0.4), parent: e)
            }
        }
        return e
    }

    static func kettlebell(scale s: Float, color: UIColor) -> Entity {
        let e = Entity()
        let iron = SimpleMaterial(color: color, roughness: 0.55, isMetallic: true)
        let r = 0.085 * s
        let ball = ModelEntity(mesh: .generateSphere(radius: r), materials: [iron])
        ball.position = [0, r * 0.92, 0]
        e.addChild(ball)
        box([r * 1.1, 0.02, r * 1.1], [0, 0.01, 0], iron, corner: 0.008, parent: e)
        for sx: Float in [-1, 1] {
            cylinder(r * 0.9, 0.012 * s, [sx * r * 0.55, r * 1.85, 0], iron, parent: e)
        }
        cylinder(r * 1.25, 0.013 * s, [0, r * 2.3, 0], iron, axis: [1, 0, 0], parent: e)
        return e
    }

    /// Langhantel 2,2 m mit Scheiben, Achse = x
    static func barbell(plates: Int = 2) -> Entity {
        let e = Entity()
        let steel = GymTex.steel(0.72)
        let plate = SimpleMaterial(color: UIColor(white: 0.10, alpha: 1), roughness: 0.5, isMetallic: false)
        let red = GymTex.paint(GymTex.brandRed)
        cylinder(2.2, 0.014, .zero, steel, axis: [1, 0, 0], parent: e)
        for s: Float in [-1, 1] {
            cylinder(0.40, 0.025, [s * 0.80, 0, 0], steel, axis: [1, 0, 0], parent: e)
            for k in 0..<plates {
                cylinder(0.04, k == 0 ? 0.225 : 0.17, [s * (0.62 + Float(k) * 0.045), 0, 0], k == 0 ? red : plate, axis: [1, 0, 0], parent: e)
            }
        }
        return e
    }
}

final class GymRoom {
    let root = Entity()
    private(set) var layout = GymLayout()

    private let tower = Entity()
    private let towerSide = [Entity(), Entity()]
    private let towerBeam = Entity()
    private let towerCenter = Entity()
    private let pullRig = Entity()
    private let squatRack = Entity()
    private let benchRack = Entity()
    private let mat = ModelEntity()
    private var handles: [Entity] = []
    private var cables: [ModelEntity] = []
    private var pulleys: [Entity] = []
    private let pulleyX: Float = 0.72
    private let towerZ: Float = 1.10
    /// Geräte, die man in der Studio-Ansicht antippen kann (Wurzel-Entity je Station)
    private(set) var stations: [(GymStation, Entity)] = []
    /// Kabelturm von außen (für die Studio-Ansicht)
    var cableTower: Entity { tower }

    func register(_ e: Entity, as station: GymStation) {
        stations.append((station, e))
    }

    init() {
        buildInterior()
        buildLighting()
        buildTower()
        buildBenchRack()
        buildPullRig()
        buildSquatRack()
        buildDecor()
        buildDecorations()
        buildMat()
        for e in [tower, pullRig, squatRack, benchRack] { e.isEnabled = false; root.addChild(e) }
        mat.isEnabled = false
        root.addChild(mat)
    }

    func setLayout(_ l: GymLayout) {
        layout = l
        pullRig.isEnabled = l.pullRig
        squatRack.isEnabled = l.squatRack
        benchRack.isEnabled = l.benchRack
        mat.isEnabled = l.mat
        tower.isEnabled = l.cableHeight != nil
        guard let h = l.cableHeight else { return }
        switch l.cableSetup {
        case .sides:
            towerSide[0].position = [-(pulleyX + 0.10), 0, towerZ + 0.10]
            towerSide[1].position = [pulleyX + 0.10, 0, towerZ + 0.10]
            towerBeam.isEnabled = true
            towerCenter.isEnabled = false
            for k in 0..<2 { pulleys[k].position = [k == 0 ? -pulleyX : pulleyX, h, towerZ - 0.12] }
        case .center:
            towerSide[0].position = [-(pulleyX + 0.10), 0, towerZ + 0.10]
            towerSide[1].position = [pulleyX + 0.10, 0, towerZ + 0.10]
            towerBeam.isEnabled = true
            towerCenter.isEnabled = true
            // Doppelrolle am Mittelholm, Seile laufen zum Griff (Seilgriff / Stange)
            for k in 0..<2 { pulleys[k].position = [k == 0 ? -0.06 : 0.06, h, 0.62] }
            towerCenter.position = [0, 0, 0.72]
        case .crossover:
            // Zwei Säulen links und rechts, leicht hinter dem Körper
            towerSide[0].position = [-1.18, 0, -0.10]
            towerSide[1].position = [1.18, 0, -0.10]
            towerBeam.isEnabled = false
            towerCenter.isEnabled = false
            for k in 0..<2 { pulleys[k].position = [k == 0 ? -1.04 : 1.04, h, -0.10] }
        }
        for k in 0..<2 {
            // Rolle zeigt zur Körpermitte
            pulleys[k].orientation = l.cableSetup == .crossover ? simd_quatf(angle: .pi / 2, axis: [0, 1, 0]) : simd_quatf(angle: 0, axis: [0, 1, 0])
        }
    }

    // MARK: Raum

    @discardableResult
    private func box(_ size: SIMD3<Float>, _ pos: SIMD3<Float>, _ m: Material, corner: Float = 0, parent: Entity? = nil) -> ModelEntity {
        GymProps.box(size, pos, m, corner: corner, parent: parent ?? root)
    }

    // MARK: Kabelturm

    /// Säule mit Gewichtsblock, Fuß und Abdeckkappe (lokal um x = 0 gebaut)
    private func buildColumn(_ parent: Entity, stack: Material, frame: Material, red: Material) {
        box([0.18, 2.5, 0.18], [0, 1.25, 0], frame, corner: 0.01, parent: parent)
        box([0.30, 1.4, 0.22], [0, 0.78, 0.20], stack, corner: 0.01, parent: parent)
        box([0.05, 1.5, 0.05], [0, 0.75, 0.32], GymTex.steel(0.7), parent: parent)
        box([0.34, 0.06, 0.95], [0, 0.03, 0.18], frame, corner: 0.01, parent: parent)
        box([0.20, 0.10, 0.20], [0, 2.55, 0], red, corner: 0.01, parent: parent)
        // Schild mit Gewichtsangabe
        box([0.16, 0.10, 0.01], [0, 1.62, 0.315], red, corner: 0.005, parent: parent)
    }

    private func buildTower() {
        let frame = GymTex.paint(GymTex.frameBlack, rough: 0.4)
        let red = GymTex.paint(GymTex.brandRed, rough: 0.4)
        let plateTex = GymTex.make(256, 512, key: "stack") { c, s in
            UIColor(white: 0.30, alpha: 1).setFill(); c.fill(CGRect(origin: .zero, size: s))
            UIColor(white: 0.12, alpha: 1).setStroke(); c.setLineWidth(3)
            for i in 0...16 {
                let y = s.height * CGFloat(i) / 16
                c.move(to: CGPoint(x: 0, y: y)); c.addLine(to: CGPoint(x: s.width, y: y))
            }
            c.strokePath()
        }
        let stack = GymTex.mat(plateTex, rough: 0.5, metal: 0.6)
        for k in 0..<2 {
            buildColumn(towerSide[k], stack: stack, frame: frame, red: red)
            towerSide[k].position = [k == 0 ? -(pulleyX + 0.10) : pulleyX + 0.10, 0, towerZ + 0.10]
            tower.addChild(towerSide[k])
        }
        // Querträger oben mit Klimmzuggriffen
        box([pulleyX * 2 + 0.38, 0.14, 0.20], [0, 2.42, towerZ + 0.10], frame, corner: 0.01, parent: towerBeam)
        box([pulleyX * 2 + 0.38, 0.05, 0.21], [0, 2.30, towerZ + 0.10], red, parent: towerBeam)
        for x: Float in [-0.45, 0.45] {
            GymProps.cylinder(0.32, 0.016, [x, 2.30, towerZ - 0.10], GymTex.steel(0.6), axis: [0, 0, 1], parent: towerBeam)
        }
        tower.addChild(towerBeam)
        // Mittelholm für Trizepsdrücken und Face Pulls
        box([0.12, 2.35, 0.12], [0, 1.175, 0], frame, corner: 0.01, parent: towerCenter)
        box([0.10, 0.10, 0.56], [0, 2.30, 0.24], frame, corner: 0.01, parent: towerCenter)
        box([0.40, 0.05, 0.40], [0, 0.025, 0], frame, corner: 0.01, parent: towerCenter)
        box([0.125, 0.04, 0.125], [0, 1.95, 0], red, parent: towerCenter)
        towerCenter.isEnabled = false
        tower.addChild(towerCenter)

        // Umlenkrollen (werden in setLayout auf Höhe und Platz gesetzt)
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
            tower.addChild(h)
            handles.append(h)
            let cable = ModelEntity(mesh: .generateCylinder(height: 1, radius: 0.0035), materials: [GymTex.paint(UIColor(white: 0.05, alpha: 1), rough: 0.6)])
            tower.addChild(cable)
            cables.append(cable)
        }
    }

    /// Setzt die Griffe auf die Handpositionen und spannt die Seile von den Rollen
    func updateCables(_ props: [(SIMD3<Float>, simd_quatf)]) {
        guard layout.cableHeight != nil else { return }
        for k in 0..<min(2, props.count) {
            let (p, q) = props[k]
            handles[k].position = p
            handles[k].orientation = q
            let pulley = pulleys[p.x < 0 ? 0 : 1].position
            let a = pulley + (layout.cableSetup == .sides ? SIMD3<Float>(0, 0, -0.04) : .zero)
            let d = p - a
            let len = max(simd_length(d), 0.01)
            cables[k].position = a + d * 0.5
            cables[k].scale = [1, len, 1]
            cables[k].orientation = simd_quatf(from: [0, 1, 0], to: d / len)
        }
    }

    // MARK: Gestelle

    /// Ablage für die Langhantel am Kopfende der Bank (Bankdrücken mit Langhantel)
    private func buildBenchRack() {
        let frame = GymTex.paint(GymTex.frameBlack, rough: 0.4)
        let red = GymTex.paint(GymTex.brandRed, rough: 0.4)
        let z: Float = -0.66
        for sx: Float in [-1, 1] {
            let x = sx * 0.56
            box([0.07, 1.30, 0.07], [x, 0.65, z], frame, corner: 0.008, parent: benchRack)
            box([0.07, 0.05, 0.60], [x, 0.025, z + 0.05], frame, corner: 0.008, parent: benchRack)
            // J-Haken auf Höhe der Hantel-Ablage
            box([0.07, 0.03, 0.10], [x, 1.02, z + 0.06], red, corner: 0.006, parent: benchRack)
            box([0.07, 0.07, 0.025], [x, 1.05, z + 0.11], red, corner: 0.006, parent: benchRack)
            // Sicherheitsablagen tiefer
            box([0.05, 0.03, 0.30], [x, 0.72, z + 0.18], GymTex.steel(0.55), parent: benchRack)
        }
        box([1.19, 0.05, 0.07], [0, 0.025, z - 0.22], frame, parent: benchRack)
    }

    private func buildPullRig() {
        let frame = GymTex.paint(GymTex.frameBlack, rough: 0.4)
        for sx: Float in [-1, 1] {
            let x = sx * 0.72
            box([0.09, 2.30, 0.09], [x, 1.15, 0.05], frame, corner: 0.01, parent: pullRig)
            box([0.09, 0.05, 0.9], [x, 0.025, 0.05], frame, parent: pullRig)
            box([0.07, 0.07, 0.4], [x, 2.25, -0.15], frame, parent: pullRig)
        }
        box([1.5, 0.07, 0.07], [0, 2.25, -0.35], frame, parent: pullRig)
    }

    private func buildSquatRack() {
        let frame = GymTex.paint(GymTex.frameBlack, rough: 0.4)
        let red = GymTex.paint(GymTex.brandRed, rough: 0.4)
        let z: Float = -0.95
        for sx: Float in [-1, 1] {
            let x = sx * 0.65
            box([0.10, 2.30, 0.10], [x, 1.15, z], frame, corner: 0.01, parent: squatRack)
            box([0.10, 0.05, 1.0], [x, 0.025, z + 0.25], frame, parent: squatRack)
            box([0.10, 0.05, 0.12], [x, 1.40, z + 0.10], red, parent: squatRack)
        }
        box([1.50, 0.06, 0.06], [0, 2.28, z], frame, parent: squatRack)
        for sx: Float in [-1, 1] {
            GymProps.cylinder(0.04, 0.225, [sx * 0.88, 1.46, z + 0.10], GymTex.paint(UIColor(white: 0.1, alpha: 1)), axis: [1, 0, 0], parent: squatRack)
        }
    }

    // MARK: Deko an den Wänden

    private func buildDecor() {
        buildDumbbellRack()
        buildKettlebells()
        buildPlateTree()
        buildPowerRack()
        buildCableStation()
        buildSpareBenches()
        buildBarbellHolder()
    }

    /// Zweistöckige Kurzhantel-Ablage an der Rückwand: 10 Paare von leicht bis schwer
    private func buildDumbbellRack() {
        let frame = GymTex.paint(GymTex.frameBlack, rough: 0.4)
        let rack = Entity()
        rack.position = [1.35, 0, -3.70]
        root.addChild(rack)
        register(rack, as: .dumbbells)
        let length: Float = 3.0
        // schräge Ablagen (zum Betrachter geneigt) und Seitenwangen
        for (y, tilt) in [(Float(0.78), Float(0.22)), (0.36, 0.12)] {
            let shelf = box([length, 0.04, 0.42], [0, y, 0], frame, corner: 0.006, parent: rack)
            shelf.orientation = simd_quatf(angle: tilt, axis: [1, 0, 0])
        }
        for x: Float in [-length / 2, 0, length / 2] {
            box([0.06, 0.88, 0.40], [x, 0.44, 0], frame, corner: 0.008, parent: rack)
        }
        let accents: [UIColor] = [.systemYellow, .systemGreen, .systemBlue, .systemRed, .systemOrange]
        for pair in 0..<10 {
            // obere Reihe: leichte Hanteln (Paare 0–4), untere Reihe: schwere (5–9)
            let row = pair < 5 ? 0 : 1
            let i = pair % 5
            let s = 0.70 + Float(pair) * 0.08
            let shelfTop: Float = (row == 0 ? 0.78 : 0.36) + 0.02
            let xBase = -length / 2 + 0.32 + Float(i) * (length - 0.64) / 4
            for k in 0..<2 {
                // Griff zeigt in die Tiefe der Ablage, wie im Studio
                let d = GymProps.dumbbell(scale: s, accent: accents[i])
                d.orientation = simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
                d.position = [xBase + (k == 0 ? -0.13 : 0.13), shelfTop + 0.0375 * s, 0]
                rack.addChild(d)
            }
        }
    }

    /// Kettlebells auf dem Boden an der Rückwand
    private func buildKettlebells() {
        let colors: [UIColor] = [.systemPink, .systemTeal, .systemYellow, .systemPurple, .systemGreen, .systemOrange]
        let group = Entity()
        root.addChild(group)
        for i in 0..<6 {
            let kb = GymProps.kettlebell(scale: 0.8 + Float(i) * 0.08, color: colors[i].withAlphaComponent(1))
            kb.position = [-3.35 + Float(i) * 0.30, 0, -3.70]
            group.addChild(kb)
        }
        register(group, as: .kettlebells)
    }

    /// Hantelscheiben-Baum
    private func buildPlateTree() {
        let frame = GymTex.paint(GymTex.frameBlack, rough: 0.4)
        let dark = SimpleMaterial(color: UIColor(white: 0.16, alpha: 1), roughness: 0.5, isMetallic: true)
        let tree = Entity()
        tree.position = [-0.65, 0, -3.65]
        root.addChild(tree)
        register(tree, as: .barbellRack)
        box([0.55, 0.05, 0.55], [0, 0.025, 0], frame, parent: tree)
        GymProps.cylinder(1.3, 0.025, [0, 0.65, 0], frame, parent: tree)
        for (k, y) in [Float(0.35), 0.70, 1.05].enumerated() {
            GymProps.cylinder(0.22, 0.02, [0, y, 0.11], frame, axis: [0, 0, 1], parent: tree)
            for i in 0..<(4 - k) {
                GymProps.cylinder(0.035, 0.225 - Float(k) * 0.04, [0, y, 0.05 + Float(i) * 0.04], i % 2 == 0 ? dark : GymTex.paint(GymTex.brandRed), axis: [0, 0, 1], parent: tree)
            }
        }
    }

    /// Power-Rack mit aufgelegter Langhantel in der hinteren linken Ecke
    private func buildPowerRack() {
        let frame = GymTex.paint(GymTex.frameBlack, rough: 0.4)
        let red = GymTex.paint(GymTex.brandRed, rough: 0.4)
        let rack = Entity()
        rack.position = [-3.30, 0, -2.55]
        rack.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
        root.addChild(rack)
        register(rack, as: .barbellRack)
        for x: Float in [-0.6, 0.6] {
            for z: Float in [-0.45, 0.45] {
                box([0.08, 2.3, 0.08], [x, 1.15, z], frame, corner: 0.008, parent: rack)
            }
            box([0.08, 0.05, 1.0], [x, 0.025, 0], frame, parent: rack)
            box([0.08, 0.08, 1.0], [x, 2.27, 0], frame, parent: rack)
            box([0.08, 0.04, 0.12], [x, 1.30, 0.40], red, parent: rack)
            box([0.06, 0.04, 0.85], [x, 0.85, 0], GymTex.steel(0.55), parent: rack)
        }
        box([1.28, 0.08, 0.08], [0, 2.27, -0.45], frame, parent: rack)
        GymProps.cylinder(1.2, 0.017, [0, 2.15, 0.45], GymTex.steel(0.6), axis: [1, 0, 0], parent: rack)
        let bar = GymProps.barbell(plates: 2)
        bar.position = [0, 1.36, 0.40]
        rack.addChild(bar)
    }

    /// Kabelzug-Station (Latzug und Rudern)
    private func buildCableStation() {
        let frame = GymTex.paint(GymTex.frameBlack, rough: 0.4)
        let red = GymTex.paint(GymTex.brandRed, rough: 0.4)
        let pad = SimpleMaterial(color: UIColor(white: 0.09, alpha: 1), roughness: 0.6, isMetallic: false)
        let st = Entity()
        // in der vorderen rechten Ecke, zur Raummitte gedreht (außerhalb der Kamerabahn)
        st.position = [3.45, 0, 2.95]
        st.orientation = simd_quatf(angle: Float(atan2(-3.45, -2.95)), axis: [0, 1, 0])
        root.addChild(st)
        register(st, as: .latStation)
        // Turm mit Gewichtsblock
        box([0.55, 2.35, 0.14], [0, 1.175, 0.0], frame, corner: 0.01, parent: st)
        box([0.30, 1.30, 0.20], [0, 0.75, 0.16], GymTex.steel(0.35), corner: 0.01, parent: st)
        box([0.55, 0.06, 0.45], [0, 0.03, 0.15], frame, parent: st)
        box([0.60, 0.05, 0.16], [0, 2.30, 0.0], red, parent: st)
        // Ausleger mit Latzugstange
        box([0.10, 0.10, 0.80], [0, 2.25, 0.40], frame, corner: 0.01, parent: st)
        GymProps.cylinder(1.10, 0.014, [0, 1.85, 0.78], GymTex.steel(0.7), axis: [1, 0, 0], parent: st)
        GymProps.cylinder(0.40, 0.0035, [0, 2.05, 0.78], GymTex.paint(.black), parent: st)
        // Sitz und Knieauflage
        box([0.36, 0.08, 0.36], [0, 0.48, 0.80], pad, corner: 0.03, parent: st)
        box([0.07, 0.46, 0.07], [0, 0.23, 0.80], frame, parent: st)
        GymProps.cylinder(0.40, 0.05, [0, 0.72, 0.62], pad, axis: [1, 0, 0], parent: st)
        box([0.07, 0.25, 0.07], [0, 0.60, 0.66], frame, parent: st)
    }

    /// Zwei weitere Bänke: eine flach, eine schräg gestellt
    private func buildSpareBenches() {
        let flat = GymProps.bench()
        flat.position = [-3.50, 0, 1.55]
        root.addChild(flat)
        register(flat, as: .bench)
        let incline = GymProps.bench(incline: 0.6)
        incline.position = [3.45, 0, -2.10]
        incline.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
        root.addChild(incline)
        register(incline, as: .bench)
    }

    /// Senkrechte Halter mit Langhanteln in der hinteren rechten Ecke
    private func buildBarbellHolder() {
        let frame = GymTex.paint(GymTex.frameBlack, rough: 0.4)
        let h = Entity()
        h.position = [3.55, 0, -3.55]
        root.addChild(h)
        register(h, as: .barbellRack)
        box([0.60, 0.10, 0.30], [0, 0.05, 0], frame, corner: 0.01, parent: h)
        for i in 0..<5 {
            let bar = GymProps.cylinder(1.6, 0.014, [-0.24 + Float(i) * 0.12, 0.85, 0], GymTex.steel(0.72), parent: h)
            bar.orientation = simd_quatf(angle: 0.04 * Float(i - 2), axis: [0, 0, 1])
        }
    }

    private func buildMat() {
        mat.model = ModelComponent(mesh: .generateBox(size: [0.95, 0.025, 2.3], cornerRadius: 0.01),
                                   materials: [GymTex.paint(GymLook.teal, rough: 0.8)])
        mat.position = [0, 0.0125, 0]
    }
}
