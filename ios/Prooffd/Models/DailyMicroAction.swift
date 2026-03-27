import Foundation

nonisolated struct DailyMicroAction: Identifiable, Sendable {
    let id: Int
    let title: String
    let description: String
    let icon: String
    let points: Int

    static let actions: [DailyMicroAction] = [
        DailyMicroAction(id: 1, title: "Explore a New Path", description: "Tap into any business path you haven't seen yet", icon: "magnifyingglass", points: 5),
        DailyMicroAction(id: 2, title: "Save a Favorite", description: "Heart a business that catches your eye", icon: "heart.fill", points: 5),
        DailyMicroAction(id: 3, title: "Read Today's Tip", description: "Check out the daily business tip", icon: "lightbulb.fill", points: 3),
        DailyMicroAction(id: 4, title: "Review Your Build", description: "Open your active build and check progress", icon: "hammer.fill", points: 5),
        DailyMicroAction(id: 5, title: "Share Your Match", description: "Share your top match with someone", icon: "square.and.arrow.up", points: 8),
        DailyMicroAction(id: 6, title: "Try What If Mode", description: "Tweak one answer and see how matches change", icon: "slider.horizontal.3", points: 5),
        DailyMicroAction(id: 7, title: "Explore a Category", description: "Browse a category you haven't checked out", icon: "square.grid.2x2.fill", points: 5),
        DailyMicroAction(id: 8, title: "Complete a Step", description: "Check off any step in your build", icon: "checkmark.circle.fill", points: 8),
        DailyMicroAction(id: 9, title: "Discover a Random Path", description: "Use Surprise Me on the Discover tab", icon: "dice.fill", points: 5),
        DailyMicroAction(id: 10, title: "Review Your Readiness", description: "Check your readiness score on your profile", icon: "gauge.open.with.lines.needle.33percent.and.arrowtriangle", points: 3),
    ]

    static func forToday() -> DailyMicroAction {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % actions.count
        return actions[index]
    }
}

@Observable
class DailyMicroActionTracker {
    private(set) var completedToday: Bool = false
    private(set) var lastCompletedDate: Date?

    private let defaults = UserDefaults.standard
    private let completedKey = "microAction_completedToday"
    private let lastDateKey = "microAction_lastDate"

    init() {
        if let date = defaults.object(forKey: lastDateKey) as? Date {
            lastCompletedDate = date
            let calendar = Calendar.current
            completedToday = calendar.isDateInToday(date)
        }
    }

    var todayAction: DailyMicroAction {
        DailyMicroAction.forToday()
    }

    func completeAction() {
        guard !completedToday else { return }
        completedToday = true
        lastCompletedDate = Date()
        defaults.set(true, forKey: completedKey)
        defaults.set(Date(), forKey: lastDateKey)
    }

    func resetIfNewDay() {
        guard let last = lastCompletedDate else { return }
        if !Calendar.current.isDateInToday(last) {
            completedToday = false
        }
    }
}
