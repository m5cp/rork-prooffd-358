import SwiftUI
import UIKit

enum ScreenshotService {
    static func captureScreen() -> UIImage? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        let window = windowScene.keyWindow ?? windowScene.windows.first
        guard let window else { return nil }

        var topController: UIViewController? = window.rootViewController
        while let presented = topController?.presentedViewController {
            topController = presented
        }
        if let sheetView = topController?.view {
            let renderer = UIGraphicsImageRenderer(bounds: sheetView.bounds)
            return renderer.image { ctx in
                sheetView.drawHierarchy(in: sheetView.bounds, afterScreenUpdates: true)
            }
        }

        let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
        return renderer.image { ctx in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }
    }

    static func captureView(_ view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}
