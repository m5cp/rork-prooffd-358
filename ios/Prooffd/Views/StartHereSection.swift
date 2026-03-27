import SwiftUI

struct StartHereSection: View {
    @Environment(AppState.self) private var appState
    let onStartFast: () -> Void
    let onStableCareer: () -> Void
    let onRandomPick: ([MatchResult]) -> Void
    @State private var isRolling: Bool = false
    @State private var diceRotation: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "hand.wave.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Text("Start Here")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .padding(.horizontal, 16)

            HStack(spacing: 10) {
                startCompactCard(
                    icon: "bolt.fill",
                    iconColor: Color(hex: "FB923C"),
                    title: "Make Money Today",
                    action: onStartFast
                )

                diceCompactCard
            }
            .padding(.horizontal, 16)
        }
    }

    private var diceCompactCard: some View {
        Button {
            rollDice()
        } label: {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "818CF8").opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: "dice.fill")
                        .font(.title3)
                        .foregroundStyle(Color(hex: "818CF8"))
                        .rotationEffect(.degrees(diceRotation))
                }
                Text("Pick For Me")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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

    private func startCompactCard(icon: String, iconColor: Color, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(iconColor)
                }
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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
