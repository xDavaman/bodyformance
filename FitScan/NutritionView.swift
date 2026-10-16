import Combine
import PhotosUI
import SwiftUI
import UIKit

// Reiter „Essen“: Tagesübersicht (Kalorien, Protein, Fett, Kohlenhydrate, Salz, Wasser), Tagesplan nach Trainingstyp,
// Mahlzeiten Frühstück / Mittag / Abend / Zwischenmahlzeit, Rezeptbibliothek und Meal Prep.

private func g0(_ v: Double) -> String { String(Int(v.rounded())) }
private func eur(_ v: Double) -> String { String(format: "%.2f €", v) }

struct NutritionView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var log: FoodLog
    @EnvironmentObject var recipes: RecipeStore
    @EnvironmentObject var premium: PremiumStore

    @State private var day = Date()
    @State private var maxMinutes = 0          // 0 = egal
    @State private var mealPrep = false
    @State private var vegetarian = false
    @State private var shuffle: [MealSlot: Int] = [:]
    @State private var customSlot: MealSlot?
    @State private var foodSlot: MealSlot?

    private var dayType: DayType { log.dayType(day: day, fallback: profile.defaultDayType) }
    private var targets: DayTargets { profile.targets(for: dayType) }
    private var eaten: Macros { log.totals(day: day) }

    var body: some View {
        NavigationStack {
            let plan = DayPlanner.plan(day: day, type: dayType, targets: targets,
                                       maxMinutes: maxMinutes == 0 ? nil : maxMinutes, mealPrep: mealPrep,
                                       vegetarian: vegetarian, shuffle: shuffle, recipes: recipes.all)
            List {
                overview
                waterSection
                settingsSection
                ForEach(MealSlot.allCases) { slot in
                    slotSection(slot, planned: plan[slot])
                }
                Section("Rezepte") {
                    NavigationLink { RecipeLibraryView() } label: {
                        Label("Alle Rezepte (\(recipes.all.count))", systemImage: "book")
                    }
                    NavigationLink { RecipePhotosView() } label: {
                        Label("Fotos für Essenspläne hochladen", systemImage: "photo.on.rectangle.angled")
                    }
                }
                Section {
                    Text("Nährwerte und Preise sind Richtwerte aus Standard-Zutatenwerten und Discounter-Preisen. Abweichungen je nach Marke und Region sind normal.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Essen")
            .sheet(item: $customSlot) { slot in
                CustomEntrySheet(slot: slot, day: day)
            }
            .sheet(item: $foodSlot) { slot in
                FoodAddSheet(slot: slot, day: day)
            }
        }
    }

    // MARK: Abschnitte

    private var overview: some View {
        Section {
            HStack {
                Button { shift(-1) } label: { Image(systemName: "chevron.left") }
                    .buttonStyle(.borderless)
                Spacer()
                VStack(spacing: 2) {
                    Text(day, format: .dateTime.weekday(.wide).day().month())
                        .font(.headline)
                    if Calendar.current.isDateInToday(day) { Text("Heute").font(.caption).foregroundStyle(.secondary) }
                }
                Spacer()
                Button { shift(1) } label: { Image(systemName: "chevron.right") }
                    .buttonStyle(.borderless)
            }
            Picker("Tagestyp", selection: Binding(get: { dayType }, set: { log.setDayType(day: day, $0) })) {
                ForEach(DayType.allCases) { Text($0.rawValue).tag($0) }
            }
            Text(dayType.note).font(.footnote).foregroundStyle(.secondary)
            bar("Kalorien", eaten.kcal, Double(targets.kcal), "kcal")
            bar("Protein", eaten.protein, Double(targets.protein), "g")
            if premium.has(.fullMacros) {
                bar("Kohlenhydrate", eaten.carbs, Double(targets.carbs), "g")
                bar("Fett", eaten.fat, Double(targets.fat), "g")
                bar("Salz", eaten.salt, targets.saltMax, "g", decimals: true)
                LabeledContent("Kosten heute", value: eur(eaten.price))
            } else {
                LockedRow(feature: .fullMacros)
            }
        } header: {
            Text("Tagesübersicht · Tempo: \(profile.pace.rawValue)")
        } footer: {
            Text("Die Ziele passen sich an Ziel, Tempo und Tagestyp an. Eine Änderung unter Körperdaten und Ziele rechnet alles neu.")
        }
    }

    private func bar(_ title: String, _ value: Double, _ goal: Double, _ unit: String, decimals: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                Text(decimals ? String(format: "%.1f / %.0f %@", value, goal, unit) : "\(g0(value)) / \(g0(goal)) \(unit)")
                    .foregroundStyle(.secondary).font(.subheadline)
            }
            ProgressView(value: min(value, max(goal, 1)), total: max(goal, 1))
                .tint(value > goal * 1.05 ? .orange : .accentColor)
        }
    }

    private var waterSection: some View {
        let ml = log.waterML(day: day)
        let goal = targets.waterML
        return Section("Wasser") {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Label("\(String(format: "%.2f", Double(ml) / 1000)) / \(String(format: "%.2f", Double(goal) / 1000)) l", systemImage: "drop")
                    Spacer()
                }
                ProgressView(value: min(Double(ml), Double(goal)), total: Double(max(goal, 1)))
            }
            HStack {
                Button("−250 ml") { log.addWater(day: day, ml: -250) }
                Spacer()
                Button("+250 ml") { log.addWater(day: day, ml: 250) }
                Spacer()
                Button("+500 ml") { log.addWater(day: day, ml: 500) }
            }
            .buttonStyle(.bordered)
        }
    }

    private var settingsSection: some View {
        Section {
            Picker("Kochzeit", selection: $maxMinutes) {
                Text("Egal").tag(0)
                Text("Schnell (bis 15 Min.)").tag(15)
                Text("Normal (bis 30 Min.)").tag(30)
            }
            Toggle("Meal-Prep-Modus", isOn: $mealPrep)
            Toggle("Vegetarisch", isOn: $vegetarian)
        } header: {
            Text("Planung")
        } footer: {
            Text("Meal Prep: Mittag und Abend bestehen aus vorkochbaren Gerichten, die 3 Tage in Folge gleich bleiben, damit du einmal kochen und mehrere Tage essen kannst.")
        }
    }

    private func slotSection(_ slot: MealSlot, planned: PlannedMeal?) -> some View {
        let items = log.entries(day: day, slot: slot)
        let sum = items.reduce(Macros()) { $0 + $1.macros }
        return Section {
            if let p = planned {
                NavigationLink {
                    RecipeDetailView(recipe: p.recipe, factor: p.factor, slot: slot, day: day)
                } label: {
                    HStack(spacing: 12) {
                        RecipeCover(recipe: p.recipe, height: 56)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(p.recipe.name)
                            Text("\(g0(p.kcal)) kcal · \(g0(p.protein)) g Eiweiß · \(g0(p.carbs)) g KH · \(g0(p.fat)) g Fett")
                                .font(.footnote).foregroundStyle(.secondary)
                            Text("\(p.recipe.minutes) Min. · \(eur(p.price))\(p.recipe.isMealPrep ? " · Meal Prep" : "") · Portion ×\(FoodLog.fmt(p.factor))")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                HStack {
                    Button {
                        log.add(day: day, slot: slot, recipe: p.recipe, factor: p.factor)
                    } label: { Label("Gegessen", systemImage: "checkmark.circle") }
                    Spacer()
                    Button {
                        shuffle[slot, default: 0] += 1
                    } label: { Label("Anderes Rezept", systemImage: "arrow.triangle.2.circlepath") }
                }
                .buttonStyle(.borderless)
            }
            ForEach(items) { e in
                HStack {
                    VStack(alignment: .leading) {
                        Text(e.name)
                        Text("\(g0(e.kcal)) kcal · \(g0(e.protein)) g Eiweiß")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button(role: .destructive) { log.remove(e.id) } label: { Image(systemName: "trash") }
                        .buttonStyle(.borderless)
                }
            }
            Button { foodSlot = slot } label: { Label("Lebensmittel scannen oder suchen", systemImage: "barcode.viewfinder") }
                .buttonStyle(.borderless)
            Button { customSlot = slot } label: { Label("Eigener Eintrag", systemImage: "plus") }
                .buttonStyle(.borderless)
        } header: {
            HStack {
                Label(slot.rawValue, systemImage: slot.icon)
                Spacer()
                Text("\(g0(sum.kcal)) / \(g0(Double(targets.kcal) * slot.share)) kcal")
            }
        }
    }

    private func shift(_ d: Int) {
        day = Calendar.current.date(byAdding: .day, value: d, to: day) ?? day
        shuffle = [:]
    }
}

// MARK: Eigener Eintrag

struct CustomEntrySheet: View {
    let slot: MealSlot
    let day: Date
    var onSaved: () -> Void = {}
    @EnvironmentObject var log: FoodLog
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var kcal = ""
    @State private var protein = ""
    @State private var fat = ""
    @State private var carbs = ""

    private func num(_ s: String) -> Double { Double(s.replacingOccurrences(of: ",", with: ".")) ?? 0 }

    var body: some View {
        NavigationStack {
            Form {
                Section("Eintrag für \(slot.rawValue)") {
                    TextField("Name (z. B. Apfel)", text: $name)
                    TextField("Kalorien (kcal)", text: $kcal).keyboardType(.decimalPad)
                    TextField("Eiweiß (g)", text: $protein).keyboardType(.decimalPad)
                    TextField("Kohlenhydrate (g)", text: $carbs).keyboardType(.decimalPad)
                    TextField("Fett (g)", text: $fat).keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Eigener Eintrag")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Abbrechen") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        log.addCustom(day: day, slot: slot, name: name, kcal: num(kcal), protein: num(protein),
                                      fat: num(fat), carbs: num(carbs))
                        dismiss()
                        onSaved()
                    }
                }
            }
        }
    }
}

// MARK: Rezeptbibliothek

struct RecipeLibraryView: View {
    @EnvironmentObject var store: RecipeStore
    @State private var newRecipe = false
    @State private var slot: MealSlot? = nil
    @State private var fastOnly = false
    @State private var prepOnly = false
    @State private var vegOnly = false
    @State private var diet: Set<DietTag> = []
    @State private var search = ""
    @State private var sort: RecipeSort = .standard

    private var items: [Recipe] {
        sort.apply(store.all.filter { r in
            (slot == nil || r.slots.contains(slot!))
                && (!fastOnly || r.isFast)
                && (!prepOnly || r.isMealPrep)
                && (!vegOnly || r.vegetarian)
                && diet.isSubset(of: Set(r.tags))
                && (search.isEmpty || r.name.localizedCaseInsensitiveContains(search)
                    || r.items.contains { $0.ing.name.localizedCaseInsensitiveContains(search) })
        })
    }

    var body: some View {
        List {
            Section {
                NavigationLink { CommunityView() } label: { Label("Community-Rezepte", systemImage: "person.3") }
                NavigationLink { RecipePhotosView() } label: { Label("Fotos für Essenspläne hochladen", systemImage: "photo.on.rectangle.angled") }
            }
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(DietTag.allCases) { t in
                            Button {
                                if diet.contains(t) { diet.remove(t) } else { diet.insert(t) }
                            } label: {
                                Label(t.rawValue, systemImage: t.icon)
                                    .font(.subheadline).padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(diet.contains(t) ? Color.accentColor : Color.secondary.opacity(0.15), in: Capsule())
                                    .foregroundStyle(diet.contains(t) ? Color.white : Color.primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                Picker("Mahlzeit", selection: $slot) {
                    Text("Alle").tag(MealSlot?.none)
                    ForEach(MealSlot.allCases) { Text($0.rawValue).tag(MealSlot?.some($0)) }
                }
                Toggle("Schnell (bis 15 Min.)", isOn: $fastOnly)
                Toggle("Meal Prep", isOn: $prepOnly)
                Toggle("Vegetarisch", isOn: $vegOnly)
                Picker("Sortieren", selection: $sort) {
                    ForEach(RecipeSort.allCases) { Text($0.rawValue).tag($0) }
                }
            }
            Section("\(items.count) Rezepte") {
                ForEach(items) { r in
                    NavigationLink {
                        RecipeDetailView(recipe: r, factor: 1, slot: r.slots.first ?? .lunch, day: Date())
                    } label: {
                        HStack(spacing: 12) {
                            RecipeCover(recipe: r, height: 56)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(r.name)
                                Text("\(g0(r.kcal)) kcal · \(g0(r.protein)) g Eiweiß · \(String(format: "%.1f", r.salt)) g Salz · \(eur(r.price))")
                                    .font(.footnote).foregroundStyle(.secondary)
                                Text("\(r.slots.map(\.rawValue).joined(separator: ", ")) · \(r.minutes) Min.\(r.isMealPrep ? " · Meal Prep" : "")\(r.vegan ? " · vegan" : (r.vegetarian ? " · vegetarisch" : ""))\(r.rating.map { " · ★ " + String(format: "%.1f", $0) } ?? "")")
                                    .font(.caption).foregroundStyle(.secondary)
                                if !r.tags.isEmpty {
                                    Text(r.tags.map(\.rawValue).joined(separator: " · "))
                                        .font(.caption2).foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $search, prompt: "Rezept oder Zutat suchen")
        .navigationTitle("Rezepte")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { newRecipe = true } label: { Label("Eigenes Rezept", systemImage: "plus") }
            }
        }
        .sheet(isPresented: $newRecipe) { CustomRecipeEditor(recipe: nil) }
    }
}

// MARK: Rezept-Detail

struct RecipeDetailView: View {
    let recipe: Recipe
    @State var factor: Double
    @State var slot: MealSlot
    let day: Date
    @State private var persons = 1
    @State private var days = 1
    private var portions: Int { persons * days }
    @State private var added = false
    @EnvironmentObject var log: FoodLog
    @EnvironmentObject var store: RecipeStore
    @State private var editSteps = false
    @State private var editRecipe = false
    @State private var shareSheet = false
    @State private var photoItem: PhotosPickerItem?
    @State private var showCamera = false
    @State private var cooking = false

    init(recipe: Recipe, factor: Double, slot: MealSlot, day: Date) {
        self.recipe = recipe
        self.day = day
        _factor = State(initialValue: factor)
        _slot = State(initialValue: slot)
    }

    private func amount(_ item: RecipeItem) -> String {
        let grams = item.grams * factor * Double(portions)
        var s = "\(g0(grams)) g"
        if let pg = item.ing.pieceGrams, let pn = item.ing.pieceName {
            let n = grams / pg
            s += " (≈ \(n == n.rounded() ? String(Int(n)) : String(format: "%.1f", n)) \(pn))"
        }
        return s
    }

    private var shoppingText: String {
        var lines = ["Einkauf: \(recipe.name) für \(persons) Person\(persons == 1 ? "" : "en") × \(days) Tag\(days == 1 ? "" : "e")"]
        for item in recipe.items where item.ing.name != "Salz" && item.ing.name != "Gewürze und Kräuter" {
            lines.append("• \(item.ing.name): \(amount(item))")
        }
        lines.append("Gesamt ca. \(eur(recipe.price * factor * Double(portions)))")
        return lines.joined(separator: "\n")
    }

    var body: some View {
        List {
            Section {
                RecipeCover(recipe: recipe, height: 190, wide: true)
                    .listRowInsets(EdgeInsets())
                HStack {
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Label("Foto wählen", systemImage: "photo")
                    }
                    .buttonStyle(.borderless)
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        Spacer()
                        Button { showCamera = true } label: { Label("Aufnehmen", systemImage: "camera") }
                            .buttonStyle(.borderless)
                    }
                    Spacer()
                    if store.hasOwnPhoto(recipe) {
                        Button("Foto entfernen", role: .destructive) { store.removePhoto(for: recipe) }
                            .buttonStyle(.borderless)
                    }
                }
                if let r = recipe.rating {
                    Text("Vorbild-Bewertung ★ \(String(format: "%.1f", r)) von 5 · \(recipe.source). Dieses Rezept ist eine eigene, schnelle Variante.")
                        .font(.footnote).foregroundStyle(.secondary)
                } else if !recipe.source.isEmpty {
                    Text(recipe.source).font(.footnote).foregroundStyle(.secondary)
                }
            }
            RecipeGallerySection(recipe: recipe)
            if !recipe.tags.isEmpty {
                Section {
                    HStack {
                        ForEach(recipe.tags) { t in
                            Label(t.rawValue, systemImage: t.icon).font(.caption)
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Color.accentColor.opacity(0.15), in: Capsule())
                        }
                    }
                }
            }
            Section("Nährwerte pro Portion") {
                MacroOverview(recipe: recipe, factor: factor)
                LabeledContent("davon Zucker", value: String(format: "%.1f g", recipe.sugar * factor))
                LabeledContent("Zubereitung", value: "\(recipe.minutes) Min.")
                Stepper(value: $factor, in: 0.5...2.5, step: 0.25) {
                    Text("Portionsgröße: ×\(FoodLog.fmt(factor))")
                }
            }
            Section {
                Stepper(value: $persons, in: 1...8) {
                    Text(persons == 1 ? "1 Person" : "\(persons) Personen")
                }
                Stepper(value: $days, in: 1...7) {
                    Text(days == 1 ? "1 Tag" : "\(days) Tage")
                }
                if portions > 1 {
                    Text("= \(portions) Portionen insgesamt")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                ForEach(Array(recipe.items.enumerated()), id: \.offset) { _, item in
                    LabeledContent(item.ing.name, value: amount(item))
                }
                PriceBreakdown(recipe: recipe, scale: factor * Double(portions))
                if portions > 1 {
                    LabeledContent("Gesamtpreis ca.", value: eur(recipe.price * factor * Double(portions)))
                    ShareLink(item: shoppingText) { Label("Einkaufsliste teilen", systemImage: "square.and.arrow.up") }
                }
            } header: {
                Text("Zutaten")
            } footer: {
                if days > 1 && recipe.prepDays == 0 {
                    Text("Dieses Gericht schmeckt frisch am besten. Für mehrere Tage besser täglich kochen oder ein Meal-Prep-Rezept nehmen.")
                } else if days > recipe.prepDays && recipe.prepDays > 0 {
                    Text("Vorgekocht hält es etwa \(recipe.prepDays) Tage im Kühlschrank. Für \(days) Tage nach dem Zeitraum einen Teil einfrieren oder zweimal kochen.")
                } else if recipe.isMealPrep {
                    Text("Vorkochen: hält sich etwa \(recipe.prepDays) Tage im Kühlschrank, einfrieren möglich.")
                }
            }
            Section {
                let steps = store.steps(for: recipe)
                if !steps.isEmpty {
                    Button { cooking = true } label: {
                        Label(portions > 1 ? "Kochen starten (\(portions) Portionen)" : "Kochen starten", systemImage: "frying.pan")
                            .font(.headline)
                    }
                }
                if steps.isEmpty { Text("Noch keine Schritte. Tippe auf „Schritte bearbeiten“.").foregroundStyle(.secondary) }
                ForEach(Array(steps.enumerated()), id: \.offset) { i, s in
                    HStack(alignment: .top) {
                        Text("\(i + 1). \(s)")
                        if let img = store.stepPhoto(recipe, step: i) {
                            Spacer()
                            Image(uiImage: img).resizable().scaledToFill()
                                .frame(width: 54, height: 54).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                if !recipe.note.isEmpty {
                    Text(recipe.note).font(.footnote).foregroundStyle(.secondary)
                }
                Button { editSteps = true } label: { Label("Schritte bearbeiten", systemImage: "pencil") }
                if recipe.isCustom {
                    Button { editRecipe = true } label: { Label("Rezept bearbeiten", systemImage: "square.and.pencil") }
                    Button { shareSheet = true } label: { Label("Mit Community teilen", systemImage: "person.3") }
                }
            } header: {
                Text(store.hasCustomSteps(recipe) ? "Zubereitung (deine Schritte)" : "Zubereitung")
            }
            Section {
                Picker("Mahlzeit", selection: $slot) {
                    ForEach(MealSlot.allCases) { Text($0.rawValue).tag($0) }
                }
                Button {
                    log.add(day: day, slot: slot, recipe: recipe, factor: factor)
                    added = true
                } label: {
                    Label(added ? "Eingetragen" : "Ins Tagebuch eintragen", systemImage: added ? "checkmark.circle.fill" : "plus.circle")
                }
            }
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $editSteps) { StepEditorSheet(recipe: recipe, initial: store.steps(for: recipe)) }
        .sheet(isPresented: $shareSheet) {
            if let i = store.customIndex(for: recipe) { ShareToCommunitySheet(recipe: store.customs[i]) }
        }
        .sheet(isPresented: $editRecipe) { CustomRecipeEditor(recipe: store.customIndex(for: recipe).map { store.customs[$0] }) }
        .fullScreenCover(isPresented: $cooking) {
            CookModeView(recipe: recipe, scale: factor * Double(portions))
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker { img in store.setPhoto(img, for: recipe) }
                .ignoresSafeArea()
        }
        .onChange(of: photoItem) { _, item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self) { store.setPhoto(data, for: recipe) }
                photoItem = nil
            }
        }
    }
}
