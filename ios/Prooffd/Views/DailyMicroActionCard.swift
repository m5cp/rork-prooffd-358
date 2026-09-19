import SwiftUI

struct DailyMicroActionCard: View {
    @Environment(AppState.self) private var appState
    @State private var showCheckAnimation: Bool = false

    private var action: DailyMicroAction {
        appState.dailyMicroAction.todayAction
    }

    private var isCompleted: Bool {
        appState.dailyMicroAction.completedToday
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "target")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                    .accessibilityHidden(true)
                Text("Today's Action")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                if isCompleted {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                        Text("Done")
                            .font(.caption2.weight(.semibold))
                    }
                    .foregroundStyle(Theme.accent)
                    .accessibilityLabel("Completed")
                } else {
                    Text("+\(action.points) pts")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color(hex: "FBBF24"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(hex: "FBBF24").opacity(0.12))
                        .clipShape(.capsule)
                        .accessibilityLabel("\(action.points) points reward")
                }
            }

            HStack(spacing: 14) {
                RenderedIcon(
                    name: IconArtwork.target,
                    size: 52,
                    glow: isCompleted ? Theme.accent : Color(hex: "F472B6")
                )
                .opacity(isCompleted ? 0.5 : 1)
                .overlay {
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Theme.accent)
                            .shadow(color: .black.opacity(0.6), radius: 4)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(action.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(isCompleted ? Theme.textTertiary : Theme.textPrimary)
                        .strikethrough(isCompleted, color: Theme.textTertiary)
                    Text(action.description)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }

                Spacer()
            }

            if !isCompleted {
                Button {
                    withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                        appState.completeDailyMicroAction()
                        showCheckAnimation = true
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .accessibilityHidden(true)
                        Text("Mark Done")
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Theme.accent)
                    .clipShape(.capsule)
                }
                .accessibilityLabel("Mark \(action.title) as done")
                .accessibilityHint("Earns \(action.points) points")
                .sensoryFeedback(.success, trigger: showCheckAnimation)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Today's Action: \(action.title), \(isCompleted ? "completed" : "not completed")")
        .padding(14)
        .background(
            LinearGradient(
                colors: [Theme.accent.opacity(isCompleted ? 0.03 : 0.06), Theme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.accent.opacity(0.15), lineWidth: 0.5)
        )
    }

}
