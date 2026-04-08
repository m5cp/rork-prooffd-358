import SwiftUI

struct DegreeCareerCategoryListSheet: View {
    let category: DegreeCareerCategory
    @Environment(StoreViewModel.self) private var store
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRecord: DegreeCareerRecord?

    private var records: [DegreeCareerRecord] {
        DegreeCareerDatabase.allRecords
            .filter { $0.category == category && !appState.isDegreeHidden($0.id) }
            .sorted { appState.degreeScore(for: $0.id) > appState.degreeScore(for: $1.id) }
    }

    private var catColor: Color {
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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    if records.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "graduationcap")
                                .font(.title2)
                                .foregroundStyle(Theme.textTertiary)
                            Text("No careers in this category")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textTertiary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(records) { record in
                                degreeRecordCard(record)
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
            .sheet(item: $selectedRecord) { record in
                DegreeCareerDetailSheet(record: record)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    private func degreeRecordCard(_ record: DegreeCareerRecord) -> some View {
        let tierColor: Color = record.aiProofTier == .tier1 ? Theme.accent : record.aiProofTier == .tier2 ? Color(hex: "FBBF24") : .orange
        let isFav = appState.isDegreeFavorite(record.id)

        return Button {
            selectedRecord = record
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(catColor.opacity(0.1))
                            .frame(width: 48, height: 48)
                        Image(systemName: record.icon)
                            .font(.body)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text(record.title)
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
                                Text(record.salaryExperienced)
                                    .font(.caption2)
                            }
                            .foregroundStyle(Theme.accent)

                            HStack(spacing: 3) {
                                Image(systemName: "clock")
                                    .font(.system(size: 9))
                                Text(record.timeline)
                                    .font(.caption2)
                            }
                            .foregroundStyle(Theme.textTertiary)
                        }
                    }

                    Spacer(minLength: 4)

                    VStack(alignment: .trailing, spacing: 4) {
                        let matchScore = appState.degreeScore(for: record.id)
                        let matchColor: Color = matchScore >= 70 ? Theme.accent : matchScore >= 50 ? Color(hex: "FBBF24") : Theme.textTertiary
                        HStack(spacing: 3) {
                            Image(systemName: "target")
                                .font(.system(size: 9))
                            Text("\(matchScore)%")
                                .font(.caption2.weight(.bold))
                        }
                        .foregroundStyle(matchColor)

                        Image(systemName: "chevron.right")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                HStack(spacing: 6) {
                    Image(systemName: "graduationcap")
                        .font(.system(size: 9))
                    Text(record.degreeRequired)
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
}
