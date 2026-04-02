import Foundation

nonisolated struct ScoringUpdate: Sendable {
    let requiresLicense: Bool
    let incomeLevel: IncomeLevel
    let demandLevel: DemandLevel
    let categoryTier: CategoryTier
    let isFastStart: Bool
    let isScalable: Bool
    let alignedInterests: [String]
}

nonisolated enum Phase5ScoringData {
    static func applyAll(_ paths: [BusinessPath]) -> [BusinessPath] {
        paths.map { path in
            guard let update = updates[path.id] else { return path }
            var updated = path
            updated.requiresLicense = update.requiresLicense
            updated.incomeLevel = update.incomeLevel
            updated.demandLevel = update.demandLevel
            updated.categoryTier = update.categoryTier
            updated.isFastStart = update.isFastStart
            updated.isScalable = update.isScalable
            updated.alignedInterests = update.alignedInterests
            return updated
        }
    }

    static let updates: [String: ScoringUpdate] = [
        // ========================
        // HOME / PROPERTY
        // ========================
        "yard-cleanup": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial", "low_cost"]),
        "house-cleaning": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["fast_start", "entrepreneurial", "low_cost"]),
        "gutter-cleaning": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "window-cleaning": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "carpet-cleaning": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["fast_start", "entrepreneurial"]),
        "house-painting": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial", "fast_start"]),
        "snow-removal": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "home-organizing": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "fast_start", "entrepreneurial"]),
        "roof-repair": ScoringUpdate(requiresLicense: true, incomeLevel: .high, demandLevel: .high, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["high_income", "hands_on", "entrepreneurial"]),
        "power-washing-commercial": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "junk-removal": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "deck-staining": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "holiday-lights": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["fast_start", "entrepreneurial", "hands_on"]),
        "garage-organizing": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "fast_start"]),
        "furniture-assembly": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "moving-helper": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "chimney-sweep": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "tile-grout-cleaning": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["fast_start", "entrepreneurial"]),
        "dryer-vent-cleaning": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .skilledTrade, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "screen-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "cabinet-refinishing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "creative", "entrepreneurial"]),
        "closet-organizing": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "fast_start"]),
        "attic-insulation": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),

        // ========================
        // FOOD / BEVERAGE
        // ========================
        "meal-prep": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial", "fast_start"]),
        "baked-goods": ScoringUpdate(requiresLicense: true, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "fast_start", "low_cost"]),
        "food-truck": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["entrepreneurial", "people_facing", "hands_on"]),
        "personal-chef": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "people_facing", "entrepreneurial"]),
        "coffee-cart": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["entrepreneurial", "people_facing", "fast_start"]),
        "smoothie-bar": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["entrepreneurial", "people_facing"]),
        "bbq-catering": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["entrepreneurial", "people_facing", "hands_on"]),
        "farmers-market-vendor": ScoringUpdate(requiresLicense: true, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["entrepreneurial", "creative", "fast_start"]),
        "candy-treats": ScoringUpdate(requiresLicense: true, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "fast_start"]),
        "hot-sauce": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "entrepreneurial"]),
        "cake-decorating": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "people_facing"]),
        "food-delivery-own": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start"]),
        "kombucha-brewing": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "entrepreneurial"]),
        "charcuterie-boards": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "people_facing"]),
        "private-dining": ScoringUpdate(requiresLicense: true, incomeLevel: .high, demandLevel: .medium, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["creative", "people_facing", "entrepreneurial", "high_income"]),
        "cookie-decorating": ScoringUpdate(requiresLicense: true, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "fast_start"]),
        "spice-blends": ScoringUpdate(requiresLicense: true, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "low_cost"]),
        "ice-cream-cart": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial"]),
        "meal-kit-delivery": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["entrepreneurial", "people_facing"]),
        "popcorn-business": ScoringUpdate(requiresLicense: true, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "fast_start"]),

        // ========================
        // PET SERVICES
        // ========================
        "dog-walking": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start", "people_facing"]),
        "pet-sitting": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start", "people_facing"]),
        "pet-grooming": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial", "hands_on"]),
        "pet-photography": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["creative", "people_facing"]),
        "dog-training": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial"]),
        "aquarium-maintenance": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "pet-taxi": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start", "people_facing"]),
        "pet-treat-bakery": ScoringUpdate(requiresLicense: true, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "low_cost"]),
        "pooper-scooper-commercial": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start", "hands_on"]),
        "cat-sitting": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start"]),
        "dog-daycare-home": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial"]),

        // ========================
        // PERSONAL CARE
        // ========================
        "mobile-barber": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .high, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial", "hands_on"]),
        "mobile-nails": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "people_facing", "entrepreneurial"]),
        "mobile-massage": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial", "hands_on"]),
        "makeup-artist": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "people_facing", "entrepreneurial"]),
        "lash-tech": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "people_facing", "entrepreneurial"]),
        "hair-braiding": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "people_facing", "entrepreneurial"]),
        "personal-shopping": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "fast_start"]),
        "senior-care-companion": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "fast_start"]),
        "childcare": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .high, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial"]),
        "errand-running": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start", "people_facing"]),
        "life-coaching": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "entrepreneurial"]),
        "notary-public": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["low_cost", "fast_start", "entrepreneurial"]),
        "resume-writing": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "remote", "fast_start"]),
        "laundry-service": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start", "low_cost"]),
        "house-checking": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start"]),
        "mobile-car-seat-install": ScoringUpdate(requiresLicense: true, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: false, alignedInterests: ["people_facing", "hands_on"]),
        "language-tutoring": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "remote", "fast_start"]),
        "elderly-tech-help": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "fast_start", "low_cost"]),

        // ========================
        // DIGITAL / CREATIVE
        // ========================
        "freelance-writing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["remote", "creative", "fast_start", "low_cost"]),
        "graphic-design": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "remote", "entrepreneurial"]),
        "video-editing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "remote", "entrepreneurial"]),
        "photography": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "people_facing"]),
        "virtual-assistant": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["remote", "fast_start", "low_cost", "entrepreneurial"]),
        "online-tutoring": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["remote", "people_facing", "entrepreneurial"]),
        "podcast-production": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "remote", "entrepreneurial"]),
        "seo-services": ScoringUpdate(requiresLicense: false, incomeLevel: .high, demandLevel: .high, categoryTier: .highValue, isFastStart: true, isScalable: true, alignedInterests: ["remote", "high_income", "entrepreneurial"]),
        "email-marketing": ScoringUpdate(requiresLicense: false, incomeLevel: .high, demandLevel: .medium, categoryTier: .highValue, isFastStart: true, isScalable: true, alignedInterests: ["remote", "entrepreneurial", "high_income"]),
        "tiktok-management": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "remote", "entrepreneurial", "fast_start"]),
        "copywriting": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "remote", "entrepreneurial"]),
        "voiceover": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["creative", "remote", "fast_start"]),
        "3d-printing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "entrepreneurial"]),
        "amazon-fba": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["entrepreneurial", "remote"]),
        "ui-design": ScoringUpdate(requiresLicense: false, incomeLevel: .high, demandLevel: .high, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["creative", "remote", "high_income"]),
        "data-entry": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["remote", "fast_start"]),
        "translation": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["remote", "people_facing", "fast_start"]),
        "etsy-digital": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "remote", "entrepreneurial", "low_cost"]),
        "online-store-management": ScoringUpdate(requiresLicense: false, incomeLevel: .high, demandLevel: .medium, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["remote", "entrepreneurial", "high_income"]),
        "newsletter-writing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["remote", "creative", "entrepreneurial"]),
        "brand-strategy": ScoringUpdate(requiresLicense: false, incomeLevel: .high, demandLevel: .medium, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["creative", "remote", "high_income", "entrepreneurial"]),
        "music-production": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: false, isScalable: true, alignedInterests: ["creative", "entrepreneurial"]),
        "affiliate-marketing": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: true, alignedInterests: ["remote", "entrepreneurial", "fast_start"]),
        "dropshipping": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: true, alignedInterests: ["remote", "entrepreneurial", "fast_start"]),
        "wordpress-maintenance": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["remote", "entrepreneurial", "fast_start"]),
        "google-ads": ScoringUpdate(requiresLicense: false, incomeLevel: .high, demandLevel: .high, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["remote", "entrepreneurial", "high_income"]),
        "notion-templates": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "remote", "low_cost"]),

        // ========================
        // PRODUCT / CRAFT
        // ========================
        "custom-tshirts": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "fast_start"]),
        "candle-making": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: true, alignedInterests: ["creative", "low_cost", "entrepreneurial"]),
        "jewelry-making": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "low_cost"]),
        "woodworking": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "creative", "entrepreneurial"]),
        "soap-making": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "low_cost"]),
        "print-on-demand": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: true, alignedInterests: ["remote", "creative", "entrepreneurial", "fast_start"]),
        "resin-art": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["creative", "low_cost"]),
        "custom-signs": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "hands_on", "entrepreneurial"]),
        "leather-goods": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "hands_on", "entrepreneurial"]),
        "pottery": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: false, isScalable: false, alignedInterests: ["creative"]),
        "embroidery": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial"]),
        "screen-printing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "entrepreneurial"]),
        "sticker-business": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: true, alignedInterests: ["creative", "remote", "low_cost"]),
        "furniture-restoration": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "creative", "entrepreneurial"]),
        "macrame": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["creative", "low_cost"]),
        "custom-phone-cases": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "fast_start"]),
        "knitting-crochet": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["creative", "low_cost"]),
        "engraving": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "entrepreneurial"]),
        "sublimation-printing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "entrepreneurial"]),
        "terrariums": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["creative", "low_cost"]),

        // ========================
        // EVENTS / ENTERTAINMENT
        // ========================
        "dj-services": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "people_facing", "entrepreneurial"]),
        "event-photography": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "people_facing", "entrepreneurial"]),
        "event-planning": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial", "creative"]),
        "photo-booth": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["people_facing", "entrepreneurial"]),
        "karaoke-dj": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: false, isScalable: false, alignedInterests: ["people_facing", "creative"]),
        "magician": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: false, isScalable: false, alignedInterests: ["creative", "people_facing"]),
        "trivia-host": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "fast_start"]),
        "videography": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["creative", "people_facing", "entrepreneurial"]),
        "kids-party-entertainment": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "creative"]),
        "wedding-officiant": ScoringUpdate(requiresLicense: true, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["people_facing", "fast_start"]),
        "floral-design": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "people_facing"]),
        "party-rental": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["entrepreneurial", "people_facing", "hands_on"]),
        "drone-photography": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["creative", "entrepreneurial", "high_income"]),
        "bounce-house-rental": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["entrepreneurial", "people_facing"]),
        "mobile-game-truck": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["entrepreneurial", "people_facing"]),
        "caricature-artist": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["creative", "people_facing"]),
        "sound-system-rental": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),

        // ========================
        // SKILLED TRADES
        // ========================
        "drywall-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "pool-cleaning": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "concrete-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "small-engine-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial", "fast_start"]),
        "electrical-small": ScoringUpdate(requiresLicense: true, incomeLevel: .high, demandLevel: .high, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["high_income", "hands_on", "entrepreneurial"]),
        "pressure-washing-fleet": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "plumbing-basic": ScoringUpdate(requiresLicense: true, incomeLevel: .high, demandLevel: .high, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["high_income", "hands_on", "entrepreneurial"]),
        "tv-mounting": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "bathroom-caulking": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "power-tool-sharpening": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "low_cost"]),
        "epoxy-flooring": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "tile-installation": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "gutter-guard-install": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "door-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "mailbox-install": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "window-film": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "water-heater-flush": ScoringUpdate(requiresLicense: true, incomeLevel: .high, demandLevel: .high, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["high_income", "hands_on", "entrepreneurial"]),
        "smart-home-install": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .skilledTrade, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial", "fast_start"]),
        "cabinet-hardware": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "glass-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "chimney-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "power-washing-deck": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start"]),
        "siding-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "rain-gutter-install": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "shutter-install": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "crawlspace-encapsulation": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),

        // ========================
        // AUTO / TRANSPORT
        // ========================
        "mobile-car-wash": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "courier-delivery": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["fast_start"]),
        "boat-detailing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "motorcycle-detailing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start"]),
        "rv-detailing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "headlight-restoration": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "mobile-tire-service": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "auto-window-tinting": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "paint-protection-film": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "mobile-oil-change": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),
        "car-upholstery-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "vehicle-wrapping": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["creative", "hands_on", "entrepreneurial"]),
        "mobile-dent-repair": ScoringUpdate(requiresLicense: false, incomeLevel: .high, demandLevel: .medium, categoryTier: .highValue, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "high_income", "entrepreneurial"]),
        "fleet-washing": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start", "entrepreneurial"]),

        // ========================
        // OUTDOOR / LANDSCAPE
        // ========================
        "landscaping": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial", "fast_start"]),
        "tree-trimming": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "mulching": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "hedge-trimming": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "stump-grinding": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "leaf-removal": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "irrigation-install": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "weed-control": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "hardscaping": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "sod-installation": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "pond-maintenance": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "flower-bed-maintenance": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["creative", "hands_on", "entrepreneurial"]),
        "lawn-aeration": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: true, alignedInterests: ["hands_on", "fast_start"]),
        "outdoor-lighting": ScoringUpdate(requiresLicense: true, incomeLevel: .medium, demandLevel: .medium, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "gravel-delivery": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "fence-staining": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "erosion-control": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .low, categoryTier: .skilledTrade, isFastStart: false, isScalable: true, alignedInterests: ["hands_on", "entrepreneurial"]),
        "brush-clearing": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .medium, categoryTier: .standard, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),
        "christmas-tree-removal": ScoringUpdate(requiresLicense: false, incomeLevel: .low, demandLevel: .low, categoryTier: .sideHustle, isFastStart: true, isScalable: false, alignedInterests: ["hands_on", "fast_start"]),

        // ========================
        // PHASE 2 UPDATES
        // ========================
        "web-design": ScoringUpdate(requiresLicense: false, incomeLevel: .high, demandLevel: .high, categoryTier: .highValue, isFastStart: true, isScalable: true, alignedInterests: ["high_income", "creative", "remote", "entrepreneurial"]),
        "bookkeeping": ScoringUpdate(requiresLicense: false, incomeLevel: .medium, demandLevel: .high, categoryTier: .highValue, isFastStart: true, isScalable: true, alignedInterests: ["remote", "entrepreneurial", "low_cost"]),
    ]
}
