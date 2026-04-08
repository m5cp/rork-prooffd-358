import SwiftUI

struct ExploreTabView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @State private var selectedResult: MatchResult?
    @State private var showPaywall: Bool = false
    @State private var showEducationCategorySheet: EducationCategory?
    @State private var randomizedTrending: [MatchResult] = []
    @State private var showHeroBusinessResult: MatchResult?
    @State private var showHeroEducationPath: CareerPath?
    @State private var showHeroDegreeRecord: DegreeCareerRecord?
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    bestMatchHeroCard
                    filterBar
                    educationOverviewSection
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
            .sheet(item: $showHeroBusinessResult) { result in
                PathDetailView(result: result)
            }
            .sheet(item: $showHeroEducationPath) { career in
                CareerPathDetailSheet(career: career)
            }
            .sheet(item: $showHeroDegreeRecord) { record in
                DegreeCareerDetailSheet(record: record)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(item: $showEducationCategorySheet) { category in
                EducationCategoryListSheet(category: category)
            }
            .onAppear {
                shuffleTrending()
            }
        }
    }

    private func shuffleTrending() {
        randomizedTrending = Array(appState.matchResults.shuffled().prefix(6))
    }

    // MARK: - Best Match Hero Card

    @ViewBuilder
    private var bestMatchHeroCard: some View {
        if let path = appState.chosenPath {
            switch path {
            case .business:
                if let topResult = appState.matchResults.first {
                    heroBusinessCard(topResult)
                }
            case .trades:
                if let topEdu = topEducationMatch {
                    heroTradesCard(topEdu.path, score: topEdu.score)
                }
            case .degree:
                if let topDeg = topDegreeMatch {
                    heroDegreeCard(topDeg.record, score: topDeg.score)
                }
            }
        }
    }

    private var topEducationMatch: (path: EducationPath, score: Int)? {
        let scored = EducationPathDatabase.all.compactMap { path -> (path: EducationPath, score: Int)? in
            let s = appState.educationScore(for: path.id)
            return (path, s)
        }
        return scored.max(by: { $0.score < $1.score })
    }

    private var topDegreeMatch: (record: DegreeCareerRecord, score: Int)? {
        let scored = DegreeCareerDatabase.allRecords.compactMap { record -> (record: DegreeCareerRecord, score: Int)? in
            let s = appState.degreeScore(for: record.id)
            return (record, s)
        }
        return scored.max(by: { $0.score < $1.score })
    }

    private func heroBusinessCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return Button {
            showHeroBusinessResult = result
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 52, height: 52)
                        Image(systemName: result.businessPath.icon)
                            .font(.title3)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                            Text("Your Best Match")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.accent)
                        }

                        Text(result.businessPath.name)
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(1)

                        Text(result.businessPath.category.rawValue)
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                    }

                    Spacer()

                    heroScoreBadge(result.scorePercentage, color: catColor)
                }
                .padding(16)

                Rectangle()
                    .fill(catColor.opacity(0.08))
                    .frame(height: 1)

                HStack(spacing: 16) {
                    heroStat(icon: "dollarsign.circle.fill", value: result.businessPath.startupCostRange, color: catColor)
                    heroStat(icon: "clock.fill", value: result.businessPath.timeToFirstDollar, color: catColor)
                    heroStat(icon: result.businessPath.zone.icon, value: "\(result.businessPath.aiProofRating)/100", color: catColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private func heroTradesCard(_ path: EducationPath, score: Int) -> some View {
        let catColor = Theme.accentBlue
        return Button {
            showHeroEducationPath = path
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 52, height: 52)
                        Image(systemName: path.icon)
                            .font(.title3)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                            Text("Your Best Match")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(catColor)
                        }

                        Text(path.title)
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(1)

                        Text(path.category.rawValue)
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                    }

                    Spacer()

                    heroScoreBadge(score, color: catColor)
                }
                .padding(16)

                Rectangle()
                    .fill(catColor.opacity(0.08))
                    .frame(height: 1)

                HStack(spacing: 16) {
                    heroStat(icon: "dollarsign.circle.fill", value: path.typicalSalaryRange, color: catColor)
                    heroStat(icon: "clock.fill", value: path.timeToComplete, color: catColor)
                    heroStat(icon: path.zone.icon, value: "\(path.aiSafeScore)/100", color: catColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private func heroDegreeCard(_ record: DegreeCareerRecord, score: Int) -> some View {
        let catColor = Color(hex: "818CF8")
        return Button {
            showHeroDegreeRecord = record
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(catColor.opacity(0.15))
                            .frame(width: 52, height: 52)
                        Image(systemName: record.icon)
                            .font(.title3)
                            .foregroundStyle(catColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                            Text("Your Best Match")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(catColor)
                        }

                        Text(record.title)
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(1)

                        Text(record.category.rawValue)
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                    }

                    Spacer()

                    heroScoreBadge(score, color: catColor)
                }
                .padding(16)

                Rectangle()
                    .fill(catColor.opacity(0.08))
                    .frame(height: 1)

                HStack(spacing: 16) {
                    heroStat(icon: "dollarsign.circle.fill", value: record.salaryExperienced, color: catColor)
                    heroStat(icon: "clock.fill", value: record.timeline, color: catColor)
                    heroStat(icon: record.aiProofTier.icon, value: record.aiProofTier.label, color: catColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(
                LinearGradient(
                    colors: [catColor.opacity(0.06), Theme.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(catColor.opacity(0.2), lineWidth: 1)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private func heroScoreBadge(_ score: Int, color: Color) -> some View {
        VStack(spacing: 2) {
            Text("\(score)%")
                .font(.title2.weight(.bold))
                .foregroundStyle(color)
            Text("match")
                .font(.caption2.weight(.medium))
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(width: 60)
    }

    private func heroStat(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(color)
            Text(value)
                .font(.caption2.weight(.medium))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    private var filterBar: some View {
        HStack(spacing: 8) {
            ForEach(ExploreFilterMode.allCases) { mode in
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        appState.exploreFilter = mode
                    }
                } label: {
                    Text(mode.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(appState.exploreFilter == mode ? .white : Theme.textSecondary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(appState.exploreFilter == mode ? Theme.accent : Theme.cardBackground)
                        .clipShape(.capsule)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    private var filteredTrending: [MatchResult] {
        switch appState.exploreFilter {
        case .all:
            return randomizedTrending.filter { !appState.isPathHidden($0.businessPath.id) }
        case .favorites:
            return randomizedTrending.filter { appState.isFavorite($0.businessPath.id) }
        case .hidden:
            return appState.matchResults.filter { appState.isPathHidden($0.businessPath.id) }
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
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        shuffleTrending()
                    }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
            }
            .padding(.horizontal, 16)

            if filteredTrending.isEmpty {
                emptyFilterState(appState.exploreFilter == .favorites ? "No favorited careers yet" : "No hidden careers")
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(filteredTrending) { result in
                            trendingCard(result)
                        }
                    }
                }
                .contentMargins(.horizontal, 16)
                .scrollIndicators(.hidden)
            }
        }
    }

    private func trendingCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        let isFav = appState.isFavorite(result.businessPath.id)
        let isHidden = appState.isPathHidden(result.businessPath.id)
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
                    if isFav {
                        Image(systemName: "heart.fill")
                            .font(.caption2)
                            .foregroundStyle(.pink)
                    }
                }

                Text(result.businessPath.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                HStack(spacing: 4) {
                    Image(systemName: result.businessPath.zone.icon)
                        .font(.system(size: 9))
                    Text("\(result.businessPath.aiProofRating)/100")
                        .font(.caption2.weight(.semibold))
                }
                .foregroundStyle(catColor)

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
        .contextMenu {
            Button {
                appState.toggleFavorite(result.businessPath.id)
            } label: {
                Label(isFav ? "Unfavorite" : "Favorite", systemImage: isFav ? "heart.slash.fill" : "heart.fill")
            }
            Button(role: isHidden ? nil : .destructive) {
                appState.toggleHiddenPath(result.businessPath.id)
            } label: {
                Label(isHidden ? "Unhide" : "Hide", systemImage: isHidden ? "eye.fill" : "eye.slash.fill")
            }
        }
    }

    private var filteredEducationCategories: [EducationCategory] {
        switch appState.exploreFilter {
        case .all:
            return EducationCategory.allCases.filter { category in
                EducationPathDatabase.all.contains { $0.category == category && !appState.isEducationHidden($0.id) }
            }
        case .favorites:
            return EducationCategory.allCases.filter { category in
                EducationPathDatabase.all.contains { $0.category == category && appState.isEducationFavorite($0.id) }
            }
        case .hidden:
            return EducationCategory.allCases.filter { category in
                EducationPathDatabase.all.contains { $0.category == category && appState.isEducationHidden($0.id) }
            }
        }
    }

    private func educationCount(for category: EducationCategory) -> Int {
        let paths = EducationPathDatabase.all.filter { $0.category == category }
        switch appState.exploreFilter {
        case .all: return paths.filter { !appState.isEducationHidden($0.id) }.count
        case .favorites: return paths.filter { appState.isEducationFavorite($0.id) }.count
        case .hidden: return paths.filter { appState.isEducationHidden($0.id) }.count
        }
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

            let categories = filteredEducationCategories

            if categories.isEmpty {
                emptyFilterState(appState.exploreFilter == .favorites ? "No favorited programs yet" : "No hidden programs")
            } else {
                let columns = sizeClass == .regular
                    ? [GridItem(.adaptive(minimum: 160), spacing: 10)]
                    : [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(categories) { category in
                        educationCategoryCard(category)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private func educationCategoryCard(_ category: EducationCategory) -> some View {
        let count = educationCount(for: category)
        let catColor: Color = {
            switch category {
            case .trade: return Theme.accent
            case .certification: return Color(hex: "FBBF24")
            case .healthcare: return Color(hex: "F472B6")
            case .technology: return Theme.accentBlue
            case .business: return Color(hex: "FB923C")
            case .creative: return Color(hex: "818CF8")
            case .military: return Color(hex: "4ADE80")
            }
        }()

        return Button {
            showEducationCategorySheet = category
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
                    Text("\(count)")
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
                    .stroke(catColor.opacity(0.08), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: showEducationCategorySheet)
    }

    private func emptyFilterState(_ message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: appState.exploreFilter == .favorites ? "heart" : "eye.slash")
                .font(.title2)
                .foregroundStyle(Theme.textTertiary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
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
        if let topResult = appState.matchResults.first {
            let content = ShareCardContent.topMatch(from: topResult)
            let card = TopMatchShareCardView(content: content, style: .clean, format: .story)
            if let image = ShareCardRenderer.render(view: card, format: .story) {
                let shareText = "I just found my top career matches on Prooffd — challenge yourself to find yours! Download Prooffd: https://apps.apple.com/app/prooffd/id6743071053"
                ShareCardRenderer.share(image: image, text: shareText)
            }
        } else {
            let shareText = "Check out Prooffd — find your perfect career or business match! Download: https://apps.apple.com/app/prooffd/id6743071053"
            ShareCardRenderer.share(image: UIImage(), text: shareText)
        }
    }
}

struct CareerPathDetailSheet: View {
    let career: CareerPath
    @Environment(\.dismiss) private var dismiss
    @Environment(StoreViewModel.self) private var store
    @Environment(AppState.self) private var appState
    @State private var showPaywall: Bool = false
    @State private var showPlanAdded: Bool = false

    private var isFav: Bool { appState.isEducationFavorite(career.id) }
    private var isHidden: Bool { appState.isEducationHidden(career.id) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroHeader
                    deliveryBadge
                    statsBar
                    addToPlanButton
                    favHideBar
                    overviewCard
                    firstStepsCard

                    if store.isPremium {
                        aiSafeCard
                        stepsCard
                        findProgramsCard
                        fundingCard
                        proStepsCard
                    } else {
                        careerProUpgradePrompt
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
            .confirmationDialog("Added to My Plan!", isPresented: $showPlanAdded, titleVisibility: .visible) {
                Button("Go Now") {
                    appState.selectedTab = 1
                    dismiss()
                }
                Button("Stay on Page", role: .cancel) { }
            } message: {
                Text("\(career.title) has been added to your plan.")
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    private var addToPlanButton: some View {
        Group {
            if appState.hasPlanItem(itemId: career.id, type: .trade) {
                Button {
                    if appState.selectedTab == 1 {
                        dismiss()
                    } else {
                        appState.selectedTab = 1
                        dismiss()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "list.clipboard.fill")
                        Text(appState.selectedTab == 1 ? "Build My Plan" : "Go to My Plan")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.accentBlue)
                    .clipShape(.capsule)
                }
            } else {
                Button {
                    appState.addPlanItem(.fromEducation(career))
                    showPlanAdded = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add to My Plan")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Theme.accentBlue, Color(hex: "818CF8")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(.capsule)
                }
                .sensoryFeedback(.impact(weight: .medium), trigger: showPlanAdded)
            }
        }
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

    private var deliveryBadge: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: deliveryIcon)
                    .font(.caption2)
                Text(career.deliveryType)
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(Theme.accentBlue)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Theme.accentBlue.opacity(0.1))
            .clipShape(.capsule)

            if career.deliveryType.lowercased().contains("person") || career.deliveryType.lowercased().contains("apprenticeship") || career.deliveryType.lowercased().contains("school") {
                Text("Online & hybrid programs may be available")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
    }

    private var deliveryIcon: String {
        let dt = career.deliveryType.lowercased()
        if dt.contains("online") && dt.contains("person") { return "laptopcomputer.and.arrow.down" }
        if dt.contains("online") || dt.contains("remote") || dt.contains("self-taught") { return "laptopcomputer" }
        if dt.contains("hybrid") { return "building.2" }
        return "mappin.and.ellipse"
    }

    private var favHideBar: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    appState.toggleEducationFavorite(career.id)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isFav ? "heart.fill" : "heart")
                        .font(.caption)
                    Text(isFav ? "Favorited" : "Favorite")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(isFav ? .pink : Theme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isFav ? Color.pink.opacity(0.1) : Theme.cardBackground)
                .clipShape(.capsule)
            }
            .sensoryFeedback(.selection, trigger: isFav)

            Button {
                withAnimation(.spring(duration: 0.3)) {
                    appState.toggleHiddenEducation(career.id)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isHidden ? "eye.fill" : "eye.slash")
                        .font(.caption)
                    Text(isHidden ? "Unhide" : "Hide")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Theme.cardBackground)
                .clipShape(.capsule)
            }

            Button {
                QuickShareHelper.shareTrade(career.title)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.caption)
                    Text("Share")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Theme.cardBackground)
                .clipShape(.capsule)
            }

            Spacer()
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

            if !career.futureDemand.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.caption2)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)
                    Text(career.futureDemand)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .lineSpacing(3)
                }
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

    private var firstStepsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Your First Steps", icon: "figure.walk")

            let firstSteps = [
                "Decide what area of \(career.title.lowercased()) interests you most",
                "Choose your learning format: \(career.deliveryType.lowercased())",
                "Research accredited programs in your area or online",
                "Compare costs, time commitment, and funding options",
                "Apply and begin your training"
            ]

            ForEach(Array(firstSteps.enumerated()), id: \.offset) { index, step in
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

    private var findProgramsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("How to Find Programs", icon: "magnifyingglass")
            ForEach(career.howToFindPrograms, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Theme.accentBlue)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(item)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }

            if !career.employerSponsoredOptions.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Employer-Sponsored Options")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                ForEach(career.employerSponsoredOptions, id: \.self) { option in
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

            if !career.militaryPath.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "shield.fill")
                        .font(.caption2)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)
                    Text(career.militaryPath)
                        .font(.caption)
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

    private var careerProUpgradePrompt: some View {
        ProUpgradePromptView(
            title: "Unlock Full Career Details",
            subtitle: "Get the complete roadmap for this career path.",
            features: [
                "Why this career is AI-resistant",
                "Step-by-step certification path",
                "How to find accredited programs",
                "Funding options & financial aid",
                "Advanced career steps"
            ],
            onUpgrade: { showPaywall = true }
        )
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
