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
    @State private var showNameEdit: Bool = false
    @State private var editingName: String = ""
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    heroSection
                    streakCard
                    achievementsGrid
                    quickActions
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

    // MARK: - Hero Section

    private var heroSection: some View {
        let level = appState.currentLevel
        let levelColor = Color(hex: level.color)
        let progress = level.progressToNext(points: appState.momentum.totalPoints)

        return VStack(spacing: 0) {
            VStack(spacing: 24) {
                HStack(spacing: 16) {
                    Button {
                        showAvatarPicker = true
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            AvatarView(avatar: appState.userProfile.avatar, size: 72)
                                .overlay {
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [levelColor.opacity(0.8), levelColor.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                        .frame(width: 78, height: 78)
                                }
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                                .background(Circle().fill(levelColor).frame(width: 18, height: 18))
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Button {
                            editingName = appState.userProfile.firstName
                            showNameEdit = true
                        } label: {
                            HStack(spacing: 6) {
                                Text(appState.userProfile.firstName.isEmpty ? "User" : appState.userProfile.firstName)
                                    .font(.title2.weight(.bold))
                                    .foregroundStyle(Theme.textPrimary)
                                Image(systemName: "pencil")
                                    .font(.caption2)
                                    .foregroundStyle(Theme.textTertiary)
                            }
                        }

                        HStack(spacing: 8) {
                            HStack(spacing: 5) {
                                Image(systemName: level.icon)
                                    .font(.caption.weight(.semibold))
                                Text("Level \(level.rank)")
                                    .font(.subheadline.weight(.bold))
                            }
                            .foregroundStyle(levelColor)

                            Text(level.title)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Theme.textSecondary)
                        }

                        if store.isPremium {
                            HStack(spacing: 4) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.yellow)
                                Text("Pro")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(Theme.accent)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Theme.accent.opacity(0.1))
                            .clipShape(.capsule)
                        }
                    }

                    Spacer()
                }

                VStack(spacing: 10) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(levelColor.opacity(0.12))
                                .frame(height: 10)
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [levelColor, levelColor.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(geo.size.width * progress, 6), height: 10)
                        }
                    }
                    .frame(height: 10)

                    HStack {
                        Text("\(appState.momentum.totalPoints) pts")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(levelColor)
                        Spacer()
                        if let next = UserLevel.nextLevel(after: level) {
                            Text("\(next.minPoints - appState.momentum.totalPoints) to \(next.title)")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                        } else {
                            Text("Max level")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(levelColor)
                        }
                    }
                }

                Text(progressMessage)
                    .font(.callout)
                    .foregroundStyle(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(24)
        }
        .background(
            ZStack {
                Theme.cardBackground
                LinearGradient(
                    colors: [levelColor.opacity(0.08), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .clipShape(.rect(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(levelColor.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: levelColor.opacity(0.08), radius: 16, y: 6)
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

    // MARK: - Streak

    private var streakCard: some View {
        let isActive = appState.streakTracker.currentStreak > 0

        return HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isActive ? Color.orange.opacity(0.12) : Theme.cardBackgroundLight)
                    .frame(width: 52, height: 52)
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundStyle(isActive ? .orange : Theme.textTertiary)
                    .symbolEffect(.pulse, options: .repeating.speed(0.5), isActive: appState.streakTracker.currentStreak >= 7)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(isActive ? "\(appState.streakTracker.currentStreak)" : "0")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(isActive ? .orange : Theme.textTertiary)
                        .contentTransition(.numericText())
                    Text(appState.streakTracker.currentStreak == 1 ? "day" : "days")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textSecondary)
                }
                Text(appState.streakTracker.streakMessage)
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                    .lineLimit(1)
            }

            Spacer()

            if appState.streakTracker.streakBufferAvailable && appState.streakTracker.currentStreak >= 2 {
                VStack(spacing: 2) {
                    Image(systemName: "shield.fill")
                        .font(.caption)
                    Text("Protected")
                        .font(.system(size: 9, weight: .semibold))
                }
                .foregroundStyle(Theme.accent)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Theme.accent.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
        .padding(18)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isActive ? Color.orange.opacity(0.1) : Theme.border.opacity(0.3), lineWidth: 0.5)
        )
        .cardShadow()
    }

    // MARK: - Achievements

    private var achievementsGrid: some View {
        let earnedBadges = MomentumBadge.all.filter { appState.momentum.hasBadge($0.id) }
        let earnedAchievements = AchievementDatabase.all.filter { appState.isAchievementUnlocked($0.id) }
        let totalEarned = earnedBadges.count + earnedAchievements.count
        let totalAvailable = MomentumBadge.all.count + AchievementDatabase.all.count

        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Achievements")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Button {
                    showAchievements = true
                } label: {
                    HStack(spacing: 4) {
                        Text("\(totalEarned)/\(totalAvailable)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.textSecondary)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
            }

            if totalEarned == 0 {
                VStack(spacing: 10) {
                    Image(systemName: "trophy")
                        .font(.largeTitle)
                        .foregroundStyle(Theme.textTertiary.opacity(0.5))
                    Text("Complete actions to unlock badges")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 16))
                .cardShadow()
            } else {
                let columns = [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ]

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(earnedBadges) { badge in
                        badgeCell(icon: badge.icon, title: badge.title, color: Color(hex: badge.color))
                    }
                    ForEach(earnedAchievements) { achievement in
                        badgeCell(icon: achievement.icon, title: achievement.title, color: Color(hex: achievement.color))
                    }
                }
            }
        }
    }

    private func badgeCell(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.body.weight(.medium))
                    .foregroundStyle(color)
            }
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(color.opacity(0.04))
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.12), lineWidth: 0.5)
        )
    }

    // MARK: - Quick Actions

    private var quickActions: some View {
        VStack(spacing: 0) {
            actionRow(icon: "square.and.arrow.up.fill", color: Theme.accentBlue, title: "Share My Path") {
                showMyPathShare = true
            }
        }
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .cardShadow()
    }

    private func actionRow(icon: String, color: Color, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
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
            .padding(.vertical, 14)
        }
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
        .clipShape(.rect(cornerRadius: 16))
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
