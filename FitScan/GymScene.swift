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

/// Bausteine für Geräte: Quader, Zylinder und die Hantelbank.
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

    /// Hantelbank (Modell aus tools/geraete): Oberkante 0,30 m, liegt entlang z, Kopfende bei -z.
    /// `incline` stellt die Rückenlehne schräg (Deko).
    static func bench(incline: Float = 0) -> Entity {
        let e = GymModels.make("Bank")
        // Lehne dreht um die Sitzvorderkante
        let back = GymModels.make("BankLehne")
        back.position = [0, 0.30 - 0.035, -0.02]
        if incline > 0 { back.orientation = simd_quatf(angle: incline, axis: [1, 0, 0]) }
        e.addChild(back)
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

    private func buildTower() {
        // Zwei Säulen mit Gewichtsblock (Modelle aus tools/geraete), Querträger mit Klimmzugstange, Mittelpfosten
        for k in 0..<2 {
            towerSide[k].addChild(GymModels.make("Kabelsaeule"))
            towerSide[k].position = [k == 0 ? -(pulleyX + 0.10) : pulleyX + 0.10, 0, towerZ + 0.10]
            tower.addChild(towerSide[k])
        }
        let beam = GymModels.make("KabelBruecke")
        beam.position = [0, 0, towerZ + 0.10]
        towerBeam.addChild(beam)
        tower.addChild(towerBeam)
        towerCenter.addChild(GymModels.make("KabelMitte"))
        towerCenter.isEnabled = false
        tower.addChild(towerCenter)

        // Umlenkrollen (werden in setLayout auf Höhe und Platz gesetzt)
        for k in 0..<2 {
            let p = Entity()
            p.addChild(GymModels.make("Rolle"))
            p.position = [k == 0 ? -pulleyX : pulleyX, 0.22, towerZ - 0.12]
            tower.addChild(p)
            pulleys.append(p)
        }
        // Griffe und Seile
        for _ in 0..<2 {
            let h = GymModels.make("Griff")
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

    /// Gerät aus tools/geraete an eine Stelle setzen (optional gedreht um y)
    @discardableResult
    func place(_ name: String, _ pos: SIMD3<Float>, yaw: Float = 0, parent: Entity? = nil) -> Entity {
        let e = GymModels.make(name)
        e.position = pos
        if yaw != 0 { e.orientation = simd_quatf(angle: yaw, axis: [0, 1, 0]) }
        (parent ?? root).addChild(e)
        return e
    }

    /// Ablage für die Langhantel am Kopfende der Bank (Bankdrücken mit Langhantel)
    private func buildBenchRack() {
        place("Bankablage", [0, 0, -0.66], parent: benchRack)
    }

    /// Gestell um die Klimmzugstange der Figur
    private func buildPullRig() {
        place("Klimmzuggestell", .zero, parent: pullRig)
    }

    private func buildSquatRack() {
        place("Kniebeugenstaender", [0, 0, -0.95], parent: squatRack)
    }

    // MARK: Deko an den Wänden

    private func buildDecor() {
        // Zweistöckige Kurzhantel-Ablage an der Rückwand: 10 Paare von leicht bis schwer
        register(place("Kurzhantelablage", [1.35, 0, -3.70]), as: .dumbbells)
        // Kettlebells auf dem Boden an der Rückwand (Modell in Raumkoordinaten)
        register(place("Kettlebells", .zero), as: .kettlebells)
        register(place("Scheibenbaum", [-0.65, 0, -3.62]), as: .barbellRack)
        // Power-Rack mit aufgelegter Langhantel in der hinteren linken Ecke
        register(place("PowerRack", [-3.30, 0, -2.55], yaw: .pi / 2), as: .barbellRack)
        // Latzug in der vorderen rechten Ecke, zur Raummitte gedreht (außerhalb der Kamerabahn)
        register(place("Latzug", [3.45, 0, 2.95], yaw: Float(atan2(-3.45, -2.95))), as: .latStation)
        // Zwei weitere Bänke: eine flach, eine schräg gestellt
        let flat = GymProps.bench()
        flat.position = [-3.50, 0, 1.55]
        root.addChild(flat)
        register(flat, as: .bench)
        let incline = GymProps.bench(incline: 0.6)
        incline.position = [3.45, 0, -2.10]
        incline.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
        root.addChild(incline)
        register(incline, as: .bench)
        // Senkrechte Halter mit Langhanteln in der hinteren rechten Ecke
        register(place("Hantelstangenhalter", [3.55, 0, -3.55]), as: .barbellRack)
    }

    private func buildMat() {
        mat.model = ModelComponent(mesh: .generateBox(size: [0.95, 0.025, 2.3], cornerRadius: 0.01),
                                   materials: [GymTex.paint(GymLook.teal, rough: 0.8)])
        mat.position = [0, 0.0125, 0]
    }
}
