import SwiftUI
import RevenueCat

/// Prooffd is free. Every feature is unlocked for everyone.
///
/// `isPremium` is a stored constant rather than an entitlement lookup so that
/// the dozens of `if store.isPremium` checks scattered across the views keep
/// compiling and simply always take the unlocked branch. Removing the property
/// outright would have meant rewriting every call site — this way the gates are
/// dead code that can be cleaned up incrementally without risking a regression.
///
/// `restore()` is intentionally kept: users who subscribed while the app was
/// paid can still restore, and the App Store requires a restore path to exist
/// for as long as the products do.
@Observable
class StoreViewModel {
    /// Always unlocked. Do not wire this back to an entitlement without also
    /// restoring the paywall UI that was removed.
    let isPremium = true

    var offerings: Offerings?
    var isLoading = false
    var isPurchasing = false
    var error: String?

    func restore() async {
        do {
            _ = try await Purchases.shared.restorePurchases()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
