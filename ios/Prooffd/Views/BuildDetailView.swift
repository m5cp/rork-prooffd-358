import SwiftUI

struct BuildDetailView: View {
    let buildId: String
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall: Bool = false
    @State private var showDeleteConfirm: Bool = false
    @State private var editingName: Bool = false
    @State private var celebrationStep: String?

    private var build: BuildProject? {
        appState.builds.first { $0.id == buildId }
    }

    var body: some View {
        NavigationStack {
            if let build {
                ScrollView {
                    VStack(spacing: 20) {
                        progressHeader(build)
                        todayStepSection(build)
                        stepsSection(build)
                        businessPlanSection(build)
                        proFeaturesSection(build)
                        suggestionsSection(build)
                        if store.isPremium {
                            exportButton(build)
                        }
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

                Text("Started \(build.startDate.formatted(.dateTime.month().day()))")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
    }

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
                            Text("Mark Complete")
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

                        Text(step.title)
                            .font(.subheadline)
                            .foregroundStyle(step.isCompleted ? Theme.textTertiary : Theme.textSecondary)
                            .strikethrough(step.isCompleted, color: Theme.textTertiary)
                            .multilineTextAlignment(.leading)

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

    private func businessPlanSection(_ build: BuildProject) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
                Text("Business Plan")
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

    private func proFeaturesSection(_ build: BuildProject) -> some View {
        let path = BusinessPathDatabase.allPaths.first { $0.id == build.pathId }

        return VStack(alignment: .leading, spacing: 0) {
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

            VStack(spacing: 0) {
                proFeatureRow(
                    title: "Draft Email",
                    icon: "envelope.fill",
                    description: "Pre-written outreach email",
                    isLocked: !store.isPremium,
                    content: path?.draftEmail
                )
                proFeatureDivider
                proFeatureRow(
                    title: "Draft Text Message",
                    icon: "message.fill",
                    description: "Ready-to-send text template",
                    isLocked: !store.isPremium,
                    content: path?.draftTextMessage
                )
                proFeatureDivider
                proFeatureRow(
                    title: "Sales Intro Script",
                    icon: "person.wave.2.fill",
                    description: "Word-for-word intro script",
                    isLocked: !store.isPremium,
                    content: path?.salesIntroScript
                )
                proFeatureDivider
                proFeatureRow(
                    title: "Follow-Up Script",
                    icon: "arrow.uturn.forward",
                    description: "Follow-up conversation template",
                    isLocked: !store.isPremium,
                    content: path?.followUpScript
                )
                proFeatureDivider
                proFeatureRow(
                    title: "Social Media Post",
                    icon: "square.and.arrow.up.fill",
                    description: "Ready-to-post content",
                    isLocked: !store.isPremium,
                    content: path?.socialMediaPost
                )
                proFeatureDivider
                proFeatureRow(
                    title: "Flyer Copy",
                    icon: "doc.richtext.fill",
                    description: "Print-ready flyer text",
                    isLocked: !store.isPremium,
                    content: path?.flyerCopy
                )
                proFeatureDivider
                proFeatureRow(
                    title: "Offer & Pricing Sheet",
                    icon: "dollarsign.square.fill",
                    description: "Suggested pricing structure",
                    isLocked: !store.isPremium,
                    content: path?.offerPricingSheet
                )
                proFeatureDivider
                proFeatureRow(
                    title: "Full Business Plan",
                    icon: "doc.text.fill",
                    description: "Comprehensive business plan",
                    isLocked: !store.isPremium,
                    content: path?.expandedBusinessPlan
                )
                proFeatureDivider
                proFeatureRow(
                    title: "PDF Export",
                    icon: "arrow.down.doc.fill",
                    description: "Download your build as PDF",
                    isLocked: !store.isPremium,
                    content: nil
                )
            }

            if !store.isPremium {
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

    private func proFeatureRow(title: String, icon: String, description: String, isLocked: Bool, content: String?) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(isLocked ? Theme.textTertiary : Theme.accent)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(isLocked ? Theme.textTertiary : Theme.textPrimary)
                Text(description)
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
            Spacer()
            if isLocked {
                Image(systemName: "lock.fill")
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

    private var proFeatureDivider: some View {
        Rectangle()
            .fill(Theme.cardBackgroundLight)
            .frame(height: 0.5)
            .padding(.leading, 52)
    }

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

    private func exportBuildPDF(_ build: BuildProject) {
        let content = BuildPDFContent(build: build)
        let renderer = ImageRenderer(content: content)
        renderer.scale = 2.0
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(build.businessName) - Build Plan.pdf")
        renderer.render { size, context in
            var box = CGRect(origin: .zero, size: .init(width: size.width, height: size.height))
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            var topController = root
            while let presented = topController.presentedViewController { topController = presented }
            activityVC.popoverPresentationController?.sourceView = topController.view
            topController.present(activityVC, animated: true)
        }
    }
}

struct BuildPDFContent: View {
    let build: BuildProject

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(build.businessName)
                .font(.title.bold())
            Text("Progress: \(build.progressPercentage)% complete")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Divider()
            Text("Steps")
                .font(.headline)
            ForEach(Array(build.steps.enumerated()), id: \.offset) { index, step in
                Text("\(step.isCompleted ? "✓" : "○") \(index + 1). \(step.title)")
                    .font(.body)
            }
            if !build.pricingNotes.isEmpty {
                Divider()
                Text("Pricing").font(.headline)
                Text(build.pricingNotes).font(.body).foregroundStyle(.secondary)
            }
            if !build.serviceNotes.isEmpty {
                Text("Services").font(.headline)
                Text(build.serviceNotes).font(.body).foregroundStyle(.secondary)
            }
            if !build.strategyNotes.isEmpty {
                Text("Strategy").font(.headline)
                Text(build.strategyNotes).font(.body).foregroundStyle(.secondary)
            }
        }
        .padding(40)
        .frame(width: 612)
        .background(.white)
    }
}
