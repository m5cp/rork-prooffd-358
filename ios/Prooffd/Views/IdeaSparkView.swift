import SwiftUI

/// A starter business idea, generated from the founder's quiz answers.
nonisolated struct SparkIdea: Identifiable, Sendable {
    let id: String
    let name: String
    let pitch: String
    let problem: String
    let solution: String
    let customer: String
    let offers: [String]
    let symbol: String
    let startupHint: String
}

/// Turns the user's existing matches and quiz profile into concrete, ready-to-edit
/// business ideas — so "I don't know what to start" isn't a dead end.
enum IdeaSparkEngine {
    static func ideas(for profile: UserProfile, matches: [MatchResult]) -> [SparkIdea] {
        let top = matches.prefix(8)
        var results: [SparkIdea] = top.map { match in
            let path = match.businessPath
            return SparkIdea(
                id: path.id,
                name: path.name,
                pitch: "A \(path.name.lowercased()) business serving \(path.customerType.lowercased()).",
                problem: derivedProblem(for: path),
                solution: path.overview,
                customer: path.customerType,
                offers: Array(path.suggestedServices.prefix(4)),
                symbol: logoSymbol(for: path),
                startupHint: path.startupCostRange
            )
        }

        if results.isEmpty {
            results = fallbackIdeas()
        }
        return results
    }

    /// Frames the path as a customer pain rather than a service description.
    private static func derivedProblem(for path: BusinessPath) -> String {
        "\(path.customerType) struggle to find someone reliable, affordable, and available for \(path.name.lowercased()). Most options are either too expensive, too slow, or don't show up."
    }

    private static func logoSymbol(for path: BusinessPath) -> String {
        let name = path.name.lowercased()
        if name.contains("clean") || name.contains("wash") { return "sparkles" }
        if name.contains("lawn") || name.contains("landscap") || name.contains("garden") { return "leaf.fill" }
        if name.contains("pet") || name.contains("dog") { return "pawprint.fill" }
        if name.contains("food") || name.contains("bak") || name.contains("cater") { return "fork.knife" }
        if name.contains("photo") || name.contains("video") { return "camera.fill" }
        if name.contains("hair") || name.contains("barber") || name.contains("nail") { return "scissors" }
        if name.contains("car") || name.contains("auto") || name.contains("detail") { return "car.fill" }
        if name.contains("haul") || name.contains("move") || name.contains("deliver") { return "shippingbox.fill" }
        if name.contains("design") || name.contains("web") || name.contains("digital") { return "laptopcomputer" }
        if name.contains("repair") || name.contains("handy") || name.contains("build") { return "hammer.fill" }
        return "bolt.fill"
    }

    private static func fallbackIdeas() -> [SparkIdea] {
        [
            SparkIdea(
                id: "spark-cleanouts",
                name: "Junk Removal & Cleanouts",
                pitch: "Haul away junk for people clearing out a garage, move, or estate.",
                problem: "People have piles of stuff they can't move themselves and dumpster rentals are expensive and slow.",
                solution: "Same-week pickup with a truck, flat pricing, and everything sorted for donation or the dump.",
                customer: "Homeowners, landlords, and real estate agents",
                offers: ["Single-item pickup", "Garage cleanout", "Full estate cleanout", "Post-move haul away"],
                symbol: "shippingbox.fill",
                startupHint: "$300–$1,500"
            ),
            SparkIdea(
                id: "spark-mobile-detail",
                name: "Mobile Car Detailing",
                pitch: "Detail cars at the customer's home or office so they never have to drive anywhere.",
                problem: "Car washes are a time sink and most people won't give up an hour of their weekend.",
                solution: "You show up with water, power, and supplies and return their car looking new.",
                customer: "Commuters, families, and small car dealerships",
                offers: ["Express interior", "Full interior + exterior", "Headlight restoration", "Monthly maintenance plan"],
                symbol: "car.fill",
                startupHint: "$400–$1,200"
            ),
            SparkIdea(
                id: "spark-lawn",
                name: "Lawn & Yard Care",
                pitch: "Keep yards cut, edged, and clean on a recurring weekly schedule.",
                problem: "Yard work is constant, and most homeowners either don't have time or don't have equipment.",
                solution: "Reliable recurring service with a predictable price and no contracts.",
                customer: "Homeowners and small commercial properties",
                offers: ["Weekly mow & edge", "Leaf cleanup", "Hedge trimming", "Seasonal yard reset"],
                symbol: "leaf.fill",
                startupHint: "$200–$2,000"
            )
        ]
    }
}

struct IdeaSparkView: View {
    var onPick: (SparkIdea) -> Void

    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    private var ideas: [SparkIdea] {
        IdeaSparkEngine.ideas(for: appState.userProfile, matches: appState.matchResults)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Ideas built for you")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("These come from your quiz answers and your top matches. Pick one to prefill a plan — you can change every word after.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 16))

                    ForEach(ideas) { idea in
                        ideaCard(idea)
                    }

                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Idea Generator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func ideaCard(_ idea: SparkIdea) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                LogoMarkView(
                    design: LogoDesign(symbol: idea.symbol, shape: .roundedSquare, paletteId: "electric"),
                    size: 48
                )
                VStack(alignment: .leading, spacing: 2) {
                    Text(idea.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("Startup: \(idea.startupHint)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            labeled("The problem", idea.problem)
            labeled("Who pays you", idea.customer)

            if !idea.offers.isEmpty {
                Text("You could sell")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
                FlowLayout(spacing: 6) {
                    ForEach(idea.offers, id: \.self) { offer in
                        Text(offer)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(Theme.accent)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(Theme.accent.opacity(0.12))
                            .clipShape(.capsule)
                    }
                }
            }

            Button {
                onPick(idea)
            } label: {
                Text("Build a plan from this")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.accent)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    private func labeled(_ label: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
            Text(body)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
