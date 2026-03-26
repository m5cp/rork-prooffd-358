import Foundation

enum JobFactory {
    static func create(
        id: String,
        name: String,
        icon: String,
        cat: BusinessCategory,
        ai: Int,
        cost: String,
        time: String,
        customer: String,
        edu: String = "None",
        overview: String,
        plan: [String],
        pricing: String,
        revenue: String = "",
        car: Bool = false,
        physical: Bool = false,
        selling: Bool = false,
        digital: Bool = false,
        solo: Bool = true,
        fast: Bool = true,
        budget: Int = 0,
        hours: Double = 2,
        conditions: [WorkCondition] = [],
        tech: Int = 0,
        exp: Int = 0,
        interaction: String = "Some",
        whyNow: String = "",
        difficulty: String = "Beginner",
        services: [String] = [],
        bizName: String = "",
        sources: [String] = [],
        priceTips: [String] = [],
        scaleTips: [String] = [],
        risks: [String] = [],
        todaySteps: [String] = [],
        eduLink: String = "",
        interests: [String] = []
    ) -> BusinessPath {
        let outreach = "Hi [Name], I offer professional \(name.lowercased()) services in your area. I'd love to help — would you like a free estimate?"
        let social = "\(name) services available now! Professional quality, affordable rates. DM for a quote! #\(name.replacingOccurrences(of: " ", with: "")) #LocalBusiness"
        let email = "Subject: Professional \(name) Services\n\nHi [Name],\n\nI offer reliable, high-quality \(name.lowercased()) services for \(customer.lowercased()).\n\nI'm currently booking new clients and would love to help.\n\nWould you like a free estimate?\n\nBest,\n[Your Name]"
        let text = "Hey [Name]! I'm offering \(name.lowercased()) services in your area. Want a free estimate?"
        let salesScript = "Hi, I'm [Your Name]. I offer \(name.lowercased()) services — professional results at fair prices. Can I give you a free estimate?"
        let followUp = "Hey [Name], following up on the \(name.lowercased()) estimate. I have availability this week — want to schedule?"
        let flyer = "\(name.uppercased())\n\nProfessional Service\n✅ Quality work\n✅ Fair prices\n✅ Free estimates\n\nCall/Text: [Phone]"
        let pricingSheet = "\(name.uppercased())\n\n\(pricing)\n\nContact for custom quotes"
        let bizPlan = "\(name) is a proven business model with strong local demand. Start with \(cost) investment and target \(customer.lowercased()). Build a client base through referrals and local marketing. \(revenue.isEmpty ? "Revenue scales with client volume." : revenue)"
        let rev = revenue.isEmpty ? "Revenue varies by volume and location. Research your local market for realistic projections." : revenue

        return BusinessPath(
            id: id, name: name, icon: icon, category: cat,
            overview: overview, startupCostRange: cost,
            timeToFirstDollar: time, customerType: customer,
            aiProofRating: ai, educationRequired: edu,
            actionPlan: plan, starterPricing: pricing,
            outreachTemplate: outreach, socialMediaPost: social,
            revenueProjections: rev, draftEmail: email,
            draftTextMessage: text, salesIntroScript: salesScript,
            followUpScript: followUp, flyerCopy: flyer,
            offerPricingSheet: pricingSheet, expandedBusinessPlan: bizPlan,
            requiresCar: car, requiresPhysicalWork: physical,
            requiresSelling: selling, isDigital: digital,
            soloFriendly: solo, fastCashPotential: fast,
            minBudget: budget, minHoursPerDay: hours,
            workConditions: conditions, minTechLevel: tech,
            minExperienceLevel: exp, customerInteractionLevel: interaction,
            whyItWorksNow: whyNow, difficultyLevel: difficulty,
            customerSources: sources, pricingTips: priceTips,
            scalingTips: scaleTips, riskNotes: risks,
            suggestedServices: services, suggestedBusinessName: bizName,
            todayStepTemplates: todaySteps, linkedEducationPathId: eduLink,
            interests: interests
        )
    }
}
