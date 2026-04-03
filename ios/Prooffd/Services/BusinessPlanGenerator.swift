import Foundation

nonisolated struct BusinessPlanSection: Sendable {
    let number: String
    let title: String
    let icon: String
    let content: [BusinessPlanLine]
}

nonisolated enum BusinessPlanLineStyle: Sendable {
    case body
    case bold
    case bullet
    case financial(label: String, value: String)
    case placeholder
}

nonisolated struct BusinessPlanLine: Sendable {
    let text: String
    let style: BusinessPlanLineStyle
}

enum BusinessPlanGenerator {
    static func generate(for path: BusinessPath) -> [BusinessPlanSection] {
        if let data = BusinessPlanDatabase.lookup(path.id) {
            return generateFromStructuredData(path: path, data: data)
        }
        return generateFallback(for: path)
    }

    private static func generateFromStructuredData(path: BusinessPath, data: BusinessPlanData) -> [BusinessPlanSection] {
        [
            executiveSummarySection(path: path, data: data),
            marketProblemSection(data: data),
            solutionSection(path: path, data: data),
            targetMarketSection(data: data),
            businessModelSection(path: path, data: data),
            startupRequirementsSection(path: path, data: data),
            startupCostBreakdownSection(data: data),
            operationsPlanSection(data: data),
            marketingSection(data: data),
            salesStrategySection(data: data),
            financialProjectionsSection(path: path, data: data),
            growthStrategySection(data: data),
            riskFactorsSection(data: data),
            launchRoadmapSection(data: data),
            fitSummarySection(data: data)
        ]
    }

    private static func executiveSummarySection(path: BusinessPath, data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: path.name, style: .bold))
        lines.append(BusinessPlanLine(text: "Legal Structure: \(data.legalStructureRecommendation)", style: .body))
        lines.append(BusinessPlanLine(text: "Location: \(data.serviceArea)", style: .body))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: path.overview, style: .body))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Mission: \(data.mission)", style: .body))
        lines.append(BusinessPlanLine(text: "Vision: \(data.vision)", style: .body))
        return BusinessPlanSection(number: "01", title: "Executive Summary", icon: "building.2.fill", content: lines)
    }

    private static func marketProblemSection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        for point in data.problemPoints {
            lines.append(BusinessPlanLine(text: point, style: .bullet))
        }
        return BusinessPlanSection(number: "02", title: "Market Problem", icon: "exclamationmark.triangle.fill", content: lines)
    }

    private static func solutionSection(path: BusinessPath, data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        for point in data.solutionPoints {
            lines.append(BusinessPlanLine(text: point, style: .bullet))
        }
        if path.aiProofRating >= 85 {
            lines.append(BusinessPlanLine(text: "", style: .body))
            lines.append(BusinessPlanLine(text: "Competitive Edge: AI-resistant service rated \(path.aiProofRating)/100 — cannot be easily automated or outsourced.", style: .bold))
        }
        return BusinessPlanSection(number: "03", title: "Service Solution", icon: "lightbulb.fill", content: lines)
    }

    private static func targetMarketSection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: "Primary Customer:", style: .bold))
        lines.append(BusinessPlanLine(text: data.primaryCustomer, style: .body))
        lines.append(BusinessPlanLine(text: "Secondary Customer:", style: .bold))
        lines.append(BusinessPlanLine(text: data.secondaryCustomer, style: .body))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Demographics: \(data.demographics)", style: .body))
        lines.append(BusinessPlanLine(text: "Psychographics: \(data.psychographics)", style: .body))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Buying Motivations:", style: .bold))
        for motivation in data.buyingMotivations {
            lines.append(BusinessPlanLine(text: motivation, style: .bullet))
        }
        return BusinessPlanSection(number: "04", title: "Target Market", icon: "person.3.fill", content: lines)
    }

    private static func businessModelSection(path: BusinessPath, data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: "Revenue Streams:", style: .bold))
        for stream in data.revenueStreams {
            lines.append(BusinessPlanLine(text: stream, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Startup Investment", style: .financial(label: "Startup Investment", value: path.startupCostRange)))
        lines.append(BusinessPlanLine(text: "Time to Revenue", style: .financial(label: "Time to Revenue", value: path.timeToFirstDollar)))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Pricing: \(data.pricingNotes)", style: .body))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Upsell Opportunities:", style: .bold))
        for upsell in data.upsells {
            lines.append(BusinessPlanLine(text: upsell, style: .bullet))
        }
        return BusinessPlanSection(number: "05", title: "Business Model", icon: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90", content: lines)
    }

    private static func startupRequirementsSection(path: BusinessPath, data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        if !data.licensesAndPermits.isEmpty {
            lines.append(BusinessPlanLine(text: "Licenses & Permits:", style: .bold))
            for item in data.licensesAndPermits {
                lines.append(BusinessPlanLine(text: item, style: .bullet))
            }
            lines.append(BusinessPlanLine(text: "", style: .body))
        }
        if !data.insuranceNeeds.isEmpty {
            lines.append(BusinessPlanLine(text: "Insurance:", style: .bold))
            for item in data.insuranceNeeds {
                lines.append(BusinessPlanLine(text: item, style: .bullet))
            }
            lines.append(BusinessPlanLine(text: "", style: .body))
        }
        lines.append(BusinessPlanLine(text: "Vehicle: \(data.vehicleNeeds)", style: .body))
        lines.append(BusinessPlanLine(text: "Workspace: \(data.workspaceNeeds)", style: .body))
        return BusinessPlanSection(number: "06", title: "Startup Requirements", icon: "checklist", content: lines)
    }

    private static func startupCostBreakdownSection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: "Essential Items:", style: .bold))
        for (item, cost) in data.startupCostItemsEssential {
            lines.append(BusinessPlanLine(text: item, style: .financial(label: item, value: cost)))
        }
        if !data.startupCostItemsOptional.isEmpty {
            lines.append(BusinessPlanLine(text: "", style: .body))
            lines.append(BusinessPlanLine(text: "Optional Items:", style: .bold))
            for (item, cost) in data.startupCostItemsOptional {
                lines.append(BusinessPlanLine(text: item, style: .financial(label: item, value: cost)))
            }
        }
        if !data.equipment.isEmpty {
            lines.append(BusinessPlanLine(text: "", style: .body))
            lines.append(BusinessPlanLine(text: "Key Equipment:", style: .bold))
            for item in data.equipment.prefix(5) {
                lines.append(BusinessPlanLine(text: item, style: .bullet))
            }
        }
        return BusinessPlanSection(number: "07", title: "Startup Cost Breakdown", icon: "cart.fill", content: lines)
    }

    private static func operationsPlanSection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: "Daily Operations:", style: .bold))
        for step in data.operationsDaily {
            lines.append(BusinessPlanLine(text: step, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Scheduling: \(data.schedulingWorkflow)", style: .body))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Customer Workflow: \(data.customerWorkflow)", style: .body))
        return BusinessPlanSection(number: "08", title: "Operations Plan", icon: "gearshape.2.fill", content: lines)
    }

    private static func marketingSection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: "Marketing Channels:", style: .bold))
        for channel in data.marketingChannels {
            lines.append(BusinessPlanLine(text: channel, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Customer Acquisition:", style: .bold))
        for strategy in data.acquisitionStrategies {
            lines.append(BusinessPlanLine(text: strategy, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Referral Strategy:", style: .bold))
        for strategy in data.referralStrategies {
            lines.append(BusinessPlanLine(text: strategy, style: .bullet))
        }
        if !data.partnershipIdeas.isEmpty {
            lines.append(BusinessPlanLine(text: "", style: .body))
            lines.append(BusinessPlanLine(text: "Partnership Ideas:", style: .bold))
            for idea in data.partnershipIdeas {
                lines.append(BusinessPlanLine(text: idea, style: .bullet))
            }
        }
        return BusinessPlanSection(number: "09", title: "Marketing & Go-to-Market", icon: "megaphone.fill", content: lines)
    }

    private static func salesStrategySection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: "Sales Process:", style: .bold))
        for step in data.salesProcess {
            lines.append(BusinessPlanLine(text: step, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Sales Tips:", style: .bold))
        for tip in data.salesTips {
            lines.append(BusinessPlanLine(text: tip, style: .bullet))
        }
        if !data.objectionHandling.isEmpty {
            lines.append(BusinessPlanLine(text: "", style: .body))
            lines.append(BusinessPlanLine(text: "Handling Objections:", style: .bold))
            for (objection, response) in data.objectionHandling {
                lines.append(BusinessPlanLine(text: "\"\(objection)\"", style: .bold))
                lines.append(BusinessPlanLine(text: response, style: .body))
            }
        }
        return BusinessPlanSection(number: "10", title: "Sales Strategy", icon: "person.wave.2.fill", content: lines)
    }

    private static func financialProjectionsSection(path: BusinessPath, data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: "Starter", style: .financial(label: "Monthly Revenue (Starter)", value: data.monthlyRevenueStarter)))
        lines.append(BusinessPlanLine(text: "Moderate", style: .financial(label: "Monthly Revenue (Moderate)", value: data.monthlyRevenueModerate)))
        lines.append(BusinessPlanLine(text: "Strong", style: .financial(label: "Monthly Revenue (Strong)", value: data.monthlyRevenueStrong)))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Estimated Expenses (Starter)", style: .financial(label: "Monthly Expenses (Starter)", value: data.estimatedMonthlyExpensesStarter)))
        lines.append(BusinessPlanLine(text: "Estimated Expenses (Moderate)", style: .financial(label: "Monthly Expenses (Moderate)", value: data.estimatedMonthlyExpensesModerate)))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Startup Costs", style: .financial(label: "Startup Investment", value: path.startupCostRange)))
        lines.append(BusinessPlanLine(text: "Time to Revenue", style: .financial(label: "Time to First Dollar", value: path.timeToFirstDollar)))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Key Assumptions:", style: .bold))
        for assumption in data.financialAssumptions {
            lines.append(BusinessPlanLine(text: assumption, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Note: All financial figures are general industry ranges, not guarantees of income. Do your own research before investing.", style: .body))
        return BusinessPlanSection(number: "11", title: "Financial Projections", icon: "chart.bar.fill", content: lines)
    }

    private static func growthStrategySection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: "Hiring Path:", style: .bold))
        for step in data.hiringPath {
            lines.append(BusinessPlanLine(text: step, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Scaling Path:", style: .bold))
        for step in data.scalingPath {
            lines.append(BusinessPlanLine(text: step, style: .bullet))
        }
        if !data.expansionIdeas.isEmpty {
            lines.append(BusinessPlanLine(text: "", style: .body))
            lines.append(BusinessPlanLine(text: "Expansion Ideas:", style: .bold))
            for idea in data.expansionIdeas {
                lines.append(BusinessPlanLine(text: idea, style: .bullet))
            }
        }
        return BusinessPlanSection(number: "12", title: "Growth Strategy", icon: "arrow.up.right.circle.fill", content: lines)
    }

    private static func riskFactorsSection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        for risk in data.riskFactors {
            lines.append(BusinessPlanLine(text: risk, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Difficulty: \(data.difficultyNotes)", style: .body))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Viability: \(data.viabilityNotes)", style: .body))
        return BusinessPlanSection(number: "13", title: "Risk Factors & Realities", icon: "shield.lefthalf.filled", content: lines)
    }

    private static func launchRoadmapSection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: "Days 1–30:", style: .bold))
        for step in data.launchSteps30Days {
            lines.append(BusinessPlanLine(text: step, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Days 31–60:", style: .bold))
        for step in data.launchSteps60Days {
            lines.append(BusinessPlanLine(text: step, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Days 61–90:", style: .bold))
        for step in data.launchSteps90Days {
            lines.append(BusinessPlanLine(text: step, style: .bullet))
        }
        return BusinessPlanSection(number: "14", title: "30-60-90 Day Launch Roadmap", icon: "flag.checkered", content: lines)
    }

    private static func fitSummarySection(data: BusinessPlanData) -> BusinessPlanSection {
        var lines: [BusinessPlanLine] = []
        lines.append(BusinessPlanLine(text: data.fitSummary, style: .body))
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Best For:", style: .bold))
        for item in data.bestFor {
            lines.append(BusinessPlanLine(text: item, style: .bullet))
        }
        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Contact: [Your Name] | [Phone] | [Email]", style: .placeholder))
        return BusinessPlanSection(number: "15", title: "Final Fit Summary", icon: "checkmark.seal.fill", content: lines)
    }

    // MARK: - Fallback (existing logic for paths without structured data)

    private static func generateFallback(for path: BusinessPath) -> [BusinessPlanSection] {
        let serviceName = path.name
        let serviceDescription = extractServiceDescription(from: path)
        let categoryContext = categoryDescription(for: path.category)

        return [
            BusinessPlanSection(
                number: "01",
                title: "Business Overview",
                icon: "building.2.fill",
                content: [
                    BusinessPlanLine(text: "\(serviceName)", style: .bold),
                    BusinessPlanLine(text: "Legal Structure: [Sole Proprietorship / LLC]", style: .placeholder),
                    BusinessPlanLine(text: "Location: [Your City, State]", style: .placeholder),
                    BusinessPlanLine(text: serviceDescription, style: .body),
                    BusinessPlanLine(text: "Mission: To provide reliable, high-quality \(serviceName.lowercased()) services that build lasting client relationships and generate consistent, scalable revenue.", style: .body)
                ]
            ),
            BusinessPlanSection(
                number: "02",
                title: "The Problem",
                icon: "exclamationmark.triangle.fill",
                content: problemContent(for: path, categoryContext: categoryContext)
            ),
            BusinessPlanSection(
                number: "03",
                title: "Solution & Value Proposition",
                icon: "lightbulb.fill",
                content: solutionContent(for: path)
            ),
            BusinessPlanSection(
                number: "04",
                title: "Target Market",
                icon: "person.3.fill",
                content: targetMarketContent(for: path)
            ),
            BusinessPlanSection(
                number: "05",
                title: "Business Model",
                icon: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90",
                content: businessModelContent(for: path)
            ),
            BusinessPlanSection(
                number: "06",
                title: "Marketing & Sales Strategy",
                icon: "megaphone.fill",
                content: marketingContent(for: path)
            ),
            BusinessPlanSection(
                number: "07",
                title: "Team",
                icon: "person.2.fill",
                content: [
                    BusinessPlanLine(text: "[Your Name] — Founder & Lead Operator", style: .placeholder),
                    BusinessPlanLine(text: "Responsible for service delivery, client acquisition, and day-to-day operations.", style: .body),
                    BusinessPlanLine(text: SmartCareerBrain.educationText(for: path), style: .body),
                    BusinessPlanLine(text: "Planned Hires: Part-time help as client base exceeds solo capacity. Virtual assistant for scheduling and admin at scale.", style: .bullet)
                ]
            ),
            BusinessPlanSection(
                number: "08",
                title: "Financial Summary",
                icon: "chart.bar.fill",
                content: financialContent(for: path)
            ),
            BusinessPlanSection(
                number: "09",
                title: "Milestones & Next Steps",
                icon: "flag.checkered",
                content: milestonesContent(for: path)
            ),
            BusinessPlanSection(
                number: "10",
                title: "Note",
                icon: "info.circle.fill",
                content: [
                    BusinessPlanLine(text: "Detailed business plan data is still being added for this path. The plan above uses general industry information from your path profile.", style: .body),
                    BusinessPlanLine(text: "Full structured plans with startup cost breakdowns, operations workflows, sales strategies, financial projections, and 30-60-90 day launch roadmaps are available for top-tier paths.", style: .body)
                ]
            )
        ]
    }

    private static func extractServiceDescription(from path: BusinessPath) -> String {
        let overview = path.overview
        if overview.count > 20 {
            return overview
        }
        return "Professional \(path.name.lowercased()) services for \(path.customerType.lowercased())."
    }

    private static func categoryDescription(for category: BusinessCategory) -> String {
        switch category {
        case .homeProperty: return "home and property services"
        case .autoTransport: return "automotive and transportation services"
        case .outdoorLandscape: return "outdoor and landscaping services"
        case .foodBeverage: return "food and beverage services"
        case .petServices: return "pet care services"
        case .personalCare: return "personal care and professional services"
        case .digitalCreative: return "digital and creative services"
        case .productCraft: return "product and craft businesses"
        case .eventsEntertainment: return "events and entertainment services"
        case .skilledTrades: return "skilled trade services"
        }
    }

    private static func problemContent(for path: BusinessPath, categoryContext: String) -> [BusinessPlanLine] {
        let customers = path.customerType
        var lines: [BusinessPlanLine] = []

        lines.append(BusinessPlanLine(
            text: "\(customers) frequently struggle to find dependable, fairly-priced \(path.name.lowercased()) providers in their local area.",
            style: .body
        ))

        if path.category == .homeProperty || path.category == .skilledTrades {
            lines.append(BusinessPlanLine(text: "Common frustrations include unreliable scheduling, poor communication, inconsistent quality, and inflated pricing from larger companies.", style: .bullet))
        } else if path.category == .digitalCreative {
            lines.append(BusinessPlanLine(text: "Many small businesses lack the time, skills, or budget to handle this in-house, yet need professional results to remain competitive.", style: .bullet))
        } else if path.category == .foodBeverage {
            lines.append(BusinessPlanLine(text: "Customers want convenient, quality options but are underserved by existing providers who often prioritize volume over personalized service.", style: .bullet))
        } else if path.category == .petServices {
            lines.append(BusinessPlanLine(text: "Pet owners need trustworthy, reliable care providers but often find inconsistent quality and limited availability.", style: .bullet))
        } else {
            lines.append(BusinessPlanLine(text: "Current market options are often overpriced, unreliable, or fail to deliver the personalized attention customers expect.", style: .bullet))
        }

        lines.append(BusinessPlanLine(
            text: "This gap represents a clear opportunity for a responsive, quality-focused provider to capture market share quickly.",
            style: .body
        ))

        return lines
    }

    private static func solutionContent(for path: BusinessPath) -> [BusinessPlanLine] {
        var lines: [BusinessPlanLine] = []

        lines.append(BusinessPlanLine(
            text: "We deliver professional \(path.name.lowercased()) with a focus on reliability, clear communication, and exceptional results.",
            style: .body
        ))

        if path.soloFriendly {
            lines.append(BusinessPlanLine(text: "Personalized, owner-operated service ensures consistent quality on every job — no random subcontractors.", style: .bullet))
        }
        if path.fastCashPotential {
            lines.append(BusinessPlanLine(text: "Fast turnaround and flexible scheduling that larger competitors can't match.", style: .bullet))
        }

        lines.append(BusinessPlanLine(text: "Transparent pricing with no hidden fees — customers know exactly what they're paying.", style: .bullet))
        lines.append(BusinessPlanLine(text: "Follow-up communication and satisfaction guarantee that drives referrals and repeat business.", style: .bullet))

        if path.aiProofRating >= 85 {
            lines.append(BusinessPlanLine(
                text: "Competitive Edge: This is a hands-on, AI-resistant service (rated \(path.aiProofRating)/100) that cannot be easily automated or outsourced overseas.",
                style: .bold
            ))
        }

        return lines
    }

    private static func targetMarketContent(for path: BusinessPath) -> [BusinessPlanLine] {
        let customers = path.customerType.components(separatedBy: ", ")
        var lines: [BusinessPlanLine] = []

        lines.append(BusinessPlanLine(text: "Primary Customers:", style: .bold))
        for customer in customers {
            lines.append(BusinessPlanLine(text: customer.trimmingCharacters(in: .whitespaces), style: .bullet))
        }

        if path.category == .homeProperty || path.category == .outdoorLandscape || path.category == .skilledTrades {
            lines.append(BusinessPlanLine(text: "Demographics: Homeowners aged 30-65, household income $60K+, within a 15-mile service radius.", style: .body))
            lines.append(BusinessPlanLine(text: "Psychographics: Value convenience, willing to pay for quality, prefer local and trusted providers.", style: .body))
        } else if path.isDigital {
            lines.append(BusinessPlanLine(text: "Demographics: Small business owners, solopreneurs, and content creators needing professional support.", style: .body))
            lines.append(BusinessPlanLine(text: "Psychographics: Growth-minded, time-constrained, willing to invest in quality services.", style: .body))
        } else {
            lines.append(BusinessPlanLine(text: "Demographics: [Describe your ideal customer's age, income, location]", style: .placeholder))
            lines.append(BusinessPlanLine(text: "Psychographics: Value quality and convenience, prefer personalized service over big-box alternatives.", style: .body))
        }

        lines.append(BusinessPlanLine(text: "Market Opportunity: [Your City/Region] — estimated [X] potential customers within service area.", style: .placeholder))

        return lines
    }

    private static func businessModelContent(for path: BusinessPath) -> [BusinessPlanLine] {
        var lines: [BusinessPlanLine] = []

        lines.append(BusinessPlanLine(text: "Revenue Streams:", style: .bold))
        lines.append(BusinessPlanLine(text: path.starterPricing, style: .body))

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Startup Investment", style: .financial(label: "Startup Investment", value: path.startupCostRange)))
        lines.append(BusinessPlanLine(text: "Customer Type", style: .financial(label: "Customer Type", value: path.customerType.components(separatedBy: ",").first ?? path.customerType)))

        if path.requiresCar {
            lines.append(BusinessPlanLine(text: "Vehicle required for service delivery (existing personal vehicle acceptable).", style: .bullet))
        }

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Upsell Opportunities: Bundled services, recurring maintenance plans, referral incentives, and premium add-ons.", style: .body))

        return lines
    }

    private static func marketingContent(for path: BusinessPath) -> [BusinessPlanLine] {
        var lines: [BusinessPlanLine] = []

        lines.append(BusinessPlanLine(text: "Customer Acquisition Channels:", style: .bold))

        if path.isDigital {
            lines.append(BusinessPlanLine(text: "Freelance platforms (Upwork, Fiverr) for initial client pipeline", style: .bullet))
            lines.append(BusinessPlanLine(text: "Social media content marketing and portfolio showcase", style: .bullet))
            lines.append(BusinessPlanLine(text: "Direct outreach to target businesses via email", style: .bullet))
            lines.append(BusinessPlanLine(text: "Referral program offering discounts for client introductions", style: .bullet))
        } else {
            lines.append(BusinessPlanLine(text: "Door-to-door canvassing and neighborhood flyers", style: .bullet))
            lines.append(BusinessPlanLine(text: "Nextdoor, Facebook Marketplace, and local community groups", style: .bullet))
            lines.append(BusinessPlanLine(text: "Google Business Profile for local search visibility", style: .bullet))
            lines.append(BusinessPlanLine(text: "Before/after photos on social media for organic reach", style: .bullet))
            lines.append(BusinessPlanLine(text: "Referral incentives — $10-$25 credit per new client referred", style: .bullet))
        }

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Go-to-Market: Launch with introductory pricing or a free first service to build reviews and word-of-mouth. Transition to standard pricing within 30 days.", style: .body))

        return lines
    }

    private static func financialContent(for path: BusinessPath) -> [BusinessPlanLine] {
        var lines: [BusinessPlanLine] = []

        lines.append(BusinessPlanLine(text: "Startup Costs", style: .financial(label: "Startup Costs", value: path.startupCostRange)))
        lines.append(BusinessPlanLine(text: "Time to First Dollar", style: .financial(label: "Time to Revenue", value: path.timeToFirstDollar)))

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "What Others Charge:", style: .bold))
        lines.append(BusinessPlanLine(text: path.starterPricing, style: .body))

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Key Considerations:", style: .bold))
        lines.append(BusinessPlanLine(text: "Pricing varies by location, experience, and local market demand", style: .bullet))
        lines.append(BusinessPlanLine(text: "Research competitors in your area to set competitive rates", style: .bullet))
        lines.append(BusinessPlanLine(text: "Factor in all costs including supplies, travel, insurance, and taxes", style: .bullet))

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Note: All financial figures are general industry ranges, not guarantees of income. Do your own research before investing.", style: .body))

        return lines
    }

    private static func milestonesContent(for path: BusinessPath) -> [BusinessPlanLine] {
        var lines: [BusinessPlanLine] = []

        lines.append(BusinessPlanLine(text: "Week 1-2:", style: .bold))
        if let first = path.actionPlan.first {
            lines.append(BusinessPlanLine(text: first, style: .bullet))
        }
        if path.actionPlan.count > 1 {
            lines.append(BusinessPlanLine(text: path.actionPlan[1], style: .bullet))
        }

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Month 1:", style: .bold))
        lines.append(BusinessPlanLine(text: "Secure first 5 paying clients", style: .bullet))
        lines.append(BusinessPlanLine(text: "Collect 3+ five-star reviews", style: .bullet))

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Month 3:", style: .bold))
        lines.append(BusinessPlanLine(text: "Establish recurring client base and consistent weekly revenue", style: .bullet))
        lines.append(BusinessPlanLine(text: "Refine pricing and service offerings based on demand", style: .bullet))

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Month 6:", style: .bold))
        lines.append(BusinessPlanLine(text: "Evaluate if scaling further makes sense for your goals", style: .bullet))
        lines.append(BusinessPlanLine(text: "Evaluate hiring or subcontracting to increase capacity", style: .bullet))

        lines.append(BusinessPlanLine(text: "", style: .body))
        lines.append(BusinessPlanLine(text: "Contact: [Your Name] | [Phone] | [Email]", style: .placeholder))

        return lines
    }
}
