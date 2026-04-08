import SwiftUI
import UIKit

enum ScreenshotService {
    static func captureScreen() -> UIImage? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return nil }
        let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
        return renderer.image { ctx in
            window.layer.render(in: ctx.cgContext)
        }
    }

    static func captureView(_ view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { ctx in
            view.layer.render(in: ctx.cgContext)
        }
    }
}
