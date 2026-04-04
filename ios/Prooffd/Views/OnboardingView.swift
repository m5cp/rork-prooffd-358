import SwiftUI

struct OnboardingView: View {
    var onComplete: () -> Void
    @State private var appeared: Bool = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            meshBackground

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 32) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 88, height: 88)
                            Image(systemName: "sparkles")
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundStyle(Theme.accent)
                                .symbolEffect(.breathe, options: .repeating)
                        }
                        .opacity(appeared ? 1 : 0)
                        .scaleEffect(appeared ? 1 : 0.8)

                        VStack(spacing: 10) {
                            Text("Welcome to Prooffd")
                                .font(.largeTitle.bold())
                                .foregroundStyle(Theme.textPrimary)

                            Text("Careers with AI Resistance")
                                .font(.title3)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 16)
                    }

                    VStack(spacing: 14) {
                        pathRow(
                            icon: "briefcase.fill",
                            color: Theme.accent,
                            title: "Start a Business",
                            detail: "Step-by-step plans for 100+ businesses"
                        )
                        pathRow(
                            icon: "wrench.and.screwdriver.fill",
                            color: Theme.accentBlue,
                            title: "Learn a Trade",
                            detail: "Certifications, apprenticeships & programs"
                        )
                        pathRow(
                            icon: "building.columns.fill",
                            color: Color(hex: "818CF8"),
                            title: "Pursue a Degree",
                            detail: "Licensed careers requiring a college degree"
                        )
                    }
                    .padding(.horizontal, 24)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 24)
                }

                Spacer()
                Spacer()

                Button {
                    onComplete()
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.accent)
                        .clipShape(.capsule)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 56)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8, bounce: 0.15).delay(0.15)) {
                appeared = true
            }
        }
    }

    private func pathRow(icon: String, color: Color, title: String, detail: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12))
                .clipShape(.rect(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer()
        }
    }

    private var meshBackground: some View {
        Group {
            if colorScheme == .dark {
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                    colors: [
                        Color(hex: "0F1117"), Color(hex: "131620"), Color(hex: "0F1117"),
                        Color(hex: "111420"), Color(hex: "14201A"), Color(hex: "111420"),
                        Color(hex: "0F1117"), Color(hex: "131620"), Color(hex: "0F1117")
                    ]
                )
                .ignoresSafeArea()
            } else {
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                    colors: [
                        Color(hex: "F8F8FA"), Color(hex: "EEF5F0"), Color(hex: "F8F8FA"),
                        Color(hex: "F0F5EE"), Color(hex: "E8F0E8"), Color(hex: "EEF2F6"),
                        Color(hex: "F8F8FA"), Color(hex: "F2F2F5"), Color(hex: "F8F8FA")
                    ]
                )
                .ignoresSafeArea()
            }
        }
    }
}
