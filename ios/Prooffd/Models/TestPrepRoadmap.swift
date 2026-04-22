import Foundation

nonisolated struct StudyPhase: Identifiable, Sendable {
    let id: String
    let weekRange: String
    let title: String
    let description: String
    let hoursPerWeek: Int
}

nonisolated struct TestPrepRoadmap: Identifiable, Sendable {
    let id: String
    let examName: String
    let icon: String
    let whoNeedsIt: String
    let registrationURL: String
    let typicalCost: String
    let scoreRange: String
    let targetScores: String
    let format: String
    let studyPhases: [StudyPhase]
    let freeResources: [String]
    let paidResources: [String]
    let retakePolicy: String
}
