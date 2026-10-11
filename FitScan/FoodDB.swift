import Combine
import SwiftUI

// Lebensmittel außerhalb der Rezepte: Grundnahrungsmittel-Datenbank, gespeicherte Produkte (Barcode / Foto / selbst angelegt).
// Alle Werte je 100 g (Richtwerte). Produkte aus dem Barcode-Scan kommen von Open Food Facts.

struct FoodItem: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var brand: String = ""
    var kcal: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var sugar: Double = 0
    var salt: Double = 0
    /// Übliche Verzehrmenge in Gramm (z. B. 250 g Packung Magerquark)
    var defaultGrams: Double = 100
    var pieceGrams: Double? = nil
    var pieceName: String? = nil
    var barcode: String? = nil

    func macros(grams: Double) -> Macros {
        let m = grams / 100
        return Macros(kcal: kcal * m, protein: protein * m, fat: fat * m, carbs: carbs * m, salt: salt * m, price: 0)
    }
}

enum FoodDB {
    static let basics: [FoodItem] = [
        FoodItem(id: "basic-0", name: "Magerquark", kcal: 67, protein: 12, fat: 0.3, carbs: 4, sugar: 4, salt: 0.1, defaultGrams: 250),
        FoodItem(id: "basic-1", name: "Speisequark 20 % Fett", kcal: 115, protein: 10, fat: 5, carbs: 3.5, sugar: 3.5, salt: 0.1, defaultGrams: 250),
        FoodItem(id: "basic-2", name: "Skyr natur", kcal: 63, protein: 11, fat: 0.2, carbs: 4, sugar: 4, salt: 0.1, defaultGrams: 150),
        FoodItem(id: "basic-3", name: "Hüttenkäse", kcal: 95, protein: 12, fat: 4, carbs: 2.5, sugar: 2.5, salt: 0.7, defaultGrams: 200),
        FoodItem(id: "basic-4", name: "Joghurt 1,5 % Fett", kcal: 47, protein: 4.5, fat: 1.5, carbs: 6.5, sugar: 6.5, salt: 0.1, defaultGrams: 150),
        FoodItem(id: "basic-5", name: "Naturjoghurt 3,5 % Fett", kcal: 66, protein: 3.5, fat: 3.8, carbs: 4.7, sugar: 4.7, salt: 0.1, defaultGrams: 150),
        FoodItem(id: "basic-6", name: "Griechischer Joghurt 10 %", kcal: 130, protein: 5.5, fat: 10, carbs: 4, sugar: 4, salt: 0.1, defaultGrams: 150),
        FoodItem(id: "basic-7", name: "Milch 1,5 %", kcal: 47, protein: 3.4, fat: 1.5, carbs: 4.8, sugar: 4.8, salt: 0.1, defaultGrams: 200),
        FoodItem(id: "basic-8", name: "Milch 3,5 %", kcal: 65, protein: 3.4, fat: 3.8, carbs: 4.8, sugar: 4.8, salt: 0.1, defaultGrams: 200),
        FoodItem(id: "basic-9", name: "Haferdrink", kcal: 45, protein: 0.5, fat: 1.5, carbs: 7, sugar: 4, salt: 0.1, defaultGrams: 200),
        FoodItem(id: "basic-10", name: "Frischkäse natur", kcal: 250, protein: 6, fat: 24, carbs: 3, sugar: 3, salt: 0.8, defaultGrams: 30),
        FoodItem(id: "basic-11", name: "Frischkäse light", kcal: 110, protein: 10, fat: 5, carbs: 4, sugar: 4, salt: 0.9, defaultGrams: 30),
        FoodItem(id: "basic-12", name: "Gouda / Schnittkäse", kcal: 356, protein: 25, fat: 28, carbs: 0, sugar: 0, salt: 1.8, defaultGrams: 30, pieceGrams: 20, pieceName: "Scheibe"),
        FoodItem(id: "basic-13", name: "Mozzarella", kcal: 245, protein: 18, fat: 19, carbs: 1, sugar: 1, salt: 0.6, defaultGrams: 125),
        FoodItem(id: "basic-14", name: "Parmesan", kcal: 400, protein: 36, fat: 28, carbs: 0, sugar: 0, salt: 1.8, defaultGrams: 10),
        FoodItem(id: "basic-15", name: "Feta", kcal: 260, protein: 15, fat: 21, carbs: 1.5, sugar: 1.5, salt: 2.7, defaultGrams: 50),
        FoodItem(id: "basic-16", name: "Ei (Größe M)", kcal: 143, protein: 12.5, fat: 10, carbs: 0.7, sugar: 0.7, salt: 0.35, defaultGrams: 55, pieceGrams: 55, pieceName: "Ei"),
        FoodItem(id: "basic-17", name: "Thunfisch im eigenen Saft (abgetropft)", kcal: 110, protein: 25, fat: 1, carbs: 0, sugar: 0, salt: 1.0, defaultGrams: 110, pieceGrams: 110, pieceName: "Dose"),
        FoodItem(id: "basic-18", name: "Thunfisch in Öl (abgetropft)", kcal: 190, protein: 25, fat: 10, carbs: 0, sugar: 0, salt: 1.0, defaultGrams: 110, pieceGrams: 110, pieceName: "Dose"),
        FoodItem(id: "basic-19", name: "Lachsfilet", kcal: 200, protein: 20, fat: 13, carbs: 0, sugar: 0, salt: 0.15, defaultGrams: 150),
        FoodItem(id: "basic-20", name: "Räucherlachs", kcal: 180, protein: 20, fat: 11, carbs: 0, sugar: 0, salt: 3.0, defaultGrams: 60),
        FoodItem(id: "basic-21", name: "Seelachs", kcal: 80, protein: 18, fat: 0.7, carbs: 0, sugar: 0, salt: 0.3, defaultGrams: 150),
        FoodItem(id: "basic-22", name: "Garnelen", kcal: 85, protein: 18, fat: 1, carbs: 0, sugar: 0, salt: 1.2, defaultGrams: 150),
        FoodItem(id: "basic-23", name: "Hähnchenbrust (roh)", kcal: 110, protein: 23, fat: 1.5, carbs: 0, sugar: 0, salt: 0.15, defaultGrams: 150),
        FoodItem(id: "basic-24", name: "Putenbrust-Aufschnitt", kcal: 105, protein: 21, fat: 1.5, carbs: 1, sugar: 1, salt: 2.0, defaultGrams: 50, pieceGrams: 12, pieceName: "Scheibe"),
        FoodItem(id: "basic-25", name: "Kochschinken", kcal: 110, protein: 19, fat: 3, carbs: 1, sugar: 0.5, salt: 2.0, defaultGrams: 50, pieceGrams: 15, pieceName: "Scheibe"),
        FoodItem(id: "basic-26", name: "Rinderhack mager", kcal: 125, protein: 21, fat: 5, carbs: 0, sugar: 0, salt: 0.15, defaultGrams: 150),
        FoodItem(id: "basic-27", name: "Salami", kcal: 450, protein: 22, fat: 40, carbs: 1, sugar: 0.5, salt: 4.5, defaultGrams: 30, pieceGrams: 5, pieceName: "Scheibe"),
        FoodItem(id: "basic-28", name: "Tofu natur", kcal: 120, protein: 13, fat: 7, carbs: 1.5, sugar: 0.5, salt: 0.05, defaultGrams: 150),
        FoodItem(id: "basic-29", name: "Vollkornbrot", kcal: 215, protein: 8, fat: 1.5, carbs: 40, sugar: 3, salt: 1.2, defaultGrams: 50, pieceGrams: 50, pieceName: "Scheibe"),
        FoodItem(id: "basic-30", name: "Toastbrot", kcal: 265, protein: 8, fat: 4, carbs: 48, sugar: 4, salt: 1.2, defaultGrams: 25, pieceGrams: 25, pieceName: "Scheibe"),
        FoodItem(id: "basic-31", name: "Brötchen", kcal: 275, protein: 9, fat: 1, carbs: 56, sugar: 2, salt: 1.5, defaultGrams: 60, pieceGrams: 60, pieceName: "Brötchen"),
        FoodItem(id: "basic-32", name: "Haferflocken", kcal: 370, protein: 13, fat: 7, carbs: 60, sugar: 1, salt: 0.02, defaultGrams: 50),
        FoodItem(id: "basic-33", name: "Müsli (ohne Zucker)", kcal: 360, protein: 11, fat: 6, carbs: 60, sugar: 5, salt: 0.05, defaultGrams: 50),
        FoodItem(id: "basic-34", name: "Reis (gekocht)", kcal: 130, protein: 2.7, fat: 0.3, carbs: 28, sugar: 0.1, salt: 0.01, defaultGrams: 180),
        FoodItem(id: "basic-35", name: "Nudeln (gekocht)", kcal: 158, protein: 5.8, fat: 0.9, carbs: 31, sugar: 1.5, salt: 0.01, defaultGrams: 200),
        FoodItem(id: "basic-36", name: "Kartoffeln (gekocht)", kcal: 77, protein: 2, fat: 0.1, carbs: 17, sugar: 1, salt: 0.01, defaultGrams: 200),
        FoodItem(id: "basic-37", name: "Banane", kcal: 90, protein: 1, fat: 0.3, carbs: 20, sugar: 17, salt: 0.01, defaultGrams: 120, pieceGrams: 120, pieceName: "Banane"),
        FoodItem(id: "basic-38", name: "Apfel", kcal: 52, protein: 0.3, fat: 0.2, carbs: 12, sugar: 11, salt: 0.01, defaultGrams: 150, pieceGrams: 150, pieceName: "Apfel"),
        FoodItem(id: "basic-39", name: "Orange", kcal: 47, protein: 0.9, fat: 0.2, carbs: 9, sugar: 8, salt: 0.01, defaultGrams: 150, pieceGrams: 150, pieceName: "Orange"),
        FoodItem(id: "basic-40", name: "Weintrauben", kcal: 70, protein: 0.7, fat: 0.2, carbs: 16, sugar: 16, salt: 0.01, defaultGrams: 100),
        FoodItem(id: "basic-41", name: "Erdbeeren", kcal: 32, protein: 0.7, fat: 0.3, carbs: 6, sugar: 5, salt: 0.01, defaultGrams: 150),
        FoodItem(id: "basic-42", name: "Blaubeeren", kcal: 42, protein: 0.7, fat: 0.3, carbs: 9, sugar: 7, salt: 0.01, defaultGrams: 100),
        FoodItem(id: "basic-43", name: "Avocado", kcal: 160, protein: 2, fat: 15, carbs: 2, sugar: 0.5, salt: 0.01, defaultGrams: 100, pieceGrams: 150, pieceName: "Avocado"),
        FoodItem(id: "basic-44", name: "Gurke", kcal: 12, protein: 0.6, fat: 0.1, carbs: 1.5, sugar: 1.5, salt: 0.01, defaultGrams: 150),
        FoodItem(id: "basic-45", name: "Tomate", kcal: 18, protein: 0.9, fat: 0.2, carbs: 3, sugar: 3, salt: 0.01, defaultGrams: 120, pieceGrams: 100, pieceName: "Tomate"),
        FoodItem(id: "basic-46", name: "Paprika", kcal: 30, protein: 1, fat: 0.3, carbs: 5, sugar: 4, salt: 0.01, defaultGrams: 120),
        FoodItem(id: "basic-47", name: "Brokkoli", kcal: 34, protein: 3, fat: 0.4, carbs: 4, sugar: 1.5, salt: 0.03, defaultGrams: 150),
        FoodItem(id: "basic-48", name: "Karotte", kcal: 35, protein: 0.9, fat: 0.2, carbs: 7, sugar: 5, salt: 0.1, defaultGrams: 80, pieceGrams: 80, pieceName: "Karotte"),
        FoodItem(id: "basic-49", name: "Mandeln", kcal: 580, protein: 21, fat: 50, carbs: 10, sugar: 4, salt: 0.01, defaultGrams: 25),
        FoodItem(id: "basic-50", name: "Walnüsse", kcal: 650, protein: 15, fat: 65, carbs: 7, sugar: 3, salt: 0.01, defaultGrams: 25),
        FoodItem(id: "basic-51", name: "Erdnüsse (geröstet)", kcal: 590, protein: 26, fat: 49, carbs: 10, sugar: 4, salt: 0.5, defaultGrams: 30),
        FoodItem(id: "basic-52", name: "Erdnussbutter", kcal: 600, protein: 25, fat: 50, carbs: 10, sugar: 6, salt: 0.5, defaultGrams: 15),
        FoodItem(id: "basic-53", name: "Cashewkerne", kcal: 580, protein: 18, fat: 44, carbs: 30, sugar: 6, salt: 0.02, defaultGrams: 25),
        FoodItem(id: "basic-54", name: "Proteinpulver (Whey)", kcal: 380, protein: 78, fat: 5, carbs: 8, sugar: 5, salt: 0.5, defaultGrams: 30),
        FoodItem(id: "basic-55", name: "Proteinriegel (Richtwert)", kcal: 350, protein: 33, fat: 12, carbs: 30, sugar: 4, salt: 0.5, defaultGrams: 45, pieceGrams: 45, pieceName: "Riegel"),
        FoodItem(id: "basic-56", name: "Whey Isolat (Richtwert)", kcal: 365, protein: 88, fat: 1, carbs: 2, sugar: 1, salt: 0.6, defaultGrams: 30),
        FoodItem(id: "basic-57", name: "Casein (Richtwert)", kcal: 370, protein: 78, fat: 2, carbs: 6, sugar: 3, salt: 0.7, defaultGrams: 30),
        FoodItem(id: "basic-58", name: "Protein-Shake Fertigdrink (Richtwert)", kcal: 60, protein: 10, fat: 1, carbs: 3, sugar: 3, salt: 0.2, defaultGrams: 330, pieceGrams: 330, pieceName: "Flasche"),
        FoodItem(id: "basic-59", name: "Protein-Cookie (Richtwert)", kcal: 390, protein: 30, fat: 15, carbs: 35, sugar: 5, salt: 0.6, defaultGrams: 60, pieceGrams: 60, pieceName: "Cookie"),
        FoodItem(id: "basic-60", name: "Protein-Chips (Richtwert)", kcal: 390, protein: 50, fat: 10, carbs: 25, sugar: 3, salt: 2.0, defaultGrams: 40),
        FoodItem(id: "basic-61", name: "Protein-Brot (Richtwert)", kcal: 230, protein: 24, fat: 7, carbs: 9, sugar: 2, salt: 1.3, defaultGrams: 50, pieceGrams: 50, pieceName: "Scheibe"),
        FoodItem(id: "basic-62", name: "Protein-Pudding (Richtwert)", kcal: 75, protein: 10, fat: 1.5, carbs: 5, sugar: 4, salt: 0.2, defaultGrams: 200, pieceGrams: 200, pieceName: "Becher"),
        FoodItem(id: "basic-63", name: "Zartbitterschokolade 70 %", kcal: 580, protein: 9, fat: 42, carbs: 31, sugar: 24, salt: 0.02, defaultGrams: 20),
        FoodItem(id: "basic-64", name: "Vollmilchschokolade", kcal: 540, protein: 7, fat: 31, carbs: 57, sugar: 56, salt: 0.2, defaultGrams: 20),
        FoodItem(id: "basic-65", name: "Honig", kcal: 330, protein: 0.3, fat: 0, carbs: 80, sugar: 80, salt: 0.0, defaultGrams: 15),
        FoodItem(id: "basic-66", name: "Marmelade", kcal: 250, protein: 0.4, fat: 0.1, carbs: 60, sugar: 58, salt: 0.0, defaultGrams: 20),
        FoodItem(id: "basic-67", name: "Nuss-Nougat-Creme", kcal: 539, protein: 6.3, fat: 31, carbs: 57.5, sugar: 56, salt: 0.1, defaultGrams: 20),
        FoodItem(id: "basic-68", name: "Butter", kcal: 740, protein: 0.7, fat: 82, carbs: 0.6, sugar: 0.6, salt: 0.02, defaultGrams: 10),
        FoodItem(id: "basic-69", name: "Olivenöl", kcal: 880, protein: 0, fat: 99.5, carbs: 0, sugar: 0, salt: 0.0, defaultGrams: 10),
        FoodItem(id: "basic-70", name: "Hummus", kcal: 250, protein: 7, fat: 18, carbs: 13, sugar: 1, salt: 1.2, defaultGrams: 50),
        FoodItem(id: "basic-71", name: "Linsen (Dose, abgetropft)", kcal: 115, protein: 9, fat: 0.6, carbs: 16, sugar: 1, salt: 0.3, defaultGrams: 150),
        FoodItem(id: "basic-72", name: "Kidneybohnen (Dose, abgetropft)", kcal: 110, protein: 7, fat: 0.5, carbs: 17, sugar: 1, salt: 0.4, defaultGrams: 120),
        FoodItem(id: "basic-73", name: "Kichererbsen (Dose, abgetropft)", kcal: 120, protein: 7, fat: 2.5, carbs: 17, sugar: 1, salt: 0.3, defaultGrams: 120),
        FoodItem(id: "basic-74", name: "Mais (Dose)", kcal: 80, protein: 2.5, fat: 1, carbs: 14, sugar: 6, salt: 0.3, defaultGrams: 60),
        FoodItem(id: "basic-75", name: "Pizza Margherita (TK, Richtwert)", kcal: 250, protein: 10, fat: 9, carbs: 31, sugar: 3, salt: 1.3, defaultGrams: 350, pieceGrams: 350, pieceName: "Pizza"),
        FoodItem(id: "basic-76", name: "Cola", kcal: 42, protein: 0, fat: 0, carbs: 10.6, sugar: 10.6, salt: 0.0, defaultGrams: 330, pieceGrams: 330, pieceName: "Dose"),
        FoodItem(id: "basic-77", name: "Cola Zero", kcal: 0.4, protein: 0, fat: 0, carbs: 0, sugar: 0, salt: 0.0, defaultGrams: 330, pieceGrams: 330, pieceName: "Dose"),
        FoodItem(id: "basic-78", name: "Orangensaft", kcal: 45, protein: 0.7, fat: 0.2, carbs: 10, sugar: 9, salt: 0.0, defaultGrams: 200),
        FoodItem(id: "basic-79", name: "Bier", kcal: 43, protein: 0.5, fat: 0, carbs: 3.5, sugar: 0.1, salt: 0.0, defaultGrams: 500),
        FoodItem(id: "basic-80", name: "Rotwein", kcal: 85, protein: 0.1, fat: 0, carbs: 2.6, sugar: 0.6, salt: 0.0, defaultGrams: 150),
        FoodItem(id: "basic-81", name: "Kaffee mit Milch", kcal: 15, protein: 1, fat: 0.6, carbs: 1.2, sugar: 1.2, salt: 0.0, defaultGrams: 200),
        FoodItem(id: "brand-82", name: "Designer Whey Protein (Pulver)", brand: "ESN", kcal: 376, protein: 76, fat: 5, carbs: 6.9, sugar: 5.7, salt: 1.0, defaultGrams: 30),
        FoodItem(id: "brand-83", name: "Isoclear Whey Isolate (Pulver)", brand: "ESN", kcal: 340, protein: 84, fat: 0, carbs: 0.3, sugar: 0.3, salt: 0.28, defaultGrams: 25),
        FoodItem(id: "brand-84", name: "Total Protein Schoko-Brownie (Pulver)", brand: "MORE Nutrition", kcal: 365, protein: 72.9, fat: 5.1, carbs: 4.7, sugar: 2.3, salt: 0.28, defaultGrams: 30),
        FoodItem(id: "brand-85", name: "Proteinpulver Strawberry (Pulver)", brand: "MORE Nutrition", kcal: 375, protein: 78, fat: 3.6, carbs: 8, sugar: 3.7, salt: 1.5, defaultGrams: 30),
        FoodItem(id: "brand-86", name: "Gold Standard 100% Whey (Pulver)", brand: "Optimum Nutrition", kcal: 372, protein: 78.5, fat: 3.8, carbs: 5.8, sugar: 3.9, salt: 0.61, defaultGrams: 30),
        FoodItem(id: "brand-87", name: "100% Whey Protein Professional (Pulver)", brand: "Scitec Nutrition", kcal: 389, protein: 73.3, fat: 3.3, carbs: 12.7, sugar: 5.0, salt: 0.5, defaultGrams: 30),
        FoodItem(id: "brand-88", name: "Impact Whey Protein geschmacksneutral (Pulver)", brand: "Myprotein", kcal: 381, protein: 75, fat: 6.3, carbs: 5.9, sugar: 3.0, salt: 0.5, defaultGrams: 25),
        FoodItem(id: "brand-89", name: "Protein Bar Cookies & Cream", brand: "Barebells", kcal: 353, protein: 36.4, fat: 12.4, carbs: 30.9, sugar: 3, salt: 0.5, defaultGrams: 55, pieceGrams: 55, pieceName: "Riegel"),
    ]

    /// Englische Bildklassen (Apple Vision) -> Suchbegriff in der Datenbank
    static let visionMap: [String: String] = [
        "egg": "Ei", "eggs": "Ei", "banana": "Banane", "apple": "Apfel", "orange": "Orange", "grape": "Weintrauben",
        "strawberry": "Erdbeeren", "blueberry": "Blaubeeren", "avocado": "Avocado", "cucumber": "Gurke", "tomato": "Tomate",
        "bell_pepper": "Paprika", "pepper": "Paprika", "broccoli": "Brokkoli", "carrot": "Karotte", "almond": "Mandeln",
        "walnut": "Walnüsse", "peanut": "Erdnüsse", "cashew": "Cashewkerne", "bread": "Vollkornbrot", "toast": "Toastbrot",
        "bun": "Brötchen", "oatmeal": "Haferflocken", "cereal": "Müsli", "rice": "Reis", "pasta": "Nudeln", "noodle": "Nudeln",
        "potato": "Kartoffeln", "cheese": "Gouda", "mozzarella": "Mozzarella", "feta": "Feta", "yogurt": "Joghurt",
        "quark": "Quark", "milk": "Milch", "salmon": "Lachs", "tuna": "Thunfisch", "shrimp": "Garnelen", "chicken": "Hähnchen",
        "turkey": "Pute", "ham": "Schinken", "salami": "Salami", "sausage": "Salami", "tofu": "Tofu", "hummus": "Hummus",
        "pizza": "Pizza", "chocolate": "schokolade", "honey": "Honig", "jam": "Marmelade", "butter": "Butter", "olive_oil": "Olivenöl",
        "beer": "Bier", "wine": "Rotwein", "coffee": "Kaffee", "cola": "Cola", "juice": "Orangensaft", "corn": "Mais",
        "lentil": "Linsen", "bean": "Bohnen", "chickpea": "Kichererbsen", "peanut_butter": "Erdnussbutter"
    ]
}

/// Gespeicherte Produkte (gescannt oder selbst angelegt) und zuletzt benutzte Lebensmittel.
final class FoodStore: ObservableObject {
    @Published var saved: [FoodItem] = [] { didSet { persist() } }
    @Published var recentIDs: [String] = [] { didSet { persist() } }

    init() {
        let d = UserDefaults.standard
        if let data = d.data(forKey: "foodStore.saved"), let v = try? JSONDecoder().decode([FoodItem].self, from: data) { saved = v }
        if let v = d.stringArray(forKey: "foodStore.recent") { recentIDs = v }
    }

    private func persist() {
        let d = UserDefaults.standard
        if let data = try? JSONEncoder().encode(saved) { d.set(data, forKey: "foodStore.saved") }
        d.set(recentIDs, forKey: "foodStore.recent")
    }

    var all: [FoodItem] { saved + FoodDB.basics }

    var recents: [FoodItem] {
        let pool = all
        return recentIDs.compactMap { id in pool.first { $0.id == id } }
    }

    func remember(_ item: FoodItem) {
        if !item.id.hasPrefix("basic-"), !item.id.hasPrefix("brand-"), !saved.contains(where: { $0.id == item.id }) { saved.insert(item, at: 0) }
        recentIDs.removeAll { $0 == item.id }
        recentIDs.insert(item.id, at: 0)
        if recentIDs.count > 12 { recentIDs = Array(recentIDs.prefix(12)) }
    }

    func delete(_ item: FoodItem) {
        saved.removeAll { $0.id == item.id }
        recentIDs.removeAll { $0 == item.id }
    }

    func search(_ q: String) -> [FoodItem] {
        let words = q.lowercased().split(separator: " ").map(String.init).filter { !$0.isEmpty }
        guard !words.isEmpty else { return [] }
        return all.filter { f in
            let hay = (f.brand + " " + f.name).lowercased()
            return words.allSatisfy { hay.contains($0) }
        }
    }
}
