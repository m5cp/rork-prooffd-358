import SwiftUI

struct ReadinessDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    scoreRingSection
                    profileScoreSection
                    actionScoreSection
                    tipsSection
                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Readiness Score")
            .navigationBarTitleDisplayMode(.large)
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

    // MARK: - Score Ring

    private var scoreRingSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Theme.cardBackgroundLight, lineWidth: 10)
                    .frame(width: 140, height: 140)
                Circle()
                    .trim(from: 0, to: Double(appState.readinessScore) / 100.0)
                    .stroke(
                        AngularGradient(
                            colors: [Theme.accent, Theme.accentBlue, Theme.accent],
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text("\(appState.readinessScore)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                    Text("of 100")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Theme.textTertiary)
                }
            }

            Text(appState.readinessLevel)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(levelColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(levelColor.opacity(0.12))
                .clipShape(.capsule)

            HStack(spacing: 20) {
                miniBreakdown(label: "Profile", value: appState.profileReadinessScore, max: 50, color: Theme.accent)
                Rectangle().fill(Theme.cardBackgroundLight).frame(width: 1, height: 40)
                miniBreakdown(label: "Actions", value: appState.actionReadinessScore, max: 50, color: Theme.accentBlue)
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Theme.accent.opacity(0.06), Theme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.accent.opacity(0.12), lineWidth: 1)
        )
    }

    private func miniBreakdown(label: String, value: Int, max: Int, color: Color) -> some View {
        VStack(spacing: 6) {
            Text("\(value)")
                .font(.title2.weight(.bold))
                .foregroundStyle(Theme.textPrimary)
            + Text(" / \(max)")
                .font(.caption.weight(.medium))
                .foregroundStyle(Theme.textTertiary)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.cardBackgroundLight).frame(height: 5)
                    Capsule().fill(color).frame(width: geo.size.width * (Double(value) / Double(max)), height: 5)
                }
            }
            .frame(height: 5)

            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Theme.textTertiary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Profile Score

    private var profileScoreSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Theme.accent)
                Text("Profile Score")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text("\(appState.profileReadinessScore)/50")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.accent)
            }

            Text("Complete the quiz and answer every question for max points. More detail = higher score.")
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(2)

            VStack(spacing: 0) {
                profileCheckRow(
                    label: "Interest categories",
                    earned: appState.userProfile.selectedCategories.isEmpty ? 0 : 12,
                    max: 12,
                    done: !appState.userProfile.selectedCategories.isEmpty,
                    icon: "square.grid.2x2.fill",
                    color: Theme.accent
                )
                checkDivider
                profileCheckRow(
                    label: "Work environment",
                    earned: appState.userProfile.workEnvironments.isEmpty ? 0 : 12,
                    max: 12,
                    done: !appState.userProfile.workEnvironments.isEmpty,
                    icon: "building.2.fill",
                    color: Theme.accentBlue
                )
                checkDivider
                profileCheckRow(
                    label: "Work conditions",
                    earned: appState.userProfile.workConditions.isEmpty ? 0 : 12,
                    max: 12,
                    done: !appState.userProfile.workConditions.isEmpty,
                    icon: "wrench.and.screwdriver.fill",
                    color: Color(hex: "818CF8")
                )
                checkDivider
                profileCheckRow(
                    label: "Situation tags",
                    earned: appState.userProfile.situationTags.isEmpty ? 0 : 14,
                    max: 14,
                    done: !appState.userProfile.situationTags.isEmpty,
                    icon: "tag.fill",
                    color: .orange
                )
            }
            .background(Theme.cardBackgroundLight)
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Action Score

    private var actionScoreSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "bolt.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Theme.accentBlue)
                Text("Action Score")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text("\(appState.actionReadinessScore)/50")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.accentBlue)
            }

            Text("The more you use the app, the higher your action score climbs.")
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(2)

            VStack(spacing: 0) {
                actionCheckRow(label: "Complete the quiz", points: 5, done: appState.hasCompletedQuiz, icon: "checkmark.circle.fill", color: Theme.accent)
                checkDivider
                actionCheckRow(label: "Explore 5 paths", points: 5, done: appState.exploredPathIDs.count >= 5, icon: "eye.fill", color: Color(hex: "818CF8"), progress: "\(min(appState.exploredPathIDs.count, 5))/5")
                checkDivider
                actionCheckRow(label: "Explore 10 paths", points: 5, done: appState.exploredPathIDs.count >= 10, icon: "eye.circle.fill", color: Color(hex: "818CF8"), progress: "\(min(appState.exploredPathIDs.count, 10))/10")
                checkDivider
                actionCheckRow(label: "Save 3 favorites", points: 3, done: appState.favoritePathIDs.count >= 3, icon: "heart.fill", color: .pink, progress: "\(min(appState.favoritePathIDs.count, 3))/3")
                checkDivider
                actionCheckRow(label: "Start a build", points: 5, done: !appState.builds.isEmpty, icon: "hammer.fill", color: Theme.accentBlue)
                checkDivider
                actionCheckRow(label: "Complete 5 checklist steps", points: 5, done: totalCompletedSteps >= 5, icon: "checklist", color: Theme.accent, progress: "\(min(totalCompletedSteps, 5))/5")
                checkDivider
                actionCheckRow(label: "Complete 10 checklist steps", points: 5, done: totalCompletedSteps >= 10, icon: "checklist.checked", color: Theme.accent, progress: "\(min(totalCompletedSteps, 10))/10")
                checkDivider
                actionCheckRow(label: "Try What If mode", points: 3, done: appState.hasUsedWhatIf, icon: "slider.horizontal.3", color: .orange)
                checkDivider
                actionCheckRow(label: "Share your progress", points: 3, done: appState.hasSharedResult, icon: "square.and.arrow.up", color: .pink)
                checkDivider
                actionCheckRow(label: "3-day streak", points: 3, done: appState.streakTracker.currentStreak >= 3, icon: "flame.fill", color: .orange, progress: "\(min(appState.streakTracker.currentStreak, 3))/3")
                checkDivider
                actionCheckRow(label: "7-day streak", points: 3, done: appState.streakTracker.currentStreak >= 7, icon: "flame.circle.fill", color: .red, progress: "\(min(appState.streakTracker.currentStreak, 7))/7")
                checkDivider
                actionCheckRow(label: "Edit your business plan", points: 2, done: hasEditedPlan, icon: "pencil", color: .orange)
                checkDivider
                actionCheckRow(label: "Complete a weekly challenge", points: 3, done: !appState.completedChallengeWeeks.isEmpty, icon: "calendar.badge.clock", color: Theme.accentBlue)
            }
            .background(Theme.cardBackgroundLight)
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Tips

    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("Next Steps")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
            }

            ForEach(appState.readinessTips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color(hex: "FBBF24"))
                        .padding(.top, 1)
                    Text(tip)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if appState.readinessScore >= 75 {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.subheadline)
                        .foregroundStyle(Theme.accent)
                    Text("You're nearly launch ready! Keep maintaining your streak and completing steps to hit 100.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Row Helpers

    private func profileCheckRow(label: String, earned: Int, max: Int, done: Bool, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .font(.subheadline)
                .foregroundStyle(done ? Color(hex: "34D399") : Theme.textTertiary)
                .frame(width: 24)
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
                .frame(width: 20)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(done ? Theme.textPrimary : Theme.textSecondary)
            Spacer()
            if done {
                Text("+\(earned)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accent)
            } else {
                Text("up to +\(max)")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private func actionCheckRow(label: String, points: Int, done: Bool, icon: String, color: Color, progress: String? = nil) -> some View {
        HStack(spacing: 12) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .font(.subheadline)
                .foregroundStyle(done ? Color(hex: "34D399") : Theme.textTertiary)
                .frame(width: 24)
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
                .frame(width: 20)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(done ? Theme.textPrimary : Theme.textSecondary)
            Spacer()
            if done {
                Text("+\(points)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accentBlue)
            } else if let progress {
                Text(progress)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Theme.textTertiary)
            } else {
                Text("+\(points)")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private var checkDivider: some View {
        Rectangle()
            .fill(Theme.cardBackground)
            .frame(height: 0.5)
            .padding(.leading, 60)
    }

    // MARK: - Computed Helpers

    private var totalCompletedSteps: Int {
        appState.builds.flatMap(\.steps).filter(\.isCompleted).count
    }

    private var hasEditedPlan: Bool {
        appState.builds.contains { !$0.businessName.isEmpty || !$0.pricingNotes.isEmpty || !$0.strategyNotes.isEmpty || !$0.serviceNotes.isEmpty }
    }

    private var levelColor: Color {
        switch appState.readinessScore {
        case 0...25: return .orange
        case 26...50: return Theme.accentBlue
        case 51...75: return Color(hex: "34D399")
        default: return Theme.accent
        }
    }
}
