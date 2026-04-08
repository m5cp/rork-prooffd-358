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

    private var sortedMatches: [MatchResult] {
        appState.matchResults.sorted { $0.scorePercentage > $1.scorePercentage }
    }

    private var strongMatches: [MatchResult] {
        sortedMatches.filter { $0.scorePercentage >= 50 }
    }

    private var targetCount: Int {
        strongMatches.count
    }

    private var topMatches: [MatchResult] {
        Array(sortedMatches.prefix(3))
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

                    Text("career matches found")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
                .sensoryFeedback(.success, trigger: showBadge)

                if showBadge {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.body)
                            .foregroundStyle(Theme.accent)
                        Text("Ranked by your quiz answers")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .transition(reduceMotion ? .opacity : .opacity.combined(with: .move(edge: .bottom)))
                }

                if showTopMatch, !topMatches.isEmpty {
                    VStack(spacing: 10) {
                        Text("Your Top Matches")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.accent)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(Array(topMatches.enumerated()), id: \.element.id) { index, match in
                            topMatchCard(match, rank: index + 1)
                        }
                    }
                    .padding(.horizontal, 24)
                    .transition(reduceMotion ? .opacity : .opacity.combined(with: .move(edge: .bottom)))
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

    private func topMatchCard(_ match: MatchResult, rank: Int) -> some View {
        let catColor = Theme.categoryColor(for: match.businessPath.category)
        let scoreColor: Color = match.scorePercentage >= 70 ? Theme.accent : match.scorePercentage >= 50 ? Color(hex: "FBBF24") : Theme.textTertiary

        return HStack(spacing: 12) {
            Text("#\(rank)")
                .font(.caption.weight(.heavy))
                .foregroundStyle(rank == 1 ? Theme.accent : Theme.textTertiary)
                .frame(width: 28)

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(catColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: match.businessPath.icon)
                    .font(.subheadline)
                    .foregroundStyle(catColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(match.businessPath.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                Text(match.businessPath.category.rawValue)
                    .font(.caption2)
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer(minLength: 4)

            HStack(spacing: 3) {
                Image(systemName: "target")
                    .font(.system(size: 10))
                Text("\(match.scorePercentage)%")
                    .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(scoreColor)
        }
        .padding(12)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Number \(rank) match: \(match.businessPath.name), \(match.scorePercentage) percent match")
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
