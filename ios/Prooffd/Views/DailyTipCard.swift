import SwiftUI

struct DailyTipCard: View {
    let tip: DailyTip
    @State private var isExpanded: Bool = false

    private var accentColor: Color {
        switch tip.category {
        case .mindset: return Color(hex: "818CF8")
        case .marketing: return Color(hex: "F472B6")
        case .money: return Color(hex: "34D399")
        case .hustle: return Color(hex: "FB923C")
        case .growth: return Color(hex: "60A5FA")
        case .strategy: return Color(hex: "FBBF24")
        }
    }

    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.35, bounce: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(accentColor.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: tip.icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(accentColor)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.caption2)
                                .foregroundStyle(.orange)
                            Text("Daily Hustle Tip")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.orange)
                        }
                        Text(tip.title)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text(tip.category.rawValue)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(accentColor)
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
                .padding(16)

                if isExpanded {
                    Divider()
                        .overlay(Theme.cardBackgroundLight)

                    Text(tip.body)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(
                LinearGradient(
                    colors: [accentColor.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(accentColor.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isExpanded)
        .accessibilityLabel("\(tip.title). \(isExpanded ? tip.body : "Tap to expand")")
        .accessibilityHint(isExpanded ? "Tap to collapse" : "Tap to read the full tip")
    }
}
