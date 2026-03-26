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
    var builds: [BuildProject] = []
    var selectedTab: Int = 0
    var showWelcomeBack: Bool = false
    var momentum: MomentumSystem = MomentumSystem()
    var quickActionBuildId: String?
    var celebratingBadge: MomentumBadge?
    var pendingSharePrompt: SharePromptType?

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
    var hasSeenResultsReveal: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSeenResultsReveal") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSeenResultsReveal") }
    }
    var completedFirstStep: Bool {
        get { UserDefaults.standard.bool(forKey: "completedFirstStep") }
        set { UserDefaults.standard.set(newValue, forKey: "completedFirstStep") }
    }
    var hasBeenPromptedForRating: Bool {
        get { UserDefaults.standard.bool(forKey: "hasBeenPromptedForRating") }
        set { UserDefaults.standard.set(newValue, forKey: "hasBeenPromptedForRating") }
    }
    var hasSkippedQuiz: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSkippedQuiz") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSkippedQuiz") }
    }

    init() {
        loadProfile()
        loadFavorites()
        loadExploredPaths()
        loadUnlockedAchievements()
        loadBuilds()
        if hasCompletedQuiz || hasSkippedQuiz {
            currentScreen = .results
            runMatching()
            checkWelcomeBack()
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

    func skipQuiz() {
        hasSkippedQuiz = true
        hasCompletedOnboarding = true
        runMatching()
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .results
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
                if !hasSeenResultsReveal {
                    withAnimation(.spring(duration: 0.5)) {
                        currentScreen = .resultsReveal
                    }
                } else {
                    withAnimation(.spring(duration: 0.5)) {
                        currentScreen = .results
                    }
                }
            }
        }
    }

    func completeEarlyQuiz(partialProfile: UserProfile) {
        userProfile = partialProfile
        saveProfile()
        hasCompletedQuiz = true
        runMatching()
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .resultsReveal
        }
    }

    func completeResultsReveal() {
        hasSeenResultsReveal = true
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .results
        }
    }

    func retakeQuiz() {
        userProfile = UserProfile()
        matchResults = []
        hasCompletedQuiz = false
        hasSeenResultsReveal = false
        hasSkippedQuiz = false
        saveProfile()
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .quiz
        }
    }

    func runMatching() {
        matchResults = MatchingEngine.match(profile: userProfile, paths: BusinessPathDatabase.allPaths)
    }

    private func checkWelcomeBack() {
        let lastSession = UserDefaults.standard.object(forKey: "lastSessionDate") as? Date
        let now = Date()
        if let last = lastSession {
            let calendar = Calendar.current
            if !calendar.isDate(last, inSameDayAs: now) {
                showWelcomeBack = !builds.isEmpty
            }
        }
        UserDefaults.standard.set(now, forKey: "lastSessionDate")
    }

    func dismissWelcomeBack() {
        withAnimation(.spring(duration: 0.4)) {
            showWelcomeBack = false
        }
    }

    // MARK: - Builds

    func addBuild(from path: BusinessPath) {
        guard !builds.contains(where: { $0.pathId == path.id }) else { return }
        let build = BuildProject.create(from: path)
        builds.append(build)
        saveBuilds()
    }

    func removeBuild(_ buildId: String) {
        builds.removeAll { $0.id == buildId }
        saveBuilds()
    }

    func hasBuild(for pathId: String) -> Bool {
        builds.contains { $0.pathId == pathId }
    }

    func toggleBuildStep(buildId: String, stepId: String) {
        guard let buildIndex = builds.firstIndex(where: { $0.id == buildId }),
              let stepIndex = builds[buildIndex].steps.firstIndex(where: { $0.id == stepId }) else { return }
        builds[buildIndex].steps[stepIndex].isCompleted.toggle()

        if builds[buildIndex].steps[stepIndex].isCompleted {
            builds[buildIndex].steps[stepIndex].completedDate = Date()
            momentum.awardPoints(5, reason: .checklistItem)

            if !completedFirstStep {
                completedFirstStep = true
                momentum.awardPoints(10, reason: .todayStep)
            }
        } else {
            builds[buildIndex].steps[stepIndex].completedDate = nil
        }

        saveBuilds()
        checkAchievements()
        checkMomentumBadges()
    }

    func updateStepNotes(buildId: String, stepId: String, notes: String) {
        guard let buildIndex = builds.firstIndex(where: { $0.id == buildId }),
              let stepIndex = builds[buildIndex].steps.firstIndex(where: { $0.id == stepId }) else { return }
        builds[buildIndex].steps[stepIndex].notes = notes
        saveBuilds()
    }

    func updateBuildField(buildId: String, field: BuildField, value: String) {
        guard let index = builds.firstIndex(where: { $0.id == buildId }) else { return }
        switch field {
        case .businessName: builds[index].businessName = value
        case .pricing: builds[index].pricingNotes = value
        case .strategy: builds[index].strategyNotes = value
        case .services: builds[index].serviceNotes = value
        }
        momentum.awardPoints(3, reason: .editedPlan)
        saveBuilds()
    }

    var activeBuild: BuildProject? {
        builds.first { $0.progressPercentage < 100 }
    }

    var todayStep: (build: BuildProject, step: BuildStep)? {
        for build in builds {
            if let step = build.nextStep {
                return (build, step)
            }
        }
        return nil
    }

    private func checkMomentumBadges() {
        let previousBadges = momentum.earnedBadges
        let totalCompleted = builds.flatMap(\.steps).filter(\.isCompleted).count
        let maxProgress = builds.map(\.progressPercentage).max() ?? 0
        momentum.checkBadges(
            completedSteps: totalCompleted,
            streakDays: streakTracker.currentStreak,
            buildProgress: maxProgress,
            buildsCount: builds.count
        )
        let newBadges = momentum.earnedBadges.subtracting(previousBadges)
        if let newId = newBadges.first,
           let badge = MomentumBadge.all.first(where: { $0.id == newId }) {
            celebratingBadge = badge
        }

        if maxProgress >= 25 && !UserDefaults.standard.bool(forKey: "prompted_share_25") {
            UserDefaults.standard.set(true, forKey: "prompted_share_25")
            pendingSharePrompt = .milestone25
        } else if maxProgress >= 50 && !UserDefaults.standard.bool(forKey: "prompted_share_50") {
            UserDefaults.standard.set(true, forKey: "prompted_share_50")
            pendingSharePrompt = .milestone50
        }
    }

    private func saveBuilds() {
        if let data = try? JSONEncoder().encode(builds) {
            UserDefaults.standard.set(data, forKey: "builds")
        }
    }

    private func loadBuilds() {
        if let data = UserDefaults.standard.data(forKey: "builds"),
           let saved = try? JSONDecoder().decode([BuildProject].self, from: data) {
            builds = saved
        }
    }

    // MARK: - Profile

    func saveProfile() {
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

    // MARK: - Favorites

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
        if momentum.canShare() {
            momentum.recordShare()
        }
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
        momentum.awardPoints(2, reason: .dailyUse)
        checkAchievements()
        checkMomentumBadges()
    }

    // MARK: - Readiness

    var readinessScore: Int {
        var score = 0
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
        return min(score, 100)
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

    // MARK: - Achievements

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
    case resultsReveal
    case results
}

nonisolated enum BuildField: Sendable {
    case businessName
    case pricing
    case strategy
    case services
}

nonisolated enum SharePromptType: Sendable {
    case quizComplete
    case jobSaved
    case milestone25
    case milestone50
    case streakMilestone
}
