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
                    Text("Last updated: March 2026")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.bottom, 8)

                VStack(alignment: .leading, spacing: 16) {
                    privacySection(
                        icon: "lock.shield.fill",
                        title: "Your Data Stays on Your Device",
                        text: "All app usage data (quiz results, paths explored, progress) is stored locally on your device using standard iOS storage. None of this data is sent to external servers."
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
                        icon: "cart.fill",
                        title: "Subscriptions",
                        text: "In-app purchases are handled securely by Apple and our payment partner RevenueCat. We do not store or have access to your payment details."
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
