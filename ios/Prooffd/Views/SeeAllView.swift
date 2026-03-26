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

    private var catColor: Color {
        Theme.categoryColor(for: result.businessPath.category)
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(catColor.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: result.businessPath.icon)
                        .font(.body)
                        .foregroundStyle(catColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(result.businessPath.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        HStack(spacing: 3) {
                            Image(systemName: "shield.checkered")
                                .font(.system(size: 9))
                            Text("\(result.businessPath.aiProofRating)")
                                .font(.caption2.weight(.bold))
                        }
                        .foregroundStyle(aiColor)

                        Text(result.businessPath.startupCostRange)
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)

                        Text(result.businessPath.timeToFirstDollar)
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                Spacer(minLength: 4)

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(result.scorePercentage)%")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(matchColor)
                    Text("match")
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    private var matchColor: Color {
        if result.scorePercentage >= 80 { return Theme.accent }
        if result.scorePercentage >= 60 { return Theme.accentBlue }
        return Color(hex: "FB923C")
    }

    private var aiColor: Color {
        let r = result.businessPath.aiProofRating
        if r >= 80 { return Theme.accent }
        if r >= 50 { return Color(hex: "FBBF24") }
        return .orange
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
