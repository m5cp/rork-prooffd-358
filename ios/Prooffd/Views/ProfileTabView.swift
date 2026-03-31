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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    statsRow
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
                if let build = appState.activeBuild {
                    ShareCardPresenterSheet(content: .progress(from: build))
                } else if let topMatch = appState.matchResults.first {
                    ShareCardPresenterSheet(content: .topMatch(from: topMatch))
                }
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

    private var profileHeader: some View {
        HStack(spacing: 16) {
            Button {
                showAvatarPicker = true
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    AvatarView(avatar: appState.userProfile.avatar, size: 64)
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white, Theme.accent)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
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

                if store.isPremium {
                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.yellow)
                        Text("Pro")
                            .font(.caption.weight(.bold))
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
        .padding(20)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 18))
        .cardShadow()
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            statCell(
                value: "\(appState.streakTracker.currentStreak)",
                label: "Streak",
                icon: "flame.fill",
                color: appState.streakTracker.currentStreak > 0 ? .orange : Theme.textTertiary
            )

            statCell(
                value: "\(appState.builds.count)",
                label: "Builds",
                icon: "list.bullet.clipboard",
                color: Theme.accent
            )

            Button {
                showAchievements = true
            } label: {
                let totalEarned = MomentumBadge.all.filter { appState.momentum.hasBadge($0.id) }.count + AchievementDatabase.all.filter { appState.isAchievementUnlocked($0.id) }.count
                statCellContent(
                    value: "\(totalEarned)",
                    label: "Badges",
                    icon: "trophy.fill",
                    color: Color(hex: "FBBF24")
                )
            }
            .buttonStyle(.plain)
        }
    }

    private func statCell(value: String, label: String, icon: String, color: Color) -> some View {
        statCellContent(value: value, label: label, icon: icon, color: color)
    }

    private func statCellContent(value: String, label: String, icon: String, color: Color) -> some View {
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
                            Text("Templates, scripts & exports")
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

            settingsLink(icon: "square.and.arrow.up.fill", color: Theme.accentBlue, title: "Share My Path") {
                showMyPathShare = true
            }
            settingsDivider

            themeRow
            settingsDivider

            HStack(spacing: 12) {
                Image(systemName: "bell.fill")
                    .foregroundStyle(Theme.accent)
                    .frame(width: 22)
                Toggle("Reminders", isOn: Binding(
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
                    if !appState.userProfile.selectedCategories.isEmpty {
                        profileDetailRow(label: "Interests", value: appState.userProfile.selectedCategories.map(\.rawValue).joined(separator: ", "))
                    }
                    if !appState.userProfile.workEnvironments.isEmpty {
                        profileDetailRow(label: "Work Environment", value: appState.userProfile.workEnvironments.map(\.rawValue).joined(separator: ", "))
                    }
                    if !appState.userProfile.workConditions.isEmpty {
                        profileDetailRow(label: "Conditions OK", value: appState.userProfile.workConditions.map(\.rawValue).joined(separator: ", "))
                    }
                    if !appState.userProfile.situationTags.isEmpty {
                        profileDetailRow(label: "Situation", value: appState.userProfile.situationTags.map(\.rawValue).joined(separator: ", "))
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
