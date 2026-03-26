import SwiftUI

struct OnboardingView: View {
    var onComplete: () -> Void
    @State private var currentPage: Int = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            headline: "You don't need\nthe perfect idea",
            subtitle: "Most successful businesses started with someone just like you — unsure but willing to try.",
            icon: "lightbulb.fill"
        ),
        OnboardingPage(
            headline: "Most people\nstay stuck here",
            subtitle: "Overthinking, over-researching, waiting for the \"right time.\" That cycle ends today.",
            icon: "figure.stand"
        ),
        OnboardingPage(
            headline: "That's not how\nthis works",
            subtitle: "You don't need a degree, a loan, or a business plan. You need the right match for YOU.",
            icon: "arrow.triangle.turn.up.right.diamond.fill"
        ),
        OnboardingPage(
            headline: "We'll show you\nexactly what to do",
            subtitle: "Answer a few quick questions and we'll match you with real businesses you can start this week.",
            icon: "checkmark.seal.fill"
        )
    ]

    var body: some View {
        ZStack {
            meshBackground
            VStack(spacing: 0) {
                Spacer()
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        VStack(spacing: 24) {
                            Image(systemName: page.icon)
                                .font(.system(.largeTitle, design: .default, weight: .bold))
                                .foregroundStyle(Theme.accent)
                                .symbolEffect(.pulse, options: .repeating)
                                .accessibilityHidden(true)

                            Text(page.headline)
                                .font(.largeTitle.bold())
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Theme.textPrimary)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility2)

                            Text(page.subtitle)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Theme.textSecondary)
                                .padding(.horizontal, 32)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                Spacer()

                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? Theme.accent : Theme.textTertiary)
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.spring(duration: 0.3), value: currentPage)
                        }
                    }

                    Button {
                        if currentPage < pages.count - 1 {
                            withAnimation(.spring(duration: 0.4)) {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    } label: {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.accent)
                            .clipShape(.capsule)
                    }
                    .padding(.horizontal, 24)
                    .accessibilityHint(currentPage == pages.count - 1 ? "Begin the quiz" : "Go to next page")

                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textTertiary)
                        .accessibilityHint("Skip onboarding and start the quiz")
                    }
                }
                .padding(.bottom, 48)
            }
        }
    }

    private var meshBackground: some View {
        MeshGradient(
            width: 3, height: 3,
            points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [0.5, 0.5], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ],
            colors: [
                Color(hex: "0A0E1A"), Color(hex: "0F1B2D"), Color(hex: "0A0E1A"),
                Color(hex: "0D1825"), Color(hex: "132A1E"), Color(hex: "0D1825"),
                Color(hex: "0A0E1A"), Color(hex: "0F1B2D"), Color(hex: "0A0E1A")
            ]
        )
        .ignoresSafeArea()
    }
}

private struct OnboardingPage {
    let headline: String
    let subtitle: String
    let icon: String
}
