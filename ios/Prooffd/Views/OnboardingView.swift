import SwiftUI

struct OnboardingView: View {
    var onComplete: () -> Void
    var onSkipQuiz: () -> Void
    @State private var currentPage: Int = 0
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            headline: "Find the right path\nfor you",
            subtitle: "Take a one-time 8-question profile assessment and get matched to jobs you can start — tailored to your skills, budget, and goals.",
            icon: "sparkles"
        ),
        OnboardingPage(
            headline: "Then build it,\nstep by step",
            subtitle: "Get a clear action plan, track your progress, and start earning — no degree or big investment required.",
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
                                .symbolEffect(.pulse, options: .repeating, isActive: !reduceMotion)
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

                VStack(spacing: 16) {
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
                            withAnimation(reduceMotion ? .none : .spring(duration: 0.4)) {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    } label: {
                        Text(currentPage == pages.count - 1 ? "Take the Quiz" : "Continue")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.accent)
                            .clipShape(.capsule)
                    }
                    .padding(.horizontal, 24)
                    .sensoryFeedback(.selection, trigger: currentPage)

                    if currentPage < pages.count - 1 {
                        Button {
                            onComplete()
                        } label: {
                            Text("Skip to Quiz")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.accent)
                        }
                    }

                    Button {
                        onSkipQuiz()
                    } label: {
                        Text("Explore App Now")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
                .padding(.bottom, 48)
            }
        }
    }

    private var meshBackground: some View {
        Group {
            if colorScheme == .dark {
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                    colors: [
                        Color(hex: "0F1117"), Color(hex: "131620"), Color(hex: "0F1117"),
                        Color(hex: "111420"), Color(hex: "14201A"), Color(hex: "111420"),
                        Color(hex: "0F1117"), Color(hex: "131620"), Color(hex: "0F1117")
                    ]
                )
                .ignoresSafeArea()
            } else {
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                    colors: [
                        Color(hex: "F5F5F7"), Color(hex: "EDF2F0"), Color(hex: "F5F5F7"),
                        Color(hex: "EFF3EE"), Color(hex: "E8EFE8"), Color(hex: "EEF1F5"),
                        Color(hex: "F5F5F7"), Color(hex: "F0F0F3"), Color(hex: "F5F5F7")
                    ]
                )
                .ignoresSafeArea()
            }
        }
    }
}

private struct OnboardingPage {
    let headline: String
    let subtitle: String
    let icon: String
}
