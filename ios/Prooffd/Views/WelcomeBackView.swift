import SwiftUI

struct WelcomeBackView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    appState.dismissWelcomeBack()
                }

            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("Welcome back, \(appState.userProfile.firstName)!")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)

                        Text("Here's where you left off")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }

                    if let today = appState.todayStep {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(Theme.accent)
                                Text("Your Next Step")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(Theme.accent)
                            }

                            Text(today.step.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Theme.cardBackgroundLight)
                                        .frame(height: 4)
                                    Capsule()
                                        .fill(Theme.accent)
                                        .frame(width: geo.size.width * Double(today.build.progressPercentage) / 100.0, height: 4)
                                }
                            }
                            .frame(height: 4)

                            HStack {
                                Text(today.build.businessName)
                                    .font(.caption)
                                    .foregroundStyle(Theme.textTertiary)
                                Spacer()
                                Text("\(today.build.progressPercentage)% complete")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(Theme.accent)
                            }
                        }
                        .padding(16)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 14))
                    } else if appState.streakTracker.currentStreak > 1 {
                        HStack(spacing: 8) {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(.orange)
                            Text("\(appState.streakTracker.currentStreak) day streak!")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.orange)
                        }
                        .padding(14)
                        .background(Color.orange.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 12))
                    }

                    Button {
                        appState.dismissWelcomeBack()
                    } label: {
                        Text("Let's Go")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.accent)
                            .clipShape(.capsule)
                    }
                    .sensoryFeedback(.impact(flexibility: .soft), trigger: true)
                }
                .padding(24)
                .background(Theme.background)
                .clipShape(.rect(cornerRadius: 24))
                .shadow(color: .black.opacity(0.3), radius: 20)
                .padding(.horizontal, 20)

                Spacer()
            }
        }
    }
}
