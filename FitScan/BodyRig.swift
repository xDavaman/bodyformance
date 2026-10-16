import Combine
import RealityKit
import UIKit
import simd

/// Requisiten einer Bewegung. roller/ball/post/step: Hilfsmittel, deren Lage je Bild in FitScan_Motions.bin steht
/// (Faszienrolle, kleiner Ball unter dem Fuß, Türrahmen bzw. Stange, Treppenstufe).
enum MotionProps { case none, dumbbell, pullbar, barbell, roller, ball, post, step }

/// Wie die Hand-Requisiten dargestellt werden: auto = wie bisher (Kurzhanteln, Kabelturm bei Curl/Seitheben),
/// dumbbell = immer Kurzhanteln, band = Widerstandsband unter den Füßen, cable = Kabelturm
enum PropGear { case auto, dumbbell, band, cable }

/// Beschreibung einer Bewegung (Lage, Requisiten, Kamera). Die Gelenkdaten stehen in FitScan_Motions.bin.
struct Motion {
    let period: Float
    let lying: Bool
    let bench: Bool
    /// Freie Körperlage (Boden-, Dehn- und Stützübungen)
    let free: Bool
    /// Wand als Requisite (z-Position der Wandfläche)
    let wallZ: Float?
    /// Blickwinkel auf den Körper (Drehung um die Hochachse)
    let yaw: Float
    /// Höhe, auf die die Kamera schaut
    let camY: Float
    let props: MotionProps
}

/// Vorberechnete Bewegungsschleife: pro Frame die lokalen Gelenktransformationen des Skeletts.
struct MotionClip {
    let frames: Int
    let period: Float
    let rot: [SIMD4<Float>]      // frames * jointCount, Quaternion (x, y, z, w)
    let pos: [SIMD3<Float>]      // frames * jointCount, lokale Verschiebung
    let propCount: Int
    let propRot: [SIMD4<Float>]  // frames * propCount, Welt-Pose der Hanteln
    let propPos: [SIMD3<Float>]
    /// Anstrengung je Bild (0 … 1): wie weit die Haltung von der Ausgangshaltung entfernt ist.
    /// Steuert das Aufleuchten der aktiven Muskeln.
    let effort: [Float]

    /// Anstrengung zu einem Zeitpunkt (gleiche Zeitbasis wie die Gelenke)
    func effort(at f: Float) -> Float {
        guard frames > 1, effort.count == frames else { return 0.5 }
        let i0 = min(Int(f), frames - 1), i1 = (i0 + 1) % frames
        let a = f - Float(i0)
        return effort[i0] + (effort[i1] - effort[i0]) * a
    }

    /// Summe der Gelenkwinkel gegenüber Bild 0, auf 0 … 1 gebracht
    static func effortCurve(frames nf: Int, joints nb: Int, rot: [SIMD4<Float>]) -> [Float] {
        guard nf > 1 else { return [Float](repeating: 0.5, count: max(nf, 1)) }
        var e = [Float](repeating: 0, count: nf)
        for f in 0..<nf {
            var sum: Float = 0
            for j in 0..<nb {
                let a = rot[j], b = rot[f * nb + j]
                let d = min(1, abs(simd_dot(a, b)))
                sum += 2 * acos(d)
            }
            e[f] = sum
        }
        let lo = e.min() ?? 0, hi = e.max() ?? 1
        let span = max(hi - lo, 1e-3)
        return e.map { ($0 - lo) / span }
    }
}

enum MotionStore {
    /// Reihenfolge der Gelenke in FitScan_Motions.bin (identisch zum Skelett in FitScan_Skin.usdz)
    static let jointNames: [String] = ["root", "spine1", "spine2", "spine3", "neck1", "neck2", "head", "clavL", "uaL", "uaTwL", "faL", "faTwL", "haL", "idx1L", "idx2L", "idx3L", "mid1L", "mid2L", "mid3L", "rng1L", "rng2L", "rng3L", "pnk1L", "pnk2L", "pnk3L", "thb0L", "thb1L", "thb2L", "thL", "shL", "ftL", "toeL", "clavR", "uaR", "uaTwR", "faR", "faTwR", "haR", "idx1R", "idx2R", "idx3R", "mid1R", "mid2R", "mid3R", "rng1R", "rng2R", "rng3R", "pnk1R", "pnk2R", "pnk3R", "thb0R", "thb1R", "thb2R", "thR", "shR", "ftR", "toeR"]

    static let clips: [String: MotionClip] = load()

    private static func load() -> [String: MotionClip] {
        guard let url = Bundle.main.url(forResource: "FitScan_Motions", withExtension: "bin"),
              let data = try? Data(contentsOf: url), data.count > 12 else {
            print("FitScan: FitScan_Motions.bin fehlt im App-Target")
            return [:]
        }
        var out: [String: MotionClip] = [:]
        data.withUnsafeBytes { (raw: UnsafeRawBufferPointer) in
            func u32(_ o: Int) -> Int { Int(raw.loadUnaligned(fromByteOffset: o, as: UInt32.self)) }
            func f32(_ o: Int) -> Float { raw.loadUnaligned(fromByteOffset: o, as: Float.self) }
            func i16(_ o: Int) -> Float { Float(raw.loadUnaligned(fromByteOffset: o, as: Int16.self)) }
            guard raw.loadUnaligned(fromByteOffset: 0, as: UInt32.self) == 0x314D_5346 else { return }
            let nb = u32(4), nm = u32(8)
            guard nb == jointNames.count else { print("FitScan: Gelenkzahl passt nicht"); return }
            var o = 12
            for _ in 0..<nm {
                var nameBytes: [UInt8] = []
                for k in 0..<24 { let b = raw[o + k]; if b == 0 { break }; nameBytes.append(b) }
                let name = String(decoding: nameBytes, as: UTF8.self)
                o += 24
                let nf = u32(o), period = f32(o + 4), npr = u32(o + 8)
                o += 12
                var rot = [SIMD4<Float>](), pos = [SIMD3<Float>]()
                rot.reserveCapacity(nf * nb); pos.reserveCapacity(nf * nb)
                for _ in 0..<(nf * nb) {
                    pos.append(SIMD3<Float>(i16(o), i16(o + 2), i16(o + 4)) / 10000)
                    rot.append(SIMD4<Float>(i16(o + 6), i16(o + 8), i16(o + 10), i16(o + 12)) / 32767)
                    o += 14
                }
                var prot = [SIMD4<Float>](), ppos = [SIMD3<Float>]()
                for _ in 0..<(nf * npr) {
                    ppos.append(SIMD3<Float>(i16(o), i16(o + 2), i16(o + 4)) / 10000)
                    prot.append(SIMD4<Float>(i16(o + 6), i16(o + 8), i16(o + 10), i16(o + 12)) / 32767)
                    o += 14
                }
                out[name] = MotionClip(frames: nf, period: period, rot: rot, pos: pos, propCount: npr, propRot: prot, propPos: ppos,
                                       effort: MotionClip.effortCurve(frames: nf, joints: nb, rot: rot))
            }
        }
        return out
    }
}

extension BodyMotion {
    /// Bewegung und Darstellung der Hilfsmittel passend zur Übung (Langhantel, Kurzhantel, Band, Kabelturm).
    static func scene(for ex: Exercise) -> (BodyMotion, PropGear) {
        var m = variant(of: ex.name) ?? ex.motionKey.flatMap { BodyMotion(rawValue: $0) }
            ?? forExercise(name: ex.name, primary: ex.primary)
        var gear = PropGear.auto
        switch ex.equipment {
        case .barbell:
            switch m {
            case .benchPress: m = .benchBar
            case .squat, .deepSquat: m = .squatBar
            case .overhead: m = .overheadBar
            case .rdl: m = .rdlBar
            case .row: m = .rowBar
            case .curl: m = .curlBar
            default: break
            }
        case .dumbbell, .kettlebell:
            gear = .dumbbell
            switch m {
            case .squat: m = .squatDb
            case .lunge: m = .lungeDb
            case .calf: m = .calfDb
            default: break
            }
        case .band: gear = .band
        case .cable: gear = .cable
        default: break
        }
        return (m, gear)
    }

    /// Eigene Animation je Variante (Mobility, Yoga, Pilates, Dehnung, Faszienrolle, Reha). Die Variante steht im Namen
    /// hinter dem Hilfsmittel, z. B. „Hüftdehnung (Körpergewicht, Frosch)“ → Familie „Hüftdehnung“, Variante „Frosch“.
    static func variant(of name: String) -> BodyMotion? {
        guard let open = name.range(of: " ("), name.hasSuffix(")") else { return nil }
        let family = String(name[..<open.lowerBound])
        guard let table = variants[family] else { return nil }
        let inner = name[open.upperBound..<name.index(before: name.endIndex)]
        let v = inner.range(of: ", ").map { String(inner[$0.upperBound...]) } ?? ""
        return table[v]
    }

    static let variants: [String: [String: BodyMotion]] = [
        "Yoga": ["": .sunA, "Dreieck": .triangle, "Halber Mond": .halfMoon, "Krieger III": .warrior3, "Pflug": .plow,
                 "Sonnengruß A": .sunA, "Sonnengruß B": .sunB, "Taube": .pigeon],
        "Pilates": ["": .hundred, "Seitlicher Beinkreis": .sideLegCircle, "Swan": .swan],
        "Nackendehnung": ["schräg vorn": .neckDiag, "vorn": .neckFwd, "mit Hand": .neckHand, "Kopfdrehung": .neckRotate],
        "Schulterdehnung": ["Arm hinter dem Rücken": .armBehind, "Arm über Kopf": .tricepStretch, "Handtuch": .towelStretch,
                            "Schlafposition": .sleeper, "Tür-Dehnung": .doorChest, "Wand": .wallShoulder],
        "Brustdehnung": ["im Türrahmen": .doorChest, "Hände hinter dem Rücken": .handsBehind, "auf dem Boden": .floorChest,
                         "an der Stange": .barChest, "Faszienrolle quer": .rollerChest],
        "Trizepsdehnung": ["mit Handtuch": .towelStretch],
        "Rückendehnung": ["Kind-Position": .childPose, "Nadelöhr": .threadNeedle, "Latissimus am Türrahmen": .latDoor],
        "Hüftdehnung": ["Taube": .pigeon, "Schmetterling": .butterfly, "Frosch": .frog, "90/90": .ninety,
                        "Figur-Vier": .figureFour, "Piriformis": .figureFour, "Couch-Stretch": .couchStretch],
        "Oberschenkeldehnung": ["Quadrizeps liegend": .quadLying, "Abduktoren (ITB)": .itbStretch,
                                "Kniesehne im Ausfallschritt": .halfSplit],
        "Wadendehnung": ["an der Wand, gebeugt": .soleusWall, "auf der Treppenstufe": .calfStep, "mit Band": .calfBand],
        "Sprunggelenk-Mobilisation": ["Kreisen": .ankleCircle, "Fußwippe": .ankleRock, "Tiefe Hocke halten": .deepSquat],
        "Handgelenk-Mobilisation": ["Kreisen": .wristCircle, "Beuger dehnen": .wristFlexor, "Strecker dehnen": .wristExtensor,
                                    "Gebet": .prayer],
        "Faszienrolle": ["": .rollQuad, "Oberschenkel vorne": .rollQuad, "Oberschenkel hinten": .rollHam, "Waden": .rollCalf,
                         "Gesäß": .rollGlute, "Außenseite (ITB)": .rollItb, "oberer Rücken": .rollUpperBack,
                         "Latissimus": .rollLat, "Nacken": .rollNeck, "Fußsohle": .rollFoot, "Brust": .rollerChest],
        "Schulter-Aktivierung": ["Band Pull-Apart": .pullApart, "Schulterkreisen": .shoulderCircle, "Y-T-W": .ytw,
                                 "Außenrotation liegend": .extRotation, "Scapula Push-up": .scapPushup,
                                 "Bear Hold": .bearHold, "Face Pull leicht": .facePull],
        "Rehab & Prävention": ["Bird Dog": .birdDog, "Clam Shell": .clamShell, "Dead Bug": .deadBug,
                               "McGill Curl-up": .mcgill, "Seitstütz": .sidePlank, "Monster Walk": .monsterWalk,
                               "Einbeinstand": .singleLeg, "Fersengang": .heelWalk, "Zehengang": .toeWalk],
    ]

    /// Bewegung passend zum Übungsnamen, sonst anhand der trainierten Muskeln.
    static func forExercise(name: String, primary: [Muscle]) -> BodyMotion {
        let n = name.lowercased()
        func has(_ s: String...) -> Bool { s.contains { n.contains($0) } }
        // Mobility und Dehnungen
        if has("sitzende vorbeuge") { return .sitFold }
        if has("beinrückseite") { return .supineHam }
        if has("hüftbeuger") { return .hipStretch }
        if has("world's greatest") { return .wgs }
        if has("cossack") { return .cossack }
        if has("knie zur wand") { return .kneeWall }
        if has("wadendehnung") { return .calfWall }
        if has("fersensitz") { return .heelSit }
        if has("tiefe hocke") { return .deepSquat }
        if has("wall slides") { return .wallSlide }
        if has("stab-dislokation") { return .stabDislocate }
        if has("brustdehnung") { return .chestStretch }
        if has("cross-body") { return .crossBody }
        if has("bws") { return .bwsRotate }
        if has("katze") { return .catCow }
        if has("kindhaltung") { return .childPose }
        if has("kobra") { return .cobra }
        if has("handgelenk") { return .wristRock }
        if has("kinn") { return .chinTuck }
        if has("nacken") { return .neckTilt }
        if has("quadrizeps-dehnung") { return .quadStretch }
        if has("knie zur brust") { return .kneeHug }
        if has("beinschwingen") { return .legSwing }
        if has("vorbeuge") { return .forwardFold }
        // Training
        if has("bankdrücken", "schrägbank") { return .benchPress }
        if has("liegestütz") { return .pushup }
        if has("plank") { return .plank }
        if has("hip thrust", "glute bridge") { return .bridge }
        if has("schulterdrücken") { return .overhead }
        if has("seitheben") { return .lateral }
        if has("dips", "trizeps") { return .triceps }
        if has("klimmz", "pull-up") { return .pullup }
        if has("beinheben") { return .legRaise }
        if has("hängen") { return .hang }
        if has("rudern") { return .row }
        if has("curl") { return .curl }
        if has("kniebeuge") { return .squat }
        if has("kreuzheben") { return .rdl }
        if has("ausfall") { return .lunge }
        if has("wadenheben") { return .calf }
        if has("seilspringen") { return .jumpRope }
        if has("kniehebe") { return .kneeRaise }
        if has("anfersen") { return .buttKick }
        if has("dead bug") { return .deadBug }
        if has("hollow") { return .hollowHold }
        guard let m = primary.first else { return .idle }
        switch m {
        case .chest: return .benchPress
        case .biceps, .forearms: return .curl
        case .triceps: return .triceps
        case .shoulders: return .lateral
        case .lats, .traps: return .row
        case .quads, .glutes, .adductors, .hipFlexors: return .squat
        case .hamstrings, .lowerBack: return .rdl
        case .calves: return .calf
        case .abs: return .crunch
        case .neck: return .idle
        }
    }
}

/// Der Körper ist ein durchgehendes Netz mit Skelett (57 Gelenke, FitScan_Skin.usdz). Die Haut verformt sich selbst,
/// dadurch entstehen keine Lücken an Schulter, Hals oder Hüfte. Bewegungen kommen vorberechnet aus FitScan_Motions.bin.
final class BodyRig {
    /// Wurzel der Szene für Körper und Hanteln (bleibt unbewegt, die Körperlage steckt im Skelett)
    let root = Entity()
    /// Bank für Übungen im Liegen (gepolsterte Hantelbank, Oberkante 0,30 m, Kopfende bei -z), siehe GymProps.bench
    let bench: Entity = {
        let e = GymProps.bench()
        e.isEnabled = false
        return e
    }()
    let pullBar: ModelEntity = {
        let m = ModelEntity(mesh: .generateCylinder(height: 1.3, radius: 0.017),
                            materials: [SimpleMaterial(color: UIColor(white: 0.55, alpha: 1), roughness: 0.3, isMetallic: true)])
        m.orientation = simd_quatf(angle: .pi / 2, axis: [0, 0, 1])
        m.position = [0, 2.03, 0.05]
        m.isEnabled = false
        return m
    }()
    let wall: ModelEntity = {
        let m = ModelEntity(mesh: .generateBox(size: [1.8, 2.5, 0.03]),
                            materials: [SimpleMaterial(color: UIColor(white: 0.42, alpha: 1), roughness: 0.9, isMetallic: false)])
        m.isEnabled = false
        return m
    }()
    /// Gym-Raum mit Boden, Wänden, Decke, Lichtern und Geräten
    let gym = GymRoom()
    private var dumbbells: [Entity] = []
    /// Langhantel (Stange 2,2 m + je 2 Scheiben), Achse = lokale y-Achse
    let barbell: Entity = {
        let e = Entity()
        let steel = SimpleMaterial(color: UIColor(white: 0.72, alpha: 1), roughness: 0.25, isMetallic: true)
        let plate = SimpleMaterial(color: UIColor(white: 0.10, alpha: 1), roughness: 0.5, isMetallic: false)
        let red = SimpleMaterial(color: UIColor(red: 0.80, green: 0.12, blue: 0.10, alpha: 1), roughness: 0.5, isMetallic: false)
        e.addChild(ModelEntity(mesh: .generateCylinder(height: 2.2, radius: 0.014), materials: [steel]))
        for s: Float in [-1, 1] {
            let sleeve = ModelEntity(mesh: .generateCylinder(height: 0.40, radius: 0.025), materials: [steel])
            sleeve.position = [0, s * 0.80, 0]
            e.addChild(sleeve)
            for (k, y) in [0.50, 0.545, 0.58].enumerated() {
                let pl = ModelEntity(mesh: .generateCylinder(height: 0.04, radius: k == 0 ? 0.225 : 0.17), materials: [k == 0 ? red : plate])
                pl.position = [0, s * Float(y), 0]
                e.addChild(pl)
            }
        }
        e.isEnabled = false
        return e
    }()
    /// Widerstandsband: zwei Stränge (Fuß → Hand) mit Griffen
    private var bands: [ModelEntity] = []
    private var bandGrips: [ModelEntity] = []
    var cableMode: Bool { gym.layout.cableHeight != nil }
    private(set) var body: ModelEntity?
    /// Netz nach der Muskel-Zerlegung, Ausgangspunkt für die eigene Form (BodyShape.swift)
    private var baseMesh: MeshResource?
    private var baseScale = SIMD3<Float>(repeating: 1)
    /// geladene Datei (Ursprung am Boden); wird für die Körpergröße skaliert, Hilfsmittel wandern mit
    private var modelRoot: Entity?
    private var sizeScale: Float = 1
    /// Punkt, um den die Größe skaliert wird: Boden, Bankoberkante, Klimmzugstange oder Wand bleiben an ihrem Platz
    private var pivot = SIMD3<Float>(repeating: 0)

    private func sized(_ p: SIMD3<Float>) -> SIMD3<Float> { pivot + (p - pivot) * sizeScale }
    private var shapeKey = ""
    private var jointMap: [Int] = []
    private var restPose: [Transform] = []
    private(set) var ready = false
    private var iSpine2 = 0, iHead = 0, iRoot = 0
    /// Hilfsmittel (Faszienrolle, Ball, Türrahmen/Stange, Stufe), bis zu zwei je Art
    private var aids: [MotionProps: [ModelEntity]] = [:]
    /// Weiches Überblenden beim Wechsel der Übung: Gelenkstellung vor dem Wechsel und Dauer
    private var fadeFrom: [Transform]?
    private let fadeDuration: Float = 0.45

    init() {
        let dark = SimpleMaterial(color: UIColor(white: 0.18, alpha: 1), roughness: 0.5, isMetallic: true)
        for _ in 0..<2 {
            let db = Entity()
            db.addChild(ModelEntity(mesh: .generateCylinder(height: 0.20, radius: 0.0125), materials: [dark]))
            for y: Float in [-0.092, 0.092] {
                let plate = ModelEntity(mesh: .generateCylinder(height: 0.035, radius: 0.055), materials: [dark])
                plate.position = [0, y, 0]
                db.addChild(plate)
            }
            db.isEnabled = false
            root.addChild(db)
            dumbbells.append(db)
        }
        root.addChild(gym.root)
        root.addChild(barbell)
        let bandMat = SimpleMaterial(color: UIColor(red: 0.95, green: 0.55, blue: 0.10, alpha: 1), roughness: 0.6, isMetallic: false)
        for _ in 0..<2 {
            let b = ModelEntity(mesh: .generateCylinder(height: 1, radius: 0.007), materials: [bandMat])
            b.isEnabled = false
            root.addChild(b)
            bands.append(b)
            let g = ModelEntity(mesh: .generateCylinder(height: 0.11, radius: 0.014), materials: [dark])
            g.isEnabled = false
            root.addChild(g)
            bandGrips.append(g)
        }
        let foam = SimpleMaterial(color: UIColor(red: 0.20, green: 0.45, blue: 0.85, alpha: 1), roughness: 0.8, isMetallic: false)
        let wood = SimpleMaterial(color: UIColor(red: 0.62, green: 0.48, blue: 0.32, alpha: 1), roughness: 0.7, isMetallic: false)
        let aidMeshes: [(MotionProps, MeshResource, Material)] = [
            (.roller, .generateCylinder(height: 0.90, radius: 0.075), foam),
            (.ball, .generateSphere(radius: 0.035), SimpleMaterial(color: UIColor(red: 0.85, green: 0.25, blue: 0.2, alpha: 1), roughness: 0.6, isMetallic: false)),
            (.post, .generateBox(size: [0.07, 2.0, 0.09], cornerRadius: 0.01), wood),
            (.step, .generateBox(size: [0.15, 0.80, 0.32], cornerRadius: 0.01), wood),
        ]
        for (kind, mesh, mat) in aidMeshes {
            aids[kind] = (0..<2).map { _ in
                let e = ModelEntity(mesh: mesh, materials: [mat])
                e.isEnabled = false
                root.addChild(e)
                return e
            }
        }
        iRoot = MotionStore.jointNames.firstIndex(of: "root") ?? 0
        iSpine2 = MotionStore.jointNames.firstIndex(of: "spine2") ?? 0
        iHead = MotionStore.jointNames.firstIndex(of: "head") ?? 0
    }

    private static func findSkinned(_ e: Entity) -> ModelEntity? {
        if let m = e as? ModelEntity, !m.jointNames.isEmpty { return m }
        for c in e.children { if let r = findSkinned(c) { return r } }
        return nil
    }

    /// Hängt das geladene Körpermodell ein und ordnet die Gelenke zu. Gibt false zurück, wenn kein Skelett gefunden wurde.
    @discardableResult
    func attachBody(_ model: Entity, material: Material) -> Bool {
        root.addChild(model)
        modelRoot = model
        guard let m = Self.findSkinned(model) else {
            print("FitScan: kein Skelett im Körpermodell gefunden")
            return false
        }
        body = m
        if var mc = m.components[ModelComponent.self] {
            let original = mc.mesh
            let jointCount = m.jointNames.count
            if let seg = MuscleSegmenter.segmented(original, key: "FitScan_Skin") {
                mc.mesh = seg
                mc.materials = Array(repeating: material, count: MuscleSegmenter.order.count + 1)
                m.components.set(mc)
                muscleParts = true
                // Sicherheitsnetz: falls das zerlegte Netz das Skelett verliert, zurück zum Original (dann ohne Muskelfarben)
                if m.jointNames.count != jointCount {
                    print("FitScan: Muskel-Zerlegung verwirft das Skelett, nutze Originalnetz")
                    mc.mesh = original
                    muscleParts = false
                }
            }
            if !muscleParts {
                mc.materials = Array(repeating: material, count: max(mc.materials.count, 1))
                m.components.set(mc)
            }
        }
        let names = m.jointNames
        var map = [Int](repeating: -1, count: MotionStore.jointNames.count)
        for (ri, full) in names.enumerated() {
            let last = full.split(separator: "/").last.map(String.init) ?? full
            if let bi = MotionStore.jointNames.firstIndex(of: last) { map[bi] = ri }
        }
        jointMap = map
        restPose = m.jointTransforms
        ready = !map.contains(-1) && restPose.count == names.count
        if !ready { print("FitScan: Gelenkzuordnung unvollständig", names.count, map.filter { $0 < 0 }.count) }
        baseMesh = m.components[ModelComponent.self]?.mesh
        baseScale = model.scale
        return ready
    }

    /// Formt die Figur nach dem eigenen Körper (Größe und Körperregionen). Ohne Wirkung, wenn sich nichts ändert.
    func applyShape(_ shape: BodyShape) {
        guard let m = body, let base = baseMesh, var mc = m.components[ModelComponent.self] else { return }
        modelRoot?.scale = baseScale * shape.heightScale
        sizeScale = shape.heightScale
        modelRoot?.position = pivot * (1 - sizeScale)
        guard shape.meshKey != shapeKey else { return }
        shapeKey = shape.meshKey
        let jointCount = m.jointNames.count
        let mesh = shape.isNeutral ? base : (BodyShaper.shaped(base, shape: shape) ?? base)
        mc.mesh = mesh
        m.components.set(mc)
        // Sicherheitsnetz wie bei der Muskel-Zerlegung: Skelett muss erhalten bleiben
        if m.jointNames.count != jointCount {
            print("FitScan: verformtes Netz verliert das Skelett, nutze Grundform")
            mc.mesh = base
            m.components.set(mc)
        }
    }

    /// true, wenn das Körpernetz in Muskelbereiche zerlegt werden konnte (dann sind Muskelfarben möglich)
    private(set) var muscleParts = false

    /// Färbt aktive Muskeln rot und passive gelb, alles andere bleibt in der Hautfarbe.
    func setHighlight(primary: [Muscle], secondary: [Muscle], neutral: UIColor) {
        highlight = (primary, secondary, neutral)
        glowLevel = -1
        setGlow(level: 4)
    }

    private var highlight: (primary: [Muscle], secondary: [Muscle], neutral: UIColor)?
    private var glowLevel = -1
    private static let glowLevels = 8

    /// Aktive Muskeln leuchten mit der Anstrengung der Bewegung stärker (Stufen, damit nicht jedes Bild neue
    /// Materialien entstehen).
    private func setGlow(level: Int) {
        guard level != glowLevel, let h = highlight else { return }
        glowLevel = level
        let e = Float(level) / Float(Self.glowLevels - 1)
        applyHighlight(primary: h.primary, secondary: h.secondary, neutral: h.neutral,
                       activeGlow: 0.15 + 0.75 * e, passiveGlow: 0.12 + 0.25 * e)
    }

    private func applyHighlight(primary: [Muscle], secondary: [Muscle], neutral: UIColor, activeGlow: Float, passiveGlow: Float) {
        guard muscleParts, let m = body, var mc = m.components[ModelComponent.self] else { return }
        func pbr(_ c: UIColor, glow: Float?) -> PhysicallyBasedMaterial {
            var mat = PhysicallyBasedMaterial()
            mat.baseColor = .init(tint: c)
            mat.roughness = .init(floatLiteral: 0.55)
            mat.metallic = .init(floatLiteral: 0)
            if let glow {
                // Eigenleuchten, damit die Farben auch im dunkleren Raum gut zu sehen sind
                mat.emissiveColor = .init(color: c)
                mat.emissiveIntensity = glow
            }
            return mat
        }
        let skin = pbr(neutral, glow: nil)
        let active = pbr(MuscleHighlight.active, glow: activeGlow)
        let passive = pbr(MuscleHighlight.passive, glow: passiveGlow)
        var mats: [Material] = [skin]
        for muscle in MuscleSegmenter.order {
            if primary.contains(muscle) { mats.append(active) }
            else if secondary.contains(muscle) { mats.append(passive) }
            else { mats.append(skin) }
        }
        mc.materials = mats
        m.components.set(mc)
    }

    /// Vor einem Übungswechsel aufrufen: die neue Bewegung blendet dann weich aus der aktuellen Haltung über.
    func beginTransition() {
        guard ready, let b = body else { return }
        fadeFrom = b.jointTransforms
    }

    func setMaterial(_ material: Material) {
        guard let m = body, var mc = m.components[ModelComponent.self] else { return }
        mc.materials = Array(repeating: material, count: max(mc.materials.count, 1))
        m.components.set(mc)
    }

    // MARK: Pose setzen

    func apply(_ mo: Motion, clip: MotionClip?, time rawTime: Float, gear: PropGear = .auto) {
        // Leicht schwankendes Tempo: keine Wiederholung gleicht exakt der vorigen
        let time = rawTime + 0.10 * sin(rawTime * 0.37) + 0.05 * sin(rawTime * 1.13)
        bench.isEnabled = mo.bench
        pullBar.isEnabled = mo.props == .pullbar
        pivot = mo.props == .pullbar ? pullBar.position : (mo.bench ? [0, 0.30, 0] : [0, 0, mo.wallZ ?? 0])
        modelRoot?.position = pivot * (1 - sizeScale)
        let bandOn = gear == .band && mo.props == .dumbbell && !mo.free
        let cableOn = cableMode && mo.props == .dumbbell && !bandOn
        for db in dumbbells { db.isEnabled = mo.props == .dumbbell && !cableOn && !bandOn }
        barbell.isEnabled = mo.props == .barbell
        for k in 0..<2 { bands[k].isEnabled = bandOn; bandGrips[k].isEnabled = bandOn }
        for (kind, list) in aids {
            for (k, e) in list.enumerated() { e.isEnabled = kind == mo.props && k < (clip?.propCount ?? 0) }
        }
        if let wz = mo.wallZ {
            wall.isEnabled = true
            wall.position = [0, 1.25, wz + (wz > 0 ? 0.015 : -0.015)]
        } else {
            wall.isEnabled = false
        }
        guard ready, let body = body, let clip = clip, clip.frames > 1, clip.period > 0 else { return }
        var f = (time / clip.period).truncatingRemainder(dividingBy: 1)
        if f < 0 { f += 1 }
        let fp = f * Float(clip.frames)
        let i0 = min(Int(fp), clip.frames - 1)
        let i1 = (i0 + 1) % clip.frames
        let a = fp - Float(i0)
        let nb = jointMap.count
        let breath = sin(time * 1.7)
        var tr = restPose
        for j in 0..<nb {
            let k0 = i0 * nb + j, k1 = i1 * nb + j
            var p = clip.pos[k0] + (clip.pos[k1] - clip.pos[k0]) * a
            var q = simd_slerp(simd_quatf(vector: clip.rot[k0]), simd_quatf(vector: clip.rot[k1]), a)
            if j == iSpine2 { q = q * simd_quatf(angle: 0.016 * breath, axis: [1, 0, 0]) }
            if j == iHead { q = q * simd_quatf(angle: 0.03 * sin(time * 0.37), axis: [0, 1, 0]) }
            if j == iRoot && !mo.lying && !mo.free { p.x += 0.006 * sin(time * 0.55) }
            tr[jointMap[j]] = Transform(scale: [1, 1, 1], rotation: q, translation: p)
        }
        if let from = fadeFrom, from.count == tr.count {
            let u = min(1, max(0, rawTime / fadeDuration))
            let w = u * u * (3 - 2 * u)
            if w >= 1 {
                fadeFrom = nil
            } else {
                for k in 0..<tr.count {
                    tr[k].translation = from[k].translation + (tr[k].translation - from[k].translation) * w
                    tr[k].rotation = simd_slerp(from[k].rotation, tr[k].rotation, w)
                }
            }
        }
        body.jointTransforms = tr
        if highlight != nil {
            let e = clip.effort(at: fp)
            setGlow(level: Int((e * Float(Self.glowLevels - 1)).rounded()))
        }
        if let list = aids[mo.props], clip.propCount > 0 {
            for k in 0..<min(list.count, clip.propCount) {
                let b0 = i0 * clip.propCount + k, b1 = i1 * clip.propCount + k
                list[k].position = sized(clip.propPos[b0] + (clip.propPos[b1] - clip.propPos[b0]) * a)
                list[k].orientation = simd_slerp(simd_quatf(vector: clip.propRot[b0]), simd_quatf(vector: clip.propRot[b1]), a)
            }
        }
        if mo.props == .barbell, clip.propCount > 0 {
            let b0 = i0 * clip.propCount, b1 = i1 * clip.propCount
            barbell.position = sized(clip.propPos[b0] + (clip.propPos[b1] - clip.propPos[b0]) * a)
            barbell.orientation = simd_slerp(simd_quatf(vector: clip.propRot[b0]), simd_quatf(vector: clip.propRot[b1]), a)
        }
        if mo.props == .dumbbell {
            for k in 0..<min(dumbbells.count, clip.propCount) {
                let b0 = i0 * clip.propCount + k, b1 = i1 * clip.propCount + k
                dumbbells[k].position = sized(clip.propPos[b0] + (clip.propPos[b1] - clip.propPos[b0]) * a)
                dumbbells[k].orientation = simd_slerp(simd_quatf(vector: clip.propRot[b0]), simd_quatf(vector: clip.propRot[b1]), a)
            }
            if cableOn { gym.updateCables(dumbbells.map { ($0.position, $0.orientation) }) }
            if bandOn {
                for k in 0..<min(2, dumbbells.count) {
                    let hand = dumbbells[k].position
                    let anchor = mo.lying ? SIMD3<Float>(hand.x < 0 ? -0.10 : 0.10, 0.22, -0.2) : SIMD3<Float>(hand.x < 0 ? -0.11 : 0.11, 0.03, 0.04)
                    let d = hand - anchor
                    let len = max(simd_length(d), 0.01)
                    bands[k].position = anchor + d * 0.5
                    bands[k].scale = [1, len, 1]
                    bands[k].orientation = simd_quatf(from: [0, 1, 0], to: d / len)
                    bandGrips[k].position = hand
                    bandGrips[k].orientation = dumbbells[k].orientation
                }
            }
        }
    }
}
