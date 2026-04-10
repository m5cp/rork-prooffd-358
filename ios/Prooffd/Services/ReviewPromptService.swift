import StoreKit
import SwiftUI

@Observable
class ReviewPromptService {
    static let shared = ReviewPromptService()

    private let maxPrompts = 3
    private let cooldownDays = 30

    private let promptCountKey = "review_promptCount"
    private let lastPromptDateKey = "review_lastPromptDate"

    private(set) var promptCount: Int
    private(set) var lastPromptDate: Date?

    private init() {
        promptCount = UserDefaults.standard.integer(forKey: promptCountKey)
        lastPromptDate = UserDefaults.standard.object(forKey: lastPromptDateKey) as? Date
    }

    private var canPrompt: Bool {
        guard promptCount < maxPrompts else { return false }
        if let last = lastPromptDate {
            let daysSince = Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0
            return daysSince >= cooldownDays
        }
        return true
    }

    func checkAndPromptIfEligible(
        streakDays: Int,
        levelRank: Int,
        unlockedCount: Int
    ) {
        guard canPrompt else { return }

        let eligible =
            streakDays == 7 ||
            streakDays == 14 ||
            streakDays == 30 ||
            levelRank == 3 ||
            levelRank == 5 ||
            unlockedCount == 5 ||
            unlockedCount == 10

        guard eligible else { return }

        requestReview()
    }

    private func requestReview() {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }

        SKStoreReviewController.requestReview(in: scene)

        promptCount += 1
        lastPromptDate = Date()
        UserDefaults.standard.set(promptCount, forKey: promptCountKey)
        UserDefaults.standard.set(lastPromptDate, forKey: lastPromptDateKey)
    }
}
