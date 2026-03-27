import SwiftUI

struct BadgeCelebrationOverlay: View {
    let badge: MomentumBadge
    let onDismiss: () -> Void
    @State private var appear: Bool = false
    @State private var shimmer: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Color.black.opacity(appear ? 0.6 : 0)
                .ignoresSafeArea()
                .onTapGesture { dismissWithAnimation() }

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color(hex: badge.color).opacity(0.2))
                        .frame(width: 120, height: 120)
                        .scaleEffect(reduceMotion ? 1.0 : (shimmer ? 1.15 : 1.0))

                    Circle()
                        .fill(Color(hex: badge.color).opacity(0.1))
                        .frame(width: 90, height: 90)

                    Image(systemName: badge.icon)
                        .font(.system(size: 40))
                        .foregroundStyle(Color(hex: badge.color))
                        .scaleEffect(reduceMotion ? 1 : (appear ? 1 : 0.3))
                }
                .accessibilityHidden(true)

                VStack(spacing: 8) {
                    Text("Badge Unlocked!")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color(hex: badge.color))
                        .textCase(.uppercase)
                        .tracking(1.5)

                    Text(badge.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)

                    Text(badge.description)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }

                Button {
                    dismissWithAnimation()
                } label: {
                    Text("Awesome!")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(Color(hex: badge.color))
                        .clipShape(.capsule)
                }
            }
            .padding(32)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 24))
            .padding(.horizontal, 40)
            .scaleEffect(reduceMotion ? 1 : (appear ? 1 : 0.7))
            .opacity(appear ? 1 : 0)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Badge unlocked: \(badge.title). \(badge.description)")
        .onAppear {
            if reduceMotion {
                appear = true
            } else {
                withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                    appear = true
                }
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    shimmer = true
                }
            }
        }
    }

    private func dismissWithAnimation() {
        withAnimation(.spring(duration: 0.3)) {
            appear = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}
