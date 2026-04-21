import SwiftUI

struct WeeklySummaryCard: View {
    @Environment(AppState.self) private var appState
    @Binding var isVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "calendar.badge.checkmark")
                    .font(.headline)
                    .foregroundStyle(Theme.accent)
                Text("Weekly Summary")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.textTertiary)
                        .padding(8)
                        .background(Theme.cardBackgroundLight, in: Circle())
                }
                .accessibilityLabel("Dismiss weekly summary")
                .frame(minWidth: 44, minHeight: 44)
            }

            HStack(spacing: 12) {
                summaryStat(icon: "flame.fill", value: "\(appState.streakTracker.currentStreak)", label: "Streak", color: .orange)
                summaryStat(icon: "hammer.fill", value: "\(appState.builds.count)", label: "Builds", color: Theme.accentBlue)
                summaryStat(icon: "bolt.fill", value: "\(appState.momentum.totalPoints)", label: "Points", color: Color(hex: "FBBF24"))
            }

            Text(encouragement)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                appState.selectedTab = 1
                dismiss()
            } label: {
                HStack(spacing: 6) {
                    Text("Plan this week")
                        .font(.subheadline.weight(.semibold))
                    Image(systemName: "arrow.right")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(colors: [Theme.accent, Theme.accent.opacity(0.85)],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(.capsule)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Theme.accent.opacity(0.08), Theme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
        )
    }

    private var encouragement: String {
        let streak = appState.streakTracker.currentStreak
        if streak >= 7 { return "Strong week! Keep the chain unbroken and push your plan forward." }
        if streak >= 3 { return "You're building momentum. A couple of micro-actions keeps it going." }
        return "Fresh week, fresh start. One small step today beats a perfect plan tomorrow."
    }

    private func summaryStat(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(color)
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.textPrimary)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.03))
        .clipShape(.rect(cornerRadius: 10))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }

    private func dismiss() {
        WeeklySummaryScheduler.dismiss()
        withAnimation(.spring(duration: 0.35)) { isVisible = false }
    }
}

enum WeeklySummaryScheduler {
    private static let dismissedWeekKey = "weeklySummary_dismissedWeek"

    static var shouldShow: Bool {
        let cal = Calendar(identifier: .iso8601)
        let today = Date()
        guard cal.component(.weekday, from: today) == 2 else { return false }
        let dismissedWeek = UserDefaults.standard.string(forKey: dismissedWeekKey) ?? ""
        return dismissedWeek != currentWeekKey()
    }

    static func dismiss() {
        UserDefaults.standard.set(currentWeekKey(), forKey: dismissedWeekKey)
    }

    private static func currentWeekKey() -> String {
        let cal = Calendar(identifier: .iso8601)
        let comps = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return "\(comps.yearForWeekOfYear ?? 0)-W\(comps.weekOfYear ?? 0)"
    }
}
