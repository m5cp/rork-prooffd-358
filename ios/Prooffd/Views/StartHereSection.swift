import SwiftUI

struct StartHereSection: View {
    @Environment(AppState.self) private var appState
    let onStartFast: () -> Void
    let onStableCareer: () -> Void
    let onRandomPick: ([MatchResult]) -> Void
    @State private var isRolling: Bool = false
    @State private var diceRotation: Double = 0

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

                diceRollCard
            }
            .padding(.horizontal, 16)
        }
    }

    private var diceRollCard: some View {
        Button {
            rollDice()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "818CF8").opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: "dice.fill")
                        .font(.title3)
                        .foregroundStyle(Color(hex: "818CF8"))
                        .rotationEffect(.degrees(diceRotation))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Pick For Me")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Roll the dice for 2 random suggestions")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 4)

                Image(systemName: "dice.fill")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color(hex: "818CF8"))
                    .rotationEffect(.degrees(diceRotation))
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex: "818CF8").opacity(0.1), lineWidth: 0.5)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
        .disabled(isRolling)
        .sensoryFeedback(.impact(weight: .medium), trigger: isRolling)
    }

    private func rollDice() {
        guard !isRolling else { return }
        isRolling = true

        withAnimation(.spring(duration: 0.6, bounce: 0.4)) {
            diceRotation += 360
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            let allResults = appState.matchResults
            guard allResults.count >= 2 else {
                isRolling = false
                return
            }
            let shuffled = allResults.shuffled()
            let picks = Array(shuffled.prefix(2))
            onRandomPick(picks)
            isRolling = false
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
