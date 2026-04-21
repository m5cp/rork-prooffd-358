import SwiftUI
import AppIntents

struct SiriDailyTipHint: View {
    var onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.accentBlue.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: "mic.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Try Siri")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textTertiary)
                Text("\u{201C}Hey Siri, show my daily tip\u{201D}")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 0)

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textTertiary)
                    .frame(width: 32, height: 32)
                    .background(Theme.cardBackgroundLight, in: Circle())
            }
            .accessibilityLabel("Dismiss Siri tip")
            .frame(minWidth: 44, minHeight: 44)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.accentBlue.opacity(0.15), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Tip: say \"Hey Siri, show my daily tip\"")
    }
}
