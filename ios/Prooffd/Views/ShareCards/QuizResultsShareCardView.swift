import SwiftUI

struct QuizResultsShareCardView: View {
    let content: ShareCardContent
    let style: ShareCardStyle
    let format: ShareCardFormat

    private var isSquare: Bool { format == .square }

    private var bg: some View {
        Group {
            switch style {
            case .clean:
                LinearGradient(
                    colors: [Color(hex: "0C1018"), Color(hex: "121A2E"), Color(hex: "0E1424")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            case .bold:
                LinearGradient(
                    colors: [Color(hex: "1A0A2E"), Color(hex: "16213E"), Color(hex: "0F3460")],
                    startPoint: .top, endPoint: .bottom
                )
            case .premium:
                LinearGradient(
                    colors: [Color(hex: "0D0D0D"), Color(hex: "1A1A2E"), Color(hex: "0D0D0D")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            }
        }
    }

    private var accentColor: Color {
        switch style {
        case .clean: return Color(hex: "34D399")
        case .bold: return Color(hex: "60A5FA")
        case .premium: return Color(hex: "C4B5FD")
        }
    }

    private var secondaryAccent: Color {
        switch style {
        case .clean: return Color(hex: "60A5FA")
        case .bold: return Color(hex: "F472B6")
        case .premium: return Color(hex: "FCD34D")
        }
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer(minLength: isSquare ? 16 : 40)
                brandLabel
                Spacer(minLength: isSquare ? 12 : 28)
                titleBlock
                Spacer(minLength: isSquare ? 12 : 24)
                matchesList
                Spacer(minLength: isSquare ? 12 : 20)
                if let topZone = content.topMatches.first?.zone {
                    zoneLabel(topZone)
                }
                Spacer(minLength: isSquare ? 8 : 16)
                supportingLine
                Spacer()
                ctaFooter
                Spacer(minLength: isSquare ? 16 : 32)
            }
            .padding(.horizontal, isSquare ? 24 : 28)
        }
    }

    private var brandLabel: some View {
        Text("P R O O F F D")
            .font(.system(size: isSquare ? 9 : 11, weight: .bold))
            .tracking(3)
            .foregroundStyle(Color.white.opacity(0.35))
    }

    private var titleBlock: some View {
        VStack(spacing: isSquare ? 4 : 8) {
            Text("My Top Matches")
                .font(.system(size: isSquare ? 22 : 30, weight: .heavy))
                .foregroundStyle(.white)
            if style == .premium {
                Rectangle()
                    .fill(accentColor.opacity(0.5))
                    .frame(width: 40, height: 2)
            }
        }
    }

    private var matchesList: some View {
        VStack(spacing: isSquare ? 8 : 14) {
            ForEach(Array(content.topMatches.enumerated()), id: \.offset) { index, match in
                matchRow(index: index + 1, name: match.name, percent: match.percent, icon: match.icon)
            }
        }
    }

    private func matchRow(index: Int, name: String, percent: Int, icon: String) -> some View {
        let isTop = index == 1
        let rowAccent = isTop ? accentColor : Color.white.opacity(0.6)
        let fontSize: CGFloat = isSquare ? (isTop ? 15 : 13) : (isTop ? 20 : 16)
        let percentSize: CGFloat = isSquare ? (isTop ? 18 : 14) : (isTop ? 24 : 18)

        return HStack(spacing: isSquare ? 10 : 14) {
            Text("\(index)")
                .font(.system(size: isSquare ? 11 : 14, weight: .bold, design: .rounded))
                .foregroundStyle(isTop ? accentColor : Color.white.opacity(0.4))
                .frame(width: isSquare ? 18 : 22)

            Image(systemName: icon)
                .font(.system(size: isSquare ? 12 : 15))
                .foregroundStyle(rowAccent)

            Text(name)
                .font(.system(size: fontSize, weight: isTop ? .bold : .semibold))
                .foregroundStyle(isTop ? .white : Color.white.opacity(0.75))
                .lineLimit(1)

            Spacer(minLength: 4)

            Text("\(percent)%")
                .font(.system(size: percentSize, weight: .bold, design: .rounded))
                .foregroundStyle(rowAccent)
        }
        .padding(.horizontal, isSquare ? 12 : 16)
        .padding(.vertical, isSquare ? 10 : 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isTop ? Color.white.opacity(0.08) : Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isTop ? accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
    }

    private func zoneLabel(_ zone: AIZone) -> some View {
        let zoneText: String
        switch zone {
        case .safe: zoneText = "High"
        case .human: zoneText = "Medium"
        case .augmented: zoneText = "Low"
        }
        return HStack(spacing: 6) {
            Image(systemName: zone.icon)
                .font(.system(size: isSquare ? 10 : 12))
            Text("AI Safe Zone: \(zoneText)")
                .font(.system(size: isSquare ? 11 : 13, weight: .semibold))
        }
        .foregroundStyle(secondaryAccent)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(secondaryAccent.opacity(0.1))
        .clipShape(.rect(cornerRadius: 20))
    }

    private var supportingLine: some View {
        Text("Built for flexible, high-upside work")
            .font(.system(size: isSquare ? 11 : 14, weight: .medium))
            .foregroundStyle(Color.white.opacity(0.5))
            .multilineTextAlignment(.center)
    }

    private var ctaFooter: some View {
        VStack(spacing: isSquare ? 4 : 8) {
            Text("Find your path \u{2192}")
                .font(.system(size: isSquare ? 12 : 15, weight: .bold))
                .foregroundStyle(accentColor)
            Text("prooffd.app")
                .font(.system(size: isSquare ? 9 : 11, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.3))
        }
    }
}
