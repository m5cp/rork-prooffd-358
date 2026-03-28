import SwiftUI
import StoreKit

struct MyBuildsView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedBuild: BuildProject?
    @State private var showPaywall: Bool = false
    @State private var celebrationBuildId: String?
    @State private var showAchievements: Bool = false
    @State private var showProgressShare: Bool = false
    @State private var showStepCelebration: Bool = false
    @State private var celebratedStepTitle: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if appState.builds.isEmpty {
                        emptyState
                            .padding(.horizontal, 16)
                    } else {
                        if let today = appState.todayStep {
                            todayStepSection(today)
                                .padding(.horizontal, 16)
                        }

                        encouragementBanner
                            .padding(.horizontal, 16)

                        buildsListSection
                            .padding(.horizontal, 16)

                        if !appState.builds.isEmpty {
                            shareProgressSection
                                .padding(.horizontal, 16)
                        }
                    }

                    if !store.isPremium {
                        upgradePrompt
                            .padding(.horizontal, 16)
                    }

                    Color.clear.frame(height: 40)
                }
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("My Builds")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(item: $selectedBuild) { build in
                BuildDetailView(buildId: build.id)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showAchievements) {
                AchievementsView()
            }
            .sheet(isPresented: $showProgressShare) {
                if let build = appState.activeBuild {
                    ShareCardPresenterSheet(content: .progress(from: build))
                }
            }
            .overlay {
                if showStepCelebration {
                    StepCompletionOverlay(
                        title: "Step Complete!",
                        subtitle: "You finished \"\(celebratedStepTitle)\". Keep the momentum going!",
                        onShare: {
                            showStepCelebration = false
                            showProgressShare = true
                            appState.markResultShared()
                        },
                        onDismiss: {
                            withAnimation(.spring(duration: 0.3)) {
                                showStepCelebration = false
                            }
                        }
                    )
                    .transition(.opacity)
                }
            }
            .animation(.spring(duration: 0.4), value: showStepCelebration)
        }
    }

    // MARK: - Encouragement Banner

    @ViewBuilder
    private var encouragementBanner: some View {
        let maxProgress = appState.builds.map(\.progressPercentage).max() ?? 0
        let totalCompleted = appState.builds.flatMap(\.steps).filter(\.isCompleted).count
        let message = encouragementMessage(progress: maxProgress, stepsCompleted: totalCompleted)

        if let message {
            HStack(spacing: 12) {
                Image(systemName: message.icon)
                    .font(.title3)
                    .foregroundStyle(message.color)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(message.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(message.subtitle)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer()
            }
            .accessibilityElement(children: .combine)
            .padding(14)
            .background(
                LinearGradient(
                    colors: [message.color.opacity(0.08), Theme.cardBackground],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(message.color.opacity(0.15), lineWidth: 0.5)
            )
            .cardShadow()
        }
    }

    private struct EncouragementContent {
        let icon: String
        let title: String
        let subtitle: String
        let color: Color
    }

    private func encouragementMessage(progress: Int, stepsCompleted: Int) -> EncouragementContent? {
        if stepsCompleted == 1 {
            return EncouragementContent(
                icon: "sparkles",
                title: "First step done!",
                subtitle: "You're officially building. Keep the momentum going.",
                color: Theme.accent
            )
        }
        if progress >= 50 && progress < 75 {
            return EncouragementContent(
                icon: "flame.fill",
                title: "Halfway there",
                subtitle: "You're making real progress. The finish line is getting closer.",
                color: .orange
            )
        }
        if progress >= 25 && progress < 50 {
            return EncouragementContent(
                icon: "bolt.fill",
                title: "Building momentum",
                subtitle: "Quarter of the way done \u{2014} you're ahead of most people.",
                color: Color(hex: "FBBF24")
            )
        }
        if progress >= 75 && progress < 100 {
            return EncouragementContent(
                icon: "trophy.fill",
                title: "Almost there",
                subtitle: "You're in the final stretch. Keep pushing!",
                color: Color(hex: "818CF8")
            )
        }
        if progress >= 100 {
            return EncouragementContent(
                icon: "checkmark.seal.fill",
                title: "Launch ready",
                subtitle: "You completed your plan. Time to make it happen.",
                color: Theme.accent
            )
        }
        return nil
    }

    // MARK: - Today's Step

    private func todayStepSection(_ today: (build: BuildProject, step: BuildStep)) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
                    .accessibilityHidden(true)
                Text("Today's Step")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text(today.build.pathName)
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }

            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Theme.cardBackgroundLight, lineWidth: 3)
                        .frame(width: 44, height: 44)
                    Circle()
                        .trim(from: 0, to: Double(today.build.progressPercentage) / 100.0)
                        .stroke(Theme.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 44, height: 44)
                        .rotationEffect(.degrees(-90))
                    Text("\(today.build.progressPercentage)%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Theme.accent)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(today.build.progressPercentage) percent complete")

                VStack(alignment: .leading, spacing: 4) {
                    Text(today.step.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Step \(today.step.order + 1) of \(today.build.totalSteps)")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }

                Spacer()
            }

            Button {
                withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                    appState.toggleBuildStep(buildId: today.build.id, stepId: today.step.id)
                    celebrationBuildId = today.build.id
                    celebratedStepTitle = today.step.title
                    showStepCelebration = true
                }
                checkForRatingPrompt()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .accessibilityHidden(true)
                    Text("Mark Complete  +10 pts")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.accent)
                .clipShape(.capsule)
            }
            .accessibilityLabel("Mark step complete, earn 10 points")
            .sensoryFeedback(.success, trigger: celebrationBuildId)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Theme.accent.opacity(0.08), Theme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
        )
        .cardShadow()
    }

    // MARK: - Builds List

    private var buildsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Plans")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.textPrimary)

            ForEach(appState.builds) { build in
                buildCard(build)
            }
        }
    }

    private func buildCard(_ build: BuildProject) -> some View {
        Button {
            selectedBuild = build
        } label: {
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Theme.categoryColor(for: build.category).opacity(0.12))
                            .frame(width: 44, height: 44)
                        Image(systemName: build.pathIcon)
                            .font(.body)
                            .foregroundStyle(Theme.categoryColor(for: build.category))
                    }
                    .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(build.businessName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(1)
                        Text(build.currentMilestone)
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(build.progressPercentage)%")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Theme.accent)
                        Text("\(build.completedSteps)/\(build.totalSteps)")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Theme.cardBackgroundLight)
                            .frame(height: 6)
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Theme.accent, Theme.accent.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * Double(build.progressPercentage) / 100.0, height: 6)
                    }
                }
                .frame(height: 6)
                .accessibilityHidden(true)

                if let nextStep = build.nextStep {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.right.circle")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                        Text("Next: \(nextStep.title)")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }
                } else if build.progressPercentage >= 100 {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.accent)
                        Text("Plan complete")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Theme.accent)
                    }
                }
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.categoryColor(for: build.category).opacity(0.1), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(build.businessName), \(build.progressPercentage) percent complete, \(build.completedSteps) of \(build.totalSteps) steps done")
        .accessibilityHint("Opens build details")
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 44))
                .foregroundStyle(Theme.textTertiary)

            VStack(spacing: 8) {
                Text("No active builds yet")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("Find a business match in Discover, then tap \"Start This Build\" to begin your step-by-step plan.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                appState.selectedTab = 0
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                    Text("Browse Matches")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Theme.accent)
                .clipShape(.capsule)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .padding(.horizontal, 20)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .cardShadow()
    }

    // MARK: - Upgrade Prompt

    private var upgradePrompt: some View {
        Button {
            showPaywall = true
        } label: {
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Theme.accent, Theme.accentBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                        Image(systemName: "crown.fill")
                            .font(.body)
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Unlock Pro Features")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                        Text("Marketing scripts, outreach templates, PDF exports & more")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .lineLimit(2)
                    }

                    Spacer()
                }

                HStack(spacing: 6) {
                    Image(systemName: "lock.open.fill")
                    Text("Upgrade to Pro")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [Theme.accent, Theme.accentBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(.capsule)
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    // MARK: - Share Progress

    private var shareProgressSection: some View {
        Button {
            showProgressShare = true
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Theme.accentBlue.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.body)
                        .foregroundStyle(Theme.accentBlue)
                }
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Share Your Progress")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Show friends what you're building")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textTertiary)
                    .accessibilityHidden(true)
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Share Your Progress")
        .accessibilityHint("Creates a shareable card of your building progress")
    }

    private func checkForRatingPrompt() {
        if appState.completedFirstStep && !appState.hasBeenPromptedForRating {
            appState.hasBeenPromptedForRating = true
            Task {
                try? await Task.sleep(for: .seconds(1.5))
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
        }
    }
}
