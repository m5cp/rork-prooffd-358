import SwiftUI

struct DegreeExplorePage: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedRecord: DegreeCareerRecord?
    @State private var searchText: String = ""

    private var visibleCategories: [DegreeCareerCategory] {
        DegreeCareerCategory.allCases.filter { cat in
            let records = recordsForCategory(cat)
            if searchText.isEmpty { return !records.isEmpty }
            return records.contains { $0.title.localizedStandardContains(searchText) }
        }
    }

    private func recordsForCategory(_ cat: DegreeCareerCategory) -> [DegreeCareerRecord] {
        DegreeCareerDatabase.allRecords.filter { $0.category == cat && !appState.isDegreeHidden($0.id) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                LazyVStack(spacing: 8) {
                    ForEach(visibleCategories) { cat in
                        categorySection(cat)
                    }
                }

                if visibleCategories.isEmpty {
                    emptyState
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("4-Year Degree Careers")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search degree careers...")
        .sheet(item: $selectedRecord) { record in
            DegreeCareerDetailSheet(record: record)
        }
    }

    private func categorySection(_ cat: DegreeCareerCategory) -> some View {
        let catColor = degreeCategoryColor(cat)
        var records = recordsForCategory(cat)
        if !searchText.isEmpty {
            records = records.filter { $0.title.localizedStandardContains(searchText) }
        }

        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: cat.icon)
                    .font(.subheadline)
                    .foregroundStyle(catColor)
                    .frame(width: 32, height: 32)
                    .background(catColor.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 8))

                Text(cat.rawValue)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(records.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)
            .padding(.top, 8)

            ForEach(records) { record in
                degreeCard(record, color: catColor)
            }
        }
    }

    private func degreeCard(_ record: DegreeCareerRecord, color: Color) -> some View {
        let tierColor: Color = record.aiProofTier == .tier1 ? Theme.accent : record.aiProofTier == .tier2 ? Color(hex: "FBBF24") : .orange
        let isFav = appState.isDegreeFavorite(record.id)

        return Button {
            selectedRecord = record
        } label: {
            HStack(spacing: 14) {
                Image(systemName: record.icon)
                    .font(.body)
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(record.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        if isFav {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(.pink)
                        }
                    }

                    HStack(spacing: 8) {
                        Text(record.salaryExperienced)
                            .font(.caption2)
                            .foregroundStyle(Theme.accent)

                        Text("·")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)

                        Text(record.timeline)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer(minLength: 4)

                HStack(spacing: 4) {
                    Image(systemName: record.aiProofTier.icon)
                        .font(.system(size: 10))
                    Text(record.aiProofTier == .tier1 ? "T1" : record.aiProofTier == .tier2 ? "T2" : "T3")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(tierColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(tierColor.opacity(0.1))
                .clipShape(.capsule)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                appState.toggleDegreeFavorite(record.id)
            } label: {
                Label(isFav ? "Unfavorite" : "Favorite", systemImage: isFav ? "heart.slash.fill" : "heart.fill")
            }
            Button(role: .destructive) {
                appState.toggleHiddenDegree(record.id)
            } label: {
                Label("Hide", systemImage: "eye.slash.fill")
            }
        }
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
