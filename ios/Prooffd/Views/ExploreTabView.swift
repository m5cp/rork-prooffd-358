import SwiftUI

struct ExploreTabView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedResult: MatchResult?
    @State private var selectedCareer: CareerPath?
    @State private var surprisePath: MatchResult?
    @State private var showSurpriseReveal: Bool = false
    @State private var isSpinning: Bool = false
    @State private var showPaywall: Bool = false

    private var trendingPaths: [MatchResult] {
        Array(appState.matchResults.sorted { $0.scorePercentage > $1.scorePercentage }.prefix(6))
    }

    private var unexploredResults: [MatchResult] {
        appState.matchResults.filter { !appState.exploredPathIDs.contains($0.businessPath.id) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    trendingSection
                    careerPathsSection
                    surpriseMeSection
                    challengeSection
                    DailyTipCard(tip: DailyTipDatabase.tipForToday())
                        .padding(.horizontal, 16)
                    shareLoopSection
                    Color.clear.frame(height: 40)
                }
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $selectedCareer) { career in
                CareerPathDetailSheet(career: career)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Text("Popular Right Now")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(trendingPaths) { result in
                        trendingCard(result)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)
        }
    }

    private func trendingCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return Button {
            selectedResult = result
            appState.markPathExplored(result.businessPath.id)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    Circle()
                        .fill(catColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: result.businessPath.icon)
                        .font(.body)
                        .foregroundStyle(catColor)
                }

                Text(result.businessPath.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 4) {
                    Text("\(result.scorePercentage)% match")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(catColor)
                }

                Text(result.businessPath.startupCostRange)
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
            .frame(width: 140, alignment: .leading)
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(catColor.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var careerPathsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "road.lanes")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
                Text("Career Paths")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)

            Text("Stable income paths with step-by-step guidance")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(CareerPathDatabase.all) { career in
                        careerCard(career)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)
        }
    }

    private func careerCard(_ career: CareerPath) -> some View {
        Button {
            selectedCareer = career
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: career.icon)
                    .font(.title2)
                    .foregroundStyle(Theme.accentBlue)

                Text(career.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .font(.system(size: 9))
                        Text(career.salaryRange)
                            .font(.caption2)
                    }
                    .foregroundStyle(Theme.accent)

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 9))
                        Text(career.timeToIncome)
                            .font(.caption2)
                    }
                    .foregroundStyle(Theme.textTertiary)
                }
            }
            .frame(width: 160, alignment: .leading)
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accentBlue.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var surpriseMeSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.caption.weight(.semibold))
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
                                .frame(width: 48, height: 48)
                            Image(systemName: "dice.fill")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .rotationEffect(.degrees(isSpinning ? 360 : 0))
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Discover a Random Path")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            Text("Tap to reveal a business you haven't explored")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .padding(14)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "FBBF24").opacity(0.08), Theme.cardBackground],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 14))
                }
                .sensoryFeedback(.impact(weight: .medium), trigger: showSurpriseReveal)
            }
        }
        .padding(.horizontal, 16)
    }

    private func surpriseRevealCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(catColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: result.businessPath.icon)
                        .font(.body)
                        .foregroundStyle(catColor)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(result.businessPath.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("\(result.scorePercentage)% match")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(catColor)
                }
                Spacer()
            }

            HStack(spacing: 10) {
                Button {
                    selectedResult = result
                    appState.markPathExplored(result.businessPath.id)
                } label: {
                    Text("Explore")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(catColor)
                        .clipShape(.capsule)
                }

                Button {
                    withAnimation(.spring(duration: 0.4)) {
                        showSurpriseReveal = false
                        surprisePath = nil
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        revealSurprise()
                    }
                } label: {
                    Text("Another")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Theme.cardBackgroundLight)
                        .clipShape(.capsule)
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func revealSurprise() {
        let pool = unexploredResults.isEmpty ? appState.matchResults : unexploredResults
        guard !pool.isEmpty else { return }
        withAnimation(.spring(duration: 0.3)) { isSpinning = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            surprisePath = pool.randomElement()
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
                    .font(.caption.weight(.semibold))
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

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(challengeColor.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: challenge.icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(challengeColor)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(challenge.title)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                        Text(challenge.description)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }

                ForEach(Array(challenge.actionSteps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(isCompleted ? Theme.accent.opacity(0.15) : Theme.cardBackgroundLight)
                                .frame(width: 22, height: 22)
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
                        .padding(.vertical, 10)
                        .background(Theme.accentBlue)
                        .clipShape(.capsule)
                    }
                    .sensoryFeedback(.success, trigger: isCompleted)
                }
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
        .padding(.horizontal, 16)
    }

    private var shareLoopSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.fill")
                .font(.title2)
                .foregroundStyle(Theme.accentBlue)
            Text("Challenge a friend to find theirs")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
            Text("Share the app and see who gets better matches")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .multilineTextAlignment(.center)

            Button {
                shareApp()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share with a Friend")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.accentBlue)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Theme.accentBlue.opacity(0.12))
                .clipShape(.capsule)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
        .padding(.horizontal, 16)
    }

    private func shareApp() {
        let text = "I just found my top business matches on Prooffd — challenge yourself to find yours!"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            var topController = root
            while let presented = topController.presentedViewController { topController = presented }
            activityVC.popoverPresentationController?.sourceView = topController.view
            topController.present(activityVC, animated: true)
        }
    }
}

struct CareerPathDetailSheet: View {
    let career: CareerPath
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: career.icon)
                            .font(.system(size: 36))
                            .foregroundStyle(Theme.accentBlue)
                        Text(career.name)
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)
                    }
                    .padding(.top, 8)

                    HStack(spacing: 0) {
                        statItem(icon: "dollarsign.circle.fill", title: "Salary", value: career.salaryRange)
                        Rectangle().fill(Theme.cardBackgroundLight).frame(width: 1, height: 40)
                        statItem(icon: "clock.fill", title: "Time", value: career.timeToIncome)
                        Rectangle().fill(Theme.cardBackgroundLight).frame(width: 1, height: 40)
                        statItem(icon: "banknote.fill", title: "Cost", value: career.costRange)
                    }
                    .padding(.vertical, 16)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 10) {
                        sectionHeader("Overview", icon: "text.alignleft")
                        Text(career.overview)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(4)
                    }
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader("Steps to Get Started", icon: "list.number")
                        ForEach(Array(career.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                                    .background(Theme.accentBlue)
                                    .clipShape(Circle())
                                Text(step)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                    }
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 10) {
                        sectionHeader("Funding Options", icon: "banknote.fill")
                        ForEach(career.fundingOptions, id: \.self) { option in
                            HStack(alignment: .top, spacing: 10) {
                                Circle()
                                    .fill(Theme.accent)
                                    .frame(width: 5, height: 5)
                                    .padding(.top, 6)
                                Text(option)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                    }
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 10) {
                        sectionHeader("Why It's AI-Resistant", icon: "shield.checkered")
                        Text(career.whyAIResistant)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(4)
                    }
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))

                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Theme.textTertiary)
                            .font(.title3)
                    }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    private func statItem(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(Theme.accentBlue)
            Text(title)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
            Text(value)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Theme.accentBlue)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
        }
    }
}
