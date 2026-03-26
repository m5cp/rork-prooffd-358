import SwiftUI

@Observable
class AppState {
    var currentScreen: AppScreen = .onboarding
    var userProfile: UserProfile = UserProfile()
    var matchResults: [MatchResult] = []
    var favoritePathIDs: Set<String> = []
    var showFavoritesOnly: Bool = false
    var streakTracker: StreakTracker = StreakTracker()
    var unlockedAchievementIDs: Set<String> = []
    var exploredPathIDs: Set<String> = []
    var hasUsedWhatIf: Bool {
        get { UserDefaults.standard.bool(forKey: "hasUsedWhatIf") }
        set { UserDefaults.standard.set(newValue, forKey: "hasUsedWhatIf") }
    }
    var hasSharedResult: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSharedResult") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSharedResult") }
    }
    var completedChallengeWeeks: Set<Int> {
        get {
            let arr = UserDefaults.standard.array(forKey: "completedChallengeWeeks") as? [Int] ?? []
            return Set(arr)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: "completedChallengeWeeks")
        }
    }
    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding") }
    }
    var hasCompletedQuiz: Bool {
        get { UserDefaults.standard.bool(forKey: "hasCompletedQuiz") }
        set { UserDefaults.standard.set(newValue, forKey: "hasCompletedQuiz") }
    }

    init() {
        loadProfile()
        loadFavorites()
        loadExploredPaths()
        loadUnlockedAchievements()
        if hasCompletedQuiz {
            currentScreen = .results
            runMatching()
        } else if hasCompletedOnboarding {
            currentScreen = .quiz
        }
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .quiz
        }
    }

    func completeQuiz() {
        saveProfile()
        hasCompletedQuiz = true
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .analyzing
        }
        Task {
            try? await Task.sleep(for: .seconds(3))
            await MainActor.run {
                runMatching()
                withAnimation(.spring(duration: 0.5)) {
                    currentScreen = .results
                }
            }
        }
    }

    func retakeQuiz() {
        userProfile = UserProfile()
        matchResults = []
        hasCompletedQuiz = false
        saveProfile()
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .quiz
        }
    }

    func runMatching() {
        matchResults = MatchingEngine.match(profile: userProfile, paths: BusinessPathDatabase.allPaths)
    }

    private func saveProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
    }

    private func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = profile
        }
    }

    func toggleFavorite(_ pathID: String) {
        if favoritePathIDs.contains(pathID) {
            favoritePathIDs.remove(pathID)
        } else {
            favoritePathIDs.insert(pathID)
        }
        saveFavorites()
        checkAchievements()
    }

    func isFavorite(_ pathID: String) -> Bool {
        favoritePathIDs.contains(pathID)
    }

    func markPathExplored(_ pathID: String) {
        exploredPathIDs.insert(pathID)
        saveExploredPaths()
        checkAchievements()
    }

    func markWhatIfUsed() {
        hasUsedWhatIf = true
        checkAchievements()
    }

    func markResultShared() {
        hasSharedResult = true
        checkAchievements()
    }

    func markChallengeCompleted(_ weekID: Int) {
        completedChallengeWeeks.insert(weekID)
    }

    func isChallengeCompleted(_ weekID: Int) -> Bool {
        completedChallengeWeeks.contains(weekID)
    }

    func recordAppOpen() {
        streakTracker.recordAppOpen()
        checkAchievements()
    }

    var readinessScore: Int {
        var score = 0
        let maxScore = 100

        if userProfile.budget != nil {
            switch userProfile.budget! {
            case .zero: score += 5
            case .under100: score += 8
            case .under500: score += 12
            case .under1000: score += 16
            case .over1000: score += 20
            }
        }

        if let hours = userProfile.hoursPerDay {
            switch hours {
            case .lessThan1: score += 5
            case .oneToTwo: score += 10
            case .threeToFour: score += 15
            case .fivePlus: score += 20
            }
        }

        if let tech = userProfile.techComfort {
            switch tech {
            case .notComfortable: score += 3
            case .basic: score += 7
            case .moderate: score += 12
            case .verySavvy: score += 15
            }
        }

        if let exp = userProfile.experienceLevel {
            switch exp {
            case .beginner: score += 5
            case .some: score += 10
            case .skilled: score += 15
            }
        }

        if let selling = userProfile.sellingComfort {
            switch selling {
            case .notComfortable: score += 3
            case .somewhat: score += 7
            case .veryComfortable: score += 10
            }
        }

        if userProfile.hasCar == true { score += 5 }
        if !userProfile.selectedCategories.isEmpty { score += 5 }
        if !userProfile.workConditions.isEmpty { score += 5 }
        if userProfile.workPreference != nil { score += 3 }
        if userProfile.workStyle != nil { score += 2 }

        return min(score, maxScore)
    }

    var readinessLevel: String {
        switch readinessScore {
        case 0...25: return "Getting Started"
        case 26...50: return "Building Foundation"
        case 51...75: return "Ready to Launch"
        default: return "Launch Ready"
        }
    }

    var readinessTips: [String] {
        var tips: [String] = []
        if let tech = userProfile.techComfort, tech.level < 2 {
            tips.append("Improving tech skills unlocks more digital business paths")
        }
        if let hours = userProfile.hoursPerDay, hours.numericValue < 3 {
            tips.append("Dedicating more hours increases your earning potential")
        }
        if let selling = userProfile.sellingComfort, selling == .notComfortable {
            tips.append("Building sales confidence opens high-revenue opportunities")
        }
        if let budget = userProfile.budget, budget.numericValue < 500 {
            tips.append("A slightly higher budget unlocks more business types")
        }
        if userProfile.hasCar == false {
            tips.append("Access to a vehicle opens service-based business paths")
        }
        if tips.isEmpty {
            tips.append("You're well-positioned — explore your top matches!")
        }
        return tips
    }

    func checkAchievements() {
        for achievement in AchievementDatabase.all {
            guard !unlockedAchievementIDs.contains(achievement.id) else { continue }
            var unlocked = false
            switch achievement.requirement {
            case .completedQuiz:
                unlocked = hasCompletedQuiz
            case .pathsExplored(let count):
                unlocked = exploredPathIDs.count >= count
            case .favorited(let count):
                unlocked = favoritePathIDs.count >= count
            case .usedWhatIf:
                unlocked = hasUsedWhatIf
            case .sharedResult:
                unlocked = hasSharedResult
            case .streakDays(let count):
                unlocked = streakTracker.currentStreak >= count
            case .openedApp(let count):
                unlocked = streakTracker.totalDaysOpened >= count
            }
            if unlocked {
                unlockedAchievementIDs.insert(achievement.id)
            }
        }
        saveUnlockedAchievements()
    }

    func isAchievementUnlocked(_ id: String) -> Bool {
        unlockedAchievementIDs.contains(id)
    }

    var unlockedCount: Int {
        unlockedAchievementIDs.count
    }

    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoritePathIDs), forKey: "favoritePathIDs")
    }

    private func loadFavorites() {
        if let ids = UserDefaults.standard.stringArray(forKey: "favoritePathIDs") {
            favoritePathIDs = Set(ids)
        }
    }

    private func saveExploredPaths() {
        UserDefaults.standard.set(Array(exploredPathIDs), forKey: "exploredPathIDs")
    }

    private func loadExploredPaths() {
        if let ids = UserDefaults.standard.stringArray(forKey: "exploredPathIDs") {
            exploredPathIDs = Set(ids)
        }
    }

    private func saveUnlockedAchievements() {
        UserDefaults.standard.set(Array(unlockedAchievementIDs), forKey: "unlockedAchievementIDs")
    }

    private func loadUnlockedAchievements() {
        if let ids = UserDefaults.standard.stringArray(forKey: "unlockedAchievementIDs") {
            unlockedAchievementIDs = Set(ids)
        }
    }
}

nonisolated enum AppScreen: Sendable, Equatable {
    case onboarding
    case quiz
    case analyzing
    case results
}
