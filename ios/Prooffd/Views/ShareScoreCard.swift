import SwiftUI

struct ShareScoreCardRenderable: View {
    let result: MatchResult
    let userName: String
    let totalMatches: Int

    private var path: BusinessPath { result.businessPath }

    private var scoreColor: Color {
        if result.scorePercentage >= 80 { return Theme.accent }
        if result.scorePercentage >= 60 { return Theme.accentBlue }
        return .orange
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                Text("P R O O F F D")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(Color.white.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 6) {
                    Text("\(userName.isEmpty ? "Your" : userName + "'s") Results")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Matched from \(totalMatches)+ business paths")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(scoreColor.opacity(0.15), lineWidth: 8)
                            .frame(width: 90, height: 90)
                        Circle()
                            .trim(from: 0, to: Double(result.scorePercentage) / 100.0)
                            .stroke(scoreColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 90, height: 90)
                        VStack(spacing: 0) {
                            Text("\(result.scorePercentage)")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(scoreColor)
                            Text("Score")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(scoreColor.opacity(0.7))
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Best Match")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color(hex: "34D399"))

                        HStack(spacing: 8) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(scoreColor.opacity(0.15))
                                    .frame(width: 32, height: 32)
                                Image(systemName: path.icon)
                                    .font(.system(size: 14))
                                    .foregroundStyle(scoreColor)
                            }

                            Text(path.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Spacer(minLength: 0)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(hex: "111825"))
                )

                HStack(spacing: 16) {
                    statPill(icon: "dollarsign.circle.fill", label: "Startup", value: path.startupCostRange)
                    statPill(icon: "clock.fill", label: "First $", value: path.timeToFirstDollar)
                }
            }
            .padding(24)
            .background(
                LinearGradient(
                    colors: [Color(hex: "0D1220"), Color(hex: "111B30"), Color(hex: "0B1525")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            HStack {
                Text("Find your path at")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.4))
                Text("prooffd.app")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color(hex: "34D399").opacity(0.8))
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white.opacity(0.4))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color(hex: "080C16"))
        }
        .clipShape(.rect(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [scoreColor.opacity(0.25), scoreColor.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }

    private func statPill(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(Color.white.opacity(0.4))
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.4))
                Text(value)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
    }
}

struct ShareCardPreviewSheet: View {
    let result: MatchResult
    let userName: String
    let totalMatches: Int
    @Environment(\.dismiss) private var dismiss
    @State private var renderedImage: UIImage?

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Share Your Match")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            ScrollView {
                ShareScoreCardRenderable(
                    result: result,
                    userName: userName,
                    totalMatches: totalMatches
                )
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)

            Button {
                shareImage()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.body.weight(.semibold))
                    Text("Share Card")
                        .font(.body.weight(.semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.accent)
                .clipShape(.rect(cornerRadius: 14))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .background(Theme.background)
        .onAppear {
            renderImage()
        }
    }

    private func renderImage() {
        let card = ShareScoreCardRenderable(
            result: result,
            userName: userName,
            totalMatches: totalMatches
        )
        .frame(width: 340)
        .padding(16)
        .background(Color(hex: "0F1117"))

        let renderer = ImageRenderer(content: card)
        renderer.scale = 3.0
        renderedImage = renderer.uiImage
    }

    private func shareImage() {
        if renderedImage == nil {
            renderImage()
        }
        guard let image = renderedImage else { return }

        let shareText = "Check out my match on Prooffd! Download: https://apps.apple.com/app/prooffd/id6743071053"
        let activityVC = UIActivityViewController(activityItems: [image, shareText], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            var topController = root
            while let presented = topController.presentedViewController {
                topController = presented
            }
            activityVC.popoverPresentationController?.sourceView = topController.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: topController.view.bounds.midX, y: topController.view.bounds.midY, width: 0, height: 0)
            activityVC.popoverPresentationController?.permittedArrowDirections = []
            topController.present(activityVC, animated: true)
        }
    }
}

struct ShareScoreCard: View {
    let result: MatchResult
    let userName: String
    let totalMatches: Int

    var body: some View {
        ShareScoreCardRenderable(
            result: result,
            userName: userName,
            totalMatches: totalMatches
        )
    }
}
