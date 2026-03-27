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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    streakBanner
                        .padding(.horizontal, 16)

                    if let today = appState.todayStep {
                        todayStepSection(today)
                            .padding(.horizontal, 16)
                    }

                    if !appState.builds.isEmpty {
                        momentumSection
                            .padding(.horizontal, 16)
                    }

                    if appState.builds.isEmpty {
                        emptyState
                            .padding(.horizontal, 16)
                    } else {
                        buildsListSection
                            .padding(.horizontal, 16)
                    }

                    if !appState.builds.isEmpty {
                        shareProgressSection
                            .padding(.horizontal, 16)
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
                    ShareableCardSheet(
                        cardContent: AnyView(
                            ProgressShareCard(
                                buildName: build.businessName,
                                progressPercent: build.progressPercentage,
                                streakDays: appState.streakTracker.currentStreak,
                                nextStep: build.nextStep?.title ?? "",
                                totalPoints: appState.momentum.totalPoints
                            )
                        ),
                        shareText: "I'm building \(build.businessName) step-by-step with Prooffd \u{2014} \(build.progressPercentage)% complete! Download Prooffd: https://apps.apple.com/app/prooffd/id6743071053"
                    )
                }
            }
        }
    }

    private var streakBanner: some View {
        HStack(spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.title3)
                    .foregroundStyle(appState.streakTracker.currentStreak > 0 ? .orange : Theme.textTertiary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(appState.streakTracker.currentStreak > 0
                        ? "\(appState.streakTracker.currentStreak) Day Streak"
                        : "Start Your Streak")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(appState.streakTracker.streakMessage)
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button {
                showAchievements = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .font(.caption2)
                    Text("\(appState.momentum.earnedBadges.count)")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(Color(hex: "818CF8"))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(hex: "818CF8").opacity(0.12))
                .clipShape(.capsule)
            }
        }
        .padding(14)
        .tintedCard(.orange)
    }

    private func todayStepSection(_ today: (build: BuildProject, step: BuildStep)) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
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
                }
                checkForRatingPrompt()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Mark Complete  +10 pts")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.accent)
                .clipShape(.capsule)
            }
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

    private var momentumSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .font(.caption)
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("Momentum")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text("\(appState.momentum.totalPoints) pts")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color(hex: "FBBF24"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "FBBF24").opacity(0.12))
                    .clipShape(.capsule)
            }

            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(MomentumBadge.all) { badge in
                        let earned = appState.momentum.hasBadge(badge.id)
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(earned ? Color(hex: badge.color).opacity(0.15) : Theme.cardBackgroundLight)
                                    .frame(width: 36, height: 36)
                                Image(systemName: badge.icon)
                                    .font(.caption)
                                    .foregroundStyle(earned ? Color(hex: badge.color) : Theme.textTertiary.opacity(0.4))
                            }
                            Text(badge.title)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(earned ? Theme.textSecondary : Theme.textTertiary.opacity(0.5))
                                .lineLimit(1)
                        }
                        .frame(width: 64)
                        .opacity(earned ? 1 : 0.5)
                    }
                }
            }
            .contentMargins(.horizontal, 0)
            .scrollIndicators(.hidden)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private var buildsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Builds")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.textPrimary)

            ForEach(appState.builds) { build in
                buildCard(build)
            }
        }
    }

    private func milestoneMessage(for progress: Int) -> String? {
        switch progress {
        case 25: return "Quarter way there — great momentum!"
        case 50: return "Halfway done — you're crushing it!"
        case 75: return "Almost there — the finish line is close!"
        case 100: return "Launch ready — you did it!"
        default: return nil
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
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.accent)
                        Text("\(build.completedSteps)/\(build.totalSteps) steps")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Theme.cardBackgroundLight)
                            .frame(height: 4)
                        Capsule()
                            .fill(Theme.accent)
                            .frame(width: geo.size.width * Double(build.progressPercentage) / 100.0, height: 4)
                    }
                }
                .frame(height: 4)

                if let msg = milestoneMessage(for: build.progressPercentage) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .font(.caption2)
                            .foregroundStyle(Color(hex: "FBBF24"))
                        Text(msg)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Color(hex: "FBBF24"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "FBBF24").opacity(0.08))
                    .clipShape(.capsule)
                } else if let nextStep = build.nextStep {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.right.circle")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                        Text("Next: \(nextStep.title)")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .lineLimit(1)
                        Spacer()
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
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 44))
                .foregroundStyle(Theme.textTertiary)

            VStack(spacing: 8) {
                Text("No active builds yet")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("Find a business match in Discover, then tap \"Start This Build\" to begin your step-by-step journey.")
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
                        Text("Business plans, email templates, sales scripts, PDF exports & more")
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
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
        .buttonStyle(.plain)
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
