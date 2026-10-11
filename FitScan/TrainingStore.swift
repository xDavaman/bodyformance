import Combine
import Foundation

struct SetLog: Identifiable, Codable, Hashable {
    var id = UUID()
    var exercise: String
    var date: Date
    var weightKg: Double      // bei Körpergewichtsübungen: Zusatzgewicht (0 = ohne)
    var reps: Int             // bei Haltezeiten: Sekunden

    /// Vergleichswert für den Fortschritt: geschätztes 1-Wiederholungs-Maximum (Epley).
    /// Ohne Zusatzgewicht zählen einfach die Wiederholungen bzw. Sekunden.
    var e1RM: Double {
        if reps <= 0 { return 0 }
        return weightKg > 0 ? weightKg * (1 + Double(reps) / 30) : Double(reps)
    }
}

struct BodyEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var weightKg: Double
}

enum CardioKind: String, Codable, CaseIterable, Identifiable {
    case easy = "Lockerer Lauf", tempo = "Tempolauf", interval = "Intervalle", long = "Langer Lauf", other = "Anderes Cardio"
    var id: String { rawValue }
}

struct CardioLog: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var kind: CardioKind
    var km: Double
    var minutes: Double
    /// Minuten pro Kilometer
    var pace: Double { km > 0 ? minutes / km : 0 }
}

struct MobilityLog: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var exercise: String
    var region: String
}

/// Speichert alle Daten dauerhaft als JSON im App-Ordner.
final class TrainingStore: ObservableObject {
    @Published private(set) var sets: [SetLog] = []
    @Published private(set) var bodyEntries: [BodyEntry] = []
    @Published private(set) var cardio: [CardioLog] = []
    @Published private(set) var mobility: [MobilityLog] = []

    private let fileURL: URL

    private struct Payload: Codable {
        var sets: [SetLog]
        var bodyEntries: [BodyEntry]
        var cardio: [CardioLog]
        var mobility: [MobilityLog]

        init(sets: [SetLog], bodyEntries: [BodyEntry], cardio: [CardioLog], mobility: [MobilityLog]) {
            self.sets = sets; self.bodyEntries = bodyEntries; self.cardio = cardio; self.mobility = mobility
        }

        // Ältere Dateien kennen cardio und mobility noch nicht.
        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            sets = try c.decodeIfPresent([SetLog].self, forKey: .sets) ?? []
            bodyEntries = try c.decodeIfPresent([BodyEntry].self, forKey: .bodyEntries) ?? []
            cardio = try c.decodeIfPresent([CardioLog].self, forKey: .cardio) ?? []
            mobility = try c.decodeIfPresent([MobilityLog].self, forKey: .mobility) ?? []
        }
    }

    init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = dir.appendingPathComponent("fitscan-data.json")
        load()
    }

    func addSet(exercise: String, weightKg: Double, reps: Int) {
        sets.append(SetLog(exercise: exercise, date: Date(), weightKg: weightKg, reps: reps))
        save()
    }

    func remove(_ log: SetLog) {
        sets.removeAll { $0.id == log.id }
        save()
    }

    func addBody(weightKg: Double) {
        bodyEntries.append(BodyEntry(date: Date(), weightKg: weightKg))
        save()
    }

    func addCardio(kind: CardioKind, km: Double, minutes: Double) {
        cardio.append(CardioLog(date: Date(), kind: kind, km: km, minutes: minutes))
        save()
    }

    func remove(_ log: CardioLog) {
        cardio.removeAll { $0.id == log.id }
        save()
    }

    func addMobility(_ exercise: Exercise) {
        mobility.append(MobilityLog(date: Date(), exercise: exercise.name, region: exercise.region?.rawValue ?? ""))
        save()
    }

    func sessions(for exercise: String) -> [[SetLog]] {
        Progression.sessions(from: sets.filter { $0.exercise == exercise })
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let payload = try? JSONDecoder().decode(Payload.self, from: data) else { return }
        sets = payload.sets
        bodyEntries = payload.bodyEntries
        cardio = payload.cardio
        mobility = payload.mobility
    }

    private func save() {
        let payload = Payload(sets: sets, bodyEntries: bodyEntries, cardio: cardio, mobility: mobility)
        if let data = try? JSONEncoder().encode(payload) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
