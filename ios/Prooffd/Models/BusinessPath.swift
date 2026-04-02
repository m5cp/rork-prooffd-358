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

    var zone: AIZone { AIZone.from(score: aiProofRating) }
    var aiSafeLabel: String { zone.label }

    var inferredWorkEnvironments: [WorkEnvironment] {
        var envs: [WorkEnvironment] = []
        if isDigital && soloFriendly { envs.append(.homeBased) }
        if isDigital { envs.append(.officeDesk) }
        if requiresCar { envs.append(.onTheRoad) }
        if requiresPhysicalWork && !isDigital {
            let catStr = category.rawValue.lowercased()
            if catStr.contains("outdoor") || catStr.contains("landscape") {
                envs.append(.outdoors)
            }
            if catStr.contains("home") || catStr.contains("property") {
                envs.append(.clientLocation)
            }
            if catStr.contains("skilled") || catStr.contains("auto") {
                envs.append(.warehouse)
            }
            if catStr.contains("event") {
                envs.append(.clientLocation)
            }
        }
        if category == .foodBeverage {
            envs.append(.clientLocation)
            if !isDigital { envs.append(.homeBased) }
        }
        if category == .petServices {
            envs.append(.clientLocation)
            envs.append(.outdoors)
        }
        if category == .personalCare {
            envs.append(.clientLocation)
        }
        if category == .productCraft {
            envs.append(.homeBased)
        }
        if category == .eventsEntertainment {
            envs.append(.clientLocation)
        }
        if category == .skilledTrades {
            envs.append(.constructionSite)
            envs.append(.clientLocation)
        }
        if envs.isEmpty {
            envs.append(.clientLocation)
        }
        return Array(Set(envs))
    }

    let whyItWorksNow: String
    let entryPath: String
    let difficultyLevel: String
    let typicalMarketRates: String
    let freeActionPlan: [String]
    let proLaunchPlan: [String]
    let customerSources: [String]
    let pricingTips: [String]
    let scalingTips: [String]
    let riskNotes: [String]
    let suggestedServices: [String]
    let suggestedBusinessName: String
    let todayStepTemplates: [String]
    let linkedEducationPathId: String
    let interests: [String]
    let startupCostMin: Int
    let startupCostMax: Int
    let llcInfo: LLCInfo
    let degreeRequirement: String
    var requiresLicense: Bool
    var incomeLevel: IncomeLevel
    var demandLevel: DemandLevel
    var categoryTier: CategoryTier
    var isFastStart: Bool
    var isScalable: Bool
    var alignedInterests: [String]

    init(
        id: String,
        name: String,
        icon: String,
        category: BusinessCategory,
        overview: String,
        startupCostRange: String,
        timeToFirstDollar: String,
        customerType: String,
        aiProofRating: Int,
        educationRequired: String,
        actionPlan: [String],
        starterPricing: String,
        outreachTemplate: String,
        socialMediaPost: String,
        revenueProjections: String,
        draftEmail: String,
        draftTextMessage: String,
        salesIntroScript: String,
        followUpScript: String,
        flyerCopy: String,
        offerPricingSheet: String,
        expandedBusinessPlan: String,
        requiresCar: Bool,
        requiresPhysicalWork: Bool,
        requiresSelling: Bool,
        isDigital: Bool,
        soloFriendly: Bool,
        fastCashPotential: Bool,
        minBudget: Int,
        minHoursPerDay: Double,
        workConditions: [WorkCondition],
        minTechLevel: Int,
        minExperienceLevel: Int,
        customerInteractionLevel: String,
        whyItWorksNow: String = "",
        entryPath: String = "",
        difficultyLevel: String = "Beginner",
        typicalMarketRates: String = "",
        freeActionPlan: [String] = [],
        proLaunchPlan: [String] = [],
        customerSources: [String] = [],
        pricingTips: [String] = [],
        scalingTips: [String] = [],
        riskNotes: [String] = [],
        suggestedServices: [String] = [],
        suggestedBusinessName: String = "",
        todayStepTemplates: [String] = [],
        linkedEducationPathId: String = "",
        interests: [String] = [],
        startupCostMin: Int = 0,
        startupCostMax: Int = 0,
        llcInfo: LLCInfo = .optional,
        degreeRequirement: String = "",
        requiresLicense: Bool = false,
        incomeLevel: IncomeLevel = .medium,
        demandLevel: DemandLevel = .medium,
        categoryTier: CategoryTier = .standard,
        isFastStart: Bool = false,
        isScalable: Bool = false,
        alignedInterests: [String] = []
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.category = category
        self.overview = overview
        self.startupCostRange = startupCostRange
        self.timeToFirstDollar = timeToFirstDollar
        self.customerType = customerType
        self.aiProofRating = aiProofRating
        self.educationRequired = educationRequired
        self.actionPlan = actionPlan
        self.starterPricing = starterPricing
        self.outreachTemplate = outreachTemplate
        self.socialMediaPost = socialMediaPost
        self.revenueProjections = revenueProjections
        self.draftEmail = draftEmail
        self.draftTextMessage = draftTextMessage
        self.salesIntroScript = salesIntroScript
        self.followUpScript = followUpScript
        self.flyerCopy = flyerCopy
        self.offerPricingSheet = offerPricingSheet
        self.expandedBusinessPlan = expandedBusinessPlan
        self.requiresCar = requiresCar
        self.requiresPhysicalWork = requiresPhysicalWork
        self.requiresSelling = requiresSelling
        self.isDigital = isDigital
        self.soloFriendly = soloFriendly
        self.fastCashPotential = fastCashPotential
        self.minBudget = minBudget
        self.minHoursPerDay = minHoursPerDay
        self.workConditions = workConditions
        self.minTechLevel = minTechLevel
        self.minExperienceLevel = minExperienceLevel
        self.customerInteractionLevel = customerInteractionLevel
        self.whyItWorksNow = whyItWorksNow.isEmpty ? Self.generateWhyItWorksNow(name: name, category: category) : whyItWorksNow
        self.entryPath = entryPath.isEmpty ? Self.generateEntryPath(educationRequired: educationRequired) : entryPath
        self.difficultyLevel = difficultyLevel
        self.typicalMarketRates = typicalMarketRates.isEmpty ? starterPricing : typicalMarketRates
        self.freeActionPlan = freeActionPlan.isEmpty ? Array(actionPlan.prefix(5)) : freeActionPlan
        self.proLaunchPlan = proLaunchPlan.isEmpty ? Self.generateProLaunchPlan(name: name) : proLaunchPlan
        self.customerSources = customerSources.isEmpty ? Self.generateCustomerSources(isDigital: isDigital) : customerSources
        self.pricingTips = pricingTips.isEmpty ? Self.generatePricingTips() : pricingTips
        self.scalingTips = scalingTips.isEmpty ? Self.generateScalingTips(name: name) : scalingTips
        self.riskNotes = riskNotes.isEmpty ? Self.generateRiskNotes(category: category) : riskNotes
        self.suggestedServices = suggestedServices.isEmpty ? Self.generateSuggestedServices(name: name, category: category) : suggestedServices
        self.suggestedBusinessName = suggestedBusinessName.isEmpty ? Self.generateBusinessName(name: name) : suggestedBusinessName
        self.todayStepTemplates = todayStepTemplates.isEmpty ? Self.generateTodaySteps(name: name) : todayStepTemplates
        self.linkedEducationPathId = linkedEducationPathId
        self.interests = interests.isEmpty ? [category.rawValue] : interests
        self.startupCostMin = startupCostMin > 0 ? startupCostMin : minBudget
        self.startupCostMax = startupCostMax > 0 ? startupCostMax : minBudget * 3
        self.llcInfo = llcInfo
        self.degreeRequirement = degreeRequirement.isEmpty ? Self.generateDegreeRequirement(educationRequired: educationRequired, category: category) : degreeRequirement
        self.requiresLicense = requiresLicense
        self.incomeLevel = incomeLevel
        self.demandLevel = demandLevel
        self.categoryTier = categoryTier
        self.isFastStart = isFastStart
        self.isScalable = isScalable
        self.alignedInterests = alignedInterests
    }

    private static func generateWhyItWorksNow(name: String, category: BusinessCategory) -> String {
        switch category {
        case .homeProperty: return "Growing demand for home services as homeowners invest in property maintenance. Local, hands-on work that remote workers and AI cannot replace."
        case .autoTransport: return "Vehicle ownership remains essential. Mobile convenience services are in high demand as people value their time more than ever."
        case .outdoorLandscape: return "Outdoor maintenance is non-negotiable for property owners. Climate patterns increase demand for year-round landscape management."
        case .foodBeverage: return "Food is recession-proof. Demand for convenient, personalized food services continues to grow as people seek alternatives to chain restaurants."
        case .petServices: return "Pet ownership is at an all-time high. Pet owners spend more than ever on services, creating a growing market for reliable providers."
        case .personalCare: return "Personal services require human touch and trust. Growing demand for mobile and convenient care options creates opportunities."
        case .digitalCreative: return "Every business needs an online presence. Small businesses increasingly outsource digital work to freelancers and specialists."
        case .productCraft: return "Consumers value handmade, unique products. Online marketplaces make it easier than ever to reach buyers worldwide."
        case .eventsEntertainment: return "Events and celebrations are rebounding strongly. People are willing to spend more on memorable experiences and professional services."
        case .skilledTrades: return "Skilled trades face a massive worker shortage. Demand far exceeds supply, driving up rates and creating opportunities for new entrants."
        }
    }

    private static func generateEntryPath(educationRequired: String) -> String {
        if educationRequired == "None" {
            return "No formal education required. Start immediately with basic skills and learn on the job."
        }
        return educationRequired
    }

    private static func generateProLaunchPlan(name: String) -> [String] {
        [
            "Day 1: Finalize your business name and set up a Google Business Profile",
            "Day 2: Create your pricing sheet and service packages",
            "Day 3: Draft outreach messages and post on 3 local community groups",
            "Day 4: Reach out to 10 potential customers directly",
            "Day 5: Follow up on all leads and book your first appointment",
            "Day 6: Complete your first job and ask for a review",
            "Day 7: Post before/after content and refine your process"
        ]
    }

    private static func generateCustomerSources(isDigital: Bool) -> [String] {
        if isDigital {
            return [
                "Freelance platforms (Upwork, Fiverr)",
                "Social media (Instagram, LinkedIn)",
                "Direct email outreach",
                "Referrals from existing clients",
                "Online communities and forums"
            ]
        }
        return [
            "Facebook groups and Nextdoor",
            "Door-to-door canvassing",
            "Google Business Profile",
            "Referrals from satisfied clients",
            "Local community boards and Craigslist"
        ]
    }

    private static func generatePricingTips() -> [String] {
        [
            "Start slightly below market rate to build reviews quickly",
            "Raise prices 10-20% once you have 5+ positive reviews",
            "Offer package deals for recurring services",
            "Add premium tiers for customers willing to pay more"
        ]
    }

    private static func generateScalingTips(name: String) -> [String] {
        [
            "Build a referral system — offer discounts for client introductions",
            "Create repeatable processes to handle more volume",
            "Consider hiring part-time help when demand exceeds your capacity",
            "Expand your service area gradually as you build reputation"
        ]
    }

    private static func generateRiskNotes(category: BusinessCategory) -> [String] {
        var notes = ["Pricing varies by location and local market demand"]
        switch category {
        case .homeProperty, .skilledTrades:
            notes.append("Consider liability insurance before taking on larger jobs")
            notes.append("Weather and seasonality may affect demand")
        case .foodBeverage:
            notes.append("Check local health department and cottage food laws")
            notes.append("Food spoilage is a cost factor — start small to minimize waste")
        case .digitalCreative:
            notes.append("Client acquisition can be slow initially — persistence is key")
            notes.append("AI tools may change the landscape — stay adaptable")
        default:
            notes.append("Research local licensing requirements before starting")
        }
        return notes
    }

    private static func generateSuggestedServices(name: String, category: BusinessCategory) -> [String] {
        switch category {
        case .homeProperty: return [name, "General maintenance add-ons", "Seasonal service packages"]
        case .autoTransport: return [name, "Interior detailing add-on", "Fleet service packages"]
        case .outdoorLandscape: return [name, "Seasonal cleanup", "Mulching and planting"]
        case .foodBeverage: return [name, "Custom orders", "Event catering"]
        case .petServices: return [name, "Pet sitting add-on", "Grooming packages"]
        case .personalCare: return [name, "Mobile service premium", "Group booking discounts"]
        case .digitalCreative: return [name, "Monthly retainer packages", "Rush delivery premium"]
        case .productCraft: return [name, "Custom orders", "Gift sets and bundles"]
        case .eventsEntertainment: return [name, "Premium packages", "Add-on services"]
        case .skilledTrades: return [name, "Emergency service premium", "Maintenance contracts"]
        }
    }

    private static func generateBusinessName(name: String) -> String {
        let words = name.components(separatedBy: " ")
        if let first = words.first {
            return "[Your Name]'s \(first) Pro"
        }
        return "[Your Name]'s \(name)"
    }

    private static func generateTodaySteps(name: String) -> [String] {
        [
            "Research 3 competitors in your area for \(name.lowercased())",
            "Post your first offer in a local Facebook group",
            "Create a simple pricing sheet for your services",
            "Reach out to 5 people who might need \(name.lowercased())",
            "Set up a Google Business Profile for local visibility",
            "Take before/after photos of your first completed job",
            "Ask your first client for a review or testimonial",
            "Follow up with all leads from this week",
            "Create a social media post showcasing your work",
            "Book your next 3 appointments"
        ]
    }
}

nonisolated struct LLCInfo: Codable, Sendable {
    let requirement: LLCRequirement
    let explanation: String
    let costWithoutLLC: String
    let costWithLLC: String

    static let optional = LLCInfo(
        requirement: .optional,
        explanation: "An LLC is optional for gig or freelance work. You can operate as a sole proprietor. However, an LLC provides liability protection and may look more professional to clients.",
        costWithoutLLC: "$0 (operate as sole proprietor)",
        costWithLLC: "$50–$500+ (varies by state)"
    )

    static let recommended = LLCInfo(
        requirement: .recommended,
        explanation: "An LLC is recommended if you plan to operate independently. It separates your personal assets from business liabilities. If working for an employer, no LLC is needed.",
        costWithoutLLC: "$0 (work as employee or sole proprietor)",
        costWithLLC: "$50–$500+ (varies by state)"
    )

    static let requiredForIndependent = LLCInfo(
        requirement: .requiredIfIndependent,
        explanation: "An LLC is strongly recommended if operating independently or starting your own business. Not needed if employed by a company or union. Provides liability protection and tax benefits.",
        costWithoutLLC: "$0 (work as employee)",
        costWithLLC: "$50–$500+ (varies by state, plus registered agent fees)"
    )

    static let notNeeded = LLCInfo(
        requirement: .notNeeded,
        explanation: "No LLC needed if working as an employee. If you eventually start your own practice or business, consider forming one at that time.",
        costWithoutLLC: "$0",
        costWithLLC: "N/A"
    )
}

nonisolated enum LLCRequirement: String, Codable, Sendable {
    case notNeeded = "Not Needed"
    case optional = "Optional"
    case recommended = "Recommended"
    case requiredIfIndependent = "Required if Independent"
}

extension BusinessPath {
    static func generateDegreeRequirement(educationRequired: String, category: BusinessCategory) -> String {
        let edu = educationRequired.lowercased()
        if edu.contains("none") || edu.contains("no ") {
            return "No degree required. Learn through practice, online tutorials, and on-the-job experience."
        }
        if edu.contains("certification") || edu.contains("cert") {
            return "Online certification available. No degree required, but certification improves credibility."
        }
        if edu.contains("apprenticeship") {
            return "Apprenticeship required. Typically 2–5 years of supervised training. No college degree needed."
        }
        if edu.contains("trade school") {
            return "Trade school or vocational program. Typically 6 months to 2 years. No 4-year degree needed."
        }
        if edu.contains("license") {
            return "State licensing required. Complete required coursework and pass licensing exam. No 4-year degree needed."
        }
        return "No formal degree required. Skills can be self-taught or learned through short courses."
    }

    static func generateLLCInfo(for category: BusinessCategory, isGig: Bool) -> LLCInfo {
        if isGig {
            return .optional
        }
        switch category {
        case .skilledTrades:
            return .requiredForIndependent
        case .homeProperty, .autoTransport, .outdoorLandscape:
            return .recommended
        case .foodBeverage:
            return LLCInfo(
                requirement: .recommended,
                explanation: "An LLC is recommended for food businesses for liability protection. Check local health department requirements and cottage food laws in your area.",
                costWithoutLLC: "$0 (sole proprietor with permits)",
                costWithLLC: "$50–$500+ (varies by state)"
            )
        case .digitalCreative, .productCraft:
            return .optional
        case .personalCare, .petServices, .eventsEntertainment:
            return .recommended
        }
    }
}

nonisolated struct MatchResult: Identifiable, Sendable {
    let id: String
    let businessPath: BusinessPath
    let score: Double
    let scorePercentage: Int
}
