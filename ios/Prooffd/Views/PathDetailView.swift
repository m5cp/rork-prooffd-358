import SwiftUI

struct PathDetailView: View {
    let result: MatchResult
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var showBuildAdded: Bool = false

    private var path: BusinessPath { result.businessPath }
    private var alreadyBuilding: Bool { appState.hasBuild(for: path.id) }
    private var track: CareerTrack { SmartCareerBrain.careerTrack(for: path) }
    private var linkedEducation: EducationPath? {
        guard !path.linkedEducationPathId.isEmpty else { return nil }
        return EducationPathDatabase.all.first { $0.id == path.linkedEducationPathId }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    heroSection
                    trackBadge
                    quickStats
                    favHideBar
                    startBuildSection
                    overviewSection
                    degreeRequirementSection

                    switch track {
                    case .startBusiness:
                        businessTrackContent
                    case .tradeAndCertification:
                        tradeTrackContent
                    case .degreeBasedCareer:
                        degreeTrackContent
                    }

                    actionButtons

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
            .sheet(isPresented: $showShareSheet) {
                ShareCardPresenterSheet(content: .topMatch(from: result))
            }
            .confirmationDialog("Added to My Plan!", isPresented: $showBuildAdded, titleVisibility: .visible) {
                Button("Go Now") {
                    appState.selectedTab = 1
                    dismiss()
                }
                Button("Stay on Page", role: .cancel) { }
            } message: {
                Text("\(path.name) has been added to your plan.")
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    private var catColor: Color {
        Theme.categoryColor(for: path.category)
    }

    private var favHideBar: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    appState.toggleFavorite(path.id)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: appState.isFavorite(path.id) ? "heart.fill" : "heart")
                        .font(.caption)
                    Text(appState.isFavorite(path.id) ? "Favorited" : "Favorite")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(appState.isFavorite(path.id) ? .pink : Theme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(appState.isFavorite(path.id) ? Color.pink.opacity(0.1) : Theme.cardBackground)
                .clipShape(.capsule)
            }
            .accessibilityLabel(appState.isFavorite(path.id) ? "Remove from favorites" : "Add to favorites")
            .sensoryFeedback(.selection, trigger: appState.isFavorite(path.id))

            Button {
                withAnimation(.spring(duration: 0.3)) {
                    appState.toggleHiddenPath(path.id)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: appState.isPathHidden(path.id) ? "eye.fill" : "eye.slash")
                        .font(.caption)
                    Text(appState.isPathHidden(path.id) ? "Unhide" : "Hide")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Theme.cardBackground)
                .clipShape(.capsule)
            }
            .accessibilityLabel(appState.isPathHidden(path.id) ? "Show this path in results" : "Hide this path from results")

            Button {
                QuickShareHelper.shareBusiness(path.name)
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
            .accessibilityLabel("Share \(path.name)")

            Spacer()
        }
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(catColor.opacity(0.12))
                    .frame(width: 80, height: 80)
                Image(systemName: path.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(catColor)
            }
            .padding(.top, 8)
            .accessibilityHidden(true)

            Text(path.name)
                .font(.title.bold())
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)

            HStack(spacing: 6) {
                Image(systemName: path.category.icon)
                    .font(.caption2)
                Text(path.category.rawValue)
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(catColor.opacity(0.8))
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(catColor.opacity(0.1))
            .clipShape(.capsule)

            aiProofDisplay
        }
    }

    private var aiProofDisplay: some View {
        let zone = path.zone
        let color: Color = zone == .safe ? Theme.accent : zone == .human ? Color(hex: "FBBF24") : .orange
        return HStack(spacing: 6) {
            Image(systemName: zone.icon)
                .font(.caption)
            Text(zone.label)
                .font(.subheadline.weight(.semibold))
            Text("\(path.aiProofRating)/100")
                .font(.subheadline.weight(.bold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(color.opacity(0.12))
        .clipShape(.capsule)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("AI Proof rating \(path.aiProofRating) out of 100, \(zone.label)")
    }

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var quickStats: some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(spacing: 12) {
                    statItem(icon: "dollarsign.circle.fill", title: "Startup", value: path.startupCostRange)
                    statItem(icon: "clock.fill", title: "First $", value: path.timeToFirstDollar)
                    statItem(icon: "shield.checkered", title: "AI-Proof", value: "\(path.aiProofRating)/100")
                }
            } else {
                HStack(spacing: 0) {
                    statItem(icon: "dollarsign.circle.fill", title: "Startup", value: path.startupCostRange)
                    divider
                    statItem(icon: "clock.fill", title: "First $", value: path.timeToFirstDollar)
                    divider
                    statItem(icon: "shield.checkered", title: "AI-Proof", value: "\(path.aiProofRating)/100")
                }
            }
        }
        .padding(.vertical, 16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var divider: some View {
        Rectangle()
            .fill(Theme.cardBackgroundLight)
            .frame(width: 1, height: 40)
    }

    private func statItem(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Theme.accent)
                .accessibilityHidden(true)
            Text(title)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
            Text(value)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title): \(value)")
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Overview", icon: "text.alignleft")
            Text(path.overview)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)

            HStack(spacing: 8) {
                detailChip("Customer: \(path.customerType)")
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var degreeRequirementSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Education & Training", icon: "graduationcap.fill")

            Text(SmartCareerBrain.educationText(for: path))
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)

            if let notice = SmartCareerBrain.regulatoryNotice(for: path) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                        .padding(.top, 2)
                    Text(notice)
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                        .lineSpacing(2)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var actionPlanSection: some View {
        let smartSteps = SmartCareerBrain.smartActionPlan(for: path)

        return VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Step-by-Step Action Plan", icon: "list.number")

            ForEach(Array(smartSteps.enumerated()), id: \.offset) { index, step in
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

    private var pricingSection: some View {
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

    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Draft Email", icon: "envelope.fill")
            let parts = path.draftEmail.strippingEmoji.components(separatedBy: "\n").filter { !$0.isEmpty }
            ForEach(Array(parts.enumerated()), id: \.offset) { index, line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.lowercased().hasPrefix("subject:") {
                    HStack(spacing: 0) {
                        Text("Subject: ")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                        Text(trimmed.replacingOccurrences(of: "Subject: ", with: ""))
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.accent)
                    }
                    Rectangle()
                        .fill(Theme.cardBackgroundLight)
                        .frame(height: 1)
                } else if trimmed.hasPrefix("Best,") || trimmed == "[Your Name]" {
                    Text(trimmed)
                        .font(.subheadline.italic())
                        .foregroundStyle(Theme.textTertiary)
                } else {
                    Text(trimmed)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(3)
                }
            }
        }
        .textSelection(.enabled)
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var textMessageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Draft Text Message", icon: "message.fill")
            HStack(alignment: .top, spacing: 0) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Theme.accentBlue)
                    .frame(width: 3)
                Text(path.draftTextMessage.strippingEmoji)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(3)
                    .padding(.leading, 10)
            }
        }
        .textSelection(.enabled)
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func scriptSection(title: String, icon: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title, icon: icon)
            Text("\"\(content.strippingEmoji)\"")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)
                .italic()
        }
        .textSelection(.enabled)
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var socialMediaMainText: String {
        let cleaned = path.socialMediaPost.strippingEmoji
        if let hashIndex = cleaned.firstIndex(of: "#") {
            return String(cleaned[cleaned.startIndex..<hashIndex]).trimmingCharacters(in: .whitespaces)
        }
        return cleaned
    }

    private var socialMediaHashtags: String {
        let cleaned = path.socialMediaPost.strippingEmoji
        if let hashIndex = cleaned.firstIndex(of: "#") {
            return String(cleaned[hashIndex...])
        }
        return ""
    }

    private var socialMediaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Social Media Post", icon: "square.and.arrow.up.fill")
            Text(socialMediaMainText)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)
            if !socialMediaHashtags.isEmpty {
                Text(socialMediaHashtags)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Theme.accentBlue)
            }
        }
        .textSelection(.enabled)
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var pricingSheetSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader("Offer & Pricing Sheet", icon: "dollarsign.square.fill")
            let lines = path.offerPricingSheet.strippingEmoji.components(separatedBy: "\n").filter { !$0.isEmpty }
            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed == trimmed.uppercased() && trimmed.count > 3 {
                    Text(trimmed)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                        .tracking(0.5)
                } else if trimmed.contains(":") {
                    let parts = trimmed.split(separator: ":", maxSplits: 1)
                    if parts.count == 2 {
                        HStack {
                            Text(String(parts[0]))
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                            Spacer()
                            Text(String(parts[1]).trimmingCharacters(in: .whitespaces))
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.accent)
                        }
                        Rectangle()
                            .fill(Theme.cardBackgroundLight)
                            .frame(height: 0.5)
                    } else {
                        Text(trimmed)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                } else {
                    Text(trimmed)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .textSelection(.enabled)
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var businessPlanSection: some View {
        let sections = BusinessPlanGenerator.generate(for: path)

        return VStack(alignment: .leading, spacing: 0) {
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

    private var whatOthersChargeSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader("What Others Charge", icon: "tag.fill")

            Text("Typical market rates for \(path.name.lowercased()) services in this category:")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .lineSpacing(3)

            let pricingLines = parsePricingLines(path.starterPricing)
            ForEach(Array(pricingLines.enumerated()), id: \.offset) { _, line in
                HStack(alignment: .top) {
                    Circle()
                        .fill(Theme.accent)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(line)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(3)
                }
            }

            Rectangle()
                .fill(Theme.cardBackgroundLight)
                .frame(height: 0.5)

            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption2)
                    .foregroundStyle(.orange)
                Text("Prices vary by location, experience, and market demand. These are general ranges based on industry data, not guarantees of income.")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func parsePricingLines(_ text: String) -> [String] {
        let lines = text.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        if lines.count > 1 {
            return lines
        }
        return [text]
    }

    private var lockedProContentSection: some View {
        VStack(spacing: 0) {
            VStack(spacing: 2) {
                Image(systemName: "crown.fill")
                    .font(.title2)
                    .foregroundStyle(Theme.accent)
                HStack(spacing: 4) {
                    Text("Pro Templates & Scripts")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                }
                Text("Unlock ready-to-use business materials")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.top, 16)
            .padding(.bottom, 12)

            VStack(spacing: 0) {
                lockedRow(title: "Draft Email", icon: "envelope.fill", description: "Pre-written outreach email")
                lockedDivider
                lockedRow(title: "Draft Text Message", icon: "message.fill", description: "Ready-to-send text template")
                lockedDivider
                lockedRow(title: "Sales Intro Script", icon: "person.wave.2.fill", description: "Word-for-word intro script")
                lockedDivider
                lockedRow(title: "Social Media Post", icon: "square.and.arrow.up.fill", description: "Ready-to-post content")
                lockedDivider
                lockedRow(title: "Offer & Pricing Sheet", icon: "dollarsign.square.fill", description: "Suggested pricing structure")
                lockedDivider
                lockedRow(title: "One-Page Business Plan", icon: "doc.text.fill", description: "Investor-ready business plan")
            }

            Button {
                showPaywall = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "lock.open.fill")
                    Text("Unlock All with Pro")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.accent)
                .clipShape(.capsule)
            }
            .padding(16)
        }
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
        )
    }

    private func lockedRow(title: String, icon: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Theme.accent.opacity(0.5))
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
            Image(systemName: "lock.fill")
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var lockedDivider: some View {
        Rectangle()
            .fill(Theme.cardBackgroundLight)
            .frame(height: 0.5)
            .padding(.leading, 52)
    }

    private var startBuildSection: some View {
        VStack(spacing: 12) {
            if alreadyBuilding {
                Button {
                    appState.selectedTab = 1
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "hammer.fill")
                        Text("Go to My Plan")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.accent)
                    .clipShape(.capsule)
                }
                .accessibilityLabel("Go to build for \(path.name)")
            } else {
                Button {
                    appState.addBuild(from: path)
                    showBuildAdded = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "hammer.fill")
                            .accessibilityHidden(true)
                        Text("Add to My Plan")
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
                    .clipShape(.capsule)
                }
                .accessibilityLabel("Add \(path.name) to your builds")
                .sensoryFeedback(.impact(weight: .medium), trigger: showBuildAdded)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                showShareSheet = true
            } label: {
                Label("Share Match Card", systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.accentBlue)
                    .clipShape(.capsule)
            }
            .accessibilityLabel("Share match card for \(path.name)")
            .accessibilityHint("Creates a shareable image card")

            if store.isPremium {
                Button {
                    exportPDF()
                } label: {
                    Label("Export as PDF", systemImage: "doc.fill")
                        .font(.headline)
                        .foregroundStyle(Theme.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.accent.opacity(0.12))
                        .clipShape(.capsule)
                }
                .accessibilityLabel("Export \(path.name) details as PDF")
            }
        }
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Theme.accent)
                .accessibilityHidden(true)
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

    private func exportPDF() {
        if let url = PDFExportService.exportPathPDF(result) {
            PDFExportService.presentShareSheet(items: [url])
        }
    }

    // MARK: - Track Badge

    private var trackBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: track.icon)
                .font(.caption2)
            Text(track.rawValue)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(trackColor)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(trackColor.opacity(0.1))
        .clipShape(.capsule)
    }

    private var trackColor: Color {
        switch track {
        case .startBusiness: return Theme.accent
        case .tradeAndCertification: return Color(hex: "FBBF24")
        case .degreeBasedCareer: return Theme.accentBlue
        }
    }

    // MARK: - Start a Business Track

    private var startupContent: BusinessStartupContent {
        BusinessStartupContentBuilder.build(for: path)
    }

    @ViewBuilder
    private var businessTrackContent: some View {
        actionPlanSection

        if store.isPremium {
            whatYouNeedToStartSection
            startupCostBreakdownSection
            typicalPricingSection

            let content = startupContent
            if !content.licensesAndPermits.isEmpty {
                licensesPermitsSection(content.licensesAndPermits)
            }
            if !content.toolsAndEquipment.isEmpty {
                toolsEquipmentSection(content.toolsAndEquipment)
            }

            launchRoadmapDisplaySection
            marketingAcquisitionSection
            bookkeepingTaxSection
            emailSection
            textMessageSection
            scriptSection(title: "Sales Intro Script", icon: "person.wave.2.fill", content: path.salesIntroScript)
            socialMediaSection
            pricingSheetSection
            businessPlanSection
        } else {
            businessProUpgradePrompt
        }
    }

    private var businessProUpgradePrompt: some View {
        ProUpgradePromptView(
            title: "Unlock Your Full Business Plan",
            subtitle: "Get everything you need to launch and grow this business.",
            features: [
                "Startup cost breakdown & checklist",
                "Pricing tiers & revenue projections",
                "Licenses, permits & tools needed",
                "30-60-90 day launch roadmap",
                "Marketing & customer acquisition plan",
                "Email, text & sales scripts",
                "One-page business plan & PDF export"
            ],
            onUpgrade: { showPaywall = true }
        )
    }

    // MARK: - Business Track Sections

    private var whatYouNeedToStartSection: some View {
        let content = startupContent
        return VStack(alignment: .leading, spacing: 14) {
            sectionHeader("What You Need to Start", icon: "checklist")

            Text("Complete these essentials to launch your \(path.name) business.")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .lineSpacing(3)

            if !content.pathSpecificChecklist.isEmpty {
                Text("Business-Specific")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                    .padding(.top, 4)

                ForEach(content.pathSpecificChecklist) { item in
                    checklistRow(item)
                }

                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
            }

            Text("Universal Startup Checklist")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.textSecondary)
                .padding(.top, content.pathSpecificChecklist.isEmpty ? 0 : 4)

            ForEach(content.universalChecklist) { item in
                checklistRow(item)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func checklistRow(_ item: StartupChecklistItem) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: item.icon)
                .font(.caption)
                .foregroundStyle(item.isUniversal ? Theme.textTertiary : Theme.accent)
                .frame(width: 20)
                .padding(.top, 1)
            Text(item.title)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(2)
        }
    }

    private var startupCostBreakdownSection: some View {
        let planData = BusinessPlanDatabase.lookup(path.id)

        return VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Startup Cost Breakdown", icon: "cart.fill")

            HStack {
                Text("Total Range")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
                Text(path.startupCostRange)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.accent)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Theme.accent.opacity(0.08))
            .clipShape(.rect(cornerRadius: 10))

            if let data = planData, !data.startupCostItemsEssential.isEmpty {
                Text("Essential Items")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .padding(.top, 4)

                ForEach(Array(data.startupCostItemsEssential.enumerated()), id: \.offset) { _, item in
                    HStack {
                        Text(item.0)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                        Spacer()
                        Text(item.1)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.accent)
                    }
                    Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                }
            }

            if let data = planData, !data.startupCostItemsOptional.isEmpty {
                Text("Optional Items")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textTertiary)
                    .padding(.top, 4)

                ForEach(Array(data.startupCostItemsOptional.enumerated()), id: \.offset) { _, item in
                    HStack {
                        Text(item.0)
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                        Spacer()
                        Text(item.1)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var typicalPricingSection: some View {
        let tiers = startupContent.pricingTiers

        return VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Typical Pricing & Revenue", icon: "tag.fill")

            Text("What you can expect to earn at different stages:")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .lineSpacing(3)

            ForEach(Array(tiers.enumerated()), id: \.offset) { index, tier in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(tier.label)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(tierColor(index: index))
                            .clipShape(.capsule)

                        Spacer()
                    }

                    Text(tier.range)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)

                    Text(tier.description)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(12)
                .background(tierColor(index: index).opacity(0.06))
                .clipShape(.rect(cornerRadius: 10))
            }

            let planData = BusinessPlanDatabase.lookup(path.id)
            if let data = planData, !data.pricingNotes.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.caption2)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)
                    Text(data.pricingNotes)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .lineSpacing(3)
                }
            }

            if let data = planData, !data.upsells.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Upsell & Package Ideas")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(data.upsells, id: \.self) { upsell in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "plus.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.accent)
                            .padding(.top, 2)
                        Text(upsell)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }

            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption2)
                    .foregroundStyle(.orange)
                Text("All figures are general ranges, not income guarantees. Varies by location, experience, and market.")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
                    .lineSpacing(2)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func tierColor(index: Int) -> Color {
        switch index {
        case 0: return Theme.accent
        case 1: return Theme.accentBlue
        default: return Color(hex: "34D399")
        }
    }

    private func licensesPermitsSection(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Licenses & Permits", icon: "checkmark.seal.fill")
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 1)
                    Text(item)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption2)
                    .foregroundStyle(.orange)
                Text("Requirements vary by state and locality. Always verify with your local government.")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
                    .lineSpacing(2)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func toolsEquipmentSection(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Tools & Equipment", icon: "wrench.and.screwdriver.fill")
            ForEach(Array(items.prefix(12).enumerated()), id: \.offset) { _, item in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Theme.accent)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(item)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            if items.count > 12 {
                Text("+ \(items.count - 12) more items listed in the full business plan")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var launchRoadmapDisplaySection: some View {
        let planData = BusinessPlanDatabase.lookup(path.id)

        return Group {
            if let data = planData, !data.launchSteps30Days.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("30-60-90 Day Launch Plan", icon: "flag.checkered")

                    launchPhase(title: "Days 1–30", steps: data.launchSteps30Days, color: Theme.accent)

                    if !data.launchSteps60Days.isEmpty {
                        Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                        launchPhase(title: "Days 31–60", steps: data.launchSteps60Days, color: Theme.accentBlue)
                    }

                    if !data.launchSteps90Days.isEmpty {
                        Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                        launchPhase(title: "Days 61–90", steps: data.launchSteps90Days, color: Color(hex: "34D399"))
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private func launchPhase(title: String, steps: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(color)
            ForEach(Array(steps.enumerated()), id: \.offset) { _, step in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(color)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(step)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(2)
                }
            }
        }
    }

    private var marketingAcquisitionSection: some View {
        let content = startupContent

        return VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Marketing & Customer Acquisition", icon: "megaphone.fill")

            if !content.marketingChannels.isEmpty {
                Text("Marketing Channels")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(content.marketingChannels, id: \.self) { channel in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(Theme.accent)
                            .frame(width: 5, height: 5)
                            .padding(.top, 6)
                        Text(channel)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }

            let planData = BusinessPlanDatabase.lookup(path.id)
            if let data = planData, !data.acquisitionStrategies.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Customer Acquisition")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(data.acquisitionStrategies, id: \.self) { strategy in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.accentBlue)
                            .padding(.top, 2)
                        Text(strategy)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }

            if let data = planData, !data.referralStrategies.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Referral Strategies")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(data.referralStrategies, id: \.self) { strategy in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "person.2.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.accent)
                            .padding(.top, 2)
                        Text(strategy)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var bookkeepingTaxSection: some View {
        let items = startupContent.bookkeepingBasics

        return VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Bookkeeping, Tax & Business Setup", icon: "chart.bar.doc.horizontal.fill")

            Text("Financial basics every new business owner should set up:")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .lineSpacing(3)

            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Theme.accent)
                        .frame(width: 16)
                        .padding(.top, 2)
                    Text(item)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(2)
                }
            }

            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.caption2)
                    .foregroundStyle(Theme.accentBlue)
                    .padding(.top, 2)
                Text("Consider consulting a tax professional or CPA familiar with small businesses in your state.")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Trade & Certification Track

    private var tradeDetailData: TradeCareerDetailData? {
        if let data = TradeCareerDatabase.lookup(path.id) { return data }
        if let edu = linkedEducation, let data = TradeCareerDatabase.lookupByEducationId(edu.id) { return data }
        return nil
    }

    @ViewBuilder
    private var tradeTrackContent: some View {
        if let edu = linkedEducation {
            tradeTrainingRoadmap(edu)
        }

        tradeTimeToEntrySection

        if store.isPremium {
            tradeTuitionCostSection

            if let edu = linkedEducation {
                tradeCertRequirements(edu)
            }

            tradeToolsExamLicensingSection
            tradePaySection
            tradeAIResistantSection
            tradeFirstJobStrategySection

            if let edu = linkedEducation {
                tradeFundingSection(edu)
                tradeFindProgramsSection(edu)
            }

            actionPlanSection

            tradeFutureBusinessSection

            let setupSteps = SmartCareerBrain.businessSetupSteps(for: path)
            if !setupSteps.isEmpty {
                businessSetupSection(setupSteps)
            }

            whatOthersChargeSection
            pricingSection
            emailSection
            textMessageSection
            scriptSection(title: "Sales Intro Script", icon: "person.wave.2.fill", content: path.salesIntroScript)
            socialMediaSection
            pricingSheetSection
        } else {
            tradeProUpgradePrompt
        }
    }

    private var tradeProUpgradePrompt: some View {
        ProUpgradePromptView(
            title: "Unlock Full Trade Career Details",
            subtitle: "Get the complete roadmap for this career path.",
            features: [
                "Tuition & training cost breakdown",
                "Certification & licensing requirements",
                "Pay ranges: entry to self-employment",
                "Why this career is AI-resistant",
                "First job strategy & action plan",
                "Funding options & program finder",
                "Future business opportunity"
            ],
            onUpgrade: { showPaywall = true }
        )
    }

    // MARK: - Trade Detail Sections (Phase 3)

    private var tradeTimeToEntrySection: some View {
        let data = tradeDetailData
        let edu = linkedEducation
        let timeValue = data?.timeToEntry ?? edu?.timeToComplete ?? ""
        let detail = data?.timeToEntryDetail ?? ""

        return Group {
            if !timeValue.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Time to Entry", icon: "clock.badge.checkmark.fill")

                    HStack(spacing: 10) {
                        Text(timeValue)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(trackColor)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(trackColor.opacity(0.08))
                    .clipShape(.rect(cornerRadius: 10))

                    if !detail.isEmpty {
                        Text(detail)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(4)
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private var tradeTuitionCostSection: some View {
        let data = tradeDetailData
        let edu = linkedEducation
        let cost = data?.tuitionCostRange ?? edu?.costRange ?? ""

        return Group {
            if !cost.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    sectionHeader("Tuition & Training Cost", icon: "banknote.fill")

                    HStack {
                        Text("Estimated Range")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                        Spacer()
                        Text(cost)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.accent)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Theme.accent.opacity(0.08))
                    .clipShape(.rect(cornerRadius: 10))

                    if let edu {
                        if !edu.fundingOptions.isEmpty {
                            Text("Financial assistance may be available — see Funding Options below.")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                                .lineSpacing(3)
                        }
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private var tradeToolsExamLicensingSection: some View {
        let data = tradeDetailData

        return Group {
            if let data, (!data.toolsAndExamRequirements.isEmpty || !data.licensingRequirements.isEmpty) {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Tools, Exams & Licensing", icon: "wrench.and.screwdriver.fill")

                    if !data.toolsAndExamRequirements.isEmpty {
                        Text("Tools & Exam Requirements")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                        ForEach(Array(data.toolsAndExamRequirements.enumerated()), id: \.offset) { _, item in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(trackColor)
                                    .padding(.top, 1)
                                Text(item)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                    }

                    if !data.licensingRequirements.isEmpty {
                        if !data.toolsAndExamRequirements.isEmpty {
                            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                        }
                        Text("Licensing Requirements")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                        ForEach(Array(data.licensingRequirements.enumerated()), id: \.offset) { _, item in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                                    .padding(.top, 1)
                                Text(item)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text("Requirements vary by state and locality. Always verify with your local licensing authority.")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                            .lineSpacing(2)
                    }
                    .padding(.top, 4)
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private var tradePaySection: some View {
        let data = tradeDetailData
        let edu = linkedEducation

        return Group {
            if data != nil || edu != nil {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Pay & Earning Potential", icon: "dollarsign.circle.fill")

                    if let data {
                        tradePayRow(label: "Entry-Level", value: data.entryLevelPay, color: Theme.accent)
                        tradePayRow(label: "Mid-Career", value: data.midCareerPay, color: Theme.accentBlue)
                        if !data.selfEmploymentUpside.isEmpty {
                            tradePayRow(label: "Self-Employment", value: data.selfEmploymentUpside, color: Color(hex: "34D399"))
                        }
                    } else if let edu {
                        tradePayRow(label: "Typical Range", value: edu.typicalSalaryRange, color: Theme.accent)
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text("Pay varies by location, experience, employer, and specialization. These are general ranges, not guarantees.")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                            .lineSpacing(2)
                    }
                    .padding(.top, 4)
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private func tradePayRow(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(color)
                .clipShape(.capsule)
            Text(value)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
    }

    private var tradeAIResistantSection: some View {
        let data = tradeDetailData

        return Group {
            if let data, !data.aiResistantReasons.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "shield.checkered")
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                        Text("Why This Is AI-Resistant")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        Text("\(path.aiProofRating)/100")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(aiScoreColor)
                            .clipShape(.capsule)
                    }

                    Text("This career scored \(path.aiProofRating)/100 on our AI-Proof scale because:")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .lineSpacing(3)

                    ForEach(Array(data.aiResistantReasons.enumerated()), id: \.offset) { _, reason in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.caption2)
                                .foregroundStyle(Theme.accent)
                                .padding(.top, 2)
                            Text(reason)
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                                .lineSpacing(3)
                        }
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.accent.opacity(0.15), lineWidth: 1)
                )
            }
        }
    }

    private var aiScoreColor: Color {
        if path.aiProofRating >= 85 { return Color(hex: "34D399") }
        if path.aiProofRating >= 70 { return Theme.accentBlue }
        if path.aiProofRating >= 55 { return Color(hex: "FBBF24") }
        return Color(hex: "F87171")
    }

    private var tradeFirstJobStrategySection: some View {
        let data = tradeDetailData

        return Group {
            if let data, !data.firstJobStrategies.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("First Job Strategy", icon: "figure.walk.arrival")

                    ForEach(Array(data.firstJobStrategies.enumerated()), id: \.offset) { index, strategy in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 22, height: 22)
                                .background(trackColor)
                                .clipShape(Circle())
                            Text(strategy)
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

    private var tradeFutureBusinessSection: some View {
        let data = tradeDetailData

        return Group {
            if let data, !data.futureBusinessOption.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "briefcase.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                        Text("Future Business Option")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                    }

                    Text(data.futureBusinessOption)
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

    // MARK: - Degree-Based Career Track

    private var degreeDetailData: DegreeCareerDetailData? {
        if let data = DegreeCareerDatabase.lookup(path.id) { return data }
        if let edu = linkedEducation, let data = DegreeCareerDatabase.lookupByEducationId(edu.id) { return data }
        return nil
    }

    private var degreeRecord: DegreeCareerRecord? {
        DegreeCareerDatabase.record(for: path.id)
    }

    @ViewBuilder
    private var degreeTrackContent: some View {
        degreeHeaderSummarySection

        if degreeDetailData != nil || linkedEducation != nil {
            degreeDegreeRequiredSection
            degreeTimelineSection

            if store.isPremium {
                degreePrerequisitesSection
                degreeLicensingExamSection
                degreeSalaryRangeSection
                degreeAIResistantSection
                degreeClinicalSection
                degreeDemandStabilitySection
                degreeBestFitSection

                if let edu = linkedEducation {
                    degreeFundingSection(edu)
                    degreeFindProgramsSection(edu)
                }
            } else {
                degreeProUpgradePrompt
            }
        } else {
            degreeFallbackSection
        }
    }

    private var degreeProUpgradePrompt: some View {
        ProUpgradePromptView(
            title: "Unlock Full Career Pathway",
            subtitle: "Get the complete education and career roadmap.",
            features: [
                "Prerequisites & admissions prep",
                "Licensing & exam path details",
                "Salary range: early to established",
                "Why this career is AI-resistant",
                "Clinical / residency requirements",
                "Demand & long-term stability",
                "Best fit summary & funding options"
            ],
            onUpgrade: { showPaywall = true }
        )
    }

    // MARK: - Trade Track Sections

    private func tradeTrainingRoadmap(_ edu: EducationPath) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Training & Certification Roadmap", icon: "map.fill")

            HStack(spacing: 16) {
                roadmapStat(icon: "clock.fill", label: "Duration", value: edu.timeToComplete)
                roadmapStat(icon: "banknote.fill", label: "Cost", value: edu.costRange)
            }

            if !edu.deliveryType.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "building.2.fill")
                        .font(.caption2)
                        .foregroundStyle(Theme.accent)
                    Text("Format: \(edu.deliveryType)")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
            }

            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

            Text(edu.overview)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)

            if !edu.whyItWorksNow.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.caption2)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)
                    Text(edu.whyItWorksNow)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .lineSpacing(3)
                }
            }

            if !edu.futureDemand.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "arrow.up.right")
                        .font(.caption2)
                        .foregroundStyle(Theme.accentBlue)
                        .padding(.top, 2)
                    Text(edu.futureDemand)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .lineSpacing(3)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func tradeCertRequirements(_ edu: EducationPath) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Certification & Licensing", icon: "checkmark.seal.fill")

            if !edu.testRequirements.isEmpty {
                ForEach(edu.testRequirements, id: \.self) { req in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                            .padding(.top, 1)
                        Text(req)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }

            if !edu.prerequisites.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Prerequisites")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(edu.prerequisites, id: \.self) { prereq in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(Theme.accent)
                            .frame(width: 5, height: 5)
                            .padding(.top, 6)
                        Text(prereq)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }

            if !edu.basicSteps.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Steps to Complete")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(Array(edu.basicSteps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(Theme.accent)
                            .clipShape(Circle())
                        Text(step)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(2)
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func tradeFundingSection(_ edu: EducationPath) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Funding Options", icon: "banknote.fill")
            ForEach(edu.fundingOptions, id: \.self) { option in
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

            if !edu.militaryPath.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "shield.fill")
                        .font(.caption2)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)
                    Text(edu.militaryPath)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(3)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func tradeFindProgramsSection(_ edu: EducationPath) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("How to Find Programs", icon: "magnifyingglass")
            ForEach(edu.howToFindPrograms, id: \.self) { item in
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

            if !edu.employerSponsoredOptions.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Employer-Sponsored Options")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                ForEach(edu.employerSponsoredOptions, id: \.self) { option in
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
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Degree Header & Fallback

    private var degreeHeaderSummarySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let record = degreeRecord {
                HStack(spacing: 8) {
                    Image(systemName: record.aiProofTier.icon)
                        .font(.caption)
                    Text(record.aiProofTier.label)
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(degreeTierColor(record.aiProofTier))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(degreeTierColor(record.aiProofTier).opacity(0.1))
                .clipShape(.capsule)

                HStack(spacing: 6) {
                    Image(systemName: record.category.icon)
                        .font(.caption2)
                    Text(record.category.rawValue)
                        .font(.caption.weight(.medium))
                }
                .foregroundStyle(Theme.textSecondary)

                if !record.trainingPath.isEmpty {
                    Text(record.trainingPath)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(4)
                }
            } else {
                HStack(spacing: 6) {
                    Image(systemName: "graduationcap.fill")
                        .font(.caption2)
                    Text("Degree-Based Career")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(Theme.accentBlue)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func degreeTierColor(_ tier: AIProofTier) -> Color {
        switch tier {
        case .tier1: return Color(hex: "34D399")
        case .tier2: return Theme.accentBlue
        case .tier3: return Color(hex: "FBBF24")
        }
    }

    private var degreeFallbackSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 32))
                .foregroundStyle(Theme.accentBlue.opacity(0.5))

            Text("Detailed Education Pathway")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)

            Text("The structured career pathway for this degree-based career is still being completed. Check back soon for full details on degree requirements, licensing, salary, and more.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            if let record = degreeRecord {
                VStack(alignment: .leading, spacing: 10) {
                    degreePayRow(label: "Early Career", value: record.salaryEarly, color: Theme.accent)
                    degreePayRow(label: "Experienced", value: record.salaryExperienced, color: Theme.accentBlue)
                }
            }
        }
        .padding(24)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Degree Detail Sections (Phase 4)

    private var degreeDegreeRequiredSection: some View {
        let data = degreeDetailData
        let edu = linkedEducation

        return Group {
            if data != nil || edu != nil {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Degree Required", icon: "graduationcap.fill")

                    if let data {
                        Text(data.degreeRequired)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                            .lineSpacing(3)

                        if !data.degreeDetail.isEmpty {
                            Text(data.degreeDetail)
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                                .lineSpacing(4)
                        }
                    } else if let edu {
                        Text(edu.deliveryType)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)

                        Text(edu.overview)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(4)
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private var degreeTimelineSection: some View {
        let data = degreeDetailData
        let edu = linkedEducation
        let timeline = data?.educationTimeline ?? edu?.timeToComplete ?? ""
        let detail = data?.timelineDetail ?? ""

        return Group {
            if !timeline.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Typical Education Timeline", icon: "calendar.badge.clock")

                    HStack(spacing: 10) {
                        Text(timeline)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Theme.accentBlue)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Theme.accentBlue.opacity(0.08))
                    .clipShape(.rect(cornerRadius: 10))

                    if !detail.isEmpty {
                        Text(detail)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(4)
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private var degreePrerequisitesSection: some View {
        let data = degreeDetailData
        let edu = linkedEducation
        let prereqs = data?.prerequisites ?? edu?.prerequisites ?? []

        return Group {
            if !prereqs.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Prerequisites & Admissions Prep", icon: "list.clipboard.fill")

                    ForEach(Array(prereqs.enumerated()), id: \.offset) { _, prereq in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.accentBlue)
                                .padding(.top, 1)
                            Text(prereq)
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

    private var degreeLicensingExamSection: some View {
        let data = degreeDetailData
        let edu = linkedEducation
        let exams = data?.licensingExamPath ?? edu?.testRequirements ?? []

        return Group {
            if !exams.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Licensing & Exam Path", icon: "checkmark.seal.fill")

                    ForEach(Array(exams.enumerated()), id: \.offset) { index, exam in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 22, height: 22)
                                .background(Theme.accentBlue)
                                .clipShape(Circle())
                            Text(exam)
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                                .lineSpacing(2)
                        }
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text("Licensing requirements vary by state. Always verify with your state's licensing board.")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                            .lineSpacing(2)
                    }
                    .padding(.top, 4)
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private var degreeClinicalSection: some View {
        let data = degreeDetailData
        let reqs = data?.clinicalRequirements ?? []

        return Group {
            if !reqs.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Clinical / Internship / Supervised Practice", icon: "stethoscope")

                    ForEach(Array(reqs.enumerated()), id: \.offset) { _, req in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "person.badge.clock.fill")
                                .font(.caption2)
                                .foregroundStyle(Theme.accentBlue)
                                .padding(.top, 2)
                            Text(req)
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                                .lineSpacing(3)
                        }
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private var degreeSalaryRangeSection: some View {
        let data = degreeDetailData
        let edu = linkedEducation

        return Group {
            if data != nil || edu != nil {
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("Salary Range", icon: "dollarsign.circle.fill")

                    if let data {
                        degreePayRow(label: "Early Career", value: data.earlyCareerPay, color: Theme.accent)
                        degreePayRow(label: "Established Career", value: data.establishedCareerPay, color: Theme.accentBlue)
                        if !data.longTermUpside.isEmpty {
                            degreePayRow(label: "Long-Term Upside", value: data.longTermUpside, color: Color(hex: "34D399"))
                        }
                    } else if let edu {
                        degreePayRow(label: "Typical Range", value: edu.typicalSalaryRange, color: Theme.accent)
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text("Pay varies by location, employer, specialization, and experience. These are general ranges, not guarantees.")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                            .lineSpacing(2)
                    }
                    .padding(.top, 4)
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private func degreePayRow(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(color)
                .clipShape(.capsule)
            Text(value)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
    }

    private var degreeAIResistantSection: some View {
        let data = degreeDetailData

        return Group {
            if let data, !data.aiResistantReasons.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "shield.checkered")
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                        Text("Why This Is AI-Resistant")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        Text("\(path.aiProofRating)/100")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(aiScoreColor)
                            .clipShape(.capsule)
                    }

                    Text("This career scored \(path.aiProofRating)/100 on our AI-Proof scale because:")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .lineSpacing(3)

                    ForEach(Array(data.aiResistantReasons.enumerated()), id: \.offset) { _, reason in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.caption2)
                                .foregroundStyle(Theme.accent)
                                .padding(.top, 2)
                            Text(reason)
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                                .lineSpacing(3)
                        }
                    }
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.accent.opacity(0.15), lineWidth: 1)
                )
            }
        }
    }

    private var degreeDemandStabilitySection: some View {
        let data = degreeDetailData
        let edu = linkedEducation
        let demand = data?.demandStability ?? edu?.futureDemand ?? ""

        return Group {
            if !demand.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    sectionHeader("Demand & Long-Term Stability", icon: "chart.line.uptrend.xyaxis")

                    Text(demand)
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

    private var degreeBestFitSection: some View {
        let data = degreeDetailData

        return Group {
            if let data, !data.bestFitSummary.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.caption)
                            .foregroundStyle(Theme.accentBlue)
                        Text("Best Fit Summary")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                    }

                    Text(data.bestFitSummary)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(4)
                }
                .padding(16)
                .background(Theme.accentBlue.opacity(0.06))
                .clipShape(.rect(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.accentBlue.opacity(0.15), lineWidth: 1)
                )
            }
        }
    }

    // MARK: - Degree Track Sections

    private func degreeCareerPathway(_ edu: EducationPath) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Career Pathway", icon: "arrow.triangle.branch")

            HStack(spacing: 16) {
                roadmapStat(icon: "dollarsign.circle.fill", label: "Salary", value: edu.typicalSalaryRange)
                roadmapStat(icon: "clock.fill", label: "Program", value: edu.timeToComplete)
            }

            HStack(spacing: 16) {
                roadmapStat(icon: "banknote.fill", label: "Cost", value: edu.costRange)
                roadmapStat(icon: "shield.checkered", label: "AI-Safe", value: "\(edu.aiSafeScore)/100")
            }

            Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)

            Text(edu.overview)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)

            if !edu.whyItWorksNow.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.caption2)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)
                    Text(edu.whyItWorksNow)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .lineSpacing(3)
                }
            }

            if !edu.futureDemand.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "arrow.up.right")
                        .font(.caption2)
                        .foregroundStyle(Theme.accentBlue)
                        .padding(.top, 2)
                    Text(edu.futureDemand)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .lineSpacing(3)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func degreeProgramDetails(_ edu: EducationPath) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Program Requirements", icon: "graduationcap.fill")

            if !edu.deliveryType.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "building.2.fill")
                        .font(.caption2)
                        .foregroundStyle(Theme.accentBlue)
                    Text("Format: \(edu.deliveryType)")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
            }

            if !edu.testRequirements.isEmpty {
                Text("Exams & Certifications")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(edu.testRequirements, id: \.self) { req in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.accentBlue)
                            .padding(.top, 1)
                        Text(req)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }

            if !edu.prerequisites.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Prerequisites")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(edu.prerequisites, id: \.self) { prereq in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(Theme.accentBlue)
                            .frame(width: 5, height: 5)
                            .padding(.top, 6)
                        Text(prereq)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }

            if !edu.basicSteps.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Steps to Complete")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(Array(edu.basicSteps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(Theme.accentBlue)
                            .clipShape(Circle())
                        Text(step)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .lineSpacing(2)
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func degreeFundingSection(_ edu: EducationPath) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Funding Options", icon: "banknote.fill")
            ForEach(edu.fundingOptions, id: \.self) { option in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Theme.accentBlue)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(option)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }

            if !edu.militaryPath.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "shield.fill")
                        .font(.caption2)
                        .foregroundStyle(Theme.accentBlue)
                        .padding(.top, 2)
                    Text(edu.militaryPath)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineSpacing(3)
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private func degreeFindProgramsSection(_ edu: EducationPath) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("How to Find Programs", icon: "magnifyingglass")
            ForEach(edu.howToFindPrograms, id: \.self) { item in
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

            if !edu.employerSponsoredOptions.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                Text("Employer-Sponsored Options")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accentBlue)
                ForEach(edu.employerSponsoredOptions, id: \.self) { option in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(Theme.accentBlue)
                            .frame(width: 5, height: 5)
                            .padding(.top, 6)
                        Text(option)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Shared Helpers

    private func businessSetupSection(_ steps: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Business Setup", icon: "building.2.fill")
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 22, height: 22)
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

    private func roadmapStat(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(Theme.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
                Text(value)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
