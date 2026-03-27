import SwiftUI

struct DiscoverView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedResult: MatchResult?
    @State private var shareResult: MatchResult?
    @State private var showRandomPicks: Bool = false
    @State private var randomPicks: [MatchResult] = []
    @State private var showBestOptions: Bool = false
    @State private var bestOptions: [MatchResult] = []
    @State private var showFastMoney: Bool = false

    private var topMatch: MatchResult? {
        appState.matchResults.first
    }

    private var alternativeMatches: [MatchResult] {
        Array(appState.matchResults.dropFirst().prefix(2))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    entryCard
                    if let top = topMatch {
                        topMatchHero(top)
                    }
                    DailyMicroActionCard()
                    startHereCompact
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $shareResult) { result in
                ShareCardPresenterSheet(content: .topMatch(from: result))
            }
            .sheet(isPresented: $showRandomPicks) {
                RandomPicksView(picks: randomPicks, onSelect: { result in
                    showRandomPicks = false
                    selectedResult = result
                    appState.markPathExplored(result.businessPath.id)
                }, onReroll: {
                    let shuffled = appState.matchResults.shuffled()
                    randomPicks = Array(shuffled.prefix(2))
                })
            }
            .sheet(isPresented: $showBestOptions) {
                bestOptionsSheet
            }
            .sheet(isPresented: $showFastMoney) {
                SeeAllView(mode: .fastStart, results: appState.matchResults.filter { $0.businessPath.fastCashPotential })
            }
        }
    }

    // MARK: - Entry Card

    private var entryCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text("What should I do next?")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("We'll show your best options instantly")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }
            .accessibilityElement(children: .combine)

            Button {
                showTopMatchAndAlternatives()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .accessibilityHidden(true)
                    Text("Find My Best Option")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Theme.accent, Theme.accentBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(.rect(cornerRadius: 14))
            }
            .accessibilityHint("Shows your top match and alternatives")
            .sensoryFeedback(.impact(weight: .medium), trigger: showBestOptions)

            HStack(spacing: 10) {
                quickOptionButton(
                    icon: "bolt.fill",
                    title: "Make Money Fast",
                    color: Color(hex: "FB923C")
                ) {
                    showFastMoney = true
                }

                quickOptionButton(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Build Long-Term",
                    color: Theme.accentBlue
                ) {
                    let longTerm = appState.matchResults.filter { $0.businessPath.aiProofRating >= 75 }
                    bestOptions = Array(longTerm.prefix(3))
                    showBestOptions = true
                }

                quickOptionButton(
                    icon: "dice.fill",
                    title: "Just Exploring",
                    color: Color(hex: "818CF8")
                ) {
                    let shuffled = appState.matchResults.shuffled()
                    randomPicks = Array(shuffled.prefix(2))
                    showRandomPicks = true
                }
            }
        }
        .padding(20)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Theme.accent.opacity(0.15), lineWidth: 0.5)
        )
        .cardShadow()
    }

    private func quickOptionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(color)
                }
                .accessibilityHidden(true)
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    private func showTopMatchAndAlternatives() {
        var options: [MatchResult] = []
        if let top = topMatch {
            options.append(top)
        }
        options.append(contentsOf: alternativeMatches)
        bestOptions = options
        showBestOptions = true
    }

    // MARK: - Best Options Sheet

    private var bestOptionsSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 36))
                            .foregroundStyle(Theme.accent)
                        Text("Your Best Move Right Now")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                        Text("Based on your profile and preferences")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.top, 8)

                    ForEach(Array(bestOptions.enumerated()), id: \.element.id) { index, result in
                        bestOptionCard(result, rank: index + 1)
                    }

                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        showBestOptions = false
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
    }

    private func bestOptionCard(_ result: MatchResult, rank: Int) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        let zone = result.businessPath.zone
        let zoneColor: Color = zone == .safe ? Theme.accent : zone == .human ? Color(hex: "FBBF24") : .orange
        let rankLabel = rank == 1 ? "Top Match" : "Alternative \(rank - 1)"

        return Button {
            showBestOptions = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                selectedResult = result
                appState.markPathExplored(result.businessPath.id)
            }
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 48, height: 48)
                        Image(systemName: result.businessPath.icon)
                            .font(.title3)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        if rank == 1 {
                            Text("TOP MATCH")
                                .font(.caption2.weight(.heavy))
                                .foregroundStyle(Theme.accent)
                                .tracking(0.5)
                        } else {
                            Text("ALTERNATIVE \(rank - 1)")
                                .font(.caption2.weight(.heavy))
                                .foregroundStyle(Theme.textTertiary)
                                .tracking(0.5)
                        }
                        Text(result.businessPath.name)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer()

                    VStack(spacing: 2) {
                        Text("\(result.scorePercentage)%")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(scoreColor(result.scorePercentage))
                        Text("match")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                HStack(spacing: 10) {
                    HStack(spacing: 4) {
                        Image(systemName: zone.icon)
                            .font(.caption2)
                        Text(zone.label)
                            .font(.caption2.weight(.semibold))
                    }
                    .foregroundStyle(zoneColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(zoneColor.opacity(0.12))
                    .clipShape(.capsule)

                    Text(result.businessPath.typicalMarketRates)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Theme.textSecondary)
                }

                HStack(spacing: 6) {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Start Plan")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(rank == 1 ? catColor : Theme.textSecondary)
                .clipShape(.capsule)
            }
            .padding(18)
            .background(
                LinearGradient(
                    colors: [catColor.opacity(rank == 1 ? 0.08 : 0.04), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(catColor.opacity(rank == 1 ? 0.25 : 0.1), lineWidth: rank == 1 ? 1 : 0.5)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(rankLabel), \(result.businessPath.name), \(result.scorePercentage) percent match, AI Safe Zone \(zone.label)")
        .accessibilityHint("Opens details for \(result.businessPath.name)")
    }

    // MARK: - Top Match Hero

    private func topMatchHero(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        let zone = result.businessPath.zone
        let zoneColor: Color = zone == .safe ? Theme.accent : zone == .human ? Color(hex: "FBBF24") : .orange

        return Button {
            selectedResult = result
            appState.markPathExplored(result.businessPath.id)
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "crown.fill")
                        .font(.caption2)
                        .foregroundStyle(Color(hex: "FBBF24"))
                        .accessibilityHidden(true)
                    Text("YOUR BEST MOVE RIGHT NOW")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(Theme.textTertiary)
                        .tracking(0.5)
                    Spacer()
                    Text("\(result.scorePercentage)% match")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(scoreColor(result.scorePercentage))
                }

                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 56, height: 56)
                        Image(systemName: result.businessPath.icon)
                            .font(.title2)
                            .foregroundStyle(catColor)
                    }
                    .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(result.businessPath.name)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: zone.icon)
                                    .font(.system(size: 10))
                                Text(zone.label)
                                    .font(.caption2.weight(.semibold))
                            }
                            .foregroundStyle(zoneColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(zoneColor.opacity(0.12))
                            .clipShape(.capsule)

                            Text(result.businessPath.typicalMarketRates)
                                .font(.caption2.weight(.medium))
                                .foregroundStyle(Theme.textSecondary)
                                .lineLimit(1)
                        }
                    }
                }

                Text(perfectForLine(result))
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(2)

                Button {
                    if !appState.hasBuild(for: result.businessPath.id) {
                        appState.addBuild(from: result.businessPath)
                    }
                    selectedResult = result
                    appState.markPathExplored(result.businessPath.id)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.right.circle.fill")
                            .accessibilityHidden(true)
                        Text("Start Plan")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(catColor)
                    .clipShape(.capsule)
                }
                .accessibilityLabel("Start Plan for \(result.businessPath.name)")
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.1), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Top Match, \(result.businessPath.name), \(result.scorePercentage) percent match, AI Safe Zone \(zone.label), typical market rate \(result.businessPath.typicalMarketRates)")
    }

    // MARK: - Start Here

    private var startHereCompact: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "hand.wave.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                    .accessibilityHidden(true)
                Text("Start Here Today")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }

            HStack(spacing: 10) {
                startCard(
                    icon: "bolt.fill",
                    iconColor: Color(hex: "FB923C"),
                    title: "Make Money Today"
                ) {
                    showFastMoney = true
                }

                startCard(
                    icon: "dice.fill",
                    iconColor: Color(hex: "818CF8"),
                    title: "Pick For Me"
                ) {
                    let shuffled = appState.matchResults.shuffled()
                    randomPicks = Array(shuffled.prefix(2))
                    showRandomPicks = true
                }
            }
        }
    }

    private func startCard(icon: String, iconColor: Color, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(iconColor)
                }
                .accessibilityHidden(true)
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(iconColor.opacity(0.1), lineWidth: 0.5)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    // MARK: - Helpers

    private func scoreColor(_ percentage: Int) -> Color {
        if percentage >= 80 { return Theme.accent }
        if percentage >= 60 { return Theme.accentBlue }
        return Color(hex: "FB923C")
    }

    private func perfectForLine(_ result: MatchResult) -> String {
        let path = result.businessPath
        if path.fastCashPotential && path.soloFriendly {
            return "Perfect for solo starters who want fast results"
        } else if path.isDigital {
            return "Perfect for those who prefer working from anywhere"
        } else if path.soloFriendly {
            return "Perfect for independent self-starters"
        } else if path.fastCashPotential {
            return "Perfect for earning quickly with minimal setup"
        } else {
            return "Perfect for building a reliable income stream"
        }
    }
}
