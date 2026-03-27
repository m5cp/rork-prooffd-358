import Foundation

@Observable
class DailyRewardTracker {
    private(set) var currentDay: Int = 0
    private(set) var lastClaimDate: Date?
    private(set) var totalClaimed: Int = 0
    var showRewardPopup: Bool = false
    var pendingReward: DailyReward?

    private let defaults = UserDefaults.standard
    private let currentDayKey = "dailyReward_currentDay"
    private let lastClaimKey = "dailyReward_lastClaim"
    private let totalClaimedKey = "dailyReward_totalClaimed"

    init() {
        currentDay = defaults.integer(forKey: currentDayKey)
        totalClaimed = defaults.integer(forKey: totalClaimedKey)
        if let date = defaults.object(forKey: lastClaimKey) as? Date {
            lastClaimDate = date
        }
        resetIfStreakBroken()
    }

    var canClaim: Bool {
        guard let last = lastClaimDate else { return true }
        let calendar = Calendar.current
        return !calendar.isDateInToday(last)
    }

    var todayReward: DailyReward {
        DailyReward.forDay(currentDay + 1)
    }

    var nextMilestoneDay: Int {
        let milestones = [3, 7, 14, 30]
        let nextDay = currentDay + 1
        return milestones.first(where: { $0 >= nextDay }) ?? 30
    }

    var daysUntilMilestone: Int {
        max(0, nextMilestoneDay - currentDay)
    }

    func claimReward() -> DailyReward {
        let reward = todayReward
        currentDay += 1
        totalClaimed += 1
        lastClaimDate = Date()

        defaults.set(currentDay, forKey: currentDayKey)
        defaults.set(totalClaimed, forKey: totalClaimedKey)
        defaults.set(lastClaimDate, forKey: lastClaimKey)

        pendingReward = reward
        showRewardPopup = true
        return reward
    }

    func dismissReward() {
        showRewardPopup = false
        pendingReward = nil
    }

    private func resetIfStreakBroken() {
        guard let last = lastClaimDate else { return }
        let calendar = Calendar.current
        let daysBetween = calendar.dateComponents([.day], from: calendar.startOfDay(for: last), to: calendar.startOfDay(for: Date())).day ?? 0
        if daysBetween > 1 {
            currentDay = 0
            defaults.set(0, forKey: currentDayKey)
        }
    }
}

nonisolated struct DailyReward: Sendable {
    let day: Int
    let points: Int
    let title: String
    let icon: String
    let isMilestone: Bool

    static func forDay(_ day: Int) -> DailyReward {
        switch day {
        case 1:
            return DailyReward(day: 1, points: 5, title: "Welcome Back", icon: "gift.fill", isMilestone: false)
        case 2:
            return DailyReward(day: 2, points: 5, title: "Day 2 Bonus", icon: "gift.fill", isMilestone: false)
        case 3:
            return DailyReward(day: 3, points: 15, title: "3-Day Streak Bonus", icon: "star.circle.fill", isMilestone: true)
        case 4...6:
            return DailyReward(day: day, points: 8, title: "Day \(day) Reward", icon: "gift.fill", isMilestone: false)
        case 7:
            return DailyReward(day: 7, points: 25, title: "Week Warrior", icon: "trophy.fill", isMilestone: true)
        case 8...13:
            return DailyReward(day: day, points: 10, title: "Day \(day) Reward", icon: "gift.fill", isMilestone: false)
        case 14:
            return DailyReward(day: 14, points: 40, title: "Two Week Champion", icon: "crown.fill", isMilestone: true)
        case 15...29:
            return DailyReward(day: day, points: 12, title: "Day \(day) Reward", icon: "gift.fill", isMilestone: false)
        case 30:
            return DailyReward(day: 30, points: 75, title: "Monthly Legend", icon: "bolt.shield.fill", isMilestone: true)
        default:
            let base = 12
            let bonus = (day / 7) * 2
            return DailyReward(day: day, points: base + bonus, title: "Day \(day) Reward", icon: "gift.fill", isMilestone: day % 7 == 0)
        }
    }
}
