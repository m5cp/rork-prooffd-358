import SwiftUI

struct ShareCardPresenterSheet: View {
    let content: ShareCardContent
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedStyle: ShareCardStyle = .clean
    @State private var selectedFormat: ShareCardFormat = .story
    @State private var renderedImage: UIImage?
    @State private var showCheckmark: Bool = false
    @State private var isSaving: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        cardPreview
                            .padding(.horizontal, 20)
                            .padding(.top, 8)

                        stylePicker
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)
                }
                .scrollIndicators(.hidden)

                actionButtons
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Theme.background)
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Share Card")
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                }
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
        .onChange(of: selectedStyle) { _, _ in renderedImage = nil }
        .onChange(of: selectedFormat) { _, _ in renderedImage = nil }
    }

    private var formatPicker: some View {
        HStack(spacing: 10) {
            ForEach(ShareCardFormat.allCases) { fmt in
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        selectedFormat = fmt
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: fmt == .story ? "rectangle.portrait" : "square")
                            .font(.system(size: 12, weight: .medium))
                        Text(fmt.label)
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(selectedFormat == fmt ? .white : Theme.textSecondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(selectedFormat == fmt ? Theme.accent : Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 10))
                }
                .accessibilityLabel("\(fmt.rawValue) format, \(fmt.label) aspect ratio")
                .accessibilityAddTraits(selectedFormat == fmt ? .isSelected : [])
            }
        }
    }

    @ViewBuilder
    private var cardPreview: some View {
        let canvas = selectedFormat.canvasSize
        let maxPreviewWidth: CGFloat = 320
        let scale = min(maxPreviewWidth / canvas.width, 1.0)
        let previewWidth = canvas.width * scale
        let previewHeight = canvas.height * scale

        cardView
            .frame(width: canvas.width, height: canvas.height)
            .clipShape(.rect(cornerRadius: 20))
            .scaleEffect(scale, anchor: .top)
            .frame(width: previewWidth, height: previewHeight)
            .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }

    @ViewBuilder
    private var cardView: some View {
        switch content.type {
        case .quizResults:
            QuizResultsShareCardView(content: content, style: selectedStyle, format: selectedFormat)
        case .topMatch:
            TopMatchShareCardView(content: content, style: selectedStyle, format: selectedFormat)
        case .progress:
            ProgressShareCardView(content: content, style: selectedStyle, format: selectedFormat)
        }
    }

    private var stylePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Style")
                .font(.caption.weight(.medium))
                .foregroundStyle(Theme.textTertiary)

            HStack(spacing: 10) {
                ForEach(ShareCardStyle.allCases) { s in
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedStyle = s
                        }
                    } label: {
                        Text(s.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selectedStyle == s ? .white : Theme.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedStyle == s ? Theme.accent : Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                    .accessibilityLabel("\(s.rawValue) style")
                    .accessibilityAddTraits(selectedStyle == s ? .isSelected : [])
                }
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button {
                shareCard()
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
            .accessibilityLabel(showCheckmark ? "Card shared successfully" : "Share this card")
            .accessibilityHint("Opens the share sheet")

            Button {
                saveToPhotos()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isSaving ? "checkmark" : "arrow.down.to.line")
                        .font(.body.weight(.medium))
                    Text(isSaving ? "Saved!" : "Save to Photos")
                        .font(.body.weight(.medium))
                }
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
            .accessibilityLabel(isSaving ? "Saved to Photos" : "Save card to Photos")
        }
    }

    private func renderIfNeeded() {
        guard renderedImage == nil else { return }
        let canvas = selectedFormat.canvasSize
        let card = cardView
            .frame(width: canvas.width, height: canvas.height)
            .clipped()
        renderedImage = ShareCardRenderer.render(view: card, format: selectedFormat)
    }

    private func shareCard() {
        renderIfNeeded()
        guard let image = renderedImage else { return }
        let text = shareText
        ShareCardRenderer.share(image: image, text: text)
        appState.markResultShared()
        withAnimation(.spring(duration: 0.3)) { showCheckmark = true }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation { showCheckmark = false }
        }
    }

    private func saveToPhotos() {
        renderIfNeeded()
        guard let image = renderedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        withAnimation(.spring(duration: 0.3)) { isSaving = true }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation { isSaving = false }
        }
    }

    private var shareText: String {
        switch content.type {
        case .quizResults:
            return "I found my top matches on Prooffd! Download: https://apps.apple.com/app/prooffd/id6743071053"
        case .topMatch:
            return "My top match is \(content.jobTitle) at \(content.matchPercent)%! Find yours on Prooffd: https://apps.apple.com/app/prooffd/id6743071053"
        case .progress:
            return "I'm building \(content.buildName) \u{2014} \(content.progressPercent)% complete! Download Prooffd: https://apps.apple.com/app/prooffd/id6743071053"
        }
    }
}
