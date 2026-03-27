import SwiftUI

struct TopMatchShareCardView: View {
    let content: ShareCardContent
    let style: ShareCardStyle
    let format: ShareCardFormat

    private var isSquare: Bool { format == .square }

    private var bg: some View {
        Group {
            switch style {
            case .clean:
                LinearGradient(
                    colors: [Color(hex: "0C1018"), Color(hex: "0F1A2B"), Color(hex: "0A1220")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            case .bold:
                ZStack {
                    Color(hex: "0A0E1A")
                    LinearGradient(
                        colors: [Color(hex: "34D399").opacity(0.15), Color.clear],
                        startPoint: .topTrailing, endPoint: .bottomLeading
                    )
                }
            case .premium:
                LinearGradient(
                    colors: [Color(hex: "0D0D0D"), Color(hex: "1C1524"), Color(hex: "0D0D12")],
                    startPoint: .top, endPoint: .bottom
                )
            }
        }
    }

    private var accentColor: Color {
        switch style {
        case .clean: return Color(hex: "34D399")
        case .bold: return Color(hex: "34D399")
        case .premium: return Color(hex: "C4B5FD")
        }
    }

    private var matchColor: Color {
        if content.matchPercent >= 80 { return Color(hex: "34D399") }
        if content.matchPercent >= 60 { return Color(hex: "60A5FA") }
        return .orange
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer(minLength: isSquare ? 16 : 44)
                brandLabel
                Spacer(minLength: isSquare ? 10 : 24)
                headerLine
                Spacer(minLength: isSquare ? 8 : 16)
                jobTitle
                Spacer(minLength: isSquare ? 10 : 20)
                matchCircle
                Spacer(minLength: isSquare ? 10 : 20)
                infoStack
                Spacer(minLength: isSquare ? 8 : 16)
                perfectForLine
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
        Text("You're Built For:")
            .font(.system(size: isSquare ? 13 : 16, weight: .semibold))
            .foregroundStyle(accentColor)
    }

    private var jobTitle: some View {
        Text(content.jobTitle)
            .font(.system(size: isSquare ? 26 : 36, weight: .heavy))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .minimumScaleFactor(0.7)
    }

    private var matchCircle: some View {
        ZStack {
            Circle()
                .stroke(matchColor.opacity(0.12), lineWidth: isSquare ? 6 : 8)
            Circle()
                .trim(from: 0, to: Double(content.matchPercent) / 100.0)
                .stroke(matchColor, style: StrokeStyle(lineWidth: isSquare ? 6 : 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text("\(content.matchPercent)%")
                    .font(.system(size: isSquare ? 28 : 38, weight: .bold, design: .rounded))
                    .foregroundStyle(matchColor)
                Text("Match")
                    .font(.system(size: isSquare ? 9 : 11, weight: .semibold))
                    .foregroundStyle(matchColor.opacity(0.7))
            }
        }
        .frame(width: isSquare ? 90 : 120, height: isSquare ? 90 : 120)
    }

    private var infoStack: some View {
        VStack(spacing: isSquare ? 6 : 10) {
            infoRow(icon: content.aiZone.icon, text: "AI Safe Zone: \(zoneName)")
            if !content.typicalRate.isEmpty {
                infoRow(icon: "dollarsign.circle.fill", text: content.typicalRate)
            }
        }
    }

    private var zoneName: String {
        switch content.aiZone {
        case .safe: return "High"
        case .human: return "Medium"
        case .augmented: return "Low"
        }
    }

    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: isSquare ? 11 : 13))
                .foregroundStyle(Color.white.opacity(0.5))
            Text(text)
                .font(.system(size: isSquare ? 12 : 14, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.75))
                .lineLimit(1)
        }
    }

    private var perfectForLine: some View {
        Group {
            if !content.perfectFor.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: isSquare ? 10 : 12))
                    Text("Perfect for: \(content.perfectFor)")
                        .font(.system(size: isSquare ? 11 : 13, weight: .medium))
                }
                .foregroundStyle(accentColor.opacity(0.8))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(accentColor.opacity(0.08))
                .clipShape(.rect(cornerRadius: 20))
            }
        }
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
