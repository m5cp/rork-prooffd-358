import Foundation

enum ActionPlanGenerator {

    static func generate(from result: MatchResult) -> WeeklyActionPlan {
        let path = result.businessPath
        let step1 = path.freeActionPlan.first ?? "Research \(path.name) businesses in your local area"
        let step2 = path.freeActionPlan.dropFirst().first ?? "Watch YouTube videos from established \(path.name) businesses"
        let actions = [
            DailyAction(id: "\(path.id)-1", dayNumber: 1, dayLabel: "Day 1 — Research",
                category: ActionCategory.research.rawValue,
                title: "Understand Your Market",
                detail: "Spend 30 minutes researching \(path.name) in your local area. Search for competitors on Google Maps, Yelp, and Nextdoor. Write down 3 things you notice about how they price and present themselves.",
                estimatedMinutes: 30),
            DailyAction(id: "\(path.id)-2", dayNumber: 2, dayLabel: "Day 2 — Research",
                category: ActionCategory.research.rawValue,
                title: "Find 3 Potential Customers",
                detail: "Identify 3 specific people or businesses who might need \(path.name) services. Write their name and where you would reach them. Do not contact them yet — just identify them.",
                estimatedMinutes: 20),
            DailyAction(id: "\(path.id)-3", dayNumber: 3, dayLabel: "Day 3 — Setup",
                category: ActionCategory.setup.rawValue,
                title: "Complete Your First Setup Step",
                detail: "Today: \(step1). Write down exactly what you completed and what the next step is.",
                estimatedMinutes: 45),
            DailyAction(id: "\(path.id)-4", dayNumber: 4, dayLabel: "Day 4 — Money",
                category: ActionCategory.money.rawValue,
                title: "Know Your Numbers",
                detail: "Look up the startup cost range for \(path.name): approximately \(path.startupCostRange). Write down what you have, what you need, and the single cheapest path to your first client. Use the Pricing Sheet in the Document Vault to draft your first offer.",
                estimatedMinutes: 30),
            DailyAction(id: "\(path.id)-5", dayNumber: 5, dayLabel: "Day 5 — Marketing",
                category: ActionCategory.marketing.rawValue,
                title: "Reach Out to One Person",
                detail: "Using the First Client Email Kit in the Document Vault, contact one of the 3 people you identified on Day 2. Send the Neighbor Approach or Referral Request email. The goal is not to get a client today — the goal is to start the conversation.",
                estimatedMinutes: 30),
            DailyAction(id: "\(path.id)-6", dayNumber: 6, dayLabel: "Day 6 — Skill Building",
                category: ActionCategory.skill.rawValue,
                title: "Build Your First Skill",
                detail: "Spend 60 minutes on your first learning step: \(step2). Write down 3 things you learned.",
                estimatedMinutes: 60),
            DailyAction(id: "\(path.id)-7", dayNumber: 7, dayLabel: "Day 7 — Review",
                category: ActionCategory.review.rawValue,
                title: "Your Week 1 Review",
                detail: "Look back at Days 1 through 6. What did you complete? What did you skip? Rate your readiness out of 10. Write one sentence about what Week 2 should focus on. Open your 90-Day Revenue Log and set your 90-day goal.",
                estimatedMinutes: 20)
        ]
        return WeeklyActionPlan(id: path.id, pathName: path.name, pathIcon: path.icon, actions: actions, generatedDate: Date())
    }

    static func generate(from trade: CareerPath) -> WeeklyActionPlan {
        let step1 = trade.basicSteps.first ?? "Research \(trade.title) programs in your area"
        let step2 = trade.basicSteps.dropFirst().first ?? "Contact a local training program or apprenticeship"
        let actions = [
            DailyAction(id: "\(trade.id)-1", dayNumber: 1, dayLabel: "Day 1 — Research",
                category: ActionCategory.research.rawValue,
                title: "Understand the Path",
                detail: "Spend 30 minutes learning about the \(trade.title) trade. Search YouTube for 'day in the life of a \(trade.title).' Write down 3 things that surprised you and whether they still excite you.",
                estimatedMinutes: 30),
            DailyAction(id: "\(trade.id)-2", dayNumber: 2, dayLabel: "Day 2 — Research",
                category: ActionCategory.research.rawValue,
                title: "Find Programs Near You",
                detail: step1,
                estimatedMinutes: 25),
            DailyAction(id: "\(trade.id)-3", dayNumber: 3, dayLabel: "Day 3 — Research",
                category: ActionCategory.research.rawValue,
                title: "Understand Licensing",
                detail: "Search for '\(trade.title) license requirements [your state]'. Write down the steps and time required. Open the Trade Toolkit in the app for your specific trade — it has the exact licensing information.",
                estimatedMinutes: 30),
            DailyAction(id: "\(trade.id)-4", dayNumber: 4, dayLabel: "Day 4 — Money",
                category: ActionCategory.money.rawValue,
                title: "Map the Finances",
                detail: "Research the cost to start: training program cost (\(trade.costRange)), tools, and time to first paycheck (\(trade.timeToComplete)). Write down how you will fund it — savings, financial aid via FAFSA, apprenticeship pay, or employer-sponsored training.",
                estimatedMinutes: 30),
            DailyAction(id: "\(trade.id)-5", dayNumber: 5, dayLabel: "Day 5 — Setup",
                category: ActionCategory.setup.rawValue,
                title: "Take Your First Real Step",
                detail: step2,
                estimatedMinutes: 20),
            DailyAction(id: "\(trade.id)-6", dayNumber: 6, dayLabel: "Day 6 — Skill Building",
                category: ActionCategory.skill.rawValue,
                title: "Start Learning",
                detail: "Spend 60 minutes watching beginner YouTube tutorials on the \(trade.title) trade. Search '\(trade.title) basics for beginners.' Take notes on terminology you did not know. This builds confidence before your first day.",
                estimatedMinutes: 60),
            DailyAction(id: "\(trade.id)-7", dayNumber: 7, dayLabel: "Day 7 — Review",
                category: ActionCategory.review.rawValue,
                title: "Commit or Pivot",
                detail: "After a week of research: are you more or less excited about \(trade.title) than on Day 1? If more excited — commit and take action from the Trade Toolkit 90-Day plan. If less excited — go back to your matches and explore your next option. Both answers are valid.",
                estimatedMinutes: 20)
        ]
        return WeeklyActionPlan(id: trade.id, pathName: trade.title, pathIcon: trade.icon, actions: actions, generatedDate: Date())
    }

    static func load(for pathId: String) -> WeeklyActionPlan? {
        guard let data = UserDefaults.standard.data(forKey: "actionPlan_\(pathId)") else { return nil }
        return try? JSONDecoder().decode(WeeklyActionPlan.self, from: data)
    }

    static func save(_ plan: WeeklyActionPlan) {
        if let data = try? JSONEncoder().encode(plan) {
            UserDefaults.standard.set(data, forKey: "actionPlan_\(plan.id)")
        }
    }
}
