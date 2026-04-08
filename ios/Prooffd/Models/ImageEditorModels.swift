import SwiftUI

nonisolated enum ImageFilter: String, CaseIterable, Identifiable, Sendable {
    case none = "Original"
    case vivid = "Vivid"
    case mono = "Mono"
    case noir = "Noir"
    case warm = "Warm"
    case cool = "Cool"
    case fade = "Fade"

    var id: String { rawValue }

    var ciFilterName: String? {
        switch self {
        case .none: return nil
        case .vivid: return "CIColorControls"
        case .mono: return "CIPhotoEffectMono"
        case .noir: return "CIPhotoEffectNoir"
        case .warm: return "CITemperatureAndTint"
        case .cool: return "CITemperatureAndTint"
        case .fade: return "CIPhotoEffectFade"
        }
    }
}

nonisolated enum EditorTool: String, CaseIterable, Identifiable, Sendable {
    case text = "Text"
    case draw = "Draw"
    case sticker = "Sticker"
    case filter = "Filter"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .text: return "textformat"
        case .draw: return "pencil.tip"
        case .sticker: return "face.smiling"
        case .filter: return "camera.filters"
        }
    }
}

struct TextOverlay: Identifiable {
    let id: String = UUID().uuidString
    var text: String
    var position: CGPoint
    var scale: CGFloat = 1.0
    var rotation: Angle = .zero
    var color: Color = .white
    var font: TextOverlayFont = .bold
    var hasBacking: Bool = true
}

nonisolated enum TextOverlayFont: String, CaseIterable, Identifiable, Sendable {
    case bold = "Bold"
    case serif = "Serif"
    case mono = "Mono"
    case rounded = "Rounded"

    var id: String { rawValue }

    var swiftUIFont: Font {
        switch self {
        case .bold: return .system(size: 24, weight: .bold)
        case .serif: return .system(size: 24, weight: .semibold, design: .serif)
        case .mono: return .system(size: 22, weight: .medium, design: .monospaced)
        case .rounded: return .system(size: 24, weight: .semibold, design: .rounded)
        }
    }
}

struct DrawingPath: Identifiable {
    let id: String = UUID().uuidString
    var points: [CGPoint] = []
    var color: Color = .white
    var lineWidth: CGFloat = 4.0
}

struct StickerOverlay: Identifiable {
    let id: String = UUID().uuidString
    var emoji: String
    var position: CGPoint
    var scale: CGFloat = 1.0
    var rotation: Angle = .zero
}
