import SwiftUI

struct ProgressShareCardView: View {
    let content: ShareCardContent
    let style: ShareCardStyle
    let format: ShareCardFormat

    private var isSquare: Bool { format == .square }

    private var accentColor: Color {
        switch style {
        case .clean: return Color(hex: "34D399")
        case .bold: return Color(hex: "FBBF24")
        case .premium: return Color(hex: "C4B5FD")
        }
    }

    private var progressColor: Color {
        if content.progressPercent >= 75 { return Color(hex: "34D399") }
        if content.progressPercent >= 50 { return Color(hex: "60A5FA") }
        if content.progressPercent >= 25 { return Color(hex: "FBBF24") }
        return Color(hex: "FB923C")
    }

    private var bg: some View {
        Group {
            switch style {
            case .clean:
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "0C1018"), Color(hex: "101E30"), Color(hex: "0B1420")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    Circle()
                        .fill(progressColor.opacity(0.08))
                        .frame(width: isSquare ? 300 : 480)
                        .blur(radius: 80)
                        .offset(y: isSquare ? -30 : -60)
                }
            case .bold:
                ZStack {
                    Color(hex: "0A0E1A")
                    RadialGradient(
                        colors: [accentColor.opacity(0.15), Color.clear],
                        center: .center, startRadius: 0, endRadius: isSquare ? 250 : 400
                    )
                    Circle()
                        .fill(Color(hex: "F472B6").opacity(0.08))
                        .frame(width: isSquare ? 200 : 320)
                        .blur(radius: 60)
                        .offset(x: 100, y: isSquare ? 100 : 180)
                }
            case .premium:
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "0D0D0D"), Color(hex: "1A1A28"), Color(hex: "0D0D12")],
                        startPoint: .top, endPoint: .bottom
                    )
                    Circle()
                        .fill(accentColor.opacity(0.06))
                        .frame(width: isSquare ? 280 : 440)
                        .blur(radius: 70)
                        .offset(y: isSquare ? 40 : 80)
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

                Text(content.buildName)
                    .font(.system(size: isSquare ? 26 : 36, weight: .heavy))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)

                Spacer().frame(height: isSquare ? 20 : 36)

                progressRing

                Spacer().frame(height: isSquare ? 16 : 28)

                Text("BUILDING MY PATH")
                    .font(.system(size: isSquare ? 13 : 16, weight: .bold))
                    .tracking(1.5)
                    .foregroundStyle(progressColor.opacity(0.8))

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
                .fill(progressColor.opacity(0.12))
                .frame(width: isSquare ? 72 : 100, height: isSquare ? 72 : 100)
            Circle()
                .fill(progressColor.opacity(0.06))
                .frame(width: isSquare ? 96 : 130, height: isSquare ? 96 : 130)
            Image(systemName: content.buildIcon)
                .font(.system(size: isSquare ? 30 : 42, weight: .semibold))
                .foregroundStyle(progressColor)
        }
    }

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(progressColor.opacity(0.1), lineWidth: isSquare ? 8 : 10)
            Circle()
                .trim(from: 0, to: Double(content.progressPercent) / 100.0)
                .stroke(
                    AngularGradient(
                        colors: [progressColor.opacity(0.4), progressColor],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: isSquare ? 8 : 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            VStack(spacing: 2) {
                Text("\(content.progressPercent)")
                    .font(.system(size: isSquare ? 36 : 52, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text("% DONE")
                    .font(.system(size: isSquare ? 10 : 13, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(progressColor)
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
