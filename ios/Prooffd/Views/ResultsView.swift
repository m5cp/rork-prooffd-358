import SwiftUI

struct ResultsView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var showSecondPaywall = false

    var body: some View {
        @Bindable var state = appState
        TabView(selection: $state.selectedTab) {
            UnifiedExploreView()
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }
                .tag(0)

            MyBuildsView()
                .tabItem {
                    Label("My Plan", systemImage: "list.clipboard.fill")
                }
                .tag(1)

            ProfileTabView()
                .tabItem {
                    Label("You", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
        .tint(Theme.accent)
        .onAppear {
            appState.recordAppOpen()
            Task {
                try? await Task.sleep(for: .seconds(2.5))
                if UserDefaults.standard.bool(forKey: "showSecondPaywall") && !store.isPremium {
                    showSecondPaywall = true
                }
            }
        }
        .sheet(isPresented: $showSecondPaywall) {
            SecondChancePaywallView()
        }
    }
}
