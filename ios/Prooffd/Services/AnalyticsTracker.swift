import Foundation

@Observable
class AnalyticsTracker {
    static let shared = AnalyticsTracker()

    private(set) var totalAppOpens: Int = 0
    private(set) var quizCompletions: Int = 0
    private(set) var pathsExplored: Int = 0
    private(set) var buildsStarted: Int = 0
    private(set) var stepsCompleted: Int = 0
    private(set) var sharesCount: Int = 0
    private(set) var dailyOpenDates: [String] = []
    private(set) var firstOpenDate: Date?

    private let defaults = UserDefaults.standard
    private let prefix = "analytics_"

    init() {
        totalAppOpens = defaults.integer(forKey: k("totalOpens"))
        quizCompletions = defaults.integer(forKey: k("quizCompletions"))
        pathsExplored = defaults.integer(forKey: k("pathsExplored"))
        buildsStarted = defaults.integer(forKey: k("buildsStarted"))
        stepsCompleted = defaults.integer(forKey: k("stepsCompleted"))
        sharesCount = defaults.integer(forKey: k("shares"))
        if let dates = defaults.stringArray(forKey: k("dailyOpenDates")) {
            dailyOpenDates = dates
        }
        firstOpenDate = defaults.object(forKey: k("firstOpen")) as? Date
    }

    func trackAppOpen() {
        totalAppOpens += 1
        defaults.set(totalAppOpens, forKey: k("totalOpens"))

        if firstOpenDate == nil {
            firstOpenDate = Date()
            defaults.set(firstOpenDate, forKey: k("firstOpen"))
        }

        let today = dateString(Date())
        if !dailyOpenDates.contains(today) {
            dailyOpenDates.append(today)
            if dailyOpenDates.count > 90 {
                dailyOpenDates = Array(dailyOpenDates.suffix(90))
            }
            defaults.set(dailyOpenDates, forKey: k("dailyOpenDates"))
        }
    }

    func trackQuizCompletion() {
        quizCompletions += 1
        defaults.set(quizCompletions, forKey: k("quizCompletions"))
    }

    func trackPathExplored() {
        pathsExplored += 1
        defaults.set(pathsExplored, forKey: k("pathsExplored"))
    }

    func trackBuildStarted() {
        buildsStarted += 1
        defaults.set(buildsStarted, forKey: k("buildsStarted"))
    }

    func trackStepCompleted() {
        stepsCompleted += 1
        defaults.set(stepsCompleted, forKey: k("stepsCompleted"))
    }

    func trackShare() {
        sharesCount += 1
        defaults.set(sharesCount, forKey: k("shares"))
    }

    var uniqueDaysActive: Int { dailyOpenDates.count }

    var daysSinceFirstOpen: Int {
        guard let first = firstOpenDate else { return 0 }
        return Calendar.current.dateComponents([.day], from: first, to: Date()).day ?? 0
    }

    var retentionRate: Double {
        let days = daysSinceFirstOpen
        guard days > 0 else { return 100 }
        return min(100, Double(uniqueDaysActive) / Double(days) * 100)
    }

    var averageActionsPerSession: Double {
        guard totalAppOpens > 0 else { return 0 }
        let totalActions = Double(quizCompletions + pathsExplored + buildsStarted + stepsCompleted + sharesCount)
        return totalActions / Double(totalAppOpens)
    }

    var weeklyActiveDays: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let weekAgoStr = dateString(weekAgo)
        return dailyOpenDates.filter { $0 >= weekAgoStr }.count
    }

    private func k(_ key: String) -> String { prefix + key }

    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
}
