import Foundation

nonisolated struct BusinessPath: Identifiable, Codable, Sendable {
    let id: String
    let name: String
    let icon: String
    let category: BusinessCategory
    let overview: String
    let startupCostRange: String
    let timeToFirstDollar: String
    let customerType: String
    let aiProofRating: Int
    let educationRequired: String
    let actionPlan: [String]
    let starterPricing: String
    let outreachTemplate: String
    let socialMediaPost: String
    let revenueProjections: String
    let draftEmail: String
    let draftTextMessage: String
    let salesIntroScript: String
    let followUpScript: String
    let flyerCopy: String
    let offerPricingSheet: String
    let expandedBusinessPlan: String
    let requiresCar: Bool
    let requiresPhysicalWork: Bool
    let requiresSelling: Bool
    let isDigital: Bool
    let soloFriendly: Bool
    let fastCashPotential: Bool
    let minBudget: Int
    let minHoursPerDay: Double
    let workConditions: [WorkCondition]
    let minTechLevel: Int
    let minExperienceLevel: Int
    let customerInteractionLevel: String
}

nonisolated struct MatchResult: Identifiable, Sendable {
    let id: String
    let businessPath: BusinessPath
    let score: Double
    let scorePercentage: Int
}
