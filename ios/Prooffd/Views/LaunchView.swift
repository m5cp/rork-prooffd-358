import SwiftUI

struct LaunchView: View {
    var onFinished: () -> Void

    @State private var phase: LaunchPhase = .dark
    @State private var particles: [LaunchParticle] = []
    @State private var ringScale: CGFloat = 0.0
    @State private var ringOpacity: Double = 0.0
    @State private var secondRingScale: CGFloat = 0.0
    @State private var secondRingOpacity: Double = 0.0
    @State private var iconScale: CGFloat = 0.3
    @State private var iconOpacity: Double = 0.0
    @State private var iconRotation: Double = -30
    @State private var titleOffset: CGFloat = 40
    @State private var titleOpacity: Double = 0.0
    @State private var taglineOpacity: Double = 0.0
    @State private var taglineOffset: CGFloat = 20
    @State private var meshPhase: CGFloat = 0.0
    @State private var glowOpacity: Double = 0.0
    @State private var glowScale: CGFloat = 0.5
    @State private var exitScale: CGFloat = 1.0
    @State private var exitOpacity: Double = 1.0
    @State private var letterRevealProgress: CGFloat = 0.0
    @State private var shockwaveScale: CGFloat = 0.0
    @State private var shockwaveOpacity: Double = 0.0
    @State private var accentLineWidth: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let brandLetters: [BrandLetter] = {
        let word = "PROOFFD"
        return word.enumerated().map { index, char in
            BrandLetter(id: index, character: String(char))
        }
    }()

    var body: some View {
        ZStack {
            animatedBackground
            shockwaveLayer
            particleField
            centralContent
        }
        .scaleEffect(exitScale)
        .opacity(exitOpacity)
        .ignoresSafeArea()
        .onAppear {
            if reduceMotion {
                phase = .complete
                iconOpacity = 1
                iconScale = 1
                titleOpacity = 1
                taglineOpacity = 1
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(1))
                    onFinished()
                }
                return
            }
            runSequence()
        }
    }

    // MARK: - Background

    private var animatedBackground: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], SIMD2<Float>(0.5 + Float(meshPhase) * 0.1, 0.5), [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ],
                colors: [
                    Color(hex: "050508"), Color(hex: "0A0F12"), Color(hex: "050508"),
                    Color(hex: "081210"), meshGlowColor, Color(hex: "0A0D14"),
                    Color(hex: "050508"), Color(hex: "080C10"), Color(hex: "050508")
                ]
            )
            .ignoresSafeArea()
            .opacity(phase == .dark ? 0 : 1)
        }
    }

    private var meshGlowColor: Color {
        switch phase {
        case .dark: Color(hex: "050508")
        case .ignite, .burst: Color(hex: "0D3D2E")
        case .reveal, .hold, .complete: Color(hex: "0A2E22")
        }
    }

    // MARK: - Shockwave

    private var shockwaveLayer: some View {
        ZStack {
            Circle()
                .stroke(
                    Theme.accent.opacity(shockwaveOpacity * 0.6),
                    lineWidth: 2
                )
                .frame(width: 300, height: 300)
                .scaleEffect(shockwaveScale)

            Circle()
                .stroke(
                    Theme.accent.opacity(ringOpacity),
                    lineWidth: 1.5
                )
                .frame(width: 160, height: 160)
                .scaleEffect(ringScale)

            Circle()
                .stroke(
                    Theme.accentBlue.opacity(secondRingOpacity),
                    lineWidth: 1
                )
                .frame(width: 220, height: 220)
                .scaleEffect(secondRingScale)
        }
    }

    // MARK: - Particles

    private var particleField: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: phase == .dark || phase == .complete)) { timeline in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let now = timeline.date.timeIntervalSinceReferenceDate

                for particle in particles {
                    let age = now - particle.birthTime
                    guard age < particle.lifetime else { continue }
                    let progress = age / particle.lifetime

                    let distance = particle.speed * age
                    let x = center.x + cos(particle.angle) * distance
                    let y = center.y + sin(particle.angle) * distance - (particle.hasGravity ? 30 * progress * progress : 0)

                    let fade = 1.0 - pow(progress, 1.5)
                    let size = particle.size * (1.0 - progress * 0.5)

                    let color = particle.color.opacity(fade)
                    let rect = CGRect(x: x - size / 2, y: y - size / 2, width: size, height: size)

                    if particle.isGlow {
                        context.fill(Circle().path(in: rect.insetBy(dx: -2, dy: -2)), with: .color(color.opacity(fade * 0.3)))
                    }
                    context.fill(Circle().path(in: rect), with: .color(color))
                }
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Central Content

    private var centralContent: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.accent.opacity(glowOpacity * 0.4), .clear],
                            center: .center,
                            startRadius: 10,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)
                    .scaleEffect(glowScale)

                iconBadge
            }

            brandTitle
                .padding(.top, 32)

            tagline
                .padding(.top, 12)

            accentLine
                .padding(.top, 20)

            Spacer()
            Spacer()
        }
    }

    private var iconBadge: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "059669"), Color(hex: "047857")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .shadow(color: Theme.accent.opacity(0.5), radius: 30, y: 0)

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.white)
                .shadow(color: .white.opacity(0.3), radius: 8)
        }
        .scaleEffect(iconScale)
        .opacity(iconOpacity)
        .rotationEffect(.degrees(iconRotation))
    }

    private var brandTitle: some View {
        HStack(spacing: 2) {
            ForEach(brandLetters) { letter in
                Text(letter.character)
                    .font(.system(size: 38, weight: .black, design: .default).width(.expanded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(hex: "B0B8C8")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(letterOpacity(for: letter.id))
                    .offset(y: letterYOffset(for: letter.id))
                    .scaleEffect(letterScale(for: letter.id))
            }
        }
        .opacity(titleOpacity)
        .offset(y: titleOffset)
    }

    private var tagline: some View {
        Text("Prove Your Path")
            .font(.subheadline.weight(.medium))
            .foregroundStyle(
                LinearGradient(
                    colors: [Theme.accent, Theme.accentBlue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .opacity(taglineOpacity)
            .offset(y: taglineOffset)
    }

    private var accentLine: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    colors: [Theme.accent.opacity(0), Theme.accent, Theme.accentBlue, Theme.accentBlue.opacity(0)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: accentLineWidth, height: 2)
            .opacity(taglineOpacity)
    }

    // MARK: - Letter Animations

    private func letterOpacity(for index: Int) -> Double {
        let threshold = Double(index) / Double(brandLetters.count)
        return Double(letterRevealProgress) > threshold ? 1.0 : 0.0
    }

    private func letterYOffset(for index: Int) -> CGFloat {
        let threshold = Double(index) / Double(brandLetters.count)
        return Double(letterRevealProgress) > threshold ? 0 : 15
    }

    private func letterScale(for index: Int) -> CGFloat {
        let threshold = Double(index) / Double(brandLetters.count)
        return Double(letterRevealProgress) > threshold ? 1.0 : 0.6
    }

    // MARK: - Animation Sequence

    private func runSequence() {
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(200))
            phase = .ignite
            spawnBurstParticles(count: 30)

            withAnimation(.spring(duration: 0.6, bounce: 0.4)) {
                iconScale = 1.0
                iconOpacity = 1.0
                iconRotation = 0
            }

            withAnimation(.easeOut(duration: 0.8)) {
                glowOpacity = 1.0
                glowScale = 1.0
            }

            withAnimation(.easeOut(duration: 0.5)) {
                meshPhase = 1.0
            }

            withAnimation(.easeOut(duration: 0.6)) {
                ringScale = 2.5
                ringOpacity = 0.8
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.05)) {
                ringOpacity = 0.0
            }

            try? await Task.sleep(for: .milliseconds(350))
            phase = .burst
            spawnBurstParticles(count: 20)

            withAnimation(.easeOut(duration: 0.7)) {
                shockwaveScale = 3.0
                shockwaveOpacity = 0.8
            }
            withAnimation(.easeOut(duration: 0.7).delay(0.1)) {
                shockwaveOpacity = 0.0
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.05)) {
                secondRingScale = 2.0
                secondRingOpacity = 0.6
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
                secondRingOpacity = 0.0
            }

            try? await Task.sleep(for: .milliseconds(300))
            phase = .reveal

            withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                titleOpacity = 1.0
                titleOffset = 0
            }

            withAnimation(.easeOut(duration: 0.45)) {
                letterRevealProgress = 1.0
            }

            spawnAmbientParticles(count: 12)

            try? await Task.sleep(for: .milliseconds(400))
            withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                taglineOpacity = 1.0
                taglineOffset = 0
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.1)) {
                accentLineWidth = 120
            }

            try? await Task.sleep(for: .seconds(1.05))
            phase = .hold

            try? await Task.sleep(for: .milliseconds(300))
            phase = .complete
            withAnimation(.spring(duration: 0.5, bounce: 0.0)) {
                exitScale = 1.08
                exitOpacity = 0
            } completion: {
                onFinished()
            }
        }
    }

    // MARK: - Particle Spawning

    private func spawnBurstParticles(count: Int) {
        let now = Date.now.timeIntervalSinceReferenceDate
        let colors: [Color] = [Theme.accent, Theme.accentBlue, .white, Color(hex: "34D399"), Color(hex: "60A5FA")]

        for i in 0..<count {
            let angle = (Double(i) / Double(count)) * .pi * 2 + Double.random(in: -0.3...0.3)
            let speed = Double.random(in: 60...200)
            let particle = LaunchParticle(
                id: UUID(),
                angle: angle,
                speed: speed,
                size: Double.random(in: 2...6),
                color: colors.randomElement() ?? .white,
                lifetime: Double.random(in: 0.6...1.4),
                birthTime: now + Double.random(in: 0...0.1),
                isGlow: Bool.random(),
                hasGravity: Bool.random()
            )
            particles.append(particle)
        }
    }

    private func spawnAmbientParticles(count: Int) {
        let now = Date.now.timeIntervalSinceReferenceDate
        let colors: [Color] = [Theme.accent.opacity(0.6), Theme.accentBlue.opacity(0.6), .white.opacity(0.4)]

        for _ in 0..<count {
            let angle = Double.random(in: 0...(2 * .pi))
            let particle = LaunchParticle(
                id: UUID(),
                angle: angle,
                speed: Double.random(in: 15...50),
                size: Double.random(in: 1.5...3.5),
                color: colors.randomElement() ?? .white,
                lifetime: Double.random(in: 1.0...2.0),
                birthTime: now,
                isGlow: true,
                hasGravity: false
            )
            particles.append(particle)
        }
    }
}

// MARK: - Models

private enum LaunchPhase {
    case dark, ignite, burst, reveal, hold, complete
}

private struct LaunchParticle: Identifiable {
    let id: UUID
    let angle: Double
    let speed: Double
    let size: Double
    let color: Color
    let lifetime: Double
    let birthTime: TimeInterval
    let isGlow: Bool
    let hasGravity: Bool
}

private struct BrandLetter: Identifiable {
    let id: Int
    let character: String
}
