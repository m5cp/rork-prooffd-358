import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            switch appState.currentScreen {
            case .onboarding:
                OnboardingView {
                    appState.completeOnboarding()
                }
                .transition(.move(edge: .trailing))

            case .quiz:
                QuizView(
                    onComplete: { profile in
                        appState.userProfile = profile
                        appState.completeQuiz()
                    },
                    initialProfile: appState.userProfile
                )
                .transition(.move(edge: .trailing))

            case .analyzing:
                AnalyzingView()
                    .transition(.opacity)

            case .resultsReveal:
                ResultsRevealView()
                    .transition(.opacity)

            case .results:
                ResultsView()
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.spring(duration: 0.5), value: appState.currentScreen)
    }
}
