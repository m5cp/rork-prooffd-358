import SwiftUI

extension View {
    func cardShadow() -> some View {
        self
            .shadow(color: Theme.cardShadow, radius: 8, x: 0, y: 2)
    }

    func premiumCard() -> some View {
        self
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.border, lineWidth: 0.5)
            )
            .cardShadow()
    }

    func tintedCard(_ tintColor: Color, cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                LinearGradient(
                    colors: [tintColor.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(tintColor.opacity(0.15), lineWidth: 0.5)
            )
            .cardShadow()
    }
}
