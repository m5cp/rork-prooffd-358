import SwiftUI

enum Theme {
    static let accent = Color(hex: "34D399")
    static let accentBlue = Color(hex: "3B82F6")

    static let background = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 10/255, green: 14/255, blue: 26/255, alpha: 1)
            : .systemBackground
    })

    static let cardBackground = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 20/255, green: 25/255, blue: 41/255, alpha: 1)
            : .secondarySystemGroupedBackground
    })

    static let cardBackgroundLight = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 28/255, green: 34/255, blue: 55/255, alpha: 1)
            : .tertiarySystemGroupedBackground
    })

    static let textPrimary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? .white : .label
    })

    static let textSecondary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.6)
            : .secondaryLabel
    })

    static let textTertiary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.4)
            : .tertiaryLabel
    })

    static func categoryColor(for category: BusinessCategory) -> Color {
        switch category {
        case .homeProperty: return Color(hex: "60A5FA")
        case .autoTransport: return Color(hex: "2DD4BF")
        case .outdoorLandscape: return Color(hex: "4ADE80")
        case .foodBeverage: return Color(hex: "FB923C")
        case .petServices: return Color(hex: "67E8F9")
        case .personalCare: return Color(hex: "22D3EE")
        case .digitalCreative: return Color(hex: "818CF8")
        case .productCraft: return Color(hex: "FBBF24")
        case .eventsEntertainment: return Color(hex: "F472B6")
        case .skilledTrades: return Color(hex: "94A3B8")
        }
    }
}

extension String {
    var strippingEmoji: String {
        unicodeScalars.filter { scalar in
            let v = scalar.value
            if v <= 0x007E { return true }
            if v >= 0x2700 && v <= 0x27BF { return false }
            if v >= 0x1F600 && v <= 0x1F64F { return false }
            if v >= 0x1F300 && v <= 0x1F5FF { return false }
            if v >= 0x1F680 && v <= 0x1F6FF { return false }
            if v >= 0x1F900 && v <= 0x1F9FF { return false }
            if v >= 0x1FA00 && v <= 0x1FA6F { return false }
            if v >= 0x1FA70 && v <= 0x1FAFF { return false }
            if v >= 0x2600 && v <= 0x26FF { return false }
            if v >= 0xFE00 && v <= 0xFE0F { return false }
            if v >= 0x200D && v <= 0x200D { return false }
            if v == 0x20E3 { return false }
            if v >= 0xE0020 && v <= 0xE007F { return false }
            if v >= 0x2300 && v <= 0x23FF { return false }
            if scalar.properties.isEmoji && scalar.properties.isEmojiPresentation { return false }
            return true
        }
        .reduce(into: "") { $0 += String($1) }
        .replacingOccurrences(of: "  +", with: " ", options: .regularExpression)
        .trimmingCharacters(in: .whitespaces)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
