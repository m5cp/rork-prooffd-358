import SwiftUI

struct ProgressShareCard: View {
    let buildName: String
    let progressPercent: Int
    let streakDays: Int
    let nextStep: String
    let totalPoints: Int

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 24) {
                Text("P R O O F F D")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(Color.white.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Building Progress")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "34D399"))
                    Text(buildName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.08), lineWidth: 10)
                        .frame(width: 120, height: 120)
                    Circle()
                        .trim(from: 0, to: Double(progressPercent) / 100.0)
                        .stroke(Color(hex: "34D399"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 120, height: 120)
                    VStack(spacing: 2) {
                        Text("\(progressPercent)%")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("complete")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.white.opacity(0.5))
                    }
                }

                HStack(spacing: 16) {
                    statChip(icon: "flame.fill", label: "Streak", value: "\(streakDays) days")
                    statChip(icon: "bolt.fill", label: "Points", value: "\(totalPoints)")
                }

                if !nextStep.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("NEXT STEP")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color.white.opacity(0.4))
                        Text(nextStep)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.white.opacity(0.8))
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color.white.opacity(0.06))
                    .clipShape(.rect(cornerRadius: 12))
                }
            }
            .padding(24)
            .background(
                LinearGradient(
                    colors: [Color(hex: "0D1220"), Color(hex: "111B30"), Color(hex: "0B1525")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            HStack {
                Text("Build yours at")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.4))
                Text("prooffd.app")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color(hex: "34D399").opacity(0.8))
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white.opacity(0.4))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color(hex: "080C16"))
        }
        .clipShape(.rect(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "34D399").opacity(0.25), Color(hex: "34D399").opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }

    private func statChip(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(Color.white.opacity(0.5))
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.4))
                Text(value)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.85))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
    }
}

struct JobSelectionShareCard: View {
    let jobTitle: String
    let matchPercent: Int
    let aiSafeScore: Int
    let startupCost: String
    let timeToFirst: String
    let icon: String

    private var scoreColor: Color {
        if matchPercent >= 80 { return Color(hex: "34D399") }
        if matchPercent >= 60 { return Color(hex: "60A5FA") }
        return .orange
    }

    private var aiColor: Color {
        if aiSafeScore >= 80 { return Color(hex: "34D399") }
        if aiSafeScore >= 50 { return Color(hex: "FBBF24") }
        return .orange
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 24) {
                Text("P R O O F F D")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(Color.white.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 6) {
                    Text("I chose my path")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(scoreColor)
                    Text(jobTitle)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(scoreColor.opacity(0.15), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        Circle()
                            .trim(from: 0, to: Double(matchPercent) / 100.0)
                            .stroke(scoreColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 80, height: 80)
                        VStack(spacing: 0) {
                            Text("\(matchPercent)")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(scoreColor)
                            Text("match")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(scoreColor.opacity(0.7))
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 6) {
                            Image(systemName: "shield.checkered")
                                .font(.system(size: 11))
                            Text("AI Safe: \(aiSafeScore)/100")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(aiColor)

                        HStack(spacing: 6) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 11))
                            Text(startupCost)
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(Color.white.opacity(0.7))

                        HStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 11))
                            Text(timeToFirst)
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(Color.white.opacity(0.7))
                    }

                    Spacer(minLength: 0)
                }
                .padding(16)
                .background(Color(hex: "111825"))
                .clipShape(.rect(cornerRadius: 14))
            }
            .padding(24)
            .background(
                LinearGradient(
                    colors: [Color(hex: "0D1220"), Color(hex: "111B30"), Color(hex: "0B1525")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            HStack {
                Text("Find yours at")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.4))
                Text("prooffd.app")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color(hex: "34D399").opacity(0.8))
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white.opacity(0.4))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color(hex: "080C16"))
        }
        .clipShape(.rect(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [scoreColor.opacity(0.25), scoreColor.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

struct MyPathShareCard: View {
    let userName: String
    let selectedJob: String
    let progressPercent: Int
    let streakDays: Int
    let aiSafeScore: Int
    let totalPoints: Int

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                Text("P R O O F F D")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(Color.white.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 6) {
                    Text("\(userName.isEmpty ? "My" : userName + "'s") Path")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                    Text(selectedJob)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(hex: "34D399"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 12) {
                    pathStatBox(icon: "chart.bar.fill", value: "\(progressPercent)%", label: "Progress", color: Color(hex: "34D399"))
                    pathStatBox(icon: "flame.fill", value: "\(streakDays)", label: "Streak", color: .orange)
                    pathStatBox(icon: "shield.checkered", value: "\(aiSafeScore)", label: "AI Safe", color: Color(hex: "60A5FA"))
                    pathStatBox(icon: "bolt.fill", value: "\(totalPoints)", label: "Points", color: Color(hex: "FBBF24"))
                }
            }
            .padding(24)
            .background(
                LinearGradient(
                    colors: [Color(hex: "0D1220"), Color(hex: "111B30"), Color(hex: "0B1525")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            HStack {
                Text("Build yours at")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.4))
                Text("prooffd.app")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color(hex: "34D399").opacity(0.8))
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white.opacity(0.4))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color(hex: "080C16"))
        }
        .clipShape(.rect(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "34D399").opacity(0.25), Color(hex: "34D399").opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }

    private func pathStatBox(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
        .clipShape(.rect(cornerRadius: 10))
    }
}

struct ShareableCardSheet: View {
    let cardContent: AnyView
    let shareText: String
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var renderedImage: UIImage?
    @State private var showCheckmark: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Preview")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Theme.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 12)

                        cardContent
                            .padding(.horizontal, 24)
                    }
                }
                .scrollIndicators(.hidden)

                VStack(spacing: 12) {
                    Button {
                        shareImage()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: showCheckmark ? "checkmark" : "square.and.arrow.up")
                                .font(.body.weight(.semibold))
                            Text(showCheckmark ? "Shared!" : "Share Card")
                                .font(.body.weight(.semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(showCheckmark ? Theme.accent.opacity(0.7) : Theme.accent)
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    Button {
                        saveToPhotos()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.to.line")
                                .font(.body.weight(.medium))
                            Text("Save to Photos")
                                .font(.body.weight(.medium))
                        }
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Theme.background)
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Theme.textTertiary)
                            .font(.title3)
                    }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
        .onAppear { renderImage() }
    }

    private func renderImage() {
        let card = cardContent
            .frame(width: 340)
            .padding(16)
            .background(Color(hex: "0F1117"))

        let renderer = ImageRenderer(content: card)
        renderer.scale = 3.0
        renderedImage = renderer.uiImage
    }

    private func shareImage() {
        if renderedImage == nil { renderImage() }
        guard let image = renderedImage else { return }
        let items: [Any] = [image, shareText]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            var topController = root
            while let presented = topController.presentedViewController { topController = presented }
            activityVC.popoverPresentationController?.sourceView = topController.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: topController.view.bounds.midX, y: topController.view.bounds.midY, width: 0, height: 0)
            activityVC.popoverPresentationController?.permittedArrowDirections = []
            topController.present(activityVC, animated: true)
        }
        appState.markResultShared()
        withAnimation(.spring(duration: 0.3)) {
            showCheckmark = true
        }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation { showCheckmark = false }
        }
    }

    private func saveToPhotos() {
        if renderedImage == nil { renderImage() }
        guard let image = renderedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        withAnimation(.spring(duration: 0.3)) {
            showCheckmark = true
        }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation { showCheckmark = false }
        }
    }
}
