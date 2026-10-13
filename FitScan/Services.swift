import Combine
import StoreKit
import SwiftUI

// MARK: - Analyse (anonym, nur mit Einwilligung)

/// Erlaubte Ereignisse. Absichtlich ohne Parameter mit Personen- oder Gesundheitsbezug.
enum AnalyticsEvent: String {
    case appOpen = "app_open"
    case workoutStarted = "workout_started"
    case workoutFinished = "workout_finished"
    case scanCompleted = "scan_completed"
    case shareOpened = "share_opened"
    case dietCoachOpened = "diet_coach_opened"
    case paywallOpened = "paywall_opened"
    case purchaseSucceeded = "purchase_succeeded"
}

protocol AnalyticsProvider {
    func log(_ name: String, _ params: [String: String])
}

/// Stufe 1 (jetzt): Apple App Analytics läuft im App Store ohne Code. Hier wird nichts gesendet.
struct AppleOnlyProvider: AnalyticsProvider {
    func log(_ name: String, _ params: [String: String]) {}
}

/*
 Stufe 2 (später, Firebase, Region Frankfurt = europe-west3):
 1. Firebase-Projekt in der EU anlegen, GoogleService-Info.plist ins Projekt, Swift-Package "firebase-ios-sdk" (FirebaseAnalytics).
 2. In FitScanApp: FirebaseApp.configure() erst NACH Einwilligung; Analytics.setAnalyticsCollectionEnabled(false) als Standard.
 3. Diese Struktur aktivieren:
    import FirebaseAnalytics
    struct FirebaseProvider: AnalyticsProvider {
        func log(_ name: String, _ params: [String: String]) { FirebaseAnalytics.Analytics.logEvent(name, parameters: params) }
    }
 4. Analytics.provider = FirebaseProvider()
 5. Datenschutzerklärung Abschnitt 15 (Stufe 2) und PrivacyInfo.xcprivacy anpassen, App-Store-Datenschutzangaben aktualisieren.
*/
enum Analytics {
    static let consentKey = "bfc.consent.analytics"
    static var provider: AnalyticsProvider = AppleOnlyProvider()
    static var enabled: Bool { UserDefaults.standard.bool(forKey: consentKey) }

    static func track(_ event: AnalyticsEvent, _ params: [String: String] = [:]) {
        guard enabled else { return }
        provider.log(event.rawValue, params)
    }
}

// MARK: - Premium

enum PremiumFeature: String, CaseIterable, Identifiable {
    case secondScan, fullMacros, bodyModelEvolution, fullAnalyses, noAds
    case reports, planExport, runHistoryMaps, shareDesigns, cloudBackup, multiProfile
    var id: String { rawValue }

    var title: String {
        switch self {
        case .secondScan: return "Zweiter und weitere Scans"
        case .fullMacros: return "Vollständige Makros und Mikros"
        case .bodyModelEvolution: return "Entwicklung deines 3D-Modells"
        case .fullAnalyses: return "Vollständige Analysen"
        case .noAds: return "Keine Werbung"
        case .reports: return "Wochen- und Monatsberichte"
        case .planExport: return "Pläne als PDF exportieren"
        case .runHistoryMaps: return "Karten und Statistik für Läufe"
        case .shareDesigns: return "Zusätzliche Share-Designs"
        case .cloudBackup: return "Cloud-Backup und Gerätewechsel"
        case .multiProfile: return "Mehrere Profile"
        }
    }

    var detail: String {
        switch self {
        case .secondScan: return "Fortschritts-Scans vergleichen. Im Gratis-Modus ist ein Scan enthalten."
        case .fullMacros: return "Alle Nährstoffe, Wochenverlauf und Zielabgleich. Gratis: Kalorien und Eiweiß."
        case .bodyModelEvolution: return "Dein Modell verändert sich mit deinem Körper und der Rang-Entwicklung."
        case .fullAnalyses: return "Trends, Körperfett-Verlauf, Muskelgruppen und Prognosen."
        case .noAds: return "Entfernt jede Werbung."
        case .reports: return "Zusammenfassung mit Vergleich zur Vorwoche."
        case .planExport: return "Trainings- und Ernährungsplan zum Drucken oder Teilen."
        case .runHistoryMaps: return "Echte Karte, Pace-Verlauf und Bestzeiten."
        case .shareDesigns: return "Weitere Vorlagen für Tages-, Lauf- und Rangkarten."
        case .cloudBackup: return "Verschlüsselte Sicherung (später, mit Firebase in Frankfurt)."
        case .multiProfile: return "Profile für Partner oder Familie."
        }
    }

    /// Ab wann es das Feature gibt (nur Anzeige).
    var planned: Bool {
        switch self {
        case .secondScan, .fullMacros, .bodyModelEvolution, .fullAnalyses, .noAds: return false
        default: return true
        }
    }
}

enum PremiumConfig {
    /// SCHALTER: false = alle Funktionen frei (jetzt). true = Premium-Funktionen sind gesperrt.
    static let enforceGating = false
    /// Produkt-IDs, so in App Store Connect anlegen (Abo-Gruppe „BFC Premium“).
    static let productIDs = ["bfc.premium.monthly", "bfc.premium.yearly", "bfc.premium.lifetime"]
}

@MainActor
final class PremiumStore: ObservableObject {
    @Published private(set) var isPremium: Bool
    @Published private(set) var products: [Product] = []
    @Published var message: String?
    @AppStorage("bfc.premium.debugUnlock") var debugUnlock = false { didSet { objectWillChange.send() } }
    private let cacheKey = "bfc.premium.cached"
    private var updates: Task<Void, Never>?

    init() {
        isPremium = UserDefaults.standard.bool(forKey: cacheKey)
        updates = Task { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let t) = result { await t.finish() }
                await self?.refresh()
            }
        }
        Task { await load(); await refresh() }
    }

    deinit { updates?.cancel() }

    /// Zentrale Abfrage für alle Funktionen.
    func has(_ feature: PremiumFeature) -> Bool {
        if !PremiumConfig.enforceGating { return true }
        #if DEBUG
        if debugUnlock { return true }
        #endif
        return isPremium
    }

    func load() async {
        do {
            products = try await Product.products(for: PremiumConfig.productIDs).sorted { $0.price < $1.price }
        } catch { products = [] }
    }

    func refresh() async {
        var active = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let t) = result, PremiumConfig.productIDs.contains(t.productID), t.revocationDate == nil { active = true }
        }
        isPremium = active
        UserDefaults.standard.set(active, forKey: cacheKey)
    }

    func buy(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let v):
                if case .verified(let t) = v { await t.finish(); Analytics.track(.purchaseSucceeded) }
                await refresh()
            case .pending: message = "Der Kauf wartet auf Freigabe."
            default: break
            }
        } catch { message = "Kauf fehlgeschlagen: \(error.localizedDescription)" }
    }

    func restore() async {
        do { try await AppStore.sync(); await refresh(); message = isPremium ? "Premium wiederhergestellt." : "Kein Kauf gefunden." }
        catch { message = "Wiederherstellen fehlgeschlagen." }
    }
}

/// Sperrt eine Ansicht, sobald PremiumConfig.enforceGating = true ist und kein Premium vorliegt.
struct PremiumGate: ViewModifier {
    @EnvironmentObject var premium: PremiumStore
    let feature: PremiumFeature
    @State private var showPaywall = false
    func body(content: Content) -> some View {
        if premium.has(feature) {
            content
        } else {
            VStack(spacing: 12) {
                Image(systemName: "lock.fill").font(.largeTitle)
                Text(feature.title).font(.headline)
                Text(feature.detail).font(.footnote).multilineTextAlignment(.center).foregroundStyle(.secondary)
                Button("Premium ansehen") { showPaywall = true }.buttonStyle(.borderedProminent)
            }
            .padding()
            .sheet(isPresented: $showPaywall) { NavigationStack { PaywallView() } }
        }
    }
}

extension View {
    func premiumGate(_ feature: PremiumFeature) -> some View { modifier(PremiumGate(feature: feature)) }
}

struct PaywallView: View {
    @EnvironmentObject var premium: PremiumStore
    var body: some View {
        List {
            Section {
                ForEach(PremiumFeature.allCases.filter { !$0.planned }) { f in
                    VStack(alignment: .leading, spacing: 2) {
                        Label(f.title, systemImage: "checkmark.seal.fill").font(.headline)
                        Text(f.detail).font(.footnote).foregroundStyle(.secondary)
                    }
                }
            } header: { Text("Enthalten") }
            Section {
                ForEach(PremiumFeature.allCases.filter { $0.planned }) { f in
                    VStack(alignment: .leading, spacing: 2) {
                        Label(f.title, systemImage: "clock").font(.subheadline)
                        Text(f.detail).font(.footnote).foregroundStyle(.secondary)
                    }
                }
            } header: { Text("Geplant") }
            Section {
                if premium.isPremium {
                    Label("Premium ist aktiv", systemImage: "star.fill").foregroundStyle(.yellow)
                } else if premium.products.isEmpty {
                    Text("Premium ist noch nicht verfügbar. Sobald die App im App Store ist, siehst du hier die Angebote.").font(.footnote).foregroundStyle(.secondary)
                } else {
                    ForEach(premium.products, id: \.id) { p in
                        Button { Task { await premium.buy(p) } } label: {
                            HStack { Text(p.displayName); Spacer(); Text(p.displayPrice).bold() }
                        }
                    }
                }
                Button("Käufe wiederherstellen") { Task { await premium.restore() } }
                if let m = premium.message { Text(m).font(.footnote).foregroundStyle(.secondary) }
            } footer: {
                Text("Abos verlängern sich automatisch, wenn sie nicht mindestens 24 Stunden vor Ablauf in den Apple-ID-Einstellungen gekündigt werden. Zahlung und Kündigung laufen über Apple.")
            }
            #if DEBUG
            Section("Entwickler (nur Debug)") {
                Toggle("Premium simulieren", isOn: $premium.debugUnlock)
                Text("Wirkt nur, wenn PremiumConfig.enforceGating = true ist.").font(.footnote).foregroundStyle(.secondary)
            }
            #endif
        }
        .navigationTitle("BFC Premium")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { Analytics.track(.paywallOpened) }
    }
}

// MARK: - Werbung (vorbereitet, aus)

enum AdConfig {
    /// SCHALTER: false = nirgends Werbung, nichts wird geladen.
    static let enabled = false
    static let consentKey = "bfc.consent.ads"
    /// Regel: nie auf Seiten mit Gesundheitsbezug (Scan, Körperwerte, Diät, Extrem, Analysen).
}

protocol AdProvider {
    func bannerView() -> AnyView
}

/// Platzhalter. Später ersetzen durch AdMob (GADBannerView) oder einen anderen Anbieter, inklusive Einwilligungsabfrage (Google UMP) und ATT.
struct NoAdProvider: AdProvider {
    func bannerView() -> AnyView { AnyView(EmptyView()) }
}

enum Ads { static var provider: AdProvider = NoAdProvider() }

struct AdBannerSlot: View {
    @EnvironmentObject var premium: PremiumStore
    @AppStorage(AdConfig.consentKey) private var adConsent = false
    var body: some View {
        if AdConfig.enabled && !premium.isPremium && adConsent {
            Ads.provider.bannerView().frame(maxWidth: .infinity, minHeight: 50)
        }
    }
}

// MARK: - Profil-Bereich

struct PremiumAndAdsSection: View {
    @EnvironmentObject var premium: PremiumStore
    @AppStorage(Analytics.consentKey) private var analytics = false
    @AppStorage(AdConfig.consentKey) private var adConsent = false
    var body: some View {
        Section {
            NavigationLink { PaywallView() } label: {
                Label(premium.isPremium ? "Premium aktiv" : "BFC Premium", systemImage: "star")
            }
            Toggle("Anonyme Nutzungsstatistik", isOn: $analytics)
            if AdConfig.enabled {
                Toggle("Personalisierte Werbung", isOn: $adConsent)
            }
        } header: { Text("Premium und Statistik") } footer: {
            Text("Die Statistik ist aus, bis du sie einschaltest. Sie enthält nie Gesundheitswerte, Standort, Fotos oder Namen. Details in der Datenschutzerklärung, Abschnitt 15 bis 17.")
        }
    }
}
