// AUTOMATISCH ERZEUGT (tools/skin/bake_all.py) – Beschreibung der Übungsbewegungen. Die Gelenkdaten stehen in FitScan_Motions.bin.
import simd

enum BodyMotion: String, CaseIterable {
    case curl
    case benchPress
    case overhead
    case lateral
    case triceps
    case row
    case pullup
    case hang
    case legRaise
    case squat
    case deepSquat
    case rdl
    case lunge
    case calf
    case crunch
    case kneeRaise
    case buttKick
    case jumpRope
    case legSwing
    case quadStretch
    case kneeHug
    case forwardFold
    case chestStretch
    case crossBody
    case neckTilt
    case idle
    case catCow
    case wristRock
    case heelSit
    case childPose
    case cobra
    case sitFold
    case supineHam
    case hipStretch
    case wgs
    case calfWall
    case kneeWall
    case wallSlide
    case stabDislocate
    case chinTuck
    case cossack
    case bwsRotate
    case plank
    case bridge
    case pushup
    case deadBug
    case hollowHold
}

extension BodyRig {
    static let library: [BodyMotion: Motion] = [
        .curl: Motion(period: 3.8, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .benchPress: Motion(period: 3.9, lying: true, bench: true, free: false, wallZ: nil, yaw: 1.15, camY: 0.55, props: .dumbbell),
        .overhead: Motion(period: 3.6, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .lateral: Motion(period: 3.6, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .triceps: Motion(period: 3.8, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .row: Motion(period: 3.6, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .pullup: Motion(period: 4.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.35, camY: 1.3, props: .pullbar),
        .hang: Motion(period: 4.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.35, camY: 1.3, props: .pullbar),
        .legRaise: Motion(period: 3.8, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.35, camY: 1.3, props: .pullbar),
        .squat: Motion(period: 3.9, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .deepSquat: Motion(period: 5.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .rdl: Motion(period: 4.4, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .lunge: Motion(period: 8.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .calf: Motion(period: 3.2, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .crunch: Motion(period: 3.2, lying: true, bench: false, free: false, wallZ: nil, yaw: 1.2, camY: 0.5, props: .none),
        .kneeRaise: Motion(period: 2.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .buttKick: Motion(period: 1.6, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .jumpRope: Motion(period: 0.9, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .legSwing: Motion(period: 2.4, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .quadStretch: Motion(period: 5.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .kneeHug: Motion(period: 4.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .forwardFold: Motion(period: 6.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .chestStretch: Motion(period: 5.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .crossBody: Motion(period: 5.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .neckTilt: Motion(period: 6.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .idle: Motion(period: 6.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .catCow: Motion(period: 5.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.45, props: .none),
        .wristRock: Motion(period: 6.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.45, props: .none),
        .heelSit: Motion(period: 6.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.6, props: .none),
        .childPose: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .cobra: Motion(period: 7.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.3, props: .none),
        .sitFold: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .supineHam: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .hipStretch: Motion(period: 14.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.9, camY: 0.8, props: .none),
        .wgs: Motion(period: 14.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.9, camY: 0.8, props: .none),
        .calfWall: Motion(period: 8.0, lying: false, bench: false, free: false, wallZ: 0.64, yaw: 1.15, camY: 0.9, props: .none),
        .kneeWall: Motion(period: 5.0, lying: false, bench: false, free: false, wallZ: 0.64, yaw: 1.15, camY: 0.9, props: .none),
        .wallSlide: Motion(period: 5.0, lying: false, bench: false, free: false, wallZ: -0.125, yaw: 1.15, camY: 0.95, props: .none),
        .stabDislocate: Motion(period: 7.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.5, camY: 1.0, props: .none),
        .chinTuck: Motion(period: 4.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.2, camY: 1.45, props: .none),
        .cossack: Motion(period: 10.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.2, camY: 0.8, props: .none),
        .bwsRotate: Motion(period: 12.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.5, props: .none),
        .plank: Motion(period: 6.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.45, props: .none),
        .bridge: Motion(period: 4.4, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .pushup: Motion(period: 3.8, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .deadBug: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .hollowHold: Motion(period: 6.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
    ]
}
