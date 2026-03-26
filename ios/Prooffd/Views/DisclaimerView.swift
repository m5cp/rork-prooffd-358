import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disclaimer")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                    Text("Last updated: March 2026")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.bottom, 8)

                warningBanner

                disclaimerSection(
                    title: "Entertainment Only",
                    icon: "theatermasks.fill",
                    content: "Prooffd is designed for entertainment and informational purposes only. The business ideas, templates, scripts, pricing information, and all other content provided within this app do not constitute financial advice, investment advice, business advice, legal advice, or any other form of professional advice."
                )

                disclaimerSection(
                    title: "No Promise of Income",
                    icon: "dollarsign.arrow.circlepath",
                    content: "There is no promise, guarantee, or expectation that you will earn any money using this app. The business paths and pricing information shown are general industry ranges and do not predict, guarantee, or imply any specific financial outcome. Many businesses fail, and you could lose some or all of the money you invest in pursuing any idea."
                )

                disclaimerSection(
                    title: "Risk of Financial Loss",
                    icon: "exclamationmark.triangle.fill",
                    content: "You could lose money on any business idea presented in this app. Starting a business involves inherent financial risk. Prooffd is not responsible for any money you spend, invest, or lose as a result of pursuing any ideas, strategies, or suggestions found in this app. Any decision to spend money based on information in this app is made entirely at your own risk."
                )

                disclaimerSection(
                    title: "Not Financial Advice",
                    icon: "banknote",
                    content: "Nothing in this app should be interpreted as financial advice. We are not financial advisors, business consultants, accountants, or attorneys. The pricing data, market information, and business templates are provided as general reference material only and should not be relied upon for making financial decisions."
                )

                disclaimerSection(
                    title: "Do Your Own Research",
                    icon: "magnifyingglass",
                    content: "Before starting any business or spending any money, you are solely responsible for conducting your own thorough research. This includes but is not limited to:\n\n\u{2022} Consulting with licensed professionals (attorneys, accountants, financial advisors)\n\u{2022} Researching your local, city, county, and state laws and regulations\n\u{2022} Understanding gig economy regulations in your area\n\u{2022} Researching business licensing, permits, and zoning requirements\n\u{2022} Understanding LLC formation, business structure, and tax obligations in your state\n\u{2022} Evaluating local market conditions and competition\n\u{2022} Understanding insurance requirements for your specific business type"
                )

                disclaimerSection(
                    title: "Local Laws & Regulations",
                    icon: "building.columns.fill",
                    content: "Business regulations, licensing requirements, tax obligations, and legal requirements vary significantly by city, county, state, and country. Prooffd does not account for your specific local regulations. It is your responsibility to ensure compliance with all applicable laws, including but not limited to business licenses, permits, health department regulations, zoning laws, insurance requirements, and tax obligations."
                )

                disclaimerSection(
                    title: "Limitation of Liability",
                    icon: "shield.slash",
                    content: "To the fullest extent permitted by law, Prooffd and its creators, owners, employees, and affiliates shall not be held liable for any damages, losses, costs, or expenses (including lost profits or lost money) arising from or related to your use of this app or any information contained within it. By using this app, you acknowledge and accept all risks associated with acting on any information provided."
                )

                Color.clear.frame(height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .navigationTitle("Disclaimer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Theme.background, for: .navigationBar)
    }

    private var warningBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text("Important Notice")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("This app is for entertainment purposes only. It is not financial advice. You could lose money.")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }

    private func disclaimerSection(title: String, icon: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(Theme.accent)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
            }
            Text(content)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
    }
}
