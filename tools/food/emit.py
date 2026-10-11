from gen import ING, R
try:
    from gen import SUGAR
except ImportError:
    SUGAR={}
import re
def esc(s): return s.replace('\\','\\\\').replace('"','\\"')
def ident(k): return k
out=['// AUTOMATISCH ERZEUGT (tools/food/gen.py) – Zutaten (je 100 g, Richtwerte) und Rezepte. Makros und Preis werden aus den Zutaten berechnet.',
'import Foundation','',
'/// Zutat mit Nährwerten und Richtpreis je 100 g (Discounter-Preise, geschätzt)',
'struct Ing: Hashable {','    let name: String','    let kcal: Double, protein: Double, fat: Double, carbs: Double','    let salt: Double','    let price: Double','    var sugar: Double = 0','    var pieceGrams: Double? = nil','    var pieceName: String? = nil','}','',
'enum Ingredients {']
for k,(n,kc,p,f,c,s,pr) in ING.items():
    extra=''
    if k=='ei': extra=', pieceGrams: 55, pieceName: "Ei"'
    if k=='wrap': extra=', pieceGrams: 62, pieceName: "Wrap"'
    out.append(f'    static let {k} = Ing(name: "{esc(n)}", kcal: {kc}, protein: {p}, fat: {f}, carbs: {c}, salt: {s}, price: {pr}, sugar: {SUGAR.get(k,0)}{extra})')
out.append('    static let all: [Ing] = [' + ', '.join(ING.keys()) + ']\n}\n')
out.append('''struct RecipeItem { let ing: Ing; let grams: Double }
private func i(_ ing: Ing, _ g: Double) -> RecipeItem { RecipeItem(ing: ing, grams: g) }

struct Recipe: Identifiable {
    let id: String
    let name: String
    let slots: [MealSlot]
    let minutes: Int
    /// Wie viele Tage sich das Gericht vorkochen lässt (0 = frisch essen)
    let prepDays: Int
    let vegetarian: Bool
    let vegan: Bool
    let items: [RecipeItem]
    let steps: [String]
    let note: String
    var rating: Double? = nil
    var source: String = ""
    var isCustom = false

    var kcal: Double { items.reduce(0) { $0 + $1.ing.kcal * $1.grams / 100 } }
    var protein: Double { items.reduce(0) { $0 + $1.ing.protein * $1.grams / 100 } }
    var fat: Double { items.reduce(0) { $0 + $1.ing.fat * $1.grams / 100 } }
    var carbs: Double { items.reduce(0) { $0 + $1.ing.carbs * $1.grams / 100 } }
    var salt: Double { items.reduce(0) { $0 + $1.ing.salt * $1.grams / 100 } }
    var sugar: Double { items.reduce(0) { $0 + $1.ing.sugar * $1.grams / 100 } }
    var price: Double { items.reduce(0) { $0 + $1.ing.price * $1.grams / 100 } }
    var carbShare: Double { kcal > 0 ? carbs * 4 / kcal : 0 }
    var proteinShare: Double { kcal > 0 ? protein * 4 / kcal : 0 }
    var isMealPrep: Bool { prepDays > 0 }
    var isFast: Bool { minutes <= 15 }
    var fatShare: Double { kcal > 0 ? fat * 9 / kcal : 0 }
    /// Ernährungsform-Tags, automatisch aus den Nährwerten pro Portion
    var tags: [DietTag] {
        var t: [DietTag] = []
        if carbs <= 15 && fatShare >= 0.45 { t.append(.keto) }
        if carbs <= 25 { t.append(.lowCarb) }
        if sugar <= 8 { t.append(.lowSugar) }
        if protein >= 30 && proteinShare >= 0.25 { t.append(.highProtein) }
        if kcal <= 400 { t.append(.lowKcal) }
        return t
    }
}

enum DietTag: String, CaseIterable, Identifiable {
    case keto = "Keto", lowCarb = "Low Carb", lowSugar = "Zuckerarm", highProtein = "High Protein", lowKcal = "Kalorienarm"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .keto: return "drop.fill"
        case .lowCarb: return "leaf.fill"
        case .lowSugar: return "cube.fill"
        case .highProtein: return "bolt.fill"
        case .lowKcal: return "flame.fill"
        }
    }
}

enum RecipeLibrary {
    static let all: [Recipe] = build()

    private static func build() -> [Recipe] {
        var r: [Recipe] = []''')
slotmap={'F':'.breakfast','M':'.lunch','A':'.dinner','S':'.snack'}
for idx,(name,slots,minutes,prep,veg,vegan,ings,steps,note,rating,source) in enumerate(R):
    rid=re.sub(r'[^a-z0-9]+','-',name.lower().replace('ä','ae').replace('ö','oe').replace('ü','ue').replace('ß','ss')).strip('-')
    items=', '.join(f'i(Ingredients.{k}, {g})' for k,g in ings)
    st=', '.join(f'"{esc(s)}"' for s in steps)
    sl=', '.join(slotmap[c] for c in slots)
    out.append(f'        let items{idx}: [RecipeItem] = [{items}]')
    out.append(f'        r.append(Recipe(id: "{rid}", name: "{esc(name)}", slots: [{sl}], minutes: {minutes}, prepDays: {prep}, vegetarian: {str(veg).lower()}, vegan: {str(vegan).lower()}, items: items{idx}, steps: [{st}], note: "{esc(note)}"{(", rating: "+str(rating)) if rating else ""}{(", source: "+chr(34)+esc(source)+chr(34)) if source else ""}))')
out.append('        return r\n    }\n}')
open('FoodData.swift','w').write('\n'.join(out)+'\n')
print(len(out))
