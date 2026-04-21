import Foundation

@Observable
class StreakTracker {
    private(set) var currentStreak: Int = 0
    private(set) var longestStreak: Int = 0
    private(set) var totalDaysOpened: Int = 0
    private(set) var streakFreezeJustUsed: Bool = false

    private let defaults = UserDefaults.standard
    private let lastOpenedKey = "streak_lastOpenedDate"
    private let currentStreakKey = "streak_current"
    private let longestStreakKey = "streak_longest"
    private let totalDaysKey = "streak_totalDays"
    private let openedDatesKey = "streak_openedDates"
    private let freezeUsedWeekKey = "streak_freezeUsedWeek"
    private let freezeJustUsedFlagKey = "streak_freezeJustUsedFlag"

    init() {
        currentStreak = defaults.integer(forKey: currentStreakKey)
        longestStreak = defaults.integer(forKey: longestStreakKey)
        totalDaysOpened = defaults.integer(forKey: totalDaysKey)
        streakFreezeJustUsed = defaults.bool(forKey: freezeJustUsedFlagKey)
    }

    /// True if the weekly freeze has not yet been used this ISO week.
    var streakFreezeAvailable: Bool {
        let thisWeek = Self.currentWeekKey()
        let usedWeek = defaults.string(forKey: freezeUsedWeekKey) ?? ""
        return usedWeek != thisWeek
    }

    func recordAppOpen() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDateData = defaults.object(forKey: lastOpenedKey) as? Date {
            let lastDate = calendar.startOfDay(for: lastDateData)
            let daysBetween = calendar.dateComponents([.day], from: lastDate, to: today).day ?? 0

            if daysBetween == 0 {
                return
            } else if daysBetween == 1 {
                currentStreak += 1
                clearFreezeJustUsed()
            } else if daysBetween == 2 && streakFreezeAvailable && currentStreak >= 2 {
                currentStreak += 1
                useWeeklyFreeze()
            } else {
                currentStreak = 1
                clearFreezeJustUsed()
            }
        } else {
            currentStreak = 1
        }

        totalDaysOpened += 1

        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }

        defaults.set(today, forKey: lastOpenedKey)
        defaults.set(currentStreak, forKey: currentStreakKey)
        defaults.set(longestStreak, forKey: longestStreakKey)
        defaults.set(totalDaysOpened, forKey: totalDaysKey)
    }

    func acknowledgeFreezeUsed() {
        streakFreezeJustUsed = false
        defaults.set(false, forKey: freezeJustUsedFlagKey)
    }

    private func useWeeklyFreeze() {
        defaults.set(Self.currentWeekKey(), forKey: freezeUsedWeekKey)
        defaults.set(true, forKey: freezeJustUsedFlagKey)
        streakFreezeJustUsed = true
    }

    private func clearFreezeJustUsed() {
        if streakFreezeJustUsed {
            streakFreezeJustUsed = false
            defaults.set(false, forKey: freezeJustUsedFlagKey)
        }
    }

    private static func currentWeekKey() -> String {
        let cal = Calendar(identifier: .iso8601)
        let comps = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return "\(comps.yearForWeekOfYear ?? 0)-W\(comps.weekOfYear ?? 0)"
    }

    var streakEmoji: String {
        switch currentStreak {
        case 0: return "💤"
        case 1...2: return "🔥"
        case 3...6: return "🔥🔥"
        case 7...13: return "🔥🔥🔥"
        case 14...29: return "⚡️"
        default: return "🏆"
        }
    }

    var streakMessage: String {
        switch currentStreak {
        case 0: return "Open the app daily to build your streak!"
        case 1: return "Day 1 — the journey starts now!"
        case 2...3: return "Building momentum, keep it up!"
        case 4...6: return "You're on a roll!"
        case 7...13: return "A full week streak — impressive!"
        case 14...29: return "Two weeks strong — you're committed!"
        default: return "Legendary streak — unstoppable!"
        }
    }
}
