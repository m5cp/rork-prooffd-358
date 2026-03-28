import SwiftUI
import RevenueCat

struct PaywallView: View {
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showTerms: Bool = false
    @State private var showPrivacy: Bool = false
    @State private var showEULA: Bool = false

    private let benefits: [(String, String)] = [
        ("doc.text.fill", "Business plan templates"),
        ("text.bubble.fill", "Client outreach scripts"),
        ("envelope.fill", "Draft email templates"),
        ("square.and.arrow.up.fill", "Export to PDF"),
        ("chart.bar.fill", "50 matched business paths"),
        ("wand.and.stars", "Deeper launch tools")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    headerSection
                    previewCard
                    benefitsList
                    priceSection
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
            Text("Get your complete\nbusiness launch kit")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .padding(.top, 16)

            Text("Unlock templates, scripts, exports, and deeper planning tools.")
                .font(.body)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var previewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "eye.fill")
                    .font(.caption2)
                    .foregroundStyle(Theme.accent)
                Text("PREVIEW")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Theme.accent)
                    .tracking(0.5)
            }

            Text("Business Plan Template")
                .font(.title3.bold())
                .foregroundStyle(Theme.textPrimary)

            Text("Step-by-step launch outline, messaging strategy, and PDF export for your matched business.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(3)

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "doc.text")
                        .font(.caption2)
                    Text("7 sections")
                        .font(.caption2.weight(.medium))
                }
                .foregroundStyle(Theme.textTertiary)

                HStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.caption2)
                    Text("PDF ready")
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

    private var priceSection: some View {
        VStack(spacing: 16) {
            if let offering = store.offerings?.current,
               let package = offering.availablePackages.first {
                VStack(spacing: 4) {
                    if let intro = package.storeProduct.introductoryDiscount,
                       intro.paymentMode == .freeTrial {
                        Text("\(intro.subscriptionPeriod.periodTitle()) Free Trial")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)
                        Text("then \(package.localizedPriceString)/month")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    } else if let intro = package.storeProduct.introductoryDiscount {
                        Text(intro.localizedPriceString + "/month")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)
                        Text("then \(package.localizedPriceString)/month")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    } else {
                        Text(package.localizedPriceString + "/month")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)
                    }
                    Text("Cancel anytime")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }

                Button {
                    Task {
                        await store.purchase(package: package)
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
                            Text(purchaseButtonTitle(for: package))
                                .font(.headline)
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.accent)
                    .clipShape(.capsule)
                }
                .disabled(store.isPurchasing)
            } else {
                VStack(spacing: 4) {
                    Text("$1.99/month")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.textPrimary)
                    Text("Cancel anytime")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }

                Button {
                } label: {
                    Text("Start Free Trial")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.accent)
                        .clipShape(.capsule)
                }

                if store.isLoading {
                    ProgressView()
                        .tint(Theme.textSecondary)
                }
            }

            Button {
                Task { await store.restore() }
            } label: {
                Text("Restore Purchases")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }

            if let error = store.error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            subscriptionDisclosure
        }
    }

    private func purchaseButtonTitle(for package: Package) -> String {
        guard let intro = package.storeProduct.introductoryDiscount else {
            return "Subscribe Now"
        }
        switch intro.paymentMode {
        case .freeTrial:
            return "Start Free Trial"
        case .payAsYouGo, .payUpFront:
            return "Start Intro Offer"
        @unknown default:
            return "Subscribe Now"
        }
    }

    private var subscriptionDisclosure: some View {
        VStack(spacing: 8) {
            Divider()
                .background(Theme.cardBackgroundLight)
                .padding(.vertical, 4)

            Text("Prooffd Pro Monthly")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.textSecondary)

            Text("Auto-renewable subscription. $1.99/month. Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless cancelled at least 24 hours before the end of the current monthly period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscription in your Apple ID Account Settings.")
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
}
