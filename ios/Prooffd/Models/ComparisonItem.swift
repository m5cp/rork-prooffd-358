import Foundation

nonisolated enum ComparisonItem: Identifiable, Sendable {
    case business(MatchResult)
    case trade(CareerPath)
    case degree(DegreeCareerRecord)

    var id: String {
        switch self {
        case .business(let r): return "b-\(r.businessPath.id)"
        case .trade(let t):    return "t-\(t.id)"
        case .degree(let d):   return "d-\(d.id)"
        }
    }
    var title: String {
        switch self {
        case .business(let r): return r.businessPath.name
        case .trade(let t):    return t.title
        case .degree(let d):   return d.title
        }
    }
    var icon: String {
        switch self {
        case .business(let r): return r.businessPath.icon
        case .trade(let t):    return t.icon
        case .degree(let d):   return d.icon
        }
    }
    var aiProofScore: Int {
        switch self {
        case .business(let r): return r.businessPath.aiProofRating
        case .trade(let t):    return t.aiSafeScore
        case .degree(let d):
            switch d.aiProofTier {
            case .tier1: return 90
            case .tier2: return 75
            case .tier3: return 60
            }
        }
    }
    var salaryRange: String {
        switch self {
        case .business(let r): return r.businessPath.typicalMarketRates
        case .trade(let t):    return t.typicalSalaryRange
        case .degree(let d):   return "\(d.salaryEarly) — \(d.salaryExperienced)"
        }
    }
    var timeToIncome: String {
        switch self {
        case .business(let r): return r.businessPath.timeToFirstDollar
        case .trade(let t):    return t.timeToComplete
        case .degree(let d):   return d.timeline
        }
    }
    var upfrontCost: String {
        switch self {
        case .business(let r): return r.businessPath.startupCostRange
        case .trade(let t):    return t.costRange
        case .degree(let d):   return d.degreeRequired
        }
    }
    var typeLabel: String {
        switch self {
        case .business: return "Business"
        case .trade:    return "Trade"
        case .degree:   return "Degree"
        }
    }
}
