import Foundation

nonisolated enum CategoryTier: String, Codable, Sendable {
    case highValue
    case skilledTrade
    case standard
    case sideHustle
}

nonisolated enum IncomeLevel: String, Codable, Sendable {
    case low
    case medium
    case high
}

nonisolated enum DemandLevel: String, Codable, Sendable {
    case low
    case medium
    case high
}

final class CareerScoringEngine {
    static let shared = CareerScoringEngine()

    private init() {}

    func calculateQualityScore(
        requiresLicense: Bool,
        incomeLevel: IncomeLevel,
        demandLevel: DemandLevel,
        categoryTier: CategoryTier,
        isFastStart: Bool = false,
        isScalable: Bool = false
    ) -> Double {
        var score: Double = 0

        if requiresLicense {
            score += 20
        }

        switch incomeLevel {
        case .low:
            score += 6
        case .medium:
            score += 13
        case .high:
            score += 20
        }

        switch demandLevel {
        case .low:
            score += 5
        case .medium:
            score += 10
        case .high:
            score += 15
        }

        switch categoryTier {
        case .highValue:
            score += 20
        case .skilledTrade:
            score += 16
        case .standard:
            score += 10
        case .sideHustle:
            score += 4
        }

        if isFastStart {
            score += 10
        }

        if isScalable {
            score += 10
        }

        return min(score, 95)
    }

    func adjustedFinalScore(
        userMatchScore: Double,
        requiresLicense: Bool,
        incomeLevel: IncomeLevel,
        demandLevel: DemandLevel,
        categoryTier: CategoryTier,
        isFastStart: Bool = false,
        isScalable: Bool = false
    ) -> Double {
        let qualityScore = calculateQualityScore(
            requiresLicense: requiresLicense,
            incomeLevel: incomeLevel,
            demandLevel: demandLevel,
            categoryTier: categoryTier,
            isFastStart: isFastStart,
            isScalable: isScalable
        )

        var finalScore = min(99, (userMatchScore * 0.60) + (qualityScore * 0.40))

        if categoryTier == .sideHustle {
            finalScore = min(finalScore, 65)
        }

        return finalScore
    }
}
