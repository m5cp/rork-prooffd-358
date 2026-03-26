import Foundation

@Observable
class StreakTracker {
    private(set) var currentStreak: Int = 0
    private(set) var longestStreak: Int = 0
    private(set) var totalDaysOpened: Int = 0

    private let defaults = UserDefaults.standard
    private let lastOpenedKey = "streak_lastOpenedDate"
    private let currentStreakKey = "streak_current"
    private let longestStreakKey = "streak_longest"
    private let totalDaysKey = "streak_totalDays"
    private let openedDatesKey = "streak_openedDates"

    init() {
        currentStreak = defaults.integer(forKey: currentStreakKey)
        longestStreak = defaults.integer(forKey: longestStreakKey)
        totalDaysOpened = defaults.integer(forKey: totalDaysKey)
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
            } else {
                currentStreak = 1
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
