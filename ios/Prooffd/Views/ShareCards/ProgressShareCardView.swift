import SwiftUI

struct ProgressShareCardView: View {
    let content: ShareCardContent
    let style: ShareCardStyle
    let format: ShareCardFormat

    private var isSquare: Bool { format == .square }

    private var bg: some View {
        Group {
            switch style {
            case .clean:
                LinearGradient(
                    colors: [Color(hex: "0C1018"), Color(hex: "101E30"), Color(hex: "0B1420")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            case .bold:
                ZStack {
                    Color(hex: "0A0E1A")
                    LinearGradient(
                        colors: [Color(hex: "FBBF24").opacity(0.12), Color.clear],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                }
            case .premium:
                LinearGradient(
                    colors: [Color(hex: "0D0D0D"), Color(hex: "1A1A28"), Color(hex: "0D0D12")],
                    startPoint: .top, endPoint: .bottom
                )
            }
        }
    }

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

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer(minLength: isSquare ? 16 : 44)
                brandLabel
                Spacer(minLength: isSquare ? 10 : 24)
                headerLine
                Spacer(minLength: isSquare ? 6 : 12)
                buildName
                Spacer(minLength: isSquare ? 14 : 28)
                progressRing
                Spacer(minLength: isSquare ? 10 : 20)
                milestonePill
                Spacer(minLength: isSquare ? 8 : 16)
                supportLine
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

    private var headerLine: some View {
        Text("I'm Building:")
            .font(.system(size: isSquare ? 13 : 16, weight: .semibold))
            .foregroundStyle(accentColor)
    }

    private var buildName: some View {
        Text(content.buildName)
            .font(.system(size: isSquare ? 22 : 30, weight: .heavy))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.7)
    }

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(progressColor.opacity(0.12), lineWidth: isSquare ? 8 : 10)
            Circle()
                .trim(from: 0, to: Double(content.progressPercent) / 100.0)
                .stroke(progressColor, style: StrokeStyle(lineWidth: isSquare ? 8 : 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 2) {
                Text("\(content.progressPercent)%")
                    .font(.system(size: isSquare ? 32 : 44, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("complete")
                    .font(.system(size: isSquare ? 9 : 11, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.5))
            }
        }
        .frame(width: isSquare ? 110 : 140, height: isSquare ? 110 : 140)
    }

    private var milestonePill: some View {
        Text(content.milestoneLine)
            .font(.system(size: isSquare ? 12 : 14, weight: .semibold))
            .foregroundStyle(progressColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(progressColor.opacity(0.1))
            .clipShape(.rect(cornerRadius: 20))
    }

    private var supportLine: some View {
        Text("Making real progress")
            .font(.system(size: isSquare ? 11 : 14, weight: .medium))
            .foregroundStyle(Color.white.opacity(0.45))
    }

    private var ctaFooter: some View {
        VStack(spacing: isSquare ? 4 : 8) {
            Text("Start your path \u{2192}")
                .font(.system(size: isSquare ? 12 : 15, weight: .bold))
                .foregroundStyle(accentColor)
            Text("prooffd.app")
                .font(.system(size: isSquare ? 9 : 11, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.3))
        }
    }
}
