import SwiftUI

struct TopMatchShareCardView: View {
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

    private var matchColor: Color {
        if content.matchPercent >= 80 { return Color(hex: "34D399") }
        if content.matchPercent >= 60 { return Color(hex: "60A5FA") }
        return .orange
    }

    private var bg: some View {
        Group {
            switch style {
            case .clean:
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "0C1018"), Color(hex: "0F1A2B"), Color(hex: "0A1220")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    Circle()
                        .fill(accentColor.opacity(0.08))
                        .frame(width: isSquare ? 300 : 500)
                        .blur(radius: 80)
                        .offset(y: isSquare ? -40 : -80)
                }
            case .bold:
                ZStack {
                    Color(hex: "0A0E1A")
                    RadialGradient(
                        colors: [accentColor.opacity(0.2), Color.clear],
                        center: .center, startRadius: 0, endRadius: isSquare ? 250 : 400
                    )
                    Circle()
                        .fill(Color(hex: "818CF8").opacity(0.1))
                        .frame(width: isSquare ? 200 : 350)
                        .blur(radius: 60)
                        .offset(x: isSquare ? 100 : 150, y: isSquare ? 120 : 200)
                }
            case .premium:
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "0D0D0D"), Color(hex: "1C1524"), Color(hex: "0D0D12")],
                        startPoint: .top, endPoint: .bottom
                    )
                    Circle()
                        .fill(accentColor.opacity(0.06))
                        .frame(width: isSquare ? 280 : 450)
                        .blur(radius: 70)
                        .offset(y: isSquare ? 30 : 60)
                }
            }
        }
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                iconBadge
                Spacer().frame(height: isSquare ? 16 : 28)

                Text(content.jobTitle)
                    .font(.system(size: isSquare ? 28 : 40, weight: .heavy))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.6)

                Spacer().frame(height: isSquare ? 20 : 36)

                matchRing

                Spacer().frame(height: isSquare ? 16 : 28)

                Text("You're Built For This")
                    .font(.system(size: isSquare ? 13 : 16, weight: .bold))
                    .tracking(1.5)
                    .foregroundStyle(accentColor.opacity(0.8))

                Spacer()

                footer
                Spacer().frame(height: isSquare ? 20 : 36)
            }
            .padding(.horizontal, isSquare ? 28 : 32)
        }
    }

    private var iconBadge: some View {
        ZStack {
            Circle()
                .fill(accentColor.opacity(0.12))
                .frame(width: isSquare ? 72 : 100, height: isSquare ? 72 : 100)
            Circle()
                .fill(accentColor.opacity(0.06))
                .frame(width: isSquare ? 96 : 130, height: isSquare ? 96 : 130)
            Image(systemName: content.jobIcon)
                .font(.system(size: isSquare ? 30 : 42, weight: .semibold))
                .foregroundStyle(accentColor)
                .symbolEffect(.pulse)
        }
    }

    private var matchRing: some View {
        ZStack {
            Circle()
                .stroke(matchColor.opacity(0.1), lineWidth: isSquare ? 8 : 10)
            Circle()
                .trim(from: 0, to: Double(content.matchPercent) / 100.0)
                .stroke(
                    AngularGradient(
                        colors: [matchColor.opacity(0.4), matchColor],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: isSquare ? 8 : 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            VStack(spacing: 2) {
                Text("\(content.matchPercent)")
                    .font(.system(size: isSquare ? 36 : 52, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text("% MATCH")
                    .font(.system(size: isSquare ? 10 : 13, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(matchColor)
            }
        }
        .frame(width: isSquare ? 120 : 160, height: isSquare ? 120 : 160)
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
