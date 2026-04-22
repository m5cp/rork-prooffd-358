import Foundation

nonisolated enum ActionCategory: String, Sendable {
    case research  = "Research"
    case setup     = "Setup"
    case marketing = "Marketing"
    case money     = "Money"
    case skill     = "Skill Building"
    case review    = "Review"

    var icon: String {
        switch self {
        case .research:  return "magnifyingglass"
        case .setup:     return "gearshape.fill"
        case .marketing: return "megaphone.fill"
        case .money:     return "dollarsign.circle.fill"
        case .skill:     return "book.fill"
        case .review:    return "checkmark.circle.fill"
        }
    }
}

nonisolated struct DailyAction: Identifiable, Codable, Sendable {
    let id: String
    let dayNumber: Int
    let dayLabel: String
    let category: String
    let title: String
    let detail: String
    let estimatedMinutes: Int
    var isCompleted: Bool = false
}

nonisolated struct WeeklyActionPlan: Identifiable, Codable, Sendable {
    let id: String
    let pathName: String
    let pathIcon: String
    var actions: [DailyAction]
    let generatedDate: Date
}
