import RealityKit

/// Geräte-Modelle aus tools/geraete (Gym_<Name>.usdz im App-Bundle).
/// Jedes Modell wird einmal geladen; jede Verwendung bekommt eine Kopie.
enum GymModels {
    private static var cache: [String: Entity] = [:]

    /// Kopie des Modells `name` (z. B. "Bank", "PowerRack"); leeres Entity, wenn die Datei fehlt
    static func make(_ name: String) -> Entity {
        if let proto = cache[name] { return proto.clone(recursive: true) }
        do {
            let proto = try Entity.load(named: "Gym_" + name)
            cache[name] = proto
            return proto.clone(recursive: true)
        } catch {
            print("GymModels: Gym_\(name).usdz nicht geladen: \(error)")
            let empty = Entity()
            cache[name] = empty
            return empty.clone(recursive: true)
        }
    }
}
