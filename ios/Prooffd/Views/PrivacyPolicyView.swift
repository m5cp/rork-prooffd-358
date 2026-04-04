import SwiftUI

struct PrivacyPolicyView: View {
    private let privacyURL = URL(string: "https://gist.github.com/m5cp/b63e5a206cd0b4b5366f9d46c8b791b7")!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Privacy Policy")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                    Text("Last updated: April 2026")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.bottom, 8)

                VStack(alignment: .leading, spacing: 16) {
                    privacySection(
                        icon: "lock.shield.fill",
                        title: "Your Data Stays on Your Device",
                        text: "All user data, progress, and generated content are stored locally on your device using standard iOS storage. None of this data is sent to external servers unless you choose to share it."
                    )

                    privacySection(
                        icon: "xmark.shield.fill",
                        title: "No Third-Party Analytics",
                        text: "We do not use third-party analytics SDKs such as Firebase, Mixpanel, or PostHog. Basic app performance and usage metrics may be available through Apple's App Store Connect analytics and platform reporting."
                    )

                    privacySection(
                        icon: "hand.raised.slash.fill",
                        title: "No Tracking",
                        text: "We do not track you across apps or websites. We do not use device fingerprinting, ad attribution, or behavioral tracking systems. No personal information such as names, emails, or location is collected."
                    )

                    privacySection(
                        icon: "square.and.arrow.up.fill",
                        title: "Sharing Features",
                        text: "The app allows you to generate and share content such as career matches, progress, or summaries. This content is created locally and is only shared if you initiate sharing using the device's native sharing options. We do not store or transmit this content externally."
                    )

                    privacySection(
                        icon: "bell.fill",
                        title: "Notifications",
                        text: "The app may send local notifications to remind you of your progress and encourage daily engagement. Notifications are enabled by default and can be turned off at any time in your Profile settings. All notification content is generated locally on your device. We do not use third-party push notification services or track notification interactions."
                    )

                    privacySection(
                        icon: "cart.fill",
                        title: "Subscriptions",
                        text: "In-app purchases are handled securely by Apple and our payment partner RevenueCat. We do not store or have access to your payment details."
                    )

                    privacySection(
                        icon: "mic.fill",
                        title: "Siri & Shortcuts",
                        text: "Prooffd integrates with Siri and Apple Shortcuts to let you access daily tips, your plan, and streaks hands-free. Siri interactions are processed by Apple on-device or through Apple's servers per Apple's privacy policy. We do not receive, store, or transmit any Siri voice data."
                    )

                    privacySection(
                        icon: "magnifyingglass",
                        title: "Spotlight Search",
                        text: "Career and business paths are indexed for Spotlight search so you can find them quickly from your home screen. This data is stored locally in Apple's on-device index and is never sent to external servers."
                    )

                    privacySection(
                        icon: "rectangle.on.rectangle",
                        title: "Widgets",
                        text: "Prooffd widgets display streaks, tips, and micro-actions on your home and lock screens. Widget data is stored in a shared App Group container on your device and is never transmitted externally."
                    )

                    privacySection(
                        icon: "brain.head.profile",
                        title: "Apple Intelligence Compatibility",
                        text: "Prooffd is compatible with Apple Intelligence features available on supported devices (iPhone 15 Pro and later, iPad and Mac with M1 or later). All Apple Intelligence processing happens on-device or through Apple's Private Cloud Compute. Prooffd does not send any data to Apple for AI processing — Apple Intelligence features are initiated and controlled entirely by the operating system."
                    )
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))

                Button {
                    UIApplication.shared.open(privacyURL)
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "hand.raised.fill")
                            .font(.title3)
                            .foregroundStyle(Theme.accent)
                            .frame(width: 32)

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Privacy Policy")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            Text("View our full Privacy Policy")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                        }

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))
                }
                .buttonStyle(.plain)

                Color.clear.frame(height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Theme.background, for: .navigationBar)
    }

    private func privacySection(icon: String, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Theme.accent)
                .frame(width: 24, alignment: .center)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(text)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
