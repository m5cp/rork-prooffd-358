import SwiftUI
import RevenueCat

struct PaywallView: View {
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPackageType: PackageType = .annual
    @State private var showTerms: Bool = false
    @State private var showPrivacy: Bool = false

    private let appleStandardEULAURL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!

    private let benefits: [(String, String)] = [
        ("map.fill", "Full career & business roadmaps"),
        ("dollarsign.circle.fill", "Salary ranges & cost breakdowns"),
        ("shield.checkered", "AI-resistance analysis"),
        ("checkmark.seal.fill", "Licensing & certification paths"),
        ("doc.text.fill", "Business plans & outreach scripts"),
        ("arrow.down.doc.fill", "PDF export & editable notes")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    headerSection
                    beforeAfterVisual
                    benefitsList
                    packageSelector
                    purchaseButton
                    restoreAndLinks
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 20)
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
                    .accessibilityLabel("Close")
                    .frame(minWidth: 44, minHeight: 44)
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
        .presentationContentInteraction(.scrolls)
        .onAppear { pickDefaultPackage() }
        .sheet(isPresented: $showTerms) {
            NavigationStack {
                TermsOfServiceView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button { showTerms = false } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Theme.textTertiary)
                                    .font(.title3)
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $showPrivacy) {
            NavigationStack {
                PrivacyPolicyView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button { showPrivacy = false } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Theme.textTertiary)
                                    .font(.title3)
                            }
                        }
                    }
            }
        }
    }

    private func pickDefaultPackage() {
        if resolvedAnnualPackage != nil {
            selectedPackageType = .annual
        } else if resolvedMonthlyPackage != nil {
            selectedPackageType = .monthly
        } else if resolvedLifetimePackage != nil {
            selectedPackageType = .lifetime
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Unlock your complete\ncareer roadmap")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .padding(.top, 16)

            Text("Full details for every career path \u{2014} salary data, licensing requirements, business plans, and more.")
                .font(.body)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Before / After

    private var beforeAfterVisual: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.caption2)
                    .foregroundStyle(Theme.accent)
                Text("YOUR PLAN: BEFORE VS AFTER")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Theme.accent)
                    .tracking(0.5)
            }

            HStack(alignment: .top, spacing: 10) {
                planColumn(
                    title: "Free",
                    tint: Theme.textTertiary,
                    rows: [
                        (icon: "lock.fill", text: "Top 3 matches"),
                        (icon: "eye.slash.fill", text: "Salary data hidden"),
                        (icon: "xmark.circle", text: "No full roadmap"),
                        (icon: "xmark.circle", text: "No PDF export")
                    ],
                    isPro: false
                )

                planColumn(
                    title: "Pro",
                    tint: Theme.accent,
                    rows: [
                        (icon: "checkmark.seal.fill", text: "All 50+ matches"),
                        (icon: "dollarsign.circle.fill", text: "Full salary data"),
                        (icon: "map.fill", text: "Complete roadmaps"),
                        (icon: "arrow.down.doc.fill", text: "PDF export")
                    ],
                    isPro: true
                )
            }
        }
    }

    private func planColumn(title: String, tint: Color, rows: [(icon: String, text: String)], isPro: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(isPro ? Theme.textPrimary : Theme.textSecondary)
                Spacer()
                if isPro {
                    Text("YOU")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(tint, in: .capsule)
                }
            }

            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: row.icon)
                        .font(.caption)
                        .foregroundStyle(tint)
                        .frame(width: 16)
                        .padding(.top, 2)
                    Text(row.text)
                        .font(.caption)
                        .foregroundStyle(isPro ? Theme.textPrimary : Theme.textTertiary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            isPro
            ? AnyShapeStyle(LinearGradient(colors: [Theme.accent.opacity(0.1), Theme.cardBackground],
                                           startPoint: .topLeading, endPoint: .bottomTrailing))
            : AnyShapeStyle(Theme.cardBackground)
        )
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isPro ? tint.opacity(0.3) : Theme.border, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) plan: \(rows.map(\.text).joined(separator: ", "))")
    }

    private var benefitsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(benefits.enumerated()), id: \.offset) { index, benefit in
                HStack(spacing: 14) {
                    Image(systemName: benefit.0)
                        .font(.body)
                        .foregroundStyle(Theme.accent)
                        .frame(width: 28)

                    Text(benefit.1)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textPrimary)

                    Spacer()

                    Image(systemName: "checkmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.accent)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)

                if index < benefits.count - 1 {
                    Divider()
                        .background(Theme.cardBackgroundLight)
                        .padding(.horizontal, 16)
                }
            }
        }
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Package Selector

    private var packageSelector: some View {
        VStack(spacing: 12) {
            if resolvedAnnualPackage != nil || true {
                annualCard(package: resolvedAnnualPackage)
            }
            monthlyCard(package: resolvedMonthlyPackage)
            lifetimeCard(package: resolvedLifetimePackage)
        }
    }

    private func annualCard(package: Package?) -> some View {
        let isSelected = selectedPackageType == .annual
        let weeklyPrice = weeklyPriceString(for: package)
        let yearlyPrice = package?.localizedPriceString ?? "$59.99"
        let savingsBadge = annualSavingsText

        return Button {
            withAnimation(.spring(duration: 0.25)) {
                selectedPackageType = .annual
            }
        } label: {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("BEST VALUE")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.white)
                        .tracking(0.5)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            LinearGradient(
                                colors: [Theme.accent, Theme.accentBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(.rect(cornerRadii: .init(topLeading: 0, bottomLeading: 8, bottomTrailing: 0, topTrailing: 12)))
                }

                HStack(spacing: 14) {
                    selectionDot(isSelected: isSelected)

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 8) {
                            Text("Annual")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            if let badge = savingsBadge {
                                Text(badge)
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(Theme.accent)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Theme.accent.opacity(0.12))
                                    .clipShape(.capsule)
                            }
                        }
                        Text("\(yearlyPrice)/year \u{2022} Cancel anytime")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(weeklyPrice)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                        Text("per week")
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
                .padding(.bottom, 16)
            }
            .background(
                isSelected
                    ? AnyShapeStyle(LinearGradient(
                        colors: [Theme.accent.opacity(0.08), Theme.cardBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                      ))
                    : AnyShapeStyle(Theme.cardBackground)
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .sensoryFeedback(.selection, trigger: selectedPackageType)
    }

    private func monthlyCard(package: Package?) -> some View {
        let isSelected = selectedPackageType == .monthly
        let priceString: String
        let subtitleString: String

        if let pkg = package,
           let intro = pkg.storeProduct.introductoryDiscount,
           intro.paymentMode == .freeTrial {
            priceString = pkg.localizedPriceString + "/mo"
            subtitleString = "\(intro.subscriptionPeriod.periodTitle()) free trial, then \(pkg.localizedPriceString)/mo"
        } else if let pkg = package {
            priceString = pkg.localizedPriceString + "/mo"
            subtitleString = "Billed monthly \u{2022} Cancel anytime"
        } else {
            priceString = "$1.99/mo"
            subtitleString = "Billed monthly \u{2022} Cancel anytime"
        }

        return Button {
            withAnimation(.spring(duration: 0.25)) {
                selectedPackageType = .monthly
            }
        } label: {
            HStack(spacing: 14) {
                selectionDot(isSelected: isSelected)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Monthly")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(subtitleString)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(priceString)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("per month")
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                isSelected
                    ? AnyShapeStyle(LinearGradient(
                        colors: [Theme.accent.opacity(0.08), Theme.cardBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                      ))
                    : AnyShapeStyle(Theme.cardBackground)
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .sensoryFeedback(.selection, trigger: selectedPackageType)
    }

    private func lifetimeCard(package: Package?) -> some View {
        let isSelected = selectedPackageType == .lifetime
        let priceString = package?.localizedPriceString ?? "$29.99"

        return Button {
            withAnimation(.spring(duration: 0.25)) {
                selectedPackageType = .lifetime
            }
        } label: {
            HStack(spacing: 14) {
                selectionDot(isSelected: isSelected)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Lifetime")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("One-time purchase \u{2022} Never pay again")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(priceString)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("one time")
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                isSelected
                    ? AnyShapeStyle(LinearGradient(
                        colors: [Theme.accent.opacity(0.08), Theme.cardBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                      ))
                    : AnyShapeStyle(Theme.cardBackground)
            )
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .sensoryFeedback(.selection, trigger: selectedPackageType)
    }

    private func selectionDot(isSelected: Bool) -> some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: isSelected ? 2.5 : 1.5)
                .frame(width: 24, height: 24)
            if isSelected {
                Circle()
                    .fill(Theme.accent)
                    .frame(width: 14, height: 14)
            }
        }
    }

    private func weeklyPriceString(for package: Package?) -> String {
        guard let package else { return "$1.15" }
        let price = package.storeProduct.price as Decimal
        let weekly = NSDecimalNumber(decimal: price / 52)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = package.storeProduct.priceFormatter?.locale ?? .current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: weekly) ?? "\(weekly)"
    }

    private var annualSavingsText: String? {
        guard let monthly = resolvedMonthlyPackage,
              let annual = resolvedAnnualPackage else { return nil }
        let monthlyPrice = monthly.storeProduct.price as Decimal
        let annualPrice = annual.storeProduct.price as Decimal
        guard monthlyPrice > 0 else { return nil }
        let yearFromMonthly = monthlyPrice * 12
        guard yearFromMonthly > annualPrice else { return nil }
        let saved = ((yearFromMonthly - annualPrice) / yearFromMonthly) * 100
        let percent = NSDecimalNumber(decimal: saved).intValue
        guard percent >= 10 else { return nil }
        return "Save \(percent)%"
    }

    // MARK: - Purchase

    private var purchaseButton: some View {
        VStack(spacing: 12) {
            if let error = store.error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task {
                    guard let pkg = selectedPackage else { return }
                    await store.purchase(package: pkg)
                    if store.isPremium {
                        dismiss()
                    }
                }
            } label: {
                Group {
                    if store.isPurchasing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(purchaseButtonTitle)
                            .font(.headline)
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Theme.accent, Theme.accent.opacity(0.85)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(.capsule)
                .shadow(color: Theme.accent.opacity(0.3), radius: 8, y: 4)
            }
            .disabled(store.isPurchasing || selectedPackage == nil)

            if store.isLoading && store.offerings == nil {
                ProgressView()
                    .tint(Theme.textSecondary)
            }
        }
    }

    private var purchaseButtonTitle: String {
        switch selectedPackageType {
        case .lifetime:
            return "Get Lifetime Access"
        case .monthly:
            if let pkg = resolvedMonthlyPackage,
               let intro = pkg.storeProduct.introductoryDiscount,
               intro.paymentMode == .freeTrial {
                return "Start Free Trial"
            }
            return "Subscribe Now"
        case .annual:
            if let pkg = resolvedAnnualPackage,
               let intro = pkg.storeProduct.introductoryDiscount,
               intro.paymentMode == .freeTrial {
                return "Start Free Trial"
            }
            return "Continue"
        }
    }

    private var restoreAndLinks: some View {
        VStack(spacing: 16) {
            Button {
                Task { await store.restore() }
            } label: {
                Text("Restore Purchases")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
            .frame(minHeight: 44)

            subscriptionDisclosure
        }
    }

    private var subscriptionDisclosure: some View {
        VStack(spacing: 8) {
            Divider()
                .background(Theme.cardBackgroundLight)
                .padding(.vertical, 4)

            Text("Prooffd Pro")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.textSecondary)

            Group {
                if selectedPackageType == .lifetime {
                    Text("One-time purchase. Lifetime access to all Pro features. No recurring charges. Payment will be charged to your Apple ID account at confirmation of purchase.")
                } else {
                    Text("Auto-renewable subscription. Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. You can manage and cancel your subscription in your Apple ID Account Settings.")
                }
            }
            .font(.caption2)
            .foregroundStyle(Theme.textTertiary)
            .multilineTextAlignment(.center)
            .lineSpacing(2)
            .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                Button {
                    showTerms = true
                } label: {
                    Text("Terms of Use")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Theme.accentBlue)
                }

                Text("\u{00B7}")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)

                Button {
                    showPrivacy = true
                } label: {
                    Text("Privacy Policy")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Theme.accentBlue)
                }

                Text("\u{00B7}")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)

                Link(destination: appleStandardEULAURL) {
                    Text("EULA")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Theme.accentBlue)
                }
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Package Resolution

    private var resolvedAnnualPackage: Package? {
        guard let offering = store.offerings?.current else { return nil }
        return offering.annual ?? offering.availablePackages.first(where: {
            $0.storeProduct.subscriptionPeriod?.unit == .year
        })
    }

    private var resolvedMonthlyPackage: Package? {
        guard let offering = store.offerings?.current else { return nil }
        return offering.monthly ?? offering.availablePackages.first(where: {
            $0.storeProduct.subscriptionPeriod?.unit == .month
        })
    }

    private var resolvedLifetimePackage: Package? {
        guard let offering = store.offerings?.current else { return nil }
        return offering.lifetime ?? offering.availablePackages.first(where: {
            $0.storeProduct.subscriptionPeriod == nil
        })
    }

    private var selectedPackage: Package? {
        switch selectedPackageType {
        case .annual: return resolvedAnnualPackage
        case .monthly: return resolvedMonthlyPackage
        case .lifetime: return resolvedLifetimePackage
        }
    }
}

nonisolated enum PackageType: String, Sendable {
    case annual
    case monthly
    case lifetime
}
