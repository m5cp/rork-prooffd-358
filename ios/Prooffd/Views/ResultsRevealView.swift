import SwiftUI

struct ResultsRevealView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var countUpValue: Int = 0
    @State private var showTopMatch: Bool = false
    @State private var showBadge: Bool = false
    @State private var showButton: Bool = false
    @State private var confettiTrigger: Int = 0
    @State private var showShareSheet: Bool = false

    private var strongMatches: [MatchResult] {
        appState.matchResults.filter { $0.scorePercentage >= 70 }
    }

    private var targetCount: Int {
        strongMatches.count
    }

    private var topMatch: MatchResult? {
        strongMatches.first
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Theme.accent)
                        .symbolEffect(.bounce, options: .nonRepeating, isActive: !reduceMotion)
                        .accessibilityHidden(true)

                    Text("Analysis Complete")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.textPrimary)
                }

                VStack(spacing: 8) {
                    Text("\(countUpValue)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.accent)
                        .contentTransition(.numericText(countsDown: false))

                    Text("strong matches (70%+)")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }

                if showBadge {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.body)
                            .foregroundStyle(Theme.accent)
                        Text("Your matches are ready")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .transition(reduceMotion ? .opacity : .opacity.combined(with: .move(edge: .bottom)))
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
                            .accessibilityHidden(true)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(top.businessPath.name)
                                    .font(.headline)
                                    .foregroundStyle(Theme.textPrimary)
                                HStack(spacing: 8) {
                                    Text("\(top.scorePercentage)% match")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(catColor)
                                    Text("\u{2022}")
                                        .foregroundStyle(Theme.textTertiary)
                                        .accessibilityHidden(true)
                                    Text("AI Safe: \(top.businessPath.aiProofRating)")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(Theme.textTertiary)
                                }
                            }

                            Spacer()
                        }
                        .padding(16)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .padding(.horizontal, 32)
                    .transition(reduceMotion ? .opacity : .opacity.combined(with: .move(edge: .bottom)))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Your number 1 match: \(top.businessPath.name), \(top.scorePercentage) percent match, AI Safe score \(top.businessPath.aiProofRating)")
                }

                Spacer()

                if showButton {
                    VStack(spacing: 12) {
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

                        Button {
                            showShareSheet = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.subheadline.weight(.medium))
                                Text("Share Results")
                                    .font(.subheadline.weight(.medium))
                            }
                            .foregroundStyle(Theme.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                        }
                        .accessibilityLabel("Share your quiz results")
                        .accessibilityHint("Opens a share card for your top matches")
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .sensoryFeedback(.impact(weight: .heavy), trigger: showTopMatch)
        .sensoryFeedback(.success, trigger: showBadge)
        .sheet(isPresented: $showShareSheet) {
            ShareCardPresenterSheet(content: .quizResults(from: appState.matchResults))
        }
        .task {
            await runReveal()
        }
    }

    private func runReveal() async {
        if reduceMotion {
            countUpValue = targetCount
            showBadge = true
            appState.momentum.awardPoints(25, reason: .todayStep)
            showTopMatch = true
            showButton = true
            return
        }

        let steps = min(max(targetCount, 1), 30)
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

        try? await Task.sleep(for: .milliseconds(400))

        withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
            showBadge = true
        }
        appState.momentum.awardPoints(25, reason: .todayStep)

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
