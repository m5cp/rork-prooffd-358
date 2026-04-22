import SwiftUI

struct ProgressTabView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var showLogWin = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    myPathHeroSection
                    milestoneSection
                    realWorldWinsSection
                    readinessSection
                    streakSection
                    achievementsSection
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Theme.background, for: .navigationBar)
        }
    }

    private var streakSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.orange)
                Text("Daily Streak")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            .padding(.bottom, 14)

            Group {
                if dynamicTypeSize.isAccessibilitySize {
                    VStack(spacing: 12) {
                        streakStat(
                            value: "\(appState.streakTracker.currentStreak)",
                            label: "Current",
                            color: .orange,
                            icon: "flame.fill"
                        )
                        streakStat(
                            value: "\(appState.streakTracker.longestStreak)",
                            label: "Best",
                            color: Color(hex: "FBBF24"),
                            icon: "trophy.fill"
                        )
                        streakStat(
                            value: "\(appState.streakTracker.totalDaysOpened)",
                            label: "Total Days",
                            color: Theme.accentBlue,
                            icon: "calendar"
                        )
                    }
                } else {
                    HStack(spacing: 20) {
                        streakStat(
                            value: "\(appState.streakTracker.currentStreak)",
                            label: "Current",
                            color: .orange,
                            icon: "flame.fill"
                        )
                        streakStat(
                            value: "\(appState.streakTracker.longestStreak)",
                            label: "Best",
                            color: Color(hex: "FBBF24"),
                            icon: "trophy.fill"
                        )
                        streakStat(
                            value: "\(appState.streakTracker.totalDaysOpened)",
                            label: "Total Days",
                            color: Theme.accentBlue,
                            icon: "calendar"
                        )
                    }
                }
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color.orange.opacity(0.08), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.orange.opacity(0.15), lineWidth: 1)
            )

            Text(appState.streakTracker.streakMessage)
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)

            streakFreezeNotice
        }
    }

    @ViewBuilder
    private var streakFreezeNotice: some View {
        if appState.streakTracker.streakFreezeJustUsed {
            HStack(spacing: 8) {
                Image(systemName: "snowflake")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
                Text("Streak Freeze used — we covered the day you missed this week.")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                Spacer(minLength: 0)
            }
            .padding(10)
            .background(Theme.accentBlue.opacity(0.08))
            .clipShape(.rect(cornerRadius: 10))
            .padding(.top, 8)
            .onAppear { appState.streakTracker.acknowledgeFreezeUsed() }
        } else if !appState.streakTracker.streakFreezeAvailable {
            Text("Streak freeze already used this week.")
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
                .padding(.top, 6)
        }
    }

    private func streakStat(value: String, label: String, color: Color, icon: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(color)
            }
            .accessibilityHidden(true)
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(Theme.textPrimary)
            Text(label)
                .font(.caption2.weight(.medium))
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)")
    }

    private var readinessSection: some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "gauge.open.with.lines.needle.33percent.and.arrowtriangle")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Text("Readiness Score")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Theme.cardBackgroundLight, lineWidth: 8)
                        .frame(width: 120, height: 120)
                    Circle()
                        .trim(from: 0, to: Double(appState.readinessScore) / 100.0)
                        .stroke(
                            readinessGradient,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .accessibilityHidden(true)
                    VStack(spacing: 2) {
                        Text("\(appState.readinessScore)")
                            .font(.title.bold())
                            .foregroundStyle(Theme.textPrimary)
                        Text("/ 100")
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                Text(appState.readinessLevel)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(readinessColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(readinessColor.opacity(0.12))
                    .clipShape(.capsule)

                HStack(spacing: 16) {
                    readinessBreakdown(
                        label: "Profile",
                        value: appState.profileReadinessScore,
                        max: 50,
                        color: Theme.accent
                    )
                    readinessBreakdown(
                        label: "Actions",
                        value: appState.actionReadinessScore,
                        max: 50,
                        color: Theme.accentBlue
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Tips to improve")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.textTertiary)

                    ForEach(appState.readinessTips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .font(.caption2)
                                .foregroundStyle(Color(hex: "FBBF24"))
                                .padding(.top, 2)
                            Text(tip)
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [Theme.accent.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accent.opacity(0.15), lineWidth: 1)
            )
        }
    }

    private func readinessBreakdown(label: String, value: Int, max: Int, color: Color) -> some View {
        VStack(spacing: 6) {
            Text("\(value)/\(max)")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.textPrimary)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Theme.cardBackgroundLight)
                        .frame(height: 6)
                    Capsule()
                        .fill(color)
                        .frame(width: geo.size.width * (Double(value) / Double(max)), height: 6)
                }
            }
            .frame(height: 6)
            Text(label)
                .font(.caption2.weight(.medium))
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }

    private var readinessGradient: AngularGradient {
        AngularGradient(
            colors: [Theme.accent, Theme.accentBlue, Theme.accent],
            center: .center,
            startAngle: .degrees(-90),
            endAngle: .degrees(270)
        )
    }

    private var readinessColor: Color {
        switch appState.readinessScore {
        case 0...25: return .orange
        case 26...50: return Theme.accentBlue
        case 51...75: return Color(hex: "34D399")
        default: return Theme.accent
        }
    }

    private var myPathHeroSection: some View {
        Group {
            if let path = appState.myPath {
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Text(path.icon).font(.title)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("My Path")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Theme.textSecondary)
                            Text(path.name)
                                .font(.headline)
                                .foregroundStyle(Theme.textPrimary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 3) {
                            Text("\(path.matchScore)%")
                                .font(.title2.weight(.bold))
                                .foregroundStyle(Theme.accent)
                            Text("match")
                                .font(.caption2)
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                    .padding(16)

                    Divider().background(Theme.border).padding(.horizontal, 16)

                    let completed = path.milestones.filter { $0.isCompleted }.count
                    let total = max(path.milestones.count, 1)

                    VStack(spacing: 8) {
                        HStack {
                            Text("\(completed) of \(total) milestones complete")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                            Spacer()
                            Text("\(Int(Double(completed) / Double(total) * 100))%")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.accent)
                        }
                        ProgressView(value: Double(completed), total: Double(total))
                            .tint(Theme.accent)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(
                    LinearGradient(
                        colors: [Theme.accent.opacity(0.06), Theme.cardBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accent.opacity(0.2), lineWidth: 1))
            } else {
                Button {
                    appState.selectedTab = 0
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Theme.accent.opacity(0.12))
                                .frame(width: 40, height: 40)
                            Image(systemName: "flag.fill")
                                .foregroundStyle(Theme.accent)
                                .font(.system(size: 18))
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Set Your Path")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            Text("Commit to a career and unlock your milestone checklist")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Theme.textTertiary)
                            .font(.caption)
                    }
                    .padding(14)
                    .background(Theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.border, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private var milestoneSection: some View {
        if let path = appState.myPath {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "checklist")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                    Text("Milestones")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }

                VStack(spacing: 8) {
                    ForEach(path.milestones) { milestone in
                        Button {
                            if !milestone.isCompleted {
                                withAnimation(.spring(response: 0.3)) {
                                    appState.completeMilestone(id: milestone.id)
                                }
                            }
                        } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(milestone.isCompleted ? Theme.accent : Theme.cardBackgroundLight)
                                        .frame(width: 28, height: 28)
                                    if milestone.isCompleted {
                                        Image(systemName: "checkmark")
                                            .font(.caption.weight(.bold))
                                            .foregroundStyle(.black)
                                    } else {
                                        Image(systemName: milestone.category.icon)
                                            .font(.system(size: 11))
                                            .foregroundStyle(Theme.textTertiary)
                                    }
                                }
                                Text(milestone.title)
                                    .font(.subheadline)
                                    .foregroundStyle(milestone.isCompleted ? Theme.textSecondary : Theme.textPrimary)
                                    .strikethrough(milestone.isCompleted, color: Theme.textTertiary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if let date = milestone.dateCompleted {
                                    Text(date.formatted(.relative(presentation: .named)))
                                        .font(.caption2)
                                        .foregroundStyle(Theme.textTertiary)
                                }
                            }
                            .padding(12)
                            .background(milestone.isCompleted ? Theme.cardBackgroundLight : Theme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(milestone.isCompleted ? Theme.accent.opacity(0.15) : Theme.border, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var realWorldWinsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "trophy.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("Real-World Wins")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Button {
                    showLogWin = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.caption.weight(.bold))
                        Text("Log Win")
                            .font(.caption.weight(.bold))
                    }
                    .foregroundStyle(.black)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Theme.accent)
                    .clipShape(Capsule())
                }
            }

            if appState.realWorldWins.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "flag.fill")
                        .foregroundStyle(Theme.textTertiary)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Log your first real-world win")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                        Text("Made a call, sent an email, bought a tool \u{2014} it all counts")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    Spacer(minLength: 0)
                }
                .padding(14)
                .background(Theme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.border, lineWidth: 1))
            } else {
                VStack(spacing: 8) {
                    ForEach(appState.realWorldWins.prefix(10)) { win in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "FBBF24").opacity(0.15))
                                    .frame(width: 36, height: 36)
                                Image(systemName: WinType.allCases.first {
                                    $0.rawValue == win.title
                                }?.icon ?? "star.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(hex: "FBBF24"))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(win.title)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.textPrimary)
                                if !win.note.isEmpty {
                                    Text(win.note)
                                        .font(.caption)
                                        .foregroundStyle(Theme.textSecondary)
                                        .lineLimit(1)
                                }
                            }
                            Spacer()
                            Text(win.date.formatted(.relative(presentation: .named)))
                                .font(.caption2)
                                .foregroundStyle(Theme.textTertiary)
                        }
                        .padding(12)
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Theme.border, lineWidth: 1))
                        .contextMenu {
                            Button(role: .destructive) {
                                appState.deleteRealWorldWin(id: win.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showLogWin) {
            LogWinView()
        }
    }

    private var achievementsSection: some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "medal.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("Achievements")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text("\(appState.unlockedCount)/\(AchievementDatabase.all.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textTertiary)
            }

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(AchievementDatabase.all) { achievement in
                    achievementCard(achievement)
                }
            }
        }
    }

    private func achievementCard(_ achievement: Achievement) -> some View {
        let isUnlocked = appState.isAchievementUnlocked(achievement.id)
        let color = Color(hex: achievement.color)

        return VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? color.opacity(0.15) : Theme.cardBackgroundLight)
                    .frame(width: 44, height: 44)
                Image(systemName: achievement.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isUnlocked ? color : Theme.textTertiary.opacity(0.5))
            }

            VStack(spacing: 3) {
                Text(achievement.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(isUnlocked ? Theme.textPrimary : Theme.textTertiary)
                    .lineLimit(1)
                Text(achievement.description)
                    .font(.caption2)
                    .foregroundStyle(isUnlocked ? Theme.textSecondary : Theme.textTertiary.opacity(0.6))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background(isUnlocked ? color.opacity(0.05) : Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isUnlocked ? color.opacity(0.2) : Theme.cardBackgroundLight, lineWidth: 1)
        )
        .opacity(isUnlocked ? 1 : 0.6)
    }
}
