import SwiftUI

struct EngagementBannerView: View {
    @Environment(AppState.self) private var appState
    @State private var showPointsInfo: Bool = false

    private var totalEarned: Int {
        appState.momentum.earnedBadges.count + appState.unlockedCount
    }

    private var totalAvailable: Int {
        MomentumBadge.all.count + AchievementDatabase.all.count
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                levelPill
                Spacer(minLength: 8)
                streakPill
                Spacer(minLength: 8)
                pointsPill
            }
            .padding(12)

            if showPointsInfo {
                pointsDescriptionSection
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private var levelPill: some View {
        let level = appState.currentLevel
        let levelColor = Color(hex: level.color)
        return HStack(spacing: 6) {
            Image(systemName: level.icon)
                .font(.caption)
                .foregroundStyle(levelColor)
            VStack(alignment: .leading, spacing: 1) {
                Text(level.title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(levelColor)
                Text("Lv \(level.rank)")
                    .font(.system(size: 10))
                    .foregroundStyle(Theme.textTertiary)
            }
        }
    }

    private var streakPill: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.caption)
                .foregroundStyle(appState.streakTracker.currentStreak > 0 ? .orange : Theme.textTertiary)
            VStack(alignment: .leading, spacing: 1) {
                Text("\(appState.streakTracker.currentStreak)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(appState.streakTracker.currentStreak > 0 ? Theme.textPrimary : Theme.textTertiary)
                Text("day streak")
                    .font(.system(size: 10))
                    .foregroundStyle(Theme.textTertiary)
            }
        }
    }

    private var pointsPill: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                showPointsInfo.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "bolt.fill")
                    .font(.caption)
                    .foregroundStyle(Color(hex: "FBBF24"))
                VStack(alignment: .leading, spacing: 1) {
                    Text("\(appState.momentum.totalPoints)")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("points")
                        .font(.system(size: 10))
                        .foregroundStyle(Theme.textTertiary)
                }
                Image(systemName: "info.circle")
                    .font(.system(size: 9))
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .buttonStyle(.plain)
    }

    private var badgesPill: some View {
        HStack(spacing: 6) {
            Image(systemName: "trophy.fill")
                .font(.caption)
                .foregroundStyle(totalEarned > 0 ? Color(hex: "818CF8") : Theme.textTertiary)
            VStack(alignment: .leading, spacing: 1) {
                Text("\(totalEarned)/\(totalAvailable)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("badges")
                    .font(.system(size: 10))
                    .foregroundStyle(Theme.textTertiary)
            }
        }
    }

    private var pointsDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(Theme.border.opacity(0.3))
                .frame(height: 0.5)
                .padding(.horizontal, 12)

            VStack(alignment: .leading, spacing: 6) {
                Text("How to Earn Points")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)

                pointRow(icon: "checkmark.circle.fill", text: "Complete Today's Step", points: "+10")
                pointRow(icon: "checklist", text: "Complete a checklist item", points: "+5")
                pointRow(icon: "pencil.line", text: "Edit your plan", points: "+3")
                pointRow(icon: "app.badge.fill", text: "Open app daily", points: "+2")
                pointRow(icon: "square.and.arrow.up", text: "Share your progress", points: "+10")
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 12)
        }
    }

    private func pointRow(icon: String, text: String, points: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: "FBBF24"))
                .frame(width: 16)
            Text(text)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
            Spacer()
            Text(points)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color(hex: "FBBF24"))
        }
    }
}
