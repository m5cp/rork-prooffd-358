import SwiftUI

struct EducationCategoryListSheet: View {
    let category: EducationCategory
    @Environment(StoreViewModel.self) private var store
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCareer: CareerPath?
    @State private var filterMode: ExploreFilterMode = .all

    private var paths: [EducationPath] {
        let all = EducationPathDatabase.all.filter { $0.category == category }
        switch filterMode {
        case .all: return all.filter { !appState.isEducationHidden($0.id) }
        case .favorites: return all.filter { appState.isEducationFavorite($0.id) }
        case .hidden: return all.filter { appState.isEducationHidden($0.id) }
        }
    }

    private var catColor: Color {
        switch category {
        case .trade: return Theme.accent
        case .certification: return Color(hex: "FBBF24")
        case .healthcare: return Color(hex: "F472B6")
        case .technology: return Theme.accentBlue
        case .business: return Color(hex: "FB923C")
        case .creative: return Color(hex: "818CF8")
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    filterBar

                    if paths.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: filterMode == .favorites ? "heart" : "eye.slash")
                                .font(.title2)
                                .foregroundStyle(Theme.textTertiary)
                            Text(filterMode == .favorites ? "No favorites in this category" : "No hidden programs here")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textTertiary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(paths) { path in
                                pathCard(path)
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
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Theme.textTertiary)
                            .font(.title3)
                    }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(item: $selectedCareer) { career in
                CareerPathDetailSheet(career: career)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
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
                        .foregroundStyle(filterMode == mode ? .white : Theme.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(filterMode == mode ? catColor : Theme.cardBackground)
                        .clipShape(.capsule)
                }
            }
            Spacer()
        }
    }

    private func pathCard(_ path: EducationPath) -> some View {
        let aiColor: Color = path.aiSafeScore >= 80 ? Theme.accent : path.aiSafeScore >= 50 ? Color(hex: "FBBF24") : .orange
        let isFav = appState.isEducationFavorite(path.id)
        let isHid = appState.isEducationHidden(path.id)

        return Button {
            selectedCareer = path
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(catColor.opacity(0.1))
                            .frame(width: 48, height: 48)
                        Image(systemName: path.icon)
                            .font(.body)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text(path.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                                .lineLimit(1)
                            if isFav {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.pink)
                            }
                        }

                        HStack(spacing: 10) {
                            HStack(spacing: 3) {
                                Image(systemName: "dollarsign.circle")
                                    .font(.system(size: 9))
                                Text(path.typicalSalaryRange)
                                    .font(.caption2)
                            }
                            .foregroundStyle(Theme.accent)

                            HStack(spacing: 3) {
                                Image(systemName: "clock")
                                    .font(.system(size: 9))
                                Text(path.timeToComplete)
                                    .font(.caption2)
                            }
                            .foregroundStyle(Theme.textTertiary)
                        }
                    }

                    Spacer(minLength: 4)

                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 3) {
                            Image(systemName: "shield.checkered")
                                .font(.system(size: 9))
                            Text("\(path.aiSafeScore)")
                                .font(.caption2.weight(.bold))
                        }
                        .foregroundStyle(aiColor)

                        Image(systemName: "chevron.right")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                HStack(spacing: 6) {
                    Image(systemName: deliveryIcon(for: path.deliveryType))
                        .font(.system(size: 9))
                    Text(path.deliveryType)
                        .font(.caption2.weight(.medium))
                }
                .foregroundStyle(Theme.accentBlue)
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 62)
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                appState.toggleEducationFavorite(path.id)
            } label: {
                Label(isFav ? "Unfavorite" : "Favorite", systemImage: isFav ? "heart.slash.fill" : "heart.fill")
            }
            Button(role: isHid ? nil : .destructive) {
                appState.toggleHiddenEducation(path.id)
            } label: {
                Label(isHid ? "Unhide" : "Hide", systemImage: isHid ? "eye.fill" : "eye.slash.fill")
            }
        }
    }

    private func deliveryIcon(for type: String) -> String {
        let dt = type.lowercased()
        if dt.contains("online") && (dt.contains("person") || dt.contains("hybrid")) { return "laptopcomputer.and.arrow.down" }
        if dt.contains("online") || dt.contains("remote") || dt.contains("self-taught") { return "laptopcomputer" }
        if dt.contains("hybrid") { return "building.2" }
        return "mappin.and.ellipse"
    }
}
