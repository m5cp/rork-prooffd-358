import Foundation

nonisolated struct WeeklyChallenge: Identifiable, Sendable {
    let id: Int
    let title: String
    let description: String
    let icon: String
    let color: String
    let actionSteps: [String]
}

enum WeeklyChallengeDatabase {
    static let challenges: [WeeklyChallenge] = [
        WeeklyChallenge(id: 1, title: "Market Research Sprint", description: "Research 3 competitors for your top business match and note what they charge.", icon: "magnifyingglass.circle.fill", color: "60A5FA", actionSteps: ["Google your top match + 'near me'", "Note 3 competitors' pricing", "Identify one gap you could fill"]),
        WeeklyChallenge(id: 2, title: "Network Builder", description: "Tell 5 people about the business idea you're considering.", icon: "person.3.fill", color: "34D399", actionSteps: ["Pick your favorite business path", "Text or call 5 people about it", "Ask if they know anyone who needs it"]),
        WeeklyChallenge(id: 3, title: "Brand Brainstorm", description: "Come up with 3 potential business names and test them with friends.", icon: "lightbulb.fill", color: "FBBF24", actionSteps: ["Brainstorm 10 name ideas", "Narrow to your top 3", "Ask 3 friends which they prefer"]),
        WeeklyChallenge(id: 4, title: "Cost Calculator", description: "List every startup cost for your top match and total it up.", icon: "dollarsign.circle.fill", color: "FB923C", actionSteps: ["List all tools/supplies needed", "Price each item online", "Calculate your total startup cost"]),
        WeeklyChallenge(id: 5, title: "Social Media Scout", description: "Find and follow 5 successful people in your top business category.", icon: "eye.fill", color: "818CF8", actionSteps: ["Search Instagram/TikTok for your niche", "Follow 5 accounts that inspire you", "Save 3 posts with great ideas"]),
        WeeklyChallenge(id: 6, title: "Pitch Perfect", description: "Write and practice a 30-second elevator pitch for your top match.", icon: "mic.fill", color: "F472B6", actionSteps: ["Write who you help and how", "Practice saying it out loud 5 times", "Record yourself and listen back"]),
        WeeklyChallenge(id: 7, title: "Customer Avatar", description: "Describe your ideal customer in detail — who are they, where are they?", icon: "person.crop.circle.fill", color: "2DD4BF", actionSteps: ["Define age, location, income level", "List their biggest pain points", "Note where they hang out online"]),
        WeeklyChallenge(id: 8, title: "First Draft Outreach", description: "Draft your first outreach message to a potential client.", icon: "envelope.fill", color: "67E8F9", actionSteps: ["Pick one person who needs your service", "Write a friendly intro message", "Include a specific offer or free sample"]),
        WeeklyChallenge(id: 9, title: "Pricing Strategy", description: "Set 3 pricing tiers for your service: basic, standard, and premium.", icon: "tag.fill", color: "4ADE80", actionSteps: ["Research what competitors charge", "Create 3 distinct packages", "Calculate your hourly rate for each"]),
        WeeklyChallenge(id: 10, title: "Visual Identity", description: "Pick your brand colors and create a simple logo sketch.", icon: "paintpalette.fill", color: "818CF8", actionSteps: ["Choose 2-3 brand colors", "Sketch 3 simple logo ideas", "Pick your favorite and refine it"]),
    ]

    static func challengeForThisWeek() -> WeeklyChallenge {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        let index = (weekOfYear - 1) % challenges.count
        return challenges[index]
    }
}
