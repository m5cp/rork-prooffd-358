import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageEditorView: View {
    let originalImage: UIImage
    let onShare: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTool: EditorTool? = nil
    @State private var selectedFilter: ImageFilter = .none
    @State private var textOverlays: [TextOverlay] = []
    @State private var stickerOverlays: [StickerOverlay] = []
    @State private var drawingPaths: [DrawingPath] = []
    @State private var currentDrawingPath: DrawingPath? = nil
    @State private var drawColor: Color = .white
    @State private var drawLineWidth: CGFloat = 4.0
    @State private var showTextInput: Bool = false
    @State private var newTextValue: String = ""
    @State private var editingTextID: String? = nil
    @State private var selectedTextColor: Color = .white
    @State private var selectedTextFont: TextOverlayFont = .bold
    @State private var selectedTextBacking: Bool = true
    @State private var showStickerPicker: Bool = false
    @State private var isSaving: Bool = false
    @State private var showCheckmark: Bool = false
    @State private var filteredImage: UIImage?
    @State private var activeOverlayID: String? = nil

    private let context = CIContext()
    private let stickerOptions: [String] = [
        "🔥", "💯", "⭐️", "🚀", "💪", "🎯", "👏", "🏆",
        "💡", "📈", "✨", "🎉", "💎", "🧠", "⚡️", "🌟",
        "👑", "🔑", "🎓", "💼", "🛠️", "❤️", "💰", "🤑"
    ]

    private var displayImage: UIImage {
        filteredImage ?? originalImage
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                imageCanvas
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                editorToolBar
                    .padding(.top, 8)

                if showStickerPicker && selectedTool == .sticker {
                    stickerGrid
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else if selectedTool == .filter {
                    filterStrip
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else if selectedTool == .draw {
                    drawControls
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                actionButtons
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Edit & Share")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        undoLast()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.body.weight(.medium))
                            .foregroundStyle(.white.opacity(canUndo ? 1.0 : 0.3))
                    }
                    .disabled(!canUndo)
                }
            }
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showTextInput) {
            TextInputSheet(
                text: $newTextValue,
                color: $selectedTextColor,
                font: $selectedTextFont,
                hasBacking: $selectedTextBacking,
                onConfirm: {
                    addOrUpdateText()
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .presentationBackground(.ultraThinMaterial)
        }
        .onChange(of: selectedFilter) { _, newFilter in
            applyFilter(newFilter)
        }
    }

    private var canUndo: Bool {
        !textOverlays.isEmpty || !stickerOverlays.isEmpty || !drawingPaths.isEmpty || selectedFilter != .none
    }

    private var imageCanvas: some View {
        GeometryReader { geo in
            let imageSize = originalImage.size
            let scale = min(geo.size.width / imageSize.width, geo.size.height / imageSize.height)
            let scaledW = imageSize.width * scale
            let scaledH = imageSize.height * scale
            let offsetX = (geo.size.width - scaledW) / 2
            let offsetY = (geo.size.height - scaledH) / 2

            ZStack {
                Image(uiImage: displayImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .allowsHitTesting(false)

                Canvas { ctx, size in
                    for path in drawingPaths {
                        drawPath(path, in: &ctx, canvasSize: size, imageRect: CGRect(x: offsetX, y: offsetY, width: scaledW, height: scaledH))
                    }
                    if let current = currentDrawingPath {
                        drawPath(current, in: &ctx, canvasSize: size, imageRect: CGRect(x: offsetX, y: offsetY, width: scaledW, height: scaledH))
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .allowsHitTesting(false)

                ForEach($textOverlays) { $overlay in
                    DraggableTextOverlay(
                        overlay: $overlay,
                        isActive: activeOverlayID == overlay.id,
                        onTap: {
                            activeOverlayID = overlay.id
                            editingTextID = overlay.id
                            newTextValue = overlay.text
                            selectedTextColor = overlay.color
                            selectedTextFont = overlay.font
                            selectedTextBacking = overlay.hasBacking
                            showTextInput = true
                        },
                        containerSize: geo.size
                    )
                }

                ForEach($stickerOverlays) { $sticker in
                    DraggableStickerOverlay(
                        sticker: $sticker,
                        isActive: activeOverlayID == sticker.id,
                        onTap: { activeOverlayID = sticker.id },
                        containerSize: geo.size
                    )
                }
            }
            .contentShape(Rectangle())
            .gesture(
                selectedTool == .draw ?
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = value.location
                        if currentDrawingPath == nil {
                            currentDrawingPath = DrawingPath(color: drawColor, lineWidth: drawLineWidth)
                        }
                        currentDrawingPath?.points.append(point)
                    }
                    .onEnded { _ in
                        if let path = currentDrawingPath {
                            drawingPaths.append(path)
                            currentDrawingPath = nil
                        }
                    }
                : nil
            )
            .onTapGesture {
                if selectedTool == .text {
                    editingTextID = nil
                    newTextValue = ""
                    selectedTextColor = .white
                    selectedTextFont = .bold
                    selectedTextBacking = true
                    showTextInput = true
                } else {
                    activeOverlayID = nil
                }
            }
        }
    }

    private func drawPath(_ path: DrawingPath, in ctx: inout GraphicsContext, canvasSize: CGSize, imageRect: CGRect) {
        guard path.points.count > 1 else { return }
        var swiftPath = Path()
        swiftPath.move(to: path.points[0])
        for i in 1..<path.points.count {
            swiftPath.addLine(to: path.points[i])
        }
        ctx.stroke(swiftPath, with: .color(path.color), style: StrokeStyle(lineWidth: path.lineWidth, lineCap: .round, lineJoin: .round))
    }

    private var editorToolBar: some View {
        HStack(spacing: 0) {
            ForEach(EditorTool.allCases) { tool in
                Button {
                    withAnimation(.snappy(duration: 0.25)) {
                        if selectedTool == tool {
                            if tool == .sticker {
                                showStickerPicker.toggle()
                            } else {
                                selectedTool = nil
                            }
                        } else {
                            selectedTool = tool
                            if tool == .sticker {
                                showStickerPicker = true
                            } else {
                                showStickerPicker = false
                            }
                        }
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tool.icon)
                            .font(.system(size: 20, weight: .medium))
                        Text(tool.rawValue)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(selectedTool == tool ? Theme.accent : .white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private var stickerGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 8), spacing: 10) {
            ForEach(stickerOptions, id: \.self) { emoji in
                Button {
                    addSticker(emoji)
                } label: {
                    Text(emoji)
                        .font(.system(size: 28))
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.08))
        .clipShape(.rect(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    private var filterStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ImageFilter.allCases) { filter in
                    Button {
                        withAnimation(.snappy(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    } label: {
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(filterPreviewColor(filter))
                                .frame(width: 52, height: 52)
                                .overlay {
                                    Image(uiImage: originalImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 52, height: 52)
                                        .clipShape(.rect(cornerRadius: 8))
                                        .opacity(0.7)
                                        .allowsHitTesting(false)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedFilter == filter ? Theme.accent : .clear, lineWidth: 2)
                                )

                            Text(filter.rawValue)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(selectedFilter == filter ? Theme.accent : .white.opacity(0.6))
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }

    private var drawControls: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                ForEach([Color.white, Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.pink], id: \.self) { color in
                    Button {
                        drawColor = color
                    } label: {
                        Circle()
                            .fill(color)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle()
                                    .stroke(drawColor == color ? .white : .clear, lineWidth: 2)
                                    .padding(-2)
                            )
                    }
                }
            }

            HStack(spacing: 12) {
                Image(systemName: "minus")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
                Slider(value: $drawLineWidth, in: 2...20, step: 1)
                    .tint(Theme.accent)
                Image(systemName: "plus")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                saveToPhotos()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down.to.line")
                        .font(.body.weight(.medium))
                    Text("Save")
                        .font(.body.weight(.medium))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.15))
                .clipShape(.rect(cornerRadius: 12))
            }

            Button {
                shareEditedImage()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: showCheckmark ? "checkmark" : "square.and.arrow.up")
                        .font(.body.weight(.semibold))
                    Text(showCheckmark ? "Shared!" : "Share")
                        .font(.body.weight(.semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(showCheckmark ? Theme.accent.opacity(0.7) : Theme.accent)
                .clipShape(.rect(cornerRadius: 12))
            }
        }
    }

    private func filterPreviewColor(_ filter: ImageFilter) -> Color {
        switch filter {
        case .none: return .clear
        case .vivid: return .orange.opacity(0.2)
        case .mono: return .gray.opacity(0.3)
        case .noir: return .black.opacity(0.4)
        case .warm: return .orange.opacity(0.15)
        case .cool: return .blue.opacity(0.15)
        case .fade: return .white.opacity(0.2)
        }
    }

    private func applyFilter(_ filter: ImageFilter) {
        guard filter != .none else {
            filteredImage = nil
            return
        }
        guard let ciImage = CIImage(image: originalImage) else { return }

        let output: CIImage?
        switch filter {
        case .none:
            output = ciImage
        case .vivid:
            let f = CIFilter.colorControls()
            f.inputImage = ciImage
            f.saturation = 1.5
            f.contrast = 1.1
            f.brightness = 0.02
            output = f.outputImage
        case .mono:
            let f = CIFilter.photoEffectMono()
            f.inputImage = ciImage
            output = f.outputImage
        case .noir:
            let f = CIFilter.photoEffectNoir()
            f.inputImage = ciImage
            output = f.outputImage
        case .warm:
            let f = CIFilter.temperatureAndTint()
            f.inputImage = ciImage
            f.neutral = CIVector(x: 7000, y: 0)
            output = f.outputImage
        case .cool:
            let f = CIFilter.temperatureAndTint()
            f.inputImage = ciImage
            f.neutral = CIVector(x: 4000, y: 0)
            output = f.outputImage
        case .fade:
            let f = CIFilter.photoEffectFade()
            f.inputImage = ciImage
            output = f.outputImage
        }

        guard let outputImage = output,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        filteredImage = UIImage(cgImage: cgImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
    }

    private func addOrUpdateText() {
        guard !newTextValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        if let editID = editingTextID,
           let idx = textOverlays.firstIndex(where: { $0.id == editID }) {
            textOverlays[idx].text = newTextValue
            textOverlays[idx].color = selectedTextColor
            textOverlays[idx].font = selectedTextFont
            textOverlays[idx].hasBacking = selectedTextBacking
        } else {
            let overlay = TextOverlay(
                text: newTextValue,
                position: CGPoint(x: 0.5, y: 0.4),
                color: selectedTextColor,
                font: selectedTextFont,
                hasBacking: selectedTextBacking
            )
            textOverlays.append(overlay)
        }
        editingTextID = nil
        newTextValue = ""
    }

    private func addSticker(_ emoji: String) {
        let sticker = StickerOverlay(
            emoji: emoji,
            position: CGPoint(x: CGFloat.random(in: 0.3...0.7), y: CGFloat.random(in: 0.3...0.6))
        )
        stickerOverlays.append(sticker)
        activeOverlayID = sticker.id
    }

    private func undoLast() {
        if !drawingPaths.isEmpty {
            drawingPaths.removeLast()
        } else if !stickerOverlays.isEmpty {
            stickerOverlays.removeLast()
        } else if !textOverlays.isEmpty {
            textOverlays.removeLast()
        } else if selectedFilter != .none {
            selectedFilter = .none
        }
    }

    private func composeFinalImage() -> UIImage {
        let size = originalImage.size
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            displayImage.draw(in: CGRect(origin: .zero, size: size))

            let scaleX = size.width
            let scaleY = size.height

            for path in drawingPaths {
                guard path.points.count > 1 else { continue }
                let bezier = UIBezierPath()
                bezier.move(to: path.points[0])
                for i in 1..<path.points.count {
                    bezier.addLine(to: path.points[i])
                }
                bezier.lineWidth = path.lineWidth * (size.width / UIScreen.main.bounds.width)
                bezier.lineCapStyle = .round
                bezier.lineJoinStyle = .round
                UIColor(path.color).setStroke()
                bezier.stroke()
            }

            for overlay in textOverlays {
                let fontSize: CGFloat
                switch overlay.font {
                case .bold: fontSize = 24
                case .serif: fontSize = 24
                case .mono: fontSize = 22
                case .rounded: fontSize = 24
                }
                let scaledFontSize = fontSize * overlay.scale * (size.width / 390)
                let uiFont: UIFont
                switch overlay.font {
                case .bold: uiFont = .systemFont(ofSize: scaledFontSize, weight: .bold)
                case .serif: uiFont = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body).withDesign(.serif)!, size: scaledFontSize)
                case .mono: uiFont = .monospacedSystemFont(ofSize: scaledFontSize, weight: .medium)
                case .rounded: uiFont = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body).withDesign(.rounded)!, size: scaledFontSize)
                }

                let attrs: [NSAttributedString.Key: Any] = [
                    .font: uiFont,
                    .foregroundColor: UIColor(overlay.color)
                ]
                let textSize = (overlay.text as NSString).size(withAttributes: attrs)
                let x = overlay.position.x * scaleX - textSize.width / 2
                let y = overlay.position.y * scaleY - textSize.height / 2

                if overlay.hasBacking {
                    let backingRect = CGRect(x: x - 8, y: y - 4, width: textSize.width + 16, height: textSize.height + 8)
                    let backingPath = UIBezierPath(roundedRect: backingRect, cornerRadius: 6)
                    UIColor.black.withAlphaComponent(0.5).setFill()
                    backingPath.fill()
                }

                (overlay.text as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: attrs)
            }

            for sticker in stickerOverlays {
                let emojiSize = 40 * sticker.scale * (size.width / 390)
                let uiFont = UIFont.systemFont(ofSize: emojiSize)
                let attrs: [NSAttributedString.Key: Any] = [.font: uiFont]
                let textSize = (sticker.emoji as NSString).size(withAttributes: attrs)
                let x = sticker.position.x * scaleX - textSize.width / 2
                let y = sticker.position.y * scaleY - textSize.height / 2
                (sticker.emoji as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: attrs)
            }
        }
    }

    private func shareEditedImage() {
        let finalImage = composeFinalImage()
        let shareText = "Check out what I found on Prooffd! Download: https://apps.apple.com/app/prooffd/id6743071053"
        let activityVC = UIActivityViewController(activityItems: [finalImage, shareText], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            var topController = root
            while let presented = topController.presentedViewController { topController = presented }
            activityVC.popoverPresentationController?.sourceView = topController.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: topController.view.bounds.midX, y: topController.view.bounds.midY, width: 0, height: 0)
            activityVC.popoverPresentationController?.permittedArrowDirections = []
            topController.present(activityVC, animated: true)
        }
        withAnimation(.spring(duration: 0.3)) { showCheckmark = true }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation { showCheckmark = false }
        }
    }

    private func saveToPhotos() {
        let finalImage = composeFinalImage()
        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
        withAnimation(.spring(duration: 0.3)) { isSaving = true }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation { isSaving = false }
        }
    }
}

struct DraggableTextOverlay: View {
    @Binding var overlay: TextOverlay
    let isActive: Bool
    let onTap: () -> Void
    let containerSize: CGSize

    @State private var dragOffset: CGSize = .zero

    var body: some View {
        Text(overlay.text)
            .font(overlay.font.swiftUIFont)
            .foregroundStyle(overlay.color)
            .scaleEffect(overlay.scale)
            .rotationEffect(overlay.rotation)
            .padding(.horizontal, overlay.hasBacking ? 10 : 0)
            .padding(.vertical, overlay.hasBacking ? 5 : 0)
            .background(overlay.hasBacking ? Color.black.opacity(0.5) : .clear)
            .clipShape(.rect(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isActive ? Theme.accent : .clear, lineWidth: 1.5)
                    .padding(-2)
            )
            .position(
                x: overlay.position.x * containerSize.width + dragOffset.width,
                y: overlay.position.y * containerSize.height + dragOffset.height
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        overlay.position.x += value.translation.width / containerSize.width
                        overlay.position.y += value.translation.height / containerSize.height
                        overlay.position.x = max(0.05, min(0.95, overlay.position.x))
                        overlay.position.y = max(0.05, min(0.95, overlay.position.y))
                        dragOffset = .zero
                    }
            )
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        overlay.scale = max(0.5, min(3.0, value.magnification))
                    }
            )
            .onTapGesture {
                onTap()
            }
    }
}

struct DraggableStickerOverlay: View {
    @Binding var sticker: StickerOverlay
    let isActive: Bool
    let onTap: () -> Void
    let containerSize: CGSize

    @State private var dragOffset: CGSize = .zero

    var body: some View {
        Text(sticker.emoji)
            .font(.system(size: 40))
            .scaleEffect(sticker.scale)
            .rotationEffect(sticker.rotation)
            .overlay(
                Circle()
                    .stroke(isActive ? Theme.accent : .clear, lineWidth: 1.5)
                    .frame(width: 50, height: 50)
            )
            .position(
                x: sticker.position.x * containerSize.width + dragOffset.width,
                y: sticker.position.y * containerSize.height + dragOffset.height
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        sticker.position.x += value.translation.width / containerSize.width
                        sticker.position.y += value.translation.height / containerSize.height
                        sticker.position.x = max(0.05, min(0.95, sticker.position.x))
                        sticker.position.y = max(0.05, min(0.95, sticker.position.y))
                        dragOffset = .zero
                    }
            )
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        sticker.scale = max(0.5, min(3.0, value.magnification))
                    }
            )
            .onTapGesture {
                onTap()
            }
    }
}

struct TextInputSheet: View {
    @Binding var text: String
    @Binding var color: Color
    @Binding var font: TextOverlayFont
    @Binding var hasBacking: Bool
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    private let colorOptions: [Color] = [.white, .black, .red, .orange, .yellow, .green, .blue, .purple, .pink, .cyan]

    var body: some View {
        VStack(spacing: 16) {
            Text("Add Text")
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.top, 16)

            TextField("Type something...", text: $text)
                .font(.system(size: 18, weight: .medium))
                .padding(14)
                .background(Color(.secondarySystemBackground))
                .clipShape(.rect(cornerRadius: 12))
                .padding(.horizontal, 20)

            HStack(spacing: 8) {
                ForEach(TextOverlayFont.allCases) { f in
                    Button {
                        font = f
                    } label: {
                        Text(f.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(font == f ? .white : .secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(font == f ? Theme.accent : Color(.tertiarySystemBackground))
                            .clipShape(.capsule)
                    }
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(colorOptions, id: \.self) { c in
                        Button {
                            color = c
                        } label: {
                            Circle()
                                .fill(c)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(color == c ? Color.primary : .clear, lineWidth: 2)
                                        .padding(-2)
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            Toggle(isOn: $hasBacking) {
                HStack(spacing: 8) {
                    Image(systemName: "rectangle.fill")
                        .font(.caption)
                    Text("Background")
                        .font(.subheadline.weight(.medium))
                }
            }
            .tint(Theme.accent)
            .padding(.horizontal, 20)

            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.body.weight(.medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.tertiarySystemBackground))
                        .clipShape(.rect(cornerRadius: 12))
                }

                Button {
                    onConfirm()
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(text.trimmingCharacters(in: .whitespaces).isEmpty ? Theme.accent.opacity(0.4) : Theme.accent)
                        .clipShape(.rect(cornerRadius: 12))
                }
                .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
}
