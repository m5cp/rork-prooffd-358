import SwiftUI

struct PointsGuideView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    pointsSection
                    badgesSection
                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Earn Points & Badges")
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
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    private var pointsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "bolt.fill")
                    .font(.title3)
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("How to Earn Points")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
            }

            VStack(spacing: 0) {
                pointRow(action: "Complete Today's Step", points: "+10", icon: "checkmark.circle.fill", color: Theme.accent)
                pointDivider
                pointRow(action: "Complete a checklist item", points: "+5", icon: "checklist", color: Theme.accentBlue)
                pointDivider
                pointRow(action: "Edit your business plan", points: "+3", icon: "pencil", color: .orange)
                pointDivider
                pointRow(action: "Open the app daily", points: "+2", icon: "app.badge.fill", color: Color(hex: "818CF8"))
                pointDivider
                pointRow(action: "Share your progress", points: "+10", icon: "square.and.arrow.up", color: .pink)
            }
            .background(Theme.cardBackgroundLight)
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func pointRow(action: String, points: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(color)
                .frame(width: 28)
            Text(action)
                .font(.subheadline)
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            Text(points)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color(hex: "FBBF24"))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private var pointDivider: some View {
        Rectangle()
            .fill(Theme.cardBackground)
            .frame(height: 0.5)
            .padding(.leading, 54)
    }

    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "trophy.fill")
                    .font(.title3)
                    .foregroundStyle(Color(hex: "818CF8"))
                Text("Badges to Earn")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
            }

            ForEach(MomentumBadge.all, id: \.id) { badge in
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: badge.color).opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: badge.icon)
                            .font(.body)
                            .foregroundStyle(Color(hex: badge.color))
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(badge.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                        Text(badge.description)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }

                    Spacer()
                }
                .padding(.vertical, 4)
            }

            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("Keep building your streak and completing steps to unlock all badges. You'll see a celebration when you earn a new one!")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }
}
