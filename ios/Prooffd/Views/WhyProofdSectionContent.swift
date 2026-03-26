import SwiftUI

struct WhyProofdSectionContent: View {
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(colors: [Theme.accent, Theme.accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 40, height: 40)
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Real Hustle in an AI World")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Why Prooffd exists")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textTertiary)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(duration: 0.35)) {
                    isExpanded.toggle()
                }
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 14) {
                    Text("The world is changing. Fast.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)

                    Text("AI is eliminating traditional jobs at an unprecedented pace. Microsoft's 2025 research confirms that knowledge and desk-based roles \u{2014} writers, customer service, translators \u{2014} face the highest disruption risk. Meanwhile, physical, hands-on, and entrepreneurial work remains resilient and far harder for AI to replace.")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("But the real problem isn't just AI.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 8) {
                        StatBullet(icon: "chart.line.downtrend.xyaxis", text: "Unemployment sits at ~4.4%, but real underemployment (U-6) is closer to 8%")
                        StatBullet(icon: "person.2.fill", text: "Only 62% of working-age Americans are even in the labor force")
                        StatBullet(icon: "graduationcap.fill", text: "~42% of recent college grads are underemployed \u{2014} stuck in jobs that don't require their degree")
                        StatBullet(icon: "arrow.triangle.branch", text: "Millions know they need to pivot, but get stuck over-planning and never actually launch")
                    }

                    Divider()
                        .overlay(Theme.cardBackgroundLight)

                    Text("That's where Prooffd comes in.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)

                    Text("We don't give you generic career advice or another list of side hustles. Prooffd builds a real profile around you \u{2014} your budget, your time, your skills, your resources, and your goals \u{2014} then matches you to immediate, low-barrier, AI-proof business paths you can actually start today.")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "sparkles")
                            .font(.subheadline)
                            .foregroundStyle(Theme.accent)
                            .padding(.top, 2)

                        Text("No fluff. No theory. Just a clear, personalized path from where you are to where you want to be \u{2014} backed by real data and built for action.")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .background(Theme.accent.opacity(0.08))
                    .clipShape(.rect(cornerRadius: 10))
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 4)
    }
}

private struct StatBullet: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(Theme.accentBlue)
                .frame(width: 16, alignment: .center)
                .padding(.top, 2)
            Text(text)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
