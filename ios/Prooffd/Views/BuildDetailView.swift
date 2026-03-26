import SwiftUI

struct BuildDetailView: View {
    let buildId: String
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall: Bool = false
    @State private var showDeleteConfirm: Bool = false
    @State private var celebrationStep: String?
    @State private var expandedUnlockTier: Int?
    @State private var expandedProSection: String?
    @State private var shareImage: UIImage?
    @State private var showShareSheet: Bool = false

    private var build: BuildProject? {
        appState.builds.first { $0.id == buildId }
    }

    private var path: BusinessPath? {
        guard let build else { return nil }
        return BusinessPathDatabase.allPaths.first { $0.id == build.pathId }
    }

    var body: some View {
        NavigationStack {
            if let build {
                ScrollView {
                    VStack(spacing: 20) {
                        progressHeader(build)
                        todayStepSection(build)
                        stepsSection(build)
                        overviewSection(build)
                        businessPlanEditorSection(build)
                        actionPlanSection
                        pricingSection
                        unlockTiersSection(build)
                        proContentSections(build)
                        fullBusinessPlanSection
                        suggestionsSection(build)
                        if store.isPremium {
                            exportButton(build)
                        }
                        shareProgressButton(build)
                        dangerZone
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
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
                .sheet(isPresented: $showPaywall) {
                    PaywallView()
                }
                .alert("Remove Build?", isPresented: $showDeleteConfirm) {
                    Button("Cancel", role: .cancel) {}
                    Button("Remove", role: .destructive) {
                        appState.removeBuild(buildId)
                        dismiss()
                    }
                } message: {
                    Text("This will remove this build and all progress. This cannot be undone.")
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    // MARK: - Progress Header

    private func progressHeader(_ build: BuildProject) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Theme.cardBackgroundLight, lineWidth: 8)
                    .frame(width: 100, height: 100)
                Circle()
                    .trim(from: 0, to: Double(build.progressPercentage) / 100.0)
                    .stroke(Theme.accent, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text("\(build.progressPercentage)%")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.textPrimary)
                    Text("complete")
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .padding(.top, 8)

            VStack(spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: build.pathIcon)
                        .font(.caption)
                        .foregroundStyle(Theme.categoryColor(for: build.category))
                    Text(build.businessName)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                }

                Text(build.currentMilestone)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Theme.accent.opacity(0.12))
                    .clipShape(.capsule)

                HStack(spacing: 16) {
                    Text("Started \(build.startDate.formatted(.dateTime.month().day()))")
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 9))
                        Text("\(appState.momentum.totalPoints) pts")
                            .font(.caption2.weight(.semibold))
                    }
                    .foregroundStyle(Color(hex: "FBBF24"))
                }

                if let path {
                    HStack(spacing: 12) {
                        statChip(icon: "dollarsign.circle.fill", value: path.startupCostRange)
                        statChip(icon: "clock.fill", value: path.timeToFirstDollar)
                        statChip(icon: "shield.checkered", value: "\(path.aiProofRating)/100")
                    }
                    .padding(.top, 4)
                }
            }
        }
    }

    private func statChip(icon: String, value: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 9))
                .foregroundStyle(Theme.accent)
            Text(value)
                .font(.caption2.weight(.medium))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Theme.cardBackground)
        .clipShape(.capsule)
    }

    // MARK: - Today's Step

    private func todayStepSection(_ build: BuildProject) -> some View {
        Group {
            if let step = build.nextStep {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                        Text("Next Step")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                    }

                    Text(step.title)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)

                    Button {
                        withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                            appState.toggleBuildStep(buildId: build.id, stepId: step.id)
                            celebrationStep = step.id
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark Complete  +10 pts")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.accent)
                        .clipShape(.capsule)
                    }
                    .sensoryFeedback(.success, trigger: celebrationStep)
                }
                .padding(16)
                .background(
                    LinearGradient(
                        colors: [Theme.accent.opacity(0.08), Theme.cardBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    // MARK: - Steps Checklist

    private func stepsSection(_ build: BuildProject) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "list.number")
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
                Text("All Steps")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text("\(build.completedSteps)/\(build.totalSteps)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textTertiary)
            }

            ForEach(build.steps) { step in
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        appState.toggleBuildStep(buildId: build.id, stepId: step.id)
                    }
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: step.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.body)
                            .foregroundStyle(step.isCompleted ? Theme.accent : Theme.textTertiary)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(step.title)
                                .font(.subheadline)
                                .foregroundStyle(step.isCompleted ? Theme.textTertiary : Theme.textSecondary)
                                .strikethrough(step.isCompleted, color: Theme.textTertiary)
                                .multilineTextAlignment(.leading)

                            if let date = step.completedDate {
                                Text("Completed \(date.formatted(.dateTime.month(.abbreviated).day()))")
                                    .font(.caption2)
                                    .foregroundStyle(Theme.accent.opacity(0.7))
                            }

                            if let notes = step.notes, !notes.isEmpty {
                                Text(notes)
                                    .font(.caption)
                                    .foregroundStyle(Theme.textTertiary)
                                    .lineLimit(2)
                            }
                        }

                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
                .sensoryFeedback(.selection, trigger: step.isCompleted)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Overview (from job data)

    private func overviewSection(_ build: BuildProject) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Overview", icon: "text.alignleft")
            Text(build.overview)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)

            if let path {
                if !path.whyItWorksNow.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Why It Works Now")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.accent)
                        Text(path.whyItWorksNow)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(3)
                    }
                    .padding(.top, 4)
                }

                HStack(spacing: 8) {
                    detailChip("Customer: \(path.customerType)")
                    detailChip("Education: \(path.educationRequired)")
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Editable Business Plan Fields

    private func businessPlanEditorSection(_ build: BuildProject) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "pencil.and.outline")
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
                Text("Your Business Plan")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
            }

            editableField(label: "Business Name", value: build.businessName, field: .businessName, buildId: build.id)
            editableField(label: "Pricing", value: build.pricingNotes, field: .pricing, buildId: build.id)
            editableField(label: "Services", value: build.serviceNotes.isEmpty ? "Describe your services..." : build.serviceNotes, field: .services, buildId: build.id)
            editableField(label: "Strategy", value: build.strategyNotes.isEmpty ? "Notes on your approach..." : build.strategyNotes, field: .strategy, buildId: build.id)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func editableField(label: String, value: String, field: BuildField, buildId: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.textTertiary)
            TextField(label, text: Binding(
                get: {
                    guard let b = appState.builds.first(where: { $0.id == buildId }) else { return value }
                    switch field {
                    case .businessName: return b.businessName
                    case .pricing: return b.pricingNotes
                    case .strategy: return b.strategyNotes
                    case .services: return b.serviceNotes
                    }
                },
                set: { newValue in
                    appState.updateBuildField(buildId: buildId, field: field, value: newValue)
                }
            ), axis: .vertical)
            .font(.subheadline)
            .foregroundStyle(Theme.textPrimary)
            .padding(10)
            .background(Theme.cardBackgroundLight)
            .clipShape(.rect(cornerRadius: 8))
        }
    }

    // MARK: - Action Plan (from job data)

    private var actionPlanSection: some View {
        Group {
            if let path {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Step-by-Step Action Plan", icon: "list.number")

                    ForEach(Array(path.actionPlan.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.background)
                                .frame(width: 24, height: 24)
                                .background(Theme.accent)
                                .clipShape(Circle())

                            Text(step)
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                                .lineSpacing(2)
                        }
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    // MARK: - Pricing (from job data)

    private var pricingSection: some View {
        Group {
            if let path {
                VStack(alignment: .leading, spacing: 10) {
                    sectionHeader("Starter Pricing", icon: "tag.fill")
                    Text(path.starterPricing)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(4)
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    // MARK: - Unlock Tiers

    private func unlockTiersSection(_ build: BuildProject) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "gift.fill")
                    .font(.caption)
                    .foregroundStyle(Color(hex: "FBBF24"))
                Text("Unlocked Content")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
            }

            let tier1 = UnlockContentDatabase.tier1Content(for: build.pathName)
            let tier2 = UnlockContentDatabase.tier2Content(for: build.pathName)
            let tier3 = UnlockContentDatabase.tier3Teaser

            if build.unlockTier >= 1 {
                unlockTierCard(tier1, isUnlocked: true)
            } else {
                lockedTierCard(title: "Starter Kit", requirement: "Reach 15% progress to unlock", progress: Double(build.progressPercentage) / 15.0)
            }

            if build.unlockTier >= 2 {
                unlockTierCard(tier2, isUnlocked: true)
            } else {
                lockedTierCard(title: "Growth Kit", requirement: "Reach 40% progress to unlock", progress: Double(build.progressPercentage) / 40.0)
            }

            if build.unlockTier >= 3 && store.isPremium {
                unlockTierCard(tier3, isUnlocked: true)
            } else if store.isPremium {
                lockedTierCard(title: "Pro Growth System", requirement: "Reach 70% to unlock", progress: Double(build.progressPercentage) / 70.0)
            } else {
                lockedTierCard(title: "Pro Growth System", requirement: "Pro feature — upgrade to access", progress: 0, isPro: true)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func unlockTierCard(_ content: UnlockContent, isUnlocked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    expandedUnlockTier = expandedUnlockTier == content.tier ? nil : content.tier
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(Theme.accent)
                    Text(content.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    Image(systemName: expandedUnlockTier == content.tier ? "chevron.up" : "chevron.down")
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }
            }

            if expandedUnlockTier == content.tier {
                ForEach(content.items) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: item.icon)
                                .font(.caption)
                                .foregroundStyle(Theme.accent)
                            Text(item.title)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                        }
                        Text(item.content)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(2)
                    }
                    .padding(10)
                    .background(Theme.cardBackgroundLight)
                    .clipShape(.rect(cornerRadius: 8))
                }
                .textSelection(.enabled)
            }
        }
        .padding(12)
        .background(Theme.accent.opacity(0.04))
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Theme.accent.opacity(0.15), lineWidth: 0.5)
        )
    }

    private func lockedTierCard(title: String, requirement: String, progress: Double, isPro: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: isPro ? "crown.fill" : "lock.fill")
                    .font(.caption)
                    .foregroundStyle(isPro ? Color(hex: "FBBF24") : Theme.textTertiary)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textTertiary)
                Spacer()
            }
            Text(requirement)
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)

            if !isPro && progress > 0 {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Theme.cardBackgroundLight)
                            .frame(height: 3)
                        Capsule()
                            .fill(Theme.accent.opacity(0.5))
                            .frame(width: geo.size.width * min(progress, 1.0), height: 3)
                    }
                }
                .frame(height: 3)
            }

            if isPro {
                Button {
                    showPaywall = true
                } label: {
                    Text("Upgrade to Pro")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
            }
        }
        .padding(12)
        .background(Theme.cardBackgroundLight.opacity(0.5))
        .clipShape(.rect(cornerRadius: 10))
    }

    // MARK: - Pro Content Sections (actual content, not just titles)

    private func proContentSections(_ build: BuildProject) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "briefcase.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
                Text("Business Tools")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                if !store.isPremium {
                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                        Text("Pro")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Theme.accent)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.accent.opacity(0.12))
                    .clipShape(.capsule)
                }
            }
            .padding(16)
            .padding(.bottom, 4)

            if store.isPremium {
                VStack(spacing: 0) {
                    expandableProRow(id: "email", title: "Draft Email", icon: "envelope.fill", description: "Pre-written outreach email", content: path?.draftEmail)
                    proFeatureDivider
                    expandableProRow(id: "text", title: "Draft Text Message", icon: "message.fill", description: "Ready-to-send text template", content: path?.draftTextMessage)
                    proFeatureDivider
                    expandableProRow(id: "sales", title: "Sales Intro Script", icon: "person.wave.2.fill", description: "Word-for-word intro script", content: path?.salesIntroScript)
                    proFeatureDivider
                    expandableProRow(id: "followup", title: "Follow-Up Script", icon: "arrow.uturn.forward", description: "Follow-up conversation template", content: path?.followUpScript)
                    proFeatureDivider
                    expandableProRow(id: "social", title: "Social Media Post", icon: "square.and.arrow.up.fill", description: "Ready-to-post content", content: path?.socialMediaPost)
                    proFeatureDivider
                    expandableProRow(id: "flyer", title: "Flyer Copy", icon: "doc.richtext.fill", description: "Print-ready flyer text", content: path?.flyerCopy)
                    proFeatureDivider
                    expandableProRow(id: "pricing_sheet", title: "Offer & Pricing Sheet", icon: "dollarsign.square.fill", description: "Suggested pricing structure", content: path?.offerPricingSheet)
                    proFeatureDivider
                    expandableProRow(id: "pdf", title: "PDF Export", icon: "arrow.down.doc.fill", description: "Download your build as PDF", content: nil, isPDFExport: true)
                }
            } else {
                VStack(spacing: 0) {
                    lockedProRow(title: "Draft Email", icon: "envelope.fill", description: "Pre-written outreach email")
                    proFeatureDivider
                    lockedProRow(title: "Draft Text Message", icon: "message.fill", description: "Ready-to-send text template")
                    proFeatureDivider
                    lockedProRow(title: "Sales Intro Script", icon: "person.wave.2.fill", description: "Word-for-word intro script")
                    proFeatureDivider
                    lockedProRow(title: "Follow-Up Script", icon: "arrow.uturn.forward", description: "Follow-up conversation template")
                    proFeatureDivider
                    lockedProRow(title: "Social Media Post", icon: "square.and.arrow.up.fill", description: "Ready-to-post content")
                    proFeatureDivider
                    lockedProRow(title: "Flyer Copy", icon: "doc.richtext.fill", description: "Print-ready flyer text")
                    proFeatureDivider
                    lockedProRow(title: "Offer & Pricing Sheet", icon: "dollarsign.square.fill", description: "Suggested pricing structure")
                    proFeatureDivider
                    lockedProRow(title: "Full Business Plan", icon: "doc.text.fill", description: "Comprehensive business plan")
                    proFeatureDivider
                    lockedProRow(title: "PDF Export", icon: "arrow.down.doc.fill", description: "Download your build as PDF")
                }

                Button {
                    showPaywall = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "lock.open.fill")
                        Text("Unlock All Features with Pro")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
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
            }
        }
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(store.isPremium ? Color.clear : Theme.accent.opacity(0.2), lineWidth: 1)
        )
    }

    private func expandableProRow(id: String, title: String, icon: String, description: String, content: String?, isPDFExport: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                if isPDFExport, let build {
                    exportBuildPDF(build)
                } else if content != nil {
                    withAnimation(.spring(duration: 0.3)) {
                        expandedProSection = expandedProSection == id ? nil : id
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundStyle(Theme.accent)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.textPrimary)
                        Text(description)
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }
                    Spacer()
                    if isPDFExport {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                    } else if content != nil {
                        Image(systemName: expandedProSection == id ? "chevron.up" : "chevron.down")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }

            if expandedProSection == id, let content, !content.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.strippingEmoji)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(3)
                        .textSelection(.enabled)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
    }

    private func lockedProRow(title: String, icon: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.textTertiary)
                Text(description)
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
            Spacer()
            Image(systemName: "lock.fill")
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var proFeatureDivider: some View {
        Rectangle()
            .fill(Theme.cardBackgroundLight)
            .frame(height: 0.5)
            .padding(.leading, 52)
    }

    // MARK: - Full Business Plan (Pro)

    private var fullBusinessPlanSection: some View {
        Group {
            if store.isPremium, let path {
                let sections = BusinessPlanGenerator.generate(for: path)

                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            Image(systemName: "doc.text.fill")
                                .font(.title3)
                                .foregroundStyle(Theme.accent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("One-Page Business Plan")
                                    .font(.headline)
                                    .foregroundStyle(Theme.textPrimary)
                                Text(path.name)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(Theme.accent)
                            }
                        }
                        Rectangle()
                            .fill(LinearGradient(colors: [Theme.accent, Theme.accent.opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                            .frame(height: 2)
                    }
                    .padding(16)
                    .padding(.bottom, 4)

                    ForEach(Array(sections.enumerated()), id: \.offset) { index, section in
                        if index > 0 {
                            Rectangle()
                                .fill(Theme.cardBackgroundLight)
                                .frame(height: 0.5)
                                .padding(.horizontal, 16)
                        }
                        businessPlanSectionView(section)
                    }

                    Rectangle()
                        .fill(Theme.cardBackgroundLight)
                        .frame(height: 0.5)
                        .padding(.horizontal, 16)

                    HStack(spacing: 6) {
                        Image(systemName: "doc.on.doc")
                            .font(.caption2)
                        Text("Long press any section to copy text")
                            .font(.caption2)
                    }
                    .foregroundStyle(Theme.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                }
                .textSelection(.enabled)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }

    private func businessPlanSectionView(_ section: BusinessPlanSection) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Text(section.number)
                    .font(.caption2.weight(.bold).monospaced())
                    .foregroundStyle(Theme.background)
                    .frame(width: 26, height: 26)
                    .background(Theme.accent)
                    .clipShape(Circle())
                Image(systemName: section.icon)
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
                Text(section.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }

            ForEach(Array(section.content.enumerated()), id: \.offset) { _, line in
                businessPlanLineView(line)
            }
        }
        .padding(16)
    }

    @ViewBuilder
    private func businessPlanLineView(_ line: BusinessPlanLine) -> some View {
        switch line.style {
        case .body:
            if !line.text.isEmpty {
                Text(line.text)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(3)
            }
        case .bold:
            Text(line.text)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
                .lineSpacing(3)
        case .bullet:
            HStack(alignment: .top, spacing: 10) {
                Circle()
                    .fill(Theme.accent)
                    .frame(width: 5, height: 5)
                    .padding(.top, 6)
                Text(line.text)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(3)
            }
        case .financial(let label, let value):
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.accent)
            }
            Rectangle()
                .fill(Theme.cardBackgroundLight)
                .frame(height: 0.5)
        case .placeholder:
            Text(line.text)
                .font(.subheadline.italic())
                .foregroundStyle(Theme.accent.opacity(0.6))
                .lineSpacing(3)
        }
    }

    // MARK: - Suggestions

    private func suggestionsSection(_ build: BuildProject) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
                Text("Optimization Tips")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
            }

            ForEach(build.optimizationSuggestions, id: \.self) { suggestion in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.caption2)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)
                    Text(suggestion)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Actions

    private func exportButton(_ build: BuildProject) -> some View {
        Button {
            exportBuildPDF(build)
        } label: {
            Label("Download Current Version", systemImage: "doc.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.accent.opacity(0.12))
                .clipShape(.capsule)
        }
    }

    private func shareProgressButton(_ build: BuildProject) -> some View {
        Button {
            shareBuildProgress(build)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                Text("Share Progress")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Theme.accentBlue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.accentBlue.opacity(0.12))
            .clipShape(.capsule)
        }
    }

    private var dangerZone: some View {
        Button {
            showDeleteConfirm = true
        } label: {
            Text("Remove Build")
                .font(.caption.weight(.medium))
                .foregroundStyle(.red.opacity(0.7))
        }
        .padding(.top, 8)
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Theme.accent)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
        }
    }

    private func detailChip(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .foregroundStyle(Theme.textTertiary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Theme.cardBackgroundLight)
            .clipShape(.capsule)
    }

    private func shareBuildProgress(_ build: BuildProject) {
        let text = "I'm building \(build.businessName) step-by-step with Prooffd — \(build.progressPercentage)% complete!"
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
        appState.markResultShared()
    }

    private func exportBuildPDF(_ build: BuildProject) {
        if let url = PDFExportService.exportBuildPDF(build) {
            PDFExportService.presentShareSheet(items: [url])
        }
    }
}
