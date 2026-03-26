import SwiftUI

struct DiscoverView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var surprisePath: MatchResult?
    @State private var showSurpriseReveal: Bool = false
    @State private var isSpinning: Bool = false
    @State private var selectedResult: MatchResult?
    @State private var shareResult: MatchResult?

    private var unexploredResults: [MatchResult] {
        appState.matchResults.filter { !appState.exploredPathIDs.contains($0.businessPath.id) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    surpriseMeSection
                    challengeSection
                    DailyTipCard(tip: DailyTipDatabase.tipForToday())
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $shareResult) { result in
                ShareCardView(result: result, userName: appState.userProfile.firstName, totalMatches: appState.matchResults.count)
            }
        }
    }

    private var surpriseMeSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("Surprise Me")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                if !unexploredResults.isEmpty {
                    Text("\(unexploredResults.count) unseen")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Theme.textTertiary)
                }
            }

            if showSurpriseReveal, let path = surprisePath {
                surpriseRevealCard(path)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .opacity
                    ))
            } else {
                Button {
                    revealSurprise()
                } label: {
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
                                .frame(width: 52, height: 52)

                            Image(systemName: "dice.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .rotationEffect(.degrees(isSpinning ? 360 : 0))
                                .accessibilityHidden(true)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Discover a Random Path")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            Text("Tap to reveal a business you haven't explored yet")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .padding(16)
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
                            .stroke(Color(hex: "FBBF24").opacity(0.2), lineWidth: 1)
                    )
                }
                .sensoryFeedback(.impact(weight: .medium), trigger: showSurpriseReveal)
            }
        }
    }

    private func surpriseRevealCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return VStack(spacing: 14) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(catColor.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: result.businessPath.icon)
                        .font(.title2)
                        .foregroundStyle(catColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(result.businessPath.name)
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                    HStack(spacing: 8) {
                        Text(result.businessPath.startupCostRange)
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                        Text("•")
                            .foregroundStyle(Theme.textTertiary)
                        Text("\(result.scorePercentage)% match")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(catColor)
                    }
                }

                Spacer()
            }

            Text(result.businessPath.overview)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(3)

            HStack(spacing: 10) {
                Button {
                    selectedResult = result
                    appState.markPathExplored(result.businessPath.id)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Explore")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(catColor)
                    .clipShape(.capsule)
                }
                .accessibilityLabel("Explore \(result.businessPath.name)")

                Button {
                    withAnimation(.spring(duration: 0.4)) {
                        showSurpriseReveal = false
                        surprisePath = nil
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        revealSurprise()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Another")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.cardBackgroundLight)
                    .clipShape(.capsule)
                }
                .accessibilityLabel("Show another random business path")
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [catColor.opacity(0.08), Theme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(catColor.opacity(0.2), lineWidth: 1)
        )
    }

    private func revealSurprise() {
        let pool = unexploredResults.isEmpty ? appState.matchResults : unexploredResults
        guard !pool.isEmpty else { return }

        withAnimation(.spring(duration: 0.3)) {
            isSpinning = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let random = pool.randomElement()!
            surprisePath = random
            withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                showSurpriseReveal = true
                isSpinning = false
            }
        }
    }

    private var challengeSection: some View {
        let challenge = WeeklyChallengeDatabase.challengeForThisWeek()
        let isCompleted = appState.isChallengeCompleted(challenge.id)
        let challengeColor = Color(hex: challenge.color)

        return VStack(spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "calendar.badge.clock")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
                Text("Weekly Challenge")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                if isCompleted {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                        Text("Done")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(Theme.accent)
                }
            }

            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(challengeColor.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: challenge.icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(challengeColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(challenge.title)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                        Text(challenge.description)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(challenge.actionSteps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(isCompleted ? Theme.accent.opacity(0.15) : Theme.cardBackgroundLight)
                                    .frame(width: 24, height: 24)
                                if isCompleted {
                                    Image(systemName: "checkmark")
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(Theme.accent)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(Theme.textTertiary)
                                }
                            }
                            Text(step)
                                .font(.caption)
                                .foregroundStyle(isCompleted ? Theme.textTertiary : Theme.textSecondary)
                                .strikethrough(isCompleted, color: Theme.textTertiary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                if !isCompleted {
                    Button {
                        withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                            appState.markChallengeCompleted(challenge.id)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark Complete")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.accentBlue)
                        .clipShape(.capsule)
                    }
                    .sensoryFeedback(.success, trigger: isCompleted)
                }
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [challengeColor.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(challengeColor.opacity(0.15), lineWidth: 1)
            )
        }
    }
}
