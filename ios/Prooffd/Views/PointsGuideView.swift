import SwiftUI

struct PointsGuideView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    pointsSection
                    readinessSection
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

    private var readinessSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "gauge.open.with.lines.needle.33percent.and.arrowtriangle")
                    .font(.title3)
                    .foregroundStyle(Theme.accent)
                Text("How to Increase Readiness")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
            }

            Text("Your readiness score has two parts: your profile (up to 50) and your actions (up to 50).")
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(2)

            VStack(alignment: .leading, spacing: 10) {
                Text("Profile (up to 50 pts)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accent)
                Text("Complete the quiz fully \u{2014} answer every question. The more detail you provide, the higher your profile score.")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)
            }

            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

            VStack(alignment: .leading, spacing: 6) {
                Text("Actions (up to 50 pts)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accentBlue)
            }

            VStack(spacing: 0) {
                readinessRow(action: "Complete the quiz", points: "+5", icon: "checkmark.circle.fill", color: Theme.accent)
                pointDivider
                readinessRow(action: "Explore 5 paths", points: "+5", icon: "eye.fill", color: Color(hex: "818CF8"))
                pointDivider
                readinessRow(action: "Explore 10 paths", points: "+5", icon: "eye.circle.fill", color: Color(hex: "818CF8"))
                pointDivider
                readinessRow(action: "Save 3 favorites", points: "+3", icon: "heart.fill", color: .pink)
                pointDivider
                readinessRow(action: "Start a build", points: "+5", icon: "hammer.fill", color: Theme.accentBlue)
                pointDivider
                readinessRow(action: "Complete 5 checklist steps", points: "+5", icon: "checklist", color: Theme.accent)
                pointDivider
                readinessRow(action: "Complete 10 checklist steps", points: "+5", icon: "checklist.checked", color: Theme.accent)
                pointDivider
                readinessRow(action: "Try What If mode", points: "+3", icon: "slider.horizontal.3", color: .orange)
                pointDivider
                readinessRow(action: "Share your progress", points: "+3", icon: "square.and.arrow.up", color: .pink)
                pointDivider
                readinessRow(action: "3-day streak", points: "+3", icon: "flame.fill", color: .orange)
                pointDivider
                readinessRow(action: "7-day streak", points: "+3", icon: "flame.circle.fill", color: .red)
                pointDivider
                readinessRow(action: "Edit your business plan", points: "+2", icon: "pencil", color: .orange)
                pointDivider
                readinessRow(action: "Complete a weekly challenge", points: "+3", icon: "calendar.badge.clock", color: Theme.accentBlue)
            }
            .background(Theme.cardBackgroundLight)
            .clipShape(.rect(cornerRadius: 12))

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                Text("The more you engage with the app \u{2014} exploring paths, building plans, maintaining streaks \u{2014} the higher your readiness climbs.")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func readinessRow(action: String, points: String, icon: String, color: Color) -> some View {
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
                .foregroundStyle(Theme.accent)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
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
