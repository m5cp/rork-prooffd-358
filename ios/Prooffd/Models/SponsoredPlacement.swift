import Foundation

nonisolated struct SponsoredProgram: Identifiable, Sendable {
    let id: String
    let name: String
    let sponsor: String
    let icon: String
    let tagline: String
    let description: String
    let category: SponsorCategory
    let ctaLabel: String
    let ctaURL: String
    let badgeText: String
    let accentColorHex: String

    var url: URL? { URL(string: ctaURL) }
}

nonisolated enum SponsorCategory: String, Sendable, CaseIterable {
    case tradeSchool = "Trade School"
    case certification = "Certification"
    case bootcamp = "Bootcamp"
    case apprenticeship = "Apprenticeship"
    case employer = "Employer"
    case tool = "Tool"
}

enum SponsoredPlacementDatabase {
    static var featuredPrograms: [SponsoredProgram] {
        [
            SponsoredProgram(
                id: "placeholder_trade_1",
                name: "Skilled Trades Training Program",
                sponsor: "Featured Partner",
                icon: "wrench.and.screwdriver.fill",
                tagline: "Start earning in 6 months",
                description: "Hands-on training in HVAC, electrical, and plumbing with job placement assistance. Financial aid available.",
                category: .tradeSchool,
                ctaLabel: "Learn More",
                ctaURL: "",
                badgeText: "Featured",
                accentColorHex: "34D399"
            ),
            SponsoredProgram(
                id: "placeholder_cert_1",
                name: "Professional Certification Fast Track",
                sponsor: "Featured Partner",
                icon: "checkmark.seal.fill",
                tagline: "Get certified in weeks, not years",
                description: "Industry-recognized certifications in IT, healthcare, and business. 100% online with flexible scheduling.",
                category: .certification,
                ctaLabel: "Learn More",
                ctaURL: "",
                badgeText: "Featured",
                accentColorHex: "60A5FA"
            ),
            SponsoredProgram(
                id: "placeholder_boot_1",
                name: "Tech Career Bootcamp",
                sponsor: "Featured Partner",
                icon: "laptopcomputer",
                tagline: "No degree? No problem.",
                description: "12-week intensive coding and tech bootcamp. Learn web development, data analytics, or cybersecurity. Pay after you're hired.",
                category: .bootcamp,
                ctaLabel: "Learn More",
                ctaURL: "",
                badgeText: "Featured",
                accentColorHex: "818CF8"
            )
        ]
    }

    static func trackImpression(programId: String) {
        let key = "sponsor_impressions_\(programId)"
        let count = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.set(count + 1, forKey: key)

        let totalKey = "sponsor_total_impressions"
        let total = UserDefaults.standard.integer(forKey: totalKey)
        UserDefaults.standard.set(total + 1, forKey: totalKey)
    }

    static func trackTap(programId: String) {
        let key = "sponsor_taps_\(programId)"
        let count = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.set(count + 1, forKey: key)

        let totalKey = "sponsor_total_taps"
        let total = UserDefaults.standard.integer(forKey: totalKey)
        UserDefaults.standard.set(total + 1, forKey: totalKey)
    }

    static func impressions(for programId: String) -> Int {
        UserDefaults.standard.integer(forKey: "sponsor_impressions_\(programId)")
    }

    static func taps(for programId: String) -> Int {
        UserDefaults.standard.integer(forKey: "sponsor_taps_\(programId)")
    }

    static var totalImpressions: Int {
        UserDefaults.standard.integer(forKey: "sponsor_total_impressions")
    }

    static var totalTaps: Int {
        UserDefaults.standard.integer(forKey: "sponsor_total_taps")
    }
}
