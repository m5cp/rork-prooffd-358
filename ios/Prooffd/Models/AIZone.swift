import Foundation

nonisolated enum AIZone: String, Codable, Sendable, CaseIterable, Identifiable {
    case safe = "Safe"
    case human = "Human"
    case augmented = "Augmented"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .safe: return "High Resistance"
        case .human: return "Medium Resistance"
        case .augmented: return "Low Resistance"
        }
    }

    var description: String {
        switch self {
        case .safe: return "This path is highly resistant to AI disruption. It requires physical presence, human judgment, or hands-on skill that AI cannot replicate."
        case .human: return "This path benefits from human expertise but may see some AI-assisted tools. The core work still requires human involvement."
        case .augmented: return "AI tools are already impacting this field. Success requires adapting to and leveraging AI rather than competing with it."
        }
    }

    var icon: String {
        switch self {
        case .safe: return "shield.checkered"
        case .human: return "person.fill.checkmark"
        case .augmented: return "cpu"
        }
    }

    var scoreRange: String {
        switch self {
        case .safe: return "80–100"
        case .human: return "50–79"
        case .augmented: return "0–49"
        }
    }

    static func from(score: Int) -> AIZone {
        switch score {
        case 80...100: return .safe
        case 50...79: return .human
        default: return .augmented
        }
    }
}
