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
        }
    }
}
