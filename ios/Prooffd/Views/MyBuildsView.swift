import SwiftUI
import StoreKit

struct MyBuildsView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedBuild: BuildProject?
    @State private var showPaywall: Bool = false
    @State private var celebrationBuildId: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let today = appState.todayStep {
                        todayStepSection(today)
                            .padding(.horizontal, 16)
                    }

                    if appState.builds.isEmpty {
                        emptyState
                            .padding(.horizontal, 16)
                    } else {
                        buildsListSection
                            .padding(.horizontal, 16)
                    }

                    if !store.isPremium && appState.builds.count >= 2 {
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
        }
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
                    Text("Mark Complete")
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
            HStack(spacing: 12) {
                Image(systemName: "crown.fill")
                    .font(.title3)
                    .foregroundStyle(.yellow)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Unlock Full Business Plans")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Get templates, scripts & export tools")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
        }
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

