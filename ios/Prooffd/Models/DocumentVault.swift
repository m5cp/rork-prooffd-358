import Foundation

nonisolated enum DocumentCategory: String, CaseIterable, Sendable {
    case legal      = "Legal"
    case financial  = "Financial"
    case marketing  = "Marketing"
    case guides     = "Guides"

    var icon: String {
        switch self {
        case .legal:     return "doc.badge.gearshape.fill"
        case .financial: return "dollarsign.square.fill"
        case .marketing: return "megaphone.fill"
        case .guides:    return "book.fill"
        }
    }
}

nonisolated struct VaultDocument: Identifiable, Sendable {
    let id: String
    let title: String
    let icon: String
    let category: DocumentCategory
    let description: String
    let content: String
    let isPro: Bool
}
