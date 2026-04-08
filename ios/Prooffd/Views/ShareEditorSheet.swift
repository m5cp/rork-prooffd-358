import SwiftUI

struct ShareEditorSheet: View {
    let capturedImage: UIImage
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ImageEditorView(
            originalImage: capturedImage,
            onShare: { _ in
                dismiss()
            }
        )
        .interactiveDismissDisabled()
    }
}

struct ScreenshotShareButton: View {
    @State private var capturedImage: UIImage?
    @State private var showEditor: Bool = false

    var body: some View {
        Button {
            captureAndShow()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                    .font(.caption)
                Text("Share")
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(Theme.textSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Theme.cardBackground)
            .clipShape(.capsule)
        }
        .fullScreenCover(isPresented: $showEditor) {
            if let image = capturedImage {
                ShareEditorSheet(capturedImage: image)
            }
        }
    }

    private func captureAndShow() {
        capturedImage = ScreenshotService.captureScreen()
        if capturedImage != nil {
            showEditor = true
        }
    }
}
