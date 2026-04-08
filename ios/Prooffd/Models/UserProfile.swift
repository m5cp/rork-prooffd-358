import Foundation

nonisolated enum BudgetRange: String, CaseIterable, Identifiable, Codable, Sendable {
    case zero = "$0"
    case under100 = "Under $100"
    case under500 = "Under $500"
    case under1000 = "Under $1,000"
    case over1000 = "$1,000+"

    var id: String { rawValue }

    var numericValue: Int {
        switch self {
        case .zero: return 0
        case .under100: return 100
        case .under500: return 500
        case .under1000: return 1000
        case .over1000: return 5000
        }
    }
}

nonisolated enum HoursPerDay: String, CaseIterable, Identifiable, Codable, Sendable {
    case lessThan1 = "Less than 1"
    case oneToTwo = "1–2"
    case threeToFour = "3–4"
    case fivePlus = "5+"

    var id: String { rawValue }

    var numericValue: Double {
        switch self {
        case .lessThan1: return 0.5
        case .oneToTwo: return 1.5
        case .threeToFour: return 3.5
        case .fivePlus: return 6
        }
    }
}

nonisolated enum WorkPreference: String, CaseIterable, Identifiable, Codable, Sendable {
    case physical = "Physical"
    case digital = "Digital"
    case either = "Either"

    var id: String { rawValue }
}

nonisolated enum WorkStyle: String, CaseIterable, Identifiable, Codable, Sendable {
    case solo = "Solo"
    case withPeople = "With People"
    case either = "Either"

    var id: String { rawValue }
}

nonisolated enum WorkCondition: String, CaseIterable, Identifiable, Codable, Sendable {
    case gettingDirty = "Getting dirty"
    case wet = "Wet"
    case sweaty = "Sweaty"
    case heights = "Heights"
    case chemicals = "Chemicals"
    case heavyLifting = "Heavy lifting"
    case outdoorHeat = "Outdoor heat"
    case cold = "Cold"
    case tightSpaces = "Tight spaces"
    case officeDesk = "Office/desk"
    case patientCare = "Patient care"
    case longShifts = "Long / irregular shifts"
    case highStakes = "High-stakes decisions"
    case emotionalSituations = "Emotional situations"
    case sterileEnvironment = "Sterile / clean room"
    case publicSpeaking = "Public speaking"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .gettingDirty: return "hands.sparkles.fill"
        case .wet: return "drop.fill"
        case .sweaty: return "figure.run"
        case .heights: return "arrow.up.to.line"
        case .chemicals: return "flask.fill"
        case .heavyLifting: return "dumbbell.fill"
        case .outdoorHeat: return "sun.max.fill"
        case .cold: return "snowflake"
        case .tightSpaces: return "rectangle.compress.vertical"
        case .officeDesk: return "desktopcomputer"
        case .patientCare: return "heart.fill"
        case .longShifts: return "clock.badge.fill"
        case .highStakes: return "exclamationmark.triangle.fill"
        case .emotionalSituations: return "person.wave.2.fill"
        case .sterileEnvironment: return "cross.vial.fill"
        case .publicSpeaking: return "mic.fill"
        }
    }
}

nonisolated enum TechComfort: String, CaseIterable, Identifiable, Codable, Sendable {
    case notComfortable = "Not comfortable"
    case basic = "Basic"
    case moderate = "Moderate"
    case verySavvy = "Very tech-savvy"

    var id: String { rawValue }

    var level: Int {
        switch self {
        case .notComfortable: return 0
        case .basic: return 1
        case .moderate: return 2
        case .verySavvy: return 3
        }
    }
}

nonisolated enum ExperienceLevel: String, CaseIterable, Identifiable, Codable, Sendable {
    case beginner = "Total beginner"
    case some = "Some experience"
    case skilled = "Skilled/trade trained"

    var id: String { rawValue }

    var level: Int {
        switch self {
        case .beginner: return 0
        case .some: return 1
        case .skilled: return 2
        }
    }
}

nonisolated enum CustomerInteraction: String, CaseIterable, Identifiable, Codable, Sendable {
    case minimal = "Minimal"
    case some = "Some"
    case lots = "Lots"

    var id: String { rawValue }
}

nonisolated enum SellingComfort: String, CaseIterable, Identifiable, Codable, Sendable {
    case notComfortable = "Not comfortable"
    case somewhat = "Somewhat"
    case veryComfortable = "Very comfortable"

    var id: String { rawValue }
}

nonisolated enum WorkEnvironment: String, CaseIterable, Identifiable, Codable, Sendable {
    case outdoors = "Outdoors"
    case officeDesk = "Office / Desk"
    case warehouse = "Warehouse / Shop"
    case retail = "Retail / Storefront"
    case homeBased = "Home-based"
    case onTheRoad = "On the road / Mobile"
    case constructionSite = "Construction site"
    case clientLocation = "Client locations"
    case hospital = "Hospital"
    case clinic = "Clinic / Medical"
    case laboratory = "Laboratory"
    case courtroom = "Courtroom / Legal"
    case classroom = "Classroom / School"
    case aircraft = "Aircraft / Cockpit"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .outdoors: return "sun.max.fill"
        case .officeDesk: return "desktopcomputer"
        case .warehouse: return "building.fill"
        case .retail: return "storefront.fill"
        case .homeBased: return "house.fill"
        case .onTheRoad: return "car.fill"
        case .constructionSite: return "hammer.fill"
        case .clientLocation: return "mappin.and.ellipse"
        case .hospital: return "cross.case.fill"
        case .clinic: return "stethoscope"
        case .laboratory: return "flask.fill"
        case .courtroom: return "building.columns.fill"
        case .classroom: return "book.fill"
        case .aircraft: return "airplane"
        }
    }
}

nonisolated enum IncomeTimeline: String, CaseIterable, Identifiable, Codable, Sendable {
    case asap = "ASAP — I need money now"
    case oneToThree = "1–3 months"
    case threeToSix = "3–6 months"
    case noRush = "6+ months is fine"

    var id: String { rawValue }
}

nonisolated enum SituationTag: String, CaseIterable, Identifiable, Codable, Sendable {
    case lowBudget = "Little to no startup budget"
    case canInvest = "Can invest $500+"
    case needMoneyNow = "Need income ASAP"
    case flexibleTimeline = "Flexible timeline"
    case fewHours = "Only 1–2 hours/day available"
    case fullTime = "4+ hours/day available"
    case prefersPhysical = "Prefer hands-on work"
    case prefersDigital = "Prefer computer/digital work"
    case workAlone = "Prefer working solo"
    case workWithPeople = "Enjoy working with people"
    case techSavvy = "Comfortable with technology"
    case lowTech = "Prefer low-tech work"
    case comfortableSelling = "Comfortable with sales"
    case noSelling = "Prefer no selling"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .lowBudget: return "dollarsign.circle"
        case .canInvest: return "banknote.fill"
        case .needMoneyNow: return "clock.fill"
        case .flexibleTimeline: return "calendar"
        case .fewHours: return "hourglass.bottomhalf.filled"
        case .fullTime: return "hourglass.tophalf.filled"
        case .prefersPhysical: return "hammer.fill"
        case .prefersDigital: return "laptopcomputer"
        case .workAlone: return "person.fill"
        case .workWithPeople: return "person.3.fill"
        case .techSavvy: return "desktopcomputer"
        case .lowTech: return "wrench.fill"
        case .comfortableSelling: return "megaphone.fill"
        case .noSelling: return "hand.raised.fill"
        }
    }
}

nonisolated enum EducationWillingness: String, CaseIterable, Identifiable, Codable, Sendable {
    case selfTaught = "Self-taught / online only"
    case shortCert = "Short certification (under 3 months)"
    case tradeSchool = "Trade school / bootcamp (3–12 months)"
    case twoYear = "2-year program"
    case fourYear = "4-year degree"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .selfTaught: return "laptopcomputer"
        case .shortCert: return "rosette"
        case .tradeSchool: return "wrench.and.screwdriver.fill"
        case .twoYear: return "building.columns.fill"
        case .fourYear: return "graduationcap.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .selfTaught: return "Best for self-starters who learn by doing and want to move fast."
        case .shortCert: return "Great for focused learners who want a credential quickly."
        case .tradeSchool: return "Ideal for hands-on people who thrive in structured programs."
        case .twoYear: return "Perfect for those who want deeper expertise with flexibility."
        case .fourYear: return "For people who want a comprehensive foundation and professional network."
        }
    }

    var matchScore: Int {
        switch self {
        case .selfTaught: return 95
        case .shortCert: return 88
        case .tradeSchool: return 82
        case .twoYear: return 74
        case .fourYear: return 65
        }
    }
}

nonisolated struct UserProfile: Codable, Sendable {
    var firstName: String = ""
    var selectedCategories: [BusinessCategory] = []
    var budget: BudgetRange?
    var hoursPerDay: HoursPerDay?
    var workPreference: WorkPreference?
    var workStyle: WorkStyle?
    var workConditions: [WorkCondition] = []
    var techComfort: TechComfort?
    var experienceLevel: ExperienceLevel?
    var customerInteraction: CustomerInteraction?
    var hasCar: Bool?
    var sellingComfort: SellingComfort?
    var needsFastCash: Bool?
    var workEnvironments: [WorkEnvironment] = []
    var incomeTimeline: IncomeTimeline?
    var educationWillingnesses: [EducationWillingness] = []
    var situationTags: [SituationTag] = []
    var avatarId: String = ""

    var avatar: AvatarOption {
        AvatarOption(rawValue: avatarId) ?? .star
    }

    var isComplete: Bool {
        !firstName.isEmpty &&
        !selectedCategories.isEmpty &&
        budget != nil &&
        hoursPerDay != nil &&
        workPreference != nil &&
        workStyle != nil &&
        techComfort != nil &&
        experienceLevel != nil &&
        customerInteraction != nil &&
        hasCar != nil &&
        sellingComfort != nil
    }
}
