import Foundation

enum BusinessPlanDatabase {
    static func lookup(_ pathId: String) -> BusinessPlanData? {
        allPlans[pathId]
    }

    static let allPlans: [String: BusinessPlanData] = {
        var plans: [String: BusinessPlanData] = [:]
        for plan in tradesPlans + serviceBusinessPlans + digitalPlans + sideHustlePlans {
            plans[plan.pathId] = plan
        }
        return plans
    }()
}
