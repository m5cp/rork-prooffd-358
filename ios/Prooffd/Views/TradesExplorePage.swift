import SwiftUI

struct TradesExplorePage: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var searchText: String = ""
    @State private var selectedCategory: EducationCategory?
    @State private var selectedTopCareer: CareerPath?
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var topMatches: [EducationPath] {
        let all = EducationPathDatabase.all.filter { !appState.isEducationHidden($0.id) }
        let sorted = all.sorted { appState.educationScore(for: $0.id) > appState.educationScore(for: $1.id) }
        if searchText.isEmpty { return Array(sorted.prefix(3)) }
        return Array(sorted.filter { $0.title.localizedStandardContains(searchText) }.prefix(3))
    }

    private var visibleCategories: [EducationCategory] {
        EducationCategory.allCases.filter { cat in
            let count = pathCount(for: cat)
            return count > 0
        }
    }

    private func pathCount(for category: EducationCategory) -> Int {
        let all = EducationPathDatabase.all.filter { $0.category == category && !appState.isEducationHidden($0.id) }
        if searchText.isEmpty { return all.count }
        return all.filter { $0.title.localizedStandardContains(searchText) }.count
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
                                tradeCategoryCard(category)
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
        .navigationTitle("Trades & Certifications")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search programs...")
        .sheet(item: $selectedCategory) { category in
            EducationCategoryListSheet(category: category)
        }
        .sheet(item: $selectedTopCareer) { career in
            CareerPathDetailSheet(career: career)
        }
    }

    private var topMatchesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accentBlue)
                Text("YOUR TOP MATCHES")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(Theme.accentBlue)
                    .tracking(0.8)
                Spacer()
            }
            .padding(.horizontal, 16)

            ForEach(Array(topMatches.enumerated()), id: \.element.id) { index, path in
                topMatchCard(path, rank: index + 1)
            }
        }
        .padding(.bottom, 4)
    }

    private func topMatchCard(_ path: EducationPath, rank: Int) -> some View {
        let isTop = rank == 1
        let matchScore = appState.educationScore(for: path.id)
        let accentColor = Theme.accentBlue

        return Button {
            selectedTopCareer = path
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isTop ? accentColor : accentColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    if isTop {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Text("#\(rank)")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(accentColor)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(path.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(path.category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 4)

                HStack(spacing: 4) {
                    Image(systemName: "target")
                        .font(.system(size: 11, weight: .bold))
                    Text("\(matchScore)%")
                        .font(.subheadline.weight(.bold))
                        .monospacedDigit()
                }
                .foregroundStyle(matchScore >= 70 ? Theme.accent : matchScore >= 50 ? Color(hex: "FBBF24") : .secondary)

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(
                isTop
                    ? AnyShapeStyle(accentColor.opacity(0.06))
                    : AnyShapeStyle(Color(.secondarySystemGroupedBackground))
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isTop ? accentColor.opacity(0.3) : .clear, lineWidth: 1.5)
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

    private func tradeCategoryCard(_ category: EducationCategory) -> some View {
        let count = pathCount(for: category)
        let catColor = educationCategoryColor(category)

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
}
