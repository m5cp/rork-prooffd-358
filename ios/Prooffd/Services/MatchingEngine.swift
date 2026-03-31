import Foundation

enum MatchingEngine {
    nonisolated static func match(profile: UserProfile, paths: [BusinessPath]) -> [MatchResult] {
        let hasAnswers = !profile.selectedCategories.isEmpty || profile.budget != nil || profile.workPreference != nil || !profile.situationTags.isEmpty

        if !hasAnswers {
            return browseAll(paths: paths)
        }

        var results: [MatchResult] = []

        for path in paths {
            var score: Double = 0
            var maxScore: Double = 0

            maxScore += 20
            if profile.selectedCategories.contains(path.category) {
                score += 20
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

            maxScore += 7
            if !profile.educationWillingnesses.isEmpty {
                let eduReq = path.educationRequired.lowercased()
                let requiredLevel: EducationWillingness
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
                if profile.educationWillingnesses.contains(requiredLevel) {
                    score += 7
                } else if profile.educationWillingnesses.contains(where: { EducationWillingness.allCases.firstIndex(of: $0)! >= EducationWillingness.allCases.firstIndex(of: requiredLevel)! }) {
                    score += 5
                } else {
                    score += 2
                }
            }

            maxScore += 2
            if let fastCash = profile.needsFastCash {
                if fastCash && path.fastCashPotential { score += 2 }
                else if !fastCash { score += 2 }
                else { score += 1 }
            }

            let percentage = maxScore > 0 ? Int((score / maxScore) * 100) : 0

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
}
