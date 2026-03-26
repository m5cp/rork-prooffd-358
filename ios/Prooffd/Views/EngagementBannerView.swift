import SwiftUI

struct EngagementBannerView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        HStack(spacing: 0) {
            streakPill
            Spacer(minLength: 8)
            pointsPill
            Spacer(minLength: 8)
            badgesPill
        }
        .padding(12)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
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
        }
    }

    private var badgesPill: some View {
        let earned = appState.momentum.earnedBadges.count
        let total = MomentumBadge.all.count
        return HStack(spacing: 6) {
            Image(systemName: "trophy.fill")
                .font(.caption)
                .foregroundStyle(earned > 0 ? Color(hex: "818CF8") : Theme.textTertiary)
            VStack(alignment: .leading, spacing: 1) {
                Text("\(earned)/\(total)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("badges")
                    .font(.system(size: 10))
                    .foregroundStyle(Theme.textTertiary)
            }
        }
    }
}
