import SwiftUI

struct ShareCardRenderer {
    static func render<V: View>(view: V, format: ShareCardFormat) -> UIImage? {
        let canvas = format.canvasSize
        let card = view
            .frame(width: canvas.width, height: canvas.height)
            .clipped()

        let renderer = ImageRenderer(content: card)
        renderer.scale = format.size.width / canvas.width
        renderer.proposedSize = .init(width: canvas.width, height: canvas.height)
        return renderer.uiImage
    }

    static func share(image: UIImage, text: String) {
        let items: [Any] = [image, text]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = (windowScene.keyWindow ?? windowScene.windows.first)?.rootViewController else { return }
        var topController = root
        while let presented = topController.presentedViewController {
            topController = presented
        }
        activityVC.popoverPresentationController?.sourceView = topController.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(
            x: topController.view.bounds.midX,
            y: topController.view.bounds.midY,
            width: 0, height: 0
        )
        activityVC.popoverPresentationController?.permittedArrowDirections = []
        topController.present(activityVC, animated: true)
    }
}
