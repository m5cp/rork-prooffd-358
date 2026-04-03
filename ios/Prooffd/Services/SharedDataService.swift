import Foundation
import WidgetKit

enum SharedDataService {
    static let suiteName = "group.app.rork.prooffd"

    static var shared: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }

    static func updateWidgetData(
        streakCount: Int,
        longestStreak: Int,
        buildsCount: Int,
        tipTitle: String,
        tipBody: String,
        tipCategory: String,
        microActionTitle: String,
        microActionCompleted: Bool,
        totalPoints: Int,
        levelName: String
    ) {
        guard let shared else { return }
        shared.set(streakCount, forKey: "widget_streakCount")
        shared.set(longestStreak, forKey: "widget_longestStreak")
        shared.set(buildsCount, forKey: "widget_buildsCount")
        shared.set(tipTitle, forKey: "widget_tipTitle")
        shared.set(tipBody, forKey: "widget_tipBody")
        shared.set(tipCategory, forKey: "widget_tipCategory")
        shared.set(microActionTitle, forKey: "widget_microActionTitle")
        shared.set(microActionCompleted, forKey: "widget_microActionCompleted")
        shared.set(totalPoints, forKey: "widget_totalPoints")
        shared.set(levelName, forKey: "widget_levelName")
        shared.set(Date(), forKey: "widget_lastUpdated")

        WidgetCenter.shared.reloadAllTimelines()
    }
}
