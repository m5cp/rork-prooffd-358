import SwiftUI
import RevenueCat
import AppIntents

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
        ProoffdShortcuts.updateAppShortcutParameters()
        SpotlightService.indexAllPaths()
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
            appState.selectedTab = 0
        default:
            break
        }
    }
}

struct RootView: View {
    @Environment(AppState.self) private var appState
    @State private var showLaunch: Bool = true
    @State private var showWelcomeIntro: Bool = false

    var body: some View {
        ZStack {
            Group {
                if appState.hasCompletedOnboarding {
                    switch appState.currentScreen {
                    case .resultsReveal:
                        ResultsRevealView()
                    case .analyzing:
                        AnalyzingView()
                    default:
                        ResultsView()
                    }
                } else if showWelcomeIntro {
                    WelcomeIntroView {
                        withAnimation(.spring(duration: 0.5, bounce: 0.1)) {
                            showWelcomeIntro = false
                        }
                    }
                    .transition(.opacity)
                } else {
                    OnboardingView { path, profile in
                        appState.completeOnboardingWithQuiz(path: path, profile: profile)
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .opacity(showLaunch ? 0 : 1)

            if showLaunch {
                LaunchView {
                    let needsWelcome = !appState.hasCompletedOnboarding && !UserDefaults.standard.bool(forKey: "hasSeenWelcomeIntro")
                    if needsWelcome {
                        showWelcomeIntro = true
                        UserDefaults.standard.set(true, forKey: "hasSeenWelcomeIntro")
                    }
                    withAnimation(.easeOut(duration: 0.3)) {
                        showLaunch = false
                    }
                }
                .transition(.opacity)
            }
        }
    }
}
