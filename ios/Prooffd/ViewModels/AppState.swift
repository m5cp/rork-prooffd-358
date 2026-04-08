import SwiftUI

nonisolated enum ChosenPath: String, Codable, Sendable {
    case business = "business"
    case trades = "trades"
    case degree = "degree"

    var title: String {
        switch self {
        case .business: return "Start a Business"
        case .trades: return "Trades & Certifications"
        case .degree: return "4-Year Degree Careers"
        }
    }

    var icon: String {
        switch self {
        case .business: return "briefcase.fill"
        case .trades: return "wrench.and.screwdriver.fill"
        case .degree: return "building.columns.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .business: return "Launch your own business with step-by-step plans"
        case .trades: return "Skilled trades, healthcare, tech & professional programs"
        case .degree: return "Licensed careers requiring a college degree"
        }
    }

    var color: Color {
        switch self {
        case .business: return Theme.accent
        case .trades: return Theme.accentBlue
        case .degree: return Color(hex: "818CF8")
        }
    }
}

@Observable
class AppState {
    var currentScreen: AppScreen = .results
    var userProfile: UserProfile = UserProfile()
    var matchResults: [MatchResult] = []
    var educationScores: [String: Int] = [:]
    var degreeScores: [String: Int] = [:]
    var favoritePathIDs: Set<String> = []
    var favoriteEducationIDs: Set<String> = []
    var favoriteDegreeIDs: Set<String> = []
    var hiddenPathIDs: Set<String> = []
    var hiddenEducationIDs: Set<String> = []
    var hiddenDegreeIDs: Set<String> = []
    var chosenPath: ChosenPath?
    var exploreFilter: ExploreFilterMode = .all
    var showFavoritesOnly: Bool = false
    var streakTracker: StreakTracker = StreakTracker()
    var unlockedAchievementIDs: Set<String> = []
    var exploredPathIDs: Set<String> = []
    var builds: [BuildProject] = []
    var planItems: [PlanItem] = []
    var selectedTab: Int = 0
    var showWelcomeBack: Bool = false
    var momentum: MomentumSystem = MomentumSystem()
    var quickActionBuildId: String?
    var celebratingBadge: MomentumBadge?
    var pendingSharePrompt: SharePromptType?
    var dailyRewards: DailyRewardTracker = DailyRewardTracker()
    var dailyMicroAction: DailyMicroActionTracker = DailyMicroActionTracker()

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
    var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding") }
    }
    var hasCompletedQuiz: Bool = UserDefaults.standard.bool(forKey: "hasCompletedQuiz") {
        didSet { UserDefaults.standard.set(hasCompletedQuiz, forKey: "hasCompletedQuiz") }
    }
    var hasSeenResultsReveal: Bool = UserDefaults.standard.bool(forKey: "hasSeenResultsReveal") {
        didSet { UserDefaults.standard.set(hasSeenResultsReveal, forKey: "hasSeenResultsReveal") }
    }
    var completedFirstStep: Bool = UserDefaults.standard.bool(forKey: "completedFirstStep") {
        didSet { UserDefaults.standard.set(completedFirstStep, forKey: "completedFirstStep") }
    }
    var hasBeenPromptedForRating: Bool = UserDefaults.standard.bool(forKey: "hasBeenPromptedForRating") {
        didSet { UserDefaults.standard.set(hasBeenPromptedForRating, forKey: "hasBeenPromptedForRating") }
    }
    var hasSkippedQuiz: Bool = UserDefaults.standard.bool(forKey: "hasSkippedQuiz") {
        didSet { UserDefaults.standard.set(hasSkippedQuiz, forKey: "hasSkippedQuiz") }
    }
    var savedChosenPath: String? = UserDefaults.standard.string(forKey: "chosenPath") {
        didSet { UserDefaults.standard.set(savedChosenPath, forKey: "chosenPath") }
    }

    init() {
        loadProfile()
        loadFavorites()
        loadHidden()
        loadExploredPaths()
        loadUnlockedAchievements()
        loadBuilds()
        loadPlanItems()
        assignAvatarIfNeeded()
        if let raw = savedChosenPath, let path = ChosenPath(rawValue: raw) {
            chosenPath = path
        }
        if hasCompletedOnboarding {
            currentScreen = .results
            runMatching()
            checkWelcomeBack()
        }
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        hasCompletedQuiz = true
        hasSkippedQuiz = true
        runMatching()
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .results
        }
    }

    func completeOnboardingWithQuiz(path: ChosenPath, profile: UserProfile) {
        chosenPath = path
        savedChosenPath = path.rawValue
        userProfile = profile
        saveProfile()
        hasCompletedOnboarding = true
        hasCompletedQuiz = true
        runMatching()
        AnalyticsTracker.shared.trackQuizCompletion()
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .resultsReveal
        }
    }

    func selectPath(_ path: ChosenPath) {
        chosenPath = path
        savedChosenPath = path.rawValue
        hasCompletedQuiz = true
        hasCompletedOnboarding = true
        runMatching()
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .results
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
        AnalyticsTracker.shared.trackQuizCompletion()
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
        educationScores = [:]
        degreeScores = [:]
        hasCompletedQuiz = false
        hasCompletedOnboarding = false
        hasSeenResultsReveal = false
        hasSkippedQuiz = false
        chosenPath = nil
        savedChosenPath = nil
        saveProfile()
        withAnimation(.spring(duration: 0.5)) {
            currentScreen = .onboarding
        }
    }

    func runMatching() {
        matchResults = MatchingEngine.match(profile: userProfile, paths: BusinessPathDatabase.allPaths)
        educationScores = MatchingEngine.scoreEducationPaths(profile: userProfile)
        degreeScores = MatchingEngine.scoreDegreeRecords(profile: userProfile)
    }

    func educationScore(for id: String) -> Int {
        educationScores[id] ?? 50
    }

    func degreeScore(for id: String) -> Int {
        degreeScores[id] ?? 50
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
        AnalyticsTracker.shared.trackBuildStarted()
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
            AnalyticsTracker.shared.trackStepCompleted()

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

    func updateStepTargetDate(buildId: String, stepId: String, date: Date?) {
        guard let buildIndex = builds.firstIndex(where: { $0.id == buildId }),
              let stepIndex = builds[buildIndex].steps.firstIndex(where: { $0.id == stepId }) else { return }
        builds[buildIndex].steps[stepIndex].targetDate = date
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

    // MARK: - Plan Items

    func addPlanItem(_ item: PlanItem) {
        guard !planItems.contains(where: { $0.itemId == item.itemId && $0.type == item.type }) else { return }
        planItems.append(item)
        savePlanItems()
    }

    func removePlanItem(_ itemId: String) {
        planItems.removeAll { $0.id == itemId }
        savePlanItems()
    }

    func hasPlanItem(itemId: String, type: PlanItemType) -> Bool {
        planItems.contains { $0.itemId == itemId && $0.type == type }
    }

    private func savePlanItems() {
        if let data = try? JSONEncoder().encode(planItems) {
            UserDefaults.standard.set(data, forKey: "planItems")
        }
    }

    private func loadPlanItems() {
        if let data = UserDefaults.standard.data(forKey: "planItems"),
           let saved = try? JSONDecoder().decode([PlanItem].self, from: data) {
            planItems = saved
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

    // MARK: - Avatar

    private func assignAvatarIfNeeded() {
        if userProfile.avatarId.isEmpty {
            userProfile.avatarId = AvatarOption.random().rawValue
            saveProfile()
        }
    }

    func updateAvatar(_ avatar: AvatarOption) {
        userProfile.avatarId = avatar.rawValue
        saveProfile()
    }

    func updateName(_ name: String) {
        userProfile.firstName = name
        saveProfile()
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

    func toggleEducationFavorite(_ pathID: String) {
        if favoriteEducationIDs.contains(pathID) {
            favoriteEducationIDs.remove(pathID)
        } else {
            favoriteEducationIDs.insert(pathID)
        }
        saveFavorites()
    }

    func isEducationFavorite(_ pathID: String) -> Bool {
        favoriteEducationIDs.contains(pathID)
    }

    func toggleDegreeFavorite(_ pathID: String) {
        if favoriteDegreeIDs.contains(pathID) {
            favoriteDegreeIDs.remove(pathID)
        } else {
            favoriteDegreeIDs.insert(pathID)
        }
        saveFavorites()
    }

    func isDegreeFavorite(_ pathID: String) -> Bool {
        favoriteDegreeIDs.contains(pathID)
    }

    // MARK: - Hidden

    func toggleHiddenPath(_ pathID: String) {
        if hiddenPathIDs.contains(pathID) {
            hiddenPathIDs.remove(pathID)
        } else {
            hiddenPathIDs.insert(pathID)
        }
        saveHidden()
    }

    func isPathHidden(_ pathID: String) -> Bool {
        hiddenPathIDs.contains(pathID)
    }

    func toggleHiddenEducation(_ pathID: String) {
        if hiddenEducationIDs.contains(pathID) {
            hiddenEducationIDs.remove(pathID)
        } else {
            hiddenEducationIDs.insert(pathID)
        }
        saveHidden()
    }

    func isEducationHidden(_ pathID: String) -> Bool {
        hiddenEducationIDs.contains(pathID)
    }

    func toggleHiddenDegree(_ pathID: String) {
        if hiddenDegreeIDs.contains(pathID) {
            hiddenDegreeIDs.remove(pathID)
        } else {
            hiddenDegreeIDs.insert(pathID)
        }
        saveHidden()
    }

    func isDegreeHidden(_ pathID: String) -> Bool {
        hiddenDegreeIDs.contains(pathID)
    }

    func markPathExplored(_ pathID: String) {
        exploredPathIDs.insert(pathID)
        saveExploredPaths()
        AnalyticsTracker.shared.trackPathExplored()
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
        AnalyticsTracker.shared.trackShare()
        checkAchievements()
    }

    func markChallengeCompleted(_ weekID: Int) {
        completedChallengeWeeks.insert(weekID)
    }

    func isChallengeCompleted(_ weekID: Int) -> Bool {
        completedChallengeWeeks.contains(weekID)
    }

    var currentLevel: UserLevel {
        UserLevel.forPoints(momentum.totalPoints)
    }

    func recordAppOpen() {
        streakTracker.recordAppOpen()
        dailyMicroAction.resetIfNewDay()
        AnalyticsTracker.shared.trackAppOpen()
        checkAchievements()
        checkMomentumBadges()
        NotificationService.shared.recordActivity()
        NotificationService.shared.scheduleStreakReminder(currentStreak: streakTracker.currentStreak)
        syncWidgetData()
    }

    func completeDailyMicroAction() {
        guard !dailyMicroAction.completedToday else { return }
        let action = dailyMicroAction.todayAction
        dailyMicroAction.completeAction()
        momentum.awardPoints(action.points, reason: .dailyUse)
        syncWidgetData()
    }

    func claimDailyReward() {
        let reward = dailyRewards.claimReward()
        momentum.awardPoints(reward.points, reason: .dailyUse)
        syncWidgetData()
    }

    func syncWidgetData() {
        let tip = DailyTipDatabase.tipForToday()
        let action = dailyMicroAction.todayAction
        SharedDataService.updateWidgetData(
            streakCount: streakTracker.currentStreak,
            longestStreak: streakTracker.longestStreak,
            buildsCount: builds.count,
            tipTitle: tip.title,
            tipBody: tip.body,
            tipCategory: tip.category.rawValue,
            microActionTitle: action.title,
            microActionCompleted: dailyMicroAction.completedToday,
            totalPoints: momentum.totalPoints,
            levelName: currentLevel.title
        )
    }

    // MARK: - Readiness

    var profileReadinessScore: Int {
        var score = 0
        if !userProfile.selectedCategories.isEmpty { score += 12 }
        if !userProfile.workEnvironments.isEmpty { score += 12 }
        if !userProfile.workConditions.isEmpty { score += 12 }
        if userProfile.budget != nil { score += 7 }
        if userProfile.hoursPerDay != nil { score += 7 }
        return min(score, 50)
    }

    var actionReadinessScore: Int {
        var score = 0
        if hasCompletedQuiz { score += 5 }
        if exploredPathIDs.count >= 5 { score += 5 }
        if exploredPathIDs.count >= 10 { score += 5 }
        if favoritePathIDs.count >= 3 { score += 3 }
        if !builds.isEmpty { score += 5 }
        let totalCompleted = builds.flatMap(\.steps).filter(\.isCompleted).count
        if totalCompleted >= 5 { score += 5 }
        if totalCompleted >= 10 { score += 5 }
        if hasUsedWhatIf { score += 3 }
        if hasSharedResult { score += 3 }
        if streakTracker.currentStreak >= 3 { score += 3 }
        if streakTracker.currentStreak >= 7 { score += 3 }
        let hasEditedPlan = builds.contains { !$0.businessName.isEmpty || !$0.pricingNotes.isEmpty || !$0.strategyNotes.isEmpty || !$0.serviceNotes.isEmpty }
        if hasEditedPlan { score += 2 }
        if !completedChallengeWeeks.isEmpty { score += 3 }
        return min(score, 50)
    }

    var readinessScore: Int {
        min(profileReadinessScore + actionReadinessScore, 100)
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
        if !hasCompletedQuiz {
            tips.append("Complete the profile quiz to boost your score")
        }
        if exploredPathIDs.count < 5 {
            tips.append("Explore more paths to increase readiness (+5 at 5 paths)")
        }
        if builds.isEmpty {
            tips.append("Start a build to add to your readiness score")
        }

        if streakTracker.currentStreak < 3 {
            tips.append("Build a 3-day streak for +3 readiness points")
        }
        if favoritePathIDs.count < 3 {
            tips.append("Save 3 favorites to earn readiness points")
        }
        if !hasUsedWhatIf {
            tips.append("Try What If mode to explore different scenarios")
        }
        if tips.isEmpty {
            tips.append("You're well-positioned \u{2014} explore your top matches!")
        }
        return Array(tips.prefix(4))
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
        UserDefaults.standard.set(Array(favoriteEducationIDs), forKey: "favoriteEducationIDs")
        UserDefaults.standard.set(Array(favoriteDegreeIDs), forKey: "favoriteDegreeIDs")
    }

    private func loadFavorites() {
        if let ids = UserDefaults.standard.stringArray(forKey: "favoritePathIDs") {
            favoritePathIDs = Set(ids)
        }
        if let ids = UserDefaults.standard.stringArray(forKey: "favoriteEducationIDs") {
            favoriteEducationIDs = Set(ids)
        }
        if let ids = UserDefaults.standard.stringArray(forKey: "favoriteDegreeIDs") {
            favoriteDegreeIDs = Set(ids)
        }
    }

    private func saveHidden() {
        UserDefaults.standard.set(Array(hiddenPathIDs), forKey: "hiddenPathIDs")
        UserDefaults.standard.set(Array(hiddenEducationIDs), forKey: "hiddenEducationIDs")
        UserDefaults.standard.set(Array(hiddenDegreeIDs), forKey: "hiddenDegreeIDs")
    }

    private func loadHidden() {
        if let ids = UserDefaults.standard.stringArray(forKey: "hiddenPathIDs") {
            hiddenPathIDs = Set(ids)
        }
        if let ids = UserDefaults.standard.stringArray(forKey: "hiddenEducationIDs") {
            hiddenEducationIDs = Set(ids)
        }
        if let ids = UserDefaults.standard.stringArray(forKey: "hiddenDegreeIDs") {
            hiddenDegreeIDs = Set(ids)
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

nonisolated enum ExploreFilterMode: String, CaseIterable, Identifiable, Sendable {
    case all = "All"
    case favorites = "Favorites"
    case hidden = "Hidden"

    var id: String { rawValue }
}
