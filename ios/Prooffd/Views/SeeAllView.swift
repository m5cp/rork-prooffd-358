import SwiftUI

enum SeeAllMode: Hashable, Identifiable {
    var id: String {
        switch self {
        case .recommended: return "recommended"
        case .fastStart: return "fastStart"
        case .aiSafe: return "aiSafe"
        case .trending: return "trending"
        case .category(let cat): return "cat_\(cat.rawValue)"
        case .search: return "search"
        }
    }

    case recommended
    case fastStart
    case aiSafe
    case trending
    case category(BusinessCategory)
    case search

    var title: String {
        switch self {
        case .recommended: return "Recommended For You"
        case .fastStart: return "Fast Start Options"
        case .aiSafe: return "High AI-Safe Careers"
        case .trending: return "Popular Right Now"
        case .category(let cat): return cat.rawValue
        case .search: return "Search Results"
        }
    }
}

struct SeeAllView: View {
    let mode: SeeAllMode
    let results: [MatchResult]
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedResult: MatchResult?
    @State private var searchText: String = ""
    @State private var selectedZone: AIZone?
    @State private var selectedCostFilter: CostFilter?
    @State private var showFilters: Bool = false

    private var filteredResults: [MatchResult] {
        var items = results
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            items = items.filter {
                $0.businessPath.name.localizedStandardContains(q) ||
                $0.businessPath.overview.localizedStandardContains(q) ||
                $0.businessPath.category.rawValue.localizedStandardContains(q)
            }
        }
        if let zone = selectedZone {
            items = items.filter { $0.businessPath.zone == zone }
        }
        if let cost = selectedCostFilter {
            items = items.filter { cost.matches($0.businessPath) }
        }
        return items
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    if filteredResults.isEmpty {
                        emptyState
                    } else {
                        ForEach(filteredResults) { result in
                            SeeAllResultCard(result: result) {
                                selectedResult = result
                                appState.markPathExplored(result.businessPath.id)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search paths...")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Theme.textTertiary)
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            showFilters.toggle()
                        }
                    } label: {
                        Image(systemName: showFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                            .foregroundStyle(hasActiveFilters ? Theme.accent : Theme.textSecondary)
                    }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
            .safeAreaInset(edge: .top) {
                if showFilters {
                    filterBar
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    private var hasActiveFilters: Bool {
        selectedZone != nil || selectedCostFilter != nil
    }

    private var filterBar: some View {
        VStack(spacing: 10) {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    Text("AI Zone:")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.textTertiary)
                    ForEach(AIZone.allCases) { zone in
                        filterChip(zone.label, isActive: selectedZone == zone) {
                            withAnimation(.spring(duration: 0.3)) {
                                selectedZone = selectedZone == zone ? nil : zone
                            }
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)

            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    Text("Cost:")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.textTertiary)
                    ForEach(CostFilter.allCases) { cost in
                        filterChip(cost.label, isActive: selectedCostFilter == cost) {
                            withAnimation(.spring(duration: 0.3)) {
                                selectedCostFilter = selectedCostFilter == cost ? nil : cost
                            }
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)

            if hasActiveFilters {
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        selectedZone = nil
                        selectedCostFilter = nil
                    }
                } label: {
                    Text("Clear Filters")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    private func filterChip(_ title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(isActive ? .white : Theme.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isActive ? Theme.accent : Theme.cardBackground)
                .clipShape(.capsule)
                .overlay(
                    Capsule()
                        .stroke(isActive ? Color.clear : Theme.border, lineWidth: 0.5)
                )
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(Theme.textTertiary)
            Text("No matches found")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textSecondary)
            Text("Try adjusting your search or filters")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

struct SeeAllResultCard: View {
    let result: MatchResult
    let onTap: () -> Void
    @Environment(AppState.self) private var appState

    private var path: BusinessPath { result.businessPath }
    private var catColor: Color { Theme.categoryColor(for: path.category) }
    private var isSideHustle: Bool { path.categoryTier == .sideHustle }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSideHustle ? Theme.cardBackgroundLight : catColor.opacity(0.12))
                            .frame(width: 48, height: 48)
                        Image(systemName: path.icon)
                            .font(.body)
                            .foregroundStyle(isSideHustle ? Theme.textTertiary : catColor)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(path.name)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(isSideHustle ? Theme.textSecondary : Theme.textPrimary)
                            .lineLimit(1)

                        Text(cardSummary)
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 4)

                    aiProofBadge
                }

                credibilityTags
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSideHustle ? Theme.border.opacity(0.5) : catColor.opacity(0.12), lineWidth: 0.5)
            )
            .cardShadow()
            .opacity(isSideHustle ? 0.85 : 1)
        }
        .buttonStyle(.plain)
    }

    private var credibilityTags: some View {
        let tags = CredibilityTagBuilder.tags(for: path)
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(tags, id: \.label) { tag in
                    HStack(spacing: 4) {
                        Image(systemName: tag.icon)
                            .font(.system(size: 9))
                        Text(tag.label)
                            .font(.caption2.weight(.medium))
                    }
                    .foregroundStyle(isSideHustle ? Theme.textTertiary : tag.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(isSideHustle ? Theme.cardBackgroundLight : tag.color.opacity(0.08))
                    .clipShape(.capsule)
                }
            }
        }
        .allowsHitTesting(false)
    }

    private var cardSummary: String {
        if path.categoryTier == .highValue && path.requiresLicense {
            return "Licensed trade \u{00B7} \(path.startupCostRange)"
        } else if path.categoryTier == .highValue {
            return "High-value path \u{00B7} \(path.startupCostRange)"
        } else if path.categoryTier == .skilledTrade {
            return "Skilled trade \u{00B7} \(path.startupCostRange)"
        } else if path.categoryTier == .sideHustle {
            return "Side hustle \u{00B7} \(path.startupCostRange)"
        } else {
            return "\(path.timeToFirstDollar) \u{00B7} \(path.startupCostRange)"
        }
    }

    private var aiProofBadge: some View {
        let zone = path.zone
        let color: Color = zone == .safe ? Theme.accent : zone == .human ? Color(hex: "FBBF24") : .orange
        return HStack(spacing: 4) {
            Image(systemName: zone.icon)
                .font(.system(size: 10))
            Text("\(path.aiProofRating)")
                .font(.caption.weight(.bold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.12))
        .clipShape(.capsule)
    }
}

struct CredibilityTag {
    let label: String
    let icon: String
    let color: Color
}

enum CredibilityTagBuilder {
    static func tags(for path: BusinessPath) -> [CredibilityTag] {
        var tags: [CredibilityTag] = []

        if path.requiresLicense {
            tags.append(CredibilityTag(label: "Licensed", icon: "checkmark.seal.fill", color: Theme.accent))
        }

        if path.demandLevel == .high {
            tags.append(CredibilityTag(label: "High Demand", icon: "arrow.up.right", color: Theme.accentBlue))
        }

        if path.isFastStart {
            tags.append(CredibilityTag(label: "Fast Start", icon: "bolt.fill", color: Color(hex: "FB923C")))
        }

        if path.isScalable {
            tags.append(CredibilityTag(label: "Scalable", icon: "chart.line.uptrend.xyaxis", color: Color(hex: "818CF8")))
        }

        if path.requiresPhysicalWork {
            tags.append(CredibilityTag(label: "Hands-On", icon: "hand.raised.fill", color: Color(hex: "FBBF24")))
        }

        if path.isDigital && path.soloFriendly {
            tags.append(CredibilityTag(label: "Remote Friendly", icon: "laptopcomputer", color: Color(hex: "22D3EE")))
        }

        return Array(tags.prefix(4))
    }
}

nonisolated enum CostFilter: String, CaseIterable, Identifiable, Sendable {
    case free = "free"
    case under100 = "under100"
    case under500 = "under500"
    case any = "any"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .free: return "$0"
        case .under100: return "Under $100"
        case .under500: return "Under $500"
        case .any: return "$500+"
        }
    }

    func matches(_ path: BusinessPath) -> Bool {
        switch self {
        case .free: return path.minBudget == 0
        case .under100: return path.minBudget < 100
        case .under500: return path.minBudget < 500
        case .any: return path.minBudget >= 500
        }
    }
}
