import Combine
import SwiftUI

@main
struct FitScanApp: App {
    @StateObject private var health = HealthManager()
    @StateObject private var profile = UserProfile()
    @StateObject private var store = TrainingStore()
    @StateObject private var foodLog = FoodLog()
    @StateObject private var recipeStore = RecipeStore()
    @StateObject private var foodStore = FoodStore()
    @StateObject private var nav = AppNav()
    @StateObject private var community = CommunityService()
    @StateObject private var steps = StepTracker()
    @StateObject private var session = WorkoutSession()
    @StateObject private var sessionLog = SessionLog()
    @StateObject private var scanSchedule = ScanSchedule()
    @StateObject private var avatar = AvatarStore()
    @StateObject private var rank = RankStore()
    @StateObject private var premium = PremiumStore()
    @StateObject private var supplements = SupplementStore()
    @StateObject private var vitals = VitalsStore()
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("bfc.consent.answered") private var consentGiven = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(health)
                .environmentObject(profile)
                .environmentObject(store)
                .environmentObject(foodLog)
                .environmentObject(recipeStore)
                .environmentObject(foodStore)
                .environmentObject(nav)
                .environmentObject(community)
                .environmentObject(steps)
                .environmentObject(session)
                .environmentObject(sessionLog)
                .environmentObject(scanSchedule)
                .environmentObject(avatar)
                .environmentObject(rank)
                .environmentObject(premium)
                .environmentObject(supplements)
                .environmentObject(vitals)
                .keyboardFriendly()
                .onChange(of: scenePhase) { _, phase in
                    if phase == .active {
                        if consentGiven { steps.start() }
                        if health.isAuthorized { Task { await health.refreshToday() } }
                    } else if !session.running { steps.stop() }
                }
                .onAppear {
                    KeyboardHelper.install()
                    // Bewegungssensor erst nach der Einwilligung (sonst erscheint die Abfrage vor dem Datenschutz-Dialog)
                    if consentGiven { steps.start() }
                    Analytics.track(.appOpen)
                    health.sessionLog = sessionLog
                    WorkoutFlow.shared.store = store
                    WorkoutFlow.shared.sessionLog = sessionLog
                }
        }
    }
}
