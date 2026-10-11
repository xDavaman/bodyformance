import Combine
import SwiftUI
import Charts

/// Tab für Läufer, Hybrid-Athleten, Calisthenics und andere Bewegungssportarten.
struct SportView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var store: TrainingStore
    @EnvironmentObject var health: HealthManager

    @State private var kind: CardioKind = .easy
    @State private var km: Double = 5
    @State private var minutes: Double = 30

    var body: some View {
        List {
            Section {
                Picker("Sport", selection: Binding(get: { profile.sport }, set: { profile.sport = $0 })) {
                    ForEach(Sport.allCases) { Text($0.rawValue).tag($0) }
                }
                Text(intro).font(.footnote).foregroundStyle(.secondary)
            }

            if profile.sport != .none {
                weekSection
            }
            if profile.sport == .running || profile.sport == .hybrid || profile.sport == .other {
                runningSection
            }
            if profile.sport == .calisthenics || profile.sport == .hybrid {
                skillSection
            }
            Section {
                NavigationLink { MobilityView() } label: {
                    Label("Passende Mobility ansehen", systemImage: "figure.flexibility")
                }
            } footer: {
                Text(mobilityHint)
            }
        }
        .navigationTitle("Sport")
        .onAppear { km = max(1, (profile.weeklyRunKm / 4).rounded()) }
    }

    // MARK: Text

    private var intro: String {
        switch profile.sport {
        case .none: return "Wähle deinen Sport. Dann bekommst du eine Wochenstruktur, Ziele und Mobility-Empfehlungen dazu."
        case .running: return "Laufen steht im Vordergrund. Zwei kurze Krafteinheiten pro Woche schützen vor Verletzungen und verbessern die Laufökonomie."
        case .hybrid: return "Kraft und Laufen zusammen. Die Kunst ist, harte Lauf- und Beintage nicht aufeinander zu legen."
        case .calisthenics: return "Training mit dem eigenen Körpergewicht. Fortschritt kommt über schwerere Varianten, mehr Wiederholungen und Haltezeiten."
        case .other: return "Für Kampfsport, Klettern, Ballsport und ähnliches: Kraft, etwas Ausdauer und viel Beweglichkeit."
        }
    }

    private var mobilityHint: String {
        switch profile.sport {
        case .running, .hybrid: return "Für dich besonders wichtig: Hüfte, Sprunggelenk und Beinrückseite."
        case .calisthenics: return "Für dich besonders wichtig: Schulter, Handgelenk und Brustwirbelsäule."
        default: return "Hüfte, Schulter und Rücken sind für fast jede Sportart eine gute Basis."
        }
    }

    // MARK: Woche

    private var weekSection: some View {
        let rows = SportPlanner.week(profile: profile)
        return Section {
            ForEach(rows) { row in
                HStack(alignment: .top) {
                    Text(row.day).bold().frame(width: 32, alignment: .leading)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(row.title)
                        Text(row.detail).font(.footnote).foregroundStyle(.secondary)
                    }
                }
            }
        } header: {
            Text("Beispielwoche (\(profile.trainingDays) Krafteinheiten)")
        } footer: {
            Text("Das ist eine Orientierung. Höre auf deinen Körper und lege bei Müdigkeit oder Schmerzen einen Ruhetag ein.")
        }
    }

    // MARK: Laufen

    @ViewBuilder
    private var runningSection: some View {
        let hr = SportPlanner.heartRateZones(age: profile.age)
        Section("Wochenziel Laufen") {
            Stepper(value: Binding(get: { profile.weeklyRunKm }, set: { profile.weeklyRunKm = $0 }), in: 0...150, step: 5) {
                Text("Ziel: \(Int(profile.weeklyRunKm)) km pro Woche")
            }
            let last7 = store.cardio.filter { $0.date > Date().addingTimeInterval(-7 * 86_400) }.map(\.km).reduce(0, +)
            let healthKm = health.runningKm7Days
            let current = max(last7, healthKm)
            ProgressView(value: min(1, current / max(1, profile.weeklyRunKm))) {
                Text("Letzte 7 Tage: \(String(format: "%.1f", current)) km")
            }
            if healthKm > 0 {
                Text("Apple Health meldet \(String(format: "%.1f", healthKm)) km Laufen/Gehen-Workouts in 7 Tagen.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Text(SportPlanner.runAdvice(weeklyKm: current, goalKm: profile.weeklyRunKm,
                                       last28Km: health.runningKm28Days))
                .font(.footnote).foregroundStyle(.secondary)
        }

        Section {
            ForEach(hr) { z in
                HStack {
                    Text(z.name)
                    Spacer()
                    Text("\(z.low)–\(z.high) bpm").foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("Herzfrequenz-Zonen (grob)")
        } footer: {
            Text("Geschätzt aus dem Alter (220 minus Alter). Eine echte Maximalpuls-Messung ist genauer. Die meisten Läufe sollten locker in Zone 2 sein.")
        }

        Section("Lauf eintragen") {
            Picker("Art", selection: $kind) {
                ForEach(CardioKind.allCases) { Text($0.rawValue).tag($0) }
            }
            Stepper(value: $km, in: 0.5...100, step: 0.5) { Text("Distanz: \(String(format: "%.1f", km)) km") }
            Stepper(value: $minutes, in: 5...600, step: 5) { Text("Dauer: \(Int(minutes)) min") }
            if km > 0 {
                LabeledContent("Tempo", value: paceText(minutes / km))
            }
            Button("Lauf speichern") { store.addCardio(kind: kind, km: km, minutes: minutes) }
        }

        let recent = Array(store.cardio.sorted { $0.date > $1.date }.prefix(8))
        if !recent.isEmpty {
            Section("Letzte Läufe") {
                ForEach(recent) { c in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(c.kind.rawValue)
                            Text(c.date, format: .dateTime.day().month()).font(.footnote).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(String(format: "%.1f", c.km)) km · \(paceText(c.pace))").foregroundStyle(.secondary)
                    }
                }
                .onDelete { offsets in for i in offsets { store.remove(recent[i]) } }
            }
        }
    }

    private func paceText(_ minPerKm: Double) -> String {
        guard minPerKm.isFinite, minPerKm > 0 else { return "–" }
        let m = Int(minPerKm)
        let s = Int(((minPerKm - Double(m)) * 60).rounded())
        return String(format: "%d:%02d min/km", m, s == 60 ? 0 : s)
    }

    // MARK: Calisthenics

    private var skillSection: some View {
        Section {
            ForEach(SportPlanner.ladders) { ladder in
                VStack(alignment: .leading, spacing: 4) {
                    Text(ladder.title).bold()
                    Text(ladder.steps.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n"))
                        .font(.footnote).foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
        } header: {
            Text("Fortschrittsleitern")
        } footer: {
            Text("Gehe zur nächsten Stufe, wenn du die aktuelle in 3 Sätzen sauber mit 10 Wiederholungen (bzw. 30 s) schaffst.")
        }
    }
}

// MARK: - Planung

struct WeekRow: Identifiable {
    var id: String { day }
    let day: String
    let title: String
    let detail: String
}

enum SportPlanner {
    struct Ladder: Identifiable { var id: String { title }; let title: String; let steps: [String] }

    static let ladders: [Ladder] = [
        Ladder(title: "Liegestütze", steps: ["Hände erhöht (Bank)", "Normale Liegestütze", "Füße erhöht", "Archer-Liegestütze", "Einarmig mit Hilfe"]),
        Ladder(title: "Klimmzüge", steps: ["Australian Pull-ups", "Negative Klimmzüge (langsam ablassen)", "Klimmzüge mit Band", "Klimmzüge", "Klimmzüge mit Zusatzgewicht"]),
        Ladder(title: "Beine", steps: ["Kniebeuge", "Ausfallschritte", "Bulgarische Kniebeuge", "Pistol Squat mit Hilfe", "Pistol Squat"]),
        Ladder(title: "Rumpf", steps: ["Dead Bug", "Plank", "Hollow Hold", "Hängendes Beinheben", "L-Sit"])
    ]

    struct HRZone: Identifiable {
        var id: String { name }
        let name: String
        let low: Int
        let high: Int
    }

    static func heartRateZones(age: Int) -> [HRZone] {
        let maxHR = Double(220 - age)
        func z(_ n: String, _ a: Double, _ b: Double) -> HRZone {
            HRZone(name: n, low: Int((maxHR * a).rounded()), high: Int((maxHR * b).rounded()))
        }
        return [z("Zone 1 – sehr locker", 0.50, 0.60), z("Zone 2 – Grundlage", 0.60, 0.70),
                z("Zone 3 – zügig", 0.70, 0.80), z("Zone 4 – Schwelle", 0.80, 0.90), z("Zone 5 – maximal", 0.90, 1.0)]
    }

    static func runAdvice(weeklyKm: Double, goalKm: Double, last28Km: Double) -> String {
        let avgWeek = last28Km / 4
        if avgWeek > 0, weeklyKm > avgWeek * 1.3 {
            return "Diese Woche liegt über 30 % über deinem Schnitt der letzten 4 Wochen (\(String(format: "%.0f", avgWeek)) km). Das erhöht das Verletzungsrisiko. Steigere dich um höchstens 10 % pro Woche."
        }
        if weeklyKm >= goalKm { return "Wochenziel erreicht. Plane nach 3 Steigerungswochen eine leichtere Woche ein." }
        return "Etwa 80 % der Kilometer locker (Zone 2), 20 % Tempo oder Intervalle. Steigere den Umfang um höchstens 10 % pro Woche."
    }

    static func week(profile: UserProfile) -> [WeekRow] {
        let strength = max(2, min(5, profile.trainingDays))
        let days = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
        var rows: [WeekRow] = days.map { WeekRow(day: $0, title: "Ruhe oder Mobility", detail: "15 Minuten Mobility") }

        func set(_ i: Int, _ t: String, _ d: String) { rows[i] = WeekRow(day: days[i], title: t, detail: d) }

        switch profile.sport {
        case .running:
            set(0, "Lockerer Lauf", "30–45 min in Zone 2")
            set(1, "Kraft: Beine und Rumpf", "Kniebeuge, Ausfallschritte, Wadenheben, Plank")
            set(2, "Intervalle oder Tempolauf", "z. B. 5 × 3 min zügig, 2 min Trab")
            set(3, "Mobility", "Hüfte, Sprunggelenk, Beinrückseite")
            set(4, "Kraft: Ganzkörper", "Klimmzüge, Rudern, Rumänisches Kreuzheben")
            set(5, "Langer Lauf", "60–90 min locker")
            set(6, "Ruhe", "Spaziergang, leichte Mobility")
        case .hybrid:
            set(0, "Kraft: Beine", "schwer, Kniebeuge, Rumänisches Kreuzheben")
            set(1, "Intervalle", "kurze Läufe in Zone 4, danach locker auslaufen")
            set(2, "Kraft: Oberkörper", "Push und Pull")
            set(3, "Lockerer Lauf", "Zone 2, 40 min")
            set(4, strength >= 4 ? "Kraft: Ganzkörper" : "Mobility", strength >= 4 ? "mittleres Gewicht, Technik" : "Hüfte, Schulter, Rücken")
            set(5, "Langer Lauf", "60–90 min locker")
            set(6, "Ruhe", "Spaziergang, leichte Mobility")
        case .calisthenics:
            set(0, "Push und Beine", "Liegestütze-Variante, Dips, Kniebeuge-Variante")
            set(1, "Mobility und Skills", "Handgelenk, Schulter, Handstand- oder L-Sit-Übung")
            set(2, "Pull und Rumpf", "Klimmzüge, Australian Pull-ups, Hollow Hold")
            set(3, "Ruhe", "Spaziergang")
            set(4, "Ganzkörper", "je eine Übung Push, Pull, Beine, Rumpf")
            set(5, strength >= 4 ? "Skills und Ausdauer" : "Lockeres Cardio", "30 min Seilspringen oder Laufen")
            set(6, "Ruhe", "leichte Mobility")
        case .other:
            set(0, "Kraft: Ganzkörper", "Grundübungen, 2–3 Sätze")
            set(1, "Sport-Training", "dein Sport")
            set(2, "Mobility", "Hüfte, Schulter, Rücken")
            set(3, "Kraft: Ganzkörper", "Zug und Beine betonen")
            set(4, "Sport-Training", "dein Sport")
            set(5, "Lockeres Cardio", "30–45 min Zone 2")
            set(6, "Ruhe", "")
        case .none:
            break
        }
        return rows
    }
}
