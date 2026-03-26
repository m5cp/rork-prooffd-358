import SwiftUI

struct AchievementsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    private var momentumBadges: [(badge: MomentumBadge, earned: Bool)] {
        MomentumBadge.all.map { ($0, appState.momentum.hasBadge($0.id)) }
    }

    private var achievements: [(achievement: Achievement, unlocked: Bool)] {
        AchievementDatabase.all.map { ($0, appState.isAchievementUnlocked($0.id)) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    summaryHeader
                    streakCard
                    badgesSection
                    achievementsSection
                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
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

    private var summaryHeader: some View {
        HStack(spacing: 0) {
            summaryItem(
                icon: "flame.fill",
                color: .orange,
                value: "\(appState.streakTracker.currentStreak)",
                label: "Day Streak"
            )

            Rectangle().fill(Theme.border).frame(width: 1, height: 44)

            summaryItem(
                icon: "bolt.fill",
                color: Color(hex: "FBBF24"),
                value: "\(appState.momentum.totalPoints)",
                label: "Points"
            )

            Rectangle().fill(Theme.border).frame(width: 1, height: 44)

            let earnedCount = momentumBadges.filter(\.earned).count + achievements.filter(\.unlocked).count
            let totalCount = momentumBadges.count + achievements.count
            summaryItem(
                icon: "trophy.fill",
                color: Color(hex: "818CF8"),
                value: "\(earnedCount)/\(totalCount)",
                label: "Unlocked"
            )
        }
        .padding(.vertical, 20)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .cardShadow()
    }

    private func summaryItem(icon: String, color: Color, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(color)
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.textPrimary)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }

    private var streakCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text(appState.streakTracker.currentStreak > 0
                        ? "\(appState.streakTracker.currentStreak) Day Streak"
                        : "No Active Streak")
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                    Text(appState.streakTracker.streakMessage)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer()
            }

            HStack(spacing: 16) {
                miniStat(label: "Current", value: "\(appState.streakTracker.currentStreak)")
                miniStat(label: "Longest", value: "\(appState.streakTracker.longestStreak)")
                miniStat(label: "Total Days", value: "\(appState.streakTracker.totalDaysOpened)")
            }
        }
        .padding(16)
        .tintedCard(.orange)
    }

    private func miniStat(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.textPrimary)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Theme.cardBackgroundLight.opacity(0.5))
        .clipShape(.rect(cornerRadius: 8))
    }

    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "medal.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("Momentum Badges")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(momentumBadges, id: \.badge.id) { item in
                    badgeCard(item.badge, earned: item.earned)
                }
            }
        }
    }

    private func badgeCard(_ badge: MomentumBadge, earned: Bool) -> some View {
        let color = Color(hex: badge.color)
        return VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(earned ? color.opacity(0.15) : Theme.cardBackgroundLight)
                    .frame(width: 52, height: 52)
                Image(systemName: badge.icon)
                    .font(.title3)
                    .foregroundStyle(earned ? color : Theme.textTertiary.opacity(0.4))
            }

            Text(badge.title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(earned ? Theme.textPrimary : Theme.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text(badge.description)
                .font(.system(size: 10))
                .foregroundStyle(Theme.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background(earned ? color.opacity(0.04) : Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(earned ? color.opacity(0.2) : Theme.border.opacity(0.3), lineWidth: 1)
        )
        .opacity(earned ? 1 : 0.6)
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "star.circle.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
                Text("Achievements")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }

            LazyVStack(spacing: 10) {
                ForEach(achievements, id: \.achievement.id) { item in
                    achievementRow(item.achievement, unlocked: item.unlocked)
                }
            }
        }
    }

    private func achievementRow(_ achievement: Achievement, unlocked: Bool) -> some View {
        let color = Color(hex: achievement.color)
        return HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(unlocked ? color.opacity(0.15) : Theme.cardBackgroundLight)
                    .frame(width: 44, height: 44)
                Image(systemName: achievement.icon)
                    .font(.body)
                    .foregroundStyle(unlocked ? color : Theme.textTertiary.opacity(0.4))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(achievement.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(unlocked ? Theme.textPrimary : Theme.textTertiary)
                Text(achievement.description)
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }

            Spacer()

            if unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.body)
                    .foregroundStyle(color)
            } else {
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary.opacity(0.4))
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(unlocked ? color.opacity(0.15) : Theme.border.opacity(0.2), lineWidth: 0.5)
        )
        .opacity(unlocked ? 1 : 0.65)
    }
}
