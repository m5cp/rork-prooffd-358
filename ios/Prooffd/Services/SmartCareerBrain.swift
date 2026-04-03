import Foundation

nonisolated enum CareerRequirementType: String, Sendable {
    case generalService
    case skilledTrade
    case licensedTrade
    case certificationPath
    case degreePath
    case apprenticeshipPath
    case healthcareLicensed
    case technologyCertification
    case creativeFreelance
    case digitalService
    case transportationLicensed
    case foodPermitBased
}

enum SmartCareerBrain {
    static func classifyPath(_ path: BusinessPath) -> CareerRequirementType {
        let id = path.id.lowercased()
        let name = path.name.lowercased()
        let edu = path.educationRequired.lowercased()

        if matchesLicensedTrade(id: id, name: name, edu: edu) { return .licensedTrade }
        if matchesHealthcare(id: id, name: name, edu: edu) { return .healthcareLicensed }
        if matchesTransportation(id: id, name: name, edu: edu) { return .transportationLicensed }
        if matchesTechCertification(id: id, name: name, edu: edu) { return .technologyCertification }
        if matchesCertificationPath(id: id, name: name, edu: edu) { return .certificationPath }
        if matchesApprenticeship(id: id, name: name, edu: edu) { return .apprenticeshipPath }
        if matchesFoodPermit(id: id, name: name, edu: edu, category: path.category) { return .foodPermitBased }
        if matchesSkilledTrade(id: id, name: name, category: path.category) { return .skilledTrade }
        if matchesCreativeFreelance(id: id, name: name, category: path.category) { return .creativeFreelance }
        if matchesDigitalService(id: id, name: name, category: path.category) { return .digitalService }

        return .generalService
    }

    // MARK: - Classification Matchers

    private static func matchesLicensedTrade(id: String, name: String, edu: String) -> Bool {
        let licensedIds = [
            "electrician", "plumber", "hvac", "hvac-technician",
            "basic-electrical", "basic-plumbing", "outdoor-lighting",
            "water-heater", "locksmith", "home-inspector",
            "real-estate", "insurance-agent", "appraiser",
            "mobile-barber", "cosmetology", "nail-tech", "mobile-nails",
            "lash-tech", "massage-therapist", "barber",
            "weed-control", "pest-control", "sprinkler-irrigation",
            "garage-door-repair"
        ]
        if licensedIds.contains(id) { return true }
        if edu.contains("license") || edu.contains("licence") { return true }
        let licensedKeywords = ["electrician", "plumber", "hvac", "barber", "cosmetolog", "nail tech", "locksmith", "home inspector", "real estate", "insurance agent", "appraiser", "lash tech"]
        return licensedKeywords.contains { name.contains($0) }
    }

    private static func matchesHealthcare(id: String, name: String, edu: String) -> Bool {
        let healthcareIds = [
            "cna", "emt", "phlebotomy", "pharmacy-tech", "surgical-tech",
            "respiratory-therapist", "dental-hygienist", "medical-assistant",
            "ekg-tech", "vet-tech", "medical-coding"
        ]
        if healthcareIds.contains(id) { return true }
        let keywords = ["cna", "emt", "phlebotom", "pharmacy tech", "surgical tech", "respiratory", "dental hygien", "medical assistant", "ekg", "vet tech", "medical cod"]
        return keywords.contains { name.contains($0) }
    }

    private static func matchesTransportation(id: String, name: String, edu: String) -> Bool {
        let transportIds = ["cdl", "truck-driver", "commercial-driver", "drone-pilot", "drone-services"]
        if transportIds.contains(id) { return true }
        let keywords = ["cdl", "commercial driv", "drone pilot"]
        return keywords.contains { name.contains($0) }
    }

    private static func matchesTechCertification(id: String, name: String, edu: String) -> Bool {
        let techIds = [
            "comptia", "cybersecurity", "it-support", "cloud", "networking",
            "data-analyst", "web-developer", "web-design"
        ]
        if techIds.contains(id) { return true }
        let keywords = ["comptia", "cybersecurity", "it support", "cloud engineer", "network admin", "data analyst"]
        return keywords.contains { name.contains($0) }
    }

    private static func matchesCertificationPath(id: String, name: String, edu: String) -> Bool {
        let certIds = ["bookkeeping", "notary", "personal-trainer", "fitness-trainer"]
        if certIds.contains(id) { return true }
        if edu.contains("certification") || edu.contains("certified") { return true }
        return false
    }

    private static func matchesApprenticeship(id: String, name: String, edu: String) -> Bool {
        let apprenticeIds = ["welding", "welder", "aircraft-mechanic", "diesel-mechanic"]
        if apprenticeIds.contains(id) { return true }
        if edu.contains("apprenticeship") { return true }
        let keywords = ["welder", "welding", "aircraft mechanic", "diesel mechanic"]
        return keywords.contains { name.contains($0) }
    }

    private static func matchesFoodPermit(id: String, name: String, edu: String, category: BusinessCategory) -> Bool {
        if category == .foodBeverage { return true }
        let foodIds = ["meal-prep", "baked-goods", "food-truck", "personal-chef", "catering"]
        return foodIds.contains(id)
    }

    private static func matchesSkilledTrade(id: String, name: String, category: BusinessCategory) -> Bool {
        if category == .skilledTrades { return true }
        let tradeIds = ["appliance-repair", "drywall-repair", "flooring-installation", "fence-repair", "handyman", "pool-cleaning"]
        return tradeIds.contains(id)
    }

    private static func matchesCreativeFreelance(id: String, name: String, category: BusinessCategory) -> Bool {
        let creativeIds = ["photography", "event-photography", "graphic-design", "video-editing", "dj-services", "podcast-production"]
        return creativeIds.contains(id)
    }

    private static func matchesDigitalService(id: String, name: String, category: BusinessCategory) -> Bool {
        if category == .digitalCreative { return true }
        let digitalIds = ["social-media-management", "freelance-writing", "virtual-assistant", "online-tutoring", "seo-services"]
        return digitalIds.contains(id)
    }

    // MARK: - Education & Training Text

    static func educationText(for path: BusinessPath) -> String {
        let careerType = classifyPath(path)
        let name = path.name

        switch careerType {
        case .licensedTrade:
            return "Trade school, certificate program, or apprenticeship may be required for \(name). Supervised experience under licensed professionals is strongly recommended. State or local licensing may apply — research your specific state requirements before starting. Certification exams may be required."

        case .apprenticeshipPath:
            return "\(name) typically requires formal training through a trade school, apprenticeship program, or vocational training. Hands-on training under experienced professionals is strongly recommended. Certification may be required depending on your state and the scope of work."

        case .healthcareLicensed:
            return "\(name) requires completion of an accredited training program. Certification or licensure is typically required. Clinical training, externship, or supervised practice hours may be part of the requirement. You must pass applicable certification exams before practicing."

        case .transportationLicensed:
            return "\(name) requires specific federal or state licensing. Structured training programs, written and practical exams, and supervised experience may be required. Research your state's Department of Motor Vehicles or FAA requirements as applicable."

        case .technologyCertification:
            return "\(name) benefits from structured training and industry-recognized certifications. Certification prep courses, hands-on labs, and portfolio projects are the standard path. Entry-level experience building through internships or freelance work is recommended."

        case .certificationPath:
            return "\(name) benefits from professional certification, which improves credibility and earning potential. Structured courses and exam preparation are available online and in-person. No four-year degree is typically required."

        case .foodPermitBased:
            return "\(name) may require a food handler's permit, health department approval, or cottage food compliance depending on your state and local laws. Research your area's food safety requirements before starting."

        case .skilledTrade:
            return "Learn core service standards and safe work practices for \(name). Hands-on experience through practice, mentorship, or short courses is recommended before taking on paying clients. Some specializations may benefit from industry certification."

        case .creativeFreelance:
            return "Build your skills through structured practice, courses, and real-world projects. A strong portfolio demonstrating your abilities is essential. Formal education is not required but continuous skill development is important."

        case .digitalService:
            return "Develop proficiency through online courses, structured practice, and real client projects. Build a portfolio or case studies to demonstrate your capabilities. Continuous learning is important as tools and platforms evolve."

        case .generalService:
            return "Learn core service standards and proper techniques before charging clients. Practice with safe methods, study basic operations and customer service, and get hands-on experience. Short courses or mentorship can accelerate your readiness."

        case .degreePath:
            return "\(name) typically requires formal education — a degree or diploma from an accredited institution. Research program requirements and financial aid options in your area."
        }
    }

    // MARK: - Smart Action Plan

    static func smartActionPlan(for path: BusinessPath) -> [String] {
        let careerType = classifyPath(path)
        let name = path.name

        switch careerType {
        case .licensedTrade:
            return [
                "Research your state and local licensing requirements for \(name)",
                "Identify accredited trade schools, certificate programs, or apprenticeship opportunities",
                "Enroll in your chosen training program",
                "Complete required education and supervised training hours",
                "Prepare for and pass any required certification or licensing exams",
                "Obtain required insurance and bonding",
                "Gather essential tools and equipment",
                "Buy a domain name and set up a professional business email",
                "Create a simple website or online booking presence",
                "Register your business if appropriate for your state",
                "Begin customer acquisition through referrals and local marketing"
            ]

        case .apprenticeshipPath:
            return [
                "Research training programs, trade schools, and apprenticeship options for \(name)",
                "Apply to a training program or apprenticeship",
                "Complete required education and hands-on supervised training",
                "Obtain any required certifications",
                "Gather tools, equipment, and safety gear",
                "Buy a domain name and set up a professional business email",
                "Launch a simple website or portfolio",
                "Register your business if appropriate",
                "Set up scheduling and invoicing tools",
                "Begin outreach to potential clients and partners"
            ]

        case .healthcareLicensed:
            return [
                "Research accredited training programs for \(name) in your area",
                "Apply and enroll in your chosen program",
                "Complete required coursework and clinical or externship hours",
                "Prepare for and pass your certification exam",
                "Apply for state licensure if required",
                "Build your resume and begin job placement search",
                "Consider specialization or advanced certifications over time"
            ]

        case .transportationLicensed:
            return [
                "Research federal and state licensing requirements for \(name)",
                "Enroll in an approved training program",
                "Complete required classroom and practical training hours",
                "Pass written and practical licensing exams",
                "Obtain required insurance and permits",
                "Buy a domain name and create a professional business presence",
                "Register your business if operating independently",
                "Begin customer acquisition or job placement"
            ]

        case .technologyCertification:
            return [
                "Choose your training and certification track for \(name)",
                "Enroll in a structured course or bootcamp",
                "Complete hands-on labs, projects, and portfolio pieces",
                "Prepare for and pass your certification exam",
                "Buy a domain and create a website or online portfolio",
                "Set up a professional business email",
                "Begin outreach to potential clients or employers",
                "Build case studies from your first projects"
            ]

        case .certificationPath:
            return [
                "Research certification options and requirements for \(name)",
                "Enroll in a training course or certification program",
                "Complete coursework and exam preparation",
                "Pass your certification exam",
                "Buy a domain name and set up a professional business email",
                "Create a simple website or booking presence",
                "Register your business if appropriate",
                "Begin outreach and customer acquisition"
            ]

        case .foodPermitBased:
            return [
                "Research local health department rules, food handler permits, and cottage food laws",
                "Obtain required food safety certifications and permits",
                "Develop your menu and perfect your recipes",
                "Set up your workspace to meet any health and safety requirements",
                "Buy a domain name and set up a professional business email",
                "Create a simple website or social media ordering presence",
                "Register your business if required in your area",
                "Begin marketing to your target customers"
            ]

        case .skilledTrade:
            return [
                "Learn core service techniques through courses, mentorship, or structured practice",
                "Invest in essential tools and safety equipment",
                "Practice on small projects to build confidence and skill",
                "Get liability insurance if working on client property",
                "Buy a domain name and set up a professional business email",
                "Create a simple website or online booking presence",
                "Register your business if appropriate for your state",
                "Begin customer acquisition through local marketing and referrals"
            ]

        case .creativeFreelance:
            return [
                "Build your skills through courses and structured practice",
                "Create a portfolio of your best work (at least 5–10 samples)",
                "Buy a domain name and set up a professional business email",
                "Launch a portfolio website showcasing your work",
                "Set up profiles on relevant freelance platforms",
                "Begin outreach to potential clients",
                "Register your business if appropriate",
                "Collect testimonials and refine your offerings"
            ]

        case .digitalService:
            return [
                "Develop your skills through online courses and practice projects",
                "Build a portfolio or case studies demonstrating results",
                "Buy a domain name and set up a professional business email",
                "Create a website or landing page for your services",
                "Set up on freelance platforms or marketplaces",
                "Offer introductory pricing to build your first client base",
                "Register your business if appropriate",
                "Collect reviews and testimonials to build credibility"
            ]

        case .generalService:
            return [
                "Learn proper service standards, techniques, and safety practices",
                "Gather essential equipment and supplies",
                "Practice your service to build quality and efficiency",
                "Buy a domain name and set up a professional business email",
                "Create a simple website or online booking presence",
                "Register your business if appropriate for your state",
                "Set up payment processing and invoicing",
                "Begin outreach through local marketing and referrals"
            ]

        case .degreePath:
            return [
                "Research accredited programs and admission requirements",
                "Apply to your chosen program",
                "Complete your degree or diploma requirements",
                "Build relevant experience through internships or entry-level positions",
                "Buy a domain name and set up a professional business email",
                "Create a website or online presence",
                "Register your business if starting independently",
                "Begin client acquisition or job placement"
            ]
        }
    }

    // MARK: - Business Setup Steps

    static func businessSetupSteps(for path: BusinessPath) -> [String] {
        let careerType = classifyPath(path)
        var steps: [String] = []

        steps.append("Buy a domain name for your business")
        steps.append("Create a professional business email")
        steps.append("Launch a simple website or booking presence")

        switch careerType {
        case .licensedTrade, .apprenticeshipPath:
            steps.append("Register your business — consider an LLC or other legal structure depending on liability, state rules, and tax setup")
            steps.append("Set up business banking and accounting")
            steps.append("Obtain required insurance and bonding")
        case .healthcareLicensed, .transportationLicensed:
            steps.append("Maintain all required licenses and credentials")
        case .technologyCertification, .certificationPath, .digitalService, .creativeFreelance:
            steps.append("Register your business if appropriate for your income level and state")
            steps.append("Set up invoicing and payment processing")
        case .foodPermitBased:
            steps.append("Register your business if required by your local health department")
            steps.append("Set up payment processing for orders")
        case .skilledTrade, .generalService:
            steps.append("Register your business if appropriate depending on liability and business goals")
            steps.append("Set up payment processing and simple invoicing")
        case .degreePath:
            steps.append("Register your business if starting independently")
        }

        return steps
    }

    // MARK: - Should Show Licensing Warning

    static func requiresRegulatoryNotice(_ path: BusinessPath) -> Bool {
        let careerType = classifyPath(path)
        switch careerType {
        case .licensedTrade, .healthcareLicensed, .transportationLicensed, .apprenticeshipPath, .foodPermitBased:
            return true
        default:
            return false
        }
    }

    static func regulatoryNotice(for path: BusinessPath) -> String? {
        let careerType = classifyPath(path)
        switch careerType {
        case .licensedTrade:
            return "This career may require state or local licensing, permits, bonding, or insurance. Requirements vary by state — always research your specific location's rules before starting."
        case .healthcareLicensed:
            return "This career requires completion of an accredited program and passing certification exams. Licensure requirements vary by state. Verify all requirements with your state's health department or licensing board."
        case .transportationLicensed:
            return "This career requires specific federal or state licensing. Training, exams, and ongoing compliance are required. Check with your state's licensing authority."
        case .apprenticeshipPath:
            return "This career typically requires formal training or apprenticeship. Certification requirements vary by state and scope of work. Research your local requirements."
        case .foodPermitBased:
            return "Food-related businesses may require health department permits, food handler certifications, and compliance with cottage food laws. Requirements vary by state and locality."
        default:
            return nil
        }
    }
}
