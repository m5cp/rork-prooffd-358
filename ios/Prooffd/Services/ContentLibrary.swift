import Foundation

enum ContentLibrary {
    static var allJobs: [BusinessPath] {
        BusinessPathDatabase.allPaths
    }

    static var allEducationPaths: [EducationPath] {
        EducationPathDatabase.all
    }

    static func job(byId id: String) -> BusinessPath? {
        allJobs.first { $0.id == id }
    }

    static func educationPath(byId id: String) -> EducationPath? {
        allEducationPaths.first { $0.id == id }
    }

    static func jobs(forCategory category: BusinessCategory) -> [BusinessPath] {
        allJobs.filter { $0.category == category }
    }

    static func jobs(inZone zone: AIZone) -> [BusinessPath] {
        allJobs.filter { $0.zone == zone }
    }

    static func jobs(matching query: String) -> [BusinessPath] {
        let q = query.lowercased()
        return allJobs.filter {
            $0.name.lowercased().contains(q) ||
            $0.overview.lowercased().contains(q) ||
            $0.category.rawValue.lowercased().contains(q) ||
            $0.interests.contains { $0.lowercased().contains(q) }
        }
    }

    static func linkedEducationPath(for job: BusinessPath) -> EducationPath? {
        guard !job.linkedEducationPathId.isEmpty else { return nil }
        return educationPath(byId: job.linkedEducationPathId)
    }

    static func linkedJobs(for educationPath: EducationPath) -> [BusinessPath] {
        allJobs.filter { educationPath.linkedJobIds.contains($0.id) }
    }

    static var jobCount: Int { allJobs.count }
    static var educationPathCount: Int { allEducationPaths.count }

    static var categoryCounts: [(BusinessCategory, Int)] {
        BusinessCategory.allCases.map { cat in
            (cat, allJobs.filter { $0.category == cat }.count)
        }
    }

    static var zoneCounts: [(AIZone, Int)] {
        AIZone.allCases.map { zone in
            (zone, allJobs.filter { $0.zone == zone }.count)
        }
    }

    static func freeContent(for job: BusinessPath) -> JobFreeContent {
        JobFreeContent(
            overview: job.overview,
            whyItWorksNow: job.whyItWorksNow,
            startupCostRange: job.startupCostRange,
            aiSafeScore: job.aiProofRating,
            zone: job.zone,
            category: job.category,
            typicalMarketRates: job.typicalMarketRates,
            matchScore: 0,
            freeActionPlan: job.freeActionPlan,
            educationSummary: job.educationRequired
        )
    }

    static func proContent(for job: BusinessPath) -> JobProContent {
        JobProContent(
            proLaunchPlan: job.proLaunchPlan,
            salesIntroScript: job.salesIntroScript,
            followUpScript: job.followUpScript,
            draftEmail: job.draftEmail,
            draftTextMessage: job.draftTextMessage,
            socialMediaPost: job.socialMediaPost,
            flyerCopy: job.flyerCopy,
            offerPricingSheet: job.offerPricingSheet,
            expandedBusinessPlan: job.expandedBusinessPlan,
            customerSources: job.customerSources,
            pricingTips: job.pricingTips,
            scalingTips: job.scalingTips,
            riskNotes: job.riskNotes,
            revenueProjections: job.revenueProjections
        )
    }
}

nonisolated struct JobFreeContent: Sendable {
    let overview: String
    let whyItWorksNow: String
    let startupCostRange: String
    let aiSafeScore: Int
    let zone: AIZone
    let category: BusinessCategory
    let typicalMarketRates: String
    let matchScore: Int
    let freeActionPlan: [String]
    let educationSummary: String
}

nonisolated struct JobProContent: Sendable {
    let proLaunchPlan: [String]
    let salesIntroScript: String
    let followUpScript: String
    let draftEmail: String
    let draftTextMessage: String
    let socialMediaPost: String
    let flyerCopy: String
    let offerPricingSheet: String
    let expandedBusinessPlan: String
    let customerSources: [String]
    let pricingTips: [String]
    let scalingTips: [String]
    let riskNotes: [String]
    let revenueProjections: String
}
