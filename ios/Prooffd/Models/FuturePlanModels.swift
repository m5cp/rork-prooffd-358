import Foundation

// MARK: - School Stage

nonisolated enum SchoolStage: String, CaseIterable, Identifiable, Codable, Sendable {
    case middleSchool = "Middle School"
    case highSchool = "High School"
    case beyondSchool = "Beyond School"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .middleSchool: return "book.fill"
        case .highSchool:   return "graduationcap.fill"
        case .beyondSchool: return "briefcase.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .middleSchool: return "Grades 6–8 — plan early, win big later"
        case .highSchool:   return "Grades 9–12 — turn these years into a head start"
        case .beyondSchool: return "Graduated, working, or changing direction"
        }
    }

    var isStudent: Bool { self != .beyondSchool }
}

// MARK: - Quiz Questions

nonisolated enum DeepDiveQuestion: Int, CaseIterable, Sendable {
    case stage            = 0
    case favoriteSubjects = 1
    case workFeel         = 2
    case activities       = 3
    case freeTime         = 4
    case familySupport    = 5
    case moneyGoal        = 6
    case dreamLifestyle   = 7
    case adultFocus       = 8
    case adultBudget      = 9
    case incomeTarget     = 10

    static func questions(for stage: SchoolStage?) -> [DeepDiveQuestion] {
        var qs: [DeepDiveQuestion] = [.stage]
        switch stage {
        case .middleSchool, .highSchool:
            qs += [.favoriteSubjects, .workFeel, .activities, .freeTime, .familySupport, .moneyGoal, .dreamLifestyle]
        case .beyondSchool:
            qs += [.adultFocus, .adultBudget, .freeTime, .incomeTarget, .dreamLifestyle]
        case nil:
            break
        }
        return qs
    }

    func title(for stage: SchoolStage?) -> String {
        switch self {
        case .stage:            return "Where are you in life?"
        case .favoriteSubjects: return "Which subjects do you actually enjoy?"
        case .workFeel:         return "What would you love to do for work someday?"
        case .activities:       return "What are you already into?"
        case .freeTime:
            return stage?.isStudent == true
                ? "How much time can you give this after school?"
                : "How much time can you give this?"
        case .familySupport:    return "How supportive is your family about your plans?"
        case .moneyGoal:        return "What's your first money goal?"
        case .dreamLifestyle:   return "What matters most in your future?"
        case .adultFocus:       return "What's your #1 focus right now?"
        case .adultBudget:      return "How much can you invest to start?"
        case .incomeTarget:     return "What do you want to earn in 3 years?"
        }
    }

    func subtitle(for stage: SchoolStage?) -> String {
        switch self {
        case .stage:            return "We'll tailor everything to your stage"
        case .favoriteSubjects: return "Select all that apply"
        case .workFeel:         return "Select all that appeal to you"
        case .activities:       return "Clubs, hobbies, side things — select all that apply"
        case .freeTime:
            return stage?.isStudent == true ? "Per school day" : "Per day"
        case .familySupport:    return "Be honest — it changes the plan"
        case .moneyGoal:        return "Pick the closest one"
        case .dreamLifestyle:   return "Pick the one that hits hardest"
        case .adultFocus:       return "This shapes your whole plan"
        case .adultBudget:      return "Total startup budget"
        case .incomeTarget:     return "Annual take-home pay"
        }
    }
}

// MARK: - Student Answer Options

nonisolated enum FavoriteSubject: String, CaseIterable, Identifiable, Codable, Sendable {
    case math     = "Math & numbers"
    case science  = "Science"
    case writing  = "English & writing"
    case art      = "Art & design"
    case history  = "History & social studies"
    case tech     = "Computers & tech"
    case pe       = "Physical education"
    case business = "Business & money"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .math:     return "number.square.fill"
        case .science:  return "atom"
        case .writing:  return "text.book.closed.fill"
        case .art:      return "paintpalette.fill"
        case .history:  return "globe.americas.fill"
        case .tech:     return "laptopcomputer"
        case .pe:       return "figure.run"
        case .business: return "dollarsign.circle.fill"
        }
    }

    var interestTags: [InterestTag] {
        switch self {
        case .math:     return [.money, .science]
        case .science:  return [.science]
        case .writing:  return [.writing]
        case .art:      return [.creative]
        case .history:  return [.writing, .people]
        case .tech:     return [.tech]
        case .pe:       return [.handsOn]
        case .business: return [.money, .selling]
        }
    }
}

nonisolated enum WorkFeelInterest: String, CaseIterable, Identifiable, Codable, Sendable {
    case buildFix   = "Build & fix things"
    case computers  = "Work with computers"
    case carePeople = "Care for people or animals"
    case food       = "Cook or make food"
    case outdoors   = "Be outside"
    case create     = "Entertain or create"
    case lead       = "Teach or lead others"
    case sell       = "Sell & start things"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .buildFix:   return "hammer.fill"
        case .computers:  return "laptopcomputer"
        case .carePeople: return "heart.fill"
        case .food:       return "fork.knife"
        case .outdoors:   return "leaf.fill"
        case .create:     return "paintbrush.fill"
        case .lead:       return "person.3.fill"
        case .sell:       return "megaphone.fill"
        }
    }

    var interestTags: [InterestTag] {
        switch self {
        case .buildFix:   return [.handsOn]
        case .computers:  return [.tech]
        case .carePeople: return [.care]
        case .food:       return [.food]
        case .outdoors:   return [.outdoors]
        case .create:     return [.creative]
        case .lead:       return [.people, .selling]
        case .sell:       return [.selling, .money]
        }
    }
}

nonisolated enum StudentActivity: String, CaseIterable, Identifiable, Codable, Sendable {
    case sports       = "Sports teams"
    case clubs        = "Clubs (robotics, DECA, etc.)"
    case making       = "Making things — art, building, crafts"
    case content      = "Creating content — video, social"
    case volunteering = "Helping people — volunteering, caring"
    case gaming       = "Gaming & tech tinkering"
    case paidWork     = "Jobs or chores for money"
    case music        = "Music & performance"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .sports:       return "figure.run"
        case .clubs:        return "person.3.fill"
        case .making:       return "paintbrush.fill"
        case .content:      return "video.fill"
        case .volunteering: return "heart.fill"
        case .gaming:       return "gamecontroller.fill"
        case .paidWork:     return "dollarsign.circle.fill"
        case .music:        return "music.note"
        }
    }

    var interestTags: [InterestTag] {
        switch self {
        case .sports:       return [.handsOn]
        case .clubs:        return [.people, .selling]
        case .making:       return [.creative, .handsOn]
        case .content:      return [.creative, .tech]
        case .volunteering: return [.care, .people]
        case .gaming:       return [.tech]
        case .paidWork:     return [.money, .selling]
        case .music:        return [.creative]
        }
    }
}

nonisolated enum FamilySupportLevel: String, CaseIterable, Identifiable, Codable, Sendable {
    case verySupportive = "Very supportive"
    case somewhat       = "Somewhat supportive"
    case onMyOwn        = "I'm mostly on my own"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .verySupportive: return "person.2.fill"
        case .somewhat:       return "hand.thumbsup.fill"
        case .onMyOwn:        return "person.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .verySupportive: return "They'll help me get started"
        case .somewhat:       return "Some help, some limits"
        case .onMyOwn:        return "My plan, my hustle"
        }
    }
}

nonisolated enum FirstMoneyGoal: String, CaseIterable, Identifiable, Codable, Sendable {
    case firstHundred = "My first $100"
    case fiveHundred  = "Save $500+"
    case phoneBill    = "Cover my own bills"
    case car          = "Save for a car"
    case college      = "Start college savings"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .firstHundred: return "1.circle.fill"
        case .fiveHundred:  return "2.circle.fill"
        case .phoneBill:    return "3.circle.fill"
        case .car:          return "car.fill"
        case .college:      return "graduationcap.fill"
        }
    }
}

nonisolated enum DreamLifestyle: String, CaseIterable, Identifiable, Codable, Sendable {
    case freedom   = "Own my schedule"
    case wealth    = "Make a lot of money"
    case impact    = "Help people every day"
    case builder   = "Build something with my name on it"
    case adventure = "Travel & see the world"
    case stability = "Stability & security"
    case creativity = "Creative work I love"
    case status    = "Respect & expertise"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .freedom:    return "bird.fill"
        case .wealth:     return "chart.line.uptrend.xyaxis"
        case .impact:     return "heart.fill"
        case .builder:    return "hammer.fill"
        case .adventure:  return "airplane"
        case .stability:  return "shield.checkered"
        case .creativity: return "paintpalette.fill"
        case .status:     return "crown.fill"
        }
    }
}

// MARK: - Adult Answer Options

nonisolated enum AdultFocus: String, CaseIterable, Identifiable, Codable, Sendable {
    case earnFast      = "Start earning as fast as possible"
    case sideHustle    = "Build a side hustle"
    case switchCareers = "Switch to a better career"
    case bigMove       = "Plan a big long-term career move"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .earnFast:      return "bolt.fill"
        case .sideHustle:    return "moon.stars.fill"
        case .switchCareers: return "arrow.triangle.2.circlepath"
        case .bigMove:       return "chart.line.uptrend.xyaxis"
        }
    }

    var subtitle: String {
        switch self {
        case .earnFast:      return "Income in weeks, not years"
        case .sideHustle:    return "Something on the side that grows"
        case .switchCareers: return "A new lane within 1–2 years"
        case .bigMove:       return "Play the long game for a big payoff"
        }
    }
}

// MARK: - Interest Tags (scoring)

nonisolated enum InterestTag: String, Sendable {
    case handsOn
    case tech
    case care
    case food
    case outdoors
    case creative
    case people
    case selling
    case money
    case writing
    case science
}

// MARK: - Future Plan

nonisolated struct FuturePlanStage: Codable, Sendable {
    let title: String
    let subtitle: String
    let milestones: [String]
}

nonisolated struct AgeOutlookSnapshot: Codable, Sendable {
    let age: String
    let educationStatus: String
    let earnings: String
    let lifestyle: String
}

nonisolated struct FuturePlan: Codable, Sendable {
    var schoolStage: SchoolStage
    var nicheType: CommittedPathType
    var nicheId: String
    var nicheName: String
    var nicheIcon: String
    var confidence: Int
    var whyThisFits: [String]
    var roadmap: [FuturePlanStage]
    var ageOutlook: [AgeOutlookSnapshot]
    var dateCreated: Date

    var nicheTypeLabel: String {
        switch nicheType {
        case .business: return "Business Niche"
        case .trade:    return "Trade Path"
        case .degree:   return "Degree Career"
        }
    }
}

// MARK: - Answers (persisted for partial progress)

nonisolated struct FuturePlanAnswers: Codable, Sendable {
    var stage: SchoolStage? = nil
    var favoriteSubjects: [FavoriteSubject] = []
    var workFeel: [WorkFeelInterest] = []
    var activities: [StudentActivity] = []
    var freeTime: HoursPerDay? = nil
    var familySupport: FamilySupportLevel? = nil
    var moneyGoal: FirstMoneyGoal? = nil
    var dreamLifestyle: DreamLifestyle? = nil
    var adultFocus: AdultFocus? = nil
    var adultBudget: BudgetRange? = nil
    var incomeTarget: IncomeTarget? = nil
}
