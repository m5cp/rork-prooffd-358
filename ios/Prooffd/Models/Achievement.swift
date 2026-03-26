import Foundation

nonisolated struct Achievement: Identifiable, Sendable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: String
    let requirement: AchievementRequirement
}

nonisolated enum AchievementRequirement: Sendable {
    case pathsExplored(Int)
    case favorited(Int)
    case usedWhatIf
    case sharedResult
    case streakDays(Int)
    case completedQuiz
    case openedApp(Int)
}

enum AchievementDatabase {
    static let all: [Achievement] = [
        Achievement(id: "first_step", title: "First Step", description: "Complete the profile quiz", icon: "checkmark.circle.fill", color: "34D399", requirement: .completedQuiz),
        Achievement(id: "curious_mind", title: "Curious Mind", description: "Explore 5 business paths", icon: "eye.fill", color: "60A5FA", requirement: .pathsExplored(5)),
        Achievement(id: "deep_diver", title: "Deep Diver", description: "Explore 15 business paths", icon: "magnifyingglass", color: "818CF8", requirement: .pathsExplored(15)),
        Achievement(id: "path_master", title: "Path Master", description: "Explore 30 business paths", icon: "star.circle.fill", color: "FBBF24", requirement: .pathsExplored(30)),
        Achievement(id: "bookmarker", title: "Bookmarker", description: "Favorite 3 business paths", icon: "heart.fill", color: "F472B6", requirement: .favorited(3)),
        Achievement(id: "collector", title: "Collector", description: "Favorite 10 business paths", icon: "heart.circle.fill", color: "FB923C", requirement: .favorited(10)),
        Achievement(id: "what_if_explorer", title: "What If Explorer", description: "Use What If mode", icon: "slider.horizontal.3", color: "3B82F6", requirement: .usedWhatIf),
        Achievement(id: "networker", title: "Networker", description: "Share a business path", icon: "square.and.arrow.up.fill", color: "2DD4BF", requirement: .sharedResult),
        Achievement(id: "streak_starter", title: "Streak Starter", description: "3-day app streak", icon: "flame.fill", color: "FB923C", requirement: .streakDays(3)),
        Achievement(id: "week_warrior", title: "Week Warrior", description: "7-day app streak", icon: "flame.circle.fill", color: "EF4444", requirement: .streakDays(7)),
        Achievement(id: "committed", title: "Fully Committed", description: "14-day app streak", icon: "trophy.fill", color: "FBBF24", requirement: .streakDays(14)),
        Achievement(id: "regular", title: "Regular", description: "Open the app 10 times", icon: "arrow.counterclockwise", color: "67E8F9", requirement: .openedApp(10)),
    ]
}
