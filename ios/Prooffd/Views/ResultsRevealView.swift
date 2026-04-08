import SwiftUI

struct ResultsRevealView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var phase: RevealPhase = .idle
    @State private var countUpValue: Int = 0
    @State private var ringProgress: CGFloat = 0
    @State private var showTopCards: Bool = false
    @State private var showCTA: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var particleSeeds: [ParticleSeed] = []
    @State private var particlesActive: Bool = false
    @State private var pulseScale: CGFloat = 0.3
    @State private var glowOpacity: Double = 0

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

    private var pathColor: Color {
        appState.chosenPath?.color ?? Theme.accent
    }

    var body: some View {
        ZStack {
            backgroundLayer

            particleLayer

            VStack(spacing: 0) {
                Spacer()

                heroSection
                    .padding(.bottom, 32)

                if showTopCards {
                    topMatchesSection
                        .padding(.horizontal, 24)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        ))
                }

                Spacer()

                if showCTA {
                    ctaSection
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .sensoryFeedback(.impact(weight: .heavy), trigger: phase == .counting)
        .sensoryFeedback(.success, trigger: phase == .reveal)
        .sheet(isPresented: $showShareSheet) {
            ShareCardPresenterSheet(content: .quizResults(from: appState.matchResults))
        }
        .task {
            generateParticles()
            await runRevealSequence()
        }
    }

    // MARK: - Background

    private var backgroundLayer: some View {
        ZStack {
            if colorScheme == .dark {
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                    colors: [
                        Color(hex: "0F1117"), Color(hex: "0D1520"), Color(hex: "0F1117"),
                        Color(hex: "0D1A18"), Color(hex: "0F1117"), Color(hex: "0D1520"),
                        Color(hex: "0F1117"), Color(hex: "0D1520"), Color(hex: "0F1117")
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

            Circle()
                .fill(
                    RadialGradient(
                        colors: [pathColor.opacity(glowOpacity), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 250
                    )
                )
                .scaleEffect(pulseScale)
                .allowsHitTesting(false)
        }
    }

    // MARK: - Particles

    private var particleLayer: some View {
        Canvas { context, size in
            guard particlesActive else { return }
            for seed in particleSeeds {
                let x = size.width * seed.x
                let y = size.height * seed.y
                let rect = CGRect(x: x - seed.size / 2, y: y - seed.size / 2, width: seed.size, height: seed.size)
                context.opacity = seed.opacity
                context.fill(Circle().path(in: rect), with: .color(pathColor.opacity(0.6)))
            }
        }
        .allowsHitTesting(false)
        .opacity(particlesActive ? 1 : 0)
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .trim(from: 0, to: ringProgress)
                    .stroke(
                        pathColor.opacity(0.3),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))

                Circle()
                    .trim(from: 0, to: ringProgress)
                    .stroke(
                        pathColor,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: pathColor.opacity(0.4), radius: 8)

                VStack(spacing: 2) {
                    Text("\(countUpValue)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(pathColor)
                        .contentTransition(.numericText(countsDown: false))

                    if phase.rawValue >= RevealPhase.reveal.rawValue {
                        Text("strong")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.textTertiary)
                            .transition(.opacity.combined(with: .scale(scale: 0.5)))
                    }
                }
            }
            .scaleEffect(phase == .idle ? 0.3 : 1.0)
            .opacity(phase == .idle ? 0 : 1)

            VStack(spacing: 8) {
                if phase.rawValue >= RevealPhase.reveal.rawValue {
                    Text("Career Matches Found")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.textPrimary)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity).combined(with: .offset(y: 12)),
                            removal: .opacity
                        ))
                }

                if phase.rawValue >= RevealPhase.reveal.rawValue {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(pathColor)
                            .symbolEffect(.bounce, options: .nonRepeating, isActive: !reduceMotion)

                        Text("Personalized to your answers")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .transition(.opacity.combined(with: .offset(y: 8)))
                }
            }
        }
    }

    // MARK: - Top Matches

    private var topMatchesSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("YOUR TOP MATCHES")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(pathColor)
                    .tracking(0.8)
                Spacer()
            }
            .padding(.bottom, 4)

            ForEach(Array(topMatches.enumerated()), id: \.element.id) { index, match in
                topMatchCard(match, rank: index + 1)
                    .opacity(showTopCards ? 1 : 0)
                    .offset(y: showTopCards ? 0 : 30)
                    .animation(
                        .spring(duration: 0.6, bounce: 0.25).delay(Double(index) * 0.12),
                        value: showTopCards
                    )
            }
        }
    }

    private func topMatchCard(_ match: MatchResult, rank: Int) -> some View {
        let catColor = Theme.categoryColor(for: match.businessPath.category)
        let isTop = rank == 1

        return HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isTop ? pathColor : catColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                if isTop {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                } else {
                    Text("#\(rank)")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(catColor)
                }
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

            HStack(spacing: 4) {
                Image(systemName: "target")
                    .font(.system(size: 11, weight: .bold))
                Text("\(match.scorePercentage)%")
                    .font(.subheadline.weight(.bold))
                    .monospacedDigit()
            }
            .foregroundStyle(match.scorePercentage >= 70 ? pathColor : match.scorePercentage >= 50 ? Theme.warning : Theme.textTertiary)
        }
        .padding(14)
        .background(
            isTop
                ? AnyShapeStyle(pathColor.opacity(colorScheme == .dark ? 0.08 : 0.05))
                : AnyShapeStyle(Theme.cardBackground)
        )
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isTop ? pathColor.opacity(0.3) : Theme.border, lineWidth: isTop ? 1.5 : 0.5)
        )
        .shadow(color: isTop ? pathColor.opacity(0.15) : .clear, radius: 12, y: 4)
    }

    // MARK: - CTA

    private var ctaSection: some View {
        VStack(spacing: 12) {
            Button {
                appState.completeResultsReveal()
            } label: {
                HStack(spacing: 8) {
                    Text("Explore All Matches")
                        .font(.headline)
                    Image(systemName: "arrow.right")
                        .font(.subheadline.weight(.bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(pathColor)
                .clipShape(.capsule)
                .shadow(color: pathColor.opacity(0.3), radius: 16, y: 6)
            }

            Button {
                showShareSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.subheadline.weight(.medium))
                    Text("Share Results")
                        .font(.subheadline.weight(.medium))
                }
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 48)
    }

    // MARK: - Animation Sequence

    private func runRevealSequence() async {
        if reduceMotion {
            phase = .reveal
            countUpValue = targetCount
            ringProgress = 1
            pulseScale = 2.5
            glowOpacity = 0.15
            showTopCards = true
            showCTA = true
            appState.momentum.awardPoints(25, reason: .todayStep)
            return
        }

        try? await Task.sleep(for: .milliseconds(300))

        withAnimation(.spring(duration: 0.7, bounce: 0.4)) {
            phase = .entering
            pulseScale = 1.8
            glowOpacity = 0.25
        }

        try? await Task.sleep(for: .milliseconds(500))

        phase = .counting
        particlesActive = true

        let steps = min(max(targetCount, 1), 40)
        let totalDuration = 2.0
        let stepDelay = totalDuration / Double(steps)

        for i in 1...steps {
            try? await Task.sleep(for: .milliseconds(Int(stepDelay * 1000)))
            let progress = Double(i) / Double(steps)
            let eased = 1 - pow(1 - progress, 3)
            withAnimation(.spring(duration: 0.12)) {
                countUpValue = Int(eased * Double(targetCount))
            }
            withAnimation(.easeOut(duration: stepDelay)) {
                ringProgress = eased
            }
        }

        withAnimation(.spring(duration: 0.2)) {
            countUpValue = targetCount
            ringProgress = 1
        }

        try? await Task.sleep(for: .milliseconds(300))

        withAnimation(.spring(duration: 0.6, bounce: 0.35)) {
            phase = .reveal
            pulseScale = 2.5
            glowOpacity = 0.12
        }
        appState.momentum.awardPoints(25, reason: .todayStep)

        try? await Task.sleep(for: .milliseconds(500))

        withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
            showTopCards = true
        }

        try? await Task.sleep(for: .milliseconds(800))

        withAnimation(.spring(duration: 0.4)) {
            showCTA = true
        }
    }

    private func generateParticles() {
        particleSeeds = (0..<24).map { _ in
            ParticleSeed(
                x: CGFloat.random(in: 0.05...0.95),
                y: CGFloat.random(in: 0.1...0.55),
                size: CGFloat.random(in: 3...7),
                opacity: Double.random(in: 0.15...0.5)
            )
        }
    }
}

private enum RevealPhase: Int, Comparable {
    case idle = 0
    case entering = 1
    case counting = 2
    case reveal = 3

    static func < (lhs: RevealPhase, rhs: RevealPhase) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

private struct ParticleSeed {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity: Double
}
