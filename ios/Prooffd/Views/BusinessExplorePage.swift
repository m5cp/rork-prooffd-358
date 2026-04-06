import SwiftUI

struct BusinessExplorePage: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var searchText: String = ""
    @State private var selectedCategory: BusinessCategory?
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var allResults: [MatchResult] { appState.matchResults }

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
                if visibleCategories.isEmpty {
                    emptyState
                } else {
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
