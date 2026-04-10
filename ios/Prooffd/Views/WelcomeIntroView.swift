import SwiftUI

struct WelcomeIntroView: View {
    var onGetStarted: () -> Void

    @State private var phase: Int = 0
    @State private var iconScale: CGFloat = 0.0
    @State private var iconOpacity: Double = 0.0
    @State private var iconRotation: Double = -45
    @State private var headlineOpacity: Double = 0.0
    @State private var headlineOffset: CGFloat = 30
    @State private var subtitleOpacity: Double = 0.0
    @State private var subtitleOffset: CGFloat = 20
    @State private var featureRowsAppeared: Bool = false
    @State private var buttonScale: CGFloat = 0.0
    @State private var buttonOpacity: Double = 0.0
    @State private var glowPulse: Bool = false
    @State private var meshPhase: CGFloat = 0
    @State private var particleTimer: Timer?
    @State private var orbitalAngle: Double = 0
    @State private var shimmerOffset: CGFloat = -200
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let features: [(icon: String, title: String, subtitle: String, color: Color)] = [
        ("sparkles", "AI-Powered Matching", "Personalized career paths based on you", Color(hex: "34D399")),
        ("chart.line.uptrend.xyaxis", "Step-by-Step Plans", "Actionable roadmaps to launch faster", Color(hex: "60A5FA")),
        ("flame.fill", "Daily Progress", "Streaks, levels & momentum tracking", Color(hex: "F59E0B"))
    ]

    var body: some View {
        ZStack {
            animatedBackground

            orbitalRings

            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 60)

                    heroSection
                        .padding(.top, 20)

                    featureCards
                        .padding(.top, 40)
                        .padding(.horizontal, 24)

                    Spacer(minLength: 140)
                }
            }
            .scrollIndicators(.hidden)

            VStack {
                Spacer()
                ctaButton
            }
        }
        .ignoresSafeArea()
        .onAppear {
            if reduceMotion {
                iconScale = 1; iconOpacity = 1; iconRotation = 0
                headlineOpacity = 1; headlineOffset = 0
                subtitleOpacity = 1; subtitleOffset = 0
                featureRowsAppeared = true
                buttonScale = 1; buttonOpacity = 1
                return
            }
            runEntrance()
        }
        .onDisappear {
            particleTimer?.invalidate()
        }
    }

    // MARK: - Background

    private var animatedBackground: some View {
        ZStack {
            if colorScheme == .dark {
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], SIMD2<Float>(0.5 + Float(meshPhase) * 0.08, 0.5 + Float(meshPhase) * 0.04), [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                    colors: [
                        Color(hex: "0F1117"), Color(hex: "111822"), Color(hex: "0F1117"),
                        Color(hex: "0D1A14"), Color(hex: "0F2820"), Color(hex: "0D1520"),
                        Color(hex: "0F1117"), Color(hex: "111620"), Color(hex: "0F1117")
                    ]
                )
                .ignoresSafeArea()
            } else {
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], SIMD2<Float>(0.5 + Float(meshPhase) * 0.06, 0.5), [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                    colors: [
                        Color(hex: "F5F7FA"), Color(hex: "E8F5EE"), Color(hex: "F5F7FA"),
                        Color(hex: "ECF8F0"), Color(hex: "E0F2E8"), Color(hex: "EAF0FA"),
                        Color(hex: "F5F7FA"), Color(hex: "F0F0F5"), Color(hex: "F5F7FA")
                    ]
                )
                .ignoresSafeArea()
            }
        }
    }

    // MARK: - Orbital Rings

    private var orbitalRings: some View {
        ZStack {
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [Theme.accent.opacity(0.0), Theme.accent.opacity(0.15), Theme.accent.opacity(0.0)],
                        center: .center,
                        startAngle: .degrees(orbitalAngle),
                        endAngle: .degrees(orbitalAngle + 360)
                    ),
                    lineWidth: 1
                )
                .frame(width: 260, height: 260)
                .rotationEffect(.degrees(orbitalAngle))

            Circle()
                .stroke(
                    AngularGradient(
                        colors: [Theme.accentBlue.opacity(0.0), Theme.accentBlue.opacity(0.1), Theme.accentBlue.opacity(0.0)],
                        center: .center,
                        startAngle: .degrees(-orbitalAngle * 0.7),
                        endAngle: .degrees(-orbitalAngle * 0.7 + 360)
                    ),
                    lineWidth: 0.8
                )
                .frame(width: 320, height: 320)
                .rotationEffect(.degrees(-orbitalAngle * 0.7))
        }
        .position(x: UIScreen.main.bounds.width / 2, y: 220)
        .opacity(iconOpacity * 0.8)
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.accent.opacity(glowPulse ? 0.25 : 0.1),
                                Theme.accent.opacity(0.0)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(glowPulse ? 1.1 : 0.9)

                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "059669"), Color(hex: "047857")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 110, height: 110)
                        .shadow(color: Theme.accent.opacity(0.4), radius: 30, y: 8)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 54, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .white.opacity(0.2), radius: 6)

                    RoundedRectangle(cornerRadius: 32)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.25), .clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .frame(width: 110, height: 110)
                        .allowsHitTesting(false)
                }
                .scaleEffect(iconScale)
                .opacity(iconOpacity)
                .rotationEffect(.degrees(iconRotation))
            }

            VStack(spacing: 10) {
                Text("Welcome to")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(Theme.textSecondary)

                Text("PROOFFD")
                    .font(.system(size: 42, weight: .black, design: .default).width(.expanded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: colorScheme == .dark
                                ? [.white, Color(hex: "B0B8C8")]
                                : [Color(hex: "1A1A1E"), Color(hex: "3A3A44")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .white.opacity(0.4), .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 60)
                            .offset(x: shimmerOffset)
                            .mask {
                                Text("PROOFFD")
                                    .font(.system(size: 42, weight: .black, design: .default).width(.expanded))
                            }
                    )
                    .clipShape(Rectangle())
            }
            .opacity(headlineOpacity)
            .offset(y: headlineOffset)

            Text("Discover your perfect career path.\nAnswer a few questions — we'll do the rest.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 32)
                .opacity(subtitleOpacity)
                .offset(y: subtitleOffset)
        }
    }

    // MARK: - Feature Cards

    private var featureCards: some View {
        VStack(spacing: 14) {
            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                featureRow(
                    icon: feature.icon,
                    title: feature.title,
                    subtitle: feature.subtitle,
                    color: feature.color,
                    index: index
                )
            }
        }
    }

    private func featureRow(icon: String, title: String, subtitle: String, color: Color, index: Int) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(color.opacity(colorScheme == .dark ? 0.15 : 0.1))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(colorScheme == .dark ? Color(hex: "1C1E27").opacity(0.8) : .white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(color.opacity(0.15), lineWidth: 1)
        )
        .opacity(featureRowsAppeared ? 1 : 0)
        .offset(y: featureRowsAppeared ? 0 : 25)
        .animation(
            .spring(duration: 0.5, bounce: 0.2).delay(Double(index) * 0.1),
            value: featureRowsAppeared
        )
    }

    // MARK: - CTA Button

    private var ctaButton: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [
                    (colorScheme == .dark ? Color(hex: "0F1117") : Color(hex: "F5F7FA")).opacity(0),
                    colorScheme == .dark ? Color(hex: "0F1117") : Color(hex: "F5F7FA")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 40)
            .allowsHitTesting(false)

            VStack(spacing: 16) {
                Button {
                    onGetStarted()
                } label: {
                    HStack(spacing: 10) {
                        Text("Get Started")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                            .font(.subheadline.weight(.bold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "059669"), Color(hex: "047857")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(.capsule)
                    .shadow(color: Theme.accent.opacity(0.3), radius: 16, y: 6)
                }
                .scaleEffect(buttonScale)
                .opacity(buttonOpacity)
                .sensoryFeedback(.impact(weight: .medium), trigger: buttonOpacity > 0.5)

                Text("Takes less than 2 minutes")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                    .opacity(buttonOpacity)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 44)
            .background(colorScheme == .dark ? Color(hex: "0F1117") : Color(hex: "F5F7FA"))
        }
    }

    // MARK: - Animation Sequence

    private func runEntrance() {
        withAnimation(.easeOut(duration: 1.2)) {
            meshPhase = 1.0
        }

        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            orbitalAngle = 360
        }

        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            glowPulse = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(duration: 0.7, bounce: 0.35)) {
                iconScale = 1.0
                iconOpacity = 1.0
                iconRotation = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            withAnimation(.spring(duration: 0.6, bounce: 0.15)) {
                headlineOpacity = 1.0
                headlineOffset = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeOut(duration: 1.2)) {
                shimmerOffset = 250
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            withAnimation(.spring(duration: 0.5, bounce: 0.1)) {
                subtitleOpacity = 1.0
                subtitleOffset = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
            featureRowsAppeared = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(.spring(duration: 0.6, bounce: 0.3)) {
                buttonScale = 1.0
                buttonOpacity = 1.0
            }
        }
    }
}
