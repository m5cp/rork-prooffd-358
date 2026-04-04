import SwiftUI

struct TradesExplorePage: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedCareer: CareerPath?
    @State private var searchText: String = ""
    @State private var filterMode: ExploreFilterMode = .all

    private func pathsForCategory(_ category: EducationCategory) -> [EducationPath] {
        let all = EducationPathDatabase.all.filter { $0.category == category }
        switch filterMode {
        case .all: return all.filter { !appState.isEducationHidden($0.id) }
        case .favorites: return all.filter { appState.isEducationFavorite($0.id) }
        case .hidden: return all.filter { appState.isEducationHidden($0.id) }
        }
    }

    private var visibleCategories: [EducationCategory] {
        EducationCategory.allCases.filter { cat in
            let paths = pathsForCategory(cat)
            if searchText.isEmpty { return !paths.isEmpty }
            return paths.contains { $0.title.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                filterBar
                    .padding(.horizontal, 4)

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
        .navigationTitle("Trades & Certifications")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search programs...")
        .sheet(item: $selectedCareer) { career in
            CareerPathDetailSheet(career: career)
        }
    }

    private var filterBar: some View {
        HStack(spacing: 8) {
            ForEach(ExploreFilterMode.allCases) { mode in
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        filterMode = mode
                    }
                } label: {
                    Text(mode.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(filterMode == mode ? .white : .secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(filterMode == mode ? Theme.accentBlue : Color(.secondarySystemGroupedBackground))
                        .clipShape(.capsule)
                }
            }
            Spacer()
        }
    }

    private func categorySection(_ cat: EducationCategory) -> some View {
        let catColor = educationCategoryColor(cat)
        var paths = pathsForCategory(cat)
        if !searchText.isEmpty {
            paths = paths.filter { $0.title.localizedStandardContains(searchText) }
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

                Text("\(paths.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)
            .padding(.top, 8)

            ForEach(paths) { path in
                pathCard(path, color: catColor)
            }
        }
    }

    private func pathCard(_ path: EducationPath, color: Color) -> some View {
        let aiColor: Color = path.aiSafeScore >= 80 ? Theme.accent : path.aiSafeScore >= 50 ? Color(hex: "FBBF24") : .orange
        let isFav = appState.isEducationFavorite(path.id)

        return Button {
            selectedCareer = path
        } label: {
            HStack(spacing: 14) {
                Image(systemName: path.icon)
                    .font(.body)
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(path.title)
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
                        Text(path.typicalSalaryRange)
                            .font(.caption2)
                            .foregroundStyle(Theme.accent)

                        Text("·")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)

                        Text(path.timeToComplete)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer(minLength: 4)

                HStack(spacing: 4) {
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 10))
                    Text("\(path.aiSafeScore)")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(aiColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(aiColor.opacity(0.1))
                .clipShape(.capsule)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                appState.toggleEducationFavorite(path.id)
            } label: {
                Label(isFav ? "Unfavorite" : "Favorite", systemImage: isFav ? "heart.slash.fill" : "heart.fill")
            }
            Button(role: appState.isEducationHidden(path.id) ? nil : .destructive) {
                appState.toggleHiddenEducation(path.id)
            } label: {
                Label(appState.isEducationHidden(path.id) ? "Unhide" : "Hide", systemImage: appState.isEducationHidden(path.id) ? "eye.fill" : "eye.slash.fill")
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: filterMode == .favorites ? "heart" : filterMode == .hidden ? "eye.slash" : "magnifyingglass")
                .font(.title)
                .foregroundStyle(.tertiary)
            Text(filterMode == .favorites ? "No favorites yet" : filterMode == .hidden ? "No hidden programs" : "No results for \"\(searchText)\"")
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
