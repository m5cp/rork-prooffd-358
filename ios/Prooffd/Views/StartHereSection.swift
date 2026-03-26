import SwiftUI

struct StartHereSection: View {
    @Environment(AppState.self) private var appState
    let onStartFast: () -> Void
    let onStableCareer: () -> Void
    let onHelpDecide: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "hand.wave.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Text("Start Here")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .padding(.horizontal, 16)

            Text("Not sure where to begin? Pick a path.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 16)

            VStack(spacing: 10) {
                startCard(
                    icon: "bolt.fill",
                    iconColor: Color(hex: "FB923C"),
                    title: "Start Something Fast",
                    subtitle: "Low cost, quick to launch businesses",
                    action: onStartFast
                )

                startCard(
                    icon: "building.2.fill",
                    iconColor: Theme.accentBlue,
                    title: "Find a Stable Career Path",
                    subtitle: "Education & certification paths with steady income",
                    action: onStableCareer
                )

                startCard(
                    icon: "questionmark.circle.fill",
                    iconColor: Color(hex: "818CF8"),
                    title: "Help Me Decide",
                    subtitle: "Take a quick quiz to find your best match",
                    action: onHelpDecide
                )
            }
            .padding(.horizontal, 16)
        }
    }

    private func startCard(icon: String, iconColor: Color, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(iconColor)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 4)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(iconColor.opacity(0.1), lineWidth: 0.5)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }
}
