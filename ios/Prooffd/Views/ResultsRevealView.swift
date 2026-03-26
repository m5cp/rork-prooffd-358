import SwiftUI

struct ResultsRevealView: View {
    @Environment(AppState.self) private var appState
    @State private var countUpValue: Int = 0
    @State private var showTopMatch: Bool = false
    @State private var showButton: Bool = false

    private var targetCount: Int {
        appState.matchResults.count
    }

    private var topMatch: MatchResult? {
        appState.matchResults.first
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Theme.accent)
                        .symbolEffect(.bounce, options: .nonRepeating)

                    Text("Analysis Complete")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.textPrimary)
                }

                VStack(spacing: 8) {
                    Text("\(countUpValue)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.accent)
                        .contentTransition(.numericText(countsDown: false))

                    Text("business matches found")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }

                if showTopMatch, let top = topMatch {
                    let catColor = Theme.categoryColor(for: top.businessPath.category)
                    VStack(spacing: 12) {
                        Text("Your #1 Match")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.accent)

                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(catColor.opacity(0.15))
                                    .frame(width: 48, height: 48)
                                Image(systemName: top.businessPath.icon)
                                    .font(.title3)
                                    .foregroundStyle(catColor)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(top.businessPath.name)
                                    .font(.headline)
                                    .foregroundStyle(Theme.textPrimary)
                                Text("\(top.scorePercentage)% match")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(catColor)
                            }

                            Spacer()
                        }
                        .padding(16)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .padding(.horizontal, 32)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer()

                if showButton {
                    Button {
                        appState.completeResultsReveal()
                    } label: {
                        Text("View All Matches")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.accent)
                            .clipShape(.capsule)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .sensoryFeedback(.impact(weight: .heavy), trigger: showTopMatch)
        .task {
            await runReveal()
        }
    }

    private func runReveal() async {
        let steps = min(targetCount, 30)
        let duration = 1.5
        let stepDelay = duration / Double(steps)

        for i in 1...steps {
            try? await Task.sleep(for: .milliseconds(Int(stepDelay * 1000)))
            let progress = Double(i) / Double(steps)
            let easedProgress = progress * progress
            withAnimation(.spring(duration: 0.15)) {
                countUpValue = Int(easedProgress * Double(targetCount))
            }
        }

        withAnimation(.spring(duration: 0.15)) {
            countUpValue = targetCount
        }

        try? await Task.sleep(for: .milliseconds(600))

        withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
            showTopMatch = true
        }

        try? await Task.sleep(for: .milliseconds(800))

        withAnimation(.spring(duration: 0.4)) {
            showButton = true
        }
    }
}
