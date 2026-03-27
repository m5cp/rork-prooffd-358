import SwiftUI

struct DailyRewardPopup: View {
    let reward: DailyReward
    let currentDay: Int
    let onClaim: () -> Void

    @State private var animateIn: Bool = false
    @State private var showConfetti: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 24) {
                    rewardIcon

                    VStack(spacing: 8) {
                        if reward.isMilestone {
                            Text("MILESTONE REWARD")
                                .font(.caption.weight(.bold))
                                .tracking(1.2)
                                .foregroundStyle(Color(hex: "FBBF24"))
                        }

                        Text(reward.title)
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)

                        Text("Day \(reward.day) Login Reward")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                            .font(.title3)
                            .foregroundStyle(Color(hex: "FBBF24"))
                        Text("+\(reward.points)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "FBBF24"))
                        Text("pts")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(Color(hex: "FBBF24").opacity(0.7))
                    }
                    .scaleEffect(animateIn ? 1.0 : 0.5)
                    .animation(.spring(duration: 0.5, bounce: 0.4).delay(0.2), value: animateIn)

                    streakProgress

                    Button {
                        onClaim()
                    } label: {
                        Text("Claim Reward")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: reward.isMilestone
                                        ? [Color(hex: "FBBF24"), Color(hex: "FB923C")]
                                        : [Theme.accent, Theme.accentBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(.capsule)
                    }
                    .sensoryFeedback(.success, trigger: showConfetti)
                }
                .padding(28)
                .background(Theme.background)
                .clipShape(.rect(cornerRadius: 28))
                .shadow(color: .black.opacity(0.3), radius: 24)
                .padding(.horizontal, 24)
                .scaleEffect(animateIn ? 1.0 : 0.85)
                .opacity(animateIn ? 1.0 : 0)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                animateIn = true
            }
        }
    }

    private var rewardIcon: some View {
        ZStack {
            Circle()
                .fill(
                    reward.isMilestone
                        ? LinearGradient(colors: [Color(hex: "FBBF24").opacity(0.2), Color(hex: "FB923C").opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [Theme.accent.opacity(0.15), Theme.accentBlue.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 88, height: 88)

            Image(systemName: reward.icon)
                .font(.system(size: 36))
                .foregroundStyle(reward.isMilestone ? Color(hex: "FBBF24") : Theme.accent)
                .symbolEffect(.bounce, value: animateIn)
        }
    }

    private var streakProgress: some View {
        VStack(spacing: 8) {
            HStack(spacing: 3) {
                ForEach(1...7, id: \.self) { day in
                    let dayInCycle = ((currentDay) % 7) + 1
                    let filled = day <= dayInCycle
                    Circle()
                        .fill(filled ? Theme.accent : Theme.cardBackgroundLight)
                        .frame(width: 10, height: 10)
                        .overlay {
                            if day == 7 {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 5))
                                    .foregroundStyle(filled ? .white : Theme.textTertiary)
                            }
                        }
                }
            }

            Text("Next milestone: Day \(nextMilestone)")
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
    }

    private var nextMilestone: Int {
        let milestones = [3, 7, 14, 30]
        let next = reward.day + 1
        return milestones.first(where: { $0 >= next }) ?? ((reward.day / 7 + 1) * 7)
    }
}

struct DailyRewardBanner: View {
    let canClaim: Bool
    let currentDay: Int
    let onClaim: () -> Void

    var body: some View {
        if canClaim {
            Button(action: onClaim) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "FBBF24"), Color(hex: "FB923C")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)

                        Image(systemName: "gift.fill")
                            .font(.body)
                            .foregroundStyle(.white)
                            .symbolEffect(.pulse.wholeSymbol)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Daily Reward Ready!")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)

                        let reward = DailyReward.forDay(currentDay + 1)
                        Text("Tap to claim +\(reward.points) points \(reward.isMilestone ? "- Milestone!" : "")")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }

                    Spacer()

                    Text("Claim")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "FBBF24"), Color(hex: "FB923C")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(.capsule)
                }
                .padding(14)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "FBBF24").opacity(0.08), Theme.cardBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(.rect(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "FBBF24").opacity(0.25), lineWidth: 1)
                )
                .cardShadow()
            }
            .buttonStyle(.plain)
        }
    }
}
