import SwiftUI
import RevenueCat

struct PaywallView: View {
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPackageType: PackageType = .lifetime
    @State private var showTerms: Bool = false
    @State private var showPrivacy: Bool = false
    @State private var showEULA: Bool = false

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
                    previewCard
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
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
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
        .sheet(isPresented: $showEULA) {
            NavigationStack {
                TermsOfServiceView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button { showEULA = false } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Theme.textTertiary)
                                    .font(.title3)
                            }
                        }
                    }
            }
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

    private var previewCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.caption2)
                    .foregroundStyle(Theme.accent)
                Text("WHAT YOU GET")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Theme.accent)
                    .tracking(0.5)
            }

            Text("Deep Career Intelligence")
                .font(.title3.bold())
                .foregroundStyle(Theme.textPrimary)

            Text("Every career path unlocks its full structured detail \u{2014} education timelines, pay data, licensing requirements, AI-proof analysis, and actionable launch plans.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(3)

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "briefcase.fill")
                        .font(.caption2)
                    Text("3 career tracks")
                        .font(.caption2.weight(.medium))
                }
                .foregroundStyle(Theme.textTertiary)

                HStack(spacing: 4) {
                    Image(systemName: "doc.text")
                        .font(.caption2)
                    Text("Full roadmaps")
                        .font(.caption2.weight(.medium))
                }
                .foregroundStyle(Theme.textTertiary)

                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.doc")
                        .font(.caption2)
                    Text("PDF export")
                        .font(.caption2.weight(.medium))
                }
                .foregroundStyle(Theme.textTertiary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Theme.accent.opacity(0.06), Theme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Theme.accent.opacity(0.15), lineWidth: 1)
        )
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
        let monthlyPkg = resolvedMonthlyPackage
        let lifetimePkg = resolvedLifetimePackage

        return VStack(spacing: 12) {
            lifetimeCard(package: lifetimePkg)
            monthlyCard(package: monthlyPkg)
        }
    }

    private func lifetimeCard(package: Package?) -> some View {
        let isSelected = selectedPackageType == .lifetime
        let priceString = package?.localizedPriceString ?? "$29.99"

        return Button {
            withAnimation(.spring(duration: 0.25)) {
                selectedPackageType = .lifetime
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

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 8) {
                            Text("Lifetime Access")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)

                            Text("Save 75%")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(Theme.accent)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Theme.accent.opacity(0.12))
                                .clipShape(.capsule)
                        }
                        Text("One-time purchase \u{2022} Never pay again")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(priceString)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                        Text("one time")
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
                        .font(.title3.weight(.bold))
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

                Button {
                    showEULA = true
                } label: {
                    Text("EULA")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Theme.accentBlue)
                }
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Package Resolution

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
        case .monthly: return resolvedMonthlyPackage
        case .lifetime: return resolvedLifetimePackage
        }
    }
}

nonisolated enum PackageType: String, Sendable {
    case monthly
    case lifetime
}
