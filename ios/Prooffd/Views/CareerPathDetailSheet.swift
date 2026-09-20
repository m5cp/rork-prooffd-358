import SwiftUI

/// Detail sheet for a trade / certification career path.
///
/// Previously defined inside `ExploreTabView.swift` — a view the app never
/// rendered — which forced that dead file to stay in the project. Extracted
/// here so the unused Explore and Progress views could be deleted.
struct CareerPathDetailSheet: View {
    let career: CareerPath
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @State private var showPlanAdded: Bool = false
    @State private var showShareCard: Bool = false
    @State private var showSetPathConfirm: Bool = false

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
                    setAsMyPathButton
                    favHideBar
                    overviewCard
                    firstStepsCard

                    aiSafeCard
                    stepsCard
                    findProgramsCard
                    fundingCard
                    proStepsCard

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
            .sheet(isPresented: $showShareCard) {
                ShareCardPresenterSheet(content: .educationPath(from: career))
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

    private var setAsMyPathButton: some View {
        let isMyPath = appState.myPath?.id == career.id
        return Button {
            if isMyPath {
                appState.clearMyPath()
            } else {
                showSetPathConfirm = true
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isMyPath ? "flag.fill" : "flag")
                    .foregroundStyle(isMyPath ? Theme.accent : Theme.textSecondary)
                Text(isMyPath ? "This Is My Path" : "Set as My Path")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isMyPath ? Theme.accent : Theme.textPrimary)
                Spacer()
                if isMyPath {
                    Text("Active")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.accent)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Theme.accent.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
            .padding(14)
            .background(isMyPath ? Theme.accent.opacity(0.06) : Theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(isMyPath ? Theme.accent.opacity(0.3) : Theme.border, lineWidth: 1))
        }
        .confirmationDialog(
            "Set as My Path?",
            isPresented: $showSetPathConfirm,
            titleVisibility: .visible
        ) {
            Button("Set \(career.title) as My Path") {
                appState.setMyPath(
                    id: career.id,
                    name: career.title,
                    icon: career.icon,
                    type: .trade,
                    matchScore: appState.educationScore(for: career.id)
                )
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This focuses your Progress tab on \(career.title) and gives you a milestone checklist to track your journey.")
        }
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
            ArtworkImage(name: PathArtwork.educationImage(for: career.category))
                .frame(height: 170)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(.rect(cornerRadius: 16))
                .accessibilityHidden(true)

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
                showShareCard = true
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
