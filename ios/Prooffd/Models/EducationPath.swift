import Foundation

nonisolated struct EducationPath: Identifiable, Codable, Sendable {
    let id: String
    let title: String
    let icon: String
    let category: EducationCategory
    let aiSafeScore: Int
    let overview: String
    let whyItWorksNow: String
    let futureDemand: String
    let typicalSalaryRange: String
    let prerequisites: [String]
    let testRequirements: [String]
    let deliveryType: String
    let timeToComplete: String
    let costRange: String
    let fundingOptions: [String]
    let howToFindPrograms: [String]
    let employerSponsoredOptions: [String]
    let militaryPath: String
    let basicSteps: [String]
    let proSteps: [String]
    let linkedJobIds: [String]

    var zone: AIZone { AIZone.from(score: aiSafeScore) }
    var aiSafeLabel: String { zone.label }

    init(
        id: String,
        title: String,
        icon: String,
        category: EducationCategory = .trade,
        aiSafeScore: Int,
        overview: String,
        whyItWorksNow: String = "",
        futureDemand: String = "",
        typicalSalaryRange: String,
        prerequisites: [String] = [],
        testRequirements: [String] = [],
        deliveryType: String = "In-person",
        timeToComplete: String,
        costRange: String,
        fundingOptions: [String],
        howToFindPrograms: [String] = [],
        employerSponsoredOptions: [String] = [],
        militaryPath: String = "",
        basicSteps: [String],
        proSteps: [String] = [],
        linkedJobIds: [String] = []
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.category = category
        self.aiSafeScore = aiSafeScore
        self.overview = overview
        self.whyItWorksNow = whyItWorksNow.isEmpty ? "Growing demand and worker shortages make this an excellent time to enter this field." : whyItWorksNow
        self.futureDemand = futureDemand.isEmpty ? "Strong outlook — demand is expected to grow over the next decade." : futureDemand
        self.typicalSalaryRange = typicalSalaryRange
        self.prerequisites = prerequisites.isEmpty ? ["High school diploma or equivalent (recommended)"] : prerequisites
        self.testRequirements = testRequirements
        self.deliveryType = deliveryType
        self.timeToComplete = timeToComplete
        self.costRange = costRange
        self.fundingOptions = fundingOptions
        self.howToFindPrograms = howToFindPrograms.isEmpty ? ["Search your state's workforce development website", "Check local community colleges", "Ask industry associations for accredited programs"] : howToFindPrograms
        self.employerSponsoredOptions = employerSponsoredOptions
        self.militaryPath = militaryPath
        self.basicSteps = basicSteps
        self.proSteps = proSteps.isEmpty ? Self.generateProSteps(title: title) : proSteps
        self.linkedJobIds = linkedJobIds
    }

    private static func generateProSteps(title: String) -> [String] {
        [
            "Research advanced certifications in \(title.lowercased())",
            "Build a professional network through industry associations",
            "Create a portfolio or track record of completed work",
            "Explore specialization opportunities for higher pay",
            "Develop a long-term career advancement plan"
        ]
    }
}

nonisolated enum EducationCategory: String, Codable, Sendable, CaseIterable, Identifiable {
    case trade = "Skilled Trade"
    case certification = "Certification"
    case healthcare = "Healthcare"
    case technology = "Technology"
    case business = "Business"
    case creative = "Creative"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .trade: return "wrench.and.screwdriver.fill"
        case .certification: return "checkmark.seal.fill"
        case .healthcare: return "cross.case.fill"
        case .technology: return "desktopcomputer"
        case .business: return "briefcase.fill"
        case .creative: return "paintbrush.fill"
        }
    }
}
