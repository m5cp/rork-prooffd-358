import SwiftUI

// MARK: - Logo

/// A generated logo mark. Stored as a recipe (not an image) so it stays tiny,
/// renders crisply at any size, and can be restyled instantly.
nonisolated struct LogoDesign: Codable, Sendable, Equatable {
    var symbol: String = "hammer.fill"
    var shape: LogoShape = .roundedSquare
    var paletteId: String = "electric"
    var useMonogram: Bool = false

    var palette: LogoPalette {
        LogoPalette.all.first { $0.id == paletteId } ?? LogoPalette.all[0]
    }


    /// Curated SF Symbols that read well as a logo mark.
    static let symbolChoices: [String] = [
        "hammer.fill", "wrench.and.screwdriver.fill", "paintbrush.fill",
        "leaf.fill", "bolt.fill", "flame.fill", "drop.fill", "sparkles",
        "house.fill", "car.fill", "pawprint.fill", "scissors",
        "fork.knife", "cup.and.saucer.fill", "camera.fill", "laptopcomputer",
        "cart.fill", "bag.fill", "shippingbox.fill", "key.fill",
        "star.fill", "crown.fill", "shield.fill", "mountain.2.fill",
        "sun.max.fill", "moon.fill", "heart.fill", "music.note",
        "gearshape.fill", "cube.fill", "chart.line.uptrend.xyaxis", "globe"
    ]
}

nonisolated enum LogoShape: String, Codable, CaseIterable, Identifiable, Sendable {
    case circle, roundedSquare, shield, hexagon, none

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .circle:        return "Circle"
        case .roundedSquare: return "Rounded"
        case .shield:        return "Shield"
        case .hexagon:       return "Hexagon"
        case .none:          return "Mark only"
        }
    }
}

nonisolated struct LogoPalette: Identifiable, Sendable, Equatable {
    let id: String
    let name: String
    let hexes: [String]

    @MainActor var colors: [Color] { hexes.map { Color(hex: $0) } }
    @MainActor var primary: Color { colors.first ?? .green }
    @MainActor var secondary: Color { colors.count > 1 ? colors[1] : primary }
    @MainActor var ink: Color { Color(hex: hexes.last ?? "0B0F14") }

    static let all: [LogoPalette] = [
        LogoPalette(id: "electric",  name: "Electric",  hexes: ["34D399", "22D3EE", "0B0F14"]),
        LogoPalette(id: "sunset",    name: "Sunset",    hexes: ["FB923C", "F43F5E", "1A0F14"]),
        LogoPalette(id: "midnight",  name: "Midnight",  hexes: ["818CF8", "38BDF8", "0B1020"]),
        LogoPalette(id: "forest",    name: "Forest",    hexes: ["22C55E", "84CC16", "0F1A10"]),
        LogoPalette(id: "gold",      name: "Gold",      hexes: ["FBBF24", "F59E0B", "1A1405"]),
        LogoPalette(id: "steel",     name: "Steel",     hexes: ["94A3B8", "CBD5E1", "0F172A"]),
        LogoPalette(id: "berry",     name: "Berry",     hexes: ["F472B6", "A855F7", "1A0B1A"]),
        LogoPalette(id: "clay",      name: "Clay",      hexes: ["EA580C", "78350F", "1C1008"])
    ]
}

// MARK: - Expenses

nonisolated enum ExpenseKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case oneTime = "One-time"
    case monthly = "Monthly"

    var id: String { rawValue }
}

nonisolated struct PlanExpense: Identifiable, Codable, Sendable, Equatable {
    var id: UUID = UUID()
    var name: String
    var amount: Double
    var kind: ExpenseKind = .oneTime
    var isEssential: Bool = true
}

// MARK: - Plan Sections

/// The guided sections of the builder, in the order a founder should work
/// through them.
nonisolated enum PlanStage: String, Codable, CaseIterable, Identifiable, Sendable {
    case idea, problem, customer, offer, pricing, money, brand, launch

    var id: String { rawValue }

    var title: String {
        switch self {
        case .idea:     return "The Idea"
        case .problem:  return "The Problem"
        case .customer: return "Your Customer"
        case .offer:    return "What You Sell"
        case .pricing:  return "Pricing"
        case .money:    return "Money & Expenses"
        case .brand:    return "Name & Logo"
        case .launch:   return "Launch Plan"
        }
    }

    var blurb: String {
        switch self {
        case .idea:     return "What the business actually is, in one line."
        case .problem:  return "The pain you remove for someone."
        case .customer: return "Exactly who pays you."
        case .offer:    return "The services or products you deliver."
        case .pricing:  return "What you charge and why."
        case .money:    return "Startup costs, monthly costs, break-even."
        case .brand:    return "Your name and a logo mark."
        case .launch:   return "Your first 30 days, step by step."
        }
    }

    var icon: String {
        switch self {
        case .idea:     return "lightbulb.fill"
        case .problem:  return "exclamationmark.bubble.fill"
        case .customer: return "person.2.fill"
        case .offer:    return "shippingbox.fill"
        case .pricing:  return "tag.fill"
        case .money:    return "dollarsign.circle.fill"
        case .brand:    return "paintpalette.fill"
        case .launch:   return "flag.checkered"
        }
    }

    var accent: Color {
        switch self {
        case .idea:     return Color(hex: "FBBF24")
        case .problem:  return Color(hex: "F43F5E")
        case .customer: return Color(hex: "60A5FA")
        case .offer:    return Color(hex: "34D399")
        case .pricing:  return Color(hex: "A855F7")
        case .money:    return Color(hex: "22C55E")
        case .brand:    return Color(hex: "F472B6")
        case .launch:   return Color(hex: "22D3EE")
        }
    }
}

// MARK: - Venture Plan

/// A founder's own business plan, built start to finish inside the app.
nonisolated struct VenturePlan: Identifiable, Codable, Sendable, Equatable {
    var id: UUID = UUID()
    var businessName: String = ""
    var tagline: String = ""

    var idea: String = ""
    var problem: String = ""
    var solution: String = ""

    var customerDescription: String = ""
    var customerLocation: String = ""

    var offers: [String] = []
    var pricingNotes: String = ""
    var priceLow: String = ""
    var priceHigh: String = ""

    var expenses: [PlanExpense] = []
    var revenueGoalMonthly: String = ""

    var logo: LogoDesign = LogoDesign()

    var launchSteps: [LaunchStep] = LaunchStep.starterSteps
    var linkedPathId: String? = nil
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    // MARK: Derived money

    var startupTotal: Double {
        expenses.filter { $0.kind == .oneTime }.reduce(0) { $0 + $1.amount }
    }

    var monthlyTotal: Double {
        expenses.filter { $0.kind == .monthly }.reduce(0) { $0 + $1.amount }
    }

    /// Average sale price, derived from the low/high range.
    var averagePrice: Double {
        let low = Double(priceLow.filter { $0.isNumber || $0 == "." }) ?? 0
        let high = Double(priceHigh.filter { $0.isNumber || $0 == "." }) ?? 0
        if low > 0 && high > 0 { return (low + high) / 2 }
        return max(low, high)
    }

    /// Sales per month needed to cover monthly costs.
    var breakEvenSales: Int? {
        guard averagePrice > 0, monthlyTotal > 0 else { return nil }
        return Int(ceil(monthlyTotal / averagePrice))
    }

    /// Sales needed to also repay the startup spend within 6 months.
    var salesToRepayStartup: Int? {
        guard averagePrice > 0, startupTotal > 0 else { return nil }
        return Int(ceil(startupTotal / averagePrice))
    }

    // MARK: Completion

    func isStageComplete(_ stage: PlanStage) -> Bool {
        switch stage {
        case .idea:     return !idea.trimmed.isEmpty
        case .problem:  return !problem.trimmed.isEmpty && !solution.trimmed.isEmpty
        case .customer: return !customerDescription.trimmed.isEmpty
        case .offer:    return !offers.isEmpty
        case .pricing:  return averagePrice > 0
        case .money:    return !expenses.isEmpty
        case .brand:    return !businessName.trimmed.isEmpty
        case .launch:   return launchSteps.contains { $0.isDone }
        }
    }

    var completedStageCount: Int {
        PlanStage.allCases.filter { isStageComplete($0) }.count
    }

    var progress: Double {
        Double(completedStageCount) / Double(PlanStage.allCases.count)
    }

    var isReadyToExport: Bool { completedStageCount >= 6 }
}

// MARK: - Launch Steps

nonisolated struct LaunchStep: Identifiable, Codable, Sendable, Equatable {
    var id: UUID = UUID()
    var title: String
    var detail: String
    var week: Int
    var isDone: Bool = false

    static let starterSteps: [LaunchStep] = [
        LaunchStep(title: "Lock in your offer", detail: "Write down exactly what you sell and for how much.", week: 1),
        LaunchStep(title: "Pick your name", detail: "Check it isn't taken locally, then claim a social handle.", week: 1),
        LaunchStep(title: "Tell 10 people", detail: "Friends, family, neighbors. Your first customer is usually someone you know.", week: 1),
        LaunchStep(title: "Set up how you get paid", detail: "A payment app is enough to start. Don't overthink it.", week: 2),
        LaunchStep(title: "Make one simple flyer or post", detail: "Name, what you do, price, phone number. That's it.", week: 2),
        LaunchStep(title: "Land your first paying job", detail: "Charge real money, even if it's discounted.", week: 3),
        LaunchStep(title: "Ask for a photo and a review", detail: "Proof is what gets you customer number two.", week: 3),
        LaunchStep(title: "Register the business", detail: "Sole proprietor or LLC, plus any local permit you need.", week: 4),
        LaunchStep(title: "Raise your price or repeat", detail: "If the first job went well, do it again and charge more.", week: 4)
    ]
}

extension String {
    /// Whitespace-stripped copy, used for "did the founder actually fill this in" checks.
    nonisolated var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
