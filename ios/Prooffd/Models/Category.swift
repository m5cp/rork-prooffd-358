import Foundation

nonisolated enum BusinessCategory: String, CaseIterable, Identifiable, Codable, Sendable {
    case homeProperty = "Home & Property"
    case autoTransport = "Auto & Transport"
    case outdoorLandscape = "Outdoor & Landscape"
    case foodBeverage = "Food & Beverage"
    case petServices = "Pet Services"
    case personalCare = "Personal & Care"
    case digitalCreative = "Digital & Creative"
    case productCraft = "Product & Craft"
    case eventsEntertainment = "Events & Entertainment"
    case skilledTrades = "Skilled Trades"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .homeProperty: return "house.fill"
        case .autoTransport: return "car.fill"
        case .outdoorLandscape: return "leaf.fill"
        case .foodBeverage: return "fork.knife"
        case .petServices: return "pawprint.fill"
        case .personalCare: return "person.fill"
        case .digitalCreative: return "laptopcomputer"
        case .productCraft: return "paintbrush.fill"
        case .eventsEntertainment: return "party.popper.fill"
        case .skilledTrades: return "wrench.and.screwdriver.fill"
        }
    }

    var color: String {
        switch self {
        case .homeProperty: return "blue"
        case .autoTransport: return "teal"
        case .outdoorLandscape: return "green"
        case .foodBeverage: return "orange"
        case .petServices: return "mint"
        case .personalCare: return "cyan"
        case .digitalCreative: return "indigo"
        case .productCraft: return "yellow"
        case .eventsEntertainment: return "pink"
        case .skilledTrades: return "gray"
        }
    }
}
