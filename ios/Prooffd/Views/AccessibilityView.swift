import SwiftUI

struct AccessibilityView: View {
    private let accessibilityURL = URL(string: "https://gist.github.com/m5cp/70b771aaf4256df02b07d4a76f44aa99")!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Accessibility")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                    Text("Last updated: March 2026")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.bottom, 8)

                featureCard(
                    icon: "textformat.size",
                    title: "Dynamic Type",
                    description: "Prooffd supports Dynamic Type across all screens. Text scales with your system font size settings, including accessibility sizes."
                )

                featureCard(
                    icon: "eye",
                    title: "VoiceOver",
                    description: "All interactive elements have accessibility labels and hints. Cards, buttons, and progress indicators are properly announced."
                )

                featureCard(
                    icon: "hand.raised",
                    title: "Reduce Motion",
                    description: "Animations are disabled when Reduce Motion is enabled in system settings. All content remains fully accessible."
                )

                featureCard(
                    icon: "circle.lefthalf.filled",
                    title: "Dark Mode",
                    description: "Full dark mode support with high contrast text and carefully tuned colors for readability in all lighting conditions."
                )

                featureCard(
                    icon: "hand.tap",
                    title: "Touch Targets",
                    description: "All interactive elements meet Apple's minimum 44x44pt touch target guideline for comfortable tapping."
                )

                featureCard(
                    icon: "waveform",
                    title: "Haptic Feedback",
                    description: "Meaningful haptic feedback for key interactions like completing steps, earning badges, and navigating between sections."
                )

                Button {
                    UIApplication.shared.open(accessibilityURL)
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "accessibility")
                            .font(.title3)
                            .foregroundStyle(Theme.accent)
                            .frame(width: 32)

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Accessibility Statement")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            Text("View our full Accessibility Statement")
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
        .navigationTitle("Accessibility")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Theme.background, for: .navigationBar)
    }

    private func featureCard(icon: String, title: String, description: String) -> some View {
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
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }
}
