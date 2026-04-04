import SwiftUI

enum ExploreSegment: String, CaseIterable, Identifiable {
    case forYou = "For You"
    case business = "Business"
    case education = "Education"
    case saved = "Saved"

    var id: String { rawValue }
}

struct UnifiedExploreView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedSegment: ExploreSegment = .forYou
    @State private var selectedResult: MatchResult?
    @State private var showPaywall: Bool = false
    @State private var showWhatIf: Bool = false
    @State private var seeAllMode: SeeAllMode?
    @State private var showSearch: Bool = false
    @State private var searchText: String = ""
    @State private var showRandomPicks: Bool = false
    @State private var randomPicks: [MatchResult] = []
    @State private var showAchievements: Bool = false
    @State private var showProgressShare: Bool = false
    @State private var showJobShare: MatchResult?
    @State private var showEducationCategorySheet: EducationCategory?
    @State private var showDegreeCategorySheet: DegreeCareerCategory?
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var allResults: [MatchResult] {
        appState.matchResults
    }

    private var recommendedResults: [MatchResult] {
        Array(allResults.sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }.prefix(8))
    }

    private var fastStartResults: [MatchResult] {
        Array(allResults.filter {
            $0.businessPath.minBudget < 200 && $0.businessPath.fastCashPotential
        }.prefix(8))
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
            VStack(spacing: 0) {
                if !showSearch {
                    segmentPicker
                }

                Group {
                    if showSearch {
                        searchContent
                    } else {
                        switch selectedSegment {
                        case .forYou:
                            forYouContent
                        case .business:
                            businessContent
                        case .education:
                            educationContent
                        case .saved:
                            savedContent
                        }
                    }
                }
            }
            .background(Theme.background)
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $showJobShare) { result in
                ShareCardPresenterSheet(content: .topMatch(from: result))
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
                    ShareCardPresenterSheet(content: .progress(from: build))
                }
            }
            .sheet(item: $seeAllMode) { mode in
                SeeAllView(mode: mode, results: resultsForMode(mode))
            }
            .sheet(item: $showEducationCategorySheet) { category in
                EducationCategoryListSheet(category: category)
            }
            .sheet(item: $showDegreeCategorySheet) { category in
                DegreeCareerCategoryListSheet(category: category)
            }
        }
    }

    private var segmentPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ExploreSegment.allCases) { segment in
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedSegment = segment
                        }
                    } label: {
                        Text(segment.rawValue)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(selectedSegment == segment ? .white : Theme.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedSegment == segment ? Theme.accent : Theme.cardBackground)
                            .clipShape(.capsule)
                    }
                    .sensoryFeedback(.selection, trigger: selectedSegment)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }

    private func resultsForMode(_ mode: SeeAllMode) -> [MatchResult] {
        switch mode {
        case .recommended: return allResults.sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }
        case .fastStart: return allResults.filter { $0.businessPath.minBudget < 200 && $0.businessPath.fastCashPotential }
        case .aiSafe: return allResults.filter { $0.businessPath.aiProofRating >= 80 }.sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }
        case .trending: return allResults.sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }
        case .category(let cat): return allResults.filter { $0.businessPath.category == cat }
        case .search: return searchResults
        }
    }

    // MARK: - For You

    @ViewBuilder
    private var forYouContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                if !appState.hasCompletedQuiz {
                    quizPromptCard
                        .padding(.horizontal, 16)
                }

                if appState.activeBuild != nil {
                    todayCard
                        .padding(.horizontal, 16)
                }

                threePathsSection

                forYouDegreeCareerSection

                forYouTradeCareerSection

                if !recommendedResults.isEmpty {
                    horizontalSection(
                        title: "Most AI-Proof Businesses",
                        icon: "shield.checkered",
                        iconColor: Theme.accent,
                        results: recommendedResults,
                        mode: .recommended
                    )
                }

                if !store.isPremium {
                    upgradePrompt
                        .padding(.horizontal, 16)
                }

                Color.clear.frame(height: 40)
            }
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - For You: Degree Careers

    private var forYouDegreeRecords: [DegreeCareerRecord] {
        let records = DegreeCareerDatabase.allRecords.filter { !appState.isDegreeHidden($0.id) }
        let favs = records.filter { appState.isDegreeFavorite($0.id) }
        if !favs.isEmpty { return Array(favs.prefix(10)) }
        return Array(records.prefix(10))
    }

    private var forYouDegreeCareerSection: some View {
        let records = forYouDegreeRecords
        return Group {
            if !records.isEmpty {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        Image(systemName: "building.columns.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color(hex: "818CF8"))
                        Text("4-Year Degree Careers")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        Button {
                            selectedSegment = .education
                        } label: {
                            Text("See All")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Theme.accent)
                        }
                    }
                    .padding(.horizontal, 16)

                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(records) { record in
                                forYouDegreeCard(record)
                            }
                        }
                    }
                    .contentMargins(.horizontal, 16)
                    .scrollIndicators(.hidden)
                }
            }
        }
    }

    private func forYouDegreeCard(_ record: DegreeCareerRecord) -> some View {
        let catColor: Color = {
            switch record.category {
            case .healthcare: return Color(hex: "F472B6")
            case .mentalHealth: return Color(hex: "818CF8")
            case .engineering: return Theme.accentBlue
            case .legal: return Color(hex: "FB923C")
            case .education: return Theme.accent
            case .aviation: return Color(hex: "38BDF8")
            case .military: return Color(hex: "4ADE80")
            }
        }()
        let tierColor: Color = record.aiProofTier == .tier1 ? Color(hex: "34D399") : record.aiProofTier == .tier2 ? Theme.accentBlue : Color(hex: "FBBF24")

        return Button {
            showDegreeCategorySheet = record.category
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: record.icon)
                            .font(.body)
                            .foregroundStyle(catColor)
                    }
                    Spacer()
                    HStack(spacing: 3) {
                        Image(systemName: record.aiProofTier.icon)
                            .font(.system(size: 9))
                        Text(record.aiProofTier == .tier1 ? "T1" : record.aiProofTier == .tier2 ? "T2" : "T3")
                            .font(.caption2.weight(.bold))
                    }
                    .foregroundStyle(tierColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(tierColor.opacity(0.12))
                    .clipShape(.capsule)
                }

                Text(record.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .font(.system(size: 9))
                        Text(record.salaryExperienced)
                            .font(.caption2.weight(.medium))
                    }
                    .foregroundStyle(Theme.accent)

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 9))
                        Text(record.timeline)
                            .font(.caption2)
                    }
                    .foregroundStyle(Theme.textTertiary)
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

    // MARK: - For You: Trade & Certification Careers

    private var forYouEducationPaths: [EducationPath] {
        let paths = EducationPathDatabase.all.filter { !appState.isEducationHidden($0.id) }
        let favs = paths.filter { appState.isEducationFavorite($0.id) }
        if !favs.isEmpty { return Array(favs.prefix(10)) }
        return Array(paths.prefix(10))
    }

    private var forYouTradeCareerSection: some View {
        let paths = forYouEducationPaths
        return Group {
            if !paths.isEmpty {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.accentBlue)
                        Text("Trades & Certifications")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        Button {
                            selectedSegment = .education
                        } label: {
                            Text("See All")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Theme.accent)
                        }
                    }
                    .padding(.horizontal, 16)

                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(paths) { path in
                                forYouTradeCard(path)
                            }
                        }
                    }
                    .contentMargins(.horizontal, 16)
                    .scrollIndicators(.hidden)
                }
            }
        }
    }

    private func forYouTradeCard(_ path: EducationPath) -> some View {
        let catColor: Color = {
            switch path.category {
            case .trade: return Theme.accent
            case .certification: return Color(hex: "FBBF24")
            case .healthcare: return Color(hex: "F472B6")
            case .technology: return Theme.accentBlue
            case .business: return Color(hex: "FB923C")
            case .creative: return Color(hex: "818CF8")
            case .military: return Color(hex: "4ADE80")
            }
        }()
        let zone = path.zone
        let zoneColor: Color = zone == .safe ? Theme.accent : zone == .human ? Color(hex: "FBBF24") : .orange

        return Button {
            showEducationCategorySheet = path.category
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: path.icon)
                            .font(.body)
                            .foregroundStyle(catColor)
                    }
                    Spacer()
                    Text("\(path.aiSafeScore)/100")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(zoneColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(zoneColor.opacity(0.12))
                        .clipShape(.capsule)
                }

                Text(path.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .font(.system(size: 9))
                        Text(path.typicalSalaryRange)
                            .font(.caption2.weight(.medium))
                    }
                    .foregroundStyle(Theme.accent)

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 9))
                        Text(path.timeToComplete)
                            .font(.caption2)
                    }
                    .foregroundStyle(Theme.textTertiary)
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

    // MARK: - Three Paths

    private var threePathsSection: some View {
        let orderedPaths: [ChosenPath] = {
            guard let chosen = appState.chosenPath else {
                return [.business, .trades, .degree]
            }
            var all: [ChosenPath] = [.business, .trades, .degree]
            all.removeAll { $0 == chosen }
            return [chosen] + all
        }()

        return VStack(spacing: 16) {
            ForEach(orderedPaths, id: \.rawValue) { path in
                pathHeroCard(path, isChosen: path == appState.chosenPath)
            }
        }
        .padding(.horizontal, 16)
    }

    private func pathHeroCard(_ path: ChosenPath, isChosen: Bool) -> some View {
        let count: String = {
            switch path {
            case .business:
                return "\(ContentLibrary.jobCount)+ businesses"
            case .trades:
                return "\(EducationPathDatabase.all.count) programs"
            case .degree:
                return "\(DegreeCareerDatabase.allRecords.count) careers"
            }
        }()

        return Button {
            switch path {
            case .business:
                selectedSegment = .business
            case .trades:
                selectedSegment = .education
            case .degree:
                selectedSegment = .education
            }
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(path.color.opacity(0.12))
                            .frame(width: 60, height: 60)
                        Image(systemName: path.icon)
                            .font(.title2)
                            .foregroundStyle(path.color)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(path.title)
                                .font(.title3.weight(.bold))
                                .foregroundStyle(Theme.textPrimary)
                            if isChosen {
                                Text("YOUR PICK")
                                    .font(.system(size: 9, weight: .heavy))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(path.color)
                                    .clipShape(.capsule)
                            }
                        }
                        Text(path.subtitle)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .lineLimit(2)
                    }

                    Spacer(minLength: 4)

                    Image(systemName: "chevron.right")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(path.color)
                }
                .padding(20)

                HStack(spacing: 0) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.grid.2x2")
                            .font(.caption2)
                        Text(count)
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(path.color)

                    Spacer()

                    Text("Explore →")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(path.color)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(path.color.opacity(0.05))
            }
            .background(
                LinearGradient(
                    colors: [path.color.opacity(isChosen ? 0.08 : 0.03), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isChosen ? path.color.opacity(0.4) : path.color.opacity(0.12), lineWidth: isChosen ? 2 : 0.5)
            )
            .shadow(color: isChosen ? path.color.opacity(0.15) : .clear, radius: 12, y: 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Business

    private var highAIProofBusinesses: [MatchResult] {
        Array(allResults.filter { $0.businessPath.aiProofRating >= 80 }
            .sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }
            .prefix(8))
    }

    private var scalableBusinesses: [MatchResult] {
        Array(allResults.filter { $0.businessPath.isScalable && $0.businessPath.aiProofRating >= 60 }
            .sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }
            .prefix(8))
    }

    @ViewBuilder
    private var businessContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                if !highAIProofBusinesses.isEmpty {
                    horizontalSection(
                        title: "Most AI-Proof",
                        icon: "shield.checkered",
                        iconColor: Theme.accent,
                        results: highAIProofBusinesses,
                        mode: .aiSafe
                    )
                }

                browseByCategorySection

                if !fastStartResults.isEmpty {
                    horizontalSection(
                        title: "Fast Start Options",
                        icon: "bolt.fill",
                        iconColor: Color(hex: "FB923C"),
                        results: fastStartResults,
                        mode: .fastStart
                    )
                }

                if !scalableBusinesses.isEmpty {
                    horizontalSection(
                        title: "Scalable Businesses",
                        icon: "chart.line.uptrend.xyaxis",
                        iconColor: Color(hex: "818CF8"),
                        results: scalableBusinesses,
                        mode: .recommended
                    )
                }

                Color.clear.frame(height: 40)
            }
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Education

    @ViewBuilder
    private var educationContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                educationOverviewSection
                degreeCareerSection
                shareLoopSection
                Color.clear.frame(height: 40)
            }
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Saved

    @ViewBuilder
    private var savedContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                let savedBusiness = allResults.filter { appState.isFavorite($0.businessPath.id) }
                let savedEducation = EducationPathDatabase.all.filter { appState.isEducationFavorite($0.id) }
                let savedDegree = DegreeCareerDatabase.allRecords.filter { appState.isDegreeFavorite($0.id) }

                if savedBusiness.isEmpty && savedEducation.isEmpty && savedDegree.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 44))
                            .foregroundStyle(Theme.textTertiary)
                        Text("Nothing Saved Yet")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                        Text("Save interesting paths to come back to them later.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 48)
                    .padding(.horizontal, 20)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 16))
                    .cardShadow()
                    .padding(.horizontal, 16)
                } else {
                    if !savedBusiness.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "heart.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.pink)
                                Text("Saved Businesses")
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(Theme.textPrimary)
                            }
                            .padding(.horizontal, 16)

                            LazyVStack(spacing: 10) {
                                ForEach(savedBusiness) { result in
                                    SeeAllResultCard(result: result) {
                                        selectedResult = result
                                        appState.markPathExplored(result.businessPath.id)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    if !savedEducation.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "heart.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.pink)
                                Text("Saved Programs")
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(Theme.textPrimary)
                            }
                            .padding(.horizontal, 16)

                            LazyVStack(spacing: 10) {
                                ForEach(savedEducation) { path in
                                    savedEducationCard(path)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    if !savedDegree.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "heart.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.pink)
                                Text("Saved Degree Careers")
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(Theme.textPrimary)
                            }
                            .padding(.horizontal, 16)

                            LazyVStack(spacing: 10) {
                                ForEach(savedDegree) { record in
                                    savedDegreeCard(record)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }

                Color.clear.frame(height: 40)
            }
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
    }

    private func savedEducationCard(_ path: EducationPath) -> some View {
        let catColor: Color = {
            switch path.category {
            case .trade: return Theme.accent
            case .certification: return Color(hex: "FBBF24")
            case .healthcare: return Color(hex: "F472B6")
            case .technology: return Theme.accentBlue
            case .business: return Color(hex: "FB923C")
            case .creative: return Color(hex: "818CF8")
            case .military: return Color(hex: "4ADE80")
            }
        }()

        return HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(catColor.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: path.icon)
                    .font(.body)
                    .foregroundStyle(catColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(path.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                HStack(spacing: 8) {
                    Text(path.category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                    Text(path.typicalSalaryRange)
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }
            }

            Spacer(minLength: 4)

            Image(systemName: "heart.fill")
                .font(.caption)
                .foregroundStyle(.pink)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private func savedDegreeCard(_ record: DegreeCareerRecord) -> some View {
        let catColor: Color = {
            switch record.category {
            case .healthcare: return Color(hex: "F472B6")
            case .mentalHealth: return Color(hex: "818CF8")
            case .engineering: return Theme.accentBlue
            case .legal: return Color(hex: "FB923C")
            case .education: return Theme.accent
            case .aviation: return Color(hex: "38BDF8")
            case .military: return Color(hex: "4ADE80")
            }
        }()

        return HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(catColor.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: record.icon)
                    .font(.body)
                    .foregroundStyle(catColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(record.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                HStack(spacing: 8) {
                    Text(record.category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                    Text(record.salaryExperienced)
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }
            }

            Spacer(minLength: 4)

            Image(systemName: "heart.fill")
                .font(.caption)
                .foregroundStyle(.pink)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    // MARK: - Search

    @ViewBuilder
    private var searchContent: some View {
        ScrollView {
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
        .scrollIndicators(.hidden)
    }

    // MARK: - Top Match Hero

    private func topMatchHero(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        let zone = result.businessPath.zone
        let zoneColor: Color = zone == .safe ? Theme.accent : zone == .human ? Color(hex: "FBBF24") : .orange
        return Button {
            selectedResult = result
            appState.markPathExplored(result.businessPath.id)
        } label: {
            VStack(spacing: 0) {
                VStack(spacing: 14) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundStyle(Color(hex: "FBBF24"))
                            Text("YOUR TOP MATCH")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(Color(hex: "FBBF24"))
                                .tracking(0.5)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(hex: "FBBF24").opacity(0.12))
                        .clipShape(.capsule)
                        Spacer()
                        Button {
                            showJobShare = result
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                                .frame(width: 32, height: 36)
                        }
                        Button {
                            appState.toggleFavorite(result.businessPath.id)
                        } label: {
                            Image(systemName: appState.isFavorite(result.businessPath.id) ? "heart.fill" : "heart")
                                .font(.body)
                                .foregroundStyle(appState.isFavorite(result.businessPath.id) ? .pink : Theme.textTertiary)
                                .frame(width: 36, height: 36)
                        }
                    }

                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(catColor.opacity(0.15))
                                .frame(width: 60, height: 60)
                            Image(systemName: result.businessPath.icon)
                                .font(.title2)
                                .foregroundStyle(catColor)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text(result.businessPath.name)
                                .font(.title3.weight(.bold))
                                .foregroundStyle(Theme.textPrimary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            HStack(spacing: 6) {
                                Image(systemName: result.businessPath.zone.icon)
                                    .font(.system(size: 10))
                                Text(result.businessPath.zone.label)
                                    .font(.caption.weight(.semibold))
                            }
                            .foregroundStyle(aiZoneColor(result.businessPath.zone))
                        }

                        Spacer(minLength: 0)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(CredibilityTagBuilder.tags(for: result.businessPath), id: \.label) { tag in
                                HStack(spacing: 4) {
                                    Image(systemName: tag.icon)
                                        .font(.system(size: 10))
                                    Text(tag.label)
                                        .font(.caption.weight(.semibold))
                                }
                                .foregroundStyle(tag.color)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(tag.color.opacity(0.1))
                                .clipShape(.capsule)
                            }
                            Spacer()
                        }
                    }
                    .allowsHitTesting(false)

                    Text(perfectForLine(result))
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                }
                .padding(20)

                Button {
                    if appState.hasBuild(for: result.businessPath.id) {
                        appState.selectedTab = 1
                    } else {
                        selectedResult = result
                        appState.markPathExplored(result.businessPath.id)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: appState.hasBuild(for: result.businessPath.id) ? "hammer.fill" : "arrow.right.circle.fill")
                        Text(appState.hasBuild(for: result.businessPath.id) ? "View Build" : "Start Plan")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(catColor)
                    .clipShape(.rect(bottomLeadingRadius: 16, bottomTrailingRadius: 16))
                }
            }
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: catColor.opacity(0.15), radius: 16, y: 6)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: appState.isFavorite(result.businessPath.id))
    }

    private func pathTagPill(_ path: BusinessPath) -> some View {
        let tag: String = {
            if path.soloFriendly { return "Solo-Friendly" }
            if path.fastCashPotential { return "Fast to Start" }
            if path.minBudget < 100 { return "Low Startup Cost" }
            if path.isDigital { return "Remote-Friendly" }
            return "Flexible Schedule"
        }()

        return Text(tag)
            .font(.caption.weight(.medium))
            .foregroundStyle(Theme.textSecondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Theme.cardBackgroundLight)
            .clipShape(.capsule)
    }

    // MARK: - Today Card

    private var todayCard: some View {
        let hasActiveBuild = appState.activeBuild != nil
        let title = hasActiveBuild ? "Continue your plan" : "Start your first plan"
        let subtitle = hasActiveBuild ? "Your next build step is ready." : "Take your first step and start building."
        let buttonTitle = hasActiveBuild ? "Open My Build" : "Start Plan"

        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
                Text("Today")
                    .font(.title3.bold())
                    .foregroundStyle(Theme.textPrimary)
            }

            Text(title)
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)

            Button {
                appState.selectedTab = 1
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.right.circle.fill")
                    Text(buttonTitle)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.accent)
                .clipShape(.capsule)
            }
        }
        .padding(18)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.accent.opacity(0.15), lineWidth: 0.5)
        )
        .cardShadow()
    }

    // MARK: - Horizontal Section

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

    private var topOpportunitiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "sparkle")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Text("Top Opportunities")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Button {
                    seeAllMode = .recommended
                } label: {
                    Text("See All")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
            }
            .padding(.horizontal, 16)

            LazyVStack(spacing: 10) {
                ForEach(Array(recommendedResults.dropFirst().prefix(5))) { result in
                    SeeAllResultCard(result: result) {
                        selectedResult = result
                        appState.markPathExplored(result.businessPath.id)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func compactCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        let isSideHustle = result.businessPath.categoryTier == .sideHustle
        let tags = CredibilityTagBuilder.tags(for: result.businessPath)
        return Button {
            selectedResult = result
            appState.markPathExplored(result.businessPath.id)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(isSideHustle ? Theme.cardBackgroundLight : catColor.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: result.businessPath.icon)
                            .font(.body)
                            .foregroundStyle(isSideHustle ? Theme.textTertiary : catColor)
                    }
                    Spacer()
                    HStack(spacing: 3) {
                        Image(systemName: result.businessPath.zone.icon)
                            .font(.system(size: 9))
                        Text("\(result.businessPath.aiProofRating)")
                            .font(.caption2.weight(.bold))
                    }
                    .foregroundStyle(aiZoneColor(result.businessPath.zone))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(aiZoneColor(result.businessPath.zone).opacity(0.12))
                    .clipShape(.capsule)
                }

                Text(result.businessPath.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isSideHustle ? Theme.textSecondary : Theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                if let firstTag = tags.first {
                    HStack(spacing: 4) {
                        Image(systemName: firstTag.icon)
                            .font(.system(size: 8))
                        Text(firstTag.label)
                            .font(.caption2.weight(.medium))
                    }
                    .foregroundStyle(isSideHustle ? Theme.textTertiary : firstTag.color)
                } else {
                    Text(result.businessPath.startupCostRange)
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .frame(width: 160, height: 170, alignment: .leading)
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSideHustle ? Theme.border.opacity(0.5) : catColor.opacity(0.1), lineWidth: 0.5)
            )
            .cardShadow()
            .opacity(isSideHustle ? 0.85 : 1)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Browse by Category

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

    // MARK: - Education

    private var educationOverviewSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "graduationcap.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
                Text("Trade Schools & Certifications")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .padding(.horizontal, 16)

            Text("Skilled trades, healthcare, creative & professional programs")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 16)

            let categories = EducationCategory.allCases.filter { category in
                EducationPathDatabase.all.contains { $0.category == category }
            }

            let columns = sizeClass == .regular
                ? [GridItem(.adaptive(minimum: 160), spacing: 10)]
                : [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(categories) { category in
                    educationCategoryCard(category)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func educationCategoryCard(_ category: EducationCategory) -> some View {
        let count = EducationPathDatabase.all.filter { $0.category == category }.count
        let catColor: Color = {
            switch category {
            case .trade: return Theme.accent
            case .certification: return Color(hex: "FBBF24")
            case .healthcare: return Color(hex: "F472B6")
            case .technology: return Theme.accentBlue
            case .business: return Color(hex: "FB923C")
            case .creative: return Color(hex: "818CF8")
            case .military: return Color(hex: "4ADE80")
            }
        }()

        return Button {
            showEducationCategorySheet = category
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(catColor.opacity(0.12))
                            .frame(width: 36, height: 36)
                        Image(systemName: category.icon)
                            .font(.subheadline)
                            .foregroundStyle(catColor)
                    }
                    Spacer()
                    Text("\(count)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(catColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(catColor.opacity(0.1))
                        .clipShape(.capsule)
                }

                Text(category.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
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

    // MARK: - Degree Careers

    private var degreeCareerSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "building.columns.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color(hex: "818CF8"))
                Text("4-Year Degree Careers")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .padding(.horizontal, 16)

            Text("Licensed professions requiring bachelor's, master's, or doctoral degrees")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 16)

            let categories = DegreeCareerCategory.allCases.filter { category in
                DegreeCareerDatabase.allRecords.contains { $0.category == category }
            }

            let columns = sizeClass == .regular
                ? [GridItem(.adaptive(minimum: 160), spacing: 10)]
                : [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(categories) { category in
                    degreeCategoryCard(category)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func degreeCategoryCard(_ category: DegreeCareerCategory) -> some View {
        let count = DegreeCareerDatabase.allRecords.filter { $0.category == category && !appState.isDegreeHidden($0.id) }.count
        let catColor: Color = {
            switch category {
            case .healthcare: return Color(hex: "F472B6")
            case .mentalHealth: return Color(hex: "818CF8")
            case .engineering: return Theme.accentBlue
            case .legal: return Color(hex: "FB923C")
            case .education: return Theme.accent
            case .aviation: return Color(hex: "38BDF8")
            case .military: return Color(hex: "4ADE80")
            }
        }()

        return Button {
            showDegreeCategorySheet = category
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(catColor.opacity(0.12))
                            .frame(width: 36, height: 36)
                        Image(systemName: category.icon)
                            .font(.subheadline)
                            .foregroundStyle(catColor)
                    }
                    Spacer()
                    Text("\(count)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(catColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(catColor.opacity(0.1))
                        .clipShape(.capsule)
                }

                Text(category.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
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

    private var shareLoopSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.fill")
                .font(.title2)
                .foregroundStyle(Theme.accentBlue)
            Text("Challenge a friend to find theirs")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
            Text("Share the app and see who gets better matches")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .multilineTextAlignment(.center)

            Button {
                shareApp()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share with a Friend")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.accentBlue)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Theme.accentBlue.opacity(0.12))
                .clipShape(.capsule)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
        .padding(.horizontal, 16)
    }

    private func shareApp() {
        if let topResult = appState.matchResults.first {
            let content = ShareCardContent.topMatch(from: topResult)
            let card = TopMatchShareCardView(content: content, style: .clean, format: .story)
            if let image = ShareCardRenderer.render(view: card, format: .story) {
                let shareText = "I just found my top career matches on Prooffd \u{2014} challenge yourself to find yours! Download Prooffd: https://apps.apple.com/app/prooffd/id6743071053"
                ShareCardRenderer.share(image: image, text: shareText)
            }
        } else {
            let shareText = "Check out Prooffd \u{2014} find your perfect career or business match! Download: https://apps.apple.com/app/prooffd/id6743071053"
            ShareCardRenderer.share(image: UIImage(), text: shareText)
        }
    }

    // MARK: - Shared Components

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

    // MARK: - Helpers

    private func aiZoneColor(_ zone: AIZone) -> Color {
        switch zone {
        case .safe: return Theme.accent
        case .human: return Color(hex: "FBBF24")
        case .augmented: return .orange
        }
    }

    private func perfectForLine(_ result: MatchResult) -> String {
        let path = result.businessPath
        if path.fastCashPotential && path.soloFriendly {
            return "Perfect for solo starters who want fast results"
        } else if path.isDigital {
            return "Perfect for those who prefer working from anywhere"
        } else if path.soloFriendly {
            return "Perfect for independent self-starters"
        } else if path.fastCashPotential {
            return "Perfect for earning quickly with minimal setup"
        } else {
            return "Perfect for building a reliable income stream"
        }
    }
}
