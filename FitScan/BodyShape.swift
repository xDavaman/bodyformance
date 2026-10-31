import RealityKit
import SwiftUI
import simd

// Eigene 3D-Figur: Die Figur aus FitScan (FitScan_Skin.usdz) wird an den eigenen Körper angepasst.
// Grundlage sind Größe, Gewicht und Körperfett (Schätzung), auf Wunsch die Maße aus dem letzten Körperscan,
// dazu lassen sich einzelne Körperregionen von Hand verstellen. Das Netz wird dafür einmal in der Grundhaltung
// verformt (Skelett, Gewichte und Bewegungen bleiben gleich). Alles bleibt auf dem Gerät.

// MARK: - Körperfett

nonisolated enum Sex: String, CaseIterable, Identifiable, Codable {
    case male = "Mann", female = "Frau"
    var id: String { rawValue }
}

/// Eingaben für Körperfett und Figur (Zentimeter, Kilogramm)
nonisolated struct BodyStats {
    var heightCm: Double
    var weightKg: Double
    var age: Int
    var sex: Sex
    var waistCm: Double
    var neckCm: Double
    var hipCm: Double

    /// Dieselben Werte wie im Profil (UserDefaults), mit den Voreinstellungen des Profils
    static func fromDefaults() -> BodyStats {
        let d = UserDefaults.standard
        func num(_ k: String, _ def: Double) -> Double { d.object(forKey: k) == nil ? def : d.double(forKey: k) }
        return BodyStats(heightCm: num("heightCm", 180), weightKg: num("weightKg", 80),
                         age: d.object(forKey: "age") == nil ? 34 : d.integer(forKey: "age"),
                         sex: Sex(rawValue: d.string(forKey: "sex") ?? "") ?? .male,
                         waistCm: num("waistCm", 85), neckCm: num("neckCm", 38), hipCm: num("hipCm", 0))
    }
}

/// Körperfett als Mittel aus drei bewährten Formeln. Jede für sich liegt im Schnitt etwa 3–4 Prozentpunkte neben
/// einer DEXA-Messung; zusammen gleichen sich ihre typischen Fehler teilweise aus. Bleibt eine Schätzung.
nonisolated enum BodyFat {
    struct Part: Identifiable { let name: String; let value: Double; var id: String { name } }
    struct Result {
        let value: Double
        let low: Double
        let high: Double
        let parts: [Part]
    }

    static func estimate(_ s: BodyStats) -> Result? {
        guard s.heightCm > 100, s.weightKg > 25 else { return nil }
        var parts: [(Part, Double)] = []
        let female = s.sex == .female
        // US-Navy-Formel (Umfänge)
        if female {
            if s.hipCm > 0, s.waistCm + s.hipCm > s.neckCm {
                let v = 495 / (1.29579 - 0.35004 * log10(s.waistCm + s.hipCm - s.neckCm) + 0.22100 * log10(s.heightCm)) - 450
                parts.append((Part(name: "Umfänge (US Navy)", value: v), 0.4))
            }
        } else if s.waistCm > s.neckCm {
            let v = 495 / (1.0324 - 0.19077 * log10(s.waistCm - s.neckCm) + 0.15456 * log10(s.heightCm)) - 450
            parts.append((Part(name: "Umfänge (US Navy)", value: v), 0.4))
        }
        // Relative Fettmasse (Größe zu Taille, Woolcott 2018)
        if s.waistCm > 40 {
            let v = 64 - 20 * s.heightCm / s.waistCm + (female ? 12 : 0)
            parts.append((Part(name: "Größe zu Taille (RFM)", value: v), 0.4))
        }
        // BMI, Alter und Geschlecht (Deurenberg 1991)
        let bmi = s.weightKg / pow(s.heightCm / 100, 2)
        parts.append((Part(name: "BMI und Alter", value: 1.2 * bmi + 0.23 * Double(s.age) - (female ? 0 : 10.8) - 5.4), 0.2))

        let clamped = parts.map { (Part(name: $0.0.name, value: max(3, min(60, $0.0.value))), $0.1) }
        let w = clamped.reduce(0) { $0 + $1.1 }
        let v = clamped.reduce(0) { $0 + $1.0.value * $1.1 } / w
        let values = clamped.map { $0.0.value }
        let spread = max(2.5, ((values.max() ?? v) - (values.min() ?? v)) / 2)
        return Result(value: v, low: max(3, v - spread), high: min(60, v + spread), parts: clamped.map { $0.0 })
    }
}

// MARK: - Körperregionen

nonisolated enum BodyRegion: String, CaseIterable, Identifiable, Codable {
    case neck, shoulders, chest, back, upperArm, forearm, waist, hips, thigh, calf
    var id: String { rawValue }

    var title: String {
        switch self {
        case .neck: return "Nacken"
        case .shoulders: return "Schultern"
        case .chest: return "Brust"
        case .back: return "Rückenbreite"
        case .upperArm: return "Oberarme"
        case .forearm: return "Unterarme"
        case .waist: return "Bauch und Taille"
        case .hips: return "Hüfte und Po"
        case .thigh: return "Oberschenkel"
        case .calf: return "Waden"
        }
    }

    var icon: String {
        switch self {
        case .neck: return "person.bust"
        case .shoulders, .back: return "figure.arms.open"
        case .chest: return "heart"
        case .upperArm, .forearm: return "dumbbell"
        case .waist: return "circle.dashed"
        case .hips: return "figure.stand"
        case .thigh, .calf: return "figure.walk"
        }
    }
}

/// Wie die Figur geformt wird (gespeichert in UserDefaults unter "bodyShape")
nonisolated struct BodyShapeSettings: Codable, Equatable {
    var useHeight = true
    var useProfile = true
    var useScan = false
    /// Faktoren je Region von Hand (1 = unverändert)
    var manual: [String: Double] = [:]

    static let key = "bodyShape"

    static func load() -> BodyShapeSettings {
        guard let d = UserDefaults.standard.data(forKey: key),
              let s = try? JSONDecoder().decode(BodyShapeSettings.self, from: d) else { return BodyShapeSettings() }
        return s
    }

    func save() {
        if let d = try? JSONEncoder().encode(self) { UserDefaults.standard.set(d, forKey: Self.key) }
    }

    func manual(_ r: BodyRegion) -> Double { manual[r.rawValue] ?? 1 }
}

/// Fertige Form: Größenfaktor und Faktor je Region
nonisolated struct BodyShape: Equatable {
    /// Größe der Figur aus FitScan in cm
    static let modelHeightCm = 180.0

    var heightScale: Float = 1
    var factors: [BodyRegion: Float] = [:]

    func f(_ r: BodyRegion) -> Float { factors[r] ?? 1 }
    var isNeutral: Bool { BodyRegion.allCases.allSatisfy { abs(f($0) - 1) < 0.005 } }
    var meshKey: String { BodyRegion.allCases.map { String(format: "%.3f", f($0)) }.joined(separator: ",") }

    /// Form aus Größe, Gewicht und Körperfett. Bezug ist die Figur selbst: 180 cm, rund 80 kg, 12 % Körperfett.
    static func fromProfile(_ s: BodyStats) -> [BodyRegion: Float] {
        guard let bf = BodyFat.estimate(s)?.value else { return [:] }
        let lean = s.weightKg * (1 - bf / 100)
        let ffmi = lean / pow(s.heightCm / 100, 2)
        let fat = bf - 12
        let mus = ffmi - 21.5
        let table: [BodyRegion: (Double, Double)] = [
            .waist: (0.020, 0.000), .hips: (0.011, 0.000), .chest: (0.005, 0.018), .back: (0.002, 0.020),
            .thigh: (0.007, 0.020), .upperArm: (0.006, 0.030), .forearm: (0.002, 0.015), .shoulders: (0.000, 0.025),
            .calf: (0.003, 0.012), .neck: (0.004, 0.015)
        ]
        var out: [BodyRegion: Float] = [:]
        for (r, (a, b)) in table { out[r] = Float(max(0.7, min(1.6, 1 + a * fat + b * mus))) }
        return out
    }

    /// Umfänge der Figur, gemessen wie in BodyMeasure.estimate, und wie stark ein Regionsfaktor sie ändert
    private static let modelGirth: [(BodyRegion, KeyPath<BodyMeasurements, Double?>, Double, Double)] = [
        (.chest, \.chestCm, 114.8, 0.89), (.waist, \.waistCm, 70.6, 0.97), (.hips, \.hipCm, 96.2, 0.93), (.thigh, \.thighCm, 59.5, 0.84)
    ]

    /// Form aus den Maßen eines Körperscans (gleiche Messweise wie bei der Figur)
    static func fromScan(_ m: BodyMeasurements, heightScale: Float) -> [BodyRegion: Float] {
        var out: [BodyRegion: Float] = [:]
        for (r, path, base, gain) in modelGirth {
            guard let v = m[keyPath: path], v > 0 else { continue }
            let ratio = v / (base * Double(heightScale))
            let f = Float(max(0.7, min(1.6, 1 + (ratio - 1) / gain)))
            out[r] = f
            if r == .chest { out[.back] = f }
        }
        return out
    }

    static func compose(_ set: BodyShapeSettings, stats: BodyStats, scan: BodyMeasurements?) -> BodyShape {
        var s = BodyShape()
        if set.useHeight { s.heightScale = Float(max(0.75, min(1.25, stats.heightCm / modelHeightCm))) }
        if set.useProfile { s.factors = fromProfile(stats) }
        if set.useScan, let scan {
            for (r, f) in fromScan(scan, heightScale: s.heightScale) { s.factors[r] = f }
        }
        for r in BodyRegion.allCases { s.factors[r] = s.f(r) * Float(set.manual(r)) }
        return s
    }

    /// Letzter Scan mit Umfängen
    @MainActor static var latestScan: BodyScanRecord? {
        BodyScanStore.shared.records.first { ($0.measurements?.waistCm ?? 0) > 0 }
    }

    @MainActor static var current: BodyShape {
        compose(.load(), stats: .fromDefaults(), scan: latestScan?.measurements)
    }
}

// MARK: - Netz verformen

enum BodyShaper {
    /// Vorbereitete Daten je Grundnetz: verschweißte Punkte, Nachbarn und Zuordnung je Teilnetz
    private final class Prepared {
        var points: [SIMD3<Float>] = []
        var nbStart: [Int32] = []
        var nbList: [Int32] = []
        /// je Teilnetz (Modell, Teil) die Punkt-Nummern
        var maps: [[Int32]] = []
    }

    private static var prepared: [ObjectIdentifier: Prepared] = [:]
    private static var cache: [String: MeshResource] = [:]
    private static var cacheOrder: [String] = []

    /// Verformte Kopie des Netzes (nil, wenn es nicht klappt)
    static func shaped(_ base: MeshResource, shape: BodyShape) -> MeshResource? {
        let key = "\(ObjectIdentifier(base).hashValue)|\(shape.meshKey)"
        if let m = cache[key] { return m }
        let prep = prepare(base)
        guard !prep.points.isEmpty else { return nil }
        let disp = relax(displacement(prep.points, shape), prep, iterations: 25)

        var contents = base.contents
        var models: [MeshResource.Model] = []
        var k = 0
        for model in contents.models {
            var parts: [MeshResource.Part] = []
            for part in model.parts {
                let map = prep.maps[k]
                k += 1
                var pos = part.positions.elements
                for i in 0..<min(pos.count, map.count) { pos[i] += disp[Int(map[i])] }
                var p = part
                p.positions = MeshBuffer(pos)
                parts.append(p)
            }
            models.append(MeshResource.Model(id: model.id, parts: parts))
        }
        contents.models = MeshModelCollection(models)
        guard let out = try? MeshResource.generate(from: contents) else { return nil }
        cache[key] = out
        cacheOrder.append(key)
        if cacheOrder.count > 6 { cache[cacheOrder.removeFirst()] = nil }
        return out
    }

    private static func prepare(_ base: MeshResource) -> Prepared {
        let id = ObjectIdentifier(base)
        if let p = prepared[id] { return p }
        let prep = Prepared()
        var index: [SIMD3<Int32>: Int32] = [:]
        var edges: [UInt64] = []
        // Teilnetze nach der Muskel-Zerlegung teilen sich dieselben Punkte; dann die Zuordnung nur einmal rechnen
        var lastSig: (Int, SIMD3<Float>, SIMD3<Float>)?
        var lastMap: [Int32] = []
        for model in base.contents.models {
            for part in model.parts {
                let pos = part.positions.elements
                var map: [Int32]
                if let s = lastSig, let first = pos.first, let last = pos.last, s.0 == pos.count, s.1 == first, s.2 == last {
                    map = lastMap
                } else {
                    map = [Int32](repeating: 0, count: pos.count)
                    for (i, p) in pos.enumerated() {
                        let q = SIMD3<Int32>(Int32((p.x * 20000).rounded()), Int32((p.y * 20000).rounded()), Int32((p.z * 20000).rounded()))
                        if let j = index[q] {
                            map[i] = j
                        } else {
                            let j = Int32(prep.points.count)
                            index[q] = j
                            prep.points.append(p)
                            map[i] = j
                        }
                    }
                    if let first = pos.first, let last = pos.last { lastSig = (pos.count, first, last) }
                    lastMap = map
                }
                prep.maps.append(map)
                if let tri = part.triangleIndices?.elements {
                    var t = 0
                    while t + 2 < tri.count {
                        let a = map[Int(tri[t])], b = map[Int(tri[t + 1])], c = map[Int(tri[t + 2])]
                        for (u, v) in [(a, b), (b, c), (c, a)] where u != v {
                            edges.append(UInt64(UInt32(min(u, v))) << 32 | UInt64(UInt32(max(u, v))))
                        }
                        t += 3
                    }
                }
            }
        }
        edges.sort()
        var unique: [UInt64] = []
        unique.reserveCapacity(edges.count)
        for e in edges where unique.last != e { unique.append(e) }
        let n = prep.points.count
        var deg = [Int32](repeating: 0, count: n + 1)
        for e in unique {
            deg[Int(e >> 32)] += 1
            deg[Int(e & 0xffff_ffff)] += 1
        }
        var start = [Int32](repeating: 0, count: n + 1)
        for i in 0..<n { start[i + 1] = start[i] + deg[i] }
        var fill = start
        var list = [Int32](repeating: 0, count: Int(start[n]))
        for e in unique {
            let a = Int(e >> 32), b = Int(e & 0xffff_ffff)
            list[Int(fill[a])] = Int32(b); fill[a] += 1
            list[Int(fill[b])] = Int32(a); fill[b] += 1
        }
        prep.nbStart = start
        prep.nbList = list
        prepared[id] = prep
        return prep
    }

    /// Verschiebungen glätten, damit an den Übergängen zwischen Regionen keine Kanten entstehen
    private static func relax(_ d0: [SIMD3<Float>], _ p: Prepared, iterations: Int) -> [SIMD3<Float>] {
        var d = d0
        var next = d0
        for _ in 0..<iterations {
            for i in 0..<d.count {
                let s = Int(p.nbStart[i]), e = Int(p.nbStart[i + 1])
                guard e > s else { next[i] = d[i]; continue }
                var sum = SIMD3<Float>(repeating: 0)
                for k in s..<e { sum += d[Int(p.nbList[k])] }
                next[i] = 0.5 * d[i] + 0.5 * sum / Float(e - s)
            }
            swap(&d, &next)
        }
        return d
    }

    // Gelenke der Grundhaltung (linke Seite, Meter, Figur schaut nach +z)
    private static let ua = SIMD3<Float>(0.20, 1.40, 0.00), fa = SIMD3<Float>(0.41, 1.21, 0.06), ha = SIMD3<Float>(0.53, 1.09, 0.27)
    private static let th = SIMD3<Float>(0.10, 0.90, 0.02), sh = SIMD3<Float>(0.16, 0.48, 0.00), ft = SIMD3<Float>(0.20, 0.08, -0.01)

    private static func smooth(_ e0: Float, _ e1: Float, _ x: Float) -> Float {
        let t = simd_clamp((x - e0) / (e1 - e0), 0, 1)
        return t * t * (3 - 2 * t)
    }

    /// Lage zur Strecke a→b: t entlang (ungekappt), nächster Punkt auf der Strecke, Abstand
    private static func seg(_ p: SIMD3<Float>, _ a: SIMD3<Float>, _ b: SIMD3<Float>) -> (t: Float, c: SIMD3<Float>, d: Float) {
        let ab = b - a
        let t = simd_dot(p - a, ab) / simd_dot(ab, ab)
        let c = a + simd_clamp(t, 0, 1) * ab
        return (t, c, simd_length(p - c))
    }

    /// Verschiebung je Punkt: radial von der Knochen- bzw. Rumpfachse weg, gewichtet nach Region
    static func displacement(_ points: [SIMD3<Float>], _ s: BodyShape) -> [SIMD3<Float>] {
        points.map { p in
            let sign: Float = p.x >= 0 ? 1 : -1
            let q = SIMD3<Float>(abs(p.x), p.y, p.z)   // alles auf der linken Seite rechnen
            let y = q.y
            let ua_ = seg(q, ua, fa), fa_ = seg(q, fa, ha), th_ = seg(q, th, sh), sh_ = seg(q, sh, ft)
            let axisZ: Float = -0.02 * simd_clamp((y - 0.95) / 0.5, 0, 1)
            let torso = SIMD3<Float>(0, y, axisZ)
            let dTorso = simd_length(SIMD2<Float>(q.x, q.z - axisZ))
            let arm = smooth(0, 0.03, (dTorso - 0.13) - min(ua_.d, fa_.d)) * smooth(0.12, 0.17, q.x)
            let leg = simd_clamp(smooth(0.86, 0.74, y) + smooth(0, 0.02, q.x - 0.05) * smooth(0.95, 0.80, y), 0, 1) * (1 - arm)
            let trunk = (1 - arm) * (1 - leg)
            let front = smooth(-0.05, 0.08, q.z - axisZ)
            var d = SIMD3<Float>(repeating: 0)
            func radial(_ c: SIMD3<Float>, _ w: Float, _ r: BodyRegion) { d += w * (s.f(r) - 1) * (q - c) }

            radial(ua_.c, arm * smooth(0.05, 0.25, ua_.t) * smooth(1.05, 0.85, ua_.t), .upperArm)
            radial(fa_.c, arm * smooth(0, 0.15, fa_.t) * smooth(1.0, 0.8, fa_.t), .forearm)
            radial(ua + SIMD3<Float>(-0.02, -0.03, 0), smooth(0.13, 0.05, simd_length(q - ua)) * (1 - 0.4 * leg), .shoulders)
            radial(th_.c, leg * smooth(-0.05, 0.15, th_.t) * smooth(1.0, 0.8, th_.t), .thigh)
            radial(sh_.c, leg * smooth(0, 0.15, sh_.t) * smooth(0.8, 0.55, sh_.t), .calf)
            radial(torso, trunk * smooth(1.18, 1.26, y) * smooth(1.48, 1.40, y) * (0.4 + 0.6 * front), .chest)
            radial(torso, trunk * smooth(1.10, 1.22, y) * smooth(1.46, 1.36, y) * (1 - front) * smooth(0.04, 0.10, q.x), .back)
            let waist = trunk * smooth(0.95, 1.03, y) * smooth(1.26, 1.16, y)
            radial(torso, waist * (0.55 + 0.45 * front), .waist)
            d.z += waist * front * (s.f(.waist) - 1) * 0.15   // Bauch wölbt sich vor allem nach vorn
            radial(torso, (trunk + leg * smooth(0.7, 0.85, y)) * smooth(0.74, 0.86, y) * smooth(1.06, 0.97, y), .hips)
            radial(SIMD3<Float>(0, y, -0.005), smooth(1.44, 1.49, y) * smooth(1.62, 1.56, y) * smooth(0.10, 0.06, q.x), .neck)
            d.x *= sign
            return d
        }
    }
}

// MARK: - Ansicht in den Einstellungen

struct BodyShapeView: View {
    @EnvironmentObject var profile: UserProfile
    @ObservedObject private var scans = BodyScanStore.shared
    @State private var settings = BodyShapeSettings.load()
    /// Stand, den die 3D-Vorschau zeigt (wird beim Loslassen eines Reglers übernommen)
    @State private var shown = BodyShapeSettings.load()
    @State private var back = false

    private var stats: BodyStats {
        BodyStats(heightCm: profile.heightCm, weightKg: profile.weightKg, age: profile.age, sex: profile.sex,
                  waistCm: profile.waistCm, neckCm: profile.neckCm, hipCm: profile.hipCm)
    }
    private var scan: BodyScanRecord? { scans.records.first { ($0.measurements?.waistCm ?? 0) > 0 } }
    private var shape: BodyShape { BodyShape.compose(shown, stats: stats, scan: scan?.measurements) }

    var body: some View {
        Form {
            Section {
                ShownOnly { MuscleRealityScene(primary: [], secondary: [], showBack: back, motion: .idle, shape: shape) }
                    .frame(height: 380)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .listRowInsets(EdgeInsets())
                Picker("Ansicht", selection: $back) {
                    Text("Vorne").tag(false)
                    Text("Hinten").tag(true)
                }
                .pickerStyle(.segmented)
            } footer: {
                Text("Mit dem Finger drehen. Die Figur stammt aus FitScan und bewegt sich in allen Übungen mit deiner Form.")
            }

            Section {
                Toggle(isOn: $settings.useHeight) {
                    Label("Größe übernehmen (\(Int(profile.heightCm)) cm)", systemImage: "ruler")
                }
                Toggle(isOn: $settings.useProfile) {
                    Label("Aus Gewicht und Körperfett formen", systemImage: "scalemass")
                }
                Toggle(isOn: $settings.useScan) {
                    VStack(alignment: .leading) {
                        Label("Maße aus dem letzten Scan", systemImage: "figure.stand")
                        if let scan {
                            Text("Scan vom \(scan.date.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption).foregroundStyle(.secondary)
                        } else {
                            Text("Noch kein Scan mit Umfängen").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                .disabled(scan == nil)
                NavigationLink { BodyScanView() } label: { Label("Neu scannen (Kamera oder Video)", systemImage: "camera.viewfinder") }
            } header: {
                Text("Grundlage")
            }

            BodyFatSection()

            Section {
                ForEach(BodyRegion.allCases) { r in
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Label(r.title, systemImage: r.icon)
                            Spacer()
                            Text(percent(settings.manual(r))).monospacedDigit().foregroundStyle(.secondary)
                        }
                        Slider(value: Binding(get: { settings.manual(r) }, set: { settings.manual[r.rawValue] = ($0 * 100).rounded() / 100 }),
                               in: 0.8...1.25, onEditingChanged: { editing in
                            if !editing { shown = settings }
                        })
                    }
                }
                Button("Regionen zurücksetzen") {
                    settings.manual = [:]
                    shown = settings
                }
                .disabled(settings.manual.isEmpty)
            } header: {
                Text("Körperregionen")
            } footer: {
                Text("Feinschliff von Hand, zusätzlich zu Größe, Gewicht und Scan. Zum Beispiel stärkere Waden oder schmalere Taille.")
            }
        }
        .navigationTitle("3D-Figur anpassen")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: settings) { _, s in
            s.save()
            // Schalter sofort zeigen, Regler erst beim Loslassen (siehe oben)
            if s.useHeight != shown.useHeight || s.useProfile != shown.useProfile || s.useScan != shown.useScan { shown = s }
        }
    }

    private func percent(_ v: Double) -> String {
        let p = Int(((v - 1) * 100).rounded())
        return p == 0 ? "±0 %" : (p > 0 ? "+\(p) %" : "\(p) %")
    }
}

/// Körperfett-Schätzung mit Spanne und den einzelnen Formeln
struct BodyFatSection: View {
    @EnvironmentObject var profile: UserProfile
    var showLink = true

    var body: some View {
        let r = profile.bodyFatResult
        Section {
            if let r {
                HStack(alignment: .firstTextBaseline) {
                    Text(String(format: "%.1f %%", r.value)).font(.system(size: 30, weight: .bold, design: .rounded))
                    Text(String(format: "etwa %.0f–%.0f %%", r.low, r.high)).foregroundStyle(.secondary)
                }
                ForEach(r.parts) { p in
                    LabeledContent(p.name, value: String(format: "%.1f %%", p.value))
                        .font(.subheadline)
                }
                LabeledContent("Fettfreie Masse", value: String(format: "%.1f kg", profile.weightKg * (1 - r.value / 100)))
                    .font(.subheadline)
            } else {
                Text("Bitte Größe und Gewicht eintragen.").foregroundStyle(.secondary)
            }
            if showLink {
                NavigationLink { ScanView() } label: { Label("Maße eintragen (Taille, Hals, Hüfte)", systemImage: "ruler") }
            }
        } header: {
            Text("Körperfett (Schätzung)")
        } footer: {
            Text("Mittel aus drei Formeln (Umfänge, Größe zu Taille, BMI und Alter). Morgens nüchtern gemessene Umfänge machen die Schätzung genauer. Keine medizinische Messung.")
        }
    }
}
