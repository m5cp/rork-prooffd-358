import Foundation

nonisolated struct BuildStep: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    var isCompleted: Bool
    let order: Int
}

nonisolated struct BuildProject: Codable, Identifiable, Sendable {
    let id: String
    let pathId: String
    let pathName: String
    let pathIcon: String
    let category: BusinessCategory
    let startupCost: String
    let timeToFirstDollar: String
    let overview: String
    let startDate: Date
    var steps: [BuildStep]
    var businessName: String
    var pricingNotes: String
    var strategyNotes: String
    var serviceNotes: String

    var completedSteps: Int { steps.filter(\.isCompleted).count }
    var totalSteps: Int { steps.count }

    var progressPercentage: Int {
        totalSteps > 0 ? Int(Double(completedSteps) / Double(totalSteps) * 100) : 0
    }

    var nextStep: BuildStep? {
        steps.first { !$0.isCompleted }
    }

    var currentMilestone: String {
        switch progressPercentage {
        case 0..<10: return "Getting Started"
        case 10..<25: return "Building Foundation"
        case 25..<50: return "First Customer"
        case 50..<75: return "Scaling Up"
        case 75..<100: return "Almost There"
        default: return "Launched!"
        }
    }

    var optimizationSuggestions: [String] {
        var suggestions: [String] = []
        if progressPercentage < 25 {
            suggestions.append("Focus on completing your first 3 steps to build momentum")
        }
        if pricingNotes.isEmpty {
            suggestions.append("You may be underpricing — set your rates in the plan")
        }
        if serviceNotes.isEmpty {
            suggestions.append("Consider adding an upsell service to increase revenue")
        }
        if progressPercentage > 50 && strategyNotes.isEmpty {
            suggestions.append("Document your strategy to stay focused as you grow")
        }
        if suggestions.isEmpty {
            suggestions.append("You're making great progress — keep going!")
        }
        return suggestions
    }

    static func create(from path: BusinessPath) -> BuildProject {
        var steps: [BuildStep] = []
        var order = 0

        let standardSteps = [
            "Research competitors in your area",
            "Choose your business name",
            "Set up your pricing structure"
        ]
        for step in standardSteps {
            steps.append(BuildStep(id: UUID().uuidString, title: step, isCompleted: false, order: order))
            order += 1
        }

        for step in path.actionPlan {
            steps.append(BuildStep(id: UUID().uuidString, title: step, isCompleted: false, order: order))
            order += 1
        }

        let closingSteps = [
            "Post your first offer",
            "Land your first customer",
            "Collect your first review"
        ]
        for step in closingSteps {
            steps.append(BuildStep(id: UUID().uuidString, title: step, isCompleted: false, order: order))
            order += 1
        }

        return BuildProject(
            id: UUID().uuidString,
            pathId: path.id,
            pathName: path.name,
            pathIcon: path.icon,
            category: path.category,
            startupCost: path.startupCostRange,
            timeToFirstDollar: path.timeToFirstDollar,
            overview: path.overview,
            startDate: Date(),
            steps: steps,
            businessName: path.name,
            pricingNotes: path.starterPricing,
            strategyNotes: "",
            serviceNotes: ""
        )
    }
}
