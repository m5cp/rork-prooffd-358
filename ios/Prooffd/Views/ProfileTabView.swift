import SwiftUI

struct ProfileTabView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @Environment(ThemeManager.self) private var themeManager
    @State private var showPaywall: Bool = false
    @State private var showRetakeConfirm: Bool = false
    @State private var showProfileDetails: Bool = false
    @State private var showAchievements: Bool = false
    @State private var showMyPathShare: Bool = false
    @State private var showAvatarPicker: Bool = false
    @State private var showPointsGuide: Bool = false
    @State private var showReadinessDetail: Bool = false
    @State private var showNameEdit: Bool = false
    @State private var editingName: String = ""
    @State private var showAnalytics: Bool = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroProgressSection
                    streakSection
                    achievementsSection
                    secondaryStatsSection
                    actionsSection
                    settingsSection
                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showAchievements) {
                AchievementsView()
            }
            .sheet(isPresented: $showMyPathShare) {
                let build = appState.activeBuild
                ShareableCardSheet(
                    cardContent: AnyView(
                        MyPathShareCard(
                            userName: appState.userProfile.firstName,
                            selectedJob: build?.pathName ?? "Exploring",
                            progressPercent: build?.progressPercentage ?? 0,
                            streakDays: appState.streakTracker.currentStreak,
                            aiSafeScore: build?.aiSafeScore ?? 0,
                            totalPoints: appState.momentum.totalPoints
                        )
                    ),
                    shareText: "I'm building a business step-by-step with Prooffd! Download Prooffd: https://apps.apple.com/app/prooffd/id6743071053"
                )
            }
            .sheet(isPresented: $showPointsGuide) {
                PointsGuideView()
            }
            .sheet(isPresented: $showReadinessDetail) {
                ReadinessDetailView()
            }
            .sheet(isPresented: $showAnalytics) {
                AnalyticsDashboardView()
            }
            .sheet(isPresented: $showAvatarPicker) {
                AvatarPickerView(selectedAvatar: Binding(
                    get: { appState.userProfile.avatar },
                    set: { appState.updateAvatar($0) }
                ))
            }
            .alert("Edit Name", isPresented: $showNameEdit) {
                TextField("Your name", text: $editingName)
                    .textInputAutocapitalization(.words)
                Button("Save") {
                    let trimmed = editingName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        appState.updateName(trimmed)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter your display name")
            }
            .alert("Retake Quiz?", isPresented: $showRetakeConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Retake", role: .destructive) {
                    appState.retakeQuiz()
                }
            } message: {
                Text("This will reset your profile and match results. You can retake the quiz to get new matches.")
            }
        }
    }

    // MARK: - Hero Progress Section

    private var heroProgressSection: some View {
        let level = appState.currentLevel
        let levelColor = Color(hex: level.color)
        let progress = level.progressToNext(points: appState.momentum.totalPoints)

        return VStack(spacing: 20) {
            HStack(spacing: 16) {
                Button {
                    showAvatarPicker = true
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        AvatarView(avatar: appState.userProfile.avatar, size: 64)
                            .overlay {
                                if store.isPremium {
                                    Circle()
                                        .stroke(
                                            LinearGradient(colors: [Theme.accent, Theme.accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing),
                                            lineWidth: 2.5
                                        )
                                        .frame(width: 68, height: 68)
                                }
                            }
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Theme.accent)
                            .background(Circle().fill(Theme.cardBackground).frame(width: 16, height: 16))
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Button {
                        editingName = appState.userProfile.firstName
                        showNameEdit = true
                    } label: {
                        HStack(spacing: 6) {
                            Text(appState.userProfile.firstName.isEmpty ? "User" : appState.userProfile.firstName)
                                .font(.title3.weight(.bold))
                                .foregroundStyle(Theme.textPrimary)
                            Image(systemName: "pencil")
                                .font(.caption2)
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }

                    HStack(spacing: 6) {
                        Image(systemName: level.icon)
                            .font(.caption)
                            .foregroundStyle(levelColor)
                        Text("Level \(level.rank) \u{2014} \(level.title)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(levelColor)
                    }

                    if store.isPremium {
                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 9))
                                .foregroundStyle(.yellow)
                            Text("Pro Member")
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(Theme.accent)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Theme.accent.opacity(0.1))
                        .clipShape(.capsule)
                    }
                }

                Spacer()
            }

            VStack(spacing: 8) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Theme.cardBackgroundLight)
                            .frame(height: 8)
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [levelColor.opacity(0.7), levelColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * progress, height: 8)
                    }
                }
                .frame(height: 8)

                HStack {
                    Text("\(appState.momentum.totalPoints) pts")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(levelColor)
                    Spacer()
                    if let next = UserLevel.nextLevel(after: level) {
                        Text("\(next.minPoints - appState.momentum.totalPoints) pts to \(next.title)")
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                    } else {
                        Text("Max level reached")
                            .font(.caption)
                            .foregroundStyle(levelColor)
                    }
                }
            }

            Text(progressMessage)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [levelColor.opacity(0.06), Theme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(levelColor.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: levelColor.opacity(0.1), radius: 12, y: 4)
    }

    private var progressMessage: String {
        let points = appState.momentum.totalPoints
        switch points {
        case 0..<10: return "Take the first step \u{2014} every journey starts somewhere."
        case 10..<50: return "You're off to a great start. Keep exploring!"
        case 50..<150: return "You're building real momentum. Keep it up!"
        case 150..<350: return "Impressive progress \u{2014} you're ahead of most."
        case 350..<700: return "You're in the top tier. Launch mode activated."
        default: return "You've mastered the path. Unstoppable."
        }
    }

    // MARK: - Streak Section

    private var streakSection: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(appState.streakTracker.currentStreak > 0 ? Color.orange.opacity(0.12) : Theme.cardBackgroundLight)
                    .frame(width: 48, height: 48)
                Image(systemName: "flame.fill")
                    .font(.title3)
                    .foregroundStyle(appState.streakTracker.currentStreak > 0 ? .orange : Theme.textTertiary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(appState.streakTracker.currentStreak > 0
                    ? "\(appState.streakTracker.currentStreak) Day Streak"
                    : "Start Your Streak")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Text(appState.streakTracker.streakMessage)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            if appState.streakTracker.streakBufferAvailable && appState.streakTracker.currentStreak >= 2 {
                HStack(spacing: 4) {
                    Image(systemName: "shield.fill")
                        .font(.system(size: 9))
                    Text("Protected")
                        .font(.caption2.weight(.medium))
                }
                .foregroundStyle(Theme.accent)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Theme.accent.opacity(0.1))
                .clipShape(.capsule)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(appState.streakTracker.currentStreak > 0 ? Color.orange.opacity(0.12) : Theme.border.opacity(0.3), lineWidth: 0.5)
        )
        .cardShadow()
    }

    // MARK: - Achievements Section

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color(hex: "818CF8"))
                    Text("Achievements")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                }
                Spacer()
                Button {
                    showAchievements = true
                } label: {
                    Text("See All")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
            }

            let earnedBadges = MomentumBadge.all.filter { appState.momentum.hasBadge($0.id) }
            let earnedAchievements = AchievementDatabase.all.filter { appState.isAchievementUnlocked($0.id) }

            if earnedBadges.isEmpty && earnedAchievements.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "trophy")
                        .font(.title2)
                        .foregroundStyle(Theme.textTertiary)
                    Text("Complete actions to earn badges")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
                .cardShadow()
            } else {
                let columns = [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ]

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(earnedBadges) { badge in
                        earnedBadgeCell(badge)
                    }
                    ForEach(earnedAchievements) { achievement in
                        earnedAchievementCell(achievement)
                    }
                }
            }
        }
    }

    private func earnedBadgeCell(_ badge: MomentumBadge) -> some View {
        let color = Color(hex: badge.color)
        return VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: badge.icon)
                    .font(.body)
                    .foregroundStyle(color)
            }
            Text(badge.title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.04))
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.15), lineWidth: 0.5)
        )
    }

    private func earnedAchievementCell(_ achievement: Achievement) -> some View {
        let color = Color(hex: achievement.color)
        return VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: achievement.icon)
                    .font(.body)
                    .foregroundStyle(color)
            }
            Text(achievement.title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.04))
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.15), lineWidth: 0.5)
        )
    }

    // MARK: - Secondary Stats

    private var secondaryStatsSection: some View {
        let columns = sizeClass == .regular
            ? [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
            : [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

        return LazyVGrid(columns: columns, spacing: 10) {
            statCell(icon: "hammer.fill", color: Theme.accentBlue, label: "Builds", value: "\(appState.builds.count)")
            statCell(icon: "eye.fill", color: Color(hex: "818CF8"), label: "Explored", value: "\(appState.exploredPathIDs.count)")
            statCell(icon: "heart.fill", color: .pink, label: "Favorites", value: "\(appState.favoritePathIDs.count)")
            statCell(icon: "calendar", color: Theme.accent, label: "Total Days", value: "\(appState.streakTracker.totalDaysOpened)")
        }
    }

    private func statCell(icon: String, color: Color, label: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(color)
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.textPrimary)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    // MARK: - Actions

    private var actionsSection: some View {
        VStack(spacing: 0) {
            actionRow(icon: "gauge.open.with.lines.needle.33percent.and.arrowtriangle", color: Theme.accent, title: "Readiness Score", detail: "\(appState.readinessScore)/100") {
                showReadinessDetail = true
            }
            actionDivider
            actionRow(icon: "square.and.arrow.up.fill", color: Theme.accentBlue, title: "Share My Path", detail: nil) {
                showMyPathShare = true
            }
            actionDivider
            actionRow(icon: "chart.bar.fill", color: Theme.accent, title: "Engagement Dashboard", detail: nil) {
                showAnalytics = true
            }
            actionDivider
            actionRow(icon: "questionmark.circle.fill", color: Color(hex: "FBBF24"), title: "How to Earn Points", detail: nil) {
                showPointsGuide = true
            }
        }
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private func actionRow(icon: String, color: Color, title: String, detail: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 22)
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                if let detail {
                    Text(detail)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textSecondary)
                }
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
        }
    }

    private var actionDivider: some View {
        Rectangle()
            .fill(Theme.cardBackgroundLight)
            .frame(height: 0.5)
            .padding(.leading, 50)
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(spacing: 0) {
            if !store.isPremium {
                Button {
                    showPaywall = true
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.yellow)
                            .frame(width: 22)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Upgrade to Pro")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            Text("Unlock all templates, scripts & exports")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                }
                settingsDivider
            }

            themeRow
            settingsDivider

            HStack(spacing: 12) {
                Image(systemName: "bell.fill")
                    .foregroundStyle(Theme.accent)
                    .frame(width: 22)
                Toggle("Gentle Reminders", isOn: Binding(
                    get: { NotificationService.shared.notificationsEnabled },
                    set: { newValue in
                        if newValue {
                            NotificationService.shared.enableNotifications()
                        } else {
                            NotificationService.shared.disableNotifications()
                        }
                    }
                ))
                .foregroundStyle(Theme.textPrimary)
                .tint(Theme.accent)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            settingsDivider

            profileDetailsRow
            settingsDivider

            if store.isPremium {
                settingsLink(icon: "creditcard.fill", color: Theme.accent, title: "Manage Subscription", external: true) {
                    if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                        UIApplication.shared.open(url)
                    }
                }
                settingsDivider
            }

            settingsLink(icon: "arrow.counterclockwise", color: Theme.accentBlue, title: "Restore Purchases") {
                Task { await store.restore() }
            }
            settingsDivider
            settingsLink(icon: "questionmark.circle.fill", color: Theme.accentBlue, title: "Support", external: true) {
                if let url = URL(string: "https://gist.github.com/m5cp/c630ed25e00a4a0e80702603e7093a16") {
                    UIApplication.shared.open(url)
                }
            }
            settingsDivider

            NavigationLink {
                TermsOfServiceView()
            } label: {
                settingsRowContent(icon: "doc.text", color: Theme.textSecondary, title: "Terms of Use")
            }
            settingsDivider
            NavigationLink {
                PrivacyPolicyView()
            } label: {
                settingsRowContent(icon: "hand.raised.fill", color: Theme.textSecondary, title: "Privacy Policy")
            }
            settingsDivider
            NavigationLink {
                DisclaimerView()
            } label: {
                settingsRowContent(icon: "exclamationmark.triangle.fill", color: Theme.textSecondary, title: "Disclaimer")
            }
            settingsDivider
            NavigationLink {
                AccessibilityView()
            } label: {
                settingsRowContent(icon: "accessibility", color: Theme.textSecondary, title: "Accessibility")
            }
        }
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private var themeRow: some View {
        HStack(spacing: 12) {
            Image(systemName: themeManager.mode.icon)
                .foregroundStyle(Theme.accent)
                .frame(width: 22)
            Text("Theme")
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            Picker("", selection: Binding(
                get: { themeManager.mode },
                set: { themeManager.mode = $0 }
            )) {
                ForEach(AppThemeMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var profileDetailsRow: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    showProfileDetails.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "person.text.rectangle.fill")
                        .foregroundStyle(Theme.accent)
                        .frame(width: 22)
                    Text("View My Answers")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    Image(systemName: showProfileDetails ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 13)
            }
            .sensoryFeedback(.selection, trigger: showProfileDetails)

            if showProfileDetails {
                VStack(spacing: 0) {
                    if let budget = appState.userProfile.budget {
                        profileDetailRow(label: "Budget", value: budget.rawValue)
                    }
                    if let hours = appState.userProfile.hoursPerDay {
                        profileDetailRow(label: "Hours/Day", value: hours.rawValue)
                    }
                    if let pref = appState.userProfile.workPreference {
                        profileDetailRow(label: "Work Type", value: pref.rawValue)
                    }
                    if let style = appState.userProfile.workStyle {
                        profileDetailRow(label: "Work Style", value: style.rawValue)
                    }
                    if let tech = appState.userProfile.techComfort {
                        profileDetailRow(label: "Tech Comfort", value: tech.rawValue)
                    }
                    if let exp = appState.userProfile.experienceLevel {
                        profileDetailRow(label: "Experience", value: exp.rawValue)
                    }
                    if !appState.userProfile.selectedCategories.isEmpty {
                        profileDetailRow(label: "Interests", value: appState.userProfile.selectedCategories.map(\.rawValue).joined(separator: ", "))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }

            Button {
                showRetakeConfirm = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundStyle(Theme.accent)
                        .frame(width: 22)
                    Text("Retake Profile Quiz")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.accent)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 13)
            }
        }
    }

    private func profileDetailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
            Spacer()
            Text(value)
                .font(.caption.weight(.medium))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.vertical, 6)
    }

    private func settingsLink(icon: String, color: Color, title: String, external: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 22)
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Image(systemName: external ? "arrow.up.right" : "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
        }
    }

    private func settingsRowContent(icon: String, color: Color, title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 22)
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    private var settingsDivider: some View {
        Rectangle()
            .fill(Theme.cardBackgroundLight)
            .frame(height: 0.5)
            .padding(.leading, 50)
    }
}
