import Foundation

// MARK: - FuturePlanEngine

/// Scores business, trade, and degree niches against Future Planner answers,
/// then builds the winning niche's roadmap and age outlook.
@MainActor
enum FuturePlanEngine {

    struct NicheWinner {
        let type: CommittedPathType
        let id: String
        let name: String
        let icon: String
        let score: Double
        let path: BusinessPath?
        let eduPath: EducationPath?
        let degreeRecord: DegreeCareerRecord?
    }

    static func computePlan(answers: FuturePlanAnswers,
                            businessResults: [MatchResult],
                            educationScores: [String: Int] = [:],
                            degreeScores: [String: Int] = [:]) -> FuturePlan {
        let tags = interestTags(from: answers)
        let stage = answers.stage ?? .highSchool

        let businessCandidates = scoreBusinessPaths(answers: answers, tags: tags, existingScores: businessResults)
        let tradeCandidates = scoreTradePaths(answers: answers, tags: tags, existingScores: educationScores)
        let degreeCandidates = scoreDegreeRecords(answers: answers, tags: tags, existingScores: degreeScores)

        let bestBusiness = businessCandidates.first
        let bestTrade = tradeCandidates.first
        let bestDegree = degreeCandidates.first

        let businessMultiplier = businessBias(answers: answers)
        let tradeMultiplier = tradeBias(answers: answers)
        let degreeMultiplier = degreeBias(answers: answers)

        var candidates: [NicheWinner] = []
        if let b = bestBusiness {
            candidates.append(NicheWinner(type: .business, id: b.path.id, name: b.path.name,
                                          icon: b.path.icon, score: b.score * businessMultiplier,
                                          path: b.path, eduPath: nil, degreeRecord: nil))
        }
        if let t = bestTrade {
            candidates.append(NicheWinner(type: .trade, id: t.path.id, name: t.path.title,
                                          icon: t.path.icon, score: t.score * tradeMultiplier,
                                          path: nil, eduPath: t.path, degreeRecord: nil))
        }
        if let d = bestDegree {
            candidates.append(NicheWinner(type: .degree, id: d.record.id, name: d.record.title,
                                          icon: d.record.icon, score: d.score * degreeMultiplier,
                                          path: nil, eduPath: nil, degreeRecord: d.record))
        }

        let sorted = candidates.sorted { $0.score > $1.score }
        guard let winner = sorted.first else {
            return fallbackPlan(stage: stage)
        }
        let runnerUp = sorted.count > 1 ? sorted[1].score : 0

        let reasons = whyThisFits(winner: winner, answers: answers, tags: tags)

        let completeness = answerCompleteness(answers: answers)
        let gapBonus = winner.score > 0 ? min(20, max(0, (winner.score - runnerUp) * 2)) : 0
        let confidence = min(97, max(55, 55 + Int(completeness * 18) + Int(gapBonus)))

        return FuturePlan(
            schoolStage: stage,
            nicheType: winner.type,
            nicheId: winner.id,
            nicheName: winner.name,
            nicheIcon: winner.icon,
            confidence: confidence,
            whyThisFits: reasons,
            roadmap: buildRoadmap(stage: stage, nicheName: winner.name),
            ageOutlook: buildAgeOutlook(winner: winner),
            dateCreated: Date()
        )
    }

    private static func fallbackPlan(stage: SchoolStage) -> FuturePlan {
        FuturePlan(
            schoolStage: stage,
            nicheType: .business,
            nicheId: "car-washing",
            nicheName: "Car Detailing",
            nicheIcon: "car.fill",
            confidence: 60,
            whyThisFits: ["A proven starter path with low startup cost"],
            roadmap: buildRoadmap(stage: stage, nicheName: "Car Detailing"),
            ageOutlook: buildBusinessOutlook(),
            dateCreated: Date()
        )
    }

    // MARK: - Interest Tags

    static func interestTags(from answers: FuturePlanAnswers) -> [InterestTag] {
        var set: Set<InterestTag> = []
        answers.favoriteSubjects.forEach { set.formUnion($0.interestTags) }
        answers.workFeel.forEach { set.formUnion($0.interestTags) }
        answers.activities.forEach { set.formUnion($0.interestTags) }
        return Array(set)
    }

    private static func businessCategoryTags(_ category: BusinessCategory) -> [InterestTag] {
        switch category {
        case .homeProperty:        return [.handsOn]
        case .autoTransport:       return [.handsOn, .outdoors]
        case .outdoorLandscape:    return [.outdoors, .handsOn]
        case .foodBeverage:        return [.food]
        case .petServices:         return [.care, .outdoors]
        case .personalCare:        return [.people, .care]
        case .digitalCreative:     return [.tech, .creative]
        case .productCraft:        return [.creative, .handsOn]
        case .eventsEntertainment: return [.creative, .people]
        case .skilledTrades:       return [.handsOn, .tech]
        }
    }

    private static func educationCategoryTags(_ category: EducationCategory) -> [InterestTag] {
        switch category {
        case .trade:         return [.handsOn]
        case .certification: return [.handsOn, .tech]
        case .healthcare:    return [.care, .science]
        case .technology:    return [.tech]
        case .business:      return [.money, .selling, .people]
        case .creative:      return [.creative]
        case .military:      return [.handsOn, .people]
        }
    }

    private static func degreeCategoryTags(_ category: DegreeCareerCategory) -> [InterestTag] {
        switch category {
        case .healthcare:   return [.care, .science]
        case .mentalHealth: return [.care, .people]
        case .engineering:  return [.tech, .science]
        case .legal:        return [.writing, .people]
        case .education:    return [.people, .writing]
        case .aviation:     return [.tech, .handsOn]
        case .military:     return [.handsOn, .people]
        }
    }

    // MARK: - Business Scoring

    private static func scoreBusinessPaths(answers: FuturePlanAnswers, tags: [InterestTag],
                                           existingScores: [MatchResult]) -> [(path: BusinessPath, score: Double)] {
        BusinessPathDatabase.allPaths.map { path in
            var score = 0.0
            let pathTags = businessCategoryTags(path.category)
            let overlap = tags.filter { pathTags.contains($0) }.count
            score += Double(overlap) * 12

            switch answers.dreamLifestyle {
            case .freedom:    if path.soloFriendly { score += 12 }
            case .wealth:     if path.incomeLevel == .high { score += 8 }
            case .builder:    score += 10
            case .adventure:  if path.category == .autoTransport || path.category == .outdoorLandscape { score += 12 }
            case .creativity: if path.category == .digitalCreative || path.category == .productCraft || path.category == .eventsEntertainment { score += 12 }
            case .impact:     if path.category == .personalCare || path.category == .petServices { score += 6 }
            case .status:     if path.incomeLevel == .high { score += 5 }
            case .stability:  if path.requiresLicense { score += 6 }
            case nil: break
            }

            if let hours = answers.freeTime {
                score += hours.numericValue >= path.minHoursPerDay ? 10 : -8
            }

            switch answers.stage {
            case .middleSchool:
                if path.requiresCar { score -= 15 }
                if path.requiresLicense { score -= 10 }
                if path.minBudget > 100 { score -= 10 }
                if path.minHoursPerDay > 3 { score -= 8 }
            case .highSchool:
                if path.requiresCar { score -= 6 }
                if path.requiresLicense { score -= 4 }
                if path.minBudget > 300 { score -= 6 }
            case .beyondSchool, nil: break
            }

            if let support = answers.familySupport, support == .onMyOwn, path.minBudget > 50 {
                score -= 12
            }

            switch answers.moneyGoal {
            case .firstHundred: if path.fastCashPotential { score += 8 }
            case .fiveHundred:  if path.fastCashPotential { score += 6 }
            case .phoneBill:    if path.fastCashPotential { score += 6 }
            case .car:          if path.fastCashPotential { score += 4 }
            case .college:      break
            case nil: break
            }

            switch answers.adultFocus {
            case .earnFast:      if path.fastCashPotential { score += 15 }; if path.isFastStart { score += 8 }
            case .sideHustle:    if path.minHoursPerDay <= 2 { score += 12 }; if path.isScalable { score += 5 }
            case .switchCareers: if path.requiresLicense { score += 6 }; score -= 4
            case .bigMove:       if path.incomeLevel == .high { score += 8 }
            case nil: break
            }

            if let budget = answers.adultBudget {
                score += budget.numericValue >= path.minBudget ? 10 : -8
            }

            if let income = answers.incomeTarget {
                switch income {
                case .under40k: if path.fastCashPotential { score += 6 }; if path.incomeLevel == .high { score -= 4 }
                case .k40to60:  if path.incomeLevel == .medium { score += 6 }
                case .k60to80:  if path.incomeLevel == .medium { score += 4 }
                case .k80to100, .over100k: if path.incomeLevel == .high { score += 8 }
                }
            }

            if let result = existingScores.first(where: { $0.businessPath.id == path.id }) {
                score += Double(result.scorePercentage) / 10
            }

            return (path, score)
        }
        .sorted { $0.score > $1.score }
    }

    // MARK: - Trade Scoring

    private static func scoreTradePaths(answers: FuturePlanAnswers, tags: [InterestTag],
                                        existingScores: [String: Int]) -> [(path: EducationPath, score: Double)] {
        EducationPathDatabase.all.map { path in
            var score = 0.0
            let pathTags = educationCategoryTags(path.category)
            let overlap = tags.filter { pathTags.contains($0) }.count
            score += Double(overlap) * 14

            switch answers.dreamLifestyle {
            case .stability:  score += 12
            case .impact:     if path.category == .healthcare { score += 10 }
            case .wealth:     if path.incomeLevel == .high { score += 6 }
            case .status:     if path.requiresLicense { score += 8 }
            case .creativity: if path.category == .creative { score += 10 }
            case .freedom:    if path.category == .trade || path.category == .technology { score += 4 }
            case .builder, .adventure: break
            case nil: break
            }

            if path.demandLevel == .high { score += 6 }
            if path.incomeLevel == .high { score += 4 }

            switch answers.moneyGoal {
            case .college: score += 4
            default: break
            }

            switch answers.adultFocus {
            case .switchCareers: score += 12
            case .bigMove:       score += 8
            case .earnFast:      score += 6
            case .sideHustle:    score += 4
            case nil: break
            }

            switch answers.incomeTarget {
            case .k80to100, .over100k: if path.incomeLevel == .high { score += 8 }
            default: break
            }

            if let existing = existingScores[path.id] {
                score += Double(existing) / 12
            }

            return (path, score)
        }
        .sorted { $0.score > $1.score }
    }

    // MARK: - Degree Scoring

    private static func scoreDegreeRecords(answers: FuturePlanAnswers, tags: [InterestTag],
                                           existingScores: [String: Int]) -> [(record: DegreeCareerRecord, score: Double)] {
        DegreeCareerDatabase.allRecords.map { record in
            var score = 0.0
            let recordTags = degreeCategoryTags(record.category)
            let overlap = tags.filter { recordTags.contains($0) }.count
            score += Double(overlap) * 14

            switch answers.dreamLifestyle {
            case .impact:    score += 12
            case .status:    score += 10
            case .wealth:    if record.salaryExperienced.contains("$250K") || record.salaryExperienced.contains("$200K") || record.salaryExperienced.contains("$150K") { score += 8 }
            case .stability: if record.demandNotes.lowercased().contains("strong") { score += 6 }
            case .adventure: if record.category == .aviation || record.category == .military { score += 12 }
            case .freedom, .builder, .creativity: break
            case nil: break
            }

            if let subject = answers.favoriteSubjects.first {
                if record.bestFitTraits.contains(where: { $0.lowercased().contains("academ") }) && subject == .science {
                    score += 6
                }
            }

            switch answers.adultFocus {
            case .bigMove:       score += 15
            case .switchCareers: score += 10
            case .sideHustle:    score -= 6
            case .earnFast:      score -= 8
            case nil: break
            }

            switch answers.incomeTarget {
            case .over100k, .k80to100: score += 6
            case .under40k: score -= 6
            default: break
            }

            switch answers.moneyGoal {
            case .college: score += 8
            default: break
            }

            if let existing = existingScores[record.id] {
                score += Double(existing) / 12
            }

            return (record, score)
        }
        .sorted { $0.score > $1.score }
    }

    // MARK: - Stage / Lifestyle Bias

    private static func businessBias(answers: FuturePlanAnswers) -> Double {
        var bias = 1.0
        switch answers.stage {
        case .middleSchool: bias *= 1.25
        case .highSchool:   bias *= 1.15
        case .beyondSchool, nil: break
        }
        switch answers.dreamLifestyle {
        case .freedom, .wealth, .builder: bias *= 1.1
        default: break
        }
        if answers.adultFocus == .earnFast || answers.adultFocus == .sideHustle { bias *= 1.2 }
        return bias
    }

    private static func tradeBias(answers: FuturePlanAnswers) -> Double {
        var bias = 1.0
        if answers.dreamLifestyle == .stability { bias *= 1.15 }
        if answers.adultFocus == .switchCareers { bias *= 1.2 }
        if answers.adultFocus == .bigMove { bias *= 1.1 }
        return bias
    }

    private static func degreeBias(answers: FuturePlanAnswers) -> Double {
        var bias = 1.0
        switch answers.stage {
        case .middleSchool: bias *= 0.85
        case .highSchool:   bias *= 0.95
        case .beyondSchool, nil: break
        }
        if answers.dreamLifestyle == .impact || answers.dreamLifestyle == .status { bias *= 1.2 }
        if answers.adultFocus == .bigMove { bias *= 1.2 }
        if answers.moneyGoal == .college { bias *= 1.15 }
        return bias
    }

    // MARK: - Why This Fits

    private static func whyThisFits(winner: NicheWinner, answers: FuturePlanAnswers, tags: [InterestTag]) -> [String] {
        var reasons: [String] = []

        let tagLabels: [InterestTag] = tags
        if !tagLabels.isEmpty {
            let labels = tagLabels.prefix(3).map { tagLabel($0) }.joined(separator: ", ")
            reasons.append("Built around what you enjoy: \(labels)")
        }

        if let path = winner.path {
            if path.minBudget <= 50 {
                reasons.append("Starts with almost no money — anyone can begin")
            } else if let budget = answers.adultBudget, budget.numericValue >= path.minBudget {
                reasons.append("Fits comfortably inside your startup budget")
            }
            if path.fastCashPotential {
                reasons.append("Real income is possible in your first weeks")
            }
            if path.soloFriendly && answers.dreamLifestyle == .freedom {
                reasons.append("You're the boss — your schedule, your clients")
            }
            if path.isDigital && !answers.favoriteSubjects.filter({ $0 == .tech }).isEmpty {
                reasons.append("Uses the tech skills you're already building")
            }
        } else if let edu = winner.eduPath {
            reasons.append("Leads to a licensed, always-in-demand skill")
            if edu.demandLevel == .high {
                reasons.append("Employers are actively short on people in this field")
            }
            if answers.dreamLifestyle == .stability {
                reasons.append("Matches your priority: stability and steady demand")
            }
            if !edu.typicalSalaryRange.isEmpty {
                reasons.append("Typical earnings: \(edu.typicalSalaryRange)")
            }
        } else if let record = winner.degreeRecord {
            reasons.append("A licensed career with a clear, proven ladder")
            if !record.salaryEarly.isEmpty {
                reasons.append("Early-career pay: \(record.salaryEarly)")
            }
            if answers.dreamLifestyle == .impact {
                reasons.append("Directly matches your goal of helping people every day")
            }
            if !record.demandNotes.isEmpty {
                reasons.append("Demand outlook: \(record.demandNotes)")
            }
        }

        return Array(reasons.prefix(3))
    }

    private static func tagLabel(_ tag: InterestTag) -> String {
        switch tag {
        case .handsOn: return "working with your hands"
        case .tech: return "technology"
        case .care: return "caring for people"
        case .food: return "food"
        case .outdoors: return "the outdoors"
        case .creative: return "creative work"
        case .people: return "people"
        case .selling: return "selling"
        case .money: return "money"
        case .writing: return "writing"
        case .science: return "science"
        }
    }

    // MARK: - Completeness

    private static func answerCompleteness(answers: FuturePlanAnswers) -> Double {
        var answered = 0.0
        var total = 0.0
        let stage = answers.stage

        if stage != nil { answered += 1 }
        total += 1

        if stage?.isStudent == true {
            for value in [answers.favoriteSubjects.isEmpty, answers.workFeel.isEmpty, answers.activities.isEmpty] {
                total += 1
                if !value { answered += 1 }
            }
            for value in [answers.freeTime != nil, answers.familySupport != nil,
                          answers.moneyGoal != nil, answers.dreamLifestyle != nil] {
                total += 1
                if value { answered += 1 }
            }
        } else if stage == .beyondSchool {
            for value in [answers.adultFocus != nil, answers.adultBudget != nil,
                          answers.freeTime != nil, answers.incomeTarget != nil,
                          answers.dreamLifestyle != nil] {
                total += 1
                if value { answered += 1 }
            }
        }
        return total > 0 ? answered / total : 0
    }

    // MARK: - Roadmap

    static func buildRoadmap(stage: SchoolStage, nicheName: String) -> [FuturePlanStage] {
        switch stage {
        case .middleSchool:
            return [
                FuturePlanStage(
                    title: "This Year",
                    subtitle: "Grades 6–8",
                    milestones: [
                        "Learn the basics of \(nicheName) — watch 3 pros and take notes",
                        "Practice at home on real projects (family, neighbors)",
                        "Ask a parent or teacher about a related club or class"
                    ]
                ),
                FuturePlanStage(
                    title: "High School Start",
                    subtitle: "9th–10th grade",
                    milestones: [
                        "Pick classes that connect to \(nicheName)",
                        "Do your first small job for real money",
                        "Save your first $100"
                    ]
                ),
                FuturePlanStage(
                    title: "Get Serious",
                    subtitle: "11th–12th grade",
                    milestones: [
                        "Take on bigger \(nicheName) jobs or a related part-time role",
                        "Build proof: photos, reviews, a simple portfolio",
                        "Decide your next step: keep building, train, or college"
                    ]
                )
            ]
        case .highSchool:
            return [
                FuturePlanStage(
                    title: "This Semester",
                    subtitle: "Start now",
                    milestones: [
                        "Learn the fundamentals of \(nicheName) with free online content",
                        "Practice on 3 real projects for people you know",
                        "Join or start a related club at school"
                    ]
                ),
                FuturePlanStage(
                    title: "Next 6 Months",
                    subtitle: "First money",
                    milestones: [
                        "Do your first paid \(nicheName) job",
                        "Set up a simple way to get customers — flyer, page, word of mouth",
                        "Save your first $500"
                    ]
                ),
                FuturePlanStage(
                    title: "Junior & Senior Year",
                    subtitle: "Build proof",
                    milestones: [
                        "Take electives and certifications that connect to \(nicheName)",
                        "Line up a mentor, internship, or related part-time work",
                        "Build a portfolio you can show anyone"
                    ]
                ),
                FuturePlanStage(
                    title: "After Graduation",
                    subtitle: "Go all in",
                    milestones: [
                        "Choose: full-time \(nicheName), a training program, or college with \(nicheName) on the side",
                        "Formalize: pricing, reviews, repeat customers",
                        "Scale your income toward your next milestone"
                    ]
                )
            ]
        case .beyondSchool:
            return [
                FuturePlanStage(
                    title: "Months 1–3",
                    subtitle: "Validate",
                    milestones: [
                        "Talk to 5 potential customers about \(nicheName)",
                        "Learn the core skills — free resources first",
                        "Set up your basics: pricing and a simple offer"
                    ]
                ),
                FuturePlanStage(
                    title: "Months 4–6",
                    subtitle: "First customers",
                    milestones: [
                        "Land your first 3 paying customers",
                        "Ask every customer for a review or referral",
                        "Track your numbers: income, costs, hours"
                    ]
                ),
                FuturePlanStage(
                    title: "Months 7–12",
                    subtitle: "Grow",
                    milestones: [
                        "Raise your prices 10–20% as reviews grow",
                        "Systemize: a repeatable process for every job",
                        "Decide: scale this up or layer in training"
                    ]
                ),
                FuturePlanStage(
                    title: "Year 2",
                    subtitle: "Compound",
                    milestones: [
                        "Double down on your best customer source",
                        "Consider licensing, certification, or an LLC",
                        "Set your next income milestone and go get it"
                    ]
                )
            ]
        }
    }

    // MARK: - Age Outlook

    static func buildAgeOutlook(winner: NicheWinner) -> [AgeOutlookSnapshot] {
        switch winner.type {
        case .business:
            return buildBusinessOutlook()
        case .trade:
            let salary = winner.eduPath?.typicalSalaryRange ?? "$45K–$70K/yr"
            return [
                AgeOutlookSnapshot(age: "18", educationStatus: "Trade school or apprenticeship underway",
                                   earnings: "$18–$28/hr while you learn",
                                   lifestyle: "Paid to learn a skill most people can't do"),
                AgeOutlookSnapshot(age: "21", educationStatus: "Licensed or nearly licensed",
                                   earnings: "\(salary) as you build hours",
                                   lifestyle: "In demand everywhere — and no student debt"),
                AgeOutlookSnapshot(age: "25", educationStatus: "Journeyman or specialist",
                                   earnings: "\(salary) or more",
                                   lifestyle: "Options everywhere: crew lead, your own outfit, or specialize")
            ]
        case .degree:
            let record = winner.degreeRecord
            let degree = record?.degreeRequired ?? "Your degree"
            let timeline = record?.timeline ?? "4–6 years"
            let early = record?.salaryEarly ?? "$60K–$85K"
            return [
                AgeOutlookSnapshot(age: "18", educationStatus: "Starting your degree (\(timeline) track)",
                                   earnings: "Part-time earnings while you study",
                                   lifestyle: "Building toward a licensed career"),
                AgeOutlookSnapshot(age: "21", educationStatus: "Deep in training: \(degree)",
                                   earnings: "Internships, clinicals, and certifications",
                                   lifestyle: "The hard middle — it pays off next"),
                AgeOutlookSnapshot(age: "25", educationStatus: "Licensed and practicing",
                                   earnings: "\(early) early-career",
                                   lifestyle: "Established professional with a clear ladder")
            ]
        }
    }

    private static func buildBusinessOutlook() -> [AgeOutlookSnapshot] {
        [
            AgeOutlookSnapshot(age: "18", educationStatus: "Working for yourself around school",
                               earnings: "$200–$1,000+/mo from repeat customers",
                               lifestyle: "You call the shots on weekends and summers"),
            AgeOutlookSnapshot(age: "21", educationStatus: "2–3 years of real customer experience",
                               earnings: "$1,000–$4,000/mo with steady reviews",
                               lifestyle: "A real business you can scale or sell"),
            AgeOutlookSnapshot(age: "25", educationStatus: "5+ years running your own thing",
                               earnings: "$40K–$80K+/yr, fully self-directed",
                               lifestyle: "Your name, your rates, your schedule")
        ]
    }
}
