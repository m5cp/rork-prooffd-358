import SwiftUI

extension View {
    func cardShadow() -> some View {
        self.shadow(color: Theme.cardShadow, radius: 8, x: 0, y: 2)
    }
}
