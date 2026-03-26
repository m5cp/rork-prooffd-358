import SwiftUI

struct ProVsFreeComparisonView: View {
    let isPremium: Bool
    var onUpgrade: () -> Void

    private let comparisons: [(feature: String, icon: String, free: FeatureAccess, pro: FeatureAccess)] = [
        ("Business Path Matches", "chart.bar.fill", .limited("20"), .full("50")),
        ("Daily Tips", "lightbulb.fill", .included, .included),
        ("Draft Email Templates", "envelope.fill", .locked, .included),
        ("Text Message Templates", "message.fill", .locked, .included),
        ("Sales Intro Scripts", "person.wave.2.fill", .locked, .included),
        ("Social Media Posts", "square.and.arrow.up.fill", .locked, .included),
        ("Offer & Pricing Sheets", "dollarsign.square.fill", .locked, .included),
        ("One-Page Business Plans", "doc.text.fill", .locked, .included),
        ("PDF Export", "doc.fill", .locked, .included),
        ("What-If Scenarios", "arrow.triangle.branch", .locked, .included)
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Compare Plans")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            HStack(spacing: 0) {
                Text("Feature")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textTertiary)
                    .textCase(.uppercase)
                Spacer()
                Text("Free")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textTertiary)
                    .textCase(.uppercase)
                    .frame(width: 56, alignment: .center)
                Text("Pro")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accent)
                    .textCase(.uppercase)
                    .frame(width: 56, alignment: .center)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            ForEach(Array(comparisons.enumerated()), id: \.offset) { index, item in
                VStack(spacing: 0) {
                    if index > 0 {
                        Rectangle()
                            .fill(Theme.cardBackgroundLight.opacity(0.5))
                            .frame(height: 1)
                            .padding(.horizontal, 16)
                    }

                    HStack(spacing: 10) {
                        Image(systemName: item.icon)
                            .font(.caption)
                            .foregroundStyle(Theme.accent.opacity(0.7))
                            .frame(width: 20)

                        Text(item.feature)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Spacer()

                        accessBadge(item.free, isPro: false)
                            .frame(width: 56, alignment: .center)

                        accessBadge(item.pro, isPro: true)
                            .frame(width: 56, alignment: .center)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                }
            }

            if !isPremium {
                Button(action: onUpgrade) {
                    HStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.subheadline)
                        Text("Upgrade to Pro")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(
                        LinearGradient(
                            colors: [Theme.accent, Theme.accentBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(.capsule)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 16)
            } else {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Theme.accent)
                    Text("You have Pro")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.accent)
                }
                .padding(.vertical, 14)
            }
        }
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    @ViewBuilder
    private func accessBadge(_ access: FeatureAccess, isPro: Bool) -> some View {
        switch access {
        case .included:
            Image(systemName: "checkmark.circle.fill")
                .font(.subheadline)
                .foregroundStyle(isPro ? Theme.accent : Theme.textTertiary)
        case .locked:
            Image(systemName: "lock.fill")
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary.opacity(0.6))
        case .limited(let text):
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.textTertiary)
        case .full(let text):
            Text(text)
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.accent)
        }
    }
}

nonisolated enum FeatureAccess: Sendable {
    case included
    case locked
    case limited(String)
    case full(String)
}
