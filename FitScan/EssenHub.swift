import Charts
import Combine
import SwiftUI

// Bereich „Rezepte“ mit vier Seiten: Rezepte (Bibliothek), Tag (Plan und Tagebuch), Scan und Suche (Produkte erfassen),
// Verlauf und Analyse. Alles, was erfasst wird, landet sofort im Tagesbedarf im Profil und im Verlauf.

enum EssenPage: String, CaseIterable, Identifiable {
    case recipes = "Rezepte"
    case day = "Tag"
    case scan = "Scan & Suche"
    case history = "Verlauf"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .recipes: return "book"
        case .day: return "fork.knife"
        case .scan: return "barcode.viewfinder"
        case .history: return "chart.bar.doc.horizontal"
        }
    }
}

/// Die fünf Hauptbereiche der App (Reihenfolge = Reihenfolge in der unteren Leiste)
enum AppTab: Int, CaseIterable, Identifiable {
    case profile, plan, recipes, mobility, settings
    var id: Int { rawValue }
    var title: String {
        switch self {
        case .profile: return "Profil"
        case .plan: return "Trainingsplan"
        case .recipes: return "Rezepte"
        case .mobility: return "Mobility"
        case .settings: return "Einstellungen"
        }
    }
    /// Kurzer Name für die untere Leiste
    var short: String { self == .plan ? "Plan" : title }
    var icon: String {
        switch self {
        case .profile: return "person.crop.circle"
        case .plan: return "figure.strengthtraining.traditional"
        case .recipes: return "fork.knife"
        case .mobility: return "figure.yoga"
        case .settings: return "gearshape"
        }
    }
}

/// Gemeinsamer Zustand für die Navigation zwischen den Bereichen
final class AppNav: ObservableObject {
    /// Index des Bereichs, siehe AppTab (0 Profil, 1 Trainingsplan, 2 Rezepte, 3 Mobility, 4 Einstellungen)
    @Published var tab = AppTab.profile.rawValue
    @Published var essenPage: EssenPage = .recipes

    func open(_ t: AppTab) { tab = t.rawValue }
    func isOn(_ t: AppTab) -> Bool { tab == t.rawValue }
}

/// Eine Zeile mit dem aktuellen Bereich, die per Tipp aufklappt und alle Bereiche zeigt
struct EssenBar: View {
    @Binding var page: EssenPage
    @State private var open = false

    var body: some View {
        HStack(spacing: 8) {
            if open {
                ForEach(EssenPage.allCases) { p in
                    Button {
                        page = p
                        withAnimation(.easeInOut(duration: 0.2)) { open = false }
                    } label: {
                        Label(p.rawValue, systemImage: p.icon)
                            .font(.subheadline).lineLimit(1).minimumScaleFactor(0.8)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(p == page ? Color.accentColor : Color.secondary.opacity(0.15), in: Capsule())
                            .foregroundStyle(p == page ? Color.white : Color.primary)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Button { withAnimation(.easeInOut(duration: 0.2)) { open = true } } label: {
                    HStack {
                        Label(page.rawValue, systemImage: page.icon).font(.subheadline.bold())
                        Spacer()
                        Image(systemName: "chevron.down").font(.footnote)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Color.secondary.opacity(0.15), in: Capsule())
                    .foregroundStyle(Color.primary)
                }
                .buttonStyle(.plain)
            }
            if open {
                Button { withAnimation(.easeInOut(duration: 0.2)) { open = false } } label: {
                    Image(systemName: "chevron.up").padding(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

/// Untere Hauptleiste (ersetzt die automatische Tab-Leiste, die auf iPad und Mac oben erscheint).
/// Der aktive Bereich bekommt eine farbige Kapsel hinter dem Symbol.
struct MainTabBar: View {
    @EnvironmentObject var nav: AppNav
    @Namespace private var pill

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { t in
                let on = nav.isOn(t)
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { nav.open(t) }
                } label: {
                    VStack(spacing: 3) {
                        ZStack {
                            if on {
                                Capsule().fill(Color.accentColor.opacity(0.16))
                                    .frame(width: 54, height: 30)
                                    .matchedGeometryEffect(id: "pill", in: pill)
                            }
                            Image(systemName: t.icon)
                                .font(.system(size: 19, weight: on ? .semibold : .regular))
                                .symbolVariant(on ? .fill : .none)
                        }
                        .frame(height: 30)
                        Text(t.short).font(.caption2.weight(on ? .semibold : .regular)).lineLimit(1).minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(on ? Color.accentColor : Color.secondary)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(t.title)
                .accessibilityAddTraits(on ? .isSelected : [])
            }
        }
        .padding(.top, 6)
        .padding(.bottom, 2)
        .background(Material.bar, ignoresSafeAreaEdges: .bottom)
        .overlay(alignment: .top) { Divider() }
    }
}

struct EssenTabView: View {
    @EnvironmentObject var nav: AppNav

    var body: some View {
        VStack(spacing: 0) {
            EssenBar(page: $nav.essenPage)
            switch nav.essenPage {
            case .recipes: NavigationStack { RecipeLibraryView() }
            case .day: NutritionView()
            case .scan: FoodScanTab()
            case .history: NavigationStack { FoodHistoryView() }
            }
        }
    }
}

// MARK: Scan und Suche

struct FoodScanTab: View {
    @EnvironmentObject var store: FoodStore
    @EnvironmentObject var log: FoodLog
    @EnvironmentObject var nav: AppNav

    enum Mode: String, CaseIterable, Identifiable {
        case scan = "Scannen", manual = "Manuell"
        var id: String { rawValue }
    }

    @State private var mode: Mode = .scan
    @State private var slot: MealSlot = FoodScanTab.defaultSlot()
    @State private var selected: FoodItem?
    @State private var busy = false
    @State private var status = ""
    @State private var manualCode = ""
    @State private var query = ""
    @State private var showCustom = false
    @State private var customCode: String?
    @State private var quickEntry = false
    @State private var scanKey = UUID()

    static func defaultSlot() -> MealSlot {
        let h = Calendar.current.component(.hour, from: Date())
        switch h {
        case 0..<10: return .breakfast
        case 10..<15: return .lunch
        case 15..<17: return .snack
        default: return .dinner
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Bereich", selection: $mode) {
                        ForEach(Mode.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    Picker("Eintragen in", selection: $slot) {
                        ForEach(MealSlot.allCases) { Text($0.rawValue).tag($0) }
                    }
                }
                if mode == .scan { scanSection } else { manualSection }
            }
            .navigationTitle("Produkt erfassen")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selected) { item in
                FoodAmountSheet(item: item, slot: slot, day: Date()) { finished() }
            }
            .sheet(isPresented: $showCustom) {
                CustomFoodSheet(name: query, barcode: customCode) { item in
                    store.remember(item)
                    // erst öffnen, wenn das Anlegen-Blatt ganz zu ist – sonst verwirft SwiftUI das zweite Blatt
                    Task { try? await Task.sleep(for: .milliseconds(450)); selected = item }
                }
            }
            .sheet(isPresented: $quickEntry) {
                CustomEntrySheet(slot: slot, day: Date(), onSaved: { finished() })
            }
        }
    }

    /// Nach dem Eintragen: zurück ins Profil, dort stehen die Werte schon in den Balken.
    private func finished() {
        scanKey = UUID()
        query = ""
        manualCode = ""
        status = ""
        nav.open(.profile)
    }

    @ViewBuilder private var scanSection: some View {
        Section {
            if BarcodeScannerView.supported && nav.isOn(.recipes) && nav.essenPage == .scan {
                BarcodeScannerView(active: selected == nil && !showCustom && !busy) { code in Task { await lookup(code) } }
                    .id(scanKey)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .listRowInsets(EdgeInsets())
            } else if !BarcodeScannerView.supported {
                Text("Der Kamera-Scanner läuft nur auf einem iPhone. Tippe den Barcode unten ein oder wechsle auf „Manuell“.")
                    .foregroundStyle(.secondary)
            }
            if BarcodeScannerView.supported {
                Button { scanKey = UUID(); status = "" } label: { Label("Neuen Scan starten", systemImage: "barcode.viewfinder") }
            }
            HStack {
                TextField("Barcode eintippen", text: $manualCode).keyboardType(.numberPad)
                Button("Suchen") { Task { await lookup(manualCode) } }
                    .buttonStyle(.borderless).disabled(manualCode.filter(\.isNumber).count < 6 || busy)
            }
            if busy { HStack { ProgressView(); Text("Produkt wird gesucht …").foregroundStyle(.secondary) } }
            if !status.isEmpty { Text(status).font(.footnote).foregroundStyle(.secondary) }
        } header: {
            Text("Barcode scannen")
        } footer: {
            Text("Halte die Kamera auf den Strichcode. Die Nährwerte kommen von Open Food Facts und landen nach der Mengenangabe direkt in deinem Tagesbedarf im Profil. Ist das Produkt nicht auffindbar, wechsle auf „Manuell“.")
        }
    }

    @ViewBuilder private var manualSection: some View {
        Section("Suchen") {
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Produktname, z. B. Magerquark", text: $query)
                if !query.isEmpty { Button { query = "" } label: { Image(systemName: "xmark.circle.fill") }.buttonStyle(.borderless).foregroundStyle(.secondary) }
            }
            if query.isEmpty {
                let recent = Array(store.recents.prefix(6))
                ForEach(recent) { foodRow($0) }
                // Grundnahrungsmittel ohne die schon oben gezeigten (doppelte IDs verwirren die Liste)
                ForEach(FoodDB.basics.filter { b in !recent.contains { $0.id == b.id } }.prefix(8)) { foodRow($0) }
            } else {
                let found = store.search(query)
                ForEach(found) { foodRow($0) }
                if found.isEmpty { Text("Kein Treffer in der eingebauten Liste. Such online weiter oder gib die Werte selbst ein.").foregroundStyle(.secondary) }
            }
        }
        OnlineFoodSearch(query: query) { item in store.remember(item); selected = item }
        Section {
            Button { customCode = nil; showCustom = true } label: {
                Label("Nährwerte je 100 g selbst eingeben", systemImage: "square.and.pencil")
            }
            Button { quickEntry = true } label: {
                Label("Nur Kalorien und Makros der Portion eintragen", systemImage: "bolt")
            }
        } header: {
            Text("Nicht gefunden?")
        } footer: {
            Text("Mit „je 100 g“ wird das Produkt gespeichert und ist beim nächsten Mal per Suche oder Scan sofort da.")
        }
    }

    private func foodRow(_ f: FoodItem) -> some View {
        Button { selected = f } label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(f.brand.isEmpty ? f.name : "\(f.name) · \(f.brand)").foregroundStyle(.primary)
                Text("\(Int(f.kcal.rounded())) kcal · \(Int(f.protein.rounded())) g Eiweiß · \(Int(f.carbs.rounded())) g KH · \(Int(f.fat.rounded())) g Fett (je 100 g)")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
    }

    private func lookup(_ raw: String) async {
        let code = raw.filter(\.isNumber)
        guard !busy else { return }
        if let known = store.saved.first(where: { $0.barcode == code }) { selected = known; return }
        busy = true; status = ""
        let item = await OpenFoodFacts.lookup(code)
        busy = false
        if let item {
            store.remember(item)
            selected = item
        } else {
            status = "Barcode \(code) nicht gefunden (oder keine Internetverbindung). Gib die Nährwerte einmal selbst ein, dann erkennt die App das Produkt künftig sofort."
            customCode = code
            showCustom = true
        }
    }
}

// MARK: Analyse

struct DayStat: Identifiable {
    let date: Date
    let eaten: Macros
    let targets: DayTargets
    let waterML: Int
    let trained: Bool
    var id: Date { date }
    var logged: Bool { eaten.kcal > 0 }
}

struct FoodInsight: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
    let title: String
    let text: String
}

enum NutritionAnalyzer {
    static func stats(days: Int, log: FoodLog, profile: UserProfile, store: TrainingStore, sessions: SessionLog) -> [DayStat] {
        var trained = Set<String>()
        for s in store.sets { trained.insert(FoodLog.key(s.date)) }
        for c in store.cardio { trained.insert(FoodLog.key(c.date)) }
        for e in sessions.entries { trained.insert(FoodLog.key(e.date)) }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return (0..<days).reversed().compactMap { i -> DayStat? in
            guard let d = cal.date(byAdding: .day, value: -i, to: today) else { return nil }
            let type = log.dayType(day: d, fallback: profile.defaultDayType)
            return DayStat(date: d, eaten: log.totals(day: d), targets: profile.targets(for: type),
                           waterML: log.waterML(day: d), trained: trained.contains(FoodLog.key(d)))
        }
    }

    /// Tage, die in die Durchschnitte eingehen: erfasste Tage ohne den (meist unvollständigen) heutigen
    static func usable(_ stats: [DayStat]) -> [DayStat] {
        let past = stats.filter { $0.logged && !Calendar.current.isDateInToday($0.date) }
        return past.isEmpty ? stats.filter(\.logged) : past
    }

    static func avg(_ xs: [Double]) -> Double { xs.isEmpty ? 0 : xs.reduce(0, +) / Double(xs.count) }

    static func insights(stats: [DayStat], profile: UserProfile) -> [FoodInsight] {
        let used = usable(stats)
        let loggedCount = stats.filter(\.logged).count
        var out: [FoodInsight] = []
        guard !used.isEmpty else {
            return [FoodInsight(icon: "fork.knife", color: .secondary, title: "Noch keine Daten",
                                text: "Trage ein paar Tage lang ein, was du isst (Scan, Suche oder Rezept). Dann bekommst du hier Auswertungen und Tipps fürs Training.")]
        }
        if used.count < 3 {
            out.append(FoodInsight(icon: "calendar.badge.plus", color: .orange, title: "Noch wenig Daten",
                                   text: "Bisher \(used.count) Tag(e) erfasst. Ab 3 Tagen werden die Tipps zuverlässiger, ideal sind 5 Tage pro Woche."))
        }
        let avgK = avg(used.map { $0.eaten.kcal }), tK = avg(used.map { Double($0.targets.kcal) })
        let avgP = avg(used.map { $0.eaten.protein }), tP = avg(used.map { Double($0.targets.protein) })
        let avgC = avg(used.map { $0.eaten.carbs }), tC = avg(used.map { Double($0.targets.carbs) })
        let avgSalt = avg(used.map { $0.eaten.salt })
        let kPct = tK > 0 ? avgK / tK : 0, pPct = tP > 0 ? avgP / tP : 0

        // Eiweiß
        if pPct < 0.9 {
            out.append(FoodInsight(icon: "bolt.slash", color: .orange, title: "Eiweiß unter Ziel",
                                   text: "Im Schnitt \(Int(avgP)) g von \(Int(tP)) g (\(Int(pPct * 100)) %). Für Muskelaufbau und Erhalt fehlen dir etwa \(Int(tP - avgP)) g pro Tag. Magerquark, Skyr oder Thunfisch als Zwischenmahlzeit bringen 20–30 g."))
        } else {
            out.append(FoodInsight(icon: "bolt.fill", color: .green, title: "Eiweiß passt",
                                   text: "Im Schnitt \(Int(avgP)) g (\(Int(pPct * 100)) % vom Ziel). Das ist eine gute Basis für Erholung und Muskelerhalt."))
        }
        // Kalorien je nach Ziel
        let diff = Int(avgK - tK)
        switch profile.goal {
        case .fatLoss:
            if kPct > 1.1 {
                out.append(FoodInsight(icon: "flame", color: .orange, title: "Mehr als geplant",
                                       text: "Du isst im Schnitt \(diff) kcal über deinem Diät-Ziel. Das Defizit ist kleiner als geplant, der Fettabbau verläuft langsamer."))
            } else if kPct < 0.8 {
                out.append(FoodInsight(icon: "exclamationmark.triangle", color: .red, title: "Defizit zu groß",
                                       text: "Du liegst \(-diff) kcal unter dem Ziel. Ein zu großes Defizit kostet Leistung und Muskeln. Iss lieber etwas mehr und halte das Training schwer."))
            } else {
                out.append(FoodInsight(icon: "checkmark.seal", color: .green, title: "Kalorien im Zielbereich",
                                       text: "Im Schnitt \(Int(avgK)) von \(Int(tK)) kcal. So bleibt das geplante Defizit stabil."))
            }
        case .muscle:
            if kPct < 0.9 {
                out.append(FoodInsight(icon: "arrow.up.circle", color: .orange, title: "Zu wenig Energie für Aufbau",
                                       text: "Du liegst \(-diff) kcal unter dem Ziel. Für Muskelaufbau braucht der Körper den Überschuss, sonst stockt der Fortschritt."))
            } else if kPct > 1.15 {
                out.append(FoodInsight(icon: "arrow.down.circle", color: .orange, title: "Überschuss recht groß",
                                       text: "\(diff) kcal über dem Ziel. Ein kleinerer Überschuss baut genauso Muskeln auf, aber weniger Fett."))
            } else {
                out.append(FoodInsight(icon: "checkmark.seal", color: .green, title: "Kalorien im Zielbereich",
                                       text: "Im Schnitt \(Int(avgK)) von \(Int(tK)) kcal."))
            }
        case .maintain:
            if abs(kPct - 1) > 0.12 {
                out.append(FoodInsight(icon: "scalemass", color: .orange, title: "Weicht vom Erhaltungsziel ab",
                                       text: "\(diff >= 0 ? "+" : "")\(diff) kcal gegenüber dem Ziel. Auf Dauer verändert das dein Gewicht."))
            } else {
                out.append(FoodInsight(icon: "checkmark.seal", color: .green, title: "Kalorien im Zielbereich",
                                       text: "Im Schnitt \(Int(avgK)) von \(Int(tK)) kcal."))
            }
        }
        // Training vs. Ruhetag
        let tr = used.filter(\.trained), rest = used.filter { !$0.trained }
        if tr.count >= 2 && rest.count >= 2 {
            let kT = avg(tr.map { $0.eaten.kcal }), kR = avg(rest.map { $0.eaten.kcal })
            let cT = avg(tr.map { $0.eaten.carbs }), cR = avg(rest.map { $0.eaten.carbs })
            if kT < kR + 100 || cT < cR + 20 {
                out.append(FoodInsight(icon: "figure.strengthtraining.traditional", color: .orange, title: "Trainingstage kaum anders als Ruhetage",
                                       text: "Trainingstage: \(Int(kT)) kcal und \(Int(cT)) g Kohlenhydrate, Ruhetage: \(Int(kR)) kcal und \(Int(cR)) g. Mehr Kohlenhydrate rund ums Training bringen bessere Leistung und Erholung."))
            } else {
                out.append(FoodInsight(icon: "figure.strengthtraining.traditional", color: .green, title: "Essen folgt dem Training",
                                       text: "An Trainingstagen isst du \(Int(kT - kR)) kcal und \(Int(cT - cR)) g Kohlenhydrate mehr als an Ruhetagen. Genau so ist es sinnvoll."))
            }
        } else if avgC < tC * 0.7 {
            out.append(FoodInsight(icon: "leaf", color: .orange, title: "Wenig Kohlenhydrate",
                                   text: "Im Schnitt \(Int(avgC)) g statt \(Int(tC)) g. Das ist bei harten Einheiten oft zu wenig. Ausnahme: du isst bewusst Low Carb oder Keto."))
        }
        if avgSalt > 7 {
            out.append(FoodInsight(icon: "drop.triangle", color: .orange, title: "Viel Salz",
                                   text: "Im Schnitt \(String(format: "%.1f", avgSalt)) g pro Tag, empfohlen sind bis 6 g. Fertigprodukte und Aufschnitt sind die häufigsten Quellen."))
        }
        // Empfehlung fürs Training
        let good = pPct >= 0.9 && kPct >= 0.85 && (profile.goal != .fatLoss || kPct <= 1.1)
        let training: String
        if used.count < 3 {
            training = "Noch zu wenig Daten für eine Trainingsempfehlung."
        } else if good {
            training = "Die Ernährung trägt das Training. Du kannst die Belastung steigern: mehr Gewicht oder eine Wiederholung mehr pro Satz in den Grundübungen."
        } else if pPct < 0.9 && kPct < 0.85 {
            training = "Eiweiß und Energie sind zu niedrig. Halte das Trainingsvolumen vorerst konstant und steigere es erst, wenn die Ernährung passt, sonst steigt das Verletzungs- und Erschöpfungsrisiko."
        } else if pPct < 0.9 {
            training = "Die Kalorien stimmen, aber das Eiweiß fehlt. Trainiere wie geplant und schließe zuerst die Eiweißlücke, damit die Muskeln den Reiz auch nutzen können."
        } else {
            training = "Das Eiweiß passt, die Energie weicht vom Ziel ab. Gleiche zuerst die Kalorien an, danach bringt zusätzliches Training mehr."
        }
        out.append(FoodInsight(icon: "dumbbell", color: .accentColor, title: "Empfehlung fürs Training", text: training))
        if loggedCount >= 5 && loggedCount < stats.count / 2 {
            out.append(FoodInsight(icon: "calendar", color: .secondary, title: "Lücken im Tagebuch",
                                   text: "Du hast \(loggedCount) von \(stats.count) Tagen erfasst. Je lückenloser, desto besser die Analyse."))
        }
        return out
    }
}

struct FoodHistoryView: View {
    @EnvironmentObject var log: FoodLog
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var trainingStore: TrainingStore
    @EnvironmentObject var sessionLog: SessionLog
    @State private var range = 14

    private var stats: [DayStat] {
        NutritionAnalyzer.stats(days: range, log: log, profile: profile, store: trainingStore, sessions: sessionLog)
    }

    var body: some View {
        let s = stats
        let used = NutritionAnalyzer.usable(s)
        List {
            Section {
                Picker("Zeitraum", selection: $range) {
                    Text("7 Tage").tag(7)
                    Text("14 Tage").tag(14)
                    Text("30 Tage").tag(30)
                }
                .pickerStyle(.segmented)
                if !used.isEmpty {
                    summary(used)
                    chart(s, title: "Kalorien", value: { $0.eaten.kcal }, target: { Double($0.targets.kcal) }, unit: "kcal")
                    chart(s, title: "Eiweiß", value: { $0.eaten.protein }, target: { Double($0.targets.protein) }, unit: "g")
                }
            } header: {
                Text("Auswertung")
            } footer: {
                Text("Grün = innerhalb von ±10 % deines Ziels. Der heutige Tag zählt erst, wenn er vorbei ist, in die Durchschnitte ein.")
            }

            Section("Analyse und Tipps") {
                ForEach(NutritionAnalyzer.insights(stats: s, profile: profile)) { i in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: i.icon).foregroundStyle(i.color).frame(width: 26)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(i.title).font(.subheadline.bold())
                            Text(i.text).font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }

            ForEach(s.reversed().filter(\.logged)) { d in
                Section {
                    ForEach(log.entries.filter { $0.day == FoodLog.key(d.date) }.reversed()) { e in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(e.name).lineLimit(2)
                                Text("\(e.slot.rawValue) · \(Int(e.protein.rounded())) g Eiweiß · \(Int(e.carbs.rounded())) g KH · \(Int(e.fat.rounded())) g Fett")
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(Int(e.kcal.rounded())) kcal").foregroundStyle(.secondary).monospacedDigit()
                        }
                        .swipeActions { Button(role: .destructive) { log.remove(e.id) } label: { Label("Löschen", systemImage: "trash") } }
                    }
                } header: {
                    HStack {
                        Text(d.date, format: .dateTime.weekday(.abbreviated).day().month())
                        if d.trained { Image(systemName: "dumbbell.fill").font(.caption) }
                        Spacer()
                        Text("\(Int(d.eaten.kcal)) / \(d.targets.kcal) kcal")
                    }
                }
            }
        }
        .navigationTitle("Verlauf und Analyse")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func summary(_ used: [DayStat]) -> some View {
        let n = NutritionAnalyzer.self
        return VStack(alignment: .leading, spacing: 6) {
            Text("Durchschnitt pro Tag (\(used.count) erfasste Tage)").font(.footnote).foregroundStyle(.secondary)
            HStack {
                stat("Kalorien", "\(Int(n.avg(used.map { $0.eaten.kcal })))", "kcal")
                stat("Eiweiß", "\(Int(n.avg(used.map { $0.eaten.protein })))", "g")
                stat("Kohlenh.", "\(Int(n.avg(used.map { $0.eaten.carbs })))", "g")
                stat("Fett", "\(Int(n.avg(used.map { $0.eaten.fat })))", "g")
            }
        }
    }

    private func stat(_ title: String, _ value: String, _ unit: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.title3.bold()).monospacedDigit()
            Text("\(title) (\(unit))").font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func chart(_ s: [DayStat], title: String, value: @escaping (DayStat) -> Double,
                       target: @escaping (DayStat) -> Double, unit: String) -> some View {
        let logged = s.filter(\.logged)
        let avgTarget = NutritionAnalyzer.avg(s.map(target))
        return VStack(alignment: .leading, spacing: 4) {
            Text("\(title) pro Tag (\(unit))").font(.footnote.bold())
            Chart {
                ForEach(logged) { d in
                    let ratio = target(d) > 0 ? value(d) / target(d) : 0
                    BarMark(x: .value("Tag", d.date, unit: .day), y: .value(title, value(d)))
                        .foregroundStyle(abs(ratio - 1) <= 0.1 ? Color.green : Color.orange)
                }
                RuleMark(y: .value("Ziel", avgTarget))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundStyle(.secondary)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: range > 14 ? 5 : (range > 7 ? 2 : 1))) { _ in
                    AxisValueLabel(format: range > 7 ? .dateTime.day() : .dateTime.weekday(.narrow))
                }
            }
            .frame(height: 120)
        }
        .padding(.vertical, 4)
    }
}
