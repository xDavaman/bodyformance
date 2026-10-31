// AUTOMATISCH ERZEUGT (tools/motions, python -m motions backen) – Beschreibung der Übungsbewegungen.
// Die Gelenkdaten stehen in FitScan_Motions.bin.
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
    case squatBar
    case benchBar
    case overheadBar
    case rdlBar
    case rowBar
    case curlBar
    case squatDb
    case lungeDb
    case calfDb
    case fly
    case pullover
    case frontRaise
    case uprightRow
    case kickback
    case skull
    case pushdown
    case facePull
    case flyCable
    case swing
    case walk
    case farmer
    case run
    case downDog
    case hundred
    case boat
    case teaser
    case rollUp
    case singleLegStretch
    case doubleLegStretch
    case scissors
    case swimming
    case warrior1
    case warrior2
    case tree
    case chair
    case seatTwist
    case sideBend
    case camel
    case supKneeHug
    case supTwist
    case tricepStretch
    case triangle
    case sunA
    case sunB
    case warrior3
    case halfMoon
    case pigeon
    case plow
    case neckDiag
    case neckFwd
    case neckHand
    case neckRotate
    case armBehind
    case towelStretch
    case wallShoulder
    case doorChest
    case handsBehind
    case barChest
    case sleeper
    case floorChest
    case threadNeedle
    case latDoor
    case butterfly
    case frog
    case ninety
    case figureFour
    case couchStretch
    case quadLying
    case itbStretch
    case halfSplit
    case soleusWall
    case calfStep
    case calfBand
    case ankleCircle
    case ankleRock
    case wristCircle
    case wristFlexor
    case wristExtensor
    case prayer
    case rollQuad
    case rollHam
    case rollCalf
    case rollGlute
    case rollItb
    case rollUpperBack
    case rollLat
    case rollNeck
    case rollFoot
    case rollerChest
    case pullApart
    case shoulderCircle
    case ytw
    case extRotation
    case scapPushup
    case bearHold
    case birdDog
    case clamShell
    case mcgill
    case sidePlank
    case monsterWalk
    case singleLeg
    case heelWalk
    case toeWalk
    case sideLegCircle
    case swan
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
        .sitFold: Motion(period: 8.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .supineHam: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .hipStretch: Motion(period: 14.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.9, camY: 0.8, props: .none),
        .wgs: Motion(period: 15.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.9, camY: 0.8, props: .none),
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
        .squatBar: Motion(period: 4.4, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .barbell),
        .benchBar: Motion(period: 4.2, lying: true, bench: true, free: false, wallZ: nil, yaw: 1.15, camY: 0.55, props: .barbell),
        .overheadBar: Motion(period: 4.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .barbell),
        .rdlBar: Motion(period: 4.6, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .barbell),
        .rowBar: Motion(period: 3.8, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .barbell),
        .curlBar: Motion(period: 3.8, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .barbell),
        .squatDb: Motion(period: 3.9, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .lungeDb: Motion(period: 8.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .calfDb: Motion(period: 3.2, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .fly: Motion(period: 4.2, lying: true, bench: true, free: false, wallZ: nil, yaw: 1.15, camY: 0.55, props: .dumbbell),
        .pullover: Motion(period: 4.6, lying: true, bench: true, free: false, wallZ: nil, yaw: 1.15, camY: 0.55, props: .dumbbell),
        .frontRaise: Motion(period: 3.8, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .uprightRow: Motion(period: 3.8, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .kickback: Motion(period: 3.6, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .skull: Motion(period: 4.0, lying: true, bench: true, free: false, wallZ: nil, yaw: 1.15, camY: 0.55, props: .dumbbell),
        .pushdown: Motion(period: 3.4, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .facePull: Motion(period: 3.8, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .flyCable: Motion(period: 3.8, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .swing: Motion(period: 2.6, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .walk: Motion(period: 1.15, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .farmer: Motion(period: 1.3, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .dumbbell),
        .run: Motion(period: 0.72, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .downDog: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.45, props: .none),
        .hundred: Motion(period: 1.6, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .boat: Motion(period: 6.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.5, props: .none),
        .teaser: Motion(period: 7.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.2, camY: 0.5, props: .none),
        .rollUp: Motion(period: 7.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.5, props: .none),
        .singleLegStretch: Motion(period: 4.0, lying: true, bench: false, free: false, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .doubleLegStretch: Motion(period: 4.0, lying: true, bench: false, free: false, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .scissors: Motion(period: 3.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .swimming: Motion(period: 2.0, lying: true, bench: false, free: false, wallZ: nil, yaw: 1.2, camY: 0.3, props: .none),
        .warrior1: Motion(period: 14.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.9, camY: 0.8, props: .none),
        .warrior2: Motion(period: 10.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.15, camY: 0.85, props: .none),
        .tree: Motion(period: 14.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.35, camY: 0.85, props: .none),
        .chair: Motion(period: 7.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.55, camY: 0.9, props: .none),
        .seatTwist: Motion(period: 10.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.12, camY: 0.5, props: .none),
        .sideBend: Motion(period: 10.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.35, camY: 0.9, props: .none),
        .camel: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.6, props: .none),
        .supKneeHug: Motion(period: 6.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .supTwist: Motion(period: 10.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.25, camY: 0.5, props: .none),
        .tricepStretch: Motion(period: 10.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.35, camY: 0.9, props: .none),
        .triangle: Motion(period: 12.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.15, camY: 0.85, props: .none),
        .sunA: Motion(period: 18.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.25, camY: 0.7, props: .none),
        .sunB: Motion(period: 24.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.25, camY: 0.7, props: .none),
        .warrior3: Motion(period: 12.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.3, camY: 0.9, props: .none),
        .halfMoon: Motion(period: 13.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.12, camY: 0.85, props: .none),
        .pigeon: Motion(period: 14.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.35, props: .none),
        .plow: Motion(period: 14.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.35, camY: 0.4, props: .none),
        .neckDiag: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.35, camY: 1.25, props: .none),
        .neckFwd: Motion(period: 12.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.9, camY: 1.3, props: .none),
        .neckHand: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.15, camY: 1.25, props: .none),
        .neckRotate: Motion(period: 10.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.3, camY: 1.25, props: .none),
        .armBehind: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 2.6, camY: 1.0, props: .none),
        .towelStretch: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 2.5, camY: 1.1, props: .none),
        .wallShoulder: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: 0.56, yaw: 1.9, camY: 1.0, props: .none),
        .doorChest: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.5, camY: 1.1, props: .post),
        .handsBehind: Motion(period: 12.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 2.2, camY: 1.0, props: .none),
        .barChest: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.9, camY: 1.0, props: .post),
        .sleeper: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.35, props: .none),
        .floorChest: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.6, camY: 0.3, props: .none),
        .threadNeedle: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.5, camY: 0.4, props: .none),
        .latDoor: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.4, camY: 1.1, props: .post),
        .butterfly: Motion(period: 12.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.5, camY: 0.4, props: .none),
        .frog: Motion(period: 12.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.3, camY: 0.35, props: .none),
        .ninety: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.4, camY: 0.35, props: .none),
        .figureFour: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.35, props: .none),
        .couchStretch: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: -0.62, yaw: 1.3, camY: 0.5, props: .none),
        .quadLying: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.35, props: .none),
        .itbStretch: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.1, camY: 0.9, props: .none),
        .halfSplit: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.3, camY: 0.45, props: .none),
        .soleusWall: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: 0.64, yaw: 1.15, camY: 0.9, props: .none),
        .calfStep: Motion(period: 10.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.3, camY: 0.8, props: .step),
        .calfBand: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .none),
        .ankleCircle: Motion(period: 12.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.0, camY: 0.5, props: .none),
        .ankleRock: Motion(period: 6.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.3, camY: 0.5, props: .none),
        .wristCircle: Motion(period: 6.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.5, camY: 1.1, props: .none),
        .wristFlexor: Motion(period: 12.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.1, camY: 1.1, props: .none),
        .wristExtensor: Motion(period: 12.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.1, camY: 1.1, props: .none),
        .prayer: Motion(period: 10.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.0, camY: 1.1, props: .none),
        .rollQuad: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.35, camY: 0.35, props: .roller),
        .rollHam: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.35, camY: 0.35, props: .roller),
        .rollCalf: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.35, camY: 0.3, props: .roller),
        .rollGlute: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.35, props: .roller),
        .rollItb: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.35, props: .roller),
        .rollUpperBack: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.35, camY: 0.35, props: .roller),
        .rollLat: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.35, props: .roller),
        .rollNeck: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.35, camY: 0.3, props: .roller),
        .rollFoot: Motion(period: 12.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.2, camY: 0.4, props: .ball),
        .rollerChest: Motion(period: 12.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.35, camY: 0.35, props: .roller),
        .pullApart: Motion(period: 6.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.4, camY: 1.15, props: .none),
        .shoulderCircle: Motion(period: 5.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.6, camY: 1.2, props: .none),
        .ytw: Motion(period: 12.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.25, camY: 1.0, props: .none),
        .extRotation: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.4, props: .none),
        .scapPushup: Motion(period: 5.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.35, camY: 0.45, props: .none),
        .bearHold: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.3, camY: 0.4, props: .none),
        .birdDog: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.3, camY: 0.45, props: .none),
        .clamShell: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.35, props: .none),
        .mcgill: Motion(period: 12.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.3, camY: 0.3, props: .none),
        .sidePlank: Motion(period: 16.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.4, props: .none),
        .monsterWalk: Motion(period: 6.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.3, camY: 0.7, props: .none),
        .singleLeg: Motion(period: 16.0, lying: false, bench: false, free: false, wallZ: nil, yaw: 0.5, camY: 0.9, props: .none),
        .heelWalk: Motion(period: 2.4, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.2, camY: 0.6, props: .none),
        .toeWalk: Motion(period: 2.4, lying: false, bench: false, free: false, wallZ: nil, yaw: 1.2, camY: 0.6, props: .none),
        .sideLegCircle: Motion(period: 12.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 0.9, camY: 0.4, props: .none),
        .swan: Motion(period: 8.0, lying: false, bench: false, free: true, wallZ: nil, yaw: 1.3, camY: 0.4, props: .none),
    ]
}
