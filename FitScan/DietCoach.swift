import SwiftUI

/// Diät-Coach (Demo): Was essen, wie oft – ohne Hunger. Dazu ein radikaler Modus mit Sicherheitsgrenzen und Bestätigung.
enum DietMode: String, CaseIterable, Identifiable {
    case comfort = "Satt & entspannt"
    case standard = "Standard"
    case radical = "Radikal"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .comfort: return "leaf"
        case .standard: return "target"
        case .radical: return "bolt.heart"
        }
    }
}

struct DietPlan {
    var mode: DietMode
    var maintenance: Int
    var kcal: Int
    var protein: Int
    var fat: Int
    var carbs: Int
    var meals: [Meal]
    var kgPerWeek: Double
    var capped: Bool

    struct Meal: Identifiable {
        let id = UUID()
        var name: String
        var kcal: Int
        var protein: Int
        var idea: String
    }
}

extension UserProfile {
    var bmrValue: Double { 10 * weightKg + 6.25 * heightCm - 5 * Double(age) + 5 }
    var maintenanceKcal: Int {
        Int((bmrValue * (1.3 + 0.05 * Double(trainingDays) + (sport == .none ? 0 : 0.05))).rounded())
    }

    func dietPlan(_ mode: DietMode) -> DietPlan {
        let maint = Double(maintenanceKcal)
        let bmr = bmrValue
        var kcal: Double
        var capped = false
        switch mode {
        case .comfort: kcal = maint - 350
        case .standard: kcal = maint - 550
        case .radical:
            kcal = maint - min(1000, maint * 0.35)
            // harte Untergrenze: nie unter Grundumsatz und nie unter 1 500 kcal
            let floor = max(bmr, 1500)
            if kcal < floor { kcal = floor; capped = true }
        }
        if mode != .radical { kcal = max(kcal, bmr * 1.15) }
        let proteinG = weightKg * (mode == .radical ? 2.3 : 2.0)
        let fatG = max(kcal * 0.25 / 9, weightKg * 0.7)
        let carbG = max(0, (kcal - proteinG * 4 - fatG * 9) / 4)
        let perMeal = mode == .radical ? [0.3, 0.35, 0.35] : [0.25, 0.30, 0.15, 0.30]
        let names = mode == .radical ? ["Frühstück", "Mittag", "Abendessen"] : ["Frühstück", "Mittag", "Snack", "Abendessen"]
        let meals = zip(names, perMeal).map { n, share -> DietPlan.Meal in
            let k = Int((kcal * share).rounded()), p = Int((proteinG * share).rounded())
            return .init(name: n, kcal: k, protein: p, idea: Self.idea(n, kcal: Double(k), protein: Double(p)))
        }
        return DietPlan(mode: mode, maintenance: Int(maint), kcal: Int(kcal.rounded()), protein: Int(proteinG.rounded()),
                        fat: Int(fatG.rounded()), carbs: Int(carbG.rounded()), meals: meals,
                        kgPerWeek: (maint - kcal) * 7 / 7700, capped: capped)
    }

    private static func r10(_ x: Double) -> Int { max(10, Int((x / 10).rounded()) * 10) }

    /// Konkrete Beispielmahlzeit, grob auf Kalorien und Eiweiß skaliert (satt durch Volumen, Eiweiß und Ballaststoffe).
    static func idea(_ meal: String, kcal: Double, protein: Double) -> String {
        switch meal {
        case "Frühstück":
            return "\(r10(kcal * 0.35 / 3.7)) g Haferflocken, \(r10(protein * 0.6 / 0.11)) g Skyr oder Magerquark, 150 g Beeren oder Apfel, Zimt."
        case "Mittag":
            return "\(r10(protein * 0.7 / 0.22)) g Hähnchen oder Fisch, \(r10(kcal * 0.35 / 0.85)) g Kartoffeln oder \(r10(kcal * 0.3 / 3.5)) g Reis (roh), dazu 300 g Gemüse."
        case "Snack":
            return "Obst und \(r10(protein * 0.7 / 0.11)) g Skyr, oder 2 Eier und eine Karotte. Dazu Wasser oder Kaffee."
        default:
            return "\(r10(protein * 0.6 / 0.12)) g Magerquark oder \(r10(protein * 0.6 / 0.13)) g Putenbrust, großer Salat oder 400 g Gemüse, \(r10(kcal * 0.3 / 2.5)) g Vollkornbrot oder Kartoffeln."
        }
    }
}

struct DietCoachView: View {
    @EnvironmentObject var profile: UserProfile
    @State private var mode: DietMode = .comfort
    private var confirmedAt: Double { profile.extremeConfirmedAt }
    @State private var showConfirm = false

    private var radicalActive: Bool { confirmedAt > 0 && Date().timeIntervalSince1970 - confirmedAt < 28 * 86400 }
    private var plan: DietPlan { profile.dietPlan(mode) }

    var body: some View {
        List {
            Section {
                Label("Demo: Die Zahlen sind Vorschläge. Deine Tagesziele in der App ändern sich dadurch noch nicht.", systemImage: "eye")
                    .font(.footnote).foregroundStyle(.secondary)
            }

            Section("Modus") {
                Picker("Modus", selection: Binding(get: { mode }, set: { new in
                    if new == .radical && !radicalActive { showConfirm = true } else { mode = new }
                })) {
                    ForEach(DietMode.allCases) { Label($0.rawValue, systemImage: $0.icon).tag($0) }
                }
                .pickerStyle(.segmented)
                Text(modeNote).font(.footnote).foregroundStyle(.secondary)
            }

            if mode == .radical { radicalBanner }

            Section("Dein Tag") {
                HStack {
                    big("\(plan.kcal)", "kcal")
                    big("\(plan.protein) g", "Eiweiß")
                    big("\(plan.carbs) g", "Kohlenhydr.")
                    big("\(plan.fat) g", "Fett")
                }
                LabeledContent("Erhaltungsbedarf", value: "\(plan.maintenance) kcal")
                LabeledContent("Erwarteter Verlust", value: String(format: "ca. %.1f kg pro Woche", plan.kgPerWeek))
                if plan.capped {
                    Label("Sicherheitsgrenze greift: nicht unter deinen Grundumsatz und nie unter 1 500 kcal.", systemImage: "shield.lefthalf.filled")
                        .font(.footnote).foregroundStyle(.orange)
                }
            }

            Section {
                ForEach(plan.meals) { m in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(m.name).font(.headline)
                            Spacer()
                            Text("\(m.kcal) kcal · \(m.protein) g Eiweiß").font(.footnote).foregroundStyle(.secondary).monospacedDigit()
                        }
                        Text(m.idea).font(.footnote)
                    }
                    .padding(.vertical, 2)
                }
            } header: {
                Text("\(plan.meals.count) Mahlzeiten am Tag")
            } footer: {
                Text("Eiweiß auf alle Mahlzeiten verteilen. Das hält satt und schützt die Muskeln. Mengen sind grobe Beispiele, Rohgewicht.")
            }

            Section("Satt bleiben ohne Hunger") {
                tip("Zuerst Eiweiß und Gemüse auf den Teller, dann der Rest.", "fork.knife")
                tip("Viel Volumen, wenig Kalorien: Kartoffeln, Gemüse, Salat, Suppe, Beeren, Magerquark, Skyr.", "carrot")
                tip("Ballaststoffe: Haferflocken, Hülsenfrüchte, Vollkorn. Sie sättigen länger.", "leaf")
                tip("Trinken: mindestens \(Int((profile.weightKg * 35 / 100).rounded()) * 100 / 1000) bis \(Int((profile.weightKg * 35 / 100).rounded() + 5) / 10) Liter Wasser, ungesüßter Kaffee oder Tee. Durst fühlt sich oft wie Hunger an.", "drop")
                tip("Langsam essen, ohne Handy. Der Sattmacher-Effekt kommt nach etwa 20 Minuten.", "clock")
                tip("Schlaf: 7 bis 9 Stunden. Zu wenig Schlaf macht hungrig.", "moon")
                tip("Einmal pro Woche auf Erhaltungskalorien essen (Diät-Pause), das hält Hunger und Stimmung im Griff.", "calendar")
            }
        }
        .navigationTitle("Diät-Coach")
        .sheet(isPresented: $showConfirm) {
            RadicalConfirmView { profile.extremeConfirmedAt = Date().timeIntervalSince1970; mode = .radical }
        }
    }

    private var modeNote: String {
        switch mode {
        case .comfort: return "Kleines Defizit, kaum Hunger, gut durchzuhalten. Etwa 0,3 bis 0,4 kg pro Woche."
        case .standard: return "Mittleres Defizit, der Normalfall. Etwa 0,5 kg pro Woche."
        case .radical: return "Großes Defizit für kurze Zeit. Nur für gesunde Erwachsene, maximal 4 Wochen, danach mindestens 2 Wochen Pause."
        }
    }

    private var radicalBanner: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Label("Radikaler Modus – nicht gesund auf Dauer", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline).foregroundStyle(.red)
                Text("Das ist eine Kurz-Kur, keine Dauerlösung. Es drohen Muskelverlust, Müdigkeit, Heißhunger, Kreislaufprobleme, Gallensteine und Nährstoffmangel. Bei Schwindel, Herzrasen, Ohnmacht, starker Schwäche oder Essgedanken, die dich belasten, sofort beenden und ärztlich abklären.")
                    .font(.footnote)
                if radicalActive {
                    let days = max(0, 28 - Int((Date().timeIntervalSince1970 - confirmedAt) / 86400))
                    Text("Bestätigt. Maximal noch \(days) Tage, danach Pause.").font(.footnote.bold())
                    Button(role: .destructive) { profile.extremeConfirmedAt = 0; mode = .standard } label: {
                        Label("Radikalen Modus beenden", systemImage: "stop.circle")
                    }
                    Text("Bei erneutem Aktivieren musst du wieder alles bestätigen.").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
    }

    private func big(_ v: String, _ s: String) -> some View {
        VStack { Text(v).font(.headline).monospacedDigit(); Text(s).font(.caption2).foregroundStyle(.secondary) }
            .frame(maxWidth: .infinity)
    }

    private func tip(_ t: String, _ icon: String) -> some View {
        Label { Text(t).font(.footnote) } icon: { Image(systemName: icon) }
    }
}

/// Zusätzliche Bestätigung vor dem radikalen Modus.
struct RadicalConfirmView: View {
    @Environment(\.dismiss) private var dismiss
    var onConfirm: () -> Void
    @State private var adult = false
    @State private var healthy = false
    @State private var risks = false
    @State private var typed = ""

    private var ok: Bool { adult && healthy && risks && typed.trimmingCharacters(in: .whitespaces).uppercased() == "VERSTANDEN" }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Label("Achtung: gesundheitsschädlich", systemImage: "exclamationmark.triangle.fill")
                        .font(.title3.bold()).foregroundStyle(.red)
                    Text("Der radikale Modus senkt die Kalorien stark. Das ist nicht gesund und kann deiner Gesundheit schaden: Muskel- und Leistungsverlust, Kreislaufprobleme, Gallensteine, Haarausfall, Nährstoffmangel, Stimmungstiefs. Er ist nur für kurze Zeit gedacht. Sprich vor dem Start unbedingt mit deinem Arzt, besonders bei Vorerkrankungen oder Medikamenten. BFC geht nie unter deinen Grundumsatz und nie unter 1 500 kcal.")
                        .font(.footnote)
                }
                Section("Bitte bestätigen") {
                    Toggle("Ich bin über 18 und gesund (keine Vorerkrankungen, nicht schwanger oder stillend, keine Essstörung)", isOn: $adult)
                    Toggle("Ich habe mit meiner Ärztin oder meinem Arzt gesprochen oder spreche vor dem Start mit ihr oder ihm", isOn: $healthy)
                    Toggle("Ich verstehe die Risiken, nutze den Modus höchstens 4 Wochen und stoppe bei Beschwerden", isOn: $risks)
                    TextField("Zum Bestätigen „VERSTANDEN“ tippen", text: $typed).textInputAutocapitalization(.characters).autocorrectionDisabled()
                }
                Section {
                    Button(role: .destructive) { onConfirm(); dismiss() } label: {
                        Text("Radikalen Modus aktivieren").frame(maxWidth: .infinity)
                    }
                    .disabled(!ok)
                    Button("Abbrechen", role: .cancel) { dismiss() }
                }
            }
            .navigationTitle("Radikaler Modus")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
