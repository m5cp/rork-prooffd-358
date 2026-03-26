import SwiftUI

struct ExploreTabView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedResult: MatchResult?
    @State private var selectedCareer: CareerPath?
    @State private var showPaywall: Bool = false
    @State private var selectedEducationCategory: EducationCategory?
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var trendingPaths: [MatchResult] {
        Array(appState.matchResults.sorted { $0.scorePercentage > $1.scorePercentage }.prefix(6))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    trendingSection
                    educationOverviewSection
                    careerPathsSection
                    shareLoopSection
                    Color.clear.frame(height: 40)
                }
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $selectedCareer) { career in
                CareerPathDetailSheet(career: career)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Text("Popular Right Now")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(trendingPaths) { result in
                        trendingCard(result)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)
        }
    }

    private func trendingCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return Button {
            selectedResult = result
            appState.markPathExplored(result.businessPath.id)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: result.businessPath.icon)
                            .font(.body)
                            .foregroundStyle(catColor)
                    }
                    Spacer()
                }

                Text(result.businessPath.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                HStack(spacing: 4) {
                    Text("\(result.scorePercentage)% match")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(catColor)
                }

                Text(result.businessPath.startupCostRange)
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
            .frame(width: 150, height: 160, alignment: .leading)
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(catColor.opacity(0.1), lineWidth: 0.5)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    private var educationOverviewSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "graduationcap.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
                Text("Trade Schools & Certifications")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .padding(.horizontal, 16)

            Text("Skilled trades, healthcare, creative & professional programs")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 16)

            let columns = sizeClass == .regular
                ? [GridItem(.adaptive(minimum: 160), spacing: 10)]
                : [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(EducationCategory.allCases) { category in
                    educationCategoryCard(category)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func educationCategoryCard(_ category: EducationCategory) -> some View {
        let paths = EducationPathDatabase.all.filter { $0.category == category }
        let catColor: Color = {
            switch category {
            case .trade: return Theme.accent
            case .certification: return Color(hex: "FBBF24")
            case .healthcare: return Color(hex: "F472B6")
            case .technology: return Theme.accentBlue
            case .business: return Color(hex: "FB923C")
            case .creative: return Color(hex: "818CF8")
            }
        }()

        return Button {
            selectedEducationCategory = selectedEducationCategory == category ? nil : category
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(catColor.opacity(0.12))
                            .frame(width: 36, height: 36)
                        Image(systemName: category.icon)
                            .font(.subheadline)
                            .foregroundStyle(catColor)
                    }
                    Spacer()
                    Text("\(paths.count)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(catColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(catColor.opacity(0.1))
                        .clipShape(.capsule)
                }

                Text(category.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
            }
            .padding(12)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedEducationCategory == category ? catColor.opacity(0.3) : catColor.opacity(0.08), lineWidth: selectedEducationCategory == category ? 1.5 : 0.5)
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selectedEducationCategory)
    }

    private var careerPathsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            let filteredCareers = selectedEducationCategory != nil
                ? EducationPathDatabase.all.filter { $0.category == selectedEducationCategory! }
                : EducationPathDatabase.all

            if let cat = selectedEducationCategory {
                HStack(spacing: 8) {
                    Text(cat.rawValue)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedEducationCategory = nil
                        }
                    } label: {
                        Text("Show All")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.accent)
                    }
                }
                .padding(.horizontal, 16)
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "road.lanes")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accentBlue)
                    Text("All Career Paths")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    Text("\(filteredCareers.count) paths")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.horizontal, 16)
            }

            LazyVStack(spacing: 10) {
                ForEach(filteredCareers) { career in
                    careerListCard(career)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func careerListCard(_ career: CareerPath) -> some View {
        let aiColor: Color = career.aiSafeScore >= 80 ? Theme.accent : career.aiSafeScore >= 50 ? Color(hex: "FBBF24") : .orange

        return Button {
            selectedCareer = career
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Theme.accentBlue.opacity(0.1))
                        .frame(width: 48, height: 48)
                    Image(systemName: career.icon)
                        .font(.body)
                        .foregroundStyle(Theme.accentBlue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(career.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)

                    HStack(spacing: 10) {
                        HStack(spacing: 3) {
                            Image(systemName: "dollarsign.circle")
                                .font(.system(size: 9))
                            Text(career.salaryRange)
                                .font(.caption2)
                        }
                        .foregroundStyle(Theme.accent)

                        HStack(spacing: 3) {
                            Image(systemName: "clock")
                                .font(.system(size: 9))
                            Text(career.timeToIncome)
                                .font(.caption2)
                        }
                        .foregroundStyle(Theme.textTertiary)
                    }
                }

                Spacer(minLength: 4)

                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 3) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 9))
                        Text("\(career.aiSafeScore)")
                            .font(.caption2.weight(.bold))
                    }
                    .foregroundStyle(aiColor)

                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    private var shareLoopSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.fill")
                .font(.title2)
                .foregroundStyle(Theme.accentBlue)
            Text("Challenge a friend to find theirs")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
            Text("Share the app and see who gets better matches")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .multilineTextAlignment(.center)

            Button {
                shareApp()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share with a Friend")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.accentBlue)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Theme.accentBlue.opacity(0.12))
                .clipShape(.capsule)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
        .padding(.horizontal, 16)
    }

    private func shareApp() {
        let text = "I just found my top business matches on Prooffd — challenge yourself to find yours!"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            var topController = root
            while let presented = topController.presentedViewController { topController = presented }
            activityVC.popoverPresentationController?.sourceView = topController.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: topController.view.bounds.midX, y: topController.view.bounds.midY, width: 0, height: 0)
            activityVC.popoverPresentationController?.permittedArrowDirections = []
            topController.present(activityVC, animated: true)
        }
    }
}

struct CareerPathDetailSheet: View {
    let career: CareerPath
    @Environment(\.dismiss) private var dismiss
    @Environment(StoreViewModel.self) private var store
    @State private var showPaywall: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroHeader
                    statsBar
                    overviewCard
                    aiSafeCard
                    stepsCard
                    fundingCard

                    if store.isPremium {
                        proStepsCard
                    } else {
                        proTeaser
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
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Theme.textTertiary)
                            .font(.title3)
                    }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    private var heroHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.accentBlue.opacity(0.12))
                    .frame(width: 72, height: 72)
                Image(systemName: career.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(Theme.accentBlue)
            }
            .padding(.top, 8)

            Text(career.name)
                .font(.title2.bold())
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)

            aiSafeBadge
        }
    }

    private var aiSafeBadge: some View {
        let zone = career.zone
        let color: Color = zone == .safe ? Theme.accent : zone == .human ? Color(hex: "FBBF24") : .orange
        return HStack(spacing: 6) {
            Image(systemName: zone.icon)
                .font(.caption2)
            Text("\(zone.label) — \(career.aiSafeScore)/100")
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(color.opacity(0.12))
        .clipShape(.capsule)
    }

    private var statsBar: some View {
        HStack(spacing: 0) {
            statItem(icon: "dollarsign.circle.fill", title: "Salary", value: career.salaryRange)
            Rectangle().fill(Theme.cardBackgroundLight).frame(width: 1, height: 40)
            statItem(icon: "clock.fill", title: "Time", value: career.timeToIncome)
            Rectangle().fill(Theme.cardBackgroundLight).frame(width: 1, height: 40)
            statItem(icon: "banknote.fill", title: "Cost", value: career.costRange)
        }
        .padding(.vertical, 16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private func statItem(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(Theme.accentBlue)
            Text(title)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
            Text(value)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Overview", icon: "text.alignleft")
            Text(career.overview)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)

            if !career.whyItWorksNow.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text(career.whyItWorksNow)
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private var aiSafeCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Why It's AI-Resistant", icon: "shield.checkered")
            Text(career.whyAIResistant)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private var stepsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Steps to Get Started", icon: "list.number")
            ForEach(Array(career.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(Theme.accentBlue)
                        .clipShape(Circle())
                    Text(step)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(3)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private var fundingCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Funding Options", icon: "banknote.fill")
            ForEach(career.fundingOptions, id: \.self) { option in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Theme.accent)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(option)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private var proStepsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Advanced Steps", icon: "arrow.up.right")
            ForEach(Array(career.proSteps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(Theme.accent)
                        .clipShape(Circle())
                    Text(step)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(3)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private var proTeaser: some View {
        Button {
            showPaywall = true
        } label: {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                    Text("Advanced Career Steps")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }

                Text("Unlock detailed advancement paths, specialization guides, and networking strategies")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 6) {
                    Image(systemName: "lock.open.fill")
                    Text("Upgrade to Pro")
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [Theme.accent, Theme.accentBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(.capsule)
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Theme.accentBlue)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
        }
    }
}
