import Foundation

nonisolated enum LongQuizQuestion: Int, CaseIterable, Sendable {
    case workEnvironments   = 0
    case sellingComfort     = 1
    case hasCar             = 2
    case techComfort        = 3
    case workStyle          = 4
    case experienceLevel    = 5
    case customerInteraction = 6
    case needsFastCash      = 7
    case thingsToAvoid      = 8
    case physicalLimitation = 9
    case learningStyle      = 10
    case incomeTarget       = 11

    var title: String {
        switch self {
        case .workEnvironments:    return "Where do you work best?"
        case .sellingComfort:      return "Finding your own clients?"
        case .hasCar:              return "Do you have reliable transportation?"
        case .techComfort:         return "How comfortable are you with technology?"
        case .workStyle:           return "Work alone or with people?"
        case .experienceLevel:     return "Any existing skills or experience?"
        case .customerInteraction: return "How much client interaction do you want?"
        case .needsFastCash:       return "Do you need money right now?"
        case .thingsToAvoid:       return "What would you most want to avoid?"
        case .physicalLimitation:  return "Any physical limitations to consider?"
        case .learningStyle:       return "How do you learn best?"
        case .incomeTarget:        return "What do you want to earn in 3 years?"
        }
    }

    var subtitle: String {
        switch self {
        case .workEnvironments:    return "Select all that appeal to you"
        case .sellingComfort:      return "Finding and closing your own clients"
        case .hasCar:              return "Needed for mobile or on-site work"
        case .techComfort:         return "Software, apps, and digital tools"
        case .workStyle:           return "Your natural working preference"
        case .experienceLevel:     return "Even informal experience counts"
        case .customerInteraction: return "Day-to-day client contact level"
        case .needsFastCash:       return "Influences which paths we prioritize"
        case .thingsToAvoid:       return "Select all that apply"
        case .physicalLimitation:  return "So we can steer away from heavy physical work if needed"
        case .learningStyle:       return "How you absorb new skills best"
        case .incomeTarget:        return "In annual take-home pay"
        }
    }
}

nonisolated enum LearningStyle: String, CaseIterable, Identifiable, Codable, Sendable {
    case handson    = "Hands-on — I learn by doing"
    case structured = "Structured — I like classes and courses"
    case selftaught = "Self-taught — books, videos, online"
    case mentored   = "Mentored — I need someone to show me"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .handson:    return "wrench.and.screwdriver.fill"
        case .structured: return "building.columns.fill"
        case .selftaught: return "laptopcomputer"
        case .mentored:   return "person.2.fill"
        }
    }
}

nonisolated enum IncomeTarget: String, CaseIterable, Identifiable, Codable, Sendable {
    case under40k  = "Under $40,000"
    case k40to60   = "$40,000 – $60,000"
    case k60to80   = "$60,000 – $80,000"
    case k80to100  = "$80,000 – $100,000"
    case over100k  = "$100,000+"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .under40k: return "1.circle.fill"
        case .k40to60:  return "2.circle.fill"
        case .k60to80:  return "3.circle.fill"
        case .k80to100: return "4.circle.fill"
        case .over100k: return "star.circle.fill"
        }
    }
}

nonisolated enum ThingToAvoid: String, CaseIterable, Identifiable, Codable, Sendable {
    case physicalHazards  = "Physical hazards or injury risk"
    case longHours        = "Long or unpredictable hours"
    case selling          = "Having to sell or find clients"
    case screenTime       = "Sitting at a screen all day"
    case emotionalDrain   = "Emotionally draining situations"
    case instability      = "Unstable or inconsistent income"
    case longEducation    = "Years of education before earning"
    case publicExposure   = "Being judged or in the public eye"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .physicalHazards: return "exclamationmark.triangle.fill"
        case .longHours:       return "clock.badge.exclamationmark.fill"
        case .selling:         return "megaphone.slash.fill"
        case .screenTime:      return "display.slash"
        case .emotionalDrain:  return "heart.slash.fill"
        case .instability:     return "waveform.path.ecg"
        case .longEducation:   return "calendar.badge.minus"
        case .publicExposure:  return "eye.slash.fill"
        }
    }
}
