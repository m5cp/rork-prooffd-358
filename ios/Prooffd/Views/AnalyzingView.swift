import SwiftUI

struct AnalyzingView: View {
    @State private var phase: Int = 0
    @State private var progress: Double = 0
    @State private var dotCount: Int = 0
    @Environment(\.colorScheme) private var colorScheme

    private let steps = [
        "Analyzing your profile",
        "Matching business paths",
        "Calculating fit scores",
        "Ranking your results"
    ]

    var body: some View {
        ZStack {
            meshBackground

            VStack(spacing: 32) {
                Spacer()

                ZStack {
                    Circle()
                        .stroke(Theme.cardBackground, lineWidth: 6)
                        .frame(width: 120, height: 120)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Theme.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundStyle(Theme.accent)
                        .symbolEffect(.pulse, options: .repeating)
                }

                VStack(spacing: 12) {
                    Text(steps[min(phase, steps.count - 1)] + String(repeating: ".", count: dotCount))
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .contentTransition(.numericText())

                    Text("This will just take a moment")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()
            }
        }
        .task {
            await animate()
        }
    }

    private func animate() async {
        for i in 0..<steps.count {
            withAnimation(.spring(duration: 0.4)) {
                phase = i
            }
            let targetProgress = Double(i + 1) / Double(steps.count)
            withAnimation(.easeInOut(duration: 0.6)) {
                progress = targetProgress
            }
            for d in 1...3 {
                try? await Task.sleep(for: .milliseconds(200))
                withAnimation { dotCount = d }
            }
            withAnimation { dotCount = 0 }
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
                        Color(hex: "0A0E1A"), Color(hex: "0F1B2D"), Color(hex: "0A0E1A"),
                        Color(hex: "0D1825"), Color(hex: "132A1E"), Color(hex: "0D1825"),
                        Color(hex: "0A0E1A"), Color(hex: "0F1B2D"), Color(hex: "0A0E1A")
                    ]
                )
                .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground), Color(.systemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
        }
    }
}
