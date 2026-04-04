import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss

    private let termsURL = URL(string: "https://gist.github.com/m5cp/c8bb13ae99be2880fe04b829827770d4")!
    private let eulaURL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Terms of Use")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                    Text("Last updated: April 2026")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.bottom, 8)

                linkCard(
                    icon: "doc.text.fill",
                    title: "Terms of Use",
                    subtitle: "View our full Terms of Use",
                    url: termsURL
                )

                linkCard(
                    icon: "apple.logo",
                    title: "Apple Standard EULA",
                    subtitle: "Licensed Application End User License Agreement",
                    url: eulaURL
                )

                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 10) {
                        Image(systemName: "info.circle.fill")
                            .font(.subheadline)
                            .foregroundStyle(Theme.accent)
                        Text("Apple Platform Integrations")
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                    }

                    integrationRow(
                        icon: "mic.fill",
                        title: "Siri & Shortcuts",
                        text: "Prooffd provides App Intents for Siri and the Shortcuts app. Voice interactions are governed by Apple's Siri & Privacy terms."
                    )

                    integrationRow(
                        icon: "magnifyingglass",
                        title: "Spotlight Search",
                        text: "Career paths are indexed locally for Spotlight. Apple's search terms apply."
                    )

                    integrationRow(
                        icon: "rectangle.on.rectangle",
                        title: "Widgets & Live Activities",
                        text: "Home and Lock Screen widgets use shared on-device storage. No external data transmission."
                    )

                    integrationRow(
                        icon: "brain.head.profile",
                        title: "Apple Intelligence",
                        text: "Compatible with Apple Intelligence on supported devices. All on-device AI processing is governed by Apple's terms."
                    )
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))

                Color.clear.frame(height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .navigationTitle("Terms of Use")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Theme.background, for: .navigationBar)
    }

    private func integrationRow(icon: String, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Theme.accentBlue)
                .frame(width: 20)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(text)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)
            }
        }
    }

    private func linkCard(icon: String, title: String, subtitle: String, url: URL) -> some View {
        Button {
            UIApplication.shared.open(url)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(Theme.accent)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(subtitle)
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
    }
}
