import Foundation
import ActivityKit

nonisolated struct BuildActivityAttributes: ActivityAttributes, Sendable {
    public nonisolated struct ContentState: Codable, Hashable, Sendable {
        var progressPercent: Int
        var streakDays: Int
        var nextStepTitle: String
        var stepsCompleted: Int
        var totalSteps: Int
    }

    var buildId: String
    var buildName: String
    var pathIcon: String
}
