import Foundation

/// Baut aus der kompakten Tabelle in ExerciseDB die vollständige Übungsbibliothek.
enum ExerciseGenerator {
    private static let muscleMap: [String: Muscle] = [
        "ch": .chest, "la": .lats, "tr": .traps, "sh": .shoulders, "bi": .biceps, "tri": .triceps, "fo": .forearms,
        "ab": .abs, "lb": .lowerBack, "gl": .glutes, "qu": .quads, "ha": .hamstrings, "ad": .adductors,
        "hf": .hipFlexors, "ca": .calves, "ne": .neck
    ]
    private static let catMap: [String: Category] = [
        "strength": .strength, "calisthenics": .calisthenics, "core": .core, "drill": .drill, "mobility": .mobility,
        "cardio": .cardio, "plyo": .plyo, "functional": .functional
    ]
    private static let eqMap: [String: Equipment] = [
        "none": .none, "dumbbell": .dumbbell, "barbell": .barbell, "bar": .bar, "cable": .cable, "machine": .machine,
        "kettlebell": .kettlebell, "band": .band, "sling": .sling, "medball": .medball, "foam": .foam,
        "cardio": .cardioGear, "outdoor": .outdoor, "bike": .bike, "pool": .pool
    ]
    private static let regionMap: [String: MobilityRegion] = [
        "hip": .hip, "ankle": .ankle, "shoulder": .shoulder, "back": .back, "neck": .neck, "legs": .legs, "wrist": .wrist
    ]

    private static func muscles(_ s: Substring) -> [Muscle] {
        s.split(separator: " ").compactMap { muscleMap[String($0)] }
    }

    static let all: [Exercise] = {
        struct Fam {
            let cat: Category; let kind: LogKind; let prim: [Muscle]; let sec: [Muscle]; let motion: String
            let target: String; let region: MobilityRegion?; let dose: String; let secs: Int; let per: Bool
            let sf: Double; let tips: [String]
        }
        let fams: [Fam] = ExerciseDB.families.split(separator: "\n").map { line in
            let p = line.split(separator: "|", maxSplits: 11, omittingEmptySubsequences: false)
            let kind: LogKind = p[1] == "bw" ? .bodyweight : (p[1] == "sec" ? .seconds : .weighted)
            return Fam(cat: catMap[String(p[0])] ?? .strength, kind: kind, prim: muscles(p[2]), sec: muscles(p[3]),
                       motion: String(p[4]), target: String(p[5]), region: regionMap[String(p[6])],
                       dose: String(p[7]), secs: Int(p[8]) ?? 0, per: p[9] == "1", sf: Double(p[10]) ?? 0,
                       tips: p[11].split(separator: "~").map(String.init))
        }
        var out: [Exercise] = []
        out.reserveCapacity(4400)
        for line in ExerciseDB.rows.split(separator: "\n") {
            let p = line.split(separator: "|", maxSplits: 3, omittingEmptySubsequences: false)
            guard p.count == 4, let fi = Int(p[1]), fi < fams.count else { continue }
            let f = fams[fi]
            var tips = f.tips
            if !p[3].isEmpty { tips.insert(String(p[3]), at: 0) }
            var ex = Exercise(name: String(p[0]), category: f.cat, region: f.region, primary: f.prim, secondary: f.sec,
                              equipment: eqMap[String(p[2])] ?? .none, kind: f.kind, dose: f.dose,
                              seconds: f.secs > 0 ? f.secs : nil, perSide: f.per, tips: tips,
                              startFactor: f.sf > 0 ? f.sf : nil)
            ex.motionKey = f.motion
            ex.target = f.target
            ex.videoName = String(format: "bf_%03d_%@", fi, f.motion)
            out.append(ex)
        }
        return out
    }()
}
