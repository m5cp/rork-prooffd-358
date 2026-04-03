import Foundation

nonisolated struct DegreeCareerDetailData: Sendable {
    let pathId: String
    let degreeRequired: String
    let degreeDetail: String
    let educationTimeline: String
    let timelineDetail: String
    let prerequisites: [String]
    let licensingExamPath: [String]
    let clinicalRequirements: [String]
    let earlyCareerPay: String
    let establishedCareerPay: String
    let longTermUpside: String
    let aiResistantReasons: [String]
    let demandStability: String
    let bestFitSummary: String
}
