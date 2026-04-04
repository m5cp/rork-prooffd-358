import SwiftUI
import StoreKit

struct MyBuildsView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedBuild: BuildProject?
    @State private var showPaywall: Bool = false
    @State private var showStepCelebration: Bool = false
    @State private var celebratedStepTitle: String = ""
    @State private var showProgressShare: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if appState.builds.isEmpty {
                        emptyState
                    } else {
                        if let today = appState.todayStep {
                            todayStepCard(today)
                        }

                        ForEach(appState.builds) { build in
                            buildCard(build)
                        }
                    }

                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Plan")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedBuild) { build in
                BuildDetailView(buildId: build.id)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
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
                        subtitle: "You finished \"\(celebratedStepTitle)\". Keep going!",
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

    private func todayStepCard(_ today: (build: BuildProject, step: BuildStep)) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 3)
                        .frame(width: 48, height: 48)
                    Circle()
                        .trim(from: 0, to: Double(today.build.progressPercentage) / 100.0)
                        .stroke(Theme.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-90))
                    Text("\(today.build.progressPercentage)%")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Theme.accent)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Next Step")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                    Text(today.step.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                }

                Spacer()
            }

            Button {
                withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                    appState.toggleBuildStep(buildId: today.build.id, stepId: today.step.id)
                    celebratedStepTitle = today.step.title
                    showStepCelebration = true
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
            .sensoryFeedback(.success, trigger: showStepCelebration)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private func buildCard(_ build: BuildProject) -> some View {
        Button {
            selectedBuild = build
        } label: {
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    Image(systemName: build.pathIcon)
                        .font(.body)
                        .foregroundStyle(Theme.categoryColor(for: build.category))
                        .frame(width: 44, height: 44)
                        .background(Theme.categoryColor(for: build.category).opacity(0.1))
                        .clipShape(.rect(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 3) {
                        Text(build.businessName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        Text("\(build.completedSteps) of \(build.totalSteps) steps")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("\(build.progressPercentage)%")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Theme.accent)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(.systemGray5))
                            .frame(height: 5)
                        Capsule()
                            .fill(Theme.accent)
                            .frame(width: geo.size.width * Double(build.progressPercentage) / 100.0, height: 5)
                    }
                }
                .frame(height: 5)

                if let nextStep = build.nextStep {
                    HStack(spacing: 6) {
                        Text("Next:")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        Text(nextStep.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                } else if build.progressPercentage >= 100 {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                        Text("Plan complete")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Theme.accent)
                    }
                }
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "hammer")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)

            VStack(spacing: 6) {
                Text("No plans yet")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text("Browse careers in Explore and tap\n\"Add to My Build\" to start a plan.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                appState.selectedTab = 0
            } label: {
                Text("Explore Careers")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Theme.accent)
                    .clipShape(.capsule)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
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
