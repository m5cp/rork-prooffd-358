import AppIntents
import SwiftUI

struct ShowDailyTipIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Daily Tip"
    static var description = IntentDescription("Shows today's career tip from Prooffd.")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let tip = DailyTipDatabase.tipForToday()
        return .result(dialog: "\(tip.title): \(tip.body)")
    }
}

struct ShowMyBuildsIntent: AppIntent {
    static var title: LocalizedStringResource = "Show My Plan"
    static var description = IntentDescription("Opens your active plan in Prooffd.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct ShowStreakIntent: AppIntent {
    static var title: LocalizedStringResource = "Show My Streak"
    static var description = IntentDescription("Shows your current streak in Prooffd.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let streak = UserDefaults.standard.integer(forKey: "streak_current")
        if streak > 0 {
            return .result(dialog: "You're on a \(streak)-day streak! Keep going!")
        } else {
            return .result(dialog: "Open Prooffd daily to build your streak!")
        }
    }
}

struct RetakeQuizIntent: AppIntent {
    static var title: LocalizedStringResource = "Retake Career Quiz"
    static var description = IntentDescription("Retakes the career matching quiz in Prooffd.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct ProoffdShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ShowDailyTipIntent(),
            phrases: [
                "Show my daily tip in \(.applicationName)",
                "What's today's tip on \(.applicationName)",
                "Give me a career tip from \(.applicationName)"
            ],
            shortTitle: "Daily Tip",
            systemImageName: "lightbulb.fill"
        )
        AppShortcut(
            intent: ShowMyBuildsIntent(),
            phrases: [
                "Show my plan in \(.applicationName)",
                "Open my career plan on \(.applicationName)"
            ],
            shortTitle: "My Plan",
            systemImageName: "list.bullet.clipboard"
        )
        AppShortcut(
            intent: ShowStreakIntent(),
            phrases: [
                "What's my streak on \(.applicationName)",
                "Show my streak in \(.applicationName)"
            ],
            shortTitle: "My Streak",
            systemImageName: "flame.fill"
        )
    }

    static var shortcutTileColor: ShortcutTileColor = .teal
}
