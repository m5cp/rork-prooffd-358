import SwiftUI

struct DegreeROICalculatorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass

    @State private var degreeCost: Double = 40_000
    @State private var yearsToComplete: Double = 4
    @State private var startingSalary: Double = 55_000
    @State private var currentSalary: Double = 35_000

    private var opportunityCost: Double { yearsToComplete * currentSalary }
    private var totalInvestment: Double { degreeCost + opportunityCost }
    private var annualGain: Double { startingSalary - currentSalary }
    private var breakEvenYears: Double {
        guard annualGain > 0 else { return 31 }
        return min(totalInvestment / annualGain, 30)
    }
    private var tenYearNet: Double { (annualGain * 10) - totalInvestment }

    private var breakEvenColor: Color {
        if annualGain <= 0 { return .red }
        let y = totalInvestment / annualGain
        if y < 7 { return .green }
        if y <= 12 { return .orange }
        return .red
    }

    private var currency: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.maximumFractionDigits = 0
        f.currencyCode = "USD"
        return f
    }

    private func money(_ v: Double) -> String {
        currency.string(from: NSNumber(value: v)) ?? "$0"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    sliderCard(
                        title: "Degree Cost",
                        value: $degreeCost,
                        range: 10_000...200_000,
                        step: 5_000,
                        display: money(degreeCost)
                    )

                    sliderCard(
                        title: "Years to Complete",
                        value: $yearsToComplete,
                        range: 1...8,
                        step: 0.5,
                        display: yearsToComplete == floor(yearsToComplete)
                            ? "\(Int(yearsToComplete)) years"
                            : String(format: "%.1f years", yearsToComplete)
                    )

                    sliderCard(
                        title: "Expected Starting Salary",
                        value: $startingSalary,
                        range: 25_000...200_000,
                        step: 5_000,
                        display: "\(money(startingSalary))/yr"
                    )

                    sliderCard(
                        title: "Current / Alternative Income",
                        value: $currentSalary,
                        range: 0...150_000,
                        step: 5_000,
                        display: "\(money(currentSalary))/yr"
                    )

                    resultsCard

                    disclaimer

                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, sizeClass == .regular ? 40 : 16)
                .padding(.top, 12)
            }
            .background(Theme.background)
            .navigationTitle("ROI Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.accent)
                        .frame(minWidth: 44, minHeight: 44)
                }
            }
        }
    }

    private func sliderCard(title: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double, display: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title).font(.subheadline).foregroundStyle(Theme.textSecondary)
                Spacer()
                Text(display).font(.headline).foregroundStyle(Theme.textPrimary).monospacedDigit()
            }
            Slider(value: value, in: range, step: step)
                .tint(Theme.accent)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.border, lineWidth: 1))
    }

    private var resultsCard: some View {
        VStack(spacing: 14) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(Theme.accent)
                Text("Your Numbers").font(.headline).foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            VStack(spacing: 10) {
                resultRow(label: "Opportunity Cost", value: money(opportunityCost), hint: "Income you give up while studying")
                Divider().background(Theme.border)
                resultRow(label: "Total Investment", value: money(totalInvestment), hint: "Tuition + opportunity cost")
                Divider().background(Theme.border)
                resultRow(label: "Annual Salary Gain", value: annualGain > 0 ? "+\(money(annualGain))/yr" : money(annualGain) + "/yr",
                          hint: "New salary minus current income",
                          valueColor: annualGain > 0 ? .green : .red)
                Divider().background(Theme.border)
                resultRow(
                    label: "Break-Even",
                    value: annualGain <= 0 ? "30+ years" : (breakEvenYears >= 30 ? "30+ years" : String(format: "%.1f years", breakEvenYears)),
                    hint: annualGain <= 0 ? "No salary gain — no break-even" : "Years until you recover your investment",
                    valueColor: breakEvenColor
                )
                Divider().background(Theme.border)
                resultRow(
                    label: "10-Year Net Gain",
                    value: tenYearNet >= 0 ? "+\(money(tenYearNet))" : money(tenYearNet),
                    hint: "Net financial position after 10 years",
                    valueColor: tenYearNet >= 0 ? .green : .red
                )
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.accent.opacity(0.25), lineWidth: 1))
    }

    private func resultRow(label: String, value: String, hint: String, valueColor: Color = Theme.textPrimary) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.subheadline.weight(.medium)).foregroundStyle(Theme.textPrimary)
                Text(hint).font(.caption).foregroundStyle(Theme.textTertiary)
            }
            Spacer()
            Text(value)
                .font(.headline.weight(.semibold))
                .foregroundStyle(valueColor)
                .monospacedDigit()
        }
    }

    private var disclaimer: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle").foregroundStyle(Theme.textTertiary).font(.caption)
            Text("This calculator is for rough planning only. It does not account for loan interest, taxes, or career promotions. Use it as a starting point, not a final answer.")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackgroundLight)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
