import SwiftUI
import RealityKit
import UIKit
import Combine

// RealityKit-Ansicht für den lizenzfreien FitScan-Körper (CC0, MakeHuman-Basis).
// Benötigt FitScan_Skin.usdz und FitScan_Motions.bin im App-Target.
// Ersetzt die alte SceneKit-Figur; Name und Parameter von MuscleModelView bleiben gleich.

struct MuscleModelView: View {
    let primary: [Muscle]
    var secondary: [Muscle] = []
    var height: CGFloat = 300
    /// Bewegung des Körpers; nil = ruhige Standhaltung (Atmung)
    var motion: BodyMotion? = nil
    var gear: PropGear = .auto
    /// Beschriftung der Legende (rot / gelb)
    var primaryLabel = "Aktiv"
    var secondaryLabel = "Passiv"
    @State private var showBack: Bool

    init(primary: [Muscle], secondary: [Muscle] = [], height: CGFloat = 300, motion: BodyMotion? = nil, gear: PropGear = .auto,
         primaryLabel: String = "Aktiv", secondaryLabel: String = "Passiv") {
        self.primaryLabel = primaryLabel
        self.secondaryLabel = secondaryLabel
        self.motion = motion
        self.gear = gear
        self.primary = primary
        self.secondary = secondary
        self.height = height
        let back = primary.filter(\.isBackSide).count
        _showBack = State(initialValue: back > primary.count - back)
    }

    var body: some View {
        VStack(spacing: 8) {
            MuscleRealityScene(primary: primary, secondary: secondary, showBack: showBack, motion: motion ?? .idle, gear: gear)
                .frame(height: height)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Picker("Ansicht", selection: $showBack) {
                Text("Vorne").tag(false)
                Text("Hinten").tag(true)
            }
            .pickerStyle(.segmented)
            MuscleLegend(primary: primary, secondary: secondary, primaryLabel: primaryLabel, secondaryLabel: secondaryLabel)
        }
    }
}

/// Legende unter dem 3D-Körper: aktiv (rot) und passiv (gelb) beanspruchte Muskelgruppen.
struct MuscleLegend: View {
    let primary: [Muscle]
    let secondary: [Muscle]
    var primaryLabel = "Aktiv"
    var secondaryLabel = "Passiv"

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !primary.isEmpty { row(Color(uiColor: MuscleHighlight.active), primaryLabel, primary) }
            let passive = secondary.filter { !primary.contains($0) }
            if !passive.isEmpty { row(Color(uiColor: MuscleHighlight.passive), secondaryLabel, passive) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func row(_ color: Color, _ title: String, _ muscles: [Muscle]) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(title).font(.footnote.bold())
            Text(muscles.map(\.rawValue).joined(separator: ", "))
                .font(.footnote).foregroundStyle(.secondary)
        }
    }
}

/// RealityKit-Szene: durchgehender Körper mit Skelett, Bewegung aus FitScan_Motions.bin. Mit dem Finger drehen.
/// Aktive Muskeln (primary) leuchten rot, passive (secondary) gelb – siehe MuscleSegmentation.swift.
/// ARView, das nach dem Einblenden mehrfach ein Neu-Layout/Neuzeichnen anstößt.
/// Behebt, dass die 3D-Fläche erst nach einem Scroll sichtbar wurde.
final class KickARView: ARView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        for d in [0.05, 0.3, 0.8, 1.6, 3.0] {
            DispatchQueue.main.asyncAfter(deadline: .now() + d) { [weak self] in
                guard let self = self, self.window != nil else { return }
                self.setNeedsLayout()
                self.layoutIfNeeded()
                self.setNeedsDisplay()
                self.layer.setNeedsDisplay()
                let a = self.alpha
                self.alpha = a * 0.999
                self.alpha = a
            }
        }
    }
}

struct MuscleRealityScene: UIViewRepresentable {
    let primary: [Muscle]
    let secondary: [Muscle]
    let showBack: Bool
    var motion: BodyMotion = .idle
    var gear: PropGear = .auto
    /// Eigene Form; nil = gespeicherte Form (BodyShape.current) beim Erstellen
    var shape: BodyShape? = nil

    static let neutralBody = UIColor(white: 0.80, alpha: 1)

    final class Coordinator: NSObject {
        let turntable = Entity()
        var subscription: Cancellable?
        var time: Float = 0
        var baseYaw: Float = 0
        var targetYaw: Float = 0
        var userYaw: Float = 0
        var dragging = false
        let rig = BodyRig()
        var motion: BodyMotion = .idle
        var gear: PropGear = .auto
        var motionDef: Motion = BodyRig.library[.idle]!
        var clip: MotionClip? = MotionStore.clips["idle"]
        var camera: PerspectiveCamera?
        var started = false
        var layout = GymLayout()
        var highlightKey = ""

        @objc func pan(_ g: UIPanGestureRecognizer) {
            switch g.state {
            case .began: dragging = true
            case .ended, .cancelled, .failed: dragging = false
            default:
                let dx = Float(g.translation(in: g.view).x)
                g.setTranslation(.zero, in: g.view)
                userYaw += dx * 0.01
            }
        }

        static func material(_ color: UIColor) -> PhysicallyBasedMaterial {
            var m = PhysicallyBasedMaterial()
            m.baseColor = .init(tint: color)
            m.roughness = .init(floatLiteral: 0.55)
            m.metallic = .init(floatLiteral: 0)
            return m
        }

        func tick(_ dt: Float) {
            time += dt
            // Sanftes Pendeln, solange man nicht dreht; Vorne/Hinten gleitet weich
            baseYaw += (targetYaw - baseYaw) * min(1, dt * 6)
            let sway: Float = dragging ? 0 : (motion == .idle ? 0.22 : 0.07) * sin(time * 0.7)
            rig.apply(motionDef, clip: clip, time: time, gear: gear)
            // Der Raum steht fest, die Kamera kreist um den Körper
            let a = baseYaw + userYaw + sway
            let r = layout.radius
            camera?.look(at: [0, motionDef.camY, 0], from: [-r * sin(a), motionDef.camY + 0.05, r * cos(a)], relativeTo: nil)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> ARView {
        let view = KickARView(frame: CGRect(x: 0, y: 0, width: 320, height: 340), cameraMode: .nonAR, automaticallyConfigureSession: false)
        view.environment.background = .color(.black)
        let c = context.coordinator

        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(c.turntable)

        c.turntable.addChild(c.rig.root)
        c.turntable.addChild(c.rig.bench)
        c.turntable.addChild(c.rig.pullBar)
        c.turntable.addChild(c.rig.wall)
        do {
            let model = try Entity.load(named: "FitScan_Skin")
            c.rig.attachBody(model, material: Coordinator.material(MuscleRealityScene.neutralBody))
            c.rig.applyShape(shape ?? BodyShape.current)
        } catch {
            print("FitScan: USDZ-Laden fehlgeschlagen: \(error)")
        }

        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 36
        anchor.addChild(camera)
        camera.look(at: [0, 0.9, 0], from: [-1.6, 0.95, 2.5], relativeTo: nil)
        c.camera = camera
        view.scene.addAnchor(anchor)

        view.addGestureRecognizer(UIPanGestureRecognizer(target: c, action: #selector(Coordinator.pan(_:))))
        c.subscription = view.scene.subscribe(to: SceneEvents.Update.self) { [weak c] event in
            c?.tick(Float(event.deltaTime))
        }
        return view
    }

    func updateUIView(_ view: ARView, context: Context) {
        let c = context.coordinator
        if let shape { c.rig.applyShape(shape) }
        let key = primary.map(\.rawValue).joined(separator: ",") + "|" + secondary.map(\.rawValue).joined(separator: ",")
        if key != c.highlightKey {
            c.highlightKey = key
            c.rig.setHighlight(primary: primary, secondary: secondary, neutral: MuscleRealityScene.neutralBody)
        }
        if c.motion != motion || c.gear != gear || !c.started {
            c.started = true
            c.motion = motion
            c.gear = gear
            let def = BodyRig.library[motion] ?? BodyRig.library[.idle]!
            c.motionDef = def
            c.rig.beginTransition()
            c.clip = MotionStore.clips[motion.rawValue] ?? MotionStore.clips["idle"]
            c.time = 0
            c.layout = GymLayout.forMotion(motion, def: def, gear: gear)
            c.rig.gym.setLayout(c.layout)
            c.camera?.camera.fieldOfViewInDegrees = c.layout.fov
        }
        let target: Float = (showBack ? .pi : 0) + (c.layout.yaw ?? c.motionDef.yaw)
        if abs(c.targetYaw - target) > 0.01 {
            c.targetYaw = target
            c.userYaw = 0
        }
    }
}

#Preview {
    MuscleModelView(primary: [.chest, .triceps], secondary: [.shoulders])
        .padding()
}

/// Kompakte Muskelanzeige für Listen: rote Punkte = aktiv, gelbe = passiv.
struct MuscleChips: View {
    let primary: [Muscle]
    let secondary: [Muscle]

    var body: some View {
        let passive = secondary.filter { !primary.contains($0) }
        HStack(spacing: 8) {
            chip(Color(uiColor: MuscleHighlight.active), primary)
            if !passive.isEmpty { chip(Color(uiColor: MuscleHighlight.passive), passive) }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Aktiv: \(primary.map(\.rawValue).joined(separator: ", ")). Passiv: \(passive.map(\.rawValue).joined(separator: ", "))")
    }

    private func chip(_ color: Color, _ muscles: [Muscle]) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 7, height: 7)
            Text(muscles.map(\.rawValue).joined(separator: ", ")).lineLimit(1)
        }
        .font(.caption).foregroundStyle(.secondary)
    }
}
