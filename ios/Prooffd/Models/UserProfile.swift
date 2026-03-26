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
