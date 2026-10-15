import Combine
import SwiftUI
import Charts
import UserNotifications

/// Ein gespeichertes Scan-Ergebnis (Messwerte zum Zeitpunkt des Scans).
struct ScanRecord: Codable, Identifiable, Equatable {
    var id = UUID()
    var date: Date
    var weightKg: Double
    var waistCm: Double
    var neckCm: Double
    var bodyFat: Double?
}

/// Scan-Intervall (Standard: alle 4 Wochen), Erinnerung und Verlauf der Ergebnisse.
final class ScanSchedule: ObservableObject {
    @Published var intervalWeeks: Int {
        didSet { UserDefaults.standard.set(intervalWeeks, forKey: "scanIntervalWeeks"); reschedule() }
    }
    @Published var remindersOn: Bool {
        didSet {
            UserDefaults.standard.set(remindersOn, forKey: "scanRemindersOn")
            if remindersOn {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
            }
            reschedule()
        }
    }
    @Published private(set) var records: [ScanRecord] = []

    private let key = "scanRecordsV1"
    private let noteID = "fitscan.scan.due"

    init() {
        let d = UserDefaults.standard
        let w = d.integer(forKey: "scanIntervalWeeks")
        intervalWeeks = w == 0 ? 4 : w
        remindersOn = d.object(forKey: "scanRemindersOn") as? Bool ?? true
        if let data = d.data(forKey: key), let r = try? JSONDecoder().decode([ScanRecord].self, from: data) {
            records = r.sorted { $0.date < $1.date }
        }
        reschedule()
    }

    var latest: ScanRecord? { records.last }
    var previous: ScanRecord? { records.count >= 2 ? records[records.count - 2] : nil }

    /// Nächster fälliger Scan; nil, solange noch gar kein Scan gespeichert ist.
    var nextDue: Date? {
        guard let last = latest else { return nil }
        return Calendar.current.date(byAdding: .day, value: intervalWeeks * 7, to: last.date)
    }

    /// Tage bis zum nächsten Scan (negativ = überfällig); nil ohne bisherigen Scan.
    var daysUntilDue: Int? {
        guard let due = nextDue else { return nil }
        let cal = Calendar.current
        return cal.dateComponents([.day], from: cal.startOfDay(for: Date()), to: cal.startOfDay(for: due)).day
    }

    var isDue: Bool { (daysUntilDue ?? 0) <= 0 }

    var statusText: String {
        guard let d = daysUntilDue, let due = nextDue else { return "Noch kein Scan gespeichert – jetzt den ersten durchführen." }
        let date = due.formatted(date: .abbreviated, time: .omitted)
        if d < 0 { return "Überfällig seit \(-d) Tag\(-d == 1 ? "" : "en") (fällig war \(date))" }
        if d == 0 { return "Heute ist Scan-Tag!" }
        return "Nächster Scan am \(date) – in \(d) Tag\(d == 1 ? "" : "en")"
    }

    func save(profile: UserProfile) {
        let rec = ScanRecord(date: Date(), weightKg: profile.weightKg, waistCm: profile.waistCm,
                             neckCm: profile.neckCm, bodyFat: profile.bodyFatEstimate)
        records.append(rec)
        persist()
        reschedule()
    }

    func delete(_ rec: ScanRecord) {
        records.removeAll { $0.id == rec.id }
        persist()
        reschedule()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(records) { UserDefaults.standard.set(data, forKey: key) }
    }

    /// Plant die Erinnerung für den nächsten Scan-Tag um 9 Uhr.
    func reschedule() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [noteID])
        guard remindersOn, let due = nextDue else { return }
        // Erinnerung ist standardmäßig an: Erlaubnis einholen, sobald es den ersten Termin gibt (fragt nur einmal)
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: due)
        comps.hour = 9
        guard let fire = Calendar.current.date(from: comps), fire > Date() else { return }
        let content = UNMutableNotificationContent()
        content.title = "Zeit für deinen Körperscan"
        content.body = "Der nächste Scan ist fällig – so siehst du deinen Fortschritt."
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        center.add(UNNotificationRequest(identifier: noteID, content: content, trigger: trigger))
    }
}

// MARK: - Ansicht

struct ScanCheckInView: View {
    @EnvironmentObject var schedule: ScanSchedule
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var rank: RankStore
    @EnvironmentObject var premium: PremiumStore
    @State private var saved = false
    @State private var showPaywall = false

    var body: some View {
        Form {
            Section {
                Label(schedule.statusText,
                      systemImage: schedule.isDue ? "exclamationmark.circle.fill" : "calendar")
                    .foregroundStyle(schedule.isDue ? Color.orange : Color.primary)
            } header: {
                Text("Status")
            }

            Section {
                Stepper(value: $schedule.intervalWeeks, in: 1...12) {
                    Text("Alle \(schedule.intervalWeeks) Woche\(schedule.intervalWeeks == 1 ? "" : "n")")
                }
                Toggle("Erinnerung am Scan-Tag", isOn: $schedule.remindersOn)
            } header: {
                Text("Intervall")
            } footer: {
                Text("Standard sind 4 Wochen: lang genug, dass sich Körperfett und Umfänge messbar ändern, kurz genug, um das Training rechtzeitig anzupassen.")
            }

            Section {
                NavigationLink { BodyScanView() } label: { Label("1. Körper scannen (3D)", systemImage: "figure.stand") }
                NavigationLink { ScanView() } label: { Label("2. Maße eintragen (Taille, Hals, Gewicht)", systemImage: "ruler") }
                LabeledContent("Gewicht", value: String(format: "%.1f kg", profile.weightKg))
                LabeledContent("Taille / Hals", value: String(format: "%.0f / %.0f cm", profile.waistCm, profile.neckCm))
                LabeledContent("Körperfett (Schätzung)", value: profile.bodyFatEstimate.map { String(format: "%.1f %%", $0) } ?? "–")
                Button {
                    if !schedule.records.isEmpty && !premium.has(.secondScan) { showPaywall = true; return }
                    schedule.save(profile: profile); rank.scanDone()
                    saved = true
                } label: { Label("3. Ergebnis ermitteln und speichern", systemImage: "checkmark.circle.fill") }
            } header: {
                Text("Scan durchführen")
            } footer: {
                Text(saved ? "Gespeichert. Der nächste Scan-Termin wurde neu berechnet." :
                     "Immer unter gleichen Bedingungen messen: morgens, nüchtern, gleiche Haltung.")
            }

            if let last = schedule.latest {
                Section("Letztes Ergebnis") {
                    resultRow("Gewicht", last.weightKg, schedule.previous?.weightKg, unit: "kg", lowerIsBetter: profile.goal == .fatLoss)
                    resultRow("Taille", last.waistCm, schedule.previous?.waistCm, unit: "cm", lowerIsBetter: true)
                    if let bf = last.bodyFat {
                        resultRow("Körperfett", bf, schedule.previous?.bodyFat, unit: "%", lowerIsBetter: true)
                    }
                    Text(verdict(last)).font(.footnote).foregroundStyle(.secondary)
                }
            }

            let withBF = schedule.records.filter { $0.bodyFat != nil }
            if withBF.count >= 2 {
                Section("Körperfett-Verlauf") {
                    Chart {
                        ForEach(withBF) { r in
                            LineMark(x: .value("Datum", r.date), y: .value("Körperfett", r.bodyFat ?? 0))
                            PointMark(x: .value("Datum", r.date), y: .value("Körperfett", r.bodyFat ?? 0))
                        }
                        RuleMark(y: .value("Ziel", profile.targetBodyFat))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                            .foregroundStyle(.green)
                    }
                    .chartYScale(domain: .automatic(includesZero: false))
                    .frame(height: 160)
                }
            }

            if !schedule.records.isEmpty {
                Section("Verlauf") {
                    ForEach(schedule.records.reversed()) { r in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(r.date.formatted(date: .abbreviated, time: .omitted)).font(.subheadline.bold())
                            Text(String(format: "%.1f kg · Taille %.0f cm · ", r.weightKg, r.waistCm)
                                 + (r.bodyFat.map { String(format: "%.1f %% KFA", $0) } ?? "KFA –"))
                                .font(.footnote).foregroundStyle(.secondary)
                        }
                        .swipeActions { Button("Löschen", role: .destructive) { schedule.delete(r) } }
                    }
                }
            }
        }
        .navigationTitle("Scan-Intervall")
        .sheet(isPresented: $showPaywall) { NavigationStack { PaywallView() } }
    }

    private func resultRow(_ title: String, _ now: Double, _ before: Double?, unit: String, lowerIsBetter: Bool) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(String(format: "%.1f %@", now, unit)).monospacedDigit()
            if let b = before {
                let d = now - b
                Text(String(format: "%+.1f", d))
                    .font(.footnote.monospacedDigit())
                    .foregroundStyle(abs(d) < 0.05 ? Color.secondary : ((d < 0) == lowerIsBetter ? Color.green : Color.orange))
            }
        }
    }

    private func verdict(_ last: ScanRecord) -> String {
        guard let prev = schedule.previous, let b = last.bodyFat, let pb = prev.bodyFat else {
            return "Nach dem nächsten Scan siehst du hier die Veränderung zum Vorgänger."
        }
        let dBF = b - pb
        let dW = last.weightKg - prev.weightKg
        switch profile.goal {
        case .fatLoss:
            return dBF < -0.2 ? "Gut: Körperfett sinkt (\(String(format: "%+.1f", dBF)) %-Punkte). Plan beibehalten."
                : "Körperfett stagniert oder steigt. Kalorien und Schritte prüfen, ggf. Tempo erhöhen."
        case .muscle:
            return dW > 0 && dBF <= 0.5 ? "Gut: Gewicht steigt ohne nennenswert mehr Fett – das spricht für Muskelaufbau."
                : (dBF > 0.5 ? "Fettanteil steigt schneller als gewünscht. Überschuss etwas senken." : "Kein Zuwachs sichtbar. Kalorien und Protein prüfen.")
        default:
            return abs(dBF) < 0.7 ? "Stabil – passend zum Ziel." : "Veränderung \(String(format: "%+.1f", dBF)) %-Punkte. Ernährung und Training angleichen."
        }
    }
}
