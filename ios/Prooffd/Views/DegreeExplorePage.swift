import SwiftUI

struct DegreeExplorePage: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var searchText: String = ""
    @State private var selectedCategory: DegreeCareerCategory?
    @State private var selectedTopRecord: DegreeCareerRecord?
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var topMatches: [DegreeCareerRecord] {
        let all = DegreeCareerDatabase.allRecords.filter { !appState.isDegreeHidden($0.id) }
        let sorted = all.sorted { appState.degreeScore(for: $0.id) > appState.degreeScore(for: $1.id) }
        if searchText.isEmpty { return Array(sorted.prefix(3)) }
        return Array(sorted.filter { $0.title.localizedStandardContains(searchText) }.prefix(3))
    }

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
                                degreeCategoryCard(category)
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
        .navigationTitle("Advanced Education Careers")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search degree careers...")
        .sheet(item: $selectedCategory) { category in
            DegreeCareerCategoryListSheet(category: category)
        }
        .sheet(item: $selectedTopRecord) { record in
            DegreeCareerDetailSheet(record: record)
        }
    }

    private let degreeAccent = Color(hex: "818CF8")

    private var topMatchesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(degreeAccent)
                Text("YOUR TOP MATCHES")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(degreeAccent)
                    .tracking(0.8)
                Spacer()
            }
            .padding(.horizontal, 16)

            ForEach(Array(topMatches.enumerated()), id: \.element.id) { index, record in
                topMatchCard(record, rank: index + 1)
            }
        }
        .padding(.bottom, 4)
    }

    private func topMatchCard(_ record: DegreeCareerRecord, rank: Int) -> some View {
        let isTop = rank == 1
        let matchScore = appState.degreeScore(for: record.id)

        return Button {
            selectedTopRecord = record
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isTop ? degreeAccent : degreeAccent.opacity(0.15))
                        .frame(width: 44, height: 44)
                    if isTop {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Text("#\(rank)")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(degreeAccent)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(record.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(record.category.rawValue)
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
                    ? AnyShapeStyle(degreeAccent.opacity(0.06))
                    : AnyShapeStyle(Color(.secondarySystemGroupedBackground))
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isTop ? degreeAccent.opacity(0.3) : .clear, lineWidth: 1.5)
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
