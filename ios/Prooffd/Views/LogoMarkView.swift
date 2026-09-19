import SwiftUI

/// Renders a `LogoDesign` as a real logo mark at any size.
struct LogoMarkView: View {
    let design: LogoDesign
    /// Used when the design is set to monogram mode.
    var businessName: String = ""
    var size: CGFloat = 96

    private var palette: LogoPalette { design.palette }

    private var monogram: String {
        let words = businessName.trimmed
            .split(separator: " ")
            .filter { !$0.isEmpty }
        guard !words.isEmpty else { return "?" }
        if words.count == 1 {
            return String(words[0].prefix(2)).uppercased()
        }
        return words.prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
            .uppercased()
    }

    var body: some View {
        ZStack {
            backdrop

            if design.useMonogram {
                Text(monogram)
                    .font(.system(size: size * 0.36, weight: .black, design: .rounded))
                    .foregroundStyle(design.shape == .none ? palette.primary : palette.ink)
                    .minimumScaleFactor(0.5)
            } else {
                Image(systemName: design.symbol)
                    .font(.system(size: size * 0.38, weight: .semibold))
                    .foregroundStyle(design.shape == .none ? primaryGradient : inkStyle)
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .frame(width: size, height: size)
        .shadow(color: palette.primary.opacity(0.35), radius: size * 0.1, y: size * 0.04)
    }

    private var primaryGradient: AnyShapeStyle {
        AnyShapeStyle(
            LinearGradient(
                colors: [palette.primary, palette.secondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private var inkStyle: AnyShapeStyle { AnyShapeStyle(palette.ink) }

    @ViewBuilder
    private var backdrop: some View {
        let fill = LinearGradient(
            colors: [palette.primary, palette.secondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        switch design.shape {
        case .circle:
            Circle().fill(fill)
                .overlay {
                    Circle().strokeBorder(.white.opacity(0.25), lineWidth: size * 0.02)
                }
        case .roundedSquare:
            RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                .fill(fill)
                .overlay {
                    RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                        .strokeBorder(.white.opacity(0.25), lineWidth: size * 0.02)
                }
        case .shield:
            ShieldShape().fill(fill)
        case .hexagon:
            HexagonShape().fill(fill)
        case .none:
            Color.clear
        }
    }
}

/// Simple shield silhouette for logo backdrops.
struct ShieldShape: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addLine(to: CGPoint(x: w, y: h * 0.18))
        p.addLine(to: CGPoint(x: w, y: h * 0.58))
        p.addQuadCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control: CGPoint(x: w * 0.92, y: h * 0.88)
        )
        p.addQuadCurve(
            to: CGPoint(x: 0, y: h * 0.58),
            control: CGPoint(x: w * 0.08, y: h * 0.88)
        )
        p.addLine(to: CGPoint(x: 0, y: h * 0.18))
        p.closeSubpath()
        return p
    }
}

/// Flat-top hexagon for logo backdrops.
struct HexagonShape: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let inset = w * 0.06
        p.move(to: CGPoint(x: w * 0.5, y: inset))
        p.addLine(to: CGPoint(x: w - inset, y: h * 0.28))
        p.addLine(to: CGPoint(x: w - inset, y: h * 0.72))
        p.addLine(to: CGPoint(x: w * 0.5, y: h - inset))
        p.addLine(to: CGPoint(x: inset, y: h * 0.72))
        p.addLine(to: CGPoint(x: inset, y: h * 0.28))
        p.closeSubpath()
        return p
    }
}
