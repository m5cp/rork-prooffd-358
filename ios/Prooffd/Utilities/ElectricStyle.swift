import SwiftUI

/// Immersive "electric" styling for the dark redesign: a deep navy backdrop
/// with green/cyan glows, plus glassy card treatment.

/// Full-screen backdrop for immersive screens (quizzes, Progress tab).
/// Layered radial glows give the screen depth instead of flat color.
struct ElectricBackdrop: View {
    var body: some View {
        ZStack {
            Theme.background
            RadialGradient(
                colors: [Theme.accent.opacity(0.16), .clear],
                center: UnitPoint(x: 0.12, y: 0.02),
                startRadius: 20,
                endRadius: 460
            )
            RadialGradient(
                colors: [Theme.accentCyan.opacity(0.12), .clear],
                center: UnitPoint(x: 0.92, y: 0.12),
                startRadius: 20,
                endRadius: 400
            )
        }
        .ignoresSafeArea()
    }
}

extension View {
    /// Glassy card: translucent material with a hairline sheen border.
    /// Apply an accent tint with `.background(color.opacity(...))` first
    /// for a colored glow under the glass.
    func electricCard(cornerRadius: CGFloat) -> some View {
        self
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.16), Color.white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}
