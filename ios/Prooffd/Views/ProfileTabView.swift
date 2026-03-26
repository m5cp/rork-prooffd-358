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

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        Button {
                            showAvatarPicker = true
                        } label: {
                            ZStack(alignment: .bottomTrailing) {
                                AvatarView(avatar: appState.userProfile.avatar, size: 50)
                                    .overlay {
                                        if store.isPremium {
                                            Circle()
                                                .stroke(
                                                    LinearGradient(colors: [Theme.accent, Theme.accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing),
                                                    lineWidth: 2
                                                )
                                                .frame(width: 54, height: 54)
                                        }
                                    }
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Theme.accent)
                                    .background(Circle().fill(Theme.background).frame(width: 14, height: 14))
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(appState.userProfile.firstName.isEmpty ? "User" : appState.userProfile.firstName)
                                .font(.headline)
                                .foregroundStyle(Theme.textPrimary)
                            Text(store.isPremium ? "Pro Member" : "Free Plan")
                                .font(.caption)
                                .foregroundStyle(store.isPremium ? Theme.accent : Theme.textTertiary)
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }

                Section("Appearance") {
                    themeRow
                }

                Section("Stats") {
                    statsRow(icon: "flame.fill", color: .orange, label: "Streak", value: "\(appState.streakTracker.currentStreak) days")
                    statsRow(icon: "bolt.fill", color: Color(hex: "FBBF24"), label: "Points", value: "\(appState.momentum.totalPoints)")
                    statsRow(icon: "gauge.open.with.lines.needle.33percent.and.arrowtriangle", color: Theme.accent, label: "Readiness", value: "\(appState.readinessScore)/100")
                    statsRow(icon: "hammer.fill", color: Theme.accentBlue, label: "Active Builds", value: "\(appState.builds.count)")
                    statsRow(icon: "eye.fill", color: Color(hex: "818CF8"), label: "Explored", value: "\(appState.exploredPathIDs.count) paths")

                    Button {
                        showAchievements = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "trophy.fill")
                                .foregroundStyle(Color(hex: "818CF8"))
                                .frame(width: 22)
                            Text("Achievements & Badges")
                                .foregroundStyle(Theme.textPrimary)
                            Spacer()
                            Text("\(appState.momentum.earnedBadges.count + appState.unlockedCount)/\(MomentumBadge.all.count + AchievementDatabase.all.count)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textSecondary)
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }
                    .listRowBackground(Theme.cardBackground)

                    Button {
                        showPointsGuide = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundStyle(Color(hex: "FBBF24"))
                                .frame(width: 22)
                            Text("How to Earn Points & Badges")
                                .foregroundStyle(Theme.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }

                Section("Share") {
                    Button {
                        showMyPathShare = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "square.and.arrow.up.fill")
                                .foregroundStyle(Theme.accentBlue)
                                .frame(width: 22)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Share My Path")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(Theme.textPrimary)
                                Text("Show friends your progress")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textTertiary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }

                if !store.isPremium {
                    Section {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(.yellow)
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
                                    .font(.caption)
                                    .foregroundStyle(Theme.textTertiary)
                            }
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                }

                Section("Your Profile") {
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
                    }
                    .listRowBackground(Theme.cardBackground)
                    .sensoryFeedback(.selection, trigger: showProfileDetails)

                    if showProfileDetails {
                        if let budget = appState.userProfile.budget {
                            profileRow(icon: "dollarsign.circle.fill", label: "Budget", value: budget.rawValue)
                        }
                        if let hours = appState.userProfile.hoursPerDay {
                            profileRow(icon: "clock.fill", label: "Hours/Day", value: hours.rawValue)
                        }
                        if let pref = appState.userProfile.workPreference {
                            profileRow(icon: "briefcase.fill", label: "Work Type", value: pref.rawValue)
                        }
                        if let style = appState.userProfile.workStyle {
                            profileRow(icon: "person.2.fill", label: "Work Style", value: style.rawValue)
                        }
                        if let tech = appState.userProfile.techComfort {
                            profileRow(icon: "desktopcomputer", label: "Tech Comfort", value: tech.rawValue)
                        }
                        if let exp = appState.userProfile.experienceLevel {
                            profileRow(icon: "star.fill", label: "Experience", value: exp.rawValue)
                        }
                        if let selling = appState.userProfile.sellingComfort {
                            profileRow(icon: "tag.fill", label: "Selling Comfort", value: selling.rawValue)
                        }
                        if let interaction = appState.userProfile.customerInteraction {
                            profileRow(icon: "person.wave.2.fill", label: "Customer Interaction", value: interaction.rawValue)
                        }
                        if let hasCar = appState.userProfile.hasCar {
                            profileRow(icon: "car.fill", label: "Has Car", value: hasCar ? "Yes" : "No")
                        }
                        if let fastCash = appState.userProfile.needsFastCash {
                            profileRow(icon: "bolt.fill", label: "Needs Fast Cash", value: fastCash ? "Yes" : "No")
                        }
                        if !appState.userProfile.selectedCategories.isEmpty {
                            profileRow(icon: "square.grid.2x2.fill", label: "Interests", value: appState.userProfile.selectedCategories.map(\.rawValue).joined(separator: ", "))
                        }
                        if !appState.userProfile.workConditions.isEmpty {
                            profileRow(icon: "wrench.and.screwdriver.fill", label: "Work Conditions", value: appState.userProfile.workConditions.map(\.rawValue).joined(separator: ", "))
                        }
                    }

                    Button {
                        showRetakeConfirm = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundStyle(Theme.accent)
                            Text("Retake Profile Quiz")
                                .foregroundStyle(Theme.accent)
                            Spacer()
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }

                Section("Notifications") {
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
                    .listRowBackground(Theme.cardBackground)

                    if NotificationService.shared.notificationsEnabled {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(Theme.textTertiary)
                                .frame(width: 22)
                            Text("You'll receive friendly reminders to keep your streak going, complete steps, and stay on track.")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                                .lineSpacing(2)
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                }

                Section("Subscription") {
                    if store.isPremium {
                        Button {
                            if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .foregroundStyle(Theme.accent)
                                Text("Manage Subscription")
                                    .foregroundStyle(Theme.textPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textTertiary)
                            }
                        }
                        .listRowBackground(Theme.cardBackground)
                    }

                    Button {
                        Task { await store.restore() }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundStyle(Theme.accentBlue)
                            Text("Restore Purchases")
                                .foregroundStyle(Theme.accentBlue)
                            Spacer()
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }

                Section("Support") {
                    Button {
                        if let url = URL(string: "https://gist.github.com/m5cp/c630ed25e00a4a0e80702603e7093a16") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundStyle(Theme.accentBlue)
                            Text("Support")
                                .foregroundStyle(Theme.textPrimary)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }

                Section("Legal") {
                    NavigationLink {
                        TermsOfServiceView()
                    } label: {
                        Label("Terms of Use", systemImage: "doc.text")
                            .foregroundStyle(Theme.textPrimary)
                    }
                    .listRowBackground(Theme.cardBackground)

                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                            .foregroundStyle(Theme.textPrimary)
                    }
                    .listRowBackground(Theme.cardBackground)

                    NavigationLink {
                        DisclaimerView()
                    } label: {
                        Label("Disclaimer", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(Theme.textPrimary)
                    }
                    .listRowBackground(Theme.cardBackground)

                    NavigationLink {
                        AccessibilityView()
                    } label: {
                        Label("Accessibility", systemImage: "accessibility")
                            .foregroundStyle(Theme.textPrimary)
                    }
                    .listRowBackground(Theme.cardBackground)
                }

                Section {
                    HStack {
                        Spacer()
                        Text("Prooffd v1.1")
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listSectionSpacing(12)
            .scrollContentBackground(.hidden)
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
            .sheet(isPresented: $showAvatarPicker) {
                AvatarPickerView(selectedAvatar: Binding(
                    get: { appState.userProfile.avatar },
                    set: { appState.updateAvatar($0) }
                ))
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
        .listRowBackground(Theme.cardBackground)
    }

    private func statsRow(icon: String, color: Color, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 22)
            Text(label)
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textSecondary)
        }
        .listRowBackground(Theme.cardBackground)
    }

    private func profileRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Theme.accent)
                .frame(width: 22)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .listRowBackground(Theme.cardBackground)
    }
}
