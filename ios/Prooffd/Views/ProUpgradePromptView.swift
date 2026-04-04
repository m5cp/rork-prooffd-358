import SwiftUI

struct ProUpgradePromptView: View {
    let title: String
    let subtitle: String
    let features: [String]
    var onUpgrade: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .font(.title3)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Theme.accent, Theme.accentBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text(title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                }

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            if !features.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(features, id: \.self) { feature in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.accent)
                            Text(feature)
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)
            }

            Button(action: onUpgrade) {
                HStack(spacing: 6) {
                    Image(systemName: "lock.open.fill")
                    Text("Unlock Full Details")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Theme.accent, Theme.accentBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(.capsule)
            }
            .sensoryFeedback(.selection, trigger: false)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Theme.accent.opacity(0.06), Theme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
        )
    }
}
