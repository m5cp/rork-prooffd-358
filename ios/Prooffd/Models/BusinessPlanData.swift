import Foundation

nonisolated struct BusinessPlanData: Sendable {
    let pathId: String
    let mission: String
    let vision: String
    let problemPoints: [String]
    let solutionPoints: [String]
    let primaryCustomer: String
    let secondaryCustomer: String
    let demographics: String
    let psychographics: String
    let buyingMotivations: [String]
    let serviceArea: String
    let revenueStreams: [String]
    let upsells: [String]
    let pricingNotes: String
    let startupCostItemsEssential: [(String, String)]
    let startupCostItemsOptional: [(String, String)]
    let equipment: [String]
    let tools: [String]
    let software: [String]
    let vehicleNeeds: String
    let workspaceNeeds: String
    let legalStructureRecommendation: String
    let licensesAndPermits: [String]
    let insuranceNeeds: [String]
    let operationsDaily: [String]
    let schedulingWorkflow: String
    let customerWorkflow: String
    let followUpWorkflow: String
    let marketingChannels: [String]
    let acquisitionStrategies: [String]
    let referralStrategies: [String]
    let partnershipIdeas: [String]
    let socialProofStrategies: [String]
    let salesProcess: [String]
    let salesTips: [String]
    let objectionHandling: [(String, String)]
    let monthlyRevenueStarter: String
    let monthlyRevenueModerate: String
    let monthlyRevenueStrong: String
    let estimatedMonthlyExpensesStarter: String
    let estimatedMonthlyExpensesModerate: String
    let financialAssumptions: [String]
    let hiringPath: [String]
    let scalingPath: [String]
    let expansionIdeas: [String]
    let riskFactors: [String]
    let difficultyNotes: String
    let viabilityNotes: String
    let launchSteps30Days: [String]
    let launchSteps60Days: [String]
    let launchSteps90Days: [String]
    let fitSummary: String
    let bestFor: [String]
}
