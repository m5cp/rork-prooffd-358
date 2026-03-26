import SwiftUI
import RevenueCat

struct PaywallView: View {
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showTerms: Bool = false
    @State private var showPrivacy: Bool = false
    @State private var showEULA: Bool = false

    private let features = [
        ("50 Matched Business Paths", "chart.bar.fill"),
        ("Draft Email Templates", "envelope.fill"),
        ("Text Message Templates", "message.fill"),
        ("Sales Intro Scripts", "person.wave.2.fill"),
        ("Social Media Posts", "square.and.arrow.up.fill"),
        ("Offer & Pricing Sheets", "dollarsign.square.fill"),
        ("One-Page Business Plans", "doc.text.fill"),
        ("PDF Export", "doc.fill")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featuresGrid
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
                            Button {
                                showTerms = false
                            } label: {
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
                            Button {
                                showPrivacy = false
                            } label: {
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
                            Button {
                                showEULA = false
                            } label: {
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
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [Theme.accent, Theme.accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 80, height: 80)
                Image(systemName: "crown.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
            .padding(.top, 16)
            .accessibilityHidden(true)

            Text("Unlock Prooffd Pro")
                .font(.title.bold())
                .foregroundStyle(Theme.textPrimary)

            Text("Get everything you need to start\nyour business today")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    private var featuresGrid: some View {
        VStack(spacing: 0) {
            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                HStack(spacing: 14) {
                    Image(systemName: feature.1)
                        .font(.body)
                        .foregroundStyle(Theme.accent)
                        .frame(width: 28)

                    Text(feature.0)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textPrimary)

                    Spacer()

                    Image(systemName: "checkmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.accent)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)

                if index < features.count - 1 {
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
                    Text(package.localizedPriceString + "/month")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.textPrimary)
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
                            Text("Start Pro")
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
                    Text("Start Pro")
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

                Text("·")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)

                Button {
                    showPrivacy = true
                } label: {
                    Text("Privacy Policy")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Theme.accentBlue)
                }

                Text("·")
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
