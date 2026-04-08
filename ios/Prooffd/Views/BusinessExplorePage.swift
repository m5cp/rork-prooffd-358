import SwiftUI

struct BusinessExplorePage: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var searchText: String = ""
    @State private var selectedCategory: BusinessCategory?
    @State private var selectedTopMatch: MatchResult?
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var allResults: [MatchResult] { appState.matchResults }

    private var topMatches: [MatchResult] {
        let sorted = allResults
            .filter { !appState.isPathHidden($0.businessPath.id) }
            .sorted { $0.scorePercentage > $1.scorePercentage }
        if searchText.isEmpty { return Array(sorted.prefix(3)) }
        let q = searchText
        return Array(sorted.filter {
            $0.businessPath.name.localizedStandardContains(q) ||
            $0.businessPath.overview.localizedStandardContains(q)
        }.prefix(3))
    }

    private var visibleCategories: [BusinessCategory] {
        BusinessCategory.allCases.filter { cat in
            let count = resultCount(for: cat)
            return count > 0
        }
    }

    private func resultCount(for category: BusinessCategory) -> Int {
        let items = allResults.filter { $0.businessPath.category == category && !appState.isPathHidden($0.businessPath.id) }
        if searchText.isEmpty { return items.count }
        let q = searchText
        return items.filter {
            $0.businessPath.name.localizedStandardContains(q) ||
            $0.businessPath.overview.localizedStandardContains(q)
        }.count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if !topMatches.isEmpty && appState.hasCompletedQuiz {
                    topMatchesSection
                }

                if visibleCategories.isEmpty && topMatches.isEmpty {
                    emptyState
                } else {
                    if !visibleCategories.isEmpty {
                        categoriesHeader

                        let columns = sizeClass == .regular
                            ? [GridItem(.adaptive(minimum: 160), spacing: 12)]
                            : [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(visibleCategories) { category in
                                businessCategoryCard(category)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Start a Business")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search businesses...")
        .sheet(item: $selectedCategory) { category in
            BusinessCategoryListSheet(category: category)
        }
        .sheet(item: $selectedTopMatch) { result in
            PathDetailView(result: result)
        }
    }

    private var topMatchesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accent)
                Text("YOUR TOP MATCHES")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(Theme.accent)
                    .tracking(0.8)
                Spacer()
            }
            .padding(.horizontal, 16)

            ForEach(Array(topMatches.enumerated()), id: \.element.id) { index, match in
                topMatchCard(match, rank: index + 1)
            }
        }
        .padding(.bottom, 4)
    }

    private func topMatchCard(_ match: MatchResult, rank: Int) -> some View {
        let isTop = rank == 1
        let catColor = Theme.categoryColor(for: match.businessPath.category)

        return Button {
            selectedTopMatch = match
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isTop ? Theme.accent : Theme.accent.opacity(0.15))
                        .frame(width: 44, height: 44)
                    if isTop {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Text("#\(rank)")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(Theme.accent)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(match.businessPath.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(match.businessPath.category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 4)

                HStack(spacing: 4) {
                    Image(systemName: "target")
                        .font(.system(size: 11, weight: .bold))
                    Text("\(match.scorePercentage)%")
                        .font(.subheadline.weight(.bold))
                        .monospacedDigit()
                }
                .foregroundStyle(match.scorePercentage >= 70 ? Theme.accent : match.scorePercentage >= 50 ? Color(hex: "FBBF24") : .secondary)

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(
                isTop
                    ? AnyShapeStyle(Theme.accent.opacity(0.06))
                    : AnyShapeStyle(Color(.secondarySystemGroupedBackground))
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isTop ? Theme.accent.opacity(0.3) : .clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private var categoriesHeader: some View {
        HStack {
            Text("EXPLORE CATEGORIES")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.secondary)
                .tracking(0.8)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func businessCategoryCard(_ category: BusinessCategory) -> some View {
        let count = resultCount(for: category)
        let catColor = Theme.categoryColor(for: category)

        return Button {
            selectedCategory = category
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(catColor.opacity(0.12))
                            .frame(width: 40, height: 40)
                        Image(systemName: category.icon)
                            .font(.body)
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
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selectedCategory)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.title)
                .foregroundStyle(.tertiary)
            Text("No results for \"\(searchText)\"")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}
