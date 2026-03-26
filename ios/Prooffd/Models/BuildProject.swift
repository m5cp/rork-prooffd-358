import Foundation

nonisolated struct BuildStep: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    var isCompleted: Bool
    let order: Int
    var completedDate: Date?
    var notes: String?
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

    var unlockTier: Int {
        switch progressPercentage {
        case 0..<15: return 0
        case 15..<40: return 1
        case 40..<70: return 2
        default: return 3
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
            "Post your first offer in a local Facebook group",
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
            strategyNotes: "Start with local outreach. Focus on getting your first 5 customers through personal connections and local groups.",
            serviceNotes: path.overview.components(separatedBy: ".").first ?? path.overview
        )
    }
}

nonisolated struct UnlockContent: Sendable {
    let tier: Int
    let title: String
    let items: [UnlockItem]
}

nonisolated struct UnlockItem: Identifiable, Sendable {
    let id: String
    let title: String
    let content: String
    let icon: String
}

enum UnlockContentDatabase {
    static func tier1Content(for pathName: String) -> UnlockContent {
        UnlockContent(tier: 1, title: "Starter Kit", items: [
            UnlockItem(
                id: "first_message",
                title: "First Outreach Message",
                content: "Hi, I'm offering \(pathName.lowercased()) services in your area this week. I have a few open spots and would love to help. Would you like a quick quote?",
                icon: "message.fill"
            ),
            UnlockItem(
                id: "pricing_tip",
                title: "Pricing Tip",
                content: "Start slightly lower than market rate to build reviews and referrals. Once you have 5+ reviews, raise to match or exceed market rates.",
                icon: "tag.fill"
            ),
            UnlockItem(
                id: "customer_sources",
                title: "Where to Find Customers",
                content: "Facebook groups, Nextdoor, local community boards, referrals from friends and family, and Craigslist services section.",
                icon: "person.3.fill"
            )
        ])
    }

    static func tier2Content(for pathName: String) -> UnlockContent {
        UnlockContent(tier: 2, title: "Growth Kit", items: [
            UnlockItem(
                id: "follow_up",
                title: "Follow-Up Template",
                content: "Hey! Just checking back on the \(pathName.lowercased()) quote I sent. I still have openings this week if you're interested. Happy to answer any questions!",
                icon: "arrow.uturn.forward"
            ),
            UnlockItem(
                id: "upsell",
                title: "Upsell Strategy",
                content: "After completing the initial service, ask: \"Would you also like [related service]? I can offer a bundle discount since I'm already here.\"",
                icon: "plus.circle.fill"
            ),
            UnlockItem(
                id: "pricing_optimize",
                title: "Pricing Optimization",
                content: "If demand is consistently high (booking out 1+ weeks), raise your prices 10-20%. If demand drops, offer a limited-time promotion to refill your schedule.",
                icon: "chart.line.uptrend.xyaxis"
            )
        ])
    }

    static let tier3Teaser = UnlockContent(tier: 3, title: "Pro Growth System", items: [
        UnlockItem(id: "acquisition", title: "Customer Acquisition System", content: "Complete system for finding and converting new customers consistently", icon: "person.badge.plus"),
        UnlockItem(id: "scaling", title: "Scaling Strategy", content: "Step-by-step plan to go from solo operator to team lead", icon: "arrow.up.right"),
        UnlockItem(id: "growth_plan", title: "Repeatable Growth Plan", content: "Monthly action plan for sustainable revenue growth", icon: "repeat")
    ])
}
