import SwiftUI

struct ToolkitTabView: View {
    @Environment(StoreViewModel.self) private var store
    @State private var showDocumentVault = false
    @State private var showTradeToolkits = false
    @State private var showDegreeGuides = false
    @State private var showPaywall = false
    @State private var showROICalc = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    header

                    toolkitCard(
                        icon: "doc.text.fill",
                        iconColor: Theme.accent,
                        title: "Document Vault",
                        subtitle: "Contracts, invoices, emails & more",
                        meta: "\(DocumentVaultDatabase.all.count) templates  •  Free + Pro",
                        badge: nil
                    ) {
                        showDocumentVault = true
                    }

                    toolkitCard(
                        icon: "wrench.and.screwdriver.fill",
                        iconColor: Theme.accentBlue,
                        title: "Trade Toolkits",
                        subtitle: "Tools, licenses, unions & 90-day plans",
                        meta: "\(TradeToolkitDatabase.all.count) trades  •  Pro",
                        badge: store.isPremium ? nil : "PRO"
                    ) {
                        if store.isPremium { showTradeToolkits = true }
                        else { showPaywall = true }
                    }

                    toolkitCard(
                        icon: "graduationcap.fill",
                        iconColor: Color(hex: "818CF8"),
                        title: "Education Guides",
                        subtitle: "Test prep, ROI calculator & planning guides",
                        meta: "Test prep, planning guides & more",
                        badge: nil
                    ) {
                        showDegreeGuides = true
                    }

                    toolkitCard(
                        icon: "chart.line.uptrend.xyaxis",
                        iconColor: Color.orange,
                        title: "ROI Calculator",
                        subtitle: "Is this path worth the time and money?",
                        meta: "Works for any path  •  Free",
                        badge: nil
                    ) {
                        showROICalc = true
                    }

                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Toolkit")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !store.isPremium {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "crown.fill")
                                    .font(.caption.weight(.bold))
                                Text("PRO")
                                    .font(.caption.weight(.bold))
                            }
                            .foregroundStyle(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Theme.accent)
                            .clipShape(.capsule)
                        }
                        .accessibilityLabel("Unlock Pro")
                    }
                }
            }
            .sheet(isPresented: $showDocumentVault) { DocumentVaultView() }
            .sheet(isPresented: $showTradeToolkits) { TradeToolkitListView() }
            .sheet(isPresented: $showDegreeGuides) { DegreeGuidesView() }
            .sheet(isPresented: $showPaywall) { PaywallView() }
            .sheet(isPresented: $showROICalc) { DegreeROICalculatorView() }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Everything you need to start")
                .font(.headline)
                .foregroundStyle(.primary)
            Text("Contracts, scripts, trade checklists, and college planning — all offline, all in your pocket.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private func toolkitCard(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        meta: String,
        badge: String?,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: icon)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(iconColor)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    Text(meta)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                if let badge {
                    Text(badge)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.accent)
                        .clipShape(.capsule)
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}
