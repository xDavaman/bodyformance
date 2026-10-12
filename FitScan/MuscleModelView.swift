import SwiftUI
import RealityKit
import UIKit
import Combine

// RealityKit-Ansicht für den lizenzfreien FitScan-Körper (CC0, MakeHuman-Basis).
// Benötigt FitScan_Skin.usdz und FitScan_Motions.bin im App-Target.
// Ersetzt die alte SceneKit-Figur; Name und Parameter von MuscleModelView bleiben gleich.

/// Zuordnung der Teilnetze (feine Einzelmuskeln) zu deinen App-Muskelgruppen.
enum BodyParts {
    static let muscleOfPart: [String: Muscle] = [
        "muscle_chest_upper": .chest,
        "muscle_chest_lower": .chest,
        "muscle_delt_front": .shoulders,
        "muscle_delt_side": .shoulders,
        "muscle_delt_rear": .shoulders,
        "muscle_traps_upper": .traps,
        "muscle_traps_mid": .traps,
        "muscle_traps_lower": .traps,
        "muscle_scapula": .traps,
        "muscle_rhomboid": .traps,
        "muscle_lats": .lats,
        "muscle_erector_l": .lowerBack,
        "muscle_abs_0": .abs,
        "muscle_abs_1": .abs,
        "muscle_abs_2": .abs,
        "muscle_abs_3": .abs,
        "muscle_obliques": .abs,
        "muscle_serratus": .abs,
        "muscle_biceps_long": .biceps,
        "muscle_biceps_short": .biceps,
        "muscle_triceps_long": .triceps,
        "muscle_triceps_lat": .triceps,
        "muscle_forearm_flexor": .forearms,
        "muscle_forearm_extensor": .forearms,
        "muscle_glute_max": .glutes,
        "muscle_glute_med": .glutes,
        "muscle_hip_flexor": .hipFlexors,
        "muscle_rectus_fem": .quads,
        "muscle_vastus_lat": .quads,
        "muscle_vastus_med": .quads,
        "muscle_hamstring_out": .hamstrings,
        "muscle_hamstring_in": .hamstrings,
        "muscle_adductors": .adductors,
        "muscle_gastro_med": .calves,
        "muscle_gastro_lat": .calves,
        "muscle_soleus": .calves,
        "muscle_tibialis": .calves,
        "muscle_neck": .neck
    ]
}

/// Atlas-Farben (jede Einzelmuskelgruppe eigene Farbe). Wird gezeigt, wenn keine Muskeln hervorgehoben werden.
enum AtlasColors {
    static let rgb: [String: (CGFloat, CGFloat, CGFloat)] = [
        "muscle_chest_upper": (0.700, 0.196, 0.280),
        "muscle_chest_lower": (0.860, 0.241, 0.344),
        "muscle_delt_front": (0.820, 0.470, 0.164),
        "muscle_delt_side": (0.980, 0.562, 0.196),
        "muscle_delt_rear": (0.880, 0.505, 0.176),
        "muscle_traps_upper": (0.750, 0.663, 0.225),
        "muscle_traps_mid": (0.910, 0.804, 0.273),
        "muscle_traps_lower": (0.810, 0.716, 0.243),
        "muscle_scapula": (0.439, 0.620, 0.310),
        "muscle_rhomboid": (0.552, 0.780, 0.390),
        "muscle_lats": (0.261, 0.580, 0.421),
        "muscle_erector_l": (0.261, 0.553, 0.580),
        "muscle_abs_0": (0.312, 0.624, 0.780),
        "muscle_abs_1": (0.376, 0.752, 0.940),
        "muscle_abs_2": (0.336, 0.672, 0.840),
        "muscle_abs_3": (0.392, 0.784, 0.980),
        "muscle_obliques": (0.315, 0.475, 0.700),
        "muscle_serratus": (0.387, 0.584, 0.860),
        "muscle_biceps_long": (0.800, 0.250, 0.200),
        "muscle_biceps_short": (0.960, 0.300, 0.240),
        "muscle_triceps_long": (0.502, 0.374, 0.680),
        "muscle_triceps_lat": (0.620, 0.462, 0.840),
        "muscle_forearm_flexor": (0.680, 0.555, 0.306),
        "muscle_forearm_extensor": (0.840, 0.686, 0.378),
        "muscle_glute_max": (0.680, 0.306, 0.555),
        "muscle_glute_med": (0.840, 0.378, 0.686),
        "muscle_hip_flexor": (0.385, 0.700, 0.647),
        "muscle_rectus_fem": (0.312, 0.390, 0.780),
        "muscle_vastus_lat": (0.376, 0.470, 0.940),
        "muscle_vastus_med": (0.336, 0.420, 0.840),
        "muscle_hamstring_out": (0.596, 0.325, 0.650),
        "muscle_adductors": (0.535, 0.620, 0.279),
        "muscle_gastro_med": (0.248, 0.620, 0.372),
        "muscle_gastro_lat": (0.312, 0.780, 0.468),
        "muscle_soleus": (0.272, 0.680, 0.408),
        "muscle_tibialis": (0.328, 0.820, 0.492),
        "muscle_neck": (0.700, 0.578, 0.490)
    ]
    static func color(for part: String) -> UIColor? {
        guard let c = rgb[part] else { return nil }
        return UIColor(red: c.0, green: c.1, blue: c.2, alpha: 1)
    }
}

struct MuscleModelView: View {
    let primary: [Muscle]
    var secondary: [Muscle] = []
    var height: CGFloat = 300
    /// Bewegung des Körpers; nil = ruhige Standhaltung (Atmung)
    var motion: BodyMotion? = nil
    var gear: PropGear = .auto
    @State private var showBack: Bool

    init(primary: [Muscle], secondary: [Muscle] = [], height: CGFloat = 300, motion: BodyMotion? = nil, gear: PropGear = .auto) {
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
            Text(primary.map(\.rawValue).joined(separator: ", "))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

/// RealityKit-Szene: durchgehender Körper mit Skelett, Bewegung aus FitScan_Motions.bin. Mit dem Finger drehen.
/// Muskelfarben sind vorerst abgeschaltet (Zuordnung wird neu erarbeitet).
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
        if c.motion != motion || c.gear != gear || !c.started {
            c.started = true
            c.motion = motion
            c.gear = gear
            let def = BodyRig.library[motion] ?? BodyRig.library[.idle]!
            c.motionDef = def
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
