import SwiftUI

struct UnifiedExploreView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedResult: MatchResult?
    @State private var showPaywall: Bool = false
    @State private var searchText: String = ""
    @State private var showJobShare: MatchResult?
    @State private var showRedoQuizAlert: Bool = false

    private var allResults: [MatchResult] { appState.matchResults }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let build = appState.activeBuild {
                        continueCard(build)
                    }

                    heroCard(path: .business, subtitle: "\(ContentLibrary.jobCount) businesses")
                    heroCard(path: .trades, subtitle: "\(EducationPathDatabase.all.count) programs")
                    heroCard(path: .degree, subtitle: "\(DegreeCareerDatabase.allRecords.count) careers")

                    if !store.isPremium {
                        upgradeCard
                    }

                    redoQuizCard

                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search careers & businesses")
            .overlay {
                if !searchText.isEmpty {
                    searchOverlay
                }
            }
            .navigationDestination(for: ChosenPath.self) { path in
                switch path {
                case .business:
                    BusinessExplorePage()
                case .trades:
                    TradesExplorePage()
                case .degree:
                    DegreeExplorePage()
                }
            }
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $showJobShare) { result in
                ShareCardPresenterSheet(content: .topMatch(from: result))
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .alert("Redo Quiz?", isPresented: $showRedoQuizAlert) {
                Button("Redo Quiz", role: .destructive) {
                    appState.retakeQuiz()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will reset your matches and restart the quiz.")
            }
        }
    }

    // MARK: - Hero Card

    private func heroCard(path: ChosenPath, subtitle: String) -> some View {
        NavigationLink(value: path) {
            HStack(spacing: 16) {
                Image(systemName: path.icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        LinearGradient(
                            colors: heroGradient(for: path),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text(path.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(20)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }

    private func heroGradient(for path: ChosenPath) -> [Color] {
        switch path {
        case .business: return [Theme.accent, Theme.accent.opacity(0.7)]
        case .trades: return [Theme.accentBlue, Theme.accentBlue.opacity(0.7)]
        case .degree: return [Color(hex: "818CF8"), Color(hex: "818CF8").opacity(0.7)]
        }
    }

    // MARK: - Continue Card

    private func continueCard(_ build: BuildProject) -> some View {
        Button {
            appState.selectedTab = 1
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 3)
                        .frame(width: 48, height: 48)
                    Circle()
                        .trim(from: 0, to: Double(build.progressPercentage) / 100.0)
                        .stroke(Theme.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-90))
                    Text("\(build.progressPercentage)%")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Theme.accent)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Continue Your Plan")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(build.pathName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Search

    private var searchResults: [MatchResult] {
        guard !searchText.isEmpty else { return [] }
        let q = searchText.lowercased()
        return allResults.filter {
            $0.businessPath.name.localizedStandardContains(q) ||
            $0.businessPath.overview.localizedStandardContains(q) ||
            $0.businessPath.category.rawValue.localizedStandardContains(q)
        }
    }

    private var searchOverlay: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if searchResults.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundStyle(.tertiary)
                        Text("No results for \"\(searchText)\"")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 80)
                } else {
                    ForEach(searchResults) { result in
                        Button {
                            selectedResult = result
                            appState.markPathExplored(result.businessPath.id)
                        } label: {
                            searchRow(result)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Color(.systemGroupedBackground))
    }

    private func searchRow(_ result: MatchResult) -> some View {
        HStack(spacing: 14) {
            Image(systemName: result.businessPath.icon)
                .font(.body)
                .foregroundStyle(Theme.categoryColor(for: result.businessPath.category))
                .frame(width: 40, height: 40)
                .background(Theme.categoryColor(for: result.businessPath.category).opacity(0.12))
                .clipShape(.rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(result.businessPath.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                Text(result.businessPath.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
    }

    // MARK: - Redo Quiz

    private var redoQuizCard: some View {
        Button {
            showRedoQuizAlert = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Redo Quiz")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text("Retake the quiz to update your matches")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Upgrade

    private var upgradeCard: some View {
        Button {
            showPaywall = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "crown.fill")
                    .font(.title3)
                    .foregroundStyle(.yellow)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Unlock Full Plans")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text("Business plans, scripts, templates & PDF export")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("PRO")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Theme.accent)
                    .clipShape(.capsule)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}
