import Foundation

nonisolated enum AIProofTier: String, Sendable, CaseIterable, Identifiable {
    case tier1 = "Tier 1"
    case tier2 = "Tier 2"
    case tier3 = "Tier 3"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .tier1: return "Highly AI-Resistant"
        case .tier2: return "AI-Resistant"
        case .tier3: return "Moderately AI-Resistant"
        }
    }

    var icon: String {
        switch self {
        case .tier1: return "shield.checkered"
        case .tier2: return "shield.lefthalf.filled"
        case .tier3: return "shield"
        }
    }
}

nonisolated enum DegreeCareerCategory: String, Sendable, CaseIterable, Identifiable {
    case healthcare = "Healthcare"
    case mentalHealth = "Mental Health & Human Services"
    case engineering = "Engineering & Technical"
    case legal = "Legal, Regulatory & High Trust"
    case education = "Education & Specialized"
    case aviation = "Aviation & Advanced"
    case military = "Military & Leadership"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .healthcare: return "cross.case.fill"
        case .mentalHealth: return "brain.head.profile.fill"
        case .engineering: return "gearshape.2.fill"
        case .legal: return "building.columns.fill"
        case .education: return "book.fill"
        case .aviation: return "airplane"
        case .military: return "shield.checkered"
        }
    }
}

nonisolated struct DegreeCareerRecord: Identifiable, Sendable {
    let id: String
    let title: String
    let icon: String
    let category: DegreeCareerCategory
    let opportunityTrack: CareerTrack
    let aiProofTier: AIProofTier
    let degreeRequired: String
    let timeline: String
    let licensingRequired: Bool
    let salaryEarly: String
    let salaryExperienced: String
    let aiProofReasons: [String]
    let prerequisites: [String]
    let trainingPath: String
    let demandNotes: String
    let bestFitTraits: [String]
}

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
