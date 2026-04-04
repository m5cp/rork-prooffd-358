import SwiftUI

struct AppleIntelligenceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Apple Intelligence")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                    Text("On-Device AI Integration")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.bottom, 8)

                compatibilityBanner

                infoCard(
                    icon: "brain.head.profile",
                    title: "What is Apple Intelligence?",
                    description: "Apple Intelligence is Apple's on-device AI system that powers smart features across iOS. It runs locally on your device, meaning your data never leaves your phone. Prooffd is fully compatible with Apple Intelligence features on supported devices."
                )

                infoCard(
                    icon: "mic.fill",
                    title: "Siri Integration",
                    description: "Ask Siri to show your daily career tip, open your plan, or check your streak. Prooffd registers App Shortcuts so Siri understands commands like \"Show my daily tip in Prooffd\" or \"What's my streak on Prooffd\" without any setup."
                )

                infoCard(
                    icon: "rectangle.and.hand.point.up.left.filled",
                    title: "Shortcuts App",
                    description: "Build custom automations with Prooffd actions in the Shortcuts app. Combine career tips with your morning routine, or get streak reminders at specific times."
                )

                infoCard(
                    icon: "magnifyingglass",
                    title: "Spotlight Search",
                    description: "All careers, businesses, and education paths are indexed in Spotlight. Search from your home screen to jump directly to any career path without opening the app first."
                )

                infoCard(
                    icon: "rectangle.on.rectangle",
                    title: "Home & Lock Screen Widgets",
                    description: "Prooffd widgets display your streak, daily tips, and micro-actions right on your home screen and lock screen. Stay motivated with a glance."
                )

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "iphone.gen3")
                            .font(.subheadline)
                            .foregroundStyle(Theme.accent)
                        Text("Supported Devices")
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                    }

                    deviceRow(name: "iPhone 15 Pro & later", detail: "Full Apple Intelligence support")
                    deviceRow(name: "iPhone 16 series", detail: "Full Apple Intelligence support")
                    deviceRow(name: "iPad with M1 or later", detail: "Full Apple Intelligence support")
                    deviceRow(name: "Mac with M1 or later", detail: "Full Apple Intelligence support")

                    Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.accentBlue)
                            .padding(.top, 2)
                        Text("Apple Intelligence features require iOS 18.1 or later with Apple Intelligence enabled in Settings > Apple Intelligence & Siri. Prooffd works on all iPhones running iOS 18+, but Apple Intelligence features are only available on supported hardware.")
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                            .lineSpacing(2)
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))

                infoCard(
                    icon: "lock.shield.fill",
                    title: "Privacy First",
                    description: "All Apple Intelligence processing happens on-device or through Apple's Private Cloud Compute. Your career exploration data, plan items, and personal information are never sent to external AI servers. Prooffd's content is human-curated, not AI-generated."
                )

                Color.clear.frame(height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .navigationTitle("Apple Intelligence")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Theme.background, for: .navigationBar)
    }

    private var compatibilityBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(Theme.accent)
            VStack(alignment: .leading, spacing: 4) {
                Text("Fully Compatible")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("Prooffd works seamlessly with Apple Intelligence, Siri, Spotlight, and Widgets.")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.accent.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.accent.opacity(0.3), lineWidth: 1)
        )
    }

    private func infoCard(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Theme.accent)
                .frame(width: 32)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }

    private func deviceRow(name: String, detail: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .font(.caption2.weight(.bold))
                .foregroundStyle(Theme.accent)
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.textPrimary)
                Text(detail)
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
    }
}
