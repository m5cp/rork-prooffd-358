import SwiftUI
import Combine

struct ResultsView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store

    var body: some View {
        @Bindable var state = appState
        TabView(selection: $state.selectedTab) {
            UnifiedExploreView()
                .tabItem {
                    Label("Explore", systemImage: "compass")
                }
                .tag(0)

            MyBuildsView()
                .tabItem {
                    Label("Builds", systemImage: "list.bullet.clipboard")
                }
                .tag(1)

            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
        .tint(Theme.accent)
        .onAppear {
            appState.recordAppOpen()
        }
    }
}
