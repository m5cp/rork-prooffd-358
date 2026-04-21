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
    @State private var isCapturing: Bool = false

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
        .disabled(isCapturing)
        .fullScreenCover(isPresented: $showEditor, onDismiss: {
            capturedImage = nil
        }) {
            if let image = capturedImage {
                ShareEditorSheet(capturedImage: image)
            } else {
                Color.black
                    .ignoresSafeArea()
                    .onAppear { showEditor = false }
            }
        }
    }

    private func captureAndShow() {
        isCapturing = true
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(100))
            let image = ScreenshotService.captureScreen()
            capturedImage = image
            isCapturing = false
            if image != nil {
                showEditor = true
            }
        }
    }
}
