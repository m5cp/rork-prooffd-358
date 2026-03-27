import SwiftUI

nonisolated enum ShareCardType: String, CaseIterable, Identifiable, Sendable {
    case quizResults = "Quiz Results"
    case topMatch = "Top Match"
    case progress = "Progress"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .quizResults: return "list.number"
        case .topMatch: return "star.fill"
        case .progress: return "chart.bar.fill"
        }
    }
}

nonisolated enum ShareCardStyle: String, CaseIterable, Identifiable, Sendable {
    case clean = "Clean"
    case bold = "Bold"
    case premium = "Premium"

    var id: String { rawValue }
}

nonisolated enum ShareCardFormat: String, CaseIterable, Identifiable, Sendable {
    case story = "Story"
    case square = "Square"

    var id: String { rawValue }

    var size: CGSize {
        switch self {
        case .story: return CGSize(width: 1080, height: 1920)
        case .square: return CGSize(width: 1080, height: 1080)
        }
    }

    var canvasSize: CGSize {
        switch self {
        case .story: return CGSize(width: 360, height: 640)
        case .square: return CGSize(width: 360, height: 360)
        }
    }

    var label: String {
        switch self {
        case .story: return "9:16"
        case .square: return "1:1"
        }
    }
}

struct ShareCardContent {
    let type: ShareCardType
    var topMatches: [(name: String, percent: Int, icon: String, zone: AIZone)] = []
    var jobTitle: String = ""
    var matchPercent: Int = 0
    var aiZone: AIZone = .human
    var typicalRate: String = ""
    var perfectFor: String = ""
    var buildName: String = ""
    var progressPercent: Int = 0
    var milestoneLine: String = ""

    static func quizResults(from results: [MatchResult]) -> ShareCardContent {
        let top3 = Array(results.prefix(3))
        return ShareCardContent(
            type: .quizResults,
            topMatches: top3.map { ($0.businessPath.name, $0.scorePercentage, $0.businessPath.icon, $0.businessPath.zone) }
        )
    }

    static func topMatch(from result: MatchResult) -> ShareCardContent {
        let path = result.businessPath
        let fitLine: String
        if path.isDigital && path.soloFriendly {
            fitLine = "remote work + flexible schedule"
        } else if path.fastCashPotential {
            fitLine = "fast income + low startup cost"
        } else if path.soloFriendly {
            fitLine = "solo-friendly + scalable"
        } else {
            fitLine = "high demand + strong earning potential"
        }
        return ShareCardContent(
            type: .topMatch,
            jobTitle: path.name,
            matchPercent: result.scorePercentage,
            aiZone: path.zone,
            typicalRate: path.typicalMarketRates.isEmpty ? path.starterPricing : path.typicalMarketRates,
            perfectFor: fitLine
        )
    }

    static func progress(from build: BuildProject) -> ShareCardContent {
        let milestone: String
        switch build.progressPercentage {
        case 0..<10: milestone = "Just getting started"
        case 10..<25: milestone = "First steps complete"
        case 25..<50: milestone = "Building momentum"
        case 50..<75: milestone = "Over halfway there"
        case 75..<100: milestone = "Almost launch-ready"
        default: milestone = "Build complete"
        }
        return ShareCardContent(
            type: .progress,
            buildName: build.businessName.isEmpty ? build.pathName : build.businessName,
            progressPercent: build.progressPercentage,
            milestoneLine: milestone
        )
    }
}
