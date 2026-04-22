import Foundation

nonisolated struct ToolItem: Identifiable, Sendable {
    let id: String
    let name: String
    let costRange: String
    let isMustHave: Bool
    let canRent: Bool
}

nonisolated struct TradeToolkit: Identifiable, Sendable {
    let id: String
    let tradeName: String
    let tradeIcon: String
    let aiProofScore: Int
    let mustHaveTools: [ToolItem]
    let estimatedStarterKit: String
    let canRentNote: String
    let unionName: String
    let unionWebsite: String
    let unionBenefits: [String]
    let payDifference: String
    let howToJoin: String
    let nonUnionNote: String
    let licenseName: String
    let licenseAuthority: String
    let licenseCost: String
    let licenseStudyTime: String
    let licenseKeyTopics: [String]
    let licenseStateNote: String
    let ninetyDaySteps: [String]
}
