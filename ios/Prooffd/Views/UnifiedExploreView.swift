import SwiftUI

struct UnifiedExploreView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedResult: MatchResult?
    @State private var showPaywall: Bool = false
    @State private var searchText: String = ""
    @State private var showJobShare: MatchResult?
    @State private var showRedoQuizAlert: Bool = false
    @State private var showHeroBusinessResult: MatchResult?
    @State private var showHeroEducationPath: CareerPath?
    @State private var showHeroDegreeRecord: DegreeCareerRecord?
    @State private var showDailyRewardPopup: Bool = false
    @State private var showWeeklySummary: Bool = WeeklySummaryScheduler.shouldShow
    @State private var siriTipHidden: Bool = UserDefaults.standard.bool(forKey: "siriTip_dismissed_dailyTip")

    private var allResults: [MatchResult] { appState.matchResults }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    DailyRewardBanner(
                        canClaim: appState.dailyRewards.canClaim,
                        currentDay: appState.dailyRewards.currentDay
                    ) {
                        showDailyRewardPopup = true
                    }

                    DailyMicroActionCard()

                    if showWeeklySummary {
                        WeeklySummaryCard(isVisible: $showWeeklySummary)
                    }

                    if !siriTipHidden {
                        SiriDailyTipHint {
                            UserDefaults.standard.set(true, forKey: "siriTip_dismissed_dailyTip")
                            withAnimation(.spring(duration: 0.3)) { siriTipHidden = true }
                        }
                    }

                    bestMatchHeroCard

                    if let build = appState.activeBuild {
                        continueCard(build)
                    }

                    heroCard(path: .business, subtitle: "\(ContentLibrary.jobCount) businesses")
                    heroCard(path: .trades, subtitle: "\(EducationPathDatabase.all.count) programs")
                    heroCard(path: .degree, subtitle: "\(DegreeCareerDatabase.allRecords.count) careers")

                    redoQuizCard

                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !store.isPremium {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "crown.fill")
                                    .font(.caption.weight(.bold))
                                Text("PRO")
                                    .font(.caption.weight(.bold))
                            }
                            .foregroundStyle(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Theme.accent)
                            .clipShape(.capsule)
                        }
                        .accessibilityLabel("Unlock Pro")
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search careers & businesses")
            .overlay {
                if !searchText.isEmpty {
                    searchOverlay
                }
            }
            .navigationDestination(for: ChosenPath.self) { path in
                switch path {
                case .business:
                    BusinessExplorePage()
                case .trades:
                    TradesExplorePage()
                case .degree:
                    DegreeExplorePage()
                }
            }
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $showHeroBusinessResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $showHeroEducationPath) { career in
                CareerPathDetailSheet(career: career)
            }
            .sheet(item: $showHeroDegreeRecord) { record in
                DegreeCareerDetailSheet(record: record)
            }
            .sheet(item: $showJobShare) { result in
                ShareCardPresenterSheet(content: .topMatch(from: result))
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .alert("Redo Quiz?", isPresented: $showRedoQuizAlert) {
                Button("Redo Quiz", role: .destructive) {
                    appState.retakeQuiz()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will reset your matches and restart the quiz.")
            }
            .overlay {
                if showDailyRewardPopup {
                    DailyRewardPopup(
                        reward: appState.dailyRewards.todayReward,
                        currentDay: appState.dailyRewards.currentDay
                    ) {
                        appState.claimDailyReward()
                        withAnimation(.spring(duration: 0.3)) {
                            showDailyRewardPopup = false
                        }
                    }
                    .transition(.opacity)
                }
            }
        }
    }

    // MARK: - Best Match Hero Card

    @ViewBuilder
    private var bestMatchHeroCard: some View {
        if let path = appState.chosenPath {
            switch path {
            case .business:
                if let topResult = appState.matchResults.first {
                    bestMatchBusinessCard(topResult)
                }
            case .trades:
                if let topEdu = topEducationMatch {
                    bestMatchTradesCard(topEdu.path, score: topEdu.score)
                }
            case .degree:
                if let topDeg = topDegreeMatch {
                    bestMatchDegreeCard(topDeg.record, score: topDeg.score)
                }
            }
        }
    }

    private var topEducationMatch: (path: EducationPath, score: Int)? {
        let scored = EducationPathDatabase.all.compactMap { path -> (path: EducationPath, score: Int)? in
            let s = appState.educationScore(for: path.id)
            return (path, s)
        }
        return scored.max(by: { $0.score < $1.score })
    }

    private var topDegreeMatch: (record: DegreeCareerRecord, score: Int)? {
        let scored = DegreeCareerDatabase.allRecords.compactMap { record -> (record: DegreeCareerRecord, score: Int)? in
            let s = appState.degreeScore(for: record.id)
            return (record, s)
        }
        return scored.max(by: { $0.score < $1.score })
    }

    private func bestMatchBusinessCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return Button {
            showHeroBusinessResult = result
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 52, height: 52)
                        Image(systemName: result.businessPath.icon)
                            .font(.title3)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                            Text("Your Best Match")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.accent)
                        }

                        Text(result.businessPath.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Text(result.businessPath.category.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    matchScoreBadge(result.scorePercentage, color: catColor)
                }
                .padding(16)

                Rectangle()
                    .fill(catColor.opacity(0.08))
                    .frame(height: 1)

                HStack(spacing: 16) {
                    matchStat(icon: "dollarsign.circle.fill", value: result.businessPath.startupCostRange, color: catColor)
                    matchStat(icon: "clock.fill", value: result.businessPath.timeToFirstDollar, color: catColor)
                    matchStat(icon: result.businessPath.zone.icon, value: "\(result.businessPath.aiProofRating)/100", color: catColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.06), Color(.secondarySystemGroupedBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func bestMatchTradesCard(_ path: EducationPath, score: Int) -> some View {
        let catColor = Theme.accentBlue
        return Button {
            showHeroEducationPath = path
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 52, height: 52)
                        Image(systemName: path.icon)
                            .font(.title3)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                            Text("Your Best Match")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(catColor)
                        }

                        Text(path.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Text(path.category.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    matchScoreBadge(score, color: catColor)
                }
                .padding(16)

                Rectangle()
                    .fill(catColor.opacity(0.08))
                    .frame(height: 1)

                HStack(spacing: 16) {
                    matchStat(icon: "dollarsign.circle.fill", value: path.typicalSalaryRange, color: catColor)
                    matchStat(icon: "clock.fill", value: path.timeToComplete, color: catColor)
                    matchStat(icon: path.zone.icon, value: "\(path.aiSafeScore)/100", color: catColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.06), Color(.secondarySystemGroupedBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func bestMatchDegreeCard(_ record: DegreeCareerRecord, score: Int) -> some View {
        let catColor = Color(hex: "818CF8")
        return Button {
            showHeroDegreeRecord = record
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 52, height: 52)
                        Image(systemName: record.icon)
                            .font(.title3)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                            Text("Your Best Match")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(catColor)
                        }

                        Text(record.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Text(record.category.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    matchScoreBadge(score, color: catColor)
                }
                .padding(16)

                Rectangle()
                    .fill(catColor.opacity(0.08))
                    .frame(height: 1)

                HStack(spacing: 16) {
                    matchStat(icon: "dollarsign.circle.fill", value: record.salaryExperienced, color: catColor)
                    matchStat(icon: "clock.fill", value: record.timeline, color: catColor)
                    matchStat(icon: record.aiProofTier.icon, value: record.aiProofTier.label, color: catColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.06), Color(.secondarySystemGroupedBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func matchScoreBadge(_ score: Int, color: Color) -> some View {
        VStack(spacing: 2) {
            Text("\(score)%")
                .font(.title2.weight(.bold))
                .foregroundStyle(color)
            Text("match")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .frame(width: 60)
    }

    private func matchStat(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(color)
            Text(value)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Category Card

    private func heroCard(path: ChosenPath, subtitle: String) -> some View {
        NavigationLink(value: path) {
            HStack(spacing: 16) {
                Image(systemName: path.icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        LinearGradient(
                            colors: heroGradient(for: path),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text(path.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(20)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }

    private func heroGradient(for path: ChosenPath) -> [Color] {
        switch path {
        case .business: return [Theme.accent, Theme.accent.opacity(0.7)]
        case .trades: return [Theme.accentBlue, Theme.accentBlue.opacity(0.7)]
        case .degree: return [Color(hex: "818CF8"), Color(hex: "818CF8").opacity(0.7)]
        }
    }

    // MARK: - Continue Card

    private func continueCard(_ build: BuildProject) -> some View {
        Button {
            appState.selectedTab = 1
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 3)
                        .frame(width: 48, height: 48)
                    Circle()
                        .trim(from: 0, to: Double(build.progressPercentage) / 100.0)
                        .stroke(Theme.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-90))
                    Text("\(build.progressPercentage)%")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Theme.accent)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Continue Your Plan")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(build.pathName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Search

    private var searchResults: [MatchResult] {
        guard !searchText.isEmpty else { return [] }
        let q = searchText.lowercased()
        return allResults.filter {
            $0.businessPath.name.localizedStandardContains(q) ||
            $0.businessPath.overview.localizedStandardContains(q) ||
            $0.businessPath.category.rawValue.localizedStandardContains(q)
        }
    }

    private var searchOverlay: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if searchResults.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundStyle(.tertiary)
                        Text("No results for \"\(searchText)\"")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 80)
                } else {
                    ForEach(searchResults) { result in
                        Button {
                            selectedResult = result
                            appState.markPathExplored(result.businessPath.id)
                        } label: {
                            searchRow(result)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Color(.systemGroupedBackground))
    }

    private func searchRow(_ result: MatchResult) -> some View {
        HStack(spacing: 14) {
            Image(systemName: result.businessPath.icon)
                .font(.body)
                .foregroundStyle(Theme.categoryColor(for: result.businessPath.category))
                .frame(width: 40, height: 40)
                .background(Theme.categoryColor(for: result.businessPath.category).opacity(0.12))
                .clipShape(.rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(result.businessPath.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                Text(result.businessPath.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
    }

    // MARK: - Redo Quiz

    private var redoQuizCard: some View {
        Button {
            showRedoQuizAlert = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Redo Quiz")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text("Retake the quiz to update your matches")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Upgrade

    private var upgradeCard: some View {
        Button {
            showPaywall = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "crown.fill")
                    .font(.title3)
                    .foregroundStyle(.yellow)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Unlock Full Plans")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text("Business plans, scripts, templates & PDF export")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("PRO")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Theme.accent)
                    .clipShape(.capsule)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}
