import SwiftUI

struct UnifiedExploreView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedResult: MatchResult?
    @State private var showPaywall: Bool = false
    @State private var showEducationCategorySheet: EducationCategory?
    @State private var showDegreeCategorySheet: DegreeCareerCategory?
    @State private var seeAllMode: SeeAllMode?
    @State private var showSearch: Bool = false
    @State private var searchText: String = ""
    @State private var showJobShare: MatchResult?
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var allResults: [MatchResult] { appState.matchResults }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    heroGreeting
                    businessSection
                    tradeSection
                    degreeSection

                    if !store.isPremium {
                        upgradeCard
                    }

                    Color.clear.frame(height: 40)
                }
                .padding(.top, 4)
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

    // MARK: - Hero Greeting

    private var heroGreeting: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let build = appState.activeBuild {
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
                            Text("Continue Building")
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
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Start a Business

    private var businessSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle(
                "Start a Business",
                icon: "briefcase.fill",
                color: Theme.accent,
                count: ContentLibrary.jobCount
            )

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(Array(topBusinesses.prefix(8))) { result in
                        businessCard(result)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)

            categoryGrid(
                categories: BusinessCategory.allCases,
                color: { Theme.categoryColor(for: $0) },
                icon: { $0.icon },
                name: { $0.rawValue },
                count: { cat in allResults.filter { r in r.businessPath.category == cat }.count },
                action: { cat in seeAllMode = .category(cat) }
            )
        }
    }

    private var topBusinesses: [MatchResult] {
        Array(allResults.sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }.prefix(8))
    }

    private func businessCard(_ result: MatchResult) -> some View {
        let color = Theme.categoryColor(for: result.businessPath.category)
        return Button {
            selectedResult = result
            appState.markPathExplored(result.businessPath.id)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: result.businessPath.icon)
                        .font(.title3)
                        .foregroundStyle(color)
                        .frame(width: 44, height: 44)
                        .background(color.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 12))
                    Spacer()
                    aiProofPill(result.businessPath.zone, rating: result.businessPath.aiProofRating)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(result.businessPath.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    Text(result.businessPath.startupCostRange)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 164, height: 150, alignment: .leading)
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Trades & Certifications

    private var tradeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle(
                "Trades & Certifications",
                icon: "wrench.and.screwdriver.fill",
                color: Theme.accentBlue,
                count: EducationPathDatabase.all.count
            )

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(Array(topTradePaths.prefix(8))) { path in
                        tradeCard(path)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)

            let categories = EducationCategory.allCases.filter { cat in
                EducationPathDatabase.all.contains { $0.category == cat }
            }
            categoryGrid(
                categories: categories,
                color: { educationCategoryColor($0) },
                icon: { $0.icon },
                name: { $0.rawValue },
                count: { cat in EducationPathDatabase.all.filter { p in p.category == cat }.count },
                action: { cat in showEducationCategorySheet = cat }
            )
        }
    }

    private var topTradePaths: [EducationPath] {
        Array(EducationPathDatabase.all.sorted { $0.aiSafeScore > $1.aiSafeScore }.prefix(8))
    }

    private func tradeCard(_ path: EducationPath) -> some View {
        let color = educationCategoryColor(path.category)
        return Button {
            showEducationCategorySheet = path.category
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: path.icon)
                        .font(.title3)
                        .foregroundStyle(color)
                        .frame(width: 44, height: 44)
                        .background(color.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 12))
                    Spacer()
                    aiProofPill(path.zone, rating: path.aiSafeScore)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(path.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    Text(path.typicalSalaryRange)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 164, height: 150, alignment: .leading)
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - 4-Year Degree Careers

    private var degreeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle(
                "4-Year Degree Careers",
                icon: "building.columns.fill",
                color: Color(hex: "818CF8"),
                count: DegreeCareerDatabase.allRecords.count
            )

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(Array(DegreeCareerDatabase.allRecords.prefix(8))) { record in
                        degreeCard(record)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)

            let categories = DegreeCareerCategory.allCases.filter { cat in
                DegreeCareerDatabase.allRecords.contains { $0.category == cat }
            }
            categoryGrid(
                categories: categories,
                color: { degreeCategoryColor($0) },
                icon: { $0.icon },
                name: { $0.rawValue },
                count: { cat in DegreeCareerDatabase.allRecords.filter { r in r.category == cat }.count },
                action: { cat in showDegreeCategorySheet = cat }
            )
        }
    }

    private func degreeCard(_ record: DegreeCareerRecord) -> some View {
        let color = degreeCategoryColor(record.category)
        let tierColor: Color = record.aiProofTier == .tier1 ? Color(hex: "34D399") : record.aiProofTier == .tier2 ? Theme.accentBlue : Color(hex: "FBBF24")

        return Button {
            showDegreeCategorySheet = record.category
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: record.icon)
                        .font(.title3)
                        .foregroundStyle(color)
                        .frame(width: 44, height: 44)
                        .background(color.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 12))
                    Spacer()
                    Text(record.aiProofTier.label.replacingOccurrences(of: "ly AI-Resistant", with: ""))
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(tierColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(tierColor.opacity(0.1))
                        .clipShape(.capsule)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(record.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    Text(record.salaryExperienced)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 164, height: 150, alignment: .leading)
            .padding(14)
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
        .padding(.horizontal, 16)
    }

    // MARK: - Shared Components

    private func sectionTitle(_ title: String, icon: String, color: Color, count: Int) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(color)
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
            Spacer()
            Text("\(count)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(.tertiarySystemFill))
                .clipShape(.capsule)
        }
        .padding(.horizontal, 16)
    }

    private func categoryGrid<T: Identifiable & Hashable>(
        categories: [T],
        color: @escaping (T) -> Color,
        icon: @escaping (T) -> String,
        name: @escaping (T) -> String,
        count: @escaping (T) -> Int,
        action: @escaping (T) -> Void
    ) -> some View {
        let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(categories, id: \.self) { cat in
                Button {
                    action(cat)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: icon(cat))
                            .font(.subheadline)
                            .foregroundStyle(color(cat))
                            .frame(width: 32, height: 32)
                            .background(color(cat).opacity(0.1))
                            .clipShape(.rect(cornerRadius: 8))

                        Text(name(cat))
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Spacer(minLength: 2)

                        Text("\(count(cat))")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    private func aiProofPill(_ zone: AIZone, rating: Int) -> some View {
        let color: Color = zone == .safe ? Theme.accent : zone == .human ? Color(hex: "FBBF24") : .orange
        return HStack(spacing: 3) {
            Image(systemName: zone.icon)
                .font(.system(size: 8))
            Text("\(rating)")
                .font(.caption2.weight(.bold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .clipShape(.capsule)
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
