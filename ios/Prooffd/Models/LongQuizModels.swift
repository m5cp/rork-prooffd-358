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
    case aiConcern          = 12
    case riskTolerance      = 13
    case growthAmbition     = 14
    case credentialAppetite = 15
    case scheduleShape      = 16
    case clientType         = 17

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
        case .aiConcern:           return "How much does AI worry you?"
        case .riskTolerance:       return "Steady paycheck or bigger upside?"
        case .growthAmbition:      return "How big do you want this to get?"
        case .credentialAppetite:  return "Willing to get licensed or certified?"
        case .scheduleShape:       return "When can you actually work?"
        case .clientType:          return "Who would you rather serve?"
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
        case .aiConcern:           return "We'll weight your matches toward AI-resistant work"
        case .riskTolerance:       return "There's no wrong answer — they lead different places"
        case .growthAmbition:      return "Some paths stay a one-person job by design"
        case .credentialAppetite:  return "Licenses gate the highest-paying trades"
        case .scheduleShape:       return "Some work can't be done on nights and weekends"
        case .clientType:          return "Consumers and businesses are very different games"
        }
    }
}

/// How much the user wants AI-resistance weighted in their matches.
nonisolated enum AIConcern: String, CaseIterable, Identifiable, Codable, Sendable {
    case veryWorried = "Very — it's my main concern"
    case somewhat    = "Somewhat — I want to be careful"
    case notReally   = "Not really — I'll adapt"
    case wantToUseIt = "I want to use AI as a tool"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .veryWorried: return "shield.checkered"
        case .somewhat:    return "exclamationmark.shield.fill"
        case .notReally:   return "hand.raised.fill"
        case .wantToUseIt: return "cpu"
        }
    }

    var subtitle: String {
        switch self {
        case .veryWorried: return "Push hands-on, physical, human-required work to the top"
        case .somewhat:    return "Favor durable paths, but stay open"
        case .notReally:   return "Rank on fit and income instead"
        case .wantToUseIt: return "Show paths where AI makes you faster, not obsolete"
        }
    }

    /// Weight applied to a path's AI-resistance rating, 0–1.
    var weight: Double {
        switch self {
        case .veryWorried: return 1.0
        case .somewhat:    return 0.6
        case .notReally:   return 0.2
        case .wantToUseIt: return 0.0
        }
    }
}

/// Appetite for income volatility.
nonisolated enum RiskTolerance: String, CaseIterable, Identifiable, Codable, Sendable {
    case steady      = "Steady and predictable"
    case balanced    = "A bit of both"
    case upside      = "Bigger upside, more risk"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .steady:   return "lock.shield.fill"
        case .balanced: return "arrow.left.arrow.right"
        case .upside:   return "chart.line.uptrend.xyaxis"
        }
    }

    var subtitle: String {
        switch self {
        case .steady:   return "Reliable income beats a big ceiling"
        case .balanced: return "Stable base with room to grow"
        case .upside:   return "I'll trade certainty for a higher ceiling"
        }
    }
}

/// How large the user wants the operation to become.
nonisolated enum GrowthAmbition: String, CaseIterable, Identifiable, Codable, Sendable {
    case justMe    = "Just me, keep it simple"
    case smallCrew = "A small crew eventually"
    case realCompany = "A real company I can scale"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .justMe:      return "person.fill"
        case .smallCrew:   return "person.2.fill"
        case .realCompany: return "building.2.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .justMe:      return "One person, low overhead, full control"
        case .smallCrew:   return "A few employees or subcontractors"
        case .realCompany: return "Something that runs without me one day"
        }
    }
}

/// Willingness to pursue licenses and formal credentials.
nonisolated enum CredentialAppetite: String, CaseIterable, Identifiable, Codable, Sendable {
    case happyTo   = "Yes — I'll do the exams"
    case ifWorthIt = "If it clearly pays off"
    case ratherNot = "I'd rather skip the paperwork"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .happyTo:   return "checkmark.seal.fill"
        case .ifWorthIt: return "rosette"
        case .ratherNot: return "hand.raised.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .happyTo:   return "Licensed trades pay the most and face the least competition"
        case .ifWorthIt: return "Show me the return before I commit"
        case .ratherNot: return "Favor paths I can start without a license"
        }
    }
}

/// The shape of the user's available working hours.
nonisolated enum ScheduleShape: String, CaseIterable, Identifiable, Codable, Sendable {
    case weekdays      = "Normal weekday hours"
    case eveningsWeekends = "Evenings and weekends only"
    case flexible      = "Whenever — I'm flexible"
    case unpredictable = "It changes week to week"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .weekdays:         return "briefcase.fill"
        case .eveningsWeekends: return "moon.stars.fill"
        case .flexible:         return "calendar"
        case .unpredictable:    return "clock.arrow.circlepath"
        }
    }

    var subtitle: String {
        switch self {
        case .weekdays:         return "Daytime, Monday to Friday"
        case .eveningsWeekends: return "I have another job or commitments"
        case .flexible:         return "I can work around the client"
        case .unpredictable:    return "I need work that tolerates a moving schedule"
        }
    }
}

/// Preferred customer base.
nonisolated enum ClientType: String, CaseIterable, Identifiable, Codable, Sendable {
    case individuals = "Everyday people"
    case businesses  = "Businesses"
    case noPreference = "No preference"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .individuals:  return "house.fill"
        case .businesses:   return "building.2.fill"
        case .noPreference: return "arrow.left.arrow.right"
        }
    }

    var subtitle: String {
        switch self {
        case .individuals:  return "Homeowners, families, consumers"
        case .businesses:   return "Fewer clients, bigger contracts, slower to close"
        case .noPreference: return "Whoever pays"
        }
    }
}

nonisolated enum LearningStyle: String, CaseIterable, Identifiable, Codable, Sendable {
    case handson    = "Hands-on — I learn by doing"
    case structured = "Structured — I like classes and courses"
    case selftaught = "Self-taught — books, videos, online"
    case mentored   = "Mentored — I need someone to show me"

    var id: String { rawValue }

    /// Education commitment this learner is naturally suited to.
    var preferredEducation: EducationWillingness {
        switch self {
        case .handson:    return .tradeSchool
        case .structured: return .twoYear
        case .selftaught: return .selfTaught
        case .mentored:   return .tradeSchool
        }
    }

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
    /// Midpoint annual figure used to compare a target against a path's income level.
    var midpoint: Int {
        switch self {
        case .under40k: return 32_000
        case .k40to60:  return 50_000
        case .k60to80:  return 70_000
        case .k80to100: return 90_000
        case .over100k: return 130_000
        }
    }

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
        case .selling:         return "megaphone.fill"
        case .screenTime:      return "desktopcomputer"
        case .emotionalDrain:  return "heart.slash.fill"
        case .instability:     return "waveform.path.ecg"
        case .longEducation:   return "calendar.badge.minus"
        case .publicExposure:  return "eye.slash.fill"
        }
    }
}
