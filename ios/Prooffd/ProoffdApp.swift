import SwiftUI
import RevenueCat

@main
struct ProoffdApp: App {
    @State private var appState = AppState()
    @State private var storeViewModel = StoreViewModel()
    @State private var themeManager = ThemeManager()

    init() {
        let apiKey = Config.EXPO_PUBLIC_REVENUECAT_IOS_API_KEY.isEmpty
            ? Config.EXPO_PUBLIC_REVENUECAT_TEST_API_KEY
            : Config.EXPO_PUBLIC_REVENUECAT_IOS_API_KEY
        if !apiKey.isEmpty {
            Purchases.configure(withAPIKey: apiKey)
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(storeViewModel)
                .environment(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                .onOpenURL { url in
                    handleQuickAction(url: url)
                }
                .task {
                    NotificationService.shared.refreshRemindersIfNeeded()
                }
        }
    }

    private func handleQuickAction(url: URL) {
        guard url.scheme == "prooffd" else { return }
        switch url.host {
        case "builds":
            appState.selectedTab = 1
        case "quiz":
            appState.retakeQuiz()
        case "today":
            appState.selectedTab = 1
        default:
            break
        }
    }
}

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            Group {
                switch appState.currentScreen {
                case .onboarding:
                    OnboardingView(
                        onComplete: { appState.completeOnboarding() },
                        onSkipQuiz: { appState.skipQuiz() }
                    )
                case .quiz:
                    QuizView(
                        onComplete: { profile in
                            appState.userProfile = profile
                            appState.completeQuiz()
                        },
                        onSkip: { appState.skipQuiz() },
                        onEarlyComplete: { profile in
                            appState.completeEarlyQuiz(partialProfile: profile)
                        },
                        initialProfile: appState.userProfile
                    )
                case .analyzing:
                    AnalyzingView()
                case .resultsReveal:
                    ResultsRevealView()
                case .results:
                    ResultsView()
                }
            }

            if let badge = appState.celebratingBadge {
                BadgeCelebrationOverlay(badge: badge) {
                    appState.celebratingBadge = nil
                }
                .transition(.opacity)
                .zIndex(100)
            }

            if appState.dailyRewards.showRewardPopup, appState.dailyRewards.canClaim {
                DailyRewardPopup(
                    reward: appState.dailyRewards.todayReward,
                    currentDay: appState.dailyRewards.currentDay
                ) {
                    appState.claimDailyReward()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        appState.dailyRewards.dismissReward()
                    }
                }
                .transition(.opacity)
                .zIndex(99)
            }
        }
        .animation(.spring(duration: 0.4), value: appState.celebratingBadge != nil)
        .animation(.spring(duration: 0.4), value: appState.dailyRewards.showRewardPopup)
        .sensoryFeedback(.success, trigger: appState.celebratingBadge != nil)
    }
}
