import SwiftUI

struct EducationCategoryListSheet: View {
    let category: EducationCategory
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCareer: CareerPath?

    private var paths: [EducationPath] {
        EducationPathDatabase.all.filter { $0.category == category }
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
                LazyVStack(spacing: 10) {
                    ForEach(paths) { path in
                        pathCard(path)
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

    private func pathCard(_ path: EducationPath) -> some View {
        let aiColor: Color = path.aiSafeScore >= 80 ? Theme.accent : path.aiSafeScore >= 50 ? Color(hex: "FBBF24") : .orange

        return Button {
            selectedCareer = path
        } label: {
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
                    Text(path.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)

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
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
        .buttonStyle(.plain)
    }
}
