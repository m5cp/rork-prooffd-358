import SwiftUI

struct UnifiedExploreView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedResult: MatchResult?
    @State private var showPaywall: Bool = false
    @State private var showEducationCategorySheet: EducationCategory?
    @State private var showDegreeCategorySheet: DegreeCareerCategory?
    @State private var seeAllMode: SeeAllMode?
    @State private var searchText: String = ""
    @State private var showJobShare: MatchResult?
    @State private var expandedCard: ChosenPath?

    private var allResults: [MatchResult] { appState.matchResults }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let build = appState.activeBuild {
                        continueCard(build)
                    }

                    heroCard(
                        path: .business,
                        subtitle: "\(ContentLibrary.jobCount) businesses",
                        expanded: expandedCard == .business
                    ) {
                        businessContent
                    }

                    heroCard(
                        path: .trades,
                        subtitle: "\(EducationPathDatabase.all.count) programs",
                        expanded: expandedCard == .trades
                    ) {
                        tradeContent
                    }

                    heroCard(
                        path: .degree,
                        subtitle: "\(DegreeCareerDatabase.allRecords.count) careers",
                        expanded: expandedCard == .degree
                    ) {
                        degreeContent
                    }

                    if !store.isPremium {
                        upgradeCard
                    }

                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search careers & businesses")
            .overlay {
                if !searchText.isEmpty {
                    searchOverlay
                }
            }
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $showJobShare) { result in
                ShareCardPresenterSheet(content: .topMatch(from: result))
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
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

    // MARK: - Hero Card

    private func heroCard<Content: View>(
        path: ChosenPath,
        subtitle: String,
        expanded: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(duration: 0.4, bounce: 0.15)) {
                    expandedCard = expandedCard == path ? nil : path
                }
            } label: {
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

                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
                .padding(20)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: expandedCard)

            if expanded {
                Rectangle()
                    .fill(Color(.separator).opacity(0.3))
                    .frame(height: 0.5)
                    .padding(.horizontal, 20)

                content()
                    .padding(16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 20))
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

    // MARK: - Business Content

    @ViewBuilder
    private var businessContent: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(Array(topBusinesses.prefix(6))) { result in
                        miniCard(
                            icon: result.businessPath.icon,
                            name: result.businessPath.name,
                            detail: result.businessPath.startupCostRange,
                            color: Theme.categoryColor(for: result.businessPath.category)
                        ) {
                            selectedResult = result
                            appState.markPathExplored(result.businessPath.id)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)

            VStack(spacing: 8) {
                ForEach(BusinessCategory.allCases) { cat in
                    let count = allResults.filter { r in r.businessPath.category == cat }.count
                    if count > 0 {
                        categoryRow(
                            icon: cat.icon,
                            name: cat.rawValue,
                            count: count,
                            color: Theme.categoryColor(for: cat)
                        ) {
                            seeAllMode = .category(cat)
                        }
                    }
                }
            }
        }
    }

    private var topBusinesses: [MatchResult] {
        Array(allResults.sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }.prefix(6))
    }

    // MARK: - Trade Content

    @ViewBuilder
    private var tradeContent: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(Array(topTradePaths.prefix(6))) { path in
                        miniCard(
                            icon: path.icon,
                            name: path.title,
                            detail: path.typicalSalaryRange,
                            color: educationCategoryColor(path.category)
                        ) {
                            showEducationCategorySheet = path.category
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)

            let categories = EducationCategory.allCases.filter { cat in
                EducationPathDatabase.all.contains { p in p.category == cat }
            }
            VStack(spacing: 8) {
                ForEach(categories) { cat in
                    let count = EducationPathDatabase.all.filter { p in p.category == cat }.count
                    categoryRow(
                        icon: cat.icon,
                        name: cat.rawValue,
                        count: count,
                        color: educationCategoryColor(cat)
                    ) {
                        showEducationCategorySheet = cat
                    }
                }
            }
        }
    }

    private var topTradePaths: [EducationPath] {
        Array(EducationPathDatabase.all.sorted { $0.aiSafeScore > $1.aiSafeScore }.prefix(6))
    }

    // MARK: - Degree Content

    @ViewBuilder
    private var degreeContent: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(Array(DegreeCareerDatabase.allRecords.prefix(6))) { record in
                        miniCard(
                            icon: record.icon,
                            name: record.title,
                            detail: record.salaryExperienced,
                            color: degreeCategoryColor(record.category)
                        ) {
                            showDegreeCategorySheet = record.category
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)

            let categories = DegreeCareerCategory.allCases.filter { cat in
                DegreeCareerDatabase.allRecords.contains { r in r.category == cat }
            }
            VStack(spacing: 8) {
                ForEach(categories) { cat in
                    let count = DegreeCareerDatabase.allRecords.filter { r in r.category == cat }.count
                    categoryRow(
                        icon: cat.icon,
                        name: cat.rawValue,
                        count: count,
                        color: degreeCategoryColor(cat)
                    ) {
                        showDegreeCategorySheet = cat
                    }
                }
            }
        }
    }

    // MARK: - Shared Components

    private func miniCard(icon: String, name: String, detail: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(color)
                    .frame(width: 36, height: 36)
                    .background(color.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 10))

                Text(name)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                Text(detail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 120, height: 110, alignment: .leading)
            .padding(12)
            .background(Color(.tertiarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private func categoryRow(icon: String, name: String, count: Int, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(color)
                    .frame(width: 32, height: 32)
                    .background(color.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 8))

                Text(name)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Spacer(minLength: 2)

                Text("\(count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
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

    // MARK: - Colors

    private func educationCategoryColor(_ category: EducationCategory) -> Color {
        switch category {
        case .trade: return Theme.accent
        case .certification: return Color(hex: "FBBF24")
        case .healthcare: return Color(hex: "F472B6")
        case .technology: return Theme.accentBlue
        case .business: return Color(hex: "FB923C")
        case .creative: return Color(hex: "818CF8")
        case .military: return Color(hex: "4ADE80")
        }
    }

    private func degreeCategoryColor(_ category: DegreeCareerCategory) -> Color {
        switch category {
        case .healthcare: return Color(hex: "F472B6")
        case .mentalHealth: return Color(hex: "818CF8")
        case .engineering: return Theme.accentBlue
        case .legal: return Color(hex: "FB923C")
        case .education: return Theme.accent
        case .aviation: return Color(hex: "38BDF8")
        case .military: return Color(hex: "4ADE80")
        }
    }
}
