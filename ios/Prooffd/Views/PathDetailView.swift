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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    heroSection
                    quickStats
                    favHideBar
                    startBuildSection
                    overviewSection
                    llcInfoSection
                    degreeRequirementSection
                    actionPlanSection
                    pricingSection

                    if store.isPremium {
                        emailSection
                        textMessageSection
                        scriptSection(title: "Sales Intro Script", icon: "person.wave.2.fill", content: path.salesIntroScript)
                        socialMediaSection
                        pricingSheetSection
                    } else {
                        lockedProContentSection
                    }

                    whatOthersChargeSection

                    if store.isPremium {
                        businessPlanSection
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
                ShareCardView(result: result, userName: appState.userProfile.firstName, totalMatches: appState.matchResults.count)
            }
            .overlay {
                if showBuildAdded {
                    VStack {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Theme.accent)
                            Text("Added to My Builds!")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .clipShape(.capsule)
                        .padding(.top, 60)
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.spring(duration: 0.4), value: showBuildAdded)
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

            scoreDisplay
        }
    }

    private var scoreDisplay: some View {
        HStack(spacing: 4) {
            Text("\(result.scorePercentage)%")
                .font(.title.bold())
                .foregroundStyle(Theme.accent)
            Text("match")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(result.scorePercentage) percent match")
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
                detailChip("Education: \(path.educationRequired)")
            }

            if !path.degreeRequirement.isEmpty {
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "graduationcap.fill")
                        .font(.caption)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)
                    Text(path.degreeRequirement)
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

    private var llcInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("LLC & Business Structure", icon: "building.columns.fill")

            HStack(spacing: 8) {
                let reqColor: Color = path.llcInfo.requirement == .notNeeded ? Theme.accent :
                    path.llcInfo.requirement == .optional ? Color(hex: "FBBF24") :
                    path.llcInfo.requirement == .recommended ? .orange : .red.opacity(0.8)
                Text(path.llcInfo.requirement.rawValue)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(reqColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(reqColor.opacity(0.12))
                    .clipShape(.capsule)
            }

            Text(path.llcInfo.explanation)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)

            VStack(spacing: 8) {
                HStack {
                    Text("Without LLC")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Theme.textTertiary)
                    Spacer()
                    Text(path.llcInfo.costWithoutLLC)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                }
                Rectangle().fill(Theme.cardBackgroundLight).frame(height: 0.5)
                HStack {
                    Text("With LLC")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Theme.textTertiary)
                    Spacer()
                    Text(path.llcInfo.costWithLLC)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                }
            }
            .padding(12)
            .background(Theme.cardBackgroundLight)
            .clipShape(.rect(cornerRadius: 10))

            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption2)
                    .foregroundStyle(.orange)
                Text("LLC costs and requirements vary by state and city. Check with your state's Secretary of State office and local tax authority to understand all tax obligations, registered agent requirements, and business licensing fees.")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var degreeRequirementSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Education & Training", icon: "graduationcap.fill")
            Text(path.degreeRequirement)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    private var actionPlanSection: some View {
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
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Theme.accent)
                    Text("Already in My Builds")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.accent.opacity(0.12))
                .clipShape(.capsule)
            } else {
                Button {
                    appState.addBuild(from: path)
                    showBuildAdded = true
                    Task {
                        try? await Task.sleep(for: .seconds(2))
                        showBuildAdded = false
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "hammer.fill")
                        Text("Start This Build")
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
            }
        }
    }

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

    private func exportPDF() {
        if let url = PDFExportService.exportPathPDF(result) {
            PDFExportService.presentShareSheet(items: [url])
        }
    }
}
