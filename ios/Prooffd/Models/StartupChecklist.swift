import Foundation

nonisolated struct StartupChecklistItem: Identifiable, Sendable {
    let id: String
    let title: String
    let icon: String
    let isUniversal: Bool
}

nonisolated struct PricingTier: Sendable {
    let label: String
    let range: String
    let description: String
}

nonisolated struct BusinessStartupContent: Sendable {
    let universalChecklist: [StartupChecklistItem]
    let pathSpecificChecklist: [StartupChecklistItem]
    let pricingTiers: [PricingTier]
    let toolsAndEquipment: [String]
    let licensesAndPermits: [String]
    let launchSteps: [String]
    let marketingChannels: [String]
    let customerAcquisition: [String]
    let bookkeepingBasics: [String]
}

enum BusinessStartupContentBuilder {
    static let universalChecklist: [StartupChecklistItem] = [
        StartupChecklistItem(id: "name", title: "Choose a business name", icon: "character.cursor.ibeam", isUniversal: true),
        StartupChecklistItem(id: "domain", title: "Buy a domain name", icon: "globe", isUniversal: true),
        StartupChecklistItem(id: "email", title: "Create a professional business email", icon: "envelope.fill", isUniversal: true),
        StartupChecklistItem(id: "website", title: "Set up a simple website or booking page", icon: "safari.fill", isUniversal: true),
        StartupChecklistItem(id: "register", title: "Register your business if appropriate", icon: "building.2.fill", isUniversal: true),
        StartupChecklistItem(id: "ein", title: "Get an EIN (Employer Identification Number) if needed", icon: "number", isUniversal: true),
        StartupChecklistItem(id: "bank", title: "Open a business bank account", icon: "banknote.fill", isUniversal: true),
        StartupChecklistItem(id: "card", title: "Get a business debit or credit card", icon: "creditcard.fill", isUniversal: true),
        StartupChecklistItem(id: "bookkeeping", title: "Set up bookkeeping and expense tracking", icon: "chart.bar.doc.horizontal.fill", isUniversal: true),
        StartupChecklistItem(id: "tax", title: "Understand your state and local tax obligations", icon: "doc.text.fill", isUniversal: true),
        StartupChecklistItem(id: "branding", title: "Create branding basics (colors, fonts, style)", icon: "paintpalette.fill", isUniversal: true),
        StartupChecklistItem(id: "logo", title: "Create a logo or visual identity", icon: "sparkles.rectangle.stack.fill", isUniversal: true),
        StartupChecklistItem(id: "ads", title: "Set up advertising and social media channels", icon: "megaphone.fill", isUniversal: true),
        StartupChecklistItem(id: "intake", title: "Create a customer intake and booking workflow", icon: "person.crop.rectangle.fill", isUniversal: true),
        StartupChecklistItem(id: "invoice", title: "Set up invoicing and payment collection", icon: "dollarsign.circle.fill", isUniversal: true),
        StartupChecklistItem(id: "insurance", title: "Get business insurance if needed", icon: "shield.checkered", isUniversal: true),
    ]

    static func build(for path: BusinessPath) -> BusinessStartupContent {
        let planData = BusinessPlanDatabase.lookup(path.id)

        let pathSpecific = buildPathSpecificChecklist(for: path, data: planData)
        let pricing = buildPricingTiers(for: path, data: planData)
        let tools = buildToolsAndEquipment(for: path, data: planData)
        let licenses = buildLicensesAndPermits(for: path, data: planData)
        let launch = buildLaunchSteps(for: path, data: planData)
        let marketing = buildMarketingChannels(for: path, data: planData)
        let acquisition = buildCustomerAcquisition(for: path, data: planData)
        let bookkeeping = buildBookkeepingBasics(for: path)

        return BusinessStartupContent(
            universalChecklist: universalChecklist,
            pathSpecificChecklist: pathSpecific,
            pricingTiers: pricing,
            toolsAndEquipment: tools,
            licensesAndPermits: licenses,
            launchSteps: launch,
            marketingChannels: marketing,
            customerAcquisition: acquisition,
            bookkeepingBasics: bookkeeping
        )
    }

    private static func buildPathSpecificChecklist(for path: BusinessPath, data: BusinessPlanData?) -> [StartupChecklistItem] {
        var items: [StartupChecklistItem] = []

        if let data, !data.licensesAndPermits.isEmpty {
            items.append(StartupChecklistItem(id: "licenses", title: "Obtain required licenses and permits", icon: "checkmark.seal.fill", isUniversal: false))
        } else if path.requiresLicense {
            items.append(StartupChecklistItem(id: "licenses", title: "Obtain required licenses and permits", icon: "checkmark.seal.fill", isUniversal: false))
        }

        if let data, !data.insuranceNeeds.isEmpty {
            items.append(StartupChecklistItem(id: "spec-insurance", title: "Get industry-specific insurance coverage", icon: "shield.fill", isUniversal: false))
        }

        if let data, !data.equipment.isEmpty {
            items.append(StartupChecklistItem(id: "equipment", title: "Purchase essential equipment and tools", icon: "wrench.and.screwdriver.fill", isUniversal: false))
        }

        if let data, !data.vehicleNeeds.isEmpty, data.vehicleNeeds.lowercased().contains("truck") || data.vehicleNeeds.lowercased().contains("van") || data.vehicleNeeds.lowercased().contains("vehicle") {
            items.append(StartupChecklistItem(id: "vehicle", title: "Arrange a work vehicle if needed", icon: "car.fill", isUniversal: false))
        } else if path.requiresCar {
            items.append(StartupChecklistItem(id: "vehicle", title: "Arrange reliable transportation", icon: "car.fill", isUniversal: false))
        }

        let careerType = SmartCareerBrain.classifyPath(path)
        if careerType == .foodPermitBased {
            items.append(StartupChecklistItem(id: "food-safety", title: "Complete food safety training and get permits", icon: "fork.knife", isUniversal: false))
        }

        if path.requiresPhysicalWork {
            items.append(StartupChecklistItem(id: "safety", title: "Get safety gear and protective equipment", icon: "helmet.fill", isUniversal: false))
        }

        return items
    }

    private static func buildPricingTiers(for path: BusinessPath, data: BusinessPlanData?) -> [PricingTier] {
        if let data {
            var tiers: [PricingTier] = []
            if !data.monthlyRevenueStarter.isEmpty {
                tiers.append(PricingTier(label: "Starter", range: data.monthlyRevenueStarter, description: "Part-time or just getting started"))
            }
            if !data.monthlyRevenueModerate.isEmpty {
                tiers.append(PricingTier(label: "Mid-Range", range: data.monthlyRevenueModerate, description: "Full-time, steady client base"))
            }
            if !data.monthlyRevenueStrong.isEmpty {
                tiers.append(PricingTier(label: "Premium", range: data.monthlyRevenueStrong, description: "Scaled with team or contracts"))
            }
            if !tiers.isEmpty { return tiers }
        }

        return [
            PricingTier(label: "Getting Started", range: path.starterPricing, description: "Typical entry-level pricing for this service")
        ]
    }

    private static func buildToolsAndEquipment(for path: BusinessPath, data: BusinessPlanData?) -> [String] {
        if let data {
            var items: [String] = []
            items.append(contentsOf: data.equipment)
            items.append(contentsOf: data.tools)
            if !data.software.isEmpty {
                items.append(contentsOf: data.software.map { "Software: \($0)" })
            }
            if !items.isEmpty { return items }
        }
        return []
    }

    private static func buildLicensesAndPermits(for path: BusinessPath, data: BusinessPlanData?) -> [String] {
        if let data, !data.licensesAndPermits.isEmpty {
            return data.licensesAndPermits
        }
        if path.requiresLicense {
            return ["Check state and local licensing requirements for \(path.name)"]
        }
        return []
    }

    private static func buildLaunchSteps(for path: BusinessPath, data: BusinessPlanData?) -> [String] {
        if let data {
            var steps: [String] = []
            steps.append(contentsOf: data.launchSteps30Days.map { "Days 1–30: \($0)" })
            steps.append(contentsOf: data.launchSteps60Days.map { "Days 31–60: \($0)" })
            steps.append(contentsOf: data.launchSteps90Days.map { "Days 61–90: \($0)" })
            if !steps.isEmpty { return steps }
        }
        return SmartCareerBrain.smartActionPlan(for: path)
    }

    private static func buildMarketingChannels(for path: BusinessPath, data: BusinessPlanData?) -> [String] {
        if let data, !data.marketingChannels.isEmpty {
            return data.marketingChannels
        }
        return path.customerSources
    }

    private static func buildCustomerAcquisition(for path: BusinessPath, data: BusinessPlanData?) -> [String] {
        if let data, !data.acquisitionStrategies.isEmpty {
            var strategies: [String] = []
            strategies.append(contentsOf: data.acquisitionStrategies)
            strategies.append(contentsOf: data.referralStrategies)
            return strategies
        }
        return path.customerSources
    }

    private static func buildBookkeepingBasics(for path: BusinessPath) -> [String] {
        var items = [
            "Track all income and expenses from day one",
            "Keep business and personal finances separate",
            "Save 25–30% of revenue for taxes",
            "Use accounting software like QuickBooks, Wave, or FreshBooks",
            "Understand your quarterly estimated tax obligations",
            "Keep receipts for all business purchases",
            "Track mileage if you drive for business"
        ]

        if path.requiresCar {
            items.append("Log mileage for vehicle tax deductions")
        }

        let careerType = SmartCareerBrain.classifyPath(path)
        switch careerType {
        case .foodPermitBased:
            items.append("Track food costs and waste separately for accurate margins")
        case .skilledTrade, .generalService:
            items.append("Track material costs per job for accurate pricing")
        case .digitalService, .creativeFreelance:
            items.append("Track software subscriptions and tool costs")
        default:
            break
        }

        return items
    }
}
