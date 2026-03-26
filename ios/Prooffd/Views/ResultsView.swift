import SwiftUI

struct ResultsView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store

    var body: some View {
        @Bindable var state = appState
        ZStack {
            TabView(selection: $state.selectedTab) {
                DiscoverTabView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Discover")
                    }
                    .tag(0)

                MyBuildsView()
                    .tabItem {
                        Image(systemName: "hammer.fill")
                        Text("My Builds")
                    }
                    .tag(1)

                ExploreTabView()
                    .tabItem {
                        Image(systemName: "compass.drawing")
                        Text("Explore")
                    }
                    .tag(2)

                ProfileTabView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(3)
            }
            .tint(Theme.accent)

            if appState.showWelcomeBack {
                WelcomeBackView()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.spring(duration: 0.5), value: appState.showWelcomeBack)
        .onAppear {
            appState.recordAppOpen()
        }
    }
}

struct DiscoverTabView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var showPaywall: Bool = false
    @State private var showWhatIf: Bool = false
    @State private var selectedResult: MatchResult?
    @State private var shareResult: MatchResult?
    @State private var seeAllMode: SeeAllMode?
    @State private var showSearch: Bool = false
    @State private var searchText: String = ""
    @State private var randomPicks: [MatchResult] = []
    @State private var showRandomPicks: Bool = false
    @State private var showAchievements: Bool = false
    @State private var showProgressShare: Bool = false
    @State private var showJobShare: MatchResult?
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var allResults: [MatchResult] {
        appState.matchResults
    }

    private var recommendedResults: [MatchResult] {
        Array(allResults.sorted { $0.scorePercentage > $1.scorePercentage }.prefix(8))
    }

    private var fastStartResults: [MatchResult] {
        Array(allResults.filter {
            $0.businessPath.minBudget < 200 && $0.businessPath.fastCashPotential
        }.prefix(8))
    }



    private var trendingResults: [MatchResult] {
        Array(allResults.sorted { $0.scorePercentage > $1.scorePercentage }
            .dropFirst(3).prefix(6))
    }

    private var searchResults: [MatchResult] {
        guard !searchText.isEmpty else { return [] }
        let q = searchText.lowercased()
        return allResults.filter {
            $0.businessPath.name.localizedStandardContains(q) ||
            $0.businessPath.overview.localizedStandardContains(q) ||
            $0.businessPath.category.rawValue.localizedStandardContains(q)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if showSearch {
                    searchContent
                } else {
                    mainContent
                }
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                showSearch.toggle()
                                if !showSearch { searchText = "" }
                            }
                        } label: {
                            Image(systemName: showSearch ? "xmark.circle.fill" : "magnifyingglass")
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $shareResult) { result in
                ShareCardView(result: result, userName: appState.userProfile.firstName, totalMatches: appState.matchResults.count)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showWhatIf) {
                WhatIfView(profile: appState.userProfile)
            }
            .sheet(isPresented: $showRandomPicks) {
                RandomPicksView(picks: randomPicks) { result in
                    showRandomPicks = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedResult = result
                        appState.markPathExplored(result.businessPath.id)
                    }
                } onReroll: {
                    let all = appState.matchResults
                    guard all.count >= 2 else { return }
                    randomPicks = Array(all.shuffled().prefix(2))
                }
            }
            .sheet(isPresented: $showAchievements) {
                AchievementsView()
            }
            .sheet(isPresented: $showProgressShare) {
                if let build = appState.activeBuild {
                    ShareableCardSheet(
                        cardContent: AnyView(
                            ProgressShareCard(
                                buildName: build.businessName,
                                progressPercent: build.progressPercentage,
                                streakDays: appState.streakTracker.currentStreak,
                                nextStep: build.nextStep?.title ?? "",
                                totalPoints: appState.momentum.totalPoints
                            )
                        ),
                        shareText: "I'm building \(build.businessName) step-by-step with Prooffd — \(build.progressPercentage)% complete!"
                    )
                }
            }
            .sheet(item: $showJobShare) { result in
                ShareableCardSheet(
                    cardContent: AnyView(
                        JobSelectionShareCard(
                            jobTitle: result.businessPath.name,
                            matchPercent: result.scorePercentage,
                            aiSafeScore: result.businessPath.aiProofRating,
                            startupCost: result.businessPath.startupCostRange,
                            timeToFirst: result.businessPath.timeToFirstDollar,
                            icon: result.businessPath.icon
                        )
                    ),
                    shareText: "I found my business match on Prooffd — \(result.businessPath.name) with a \(result.scorePercentage)% match!"
                )
            }
            .sheet(item: $seeAllMode) { mode in
                SeeAllView(mode: mode, results: resultsForMode(mode))
            }
        }
    }

    private func resultsForMode(_ mode: SeeAllMode) -> [MatchResult] {
        switch mode {
        case .recommended: return allResults.sorted { $0.scorePercentage > $1.scorePercentage }
        case .fastStart: return allResults.filter { $0.businessPath.minBudget < 200 && $0.businessPath.fastCashPotential }
        case .aiSafe: return allResults.filter { $0.businessPath.aiProofRating >= 80 }.sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }
        case .trending: return allResults.sorted { $0.scorePercentage > $1.scorePercentage }
        case .category(let cat): return allResults.filter { $0.businessPath.category == cat }
        case .search: return searchResults
        }
    }

    @ViewBuilder
    private var searchContent: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Theme.textTertiary)
                TextField("Search businesses, categories...", text: $searchText)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textPrimary)
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
            }
            .padding(12)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.top, 8)

            if searchText.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 36))
                        .foregroundStyle(Theme.textTertiary)
                    Text("Search \(ContentLibrary.jobCount) business paths")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else if searchResults.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 36))
                        .foregroundStyle(Theme.textTertiary)
                    Text("No results for \"\(searchText)\"")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textSecondary)
                    Text("Try a different search term")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(searchResults) { result in
                        SeeAllResultCard(result: result) {
                            selectedResult = result
                            appState.markPathExplored(result.businessPath.id)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            Color.clear.frame(height: 40)
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        VStack(spacing: 24) {
            EngagementBannerView()
                .padding(.horizontal, 16)

            headerBadges
                .padding(.horizontal, 16)

            if !appState.hasCompletedQuiz {
                quizPromptCard
                    .padding(.horizontal, 16)
            }

            StartHereSection(
                onStartFast: { seeAllMode = .fastStart },
                onStableCareer: { appState.selectedTab = 2 },
                onRandomPick: { picks in
                    randomPicks = picks
                    showRandomPicks = true
                }
            )

            if let topResult = recommendedResults.first {
                topMatchCard(topResult)
                    .padding(.horizontal, 16)
            }

            whatIfButton
                .padding(.horizontal, 16)

            horizontalSection(
                title: "Recommended For You",
                icon: "star.fill",
                iconColor: Theme.accent,
                results: recommendedResults,
                mode: .recommended
            )

            if !fastStartResults.isEmpty {
                horizontalSection(
                    title: "Fast Start Options",
                    icon: "bolt.fill",
                    iconColor: Color(hex: "FB923C"),
                    results: fastStartResults,
                    mode: .fastStart
                )
            }

            browseByCategorySection

            if !store.isPremium {
                upgradePrompt
                    .padding(.horizontal, 16)
            }

            Color.clear.frame(height: 40)
        }
        .padding(.top, 8)
    }

    private var headerBadges: some View {
        HStack(spacing: 8) {
            if appState.streakTracker.currentStreak > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                    Text("\(appState.streakTracker.currentStreak) day streak")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.orange.opacity(0.12))
                .clipShape(.capsule)
            }

            Text("\(allResults.count) paths matched")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)

            Spacer()

            Button {
                showAchievements = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .font(.caption2)
                    Text("\(appState.momentum.earnedBadges.count)")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(Color(hex: "818CF8"))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(hex: "818CF8").opacity(0.12))
                .clipShape(.capsule)
            }

            if !appState.builds.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "hammer.fill")
                        .font(.caption2)
                    Text("\(appState.builds.count)")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(Theme.accentBlue)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Theme.accentBlue.opacity(0.12))
                .clipShape(.capsule)
            }
        }
    }

    private func topMatchCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return Button {
            selectedResult = result
            appState.markPathExplored(result.businessPath.id)
        } label: {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 56, height: 56)
                        Image(systemName: result.businessPath.icon)
                            .font(.title2)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Top Match")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.accent)
                        Text(result.businessPath.name)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                    }

                    Spacer()

                    scoreRing(result.scorePercentage, size: 52)
                }

                HStack(spacing: 16) {
                    infoChip(icon: "dollarsign.circle.fill", text: result.businessPath.startupCostRange)
                    infoChip(icon: "clock.fill", text: result.businessPath.timeToFirstDollar)
                    Spacer()
                    Button {
                        appState.toggleFavorite(result.businessPath.id)
                    } label: {
                        Image(systemName: appState.isFavorite(result.businessPath.id) ? "heart.fill" : "heart")
                            .font(.body)
                            .foregroundStyle(appState.isFavorite(result.businessPath.id) ? .pink : Theme.textTertiary)
                    }
                }
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.08), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: appState.isFavorite(result.businessPath.id))
    }

    private func horizontalSection(title: String, icon: String, iconColor: Color, results: [MatchResult], mode: SeeAllMode) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Button {
                    seeAllMode = mode
                } label: {
                    Text("See All")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(results) { result in
                        compactCard(result)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)
        }
    }

    private func compactCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return Button {
            selectedResult = result
            appState.markPathExplored(result.businessPath.id)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: result.businessPath.icon)
                            .font(.body)
                            .foregroundStyle(catColor)
                    }
                    Spacer()
                    Text("\(result.scorePercentage)%")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(scoreColor(result.scorePercentage))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(scoreColor(result.scorePercentage).opacity(0.12))
                        .clipShape(.capsule)
                }

                Text(result.businessPath.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 9))
                        Text(result.businessPath.startupCostRange)
                            .font(.caption2)
                    }
                    .foregroundStyle(Theme.textTertiary)

                    HStack(spacing: 4) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 9))
                        Text("AI Safe: \(result.businessPath.aiProofRating)")
                            .font(.caption2)
                    }
                    .foregroundStyle(aiScoreColor(result.businessPath.aiProofRating))
                }
            }
            .frame(width: 160, height: 170, alignment: .leading)
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(catColor.opacity(0.1), lineWidth: 0.5)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    private var browseByCategorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "square.grid.2x2.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
                Text("Browse by Category")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .padding(.horizontal, 16)

            let columns = sizeClass == .regular
                ? [GridItem(.adaptive(minimum: 160), spacing: 10)]
                : [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(BusinessCategory.allCases) { category in
                    categoryCard(category)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func categoryCard(_ category: BusinessCategory) -> some View {
        let catColor = Theme.categoryColor(for: category)
        let matchCount = allResults.filter { $0.businessPath.category == category }.count
        let totalCount = ContentLibrary.jobs(forCategory: category).count
        let count = matchCount > 0 ? matchCount : totalCount
        return Button {
            seeAllMode = .category(category)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(catColor.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: category.icon)
                        .font(.body)
                        .foregroundStyle(catColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(category.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)
                    Text("\(count) paths")
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }

                Spacer(minLength: 4)

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(12)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(catColor.opacity(0.08), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
    }

    private var whatIfButton: some View {
        Button {
            showWhatIf = true
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Theme.accentBlue.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: "slider.horizontal.3")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.accentBlue)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("What If Mode")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Tweak answers & see matches change instantly")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accentBlue.opacity(0.15), lineWidth: 0.5)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    private var quizPromptCard: some View {
        Button {
            appState.retakeQuiz()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundStyle(Theme.accent)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Take the Quiz")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Answer a few questions for personalized matches")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 4)

                Text("Start")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Theme.accent)
                    .clipShape(.capsule)
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Theme.accent.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    private var upgradePrompt: some View {
        Button {
            showPaywall = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "crown.fill")
                    .font(.title3)
                    .foregroundStyle(.yellow)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Unlock All Matches & Pro Tools")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Templates, scripts, business plans & more")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer()
                Text("PRO")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Theme.accent)
                    .clipShape(.capsule)
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accent.opacity(0.15), lineWidth: 0.5)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    private func scoreRing(_ percentage: Int, size: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(Theme.cardBackgroundLight, lineWidth: 4)
            Circle()
                .trim(from: 0, to: Double(percentage) / 100.0)
                .stroke(scoreColor(percentage), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(percentage)%")
                .font(.system(size: size * 0.24, weight: .bold))
                .foregroundStyle(scoreColor(percentage))
        }
        .frame(width: size, height: size)
    }

    private func scoreColor(_ percentage: Int) -> Color {
        if percentage >= 80 { return Theme.accent }
        if percentage >= 60 { return Theme.accentBlue }
        return .orange
    }

    private func aiScoreColor(_ score: Int) -> Color {
        if score >= 80 { return Theme.accent }
        if score >= 50 { return Color(hex: "FBBF24") }
        return .orange
    }

    private func infoChip(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
            Text(text)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
        }
    }
}

struct ResultCard: View {
    @Environment(AppState.self) private var appState
    let result: MatchResult
    let rank: Int
    let onTap: () -> Void
    let onShare: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    Text("\(rank)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.textTertiary)
                        .frame(width: 20)

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(categoryColor.opacity(0.12))
                            .frame(width: 44, height: 44)
                        Image(systemName: result.businessPath.icon)
                            .font(.body)
                            .foregroundStyle(categoryColor)
                    }

                    Text(result.businessPath.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)

                    Spacer(minLength: 4)

                    HStack(spacing: 6) {
                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                appState.toggleFavorite(result.businessPath.id)
                            }
                        } label: {
                            Image(systemName: appState.isFavorite(result.businessPath.id) ? "heart.fill" : "heart")
                                .font(.subheadline)
                                .foregroundStyle(appState.isFavorite(result.businessPath.id) ? .pink : Theme.textTertiary)
                                .frame(width: 32, height: 44)
                        }

                        Button {
                            onShare()
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                                .frame(width: 32, height: 44)
                        }
                    }
                }

                HStack(spacing: 6) {
                    matchBadge
                    aiSafeBadge

                    infoTag(icon: "dollarsign.circle.fill", text: result.businessPath.startupCostRange)
                    infoTag(icon: "clock.fill", text: result.businessPath.timeToFirstDollar)

                    Spacer()
                }
                .padding(.leading, 32)
            }
            .padding(.leading, 12)
            .padding(.trailing, 10)
            .padding(.vertical, 10)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .cardShadow()
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: appState.isFavorite(result.businessPath.id))
    }

    private var matchBadge: some View {
        Text("\(result.scorePercentage)%")
            .font(.caption.weight(.bold))
            .foregroundStyle(badgeColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(badgeColor.opacity(0.12))
            .clipShape(.capsule)
    }

    private func infoTag(icon: String, text: String) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 9))
                .foregroundStyle(Theme.textTertiary)
            Text(text)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Theme.cardBackgroundLight.opacity(0.6))
        .clipShape(.capsule)
    }

    private var aiSafeBadge: some View {
        let rating = result.businessPath.aiProofRating
        let color: Color = rating >= 80 ? Theme.accent : rating >= 50 ? Color(hex: "FBBF24") : .orange
        return HStack(spacing: 2) {
            Image(systemName: "shield.checkered")
                .font(.system(size: 8))
            Text("\(rating)")
                .font(.caption2.weight(.bold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 7)
        .padding(.vertical, 4)
        .background(color.opacity(0.12))
        .clipShape(.capsule)
    }

    private var badgeColor: Color {
        if result.scorePercentage >= 80 { return Theme.accent }
        if result.scorePercentage >= 60 { return Theme.accentBlue }
        return Color(hex: "FB923C")
    }

    private var categoryColor: Color {
        Theme.categoryColor(for: result.businessPath.category)
    }
}
