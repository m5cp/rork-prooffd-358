import Foundation

@Observable
class MomentumSystem {
    var totalPoints: Int = 0
    var earnedBadges: Set<String> = []
    var lastShareDate: Date?
    var shareCountToday: Int = 0

    private let defaults = UserDefaults.standard
    private let pointsKey = "momentum_totalPoints"
    private let badgesKey = "momentum_earnedBadges"
    private let lastShareKey = "momentum_lastShareDate"
    private let shareCountKey = "momentum_shareCountToday"
    private let lastShareDayKey = "momentum_lastShareDay"

    init() {
        totalPoints = defaults.integer(forKey: pointsKey)
        if let ids = defaults.stringArray(forKey: badgesKey) {
            earnedBadges = Set(ids)
        }
        lastShareDate = defaults.object(forKey: lastShareKey) as? Date
        resetShareCountIfNewDay()
    }

    func awardPoints(_ amount: Int, reason: PointReason) {
        totalPoints += amount
        defaults.set(totalPoints, forKey: pointsKey)
    }

    func awardBadge(_ badge: MomentumBadge) {
        guard !earnedBadges.contains(badge.id) else { return }
        earnedBadges.insert(badge.id)
        defaults.set(Array(earnedBadges), forKey: badgesKey)
    }

    func canShare() -> Bool {
        resetShareCountIfNewDay()
        return shareCountToday < 3
    }

    func recordShare() {
        resetShareCountIfNewDay()
        shareCountToday += 1
        lastShareDate = Date()
        defaults.set(shareCountToday, forKey: shareCountKey)
        defaults.set(lastShareDate, forKey: lastShareKey)
        let dayString = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
        defaults.set(dayString, forKey: lastShareDayKey)
        awardPoints(10, reason: .shared)
    }

    func hasBadge(_ id: String) -> Bool {
        earnedBadges.contains(id)
    }

    private func resetShareCountIfNewDay() {
        let today = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
        let lastDay = defaults.double(forKey: lastShareDayKey)
        if lastDay != today {
            shareCountToday = 0
            defaults.set(0, forKey: shareCountKey)
        } else {
            shareCountToday = defaults.integer(forKey: shareCountKey)
        }
    }

    func checkBadges(completedSteps: Int, streakDays: Int, buildProgress: Int, buildsCount: Int) {
        if completedSteps >= 1 { awardBadge(.firstStep) }
        if streakDays >= 3 { awardBadge(.streak3) }
        if streakDays >= 7 { awardBadge(.streak7) }
        if buildProgress >= 25 { awardBadge(.quarter) }
        if buildProgress >= 50 { awardBadge(.half) }
        if buildProgress >= 100 { awardBadge(.launchReady) }
    }
}

nonisolated enum PointReason: Sendable {
    case todayStep
    case checklistItem
    case editedPlan
    case dailyUse
    case shared
}

nonisolated struct MomentumBadge: Identifiable, Sendable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: String

    static let firstStep = MomentumBadge(id: "first_step_done", title: "First Step", description: "Completed your first step", icon: "checkmark.circle.fill", color: "34D399")
    static let streak3 = MomentumBadge(id: "streak_3", title: "3 Day Streak", description: "Used the app 3 days in a row", icon: "flame.fill", color: "FB923C")
    static let streak7 = MomentumBadge(id: "streak_7", title: "7 Day Streak", description: "Used the app 7 days in a row", icon: "flame.circle.fill", color: "EF4444")
    static let quarter = MomentumBadge(id: "quarter_done", title: "25% Complete", description: "Reached 25% on a build", icon: "chart.bar.fill", color: "60A5FA")
    static let half = MomentumBadge(id: "half_done", title: "50% Complete", description: "Reached 50% on a build", icon: "star.fill", color: "FBBF24")
    static let launchReady = MomentumBadge(id: "launch_ready", title: "Launch Ready", description: "Completed a full build", icon: "trophy.fill", color: "818CF8")

    static let all: [MomentumBadge] = [firstStep, streak3, streak7, quarter, half, launchReady]
}
