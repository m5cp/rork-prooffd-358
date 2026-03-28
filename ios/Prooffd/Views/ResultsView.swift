import SwiftUI
import Combine

struct ResultsView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store

    var body: some View {
        @Bindable var state = appState
        ZStack {
            TabView(selection: $state.selectedTab) {
                UnifiedExploreView()
                    .tabItem {
                        Image(systemName: "safari")
                        Text("Explore")
                    }
                    .tag(0)

                MyBuildsView()
                    .tabItem {
                        Image(systemName: "hammer.fill")
                        Text("My Builds")
                    }
                    .tag(1)

                ProfileTabView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(2)
            }
            .tint(Theme.accent)

            if appState.showWelcomeBack {
                WelcomeBackView()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.spring(duration: 0.5), value: appState.showWelcomeBack)
        .onAppear {
            appState.recordAppOpen()
        }
    }
}
