import SwiftUI

struct QuizView: View {
    var onComplete: (UserProfile) -> Void
    var onSkip: () -> Void
    var onEarlyComplete: (UserProfile) -> Void
    var initialProfile: UserProfile
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedPath: ChosenPath?
    @State private var appeared: Bool = false

    private let paths: [ChosenPath] = [.business, .trades, .degree]

    var body: some View {
        ZStack {
            meshBackground

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "arrow.triangle.branch")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(Theme.accent)
                        .symbolEffect(.pulse, options: .repeating, isActive: !reduceMotion)

                    Text("What's your path?")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Choose the direction that fits you best.\nYou can always explore the others later.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 32)

                VStack(spacing: 14) {
                    ForEach(Array(paths.enumerated()), id: \.element.rawValue) { index, path in
                        pathCard(path, delay: Double(index) * 0.1)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        guard let path = selectedPath else { return }
                        appState.selectPath(path)
                    } label: {
                        Text("Let's Go")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(selectedPath != nil ? Theme.accent : Theme.cardBackgroundLight)
                            .clipShape(.capsule)
                    }
                    .disabled(selectedPath == nil)
                    .sensoryFeedback(.selection, trigger: selectedPath)

                    Button {
                        onSkip()
                    } label: {
                        Text("Explore Everything")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.6).delay(0.2)) {
                appeared = true
            }
        }
    }

    private func pathCard(_ path: ChosenPath, delay: Double) -> some View {
        let isSelected = selectedPath == path

        return Button {
            withAnimation(.spring(duration: 0.35)) {
                selectedPath = path
            }
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isSelected ? path.color : path.color.opacity(0.12))
                        .frame(width: 56, height: 56)
                    Image(systemName: path.icon)
                        .font(.title2)
                        .foregroundStyle(isSelected ? .white : path.color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(path.title)
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                    Text(path.subtitle)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 4)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(path.color)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(16)
            .background(isSelected ? path.color.opacity(0.08) : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? path.color : path.color.opacity(0.1), lineWidth: isSelected ? 2 : 0.5)
            )
            .shadow(color: isSelected ? path.color.opacity(0.2) : .clear, radius: 12, y: 4)
        }
        .buttonStyle(.plain)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.spring(duration: 0.5).delay(delay), value: appeared)
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
                        Color(hex: "F5F5F7"), Color(hex: "EDF2F0"), Color(hex: "F5F5F7"),
                        Color(hex: "EFF3EE"), Color(hex: "E8EFE8"), Color(hex: "EEF1F5"),
                        Color(hex: "F5F5F7"), Color(hex: "F0F0F3"), Color(hex: "F5F5F7")
                    ]
                )
                .ignoresSafeArea()
            }
        }
    }
}
