import SwiftUI

enum Theme {

    static let accent = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0x34D399)
            : UIColor(hex6: 0x059669)
    })

    static let accentBlue = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0x60A5FA)
            : UIColor(hex6: 0x2563EB)
    })

    static let background = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0x0F1117)
            : UIColor(hex6: 0xF5F5F7)
    })

    static let cardBackground = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0x1C1E27)
            : UIColor(hex6: 0xFFFFFF)
    })

    static let cardBackgroundLight = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0x262933)
            : UIColor(hex6: 0xEFEFF1)
    })

    static let textPrimary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0xF0F0F5)
            : UIColor(hex6: 0x1A1A1E)
    })

    static let textSecondary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0xA1A1AA)
            : UIColor(hex6: 0x5C5C66)
    })

    static let textTertiary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0x71717A)
            : UIColor(hex6: 0x9A9AA2)
    })

    static let border = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0x2A2D38)
            : UIColor(hex6: 0xE5E5EA)
    })

    static let cardShadow = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            : UIColor(red: 0, green: 0, blue: 0, alpha: 0.06)
    })

    static let success = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0x34D399)
            : UIColor(hex6: 0x10B981)
    })

    static let warning = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex6: 0xFBBF24)
            : UIColor(hex6: 0xD97706)
    })

    static func categoryColor(for category: BusinessCategory) -> Color {
        Color(UIColor { traits in
            let isDark = traits.userInterfaceStyle == .dark
            switch category {
            case .homeProperty:
                return isDark ? UIColor(hex6: 0x60A5FA) : UIColor(hex6: 0x2563EB)
            case .autoTransport:
                return isDark ? UIColor(hex6: 0x2DD4BF) : UIColor(hex6: 0x0D9488)
            case .outdoorLandscape:
                return isDark ? UIColor(hex6: 0x4ADE80) : UIColor(hex6: 0x16A34A)
            case .foodBeverage:
                return isDark ? UIColor(hex6: 0xFB923C) : UIColor(hex6: 0xEA580C)
            case .petServices:
                return isDark ? UIColor(hex6: 0x67E8F9) : UIColor(hex6: 0x0891B2)
            case .personalCare:
                return isDark ? UIColor(hex6: 0x22D3EE) : UIColor(hex6: 0x0E7490)
            case .digitalCreative:
                return isDark ? UIColor(hex6: 0x818CF8) : UIColor(hex6: 0x4F46E5)
            case .productCraft:
                return isDark ? UIColor(hex6: 0xFBBF24) : UIColor(hex6: 0xD97706)
            case .eventsEntertainment:
                return isDark ? UIColor(hex6: 0xF472B6) : UIColor(hex6: 0xDB2777)
            case .skilledTrades:
                return isDark ? UIColor(hex6: 0x94A3B8) : UIColor(hex6: 0x475569)
            }
        })
    }
}

extension UIColor {
    convenience init(hex6: UInt32) {
        self.init(
            red: CGFloat((hex6 >> 16) & 0xFF) / 255,
            green: CGFloat((hex6 >> 8) & 0xFF) / 255,
            blue: CGFloat(hex6 & 0xFF) / 255,
            alpha: 1
        )
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
