import Foundation

nonisolated enum CommittedPathType: String, Codable, Sendable {
    case business
    case trade
    case degree
}

nonisolated enum MilestoneCategory: String, Codable, Sendable {
    case research  = "Research"
    case setup     = "Setup"
    case training  = "Training"
    case action    = "Action"
    case financial = "Financial"
    case milestone = "Milestone"

    var icon: String {
        switch self {
        case .research:  return "magnifyingglass"
        case .setup:     return "gearshape.fill"
        case .training:  return "book.fill"
        case .action:    return "bolt.fill"
        case .financial: return "dollarsign.circle.fill"
        case .milestone: return "star.fill"
        }
    }
}

nonisolated struct PathMilestone: Identifiable, Codable, Sendable {
    let id: String
    let title: String
    let category: MilestoneCategory
    var isCompleted: Bool = false
    var dateCompleted: Date? = nil
}

nonisolated struct RealWorldWin: Identifiable, Codable, Sendable {
    let id: String
    let title: String
    let date: Date
    var note: String = ""
}

nonisolated struct MyPath: Codable, Sendable {
    let id: String
    let name: String
    let icon: String
    let type: CommittedPathType
    let matchScore: Int
    let dateSet: Date
    var milestones: [PathMilestone]
}
