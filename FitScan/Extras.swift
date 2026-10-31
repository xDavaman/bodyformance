import MapKit
import SwiftUI
import UniformTypeIdentifiers

// MARK: - Wochen- und Monatsberichte

struct ReportsView: View {
    @EnvironmentObject var premium: PremiumStore
    @EnvironmentObject var store: TrainingStore
    @EnvironmentObject var sessions: SessionLog
    @EnvironmentObject var log: FoodLog
    @EnvironmentObject var profile: UserProfile
    @State private var monthly = false

    private struct Stats {
        var workouts = 0, minutes = 0, sets = 0, volumeKg = 0.0, km = 0.0, kcalPerDay = 0.0, proteinPerDay = 0.0, loggedDays = 0
    }

    private func stats(from: Date, to: Date) -> Stats {
        var s = Stats()
        let e = sessions.entries.filter { $0.date >= from && $0.date < to }
        s.workouts = e.count
        s.minutes = e.reduce(0) { $0 + $1.seconds } / 60
        s.km = e.reduce(0) { $0 + $1.distanceM } / 1000
        let sets = store.sets.filter { $0.date >= from && $0.date < to }
        s.sets = sets.count
        s.volumeKg = sets.reduce(0) { $0 + $1.weightKg * Double($1.reps) }
        let cal = Calendar.current
        var d = cal.startOfDay(for: from)
        var kcal = 0.0, prot = 0.0
        while d < to {
            let t = log.totals(day: d)
            if t.kcal > 0 { s.loggedDays += 1; kcal += t.kcal; prot += t.protein }
            d = cal.date(byAdding: .day, value: 1, to: d) ?? to
        }
        if s.loggedDays > 0 { s.kcalPerDay = kcal / Double(s.loggedDays); s.proteinPerDay = prot / Double(s.loggedDays) }
        return s
    }

    var body: some View {
        let days = monthly ? 30 : 7
        let now = Date()
        let cur = stats(from: now.addingTimeInterval(-Double(days) * 86_400), to: now.addingTimeInterval(1))
        let prev = stats(from: now.addingTimeInterval(-Double(2 * days) * 86_400), to: now.addingTimeInterval(-Double(days) * 86_400))
        List {
            Section {
                Picker("Zeitraum", selection: $monthly) { Text("Woche").tag(false); Text("Monat").tag(true) }
                    .pickerStyle(.segmented)
            } footer: { Text("Die letzten \(days) Tage im Vergleich zu den \(days) Tagen davor.") }
            if premium.has(.reports) {
                Section("Training") {
                    row("Einheiten", Double(cur.workouts), Double(prev.workouts), "")
                    row("Zeit", Double(cur.minutes), Double(prev.minutes), " min")
                    row("Kraftsätze", Double(cur.sets), Double(prev.sets), "")
                    row("Volumen", cur.volumeKg, prev.volumeKg, " kg")
                    row("Strecke", cur.km, prev.km, " km", decimals: 1)
                }
                Section("Ernährung (Tage mit Einträgen: \(cur.loggedDays))") {
                    row("Kalorien pro Tag", cur.kcalPerDay, prev.kcalPerDay, " kcal")
                    row("Eiweiß pro Tag", cur.proteinPerDay, prev.proteinPerDay, " g")
                    Text("Ziel: \(profile.targets(for: profile.defaultDayType).kcal) kcal und \(profile.targets(for: profile.defaultDayType).protein) g Eiweiß").font(.footnote).foregroundStyle(.secondary)
                }
            } else {
                Section { LockedRow(feature: .reports) }
            }
        }
        .safeAreaInset(edge: .bottom) {
            NavigationLink { MonthlyReportView() } label: {
                Label("Ausführlicher Monatsbericht mit Excel und PDF", systemImage: "square.and.arrow.up.on.square")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Berichte")
    }

    private func row(_ title: String, _ now: Double, _ before: Double, _ unit: String, decimals: Int = 0) -> some View {
        let fmt = "%.\(decimals)f"
        let d = now - before
        return HStack {
            Text(title)
            Spacer()
            Text(String(format: fmt, now) + unit).monospacedDigit()
            Text(before == 0 && now == 0 ? "" : String(format: "%+." + "\(decimals)f", d))
                .font(.footnote.monospacedDigit()).foregroundStyle(abs(d) < 0.05 ? Color.secondary : (d > 0 ? Color.green : Color.orange))
        }
    }
}

// MARK: - Plan als PDF

struct PlanPage: View {
    let days: [TrainingDay]
    let targets: DayTargets
    let name: String
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Mein Plan – Bodyformance (BFC)").font(.system(size: 24, weight: .bold))
            if !name.isEmpty { Text(name).font(.system(size: 14)).foregroundColor(.gray) }
            Text("Tagesziele: \(targets.kcal) kcal · \(targets.protein) g Eiweiß · \(targets.carbs) g Kohlenhydrate · \(targets.fat) g Fett")
                .font(.system(size: 13))
            ForEach(days) { d in
                VStack(alignment: .leading, spacing: 4) {
                    Text(d.name).font(.system(size: 17, weight: .semibold))
                    if !d.subtitle.isEmpty { Text(d.subtitle).font(.system(size: 12)).foregroundColor(.gray) }
                    ForEach(d.items) { it in
                        Text("• \(it.exercise.name)\(it.isFocus ? "  (Schwerpunkt)" : "")").font(.system(size: 13))
                    }
                }
            }
            Text("Allgemeine Informationen, keine medizinische Beratung.").font(.system(size: 10)).foregroundColor(.gray)
        }
        .padding(36)
        .frame(width: 595, alignment: .leading)
        .background(Color.white)
        .foregroundColor(.black)
        .environment(\.colorScheme, .light)
    }
}

struct PlanExportView: View {
    @EnvironmentObject var premium: PremiumStore
    @EnvironmentObject var profile: UserProfile
    @AppStorage("profileName") private var name = ""
    @State private var url: URL?

    var body: some View {
        List {
            if premium.has(.planExport) {
                Section {
                    if let url {
                        ShareLink(item: url) { Label("PDF teilen oder speichern", systemImage: "square.and.arrow.up") }
                    } else {
                        Button { url = makePDF() } label: { Label("PDF erstellen", systemImage: "doc.richtext") }
                    }
                } footer: { Text("Enthält deinen aktuellen Trainingsplan und deine Tagesziele. Das PDF entsteht auf deinem iPhone.") }
            } else {
                Section { LockedRow(feature: .planExport) }
            }
        }
        .navigationTitle("Plan als PDF")
    }

    @MainActor private func makePDF() -> URL? {
        let page = PlanPage(days: PlanBuilder.plan(profile: profile),
                            targets: profile.targets(for: profile.defaultDayType), name: name)
            .fixedSize(horizontal: false, vertical: true)
        let r = ImageRenderer(content: page)
        let out = FileManager.default.temporaryDirectory.appendingPathComponent("BFC-Plan.pdf")
        var ok = false
        r.render { size, draw in
            var box = CGRect(origin: .zero, size: size)
            guard let ctx = CGContext(out as CFURL, mediaBox: &box, nil) else { return }
            ctx.beginPDFPage(nil); draw(ctx); ctx.endPDFPage(); ctx.closePDF(); ok = true
        }
        return ok ? out : nil
    }
}

// MARK: - Lauf-Detail mit Karte

struct RunDetailView: View {
    @EnvironmentObject var premium: PremiumStore
    @EnvironmentObject var sessions: SessionLog
    let entry: SessionEntry

    private var paceText: String {
        guard entry.distanceM > 100 else { return "–" }
        let secPerKm = Double(entry.seconds) / (entry.distanceM / 1000)
        return String(format: "%d:%02d min/km", Int(secPerKm) / 60, Int(secPerKm) % 60)
    }

    private var sameKind: [SessionEntry] { sessions.entries.filter { $0.kind == entry.kind && $0.distanceM >= 1000 } }

    var body: some View {
        List {
            if let r = entry.route, r.count > 2 {
                Section {
                    if premium.has(.runHistoryMaps) {
                        Map {
                            MapPolyline(coordinates: r.map(\.coordinate)).stroke(.red, lineWidth: 5)
                            if let a = r.first { Marker("Start", coordinate: a.coordinate).tint(.green) }
                            if let b = r.last { Marker("Ziel", coordinate: b.coordinate).tint(.red) }
                        }
                        .frame(height: 280).clipShape(RoundedRectangle(cornerRadius: 14))
                        .listRowInsets(EdgeInsets())
                    } else {
                        RouteShape(points: r).stroke(Color.red, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)).frame(height: 120)
                        LockedRow(feature: .runHistoryMaps)
                    }
                }
            }
            Section("Daten") {
                LabeledContent("Art", value: entry.kind.label)
                LabeledContent("Datum", value: entry.date.formatted(date: .abbreviated, time: .shortened))
                LabeledContent("Dauer", value: WorkoutSession.clock(entry.seconds))
                LabeledContent("Strecke", value: String(format: "%.2f km", entry.distanceM / 1000))
                LabeledContent("Pace", value: paceText)
                LabeledContent("Schritte", value: "\(entry.steps)")
                LabeledContent("Kalorien", value: "\(entry.kcal) kcal")
                if let s = entry.source { LabeledContent("Quelle", value: s) }
            }
            if premium.has(.runHistoryMaps), sameKind.count >= 2 {
                Section("Bestwerte (\(entry.kind.label))") {
                    if let longest = sameKind.max(by: { $0.distanceM < $1.distanceM }) {
                        LabeledContent("Längste Strecke", value: String(format: "%.2f km", longest.distanceM / 1000))
                    }
                    if let fastest = sameKind.min(by: { Double($0.seconds) / $0.distanceM < Double($1.seconds) / $1.distanceM }) {
                        let spk = Double(fastest.seconds) / (fastest.distanceM / 1000)
                        LabeledContent("Schnellste Pace", value: String(format: "%d:%02d min/km", Int(spk) / 60, Int(spk) % 60))
                    }
                }
            }
        }
        .navigationTitle(entry.kind.label)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Share-Designs

enum ShareTheme: String, CaseIterable, Identifiable {
    case classic = "Klassik", midnight = "Mitternacht", forest = "Wald", gold = "Gold", mono = "Mono"
    var id: String { rawValue }
    var colors: [Color] {
        switch self {
        case .classic: return [Color(red: 0.07, green: 0.07, blue: 0.08), Color(red: 0.22, green: 0.05, blue: 0.05)]
        case .midnight: return [Color(red: 0.03, green: 0.05, blue: 0.12), Color(red: 0.08, green: 0.16, blue: 0.38)]
        case .forest: return [Color(red: 0.03, green: 0.09, blue: 0.06), Color(red: 0.07, green: 0.28, blue: 0.16)]
        case .gold: return [Color(red: 0.06, green: 0.05, blue: 0.03), Color(red: 0.34, green: 0.24, blue: 0.04)]
        case .mono: return [Color.black, Color(red: 0.2, green: 0.2, blue: 0.22)]
        }
    }
}

// MARK: - Backup und Gerätewechsel

struct BackupView: View {
    @EnvironmentObject var premium: PremiumStore
    @State private var url: URL?
    @State private var importing = false
    @State private var message: String?

    var body: some View {
        List {
            Section {
                if premium.has(.cloudBackup) {
                    if let url {
                        ShareLink(item: url) { Label("Backup sichern (iCloud Drive, Dateien, AirDrop)", systemImage: "square.and.arrow.up") }
                    } else {
                        Button { url = Self.makeBackup() } label: { Label("Backup erstellen", systemImage: "externaldrive.badge.plus") }
                    }
                } else {
                    LockedRow(feature: .cloudBackup)
                }
            } header: { Text("Sichern") } footer: {
                Text("Enthält Profil, Training, Essen, Rang und Einstellungen. Profilbild und 3D-Scans sind nicht enthalten. Speichere die Datei in iCloud Drive, dann hast du sie auf jedem Gerät.")
            }
            Section {
                Button { importing = true } label: { Label("Backup wiederherstellen", systemImage: "arrow.down.doc") }
                if let message { Text(message).font(.footnote).foregroundStyle(.secondary) }
            } header: { Text("Wiederherstellen") } footer: {
                Text("Das Wiederherstellen ist immer kostenlos. Es überschreibt gleiche Daten auf diesem iPhone. Danach die App schließen und neu öffnen.")
            }
        }
        .navigationTitle("Backup")
        .fileImporter(isPresented: $importing, allowedContentTypes: [.data]) { result in
            guard case .success(let u) = result else { return }
            let access = u.startAccessingSecurityScopedResource()
            defer { if access { u.stopAccessingSecurityScopedResource() } }
            message = Self.restore(from: u) ? "Wiederhergestellt. Bitte die App schließen und neu öffnen." : "Die Datei ist kein gültiges BFC-Backup."
        }
    }

    private static let skipPrefixes = ["Apple", "NS", "com.apple", "AK", "bfc.trial", "bfc.premium"]

    /// Dateien in Documents, die mit ins Backup gehören (Training: Sätze, Cardio, Mobility, Körpergewicht)
    private static let backupFiles = ["fitscan-data.json", SupplementStore.fileName]

    static func makeBackup() -> URL? {
        var dict: [String: Any] = ["bfc.backup.version": 1]
        for (k, v) in UserDefaults.standard.dictionaryRepresentation() where !skipPrefixes.contains(where: { k.hasPrefix($0) }) {
            dict[k] = v
        }
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for name in backupFiles {
            if let d = try? Data(contentsOf: docs.appendingPathComponent(name)) { dict["file." + name] = d }
        }
        guard let data = try? PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options: 0) else { return nil }
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        let out = FileManager.default.temporaryDirectory.appendingPathComponent("BFC-Backup-\(f.string(from: Date())).bfcbackup")
        try? data.write(to: out)
        return out
    }

    static func restore(from url: URL) -> Bool {
        guard let data = try? Data(contentsOf: url),
              let obj = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              obj["bfc.backup.version"] != nil else { return false }
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for (k, v) in obj where k != "bfc.backup.version" && !skipPrefixes.contains(where: { k.hasPrefix($0) }) {
            if k.hasPrefix("file.") {
                let name = String(k.dropFirst(5))
                if backupFiles.contains(name), let d = v as? Data { try? d.write(to: docs.appendingPathComponent(name), options: .atomic) }
                continue
            }
            UserDefaults.standard.set(v, forKey: k)
        }
        return true
    }
}
