import SwiftUI

/// Central registry mapping app data (categories, education paths, moment types)
/// to the bundled 3D render artwork. All renders share one art direction:
/// glossy floating objects on deep navy with green/cyan rim light.
enum PathArtwork {

    // MARK: - Asset names

    static let tradesEducation = "hard_hat_tools_staircase"
    static let collegeDegree = "graduation_cap_diploma_books"
    static let quizBackdrop = "question_mark_glowing"
    static let resultsReveal = "crystal_star_podium"
    static let onboardingHero = "glowing_path_journey"
    static let futurePath = "glowing_path_journey"
    static let milestone = "mountain_peak_flag_milestone"
    static let celebration = "trophy_cup_confetti_stars"
    static let emptyState = "plant_sprout_dome"

    /// Hero render for a business path category.
    static func businessImage(for category: BusinessCategory) -> String {
        switch category {
        case .homeProperty: return "house_with_tools_floating"
        case .autoTransport: return "car_detailing_tools_render"
        case .outdoorLandscape: return "garden_tools_3d"
        case .foodBeverage: return "cloche_cup_kitchenware"
        case .petServices: return "pet_grooming_essentials"
        case .personalCare: return "barber_salon_tools_floating"
        case .digitalCreative: return "laptop_camera_stylus_ui"
        case .productCraft: return "craft_supplies_floating"
        case .eventsEntertainment: return "disco_party_equipment"
        case .skilledTrades: return "construction_tools_render"
        }
    }

    /// Hero render for an education category. Hands-on categories use the
    /// apprenticeship render; academic/professional ones use the degree render.
    static func educationImage(for category: EducationCategory) -> String {
        switch category {
        case .trade, .certification, .military: return tradesEducation
        case .healthcare, .technology, .business, .creative: return collegeDegree
        }
    }

    /// Hero render for a business path.
    static func image(for path: BusinessPath) -> String {
        businessImage(for: path.category)
    }

    /// Hero render for a degree/career record.
    static func image(for record: DegreeCareerRecord) -> String {
        collegeDegree
    }
}

// MARK: - ArtworkImage

/// A bundled 3D render with a soft fade-and-settle entrance.
/// Never intercepts touches, so taps pass through to the card underneath.
struct ArtworkImage: View {
    let name: String
    @State private var appeared = false

    init(name: String) {
        self.name = name
    }

    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1 : 1.05)
            .onAppear {
                withAnimation(.easeOut(duration: 0.45)) { appeared = true }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

// MARK: - ParallaxHeroHeader

/// Stretchy, parallaxing hero image for the top of detail pages.
/// Pulls down to stretch when over-scrolled; drifts at 20% scroll speed otherwise.
struct ParallaxHeroHeader: View {
    let name: String
    var height: CGFloat = 250

    var body: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            let stretch = max(0, minY)
            ArtworkImage(name: name)
                .frame(width: geo.size.width, height: height + stretch)
                .clipped()
                .offset(y: minY > 0 ? -minY : -minY * 0.2)
                .overlay(
                    LinearGradient(
                        colors: [.clear, Color(hex: "0B0F14").opacity(0.9)],
                        startPoint: .init(x: 0.5, y: 0.55),
                        endPoint: .bottom
                    )
                    .offset(y: minY > 0 ? -minY : -minY * 0.2)
                    .allowsHitTesting(false)
                )
        }
        .frame(height: height)
    }
}

// MARK: - QuizArtworkBackdrop

/// Immersive backdrop for quizzes: the glowing question-mark render dimmed
/// behind an electric gradient so question text stays crisp.
struct QuizArtworkBackdrop: View {
    var body: some View {
        ZStack(alignment: .top) {
            Theme.background
            ArtworkImage(name: PathArtwork.quizBackdrop)
                .frame(maxWidth: .infinity)
                .frame(height: 430)
                .clipped()
                .opacity(0.4)
                .overlay(
                    LinearGradient(
                        colors: [Theme.background.opacity(0.12), Theme.background],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .allowsHitTesting(false)
                )
        }
        .ignoresSafeArea()
    }
}

// MARK: - ScoreCountUpText

/// Match score that counts up from zero with a spring on first appearance.
struct ScoreCountUpText: View {
    let target: Int
    var font: Font = .system(size: 40, weight: .heavy, design: .rounded)
    var color: Color = .white
    @State private var value: Double = 0

    var body: some View {
        Text("\(Int(value))%")
            .font(font)
            .foregroundStyle(color)
            .monospacedDigit()
            .contentTransition(.numericText(countsDown: false))
            .onAppear {
                withAnimation(.spring(response: 1.1, dampingFraction: 0.85)) {
                    value = Double(target)
                }
            }
            .onChange(of: target) { _, newValue in
                withAnimation(.spring(response: 1.1, dampingFraction: 0.85)) {
                    value = Double(newValue)
                }
            }
    }
}

// MARK: - ArtworkPressStyle

/// Button style for image cards: presses in with a subtle scale and a light haptic tap.
struct ArtworkPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, pressed in
                if pressed {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
    }
}

// MARK: - ArtworkEmptyState

/// Calm, consistent empty state: the sprout render with a headline and optional hint.
struct ArtworkEmptyState: View {
    var title: String
    var message: String?
    var artwork: String = PathArtwork.emptyState
    var artworkHeight: CGFloat = 170

    var body: some View {
        VStack(spacing: 14) {
            ArtworkImage(name: artwork)
                .frame(height: artworkHeight)
                .clipped()
                .frame(maxWidth: .infinity)
            Text(title)
                .font(.headline)
                .foregroundStyle(Theme.textSecondary)
            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textTertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
    }
}
