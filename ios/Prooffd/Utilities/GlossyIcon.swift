import SwiftUI

/// Icon treatments for small UI chrome (reward banner, daily action, Siri hint,
/// avatars, stat cells, settings rows).
///
/// The primary treatment is `RenderedIcon`, which draws an actual bundled 3D
/// render — a gradient behind an SF Symbol is still a flat icon, so anywhere a
/// render exists we use the render. `GlossyIconTile` remains only for the
/// settings list, where the rows are utility affordances with no matching
/// artwork.

// MARK: - IconArtwork

/// Maps UI slots to their bundled 3D render asset names.
enum IconArtwork {
    static let gift = "gift_box_ribbon"
    static let target = "dart_target_bullseye"
    static let microphone = "microphone_studio"
    static let flame = "flame_icon"
    static let hammer = "claw_hammer"
    static let trophy = "trophy_cup_gold"

    // Settings / profile rows. These reuse existing renders rather than flat
    // symbols — a gradient behind a glyph is still a flat icon.
    static let profile = "crystal_star_podium"
    static let motivation = "dart_target_bullseye"
    static let situation = "mountain_peak_flag_milestone"
    static let workEnvironment = "house_with_tools_floating"
    static let conditions = "hard_hat_tools_staircase"
    static let vehicle = "car_detailing_tools_render"
    static let selling = "microphone_studio"
    static let fastCash = "lightning_bolt"
    static let help = "question_mark_glowing"
    static let retake = "glowing_path_journey"
}

// MARK: - RenderedIcon

/// A bundled glossy 3D render used as an icon, with a soft colored glow behind
/// it so it sits on dark surfaces with depth.
struct RenderedIcon: View {
    let name: String
    var size: CGFloat = 44
    /// Glow color behind the render. Keep close to the render's own hue.
    var glow: Color = Theme.accent
    /// Renders are generated with generous margins; scale up so the subject
    /// fills the slot at small sizes.
    var zoom: CGFloat = 1.18

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [glow.opacity(0.35), glow.opacity(0.10), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.62
                    )
                )
                .blur(radius: size * 0.08)

            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(zoom)
                .shadow(color: .black.opacity(0.45), radius: size * 0.07, y: size * 0.05)
                .shadow(color: glow.opacity(0.4), radius: size * 0.14)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

// MARK: - GlossyIconTile

/// Rounded-square icon chip for the settings list, where rows are utility
/// affordances with no matching 3D render.
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
