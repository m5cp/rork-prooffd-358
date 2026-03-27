import SwiftUI

struct AnalyticsDashboardView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    private let analytics = AnalyticsTracker.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroStats
                    engagementGrid
                    weeklyActivityCard
                    socialProofPreview
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Engagement Data")
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

    private var heroStats: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Text("Key Metrics")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text("Local Data")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Theme.cardBackgroundLight)
                    .clipShape(.capsule)
            }

            HStack(spacing: 12) {
                metricCard(value: "\(analytics.totalAppOpens)", label: "App Opens", icon: "app.badge.fill", color: Theme.accent)
                metricCard(value: "\(analytics.uniqueDaysActive)", label: "Days Active", icon: "calendar", color: Theme.accentBlue)
            }

            HStack(spacing: 12) {
                metricCard(value: String(format: "%.0f%%", analytics.retentionRate), label: "Retention", icon: "arrow.counterclockwise", color: Color(hex: "FBBF24"))
                metricCard(value: String(format: "%.1f", analytics.averageActionsPerSession), label: "Actions/Session", icon: "bolt.fill", color: Color(hex: "818CF8"))
            }
        }
    }

    private func metricCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
                Spacer()
            }

            Text(value)
                .font(.title.weight(.bold))
                .foregroundStyle(Theme.textPrimary)

            Text(label)
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.1), lineWidth: 0.5)
        )
        .cardShadow()
    }

    private var engagementGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "person.fill.checkmark")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
                Text("User Engagement")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }

            VStack(spacing: 1) {
                engagementRow(label: "Quiz Completions", value: "\(analytics.quizCompletions)", icon: "checkmark.circle.fill", color: Theme.accent)
                engagementRow(label: "Paths Explored", value: "\(analytics.pathsExplored)", icon: "eye.fill", color: Color(hex: "818CF8"))
                engagementRow(label: "Builds Started", value: "\(analytics.buildsStarted)", icon: "hammer.fill", color: Theme.accentBlue)
                engagementRow(label: "Steps Completed", value: "\(analytics.stepsCompleted)", icon: "checkmark.square.fill", color: Theme.accent)
                engagementRow(label: "Shares", value: "\(analytics.sharesCount)", icon: "square.and.arrow.up.fill", color: Color(hex: "FB923C"))
                engagementRow(label: "Current Streak", value: "\(appState.streakTracker.currentStreak) days", icon: "flame.fill", color: .orange)
                engagementRow(label: "Total Points", value: "\(appState.momentum.totalPoints)", icon: "bolt.fill", color: Color(hex: "FBBF24"))
            }
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
    }

    private func engagementRow(label: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
                .frame(width: 20)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }

    private var weeklyActivityCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "calendar.badge.clock")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("Weekly Activity")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }

            VStack(spacing: 12) {
                HStack {
                    Text("Active days this week")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                    Text("\(analytics.weeklyActiveDays)/7")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Theme.cardBackgroundLight)
                            .frame(height: 8)
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Theme.accent, Theme.accentBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * Double(analytics.weeklyActiveDays) / 7.0, height: 8)
                    }
                }
                .frame(height: 8)

                HStack(spacing: 4) {
                    ForEach(weekDayLabels, id: \.self) { day in
                        Text(day)
                            .font(.system(size: 9))
                            .foregroundStyle(Theme.textTertiary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
    }

    private var weekDayLabels: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.veryShortWeekdaySymbols.map { $0 }
    }



    private var socialProofPreview: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "person.3.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Text("Social Proof Data")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Use these data points for your App Store listing and marketing:")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)

                proofRow(text: "\(analytics.totalAppOpens)+ app sessions")
                proofRow(text: "\(analytics.uniqueDaysActive) unique days of active use")
                proofRow(text: "\(appState.matchResults.count)+ career paths available")
                proofRow(text: "\(analytics.pathsExplored) paths explored by users")
                proofRow(text: String(format: "%.0f%%", analytics.retentionRate) + " user retention rate")

                if analytics.daysSinceFirstOpen > 0 {
                    proofRow(text: "\(analytics.daysSinceFirstOpen) days since launch")
                }
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
    }

    private func proofRow(text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption2)
                .foregroundStyle(Theme.accent)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Theme.textPrimary)
        }
    }
}
