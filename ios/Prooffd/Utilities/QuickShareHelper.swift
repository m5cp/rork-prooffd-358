import SwiftUI

enum QuickShareHelper {
    static func shareExcitement(title: String, type: String) {
        let messages = [
            "I'm exploring \(title) as a \(type) on Prooffd!",
            "Just discovered \(title) on Prooffd — looks like a great \(type) path!",
            "Thinking about \(title) — exploring my options on Prooffd!"
        ]
        let message = messages.randomElement() ?? messages[0]
        let shareText = "\(message)\n\nFind your path: https://apps.apple.com/app/prooffd/id6743071053"
        presentShareSheet(items: [shareText])
    }

    static func shareBusiness(_ name: String) {
        shareExcitement(title: name, type: "business")
    }

    static func shareTrade(_ name: String) {
        shareExcitement(title: name, type: "career")
    }

    static func shareDegreeCareer(_ name: String) {
        shareExcitement(title: name, type: "career")
    }

    private static func presentShareSheet(items: [Any]) {
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = (windowScene.keyWindow ?? windowScene.windows.first)?.rootViewController {
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
