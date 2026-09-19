import SwiftUI

/// The finished, readable business plan — everything the founder entered,
/// written out as a document they can share.
struct VenturePlanSummaryView: View {
    let plan: VenturePlan

    @Environment(\.dismiss) private var dismiss
    @State private var showShare: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    cover

                    section("The Idea", plan.idea)
                    section("The Problem", plan.problem)
                    section("The Solution", plan.solution)
                    section("Your Customer", plan.customerDescription)
                    section("Where They Are", plan.customerLocation)

                    if !plan.offers.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            heading("What You Sell")
                            ForEach(plan.offers, id: \.self) { offer in
                                Text("•  \(offer)")
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                            }
                        }
                    }

                    if plan.averagePrice > 0 {
                        VStack(alignment: .leading, spacing: 8) {
                            heading("Pricing")
                            Text("Range: \(plan.priceLow.isEmpty ? "—" : "$" + plan.priceLow) to \(plan.priceHigh.isEmpty ? "—" : "$" + plan.priceHigh)")
                                .font(.subheadline)
                            Text("Average sale: \(plan.averagePrice.currency)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.accent)
                            if !plan.pricingNotes.trimmed.isEmpty {
                                Text(plan.pricingNotes)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    if !plan.expenses.isEmpty {
                        moneySection
                    }

                    launchSection

                    Color.clear.frame(height: 40)
                }
                .padding(20)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Your Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    ShareLink(item: plainText) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }

    private var cover: some View {
        VStack(spacing: 12) {
            LogoMarkView(design: plan.logo, businessName: plan.businessName, size: 110)
            Text(plan.businessName.trimmed.isEmpty ? "Untitled Business" : plan.businessName)
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)
            if !plan.tagline.trimmed.isEmpty {
                Text(plan.tagline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    private var moneySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            heading("Money")
            ForEach(plan.expenses) { expense in
                HStack {
                    Text(expense.name)
                        .font(.subheadline)
                    Spacer()
                    Text("\(expense.amount.currency) \(expense.kind == .monthly ? "/mo" : "")")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }
            Divider()
            row("Startup total", plan.startupTotal.currency)
            row("Monthly total", plan.monthlyTotal.currency)
            if let breakEven = plan.breakEvenSales {
                row("Sales/month to break even", "\(breakEven)")
            }
            if let repay = plan.salesToRepayStartup {
                row("Sales to repay startup", "\(repay)")
            }
        }
    }

    private var launchSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            heading("Launch Plan")
            ForEach([1, 2, 3, 4], id: \.self) { week in
                let steps = plan.launchSteps.filter { $0.week == week }
                if !steps.isEmpty {
                    Text("Week \(week)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.accent)
                    ForEach(steps) { step in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: step.isDone ? "checkmark.circle.fill" : "circle")
                                .font(.caption)
                                .foregroundStyle(step.isDone ? Theme.accent : .secondary)
                            Text(step.title)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
        }
    }

    private func section(_ title: String, _ body: String) -> some View {
        Group {
            if !body.trimmed.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    heading(title)
                    Text(body)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private func heading(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(Theme.accent)
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(value)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.accent)
        }
    }

    /// Plain-text export used by the share sheet.
    private var plainText: String {
        var out = "\(plan.businessName.trimmed.isEmpty ? "Business Plan" : plan.businessName)\n"
        if !plan.tagline.trimmed.isEmpty { out += "\(plan.tagline)\n" }
        out += "\n"
        if !plan.idea.trimmed.isEmpty { out += "THE IDEA\n\(plan.idea)\n\n" }
        if !plan.problem.trimmed.isEmpty { out += "THE PROBLEM\n\(plan.problem)\n\n" }
        if !plan.solution.trimmed.isEmpty { out += "THE SOLUTION\n\(plan.solution)\n\n" }
        if !plan.customerDescription.trimmed.isEmpty { out += "CUSTOMER\n\(plan.customerDescription)\n\n" }
        if !plan.offers.isEmpty {
            out += "WHAT WE SELL\n"
            for offer in plan.offers { out += "- \(offer)\n" }
            out += "\n"
        }
        if plan.averagePrice > 0 {
            out += "PRICING\nAverage sale: \(plan.averagePrice.currency)\n\n"
        }
        if !plan.expenses.isEmpty {
            out += "MONEY\nStartup: \(plan.startupTotal.currency)\nMonthly: \(plan.monthlyTotal.currency)\n"
            if let breakEven = plan.breakEvenSales {
                out += "Break even at \(breakEven) sales/month\n"
            }
            out += "\n"
        }
        out += "LAUNCH PLAN\n"
        for step in plan.launchSteps {
            out += "[\(step.isDone ? "x" : " ")] Week \(step.week): \(step.title)\n"
        }
        out += "\nBuilt with Prooffd"
        return out
    }
}
