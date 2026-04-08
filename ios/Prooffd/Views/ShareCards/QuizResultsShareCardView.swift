import SwiftUI

struct QuizResultsShareCardView: View {
    let content: ShareCardContent
    let style: ShareCardStyle
    let format: ShareCardFormat

    private var isSquare: Bool { format == .square }

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

    private var bg: some View {
        Group {
            switch style {
            case .clean:
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "0C1018"), Color(hex: "121A2E"), Color(hex: "0E1424")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    Circle()
                        .fill(accentColor.opacity(0.07))
                        .frame(width: isSquare ? 280 : 450)
                        .blur(radius: 80)
                        .offset(y: isSquare ? -60 : -120)
                }
            case .bold:
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "1A0A2E"), Color(hex: "16213E"), Color(hex: "0F3460")],
                        startPoint: .top, endPoint: .bottom
                    )
                    Circle()
                        .fill(accentColor.opacity(0.1))
                        .frame(width: isSquare ? 250 : 400)
                        .blur(radius: 70)
                        .offset(x: -80, y: isSquare ? 80 : 150)
                }
            case .premium:
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "0D0D0D"), Color(hex: "1A1A2E"), Color(hex: "0D0D0D")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    Circle()
                        .fill(accentColor.opacity(0.05))
                        .frame(width: isSquare ? 300 : 480)
                        .blur(radius: 80)
                }
            }
        }
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: isSquare ? 24 : 52)

                Text("MY TOP MATCHES")
                    .font(.system(size: isSquare ? 14 : 18, weight: .black))
                    .tracking(3)
                    .foregroundStyle(accentColor)

                Spacer().frame(height: isSquare ? 20 : 40)

                VStack(spacing: isSquare ? 12 : 20) {
                    ForEach(Array(content.topMatches.enumerated()), id: \.offset) { index, match in
                        matchRow(rank: index + 1, name: match.name, percent: match.percent, icon: match.icon)
                    }
                }

                Spacer()

                footer
                Spacer().frame(height: isSquare ? 20 : 36)
            }
            .padding(.horizontal, isSquare ? 24 : 28)
        }
    }

    private func matchRow(rank: Int, name: String, percent: Int, icon: String) -> some View {
        let isTop = rank == 1
        let rowColor = isTop ? accentColor : (rank == 2 ? secondaryAccent : Color.white.opacity(0.5))
        let iconSize: CGFloat = isSquare ? (isTop ? 44 : 36) : (isTop ? 60 : 48)
        let nameSize: CGFloat = isSquare ? (isTop ? 18 : 14) : (isTop ? 24 : 18)
        let percentSize: CGFloat = isSquare ? (isTop ? 28 : 20) : (isTop ? 38 : 26)

        return VStack(spacing: isSquare ? 6 : 10) {
            ZStack {
                Circle()
                    .fill(rowColor.opacity(isTop ? 0.15 : 0.08))
                    .frame(width: iconSize, height: iconSize)
                Image(systemName: icon)
                    .font(.system(size: iconSize * 0.4, weight: .semibold))
                    .foregroundStyle(rowColor)
            }

            Text(name)
                .font(.system(size: nameSize, weight: isTop ? .heavy : .bold))
                .foregroundStyle(isTop ? .white : Color.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)

            HStack(spacing: 4) {
                Text("\(percent)")
                    .font(.system(size: percentSize, weight: .black, design: .rounded))
                    .foregroundStyle(rowColor)
                Text("%")
                    .font(.system(size: percentSize * 0.6, weight: .bold, design: .rounded))
                    .foregroundStyle(rowColor.opacity(0.7))
                    .offset(y: isSquare ? -2 : -4)
            }

            if isTop {
                Text("BEST MATCH")
                    .font(.system(size: isSquare ? 9 : 11, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(accentColor.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(accentColor.opacity(0.1))
                    .clipShape(.capsule)
            }
        }
        .padding(.vertical, isSquare ? 8 : 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isTop ? Color.white.opacity(0.06) : Color.clear)
        )
    }

    private var footer: some View {
        VStack(spacing: isSquare ? 4 : 6) {
            Text("P R O O F F D")
                .font(.system(size: isSquare ? 10 : 12, weight: .bold))
                .tracking(4)
                .foregroundStyle(Color.white.opacity(0.3))
            Text("prooffd.app")
                .font(.system(size: isSquare ? 9 : 11, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.2))
        }
    }
}
