import SwiftUI

struct DegreeCareerDetailSheet: View {
    let record: DegreeCareerRecord
    @Environment(\.dismiss) private var dismiss
    @Environment(StoreViewModel.self) private var store
    @Environment(AppState.self) private var appState
    @State private var showPaywall: Bool = false
    @State private var showPlanAdded: Bool = false

    private var detail: DegreeCareerDetailData? {
        DegreeCareerDatabase.lookup(record.id)
    }

    private var isFav: Bool { appState.isDegreeFavorite(record.id) }

    private var tierColor: Color {
        switch record.aiProofTier {
        case .tier1: return Theme.accent
        case .tier2: return Color(hex: "FBBF24")
        case .tier3: return .orange
        }
    }

    private var catColor: Color {
        switch record.category {
        case .healthcare: return Color(hex: "F472B6")
        case .mentalHealth: return Color(hex: "818CF8")
        case .engineering: return Theme.accentBlue
        case .legal: return Color(hex: "FB923C")
        case .education: return Theme.accent
        case .aviation: return Color(hex: "38BDF8")
        case .military: return Color(hex: "4ADE80")
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroHeader
                    statsBar
                    addToPlanButton
                    favBar
                    overviewCard

                    if store.isPremium {
                        if let detail {
                            educationPathCard(detail)
                            prerequisitesCard(detail)
                            licensingCard(detail)
                            aiResistantCard(detail)
                            salaryCard(detail)
                            bestFitCard(detail)
                        } else {
                            aiReasonsCard
                            bestFitTraitsCard
                        }
                    } else {
                        freeAIReasonsCard
                        proUpgradeCard
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
                Text("\(record.title) has been added to your plan.")
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    private var addToPlanButton: some View {
        Group {
            if appState.hasPlanItem(itemId: record.id, type: .degree) {
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
                    .background(Color(hex: "818CF8"))
                    .clipShape(.capsule)
                }
            } else {
                Button {
                    appState.addPlanItem(.fromDegree(record))
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
                            colors: [Color(hex: "818CF8"), Theme.accentBlue],
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
                    .fill(catColor.opacity(0.12))
                    .frame(width: 72, height: 72)
                Image(systemName: record.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(catColor)
            }
            .padding(.top, 8)

            Text(record.title)
                .font(.title2.bold())
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: record.aiProofTier.icon)
                        .font(.caption2)
                    Text(record.aiProofTier.label)
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(tierColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(tierColor.opacity(0.12))
                .clipShape(.capsule)

                if record.licensingRequired {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                        Text("Licensed")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(Theme.accentBlue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Theme.accentBlue.opacity(0.12))
                    .clipShape(.capsule)
                }
            }
        }
    }

    private var statsBar: some View {
        HStack(spacing: 0) {
            statItem(icon: "dollarsign.circle.fill", title: "Early Career", value: record.salaryEarly)
            Rectangle().fill(Theme.cardBackgroundLight).frame(width: 1, height: 40)
            statItem(icon: "chart.line.uptrend.xyaxis", title: "Experienced", value: record.salaryExperienced)
            Rectangle().fill(Theme.cardBackgroundLight).frame(width: 1, height: 40)
            statItem(icon: "clock.fill", title: "Timeline", value: record.timeline)
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
                .foregroundStyle(catColor)
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

    private var favBar: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    appState.toggleDegreeFavorite(record.id)
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
                if store.isPremium {
                    QuickShareHelper.shareDegreeCareer(record.title)
                } else {
                    showPaywall = true
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: store.isPremium ? "square.and.arrow.up" : "lock.fill")
                        .font(.caption)
                    Text("Share")
                        .font(.caption.weight(.semibold))
                    if !store.isPremium {
                        Text("PRO")
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color(hex: "FBBF24"))
                            .clipShape(.capsule)
                    }
                }
                .foregroundStyle(store.isPremium ? Theme.textSecondary : Color(hex: "FBBF24"))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(store.isPremium ? Theme.cardBackground : Color(hex: "FBBF24").opacity(0.1))
                .clipShape(.capsule)
            }

            Spacer()
        }
    }

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Overview", icon: "text.alignleft")

            HStack(spacing: 6) {
                Image(systemName: "graduationcap")
                    .font(.caption2)
                Text("Degree: \(record.degreeRequired)")
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(Theme.accentBlue)

            Text(record.trainingPath)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)

            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.caption2)
                    .foregroundStyle(Theme.accent)
                    .padding(.top, 2)
                Text(record.demandNotes)
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

    private var freeAIReasonsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Why It's AI-Resistant", icon: "shield.checkered")
            ForEach(Array(record.aiProofReasons.prefix(2).enumerated()), id: \.offset) { _, reason in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(tierColor)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(reason)
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

    private var aiReasonsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Why It's AI-Resistant", icon: "shield.checkered")
            ForEach(Array(record.aiProofReasons.enumerated()), id: \.offset) { _, reason in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(tierColor)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(reason)
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

    private var bestFitTraitsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Best Fit Traits", icon: "person.fill.checkmark")
            FlowLayout(spacing: 8) {
                ForEach(record.bestFitTraits, id: \.self) { trait in
                    Text(trait)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(catColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(catColor.opacity(0.1))
                        .clipShape(.capsule)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private func educationPathCard(_ detail: DegreeCareerDetailData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Education Path", icon: "graduationcap.fill")

            Text(detail.degreeRequired)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)

            Text(detail.degreeDetail)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(3)

            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption2)
                Text(detail.educationTimeline)
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(Theme.accentBlue)

            Text(detail.timelineDetail)
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .lineSpacing(3)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private func prerequisitesCard(_ detail: DegreeCareerDetailData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Prerequisites", icon: "list.bullet")
            ForEach(detail.prerequisites, id: \.self) { prereq in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(catColor)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(prereq)
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

    private func licensingCard(_ detail: DegreeCareerDetailData) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !detail.licensingExamPath.isEmpty {
                sectionHeader("Licensing Path", icon: "checkmark.seal.fill")
                ForEach(Array(detail.licensingExamPath.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .background(catColor)
                            .clipShape(Circle())
                        Text(step)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(3)
                    }
                }
            }

            if !detail.clinicalRequirements.isEmpty {
                if !detail.licensingExamPath.isEmpty {
                    Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                }
                sectionHeader("Clinical Requirements", icon: "stethoscope")
                ForEach(detail.clinicalRequirements, id: \.self) { req in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(catColor)
                            .frame(width: 5, height: 5)
                            .padding(.top, 6)
                        Text(req)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private func aiResistantCard(_ detail: DegreeCareerDetailData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Why It's AI-Resistant", icon: "shield.checkered")
            ForEach(detail.aiResistantReasons, id: \.self) { reason in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(tierColor)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(reason)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }

            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

            Text(detail.demandStability)
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .lineSpacing(3)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private func salaryCard(_ detail: DegreeCareerDetailData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Salary Breakdown", icon: "dollarsign.circle.fill")

            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("Early Career")
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                    Text(detail.earlyCareerPay)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                }
                .frame(maxWidth: .infinity)

                Rectangle().fill(Theme.cardBackgroundLight).frame(width: 1, height: 36)

                VStack(spacing: 4) {
                    Text("Established")
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                    Text(detail.establishedCareerPay)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.accent)
                }
                .frame(maxWidth: .infinity)
            }

            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "arrow.up.right")
                    .font(.caption2)
                    .foregroundStyle(Theme.accent)
                    .padding(.top, 2)
                Text(detail.longTermUpside)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private func bestFitCard(_ detail: DegreeCareerDetailData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Best Fit Summary", icon: "person.fill.checkmark")
            Text(detail.bestFitSummary)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)

            FlowLayout(spacing: 8) {
                ForEach(record.bestFitTraits, id: \.self) { trait in
                    Text(trait)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(catColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(catColor.opacity(0.1))
                        .clipShape(.capsule)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .cardShadow()
    }

    private var proUpgradeCard: some View {
        ProUpgradePromptView(
            title: "Unlock Full Degree Career Details",
            subtitle: "Get the complete roadmap for this career path.",
            features: [
                "Full education path and timeline",
                "Prerequisites and licensing requirements",
                "Complete AI-resistance analysis",
                "Detailed salary breakdown",
                "Best fit personality summary"
            ],
            onUpgrade: { showPaywall = true }
        )
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(catColor)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
        }
    }
}
