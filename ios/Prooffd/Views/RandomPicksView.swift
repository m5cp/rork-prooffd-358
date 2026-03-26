import SwiftUI

struct RandomPicksView: View {
    let picks: [MatchResult]
    let onSelect: (MatchResult) -> Void
    let onReroll: () -> Void
    @State private var appeared: Bool = false
    @State private var rerollRotation: Double = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "dice.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(Color(hex: "818CF8"))
                            .rotationEffect(.degrees(appeared ? 0 : -180))
                            .scaleEffect(appeared ? 1 : 0.5)

                        Text("Your Random Picks")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)

                        Text("The dice picked these two for you")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.top, 8)

                    VStack(spacing: 14) {
                        ForEach(Array(picks.enumerated()), id: \.element.id) { index, result in
                            randomPickCard(result, index: index)
                                .opacity(appeared ? 1 : 0)
                                .offset(y: appeared ? 0 : 30)
                                .animation(.spring(duration: 0.5, bounce: 0.3).delay(Double(index) * 0.15), value: appeared)
                        }
                    }
                    .padding(.horizontal, 16)

                    Button {
                        withAnimation(.spring(duration: 0.5, bounce: 0.4)) {
                            rerollRotation += 360
                        }
                        onReroll()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "dice.fill")
                                .rotationEffect(.degrees(rerollRotation))
                            Text("Roll Again")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundStyle(Color(hex: "818CF8"))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color(hex: "818CF8").opacity(0.12))
                        .clipShape(.capsule)
                    }
                    .sensoryFeedback(.impact(weight: .medium), trigger: rerollRotation)

                    Color.clear.frame(height: 20)
                }
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        onSelect(picks[0])
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                }
            }
            .onAppear {
                withAnimation(.spring(duration: 0.6, bounce: 0.3)) {
                    appeared = true
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func randomPickCard(_ result: MatchResult, index: Int) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return Button {
            onSelect(result)
        } label: {
            VStack(spacing: 14) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 52, height: 52)
                        Image(systemName: result.businessPath.icon)
                            .font(.title3)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "dice.fill")
                                .font(.caption2)
                                .foregroundStyle(Color(hex: "818CF8"))
                            Text("Pick \(index + 1)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color(hex: "818CF8"))
                        }

                        Text(result.businessPath.name)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer()

                    VStack(spacing: 4) {
                        Text("\(result.scorePercentage)%")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(scoreColor(result.scorePercentage))
                        Text("match")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                HStack(spacing: 12) {
                    infoTag(icon: "dollarsign.circle.fill", text: result.businessPath.startupCostRange)
                    infoTag(icon: "clock.fill", text: result.businessPath.timeToFirstDollar)
                    infoTag(icon: "shield.checkered", text: "AI Safe: \(result.businessPath.aiProofRating)")

                    Spacer()

                    Text("View Details")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(catColor)
                        .clipShape(.capsule)
                }
            }
            .padding(18)
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    private func infoTag(icon: String, text: String) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 9))
            Text(text)
                .font(.caption2)
        }
        .foregroundStyle(Theme.textTertiary)
    }

    private func scoreColor(_ percentage: Int) -> Color {
        if percentage >= 80 { return Theme.accent }
        if percentage >= 60 { return Theme.accentBlue }
        return .orange
    }
}
