import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall: Bool = false
    @State private var showRetakeConfirm: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(store.isPremium
                                    ? LinearGradient(colors: [Theme.accent, Theme.accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    : LinearGradient(colors: [Theme.cardBackgroundLight, Theme.cardBackgroundLight], startPoint: .top, endPoint: .bottom)
                                )
                                .frame(width: 50, height: 50)
                            Text(appState.userProfile.firstName.prefix(1).uppercased())
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(.white)
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

                Section {
                    ProVsFreeComparisonView(isPremium: store.isPremium) {
                        showPaywall = true
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                Section("Your Profile") {
                    if !appState.userProfile.firstName.isEmpty {
                        profileRow(icon: "person.fill", label: "Name", value: appState.userProfile.firstName)
                    }

                    if !appState.userProfile.selectedCategories.isEmpty {
                        profileRow(icon: "square.grid.2x2.fill", label: "Interests", value: appState.userProfile.selectedCategories.map(\.rawValue).joined(separator: ", "))
                    }

                    if !appState.userProfile.workEnvironments.isEmpty {
                        profileRow(icon: "building.2.fill", label: "Work Environment", value: appState.userProfile.workEnvironments.map(\.rawValue).joined(separator: ", "))
                    }

                    if !appState.userProfile.workConditions.isEmpty {
                        profileRow(icon: "exclamationmark.triangle.fill", label: "Conditions OK", value: appState.userProfile.workConditions.map(\.rawValue).joined(separator: ", "))
                    }

                    if !appState.userProfile.situationTags.isEmpty {
                        profileRow(icon: "tag.fill", label: "Situation", value: appState.userProfile.situationTags.map(\.rawValue).joined(separator: ", "))
                    }

                    if let hasCar = appState.userProfile.hasCar {
                        profileRow(icon: "car.fill", label: "Has Vehicle", value: hasCar ? "Yes" : "No")
                    }

                    if let selling = appState.userProfile.sellingComfort {
                        profileRow(icon: "tag.fill", label: "Selling Comfort", value: selling.rawValue)
                    }

                    if let fastCash = appState.userProfile.needsFastCash {
                        profileRow(icon: "bolt.fill", label: "Needs Fast Cash", value: fastCash ? "Yes" : "No")
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

                Section("Why Prooffd?") {
                    WhyProofdSectionContent()
                        .listRowBackground(Theme.cardBackground)
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
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(Theme.accent)
                                Text("Upgrade to Pro")
                                    .foregroundStyle(Theme.accent)
                                Spacer()
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

                Section("Apple Intelligence") {
                    NavigationLink {
                        AppleIntelligenceView()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "brain.head.profile")
                                .foregroundStyle(Theme.accent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Apple Intelligence")
                                    .foregroundStyle(Theme.textPrimary)
                                Text("Siri, Spotlight, Widgets & more")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textTertiary)
                            }
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
                        Text("Prooffd v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Theme.textTertiary)
                            .font(.title3)
                    }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .alert("Retake Quiz?", isPresented: $showRetakeConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Retake", role: .destructive) {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        appState.retakeQuiz()
                    }
                }
            } message: {
                Text("This will reset your profile and match results. You can retake the quiz to get new matches.")
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
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
