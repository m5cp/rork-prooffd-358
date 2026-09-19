import SwiftUI

/// Dimensional icon treatments that match the app's glossy 3D render art direction.
///
/// The bundled renders can't cover small UI chrome (reward gift, daily action,
/// Siri hint, avatars, stat cells) — those need real symbols. These wrappers give
/// those symbols the same depth language as the renders: a radial-lit body, a
/// specular top highlight, a rim light, and an outer color glow, so nothing in
/// the app reads as a flat circle with a symbol dropped in it.

// MARK: - GlossyIconOrb

/// Spherical, studio-lit icon badge. Use for circular accents.
struct GlossyIconOrb: View {
    let symbol: String
    var size: CGFloat = 44
    var tint: Color = Theme.accent
    /// Secondary color for the body gradient. Defaults to a deepened `tint`.
    var shade: Color?
    var pulses: Bool = false

    private var deepTint: Color { shade ?? tint.opacity(0.55) }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [tint, deepTint],
                        center: .init(x: 0.32, y: 0.24),
                        startRadius: 0,
                        endRadius: size * 0.92
                    )
                )

            // Specular highlight — the "lit from upper-left" cue.
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.55), .white.opacity(0.04)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.62, height: size * 0.36)
                .offset(y: -size * 0.24)
                .blur(radius: size * 0.045)

            Circle()
                .strokeBorder(
                    LinearGradient(
                        colors: [.white.opacity(0.65), .white.opacity(0.05), tint.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )

            Image(systemName: symbol)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
                .symbolEffect(.pulse.wholeSymbol, isActive: pulses)
        }
        .frame(width: size, height: size)
        .shadow(color: tint.opacity(0.45), radius: size * 0.22, y: size * 0.09)
        .shadow(color: .black.opacity(0.3), radius: 3, y: 2)
    }
}

// MARK: - GlossyIconTile

/// Rounded-square sibling of `GlossyIconOrb`, for icons that sit in list rows
/// alongside square artwork thumbnails.
struct GlossyIconTile: View {
    let symbol: String
    var size: CGFloat = 44
    var tint: Color = Theme.accent
    /// Muted tiles read as "inactive" without losing dimensionality.
    var isMuted: Bool = false

    private var radius: CGFloat { size * 0.28 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: isMuted
                            ? [Theme.cardBackgroundLight, Theme.cardBackground]
                            : [tint.opacity(0.95), tint.opacity(0.45)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(isMuted ? 0.14 : 0.4), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(isMuted ? 0.2 : 0.55),
                            tint.opacity(isMuted ? 0.15 : 0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )

            Image(systemName: symbol)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundStyle(isMuted ? AnyShapeStyle(tint) : AnyShapeStyle(Color.white))
                .shadow(color: .black.opacity(isMuted ? 0 : 0.3), radius: 2, y: 1)
        }
        .frame(width: size, height: size)
        .shadow(color: isMuted ? .clear : tint.opacity(0.35), radius: size * 0.18, y: size * 0.07)
    }
}
