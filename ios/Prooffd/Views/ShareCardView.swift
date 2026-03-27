import SwiftUI

struct ShareCardView: View {
    let result: MatchResult
    let userName: String
    let totalMatches: Int
    @Environment(\.dismiss) private var dismiss
    @State private var renderedImage: UIImage?
    @State private var showCheckmark: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Preview")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Theme.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 12)

                        ShareScoreCardRenderable(
                            result: result,
                            userName: userName,
                            totalMatches: totalMatches
                        )
                        .padding(.horizontal, 24)
                    }
                }
                .scrollIndicators(.hidden)

                VStack(spacing: 12) {
                    Button {
                        shareImage()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: showCheckmark ? "checkmark" : "square.and.arrow.up")
                                .font(.body.weight(.semibold))
                            Text(showCheckmark ? "Shared!" : "Share Card")
                                .font(.body.weight(.semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(showCheckmark ? Theme.accent.opacity(0.7) : Theme.accent)
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .accessibilityLabel(showCheckmark ? "Card shared successfully" : "Share match card")
                    .accessibilityHint("Opens the share sheet to share your match card")

                    Button {
                        saveToPhotos()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.to.line")
                                .font(.body.weight(.medium))
                            Text("Save to Photos")
                                .font(.body.weight(.medium))
                        }
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .accessibilityLabel("Save match card to Photos")
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Theme.background)
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Theme.textTertiary)
                            .font(.title3)
                    }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
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
        if renderedImage == nil { renderImage() }
        guard let image = renderedImage else { return }

        let shareText = "Check out my top match on Prooffd! Download: https://apps.apple.com/app/prooffd/id6743071053"
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

    private func saveToPhotos() {
        if renderedImage == nil { renderImage() }
        guard let image = renderedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        withAnimation(.spring(duration: 0.3)) {
            showCheckmark = true
        }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation {
                showCheckmark = false
            }
        }
    }
}
