import SwiftUI

struct StepCompletionOverlay: View {
    let title: String
    let subtitle: String
    let onShare: () -> Void
    let onDismiss: () -> Void

    @State private var animateIn: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.accent)
                    .symbolEffect(.bounce, value: animateIn)

                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(Theme.textPrimary)

                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button(action: onDismiss) {
                        Text("Not now")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Theme.cardBackgroundLight)
                            .clipShape(.capsule)
                    }

                    Button(action: onShare) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.accent)
                        .clipShape(.capsule)
                    }
                }
            }
            .padding(28)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 24))
            .shadow(color: .black.opacity(0.2), radius: 24)
            .padding(.horizontal, 32)
            .scaleEffect(animateIn ? 1.0 : 0.9)
            .opacity(animateIn ? 1.0 : 0)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                animateIn = true
            }
        }
        .sensoryFeedback(.success, trigger: animateIn)
    }
}
