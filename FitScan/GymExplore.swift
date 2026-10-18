import Combine
import RealityKit
import SwiftUI
import UIKit
import simd

// Begehbares Fitnessstudio: Man steht in der Mitte des Raums, schaut sich durch Wischen um und tippt ein Gerät an.
// Jede Station zeigt die Übungen, die an ihr gemacht werden; jede Übung öffnet die Detailseite mit der 3D-Figur.
// Umgekehrt führt jede Übung über „Im Studio zeigen“ zu ihrem Gerät.

/// Geräte-Stationen im Studio. Jede Übung gehört zu genau einer Station (siehe `of(_:)`).
enum GymStation: String, CaseIterable, Identifiable {
    case cableTower, latStation, legPress, machines, bench, barbellRack, dumbbells, kettlebells
    case pullStation, mobilityArea, foamRoller, medballs, bands, cardio, bodyweight

    var id: String { rawValue }

    var title: String {
        switch self {
        case .cableTower: return "Kabelturm"
        case .latStation: return "Latzug und Rudern"
        case .legPress: return "Beinpresse und Beinmaschinen"
        case .machines: return "Kraftmaschinen"
        case .bench: return "Hantelbänke"
        case .barbellRack: return "Power-Rack und Langhanteln"
        case .dumbbells: return "Kurzhanteln"
        case .kettlebells: return "Kettlebells"
        case .pullStation: return "Klimmzug- und Dip-Station"
        case .mobilityArea: return "Matte und Mobility"
        case .foamRoller: return "Faszienrollen"
        case .medballs: return "Medizinbälle"
        case .bands: return "Widerstandsbänder"
        case .cardio: return "Cardio-Geräte"
        case .bodyweight: return "Freie Fläche"
        }
    }

    var icon: String {
        switch self {
        case .cableTower: return "cable.connector"
        case .latStation: return "figure.rower"
        case .legPress: return "figure.strengthtraining.functional"
        case .machines: return "gearshape.2"
        case .bench: return "bed.double"
        case .barbellRack: return "figure.strengthtraining.traditional"
        case .dumbbells: return "dumbbell"
        case .kettlebells: return "scalemass"
        case .pullStation: return "figure.play"
        case .mobilityArea: return "figure.yoga"
        case .foamRoller: return "cylinder"
        case .medballs: return "basketball"
        case .bands: return "lasso"
        case .cardio: return "figure.run.treadmill"
        case .bodyweight: return "figure.core.training"
        }
    }

    var info: String {
        switch self {
        case .cableTower: return "Zwei verstellbare Rollen: Curls, Seitheben, Trizepsdrücken, Face Pulls und Crossover."
        case .latStation: return "Latzug von oben und Rudern im Sitzen."
        case .legPress: return "Beinpresse, Hackenschmidt, Beinstrecker und -beuger, Ab- und Adduktion."
        case .machines: return "Geführte Maschinen für Brust, Schultern, Rücken und Arme."
        case .bench: return "Flach- und Schrägbank für Drücken, Rudern, Fliegende und Hip Thrusts."
        case .barbellRack: return "Kniebeugen, Kreuzheben, Schulterdrücken und Rudern mit der Langhantel."
        case .dumbbells: return "Zehn Paare von leicht bis schwer."
        case .kettlebells: return "Swings, Goblet Squats, Get-ups und Tragen."
        case .pullStation: return "Klimmzüge, Dips, Hängen, Beinheben und Schlingentrainer."
        case .mobilityArea: return "Dehnen, Yoga, Pilates und Reha auf der Matte."
        case .foamRoller: return "Faszienrollen und Ball für Selbstmassage."
        case .medballs: return "Würfe, Slams und Rumpfübungen."
        case .bands: return "Leichte Zugübungen und Aktivierung mit Bändern."
        case .cardio: return "Laufband und Fahrrad-Ergometer."
        case .bodyweight: return "Platz für Übungen mit dem eigenen Körpergewicht."
        }
    }

    /// Reihenfolge der Zuordnung: speziellere Stationen zuerst
    private static let priority: [GymStation] = [.latStation, .legPress, .bench, .cableTower, .machines, .pullStation,
                                                  .foamRoller, .dumbbells, .kettlebells, .barbellRack, .medballs,
                                                  .mobilityArea, .bands, .cardio, .bodyweight]

    private static let latNames = ["Latziehen", "Sitzendes Rudern"]
    private static let legNames = ["Beinpresse", "Hackenschmidt", "Wadenheben an der Beinpresse", "Beinstrecker",
                                   "Beinbeuger", "Abduktion", "Adduktion"]
    private static let benchNames = ["Bankdrücken", "Enges Bankdrücken", "Kurzhantelrudern auf der Bank", "Fliegende",
                                     "Pullover", "Skull Crushers", "JM Press", "Hip Thrust", "Preacher Curl",
                                     "Gestütztes Rudern", "Spider Curl"]

    private static func base(_ name: String) -> String {
        name.range(of: " (").map { String(name[..<$0.lowerBound]) } ?? name
    }

    private func matches(_ ex: Exercise) -> Bool {
        let b = Self.base(ex.name)
        switch self {
        case .latStation: return [.cable, .machine].contains(ex.equipment) && Self.latNames.contains(b)
        case .legPress: return ex.equipment == .machine && Self.legNames.contains(b)
        case .bench: return [.barbell, .dumbbell].contains(ex.equipment) && Self.benchNames.contains(b)
        case .cableTower: return ex.equipment == .cable
        case .machines: return ex.equipment == .machine
        case .pullStation: return [.bar, .sling].contains(ex.equipment)
        case .foamRoller: return ex.equipment == .foam
        case .dumbbells: return ex.equipment == .dumbbell
        case .kettlebells: return ex.equipment == .kettlebell
        case .barbellRack: return ex.equipment == .barbell
        case .medballs: return ex.equipment == .medball
        case .mobilityArea: return ex.isMobility
        case .bands: return ex.equipment == .band
        case .cardio: return [.cardioGear, .bike].contains(ex.equipment)
        case .bodyweight: return ex.equipment == .none
        }
    }

    /// Station, an der eine Übung gemacht wird (nil für Draußen, Schwimmbad …)
    static func of(_ ex: Exercise) -> GymStation? {
        priority.first { $0.matches(ex) }
    }

    /// Alle Übungen dieser Station aus der Bibliothek
    var exercises: [Exercise] {
        Self.byStation[self] ?? []
    }

    private static let byStation: [GymStation: [Exercise]] = {
        var out: [GymStation: [Exercise]] = [:]
        for ex in ExerciseCatalog.library {
            if let s = of(ex) { out[s, default: []].append(ex) }
        }
        return out
    }()
}

// MARK: Zusätzliche Geräte für die Studio-Ansicht

extension GymRoom {
    /// Baut die Geräte, die es nur in der Studio-Ansicht gibt, und macht alle Stationen antippbar.
    func buildShowroom() {

        // Kabelturm vor der Mitte, Griffe hängen an den Rollen
        setLayout(GymLayout(cableHeight: 1.05, cableSetup: .sides))
        updateCables([([-0.62, 0.75, 1.05], simd_quatf(angle: 0, axis: [0, 1, 0])),
                      ([0.62, 0.75, 1.05], simd_quatf(angle: 0, axis: [0, 1, 0]))])
        register(cableTower, as: .cableTower)

        // Beinpresse an der linken Wand
        register(place("Beinpresse", [-3.15, 0, -0.35], yaw: .pi / 2), as: .legPress)
        // Klimmzug- und Dip-Station mit Schlingentrainer
        register(place("Kraftturm", [-1.95, 0, -2.55]), as: .pullStation)
        // Kraftmaschine (Brust- und Schulterpresse) an der rechten Wand
        register(place("Brustpresse", [3.35, 0, 0.55], yaw: -.pi / 2), as: .machines)
        // Cardio: Laufband und Indoor-Bike an der vorderen Wand
        register(place("Cardio", [-1.7, 0, 3.35], yaw: .pi), as: .cardio)

        // Mobility-Ecke: Matte, Faszienrollen, Medizinbälle, Bänder
        let mob = Entity()
        mob.position = [1.95, 0, -1.65]
        root.addChild(mob)
        GymProps.box([0.95, 0.025, 2.0], [0, 0.0125, 0], GymTex.paint(GymLook.teal, rough: 0.8), corner: 0.01, parent: mob)
        register(mob, as: .mobilityArea)

        let rollers = Entity()
        rollers.position = [2.85, 0, -1.25]
        root.addChild(rollers)
        let foam = SimpleMaterial(color: UIColor(red: 0.20, green: 0.45, blue: 0.85, alpha: 1), roughness: 0.8, isMetallic: false)
        for i in 0..<3 {
            GymProps.cylinder(0.90, 0.075, [0, 0.075 + Float(i) * 0.15, 0], i == 1 ? GymTex.paint(.systemTeal, rough: 0.8) : foam, axis: [0, 0, 1], parent: rollers)
        }
        GymProps.cylinder(0.07, 0.035, [0.2, 0.035, 0.45], GymTex.paint(.systemRed, rough: 0.6), parent: rollers)
        register(rollers, as: .foamRoller)

        register(place("Medizinbaelle", [2.85, 0, -2.35]), as: .medballs)
        register(place("Baender", [0.75, 0, -3.88]), as: .bands)

        // Freie Fläche: Kunstrasen rechts vorn
        let free = Entity()
        free.position = [1.6, 0, 2.2]
        root.addChild(free)
        GymProps.box([1.6, 0.008, 1.2], [0, 0.004, 0], GymLook.tiled(GymLook.turf(), scale: [1.6, 1.2], rough: 0.95), parent: free)
        for z: Float in [-0.6, 0.6] { GymProps.box([1.6, 0.01, 0.05], [0, 0.005, z], GymTex.paint(GymLook.cream, rough: 0.8), parent: free) }
        register(free, as: .bodyweight)

        for (_, e) in stations { e.generateCollisionShapes(recursive: true) }
    }

    /// Station zu einem angetippten Teil (sucht die Elternkette nach einer registrierten Station ab)
    func station(for hit: Entity) -> GymStation? {
        var e: Entity? = hit
        while let cur = e {
            if let s = stations.first(where: { $0.1 === cur }) { return s.0 }
            e = cur.parent
        }
        return nil
    }

    /// Umriss einer Station in der Welt (für Kamera und Markierung)
    func bounds(of station: GymStation) -> BoundingBox? {
        let list = stations.filter { $0.0 == station }.map(\.1)
        guard let first = list.first else { return nil }
        var b = first.visualBounds(relativeTo: nil)
        for e in list.dropFirst() { b = b.union(e.visualBounds(relativeTo: nil)) }
        return b
    }

    /// Anzahl der Teile, aus denen eine Station besteht (z. B. zwei Bänke)
    func parts(of station: GymStation) -> Int { stations.filter { $0.0 == station }.count }
}

// MARK: 3D-Ansicht

struct GymExploreScene: UIViewRepresentable {
    @Binding var selected: GymStation?
    /// Station, zu der die Kamera beim Öffnen schaut
    var focus: GymStation?

    final class Coordinator: NSObject {
        var parent: GymExploreScene
        let room = GymRoom()
        let camera = PerspectiveCamera()
        let marker = ModelEntity(mesh: .generateCylinder(height: 0.01, radius: 0.55),
                                 materials: [UnlitMaterial(color: UIColor(red: 0.95, green: 0.20, blue: 0.15, alpha: 0.55))])
        var yaw: Float = .pi
        var pitch: Float = -0.12
        var targetYaw: Float = .pi
        var targetPitch: Float = -0.12
        var fov: Float = 62
        /// Standpunkt der Kamera: Raummitte, bei Geräten nahe der Mitte (Kabelturm) weiter zurück
        var eye = SIMD3<Float>(0, 1.55, 0)
        var targetEye = SIMD3<Float>(0, 1.55, 0)
        var time: Float = 0
        var subscription: Cancellable?
        weak var view: ARView?
        var shown: GymStation?

        init(_ p: GymExploreScene) {
            parent = p
            super.init()
            room.buildShowroom()
            marker.isEnabled = false
            room.root.addChild(marker)
        }

        @objc func pan(_ g: UIPanGestureRecognizer) {
            let d = g.translation(in: g.view)
            g.setTranslation(.zero, in: g.view)
            targetYaw += Float(d.x) * 0.006
            targetPitch = min(0.6, max(-0.7, targetPitch + Float(d.y) * 0.004))
        }

        @objc func pinch(_ g: UIPinchGestureRecognizer) {
            fov = min(80, max(30, fov / Float(g.scale)))
            g.scale = 1
            camera.camera.fieldOfViewInDegrees = fov
        }

        @objc func tap(_ g: UITapGestureRecognizer) {
            guard let v = view else { return }
            let p = g.location(in: v)
            guard let hit = v.entity(at: p), let s = room.station(for: hit) else { return }
            select(s)
            parent.selected = s
        }

        /// Kamera dreht sich zur Station, eine rote Fläche markiert sie am Boden.
        /// Steht das Gerät zu nah an der Raummitte, tritt die Kamera zurück, damit es ganz ins Bild passt.
        func select(_ s: GymStation) {
            shown = s
            guard let b = room.bounds(of: s) else { return }
            let c = b.center
            targetEye = standpoint(for: b, single: room.parts(of: s) == 1)
            let d = c - targetEye
            // Blickrichtung (sin(yaw), …, -cos(yaw)) zeigt bei yaw = π nach +z
            var want = atan2(d.x, -d.z)
            while want - targetYaw > .pi { want -= 2 * .pi }
            while want - targetYaw < -.pi { want += 2 * .pi }
            targetYaw = want
            targetPitch = max(-0.5, min(0.2, atan2(d.y, simd_length(SIMD2(d.x, d.z)))))
            marker.position = [c.x, 0.012, c.z]
            marker.isEnabled = true
        }

        /// Abstand, aus dem ein Gerät ganz zu sehen ist; die Kamera bleibt in der Mitte, wenn das reicht
        private func standpoint(for b: BoundingBox, single: Bool) -> SIMD3<Float> {
            let home = SIMD3<Float>(0, 1.55, 0)
            guard single else { return home }
            let c = SIMD2(b.center.x, b.center.z)
            let half = max(b.extents.x, b.extents.z) / 2
            let need = min(3.0, max(1.8, (half + 0.25) / 0.55 + half))
            let dist = simd_length(c)
            guard dist < need else { return home }
            let away = dist > 0.01 ? -c / dist : SIMD2<Float>(0, -1)
            let p = c + away * need
            return [min(3.2, max(-3.2, p.x)), 1.55, min(3.2, max(-3.2, p.y))]
        }

        func tick(_ dt: Float) {
            time += dt
            yaw += (targetYaw - yaw) * min(1, dt * 5)
            pitch += (targetPitch - pitch) * min(1, dt * 5)
            eye += (targetEye - eye) * min(1, dt * 4)
            let dir = SIMD3<Float>(sin(yaw) * cos(pitch), sin(pitch), -cos(yaw) * cos(pitch))
            camera.look(at: eye + dir, from: eye, relativeTo: nil)
            if marker.isEnabled { marker.scale = [1, 1, 1] * (1 + 0.06 * sin(time * 4)) }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> ARView {
        let view = KickARView(frame: CGRect(x: 0, y: 0, width: 320, height: 400), cameraMode: .nonAR, automaticallyConfigureSession: false)
        view.environment.background = .color(.black)
        GymLook.applyEnvironment(to: view)
        let c = context.coordinator
        c.view = view
        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(c.room.root)
        c.camera.camera.fieldOfViewInDegrees = c.fov
        anchor.addChild(c.camera)
        view.scene.addAnchor(anchor)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: c, action: #selector(Coordinator.pan(_:))))
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: c, action: #selector(Coordinator.pinch(_:))))
        view.addGestureRecognizer(UITapGestureRecognizer(target: c, action: #selector(Coordinator.tap(_:))))
        c.subscription = view.scene.subscribe(to: SceneEvents.Update.self) { [weak c] e in c?.tick(Float(e.deltaTime)) }
        if let f = focus { c.select(f) }
        c.tick(1)
        return view
    }

    func updateUIView(_ view: ARView, context: Context) {
        let c = context.coordinator
        c.parent = self
        if let s = selected, s != c.shown { c.select(s) }
    }
}

// MARK: Bildschirme

/// Das Studio zum Umschauen; unten alle Stationen als Knöpfe
struct GymExploreView: View {
    var focus: GymStation? = nil
    @State private var selected: GymStation?
    @State private var sheet: GymStation?

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                GymExploreScene(selected: $selected, focus: focus)
                Text("Wischen zum Umschauen, Gerät antippen")
                    .font(.footnote)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.top, 10)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(GymStation.allCases) { s in
                        Button {
                            selected = s
                            sheet = s
                        } label: {
                            Label(s.title, systemImage: s.icon)
                                .font(.subheadline)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(selected == s ? Color.accentColor.opacity(0.25) : Color(.secondarySystemBackground),
                                            in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(12)
            }
        }
        .navigationTitle("Fitnessstudio")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selected) { _, s in if let s { sheet = s } }
        .onAppear { if let focus { selected = focus } }
        .sheet(item: $sheet) { s in
            NavigationStack { GymStationView(station: s) }
                .presentationDetents([.medium, .large])
        }
    }
}

/// Übungen an einer Station, nach Übung gruppiert (Varianten aufklappbar)
struct GymStationView: View {
    let station: GymStation
    @State private var muscle: Muscle?
    @Environment(\.dismiss) private var dismiss

    private var groups: [(String, [Exercise])] {
        let list = station.exercises.filter { muscle == nil || $0.primary.contains(muscle!) }
        var order: [String] = []
        var map: [String: [Exercise]] = [:]
        for ex in list {
            let b = ex.name.range(of: " (").map { String(ex.name[..<$0.lowerBound]) } ?? ex.name
            if map[b] == nil { order.append(b) }
            map[b, default: []].append(ex)
        }
        return order.map { ($0, map[$0]!) }
    }

    var body: some View {
        let g = groups
        List {
            Section {
                Text(station.info).font(.subheadline).foregroundStyle(.secondary)
                Picker("Muskelgruppe", selection: $muscle) {
                    Text("Alle").tag(Muscle?.none)
                    ForEach(Muscle.allCases) { Text($0.rawValue).tag(Muscle?.some($0)) }
                }
            } footer: {
                Text("\(g.count) Übungen, \(g.reduce(0) { $0 + $1.1.count }) Varianten")
            }
            ForEach(g, id: \.0) { name, list in
                if list.count == 1, let ex = list.first {
                    NavigationLink { ExerciseDetailView(exercise: ex) } label: {
                        ExerciseRow(exercise: ex, detail: ex.equipment.rawValue)
                    }
                } else {
                    DisclosureGroup {
                        ForEach(list) { ex in
                            NavigationLink { ExerciseDetailView(exercise: ex) } label: {
                                ExerciseRow(exercise: ex, detail: ex.equipment.rawValue)
                            }
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(name)
                            Text("\(list.count) Varianten").font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(station.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Fertig") { dismiss() } } }
    }
}
