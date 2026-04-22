import Foundation

enum MatchingEngine {
    nonisolated static func match(profile: UserProfile, paths: [BusinessPath]) -> [MatchResult] {
        let hasAnswers = !profile.selectedCategories.isEmpty || profile.budget != nil || profile.workPreference != nil || !profile.situationTags.isEmpty || !profile.workEnvironments.isEmpty || !profile.educationWillingnesses.isEmpty

        if !hasAnswers {
            return browseAll(paths: paths)
        }

        var results: [MatchResult] = []

        for path in paths {
            var score: Double = 0
            var maxScore: Double = 0

            maxScore += 15
            if let motivation = profile.motivationGoal {
                switch motivation {
                case .ownBoss:
                    if path.soloFriendly { score += 15 }
                    else if !path.requiresPhysicalWork { score += 8 }
                    else { score += 4 }
                case .stableSkill:
                    if path.requiresPhysicalWork && path.requiresLicense { score += 13 }
                    else if path.requiresPhysicalWork { score += 10 }
                    else if path.requiresLicense { score += 8 }
                    else { score += 5 }
                case .helpPeople:
                    if !path.soloFriendly && path.requiresLicense { score += 11 }
                    else if !path.soloFriendly { score += 8 }
                    else { score += 5 }
                case .professionalStatus:
                    if path.requiresLicense && path.incomeLevel == .high { score += 13 }
                    else if path.requiresLicense { score += 9 }
                    else if path.incomeLevel == .high { score += 7 }
                    else { score += 4 }
                }
            } else {
                score += 10
            }

            maxScore += 15
            if !profile.workEnvironments.isEmpty {
                let pathEnvs = path.inferredWorkEnvironments
                let matchCount = profile.workEnvironments.filter { pathEnvs.contains($0) }.count
                if matchCount > 0 {
                    let ratio = Double(matchCount) / Double(profile.workEnvironments.count)
                    score += 15 * ratio
                }
            } else {
                score += 15
            }

            maxScore += 15
            if let budget = profile.budget {
                if budget.numericValue >= path.minBudget {
                    score += 15
                } else if budget.numericValue >= path.minBudget / 2 {
                    score += 7
                }
            }

            maxScore += 10
            if let hours = profile.hoursPerDay {
                if hours.numericValue >= path.minHoursPerDay {
                    score += 10
                } else if hours.numericValue >= path.minHoursPerDay * 0.5 {
                    score += 5
                }
            }

            maxScore += 10
            if let pref = profile.workPreference {
                switch pref {
                case .physical:
                    if path.requiresPhysicalWork && !path.isDigital { score += 10 }
                    else if path.requiresPhysicalWork { score += 5 }
                case .digital:
                    if path.isDigital && !path.requiresPhysicalWork { score += 10 }
                    else if path.isDigital { score += 5 }
                case .either:
                    score += 10
                }
            }

            maxScore += 8
            if let style = profile.workStyle {
                switch style {
                case .solo:
                    if path.soloFriendly { score += 8 }
                case .withPeople:
                    if !path.soloFriendly { score += 8 }
                    else { score += 3 }
                case .either:
                    score += 8
                }
            }

            maxScore += 7
            if !path.workConditions.isEmpty {
                let toleratedCount = path.workConditions.filter { profile.workConditions.contains($0) }.count
                let ratio = Double(toleratedCount) / Double(path.workConditions.count)
                score += 7 * ratio
            } else {
                score += 7
            }

            maxScore += 5
            if let tech = profile.techComfort {
                if tech.level >= path.minTechLevel { score += 5 }
                else if tech.level >= path.minTechLevel - 1 { score += 2 }
            }

            maxScore += 5
            if let exp = profile.experienceLevel {
                if exp.level >= path.minExperienceLevel { score += 5 }
                else if exp.level >= path.minExperienceLevel - 1 { score += 2 }
            }

            maxScore += 5
            if let interaction = profile.customerInteraction {
                if interaction.rawValue == path.customerInteractionLevel { score += 5 }
                else { score += 2 }
            }

            maxScore += 5
            if let hasCar = profile.hasCar {
                if !path.requiresCar || hasCar { score += 5 }
            }

            maxScore += 3
            if let selling = profile.sellingComfort {
                if path.requiresSelling {
                    switch selling {
                    case .veryComfortable: score += 3
                    case .somewhat: score += 2
                    case .notComfortable: score += 0
                    }
                } else {
                    score += 3
                }
            }

            maxScore += 10
            if let situation = profile.situationGoal {
                switch situation {
                case .needsMoneyFast:
                    if path.isFastStart && path.fastCashPotential { score += 10 }
                    else if path.isFastStart { score += 7 }
                    else if path.fastCashPotential { score += 5 }
                    else { score += 2 }
                case .willingToTrain:
                    score += 10
                case .highestEarning:
                    switch path.incomeLevel {
                    case .high: score += 10
                    case .medium: score += 6
                    case .low: score += 2
                    }
                case .flexibilityFirst:
                    if path.soloFriendly { score += 10 }
                    else { score += 4 }
                }
            } else {
                score += 8
            }

            maxScore += 7
            if let selectedEdu = profile.educationWillingnesses.first {
                let selectedIndex = EducationWillingness.allCases.firstIndex(of: selectedEdu) ?? 0
                let requiredLevel: EducationWillingness
                let eduReq = path.educationRequired.lowercased()
                if eduReq.contains("4-year") || eduReq.contains("bachelor") || eduReq.contains("degree") {
                    requiredLevel = .fourYear
                } else if eduReq.contains("2-year") || eduReq.contains("associate") {
                    requiredLevel = .twoYear
                } else if eduReq.contains("trade") || eduReq.contains("bootcamp") || eduReq.contains("apprentice") {
                    requiredLevel = .tradeSchool
                } else if eduReq.contains("cert") || eduReq.contains("license") || eduReq.contains("training") {
                    requiredLevel = .shortCert
                } else {
                    requiredLevel = .selfTaught
                }
                let requiredIndex = EducationWillingness.allCases.firstIndex(of: requiredLevel) ?? 0
                if selectedIndex >= requiredIndex {
                    score += 7
                } else if selectedIndex >= requiredIndex - 1 {
                    score += 4
                } else {
                    score += 1
                }
            } else {
                score += 5
            }

            maxScore += 2
            if let fastCash = profile.needsFastCash {
                if fastCash && path.fastCashPotential { score += 2 }
                else if !fastCash { score += 2 }
                else { score += 1 }
            }

            let userMatchScore = maxScore > 0 ? (score / maxScore) * 100 : 0

            let userInterests = Self.deriveInterests(from: profile)

            var interestBonus: Double = 0
            for interest in path.alignedInterests {
                if userInterests.contains(interest) {
                    interestBonus += 3
                }
            }
            interestBonus = min(interestBonus, 12)

            let boostedUserMatchScore = min(99, userMatchScore + interestBonus)

            let finalScore = CareerScoringEngine.shared.adjustedFinalScore(
                userMatchScore: boostedUserMatchScore,
                requiresLicense: path.requiresLicense,
                incomeLevel: path.incomeLevel,
                demandLevel: path.demandLevel,
                categoryTier: path.categoryTier,
                isFastStart: path.isFastStart,
                isScalable: path.isScalable
            )

            let percentage = Int(finalScore)

            if percentage >= 20 {
                results.append(MatchResult(
                    id: path.id,
                    businessPath: path,
                    score: score,
                    scorePercentage: min(percentage, 99)
                ))
            }
        }

        return results.sorted { $0.scorePercentage > $1.scorePercentage }
    }

    nonisolated static func quickMatch(profile: UserProfile, paths: [BusinessPath], limit: Int = 2) -> [MatchResult] {
        let results = match(profile: profile, paths: paths)
        return Array(results.prefix(limit))
    }

    private nonisolated static func deriveInterests(from profile: UserProfile) -> Set<String> {
        var interests: Set<String> = []

        if profile.workPreference == .physical || profile.situationTags.contains(.prefersPhysical) {
            interests.insert("hands_on")
        }
        if profile.workPreference == .digital || profile.situationTags.contains(.prefersDigital) {
            interests.insert("remote")
        }
        if profile.selectedCategories.contains(.digitalCreative) || profile.selectedCategories.contains(.productCraft) {
            interests.insert("creative")
        }
        if profile.workStyle == .solo || profile.situationTags.contains(.workAlone) {
            interests.insert("entrepreneurial")
        }
        if profile.needsFastCash == true || profile.situationTags.contains(.needMoneyNow) {
            interests.insert("fast_start")
        }
        if profile.budget == .zero || profile.budget == .under100 || profile.situationTags.contains(.lowBudget) {
            interests.insert("low_cost")
        }
        if profile.workStyle == .withPeople || profile.customerInteraction == .lots || profile.situationTags.contains(.workWithPeople) {
            interests.insert("people_facing")
        }
        if profile.budget == .over1000 || profile.situationTags.contains(.canInvest) || profile.incomeTimeline == .noRush {
            interests.insert("high_income")
        }
        let healthcareEnvs: Set<WorkEnvironment> = [.hospital, .clinic, .laboratory]
        if !Set(profile.workEnvironments).isDisjoint(with: healthcareEnvs) || profile.workConditions.contains(.patientCare) {
            interests.insert("people_facing")
        }

        return interests
    }

    private nonisolated static func browseAll(paths: [BusinessPath]) -> [MatchResult] {
        paths.enumerated().map { index, path in
            let baseScore = max(50 - index / 5, 30)
            return MatchResult(
                id: path.id,
                businessPath: path,
                score: Double(baseScore),
                scorePercentage: baseScore
            )
        }
    }

    // MARK: - Education Path Scoring

    nonisolated static func scoreEducationPaths(profile: UserProfile) -> [String: Int] {
        var scores: [String: Int] = [:]
        let userInterests = deriveInterests(from: profile)

        for path in EducationPathDatabase.all {
            var score: Double = 0
            var maxScore: Double = 0

            maxScore += 25
            if let selectedEdu = profile.educationWillingnesses.first {
                let selectedIndex = EducationWillingness.allCases.firstIndex(of: selectedEdu) ?? 0
                let required = educationLevelForPath(path)
                let requiredIndex = EducationWillingness.allCases.firstIndex(of: required) ?? 0
                if selectedIndex >= requiredIndex {
                    score += 25
                } else if selectedIndex >= requiredIndex - 1 {
                    score += 14
                } else {
                    score += 4
                }
            } else {
                score += 15
            }

            maxScore += 20
            if let pref = profile.workPreference {
                let isHandsOn = [EducationCategory.trade].contains(path.category)
                let isDigital = [EducationCategory.technology, .creative].contains(path.category)
                switch pref {
                case .physical:
                    if isHandsOn { score += 20 } else if !isDigital { score += 10 }
                case .digital:
                    if isDigital { score += 20 } else if !isHandsOn { score += 10 }
                case .either:
                    score += 20
                }
            }

            maxScore += 12
            if let motivation = profile.motivationGoal {
                switch motivation {
                case .stableSkill:
                    if [.trade, .certification].contains(path.category) { score += 12 }
                    else { score += 5 }
                case .helpPeople:
                    if [.healthcare].contains(path.category) { score += 12 }
                    else if [.trade, .business].contains(path.category) { score += 5 }
                    else { score += 8 }
                case .professionalStatus:
                    if [.healthcare, .technology, .business].contains(path.category) { score += 10 }
                    else { score += 6 }
                case .ownBoss:
                    if [.business, .creative].contains(path.category) { score += 10 }
                    else { score += 5 }
                }
            } else {
                score += 8
            }

            maxScore += 15
            if let timeline = profile.incomeTimeline {
                switch timeline {
                case .asap:
                    if path.isFastStart { score += 15 } else { score += 3 }
                case .oneToThree:
                    if path.isFastStart { score += 12 } else { score += 8 }
                case .threeToSix:
                    score += 12
                case .noRush:
                    score += 15
                }
            }

            maxScore += 10
            if !profile.workEnvironments.isEmpty {
                let tradeEnvs: Set<WorkEnvironment> = [.outdoors, .constructionSite, .warehouse, .clientLocation]
                let officeEnvs: Set<WorkEnvironment> = [.officeDesk, .homeBased]
                let healthcareEnvs: Set<WorkEnvironment> = [.hospital, .clinic, .laboratory]
                let militaryEnvs: Set<WorkEnvironment> = [.outdoors, .aircraft]
                let userEnvSet = Set(profile.workEnvironments)
                let isTradeCategory = [EducationCategory.trade, .certification].contains(path.category)
                let isHealthcareCategory = path.category == .healthcare
                let isTechCategory = [EducationCategory.technology, .creative, .business].contains(path.category)
                let isMilitaryCategory = path.category == .military
                if isHealthcareCategory && !userEnvSet.isDisjoint(with: healthcareEnvs) {
                    score += 10
                } else if isTradeCategory && !userEnvSet.isDisjoint(with: tradeEnvs) {
                    score += 10
                } else if isTechCategory && !userEnvSet.isDisjoint(with: officeEnvs) {
                    score += 10
                } else if isMilitaryCategory && !userEnvSet.isDisjoint(with: militaryEnvs) {
                    score += 10
                } else {
                    score += 4
                }
            } else {
                score += 10
            }

            maxScore += 10
            var interestBonus: Double = 0
            for interest in path.alignedInterests {
                if userInterests.contains(interest) { interestBonus += 3 }
            }
            score += min(interestBonus, 10)

            let userMatch = maxScore > 0 ? (score / maxScore) * 100 : 50
            let finalScore = CareerScoringEngine.shared.adjustedFinalScore(
                userMatchScore: min(99, userMatch),
                requiresLicense: path.requiresLicense,
                incomeLevel: path.incomeLevel,
                demandLevel: path.demandLevel,
                categoryTier: path.categoryTier,
                isFastStart: path.isFastStart,
                isScalable: path.isScalable
            )
            scores[path.id] = min(Int(finalScore), 99)
        }
        return scores
    }

    // MARK: - Degree Career Scoring

    nonisolated static func scoreDegreeRecords(profile: UserProfile) -> [String: Int] {
        var scores: [String: Int] = [:]
        for record in DegreeCareerDatabase.allRecords {
            var score: Double = 0
            var maxScore: Double = 0

            maxScore += 30
            if let selectedEdu = profile.educationWillingnesses.first {
                let selectedIndex = EducationWillingness.allCases.firstIndex(of: selectedEdu) ?? 0
                let twoYearIndex = EducationWillingness.allCases.firstIndex(of: .twoYear) ?? 3
                let fourYearIndex = EducationWillingness.allCases.firstIndex(of: .fourYear) ?? 4
                if selectedIndex >= fourYearIndex {
                    score += 30
                } else if selectedIndex >= twoYearIndex {
                    score += 20
                } else if selectedIndex >= twoYearIndex - 1 {
                    score += 10
                } else {
                    score += 3
                }
            } else {
                score += 15
            }

            maxScore += 12
            if let motivation = profile.motivationGoal {
                switch motivation {
                case .professionalStatus:
                    if [.legal, .engineering, .healthcare, .aviation].contains(record.category) {
                        score += 12
                    } else { score += 6 }
                case .helpPeople:
                    if [.healthcare, .mentalHealth, .education].contains(record.category) {
                        score += 12
                    } else { score += 5 }
                case .stableSkill:
                    if [.healthcare, .engineering].contains(record.category) { score += 9 }
                    else { score += 4 }
                case .ownBoss:
                    score += 4
                }
            } else {
                score += 7
            }

            maxScore += 20
            if let timeline = profile.incomeTimeline {
                switch timeline {
                case .asap: score += 3
                case .oneToThree: score += 5
                case .threeToSix: score += 10
                case .noRush: score += 20
                }
            }

            maxScore += 15
            if let pref = profile.workPreference {
                let isPhysicalCareer = [DegreeCareerCategory.healthcare, .engineering, .aviation].contains(record.category)
                let isOfficeCareer = [DegreeCareerCategory.legal, .mentalHealth, .education].contains(record.category)
                switch pref {
                case .physical:
                    if isPhysicalCareer { score += 15 } else { score += 5 }
                case .digital:
                    if isOfficeCareer { score += 15 } else { score += 8 }
                case .either:
                    score += 15
                }
            }

            maxScore += 15
            if !profile.workEnvironments.isEmpty {
                let categoryEnvs = Self.environmentsForDegreeCategory(record.category)
                let matchCount = profile.workEnvironments.filter { categoryEnvs.contains($0) }.count
                if matchCount > 0 {
                    let ratio = Double(matchCount) / Double(max(profile.workEnvironments.count, 1))
                    score += 15 * min(ratio * 1.5, 1.0)
                } else {
                    score += 3
                }
            } else {
                score += 15
            }

            maxScore += 15
            if !profile.workConditions.isEmpty {
                let categoryConditions = Self.conditionsForDegreeCategory(record.category)
                let matchCount = profile.workConditions.filter { categoryConditions.contains($0) }.count
                if matchCount > 0 {
                    let ratio = Double(matchCount) / Double(max(profile.workConditions.count, 1))
                    score += 15 * min(ratio * 1.5, 1.0)
                } else {
                    score += 3
                }
            } else {
                score += 15
            }

            maxScore += 10
            let tierBonus: Double = record.aiProofTier == .tier1 ? 10 : record.aiProofTier == .tier2 ? 7 : 4
            score += tierBonus

            let userMatch = maxScore > 0 ? (score / maxScore) * 100 : 50

            let incomeLevel: IncomeLevel
            if record.salaryExperienced.contains("100K") || record.salaryExperienced.contains("120K") || record.salaryExperienced.contains("140K") || record.salaryExperienced.contains("150K") || record.salaryExperienced.contains("200K") || record.salaryExperienced.contains("250K") || record.salaryExperienced.contains("500K") {
                incomeLevel = .high
            } else {
                incomeLevel = .medium
            }

            let finalScore = CareerScoringEngine.shared.adjustedFinalScore(
                userMatchScore: min(99, userMatch),
                requiresLicense: record.licensingRequired,
                incomeLevel: incomeLevel,
                demandLevel: .medium,
                categoryTier: .highValue,
                isFastStart: false,
                isScalable: false
            )
            scores[record.id] = min(Int(finalScore), 99)
        }
        return scores
    }

    private nonisolated static func environmentsForDegreeCategory(_ category: DegreeCareerCategory) -> Set<WorkEnvironment> {
        switch category {
        case .healthcare:
            return [.hospital, .clinic, .laboratory]
        case .mentalHealth:
            return [.clinic, .officeDesk, .classroom]
        case .engineering:
            return [.officeDesk, .laboratory, .constructionSite, .warehouse]
        case .legal:
            return [.courtroom, .officeDesk, .hospital, .clinic]
        case .education:
            return [.classroom, .officeDesk]
        case .aviation:
            return [.aircraft, .officeDesk]
        case .military:
            return [.outdoors, .aircraft, .officeDesk]
        }
    }

    private nonisolated static func conditionsForDegreeCategory(_ category: DegreeCareerCategory) -> Set<WorkCondition> {
        switch category {
        case .healthcare:
            return [.patientCare, .longShifts, .highStakes, .emotionalSituations, .sterileEnvironment, .chemicals]
        case .mentalHealth:
            return [.patientCare, .emotionalSituations, .officeDesk]
        case .engineering:
            return [.officeDesk, .highStakes, .outdoorHeat, .cold]
        case .legal:
            return [.publicSpeaking, .highStakes, .officeDesk, .longShifts]
        case .education:
            return [.publicSpeaking, .emotionalSituations, .officeDesk]
        case .aviation:
            return [.highStakes, .longShifts, .heights]
        case .military:
            return [.heavyLifting, .heights, .highStakes, .longShifts, .outdoorHeat, .cold]
        }
    }

    private nonisolated static func educationLevelForPath(_ path: EducationPath) -> EducationWillingness {
        let time = path.timeToComplete.lowercased()
        if time.contains("4") || time.contains("5") || time.contains("year") && (time.contains("4") || time.contains("5")) {
            return .tradeSchool
        }
        if time.contains("week") || time.contains("1 month") || time.contains("2 month") || time.contains("3 month") {
            return .shortCert
        }
        if time.contains("6 month") || time.contains("12 month") || time.contains("1 year") || time.contains("2 year") {
            return .tradeSchool
        }
        switch path.category {
        case .trade: return .tradeSchool
        case .certification: return .shortCert
        case .healthcare: return .twoYear
        case .technology: return .shortCert
        case .business: return .shortCert
        case .creative: return .selfTaught
        case .military: return .tradeSchool
        }
    }
}
