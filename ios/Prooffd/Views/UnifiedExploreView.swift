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
    @State private var showLongQuiz: Bool = false
    @State private var showFuturePlan: Bool = false

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

                    longQuizRefineCard

                    if let build = appState.activeBuild {
                        continueCard(build)
                    }

                    heroCard(path: .business, subtitle: "\(ContentLibrary.jobCount) businesses")
                    heroCard(path: .trades, subtitle: "\(EducationPathDatabase.all.count) programs")
                    heroCard(path: .degree, subtitle: "\(DegreeCareerDatabase.allRecords.count) careers")

                    futurePlanCard

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
            .sheet(isPresented: $showLongQuiz) {
                LongQuizView(isPresented: $showLongQuiz, onComplete: { showLongQuiz = false })
            }
            .sheet(isPresented: $showFuturePlan) {
                FuturePlanQuizView(isPresented: $showFuturePlan, onComplete: { showFuturePlan = false })
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

    // MARK: - Extended Precision Quiz

    private var longQuizRefineCard: some View {
        let isCompleted = UserDefaults.standard.bool(forKey: "longQuizCompleted")
        let title = isCompleted ? "Retake the Precision Quiz" : "Extended Precision Quiz"
        let subtitle = isCompleted
            ? "12 deeper questions — retake anytime to sharpen your results"
            : "Answer 12 more questions for noticeably sharper match scores"

        return Button { showLongQuiz = true } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.body.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 38, height: 38)
                        .background(.white.opacity(0.18))
                        .clipShape(.rect(cornerRadius: 10))
                    Text("GO DEEPER")
                        .font(.caption2.weight(.bold))
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.75))
                    Spacer()
                    if !isCompleted {
                        Text("FREE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color(hex: "059669"))
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                }
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 6) {
                    Text(isCompleted ? "Retake now" : "Take the quiz")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color(hex: "059669"))
                    Image(systemName: "arrow.right")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color(hex: "059669"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(Capsule())
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                ZStack {
                    ArtworkImage(name: PathArtwork.quizBackdrop)
                    LinearGradient(
                        colors: [Color(hex: "059669").opacity(0.82), Color(hex: "0891B2").opacity(0.82)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .clipShape(.rect(cornerRadius: 20))
            .shadow(color: Color(hex: "059669").opacity(0.35), radius: 14, y: 6)
        }
        .buttonStyle(ArtworkPressStyle())
    }

    // MARK: - Future Planner

    private var futurePlanCard: some View {
        let isCompleted = appState.futurePlan != nil
        let buttonLabel = isCompleted ? "Retake Future Planner" : "Build Your Future Plan"
        let subtitle = isCompleted
            ? "Update your roadmap and age outlook anytime"
            : "A deeper quiz that maps your future, step by step"

        return Button { showFuturePlan = true } label: {
            HStack(spacing: 14) {
                ArtworkImage(name: PathArtwork.futurePath)
                    .frame(width: 52, height: 52)
                    .clipped()
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color(hex: "818CF8").opacity(0.35), lineWidth: 1)
                    )
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(buttonLabel)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                        if !isCompleted {
                            Text("FREE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Theme.accent)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Theme.accent.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                    Text(subtitle)
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
        .buttonStyle(ArtworkPressStyle())
    }

    /// Shared full-bleed art header for the three hero match cards.
    private func heroImageHeader(artwork: String, accentColor: Color, name: String, subtitle: String, score: Int) -> some View {
        ZStack(alignment: .bottomLeading) {
            ArtworkImage(name: artwork)
                .frame(height: 240)
                .frame(maxWidth: .infinity)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.55), .black.opacity(0.9)],
                startPoint: .init(x: 0.5, y: 0.35),
                endPoint: .bottom
            )
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Image(systemName: "crown.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    Text("YOUR BEST MATCH")
                        .font(.caption2.weight(.bold))
                        .tracking(1.2)
                        .foregroundStyle(.white.opacity(0.9))
                }
                Text(name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
            }
            .padding(16)
        }
        .overlay(alignment: .topTrailing) {
            VStack(spacing: 0) {
                ScoreCountUpText(target: score, font: .system(size: 28, weight: .heavy, design: .rounded), color: .white)
                Text("match")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(12)
            .background(.black.opacity(0.35), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(accentColor.opacity(0.5), lineWidth: 1)
            )
            .padding(12)
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
                heroImageHeader(
                    artwork: PathArtwork.image(for: result.businessPath),
                    accentColor: catColor,
                    name: result.businessPath.name,
                    subtitle: result.businessPath.category.rawValue,
                    score: result.scorePercentage
                )

                HStack(spacing: 16) {
                    matchStat(icon: "dollarsign.circle.fill", value: result.businessPath.startupCostRange, color: catColor)
                    matchStat(icon: "clock.fill", value: result.businessPath.timeToFirstDollar, color: catColor)
                    matchStat(icon: result.businessPath.zone.icon, value: "\(result.businessPath.aiProofRating)/100", color: catColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(.secondarySystemGroupedBackground))
            }
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(catColor.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(ArtworkPressStyle())
    }

    private func bestMatchTradesCard(_ path: EducationPath, score: Int) -> some View {
        let catColor = Theme.accentBlue
        return Button {
            showHeroEducationPath = path
        } label: {
            VStack(spacing: 0) {
                heroImageHeader(
                    artwork: PathArtwork.educationImage(for: path.category),
                    accentColor: catColor,
                    name: path.title,
                    subtitle: path.category.rawValue,
                    score: score
                )

                HStack(spacing: 16) {
                    matchStat(icon: "dollarsign.circle.fill", value: path.typicalSalaryRange, color: catColor)
                    matchStat(icon: "clock.fill", value: path.timeToComplete, color: catColor)
                    matchStat(icon: path.zone.icon, value: "\(path.aiSafeScore)/100", color: catColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(.secondarySystemGroupedBackground))
            }
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(catColor.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(ArtworkPressStyle())
    }

    private func bestMatchDegreeCard(_ record: DegreeCareerRecord, score: Int) -> some View {
        let catColor = Color(hex: "818CF8")
        return Button {
            showHeroDegreeRecord = record
        } label: {
            VStack(spacing: 0) {
                heroImageHeader(
                    artwork: PathArtwork.image(for: record),
                    accentColor: catColor,
                    name: record.title,
                    subtitle: record.category.rawValue,
                    score: score
                )

                HStack(spacing: 16) {
                    matchStat(icon: "dollarsign.circle.fill", value: record.salaryExperienced, color: catColor)
                    matchStat(icon: "clock.fill", value: record.timeline, color: catColor)
                    matchStat(icon: record.aiProofTier.icon, value: record.aiProofTier.label, color: catColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(.secondarySystemGroupedBackground))
            }
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(catColor.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(ArtworkPressStyle())
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
                ArtworkImage(name: PathArtwork.image(for: path))
                    .frame(width: 56, height: 56)
                    .clipped()
                    .clipShape(.rect(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(heroGradient(for: path)[0].opacity(0.4), lineWidth: 1)
                    )

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
