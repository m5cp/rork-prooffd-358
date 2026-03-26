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
    @State private var appeared: Bool = false

    private var matchesAbove40: [MatchResult] {
        appState.matchResults.filter { $0.scorePercentage >= 40 }
    }

    private var visibleResults: [MatchResult] {
        let pool: [MatchResult] = store.isPremium ? matchesAbove40 : Array(appState.matchResults.prefix(20))
        if appState.showFavoritesOnly {
            return pool.filter { appState.isFavorite($0.businessPath.id) }
        }
        return pool
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection

                    whatIfButton
                        .padding(.horizontal, 16)

                    if !store.isPremium && matchesAbove40.count > 20 {
                        upgradePrompt
                    }

                    filterBar
                        .padding(.horizontal, 16)

                    LazyVStack(spacing: 12) {
                        ForEach(Array(visibleResults.enumerated()), id: \.element.id) { index, result in
                            ResultCard(result: result, rank: index + 1, onTap: {
                                selectedResult = result
                                appState.markPathExplored(result.businessPath.id)
                            }, onShare: {
                                shareResult = result
                                appState.markResultShared()
                            })
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 20)
                            .animation(.spring(duration: 0.5, bounce: 0.2).delay(Double(min(index, 10)) * 0.05), value: appeared)
                        }
                    }
                    .padding(.horizontal, 16)

                    if visibleResults.isEmpty && appState.showFavoritesOnly {
                        emptyFavoritesView
                            .padding(.horizontal, 16)
                    }

                    if !store.isPremium && matchesAbove40.count > 20 && !appState.showFavoritesOnly {
                        lockedResultsBanner
                    }

                    whatIfHint
                        .padding(.horizontal, 16)

                    Color.clear.frame(height: 40)
                }
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        shareAllResults()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(Theme.textSecondary)
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
        }
        .onAppear {
            withAnimation {
                appeared = true
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
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

                Text("\(appState.matchResults.count) paths matched")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)

                Spacer()
            }
            .padding(.horizontal, 16)

            if let topResult = visibleResults.first, !appState.showFavoritesOnly {
                topMatchCard(topResult)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
            }
        }
    }

    private func topMatchCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return Button {
            selectedResult = result
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
                    HStack(spacing: 12) {
                        Button {
                            appState.toggleFavorite(result.businessPath.id)
                        } label: {
                            Image(systemName: appState.isFavorite(result.businessPath.id) ? "heart.fill" : "heart")
                                .font(.body)
                                .foregroundStyle(appState.isFavorite(result.businessPath.id) ? .pink : Theme.textTertiary)
                        }
                        Button {
                            shareResult = result
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.body)
                                .foregroundStyle(Theme.textTertiary)
                        }
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
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var filterBar: some View {
        let favoriteCount = visibleResultsForFavoriteCount
        HStack(spacing: 10) {
            filterChip(title: "All", isActive: !appState.showFavoritesOnly) {
                withAnimation(.spring(duration: 0.3)) {
                    appState.showFavoritesOnly = false
                }
            }
            filterChip(title: "Favorites", icon: "heart.fill", count: favoriteCount, isActive: appState.showFavoritesOnly) {
                withAnimation(.spring(duration: 0.3)) {
                    appState.showFavoritesOnly = true
                }
            }
            Spacer()
        }
    }

    private var visibleResultsForFavoriteCount: Int {
        let pool: [MatchResult] = store.isPremium ? matchesAbove40 : Array(appState.matchResults.prefix(20))
        return pool.filter { appState.isFavorite($0.businessPath.id) }.count
    }

    private func filterChip(title: String, icon: String? = nil, count: Int? = nil, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let icon {
                    Image(systemName: icon)
                        .font(.caption2)
                        .foregroundStyle(isActive ? .pink : Theme.textTertiary)
                }
                Text(title)
                    .font(.subheadline.weight(.medium))
                if let count, count > 0 {
                    Text("\(count)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(isActive ? Theme.background : Theme.textTertiary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isActive ? Theme.accent : Theme.cardBackgroundLight)
                        .clipShape(.capsule)
                }
            }
            .foregroundStyle(isActive ? Theme.textPrimary : Theme.textTertiary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isActive ? Theme.cardBackgroundLight : Theme.cardBackground)
            .clipShape(.capsule)
            .overlay(
                Capsule()
                    .stroke(isActive ? Theme.accent.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
    }

    private var emptyFavoritesView: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.slash")
                .font(.system(size: 36))
                .foregroundStyle(Theme.textTertiary)
            Text("No favorites yet")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textSecondary)
            Text("Tap the heart icon on any business path to save it here")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
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
                    Text("Unlock All \(matchesAbove40.count) Matches")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Plus templates, scripts & business plans")
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
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
    }

    private var lockedResultsBanner: some View {
        Button {
            showPaywall = true
        } label: {
            VStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundStyle(Theme.textTertiary)
                Text("\(matchesAbove40.count - 20) more matches above 40% available with Pro")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.textSecondary)
                Text("Upgrade to Pro")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
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
                    .stroke(Theme.accentBlue.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var whatIfHint: some View {
        HStack(spacing: 8) {
            Image(systemName: "lightbulb.fill")
                .font(.caption)
                .foregroundStyle(.yellow)
            Text("Adjust your profile in **What If Mode** to see how your match scores change.")
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 10))
    }

    private func shareAllResults() {
        guard let topResult = visibleResults.first else { return }
        shareResult = topResult
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

                HStack(spacing: 8) {
                    matchBadge

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

    private var badgeColor: Color {
        if result.scorePercentage >= 80 { return Theme.accent }
        if result.scorePercentage >= 60 { return Theme.accentBlue }
        return Color(hex: "FB923C")
    }

    private var categoryColor: Color {
        Theme.categoryColor(for: result.businessPath.category)
    }
}
