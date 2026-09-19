import SwiftUI
import AVFoundation

/// Full-screen opening flash screen that plays the bundled brand video
/// for ~3 seconds, then fades out. Tap to skip.
struct SplashVideoView: View {
    let onFinish: () -> Void

    @State private var player: AVPlayer?
    @State private var opacity: Double = 1
    @State private var hasFinished = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if let player {
                PlayerLayerView(player: player)
                    .ignoresSafeArea()
            }
        }
        .opacity(opacity)
        .contentShape(Rectangle())
        .onTapGesture { finish() }
        .onAppear { startPlayback() }
    }

    private func startPlayback() {
        guard let url = Bundle.main.url(forResource: "SplashVideo", withExtension: "mp4") else {
            finish()
            return
        }
        let p = AVPlayer(url: url)
        p.automaticallyWaitsToMinimizeStalling = false
        p.actionAtItemEnd = .none
        player = p
        p.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { finish() }
    }

    private func finish() {
        guard !hasFinished else { return }
        hasFinished = true
        withAnimation(.easeOut(duration: 0.4)) {
            opacity = 0
        }
        player?.pause()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            onFinish()
        }
    }
}

/// SwiftUI wrapper around a control-free, aspect-fill `AVPlayerLayer`.
private struct PlayerLayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerLayerUIView {
        PlayerLayerUIView(player: player)
    }

    func updateUIView(_ uiView: PlayerLayerUIView, context: Context) {}
}

/// Backing `UIView` whose layer class is `AVPlayerLayer`.
private final class PlayerLayerUIView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    init(player: AVPlayer) {
        super.init(frame: .zero)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
