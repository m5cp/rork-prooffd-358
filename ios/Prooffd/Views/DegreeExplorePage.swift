import SwiftUI

struct DegreeExplorePage: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var searchText: String = ""
    @State private var selectedCategory: DegreeCareerCategory?
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var visibleCategories: [DegreeCareerCategory] {
        DegreeCareerCategory.allCases.filter { cat in
            let count = recordCount(for: cat)
            return count > 0
        }
    }

    private func recordCount(for category: DegreeCareerCategory) -> Int {
        let all = DegreeCareerDatabase.allRecords.filter { $0.category == category && !appState.isDegreeHidden($0.id) }
        if searchText.isEmpty { return all.count }
        return all.filter { $0.title.localizedStandardContains(searchText) }.count
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
                            degreeCategoryCard(category)
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
        .navigationTitle("4-Year Degree Careers")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search degree careers...")
        .sheet(item: $selectedCategory) { category in
            DegreeCareerCategoryListSheet(category: category)
        }
    }

    private func degreeCategoryCard(_ category: DegreeCareerCategory) -> some View {
        let count = recordCount(for: category)
        let catColor = degreeCategoryColor(category)

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
