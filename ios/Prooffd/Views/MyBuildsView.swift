import SwiftUI
import StoreKit

struct MyBuildsView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedBuild: BuildProject?
    @State private var showStepCelebration: Bool = false
    @State private var celebratedStepTitle: String = ""
    @State private var showProgressShare: Bool = false
    @State private var selectedEducationPath: CareerPath?
    @State private var selectedDegreeRecord: DegreeCareerRecord?
    @State private var weeklyPlan: WeeklyActionPlan? = nil
    @State private var showActionPlan = false

    private var isEmpty: Bool {
        appState.builds.isEmpty && appState.planItems.isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let plan = weeklyPlan {
                        actionPlanSummaryCard(plan: plan)
                    }
                    if isEmpty {
                        emptyState
                    } else {
                        if let today = appState.todayStep {
                            todayStepCard(today)
                        }

                        if !appState.builds.isEmpty {
                            sectionLabel("Business Plans", icon: "briefcase.fill", color: Theme.accent)
                            ForEach(appState.builds) { build in
                                buildCard(build)
                            }
                        }

                        let tradeItems = appState.planItems.filter { $0.type == .trade }
                        if !tradeItems.isEmpty {
                            sectionLabel("Trades & Certifications", icon: "wrench.and.screwdriver.fill", color: Theme.accentBlue)
                            ForEach(tradeItems) { item in
                                planItemCard(item)
                            }
                        }

                        let degreeItems = appState.planItems.filter { $0.type == .degree }
                        if !degreeItems.isEmpty {
                            sectionLabel("Advanced Education Careers", icon: "building.columns.fill", color: Color(hex: "818CF8"))
                            ForEach(degreeItems) { item in
                                planItemCard(item)
                            }
                        }
                    }

                    Color.clear.frame(height: 96)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("My Plan")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedBuild) { build in
                BuildDetailView(buildId: build.id)
            }
            .sheet(isPresented: $showProgressShare) {
                if let build = appState.activeBuild {
                    ShareCardPresenterSheet(content: .progress(from: build))
                }
            }
            .sheet(item: $selectedEducationPath) { path in
                CareerPathDetailSheet(career: path)
            }
            .sheet(item: $selectedDegreeRecord) { record in
                DegreeCareerDetailSheet(record: record)
            }
            .sheet(isPresented: $showActionPlan) {
                if weeklyPlan != nil {
                    WeeklyActionPlanView(plan: Binding(
                        get: { self.weeklyPlan! },
                        set: { self.weeklyPlan = $0; ActionPlanGenerator.save($0) }
                    ))
                }
            }
            .onAppear {
                if let topResult = appState.matchResults.first {
                    weeklyPlan = ActionPlanGenerator.load(for: topResult.businessPath.id)
                        ?? ActionPlanGenerator.generate(from: topResult)
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

    private func actionPlanSummaryCard(plan: WeeklyActionPlan) -> some View {
        let completed = plan.actions.filter { $0.isCompleted }.count
        // Full-bleed hero card: the render fills the whole card instead of
        // sitting in a cropped 52pt chip that cut the artwork in half.
        return Button { showActionPlan = true } label: {
            Color(hex: "0B0F14")
                .frame(height: 170)
                .frame(maxWidth: .infinity)
                .overlay {
                    ArtworkImage(name: PathArtwork.milestone)
                        .allowsHitTesting(false)
                }
                .overlay {
                    LinearGradient(
                        colors: [
                            Color(hex: "0B0F14").opacity(0.0),
                            Color(hex: "0B0F14").opacity(0.55),
                            Color(hex: "0B0F14").opacity(0.93)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .allowsHitTesting(false)
                }
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Week 1 Plan")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                        Text("\(completed)/7 days complete")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.white.opacity(0.85))
                        ProgressView(value: Double(completed), total: 7)
                            .tint(Theme.accent)
                            .frame(height: 4)
                    }
                    .padding(16)
                }
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(14)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Theme.accent.opacity(0.25), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func sectionLabel(_ title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.primary)
            Spacer()
        }
        .padding(.top, 4)
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
        .background(Theme.cardBackground)
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
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private func planItemCard(_ item: PlanItem) -> some View {
        let color: Color = item.type == .trade ? Theme.accentBlue : Color(hex: "818CF8")

        return Button {
            if item.type == .trade {
                if let path = EducationPathDatabase.all.first(where: { $0.id == item.itemId }) {
                    selectedEducationPath = path
                }
            } else if item.type == .degree {
                if let record = DegreeCareerDatabase.allRecords.first(where: { $0.id == item.itemId }) {
                    selectedDegreeRecord = record
                }
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: item.icon)
                    .font(.body)
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(item.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(role: .destructive) {
                withAnimation {
                    appState.removePlanItem(item.id)
                }
            } label: {
                Label("Remove from Plan", systemImage: "trash")
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            // `.fit` so the whole render is visible. The default `.fill` was
            // cropping the sprout in half inside this short frame.
            ArtworkImage(name: PathArtwork.emptyState, contentMode: .fit)
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .accessibilityHidden(true)

            VStack(spacing: 6) {
                Text("No plans yet")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text("Browse careers in Explore and tap\n\"Add to My Plan\" to start planning.")
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
        .background(Theme.cardBackground)
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
