import SwiftUI

/// The guided, start-to-finish business plan builder.
struct VenturePlanBuilderView: View {
    let planId: UUID

    @Environment(AppState.self) private var appState
    @State private var plan: VenturePlan = VenturePlan()
    @State private var openStage: PlanStage? = nil
    @State private var showSummary: Bool = false
    @State private var didLoad: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                headerCard

                ForEach(PlanStage.allCases) { stage in
                    stageRow(stage)
                }

                if plan.isReadyToExport {
                    Button {
                        showSummary = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "doc.text.fill")
                            Text("View Full Plan")
                                .font(.headline)
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Theme.accent, Theme.accentBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(.rect(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                } else {
                    Text("Finish at least 6 sections to unlock your full written plan.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                }

                Color.clear.frame(height: 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(plan.businessName.trimmed.isEmpty ? "Your Plan" : plan.businessName)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $openStage) { stage in
            PlanStageEditorView(stage: stage, plan: $plan)
        }
        .sheet(isPresented: $showSummary) {
            VenturePlanSummaryView(plan: plan)
        }
        .onAppear {
            guard !didLoad else { return }
            if let existing = appState.venturePlans.first(where: { $0.id == planId }) {
                plan = existing
            }
            didLoad = true
        }
        .onChange(of: plan) { _, newValue in
            guard didLoad else { return }
            appState.updateVenturePlan(newValue)
        }
    }

    private var headerCard: some View {
        VStack(spacing: 14) {
            LogoMarkView(design: plan.logo, businessName: plan.businessName, size: 88)

            VStack(spacing: 4) {
                Text(plan.businessName.trimmed.isEmpty ? "Name your business" : plan.businessName)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                if !plan.tagline.trimmed.isEmpty {
                    Text(plan.tagline)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            VStack(spacing: 6) {
                ProgressView(value: plan.progress)
                    .tint(Theme.accent)
                Text("\(plan.completedStageCount) of \(PlanStage.allCases.count) sections complete")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    private func stageRow(_ stage: PlanStage) -> some View {
        let done = plan.isStageComplete(stage)
        return Button {
            openStage = stage
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(done ? stage.accent : stage.accent.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: done ? "checkmark" : stage.icon)
                        .font(.body.weight(.bold))
                        .foregroundStyle(done ? .black : stage.accent)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(stage.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(stage.blurb)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

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

// MARK: - Stage Editor

struct PlanStageEditorView: View {
    let stage: PlanStage
    @Binding var plan: VenturePlan

    @Environment(\.dismiss) private var dismiss
    @State private var newOffer: String = ""
    @State private var newExpenseName: String = ""
    @State private var newExpenseAmount: String = ""
    @State private var newExpenseKind: ExpenseKind = .oneTime

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(stage.blurb)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    content
                }
                .padding(20)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle(stage.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch stage {
        case .idea:
            field("In one sentence, what is this business?",
                  hint: "e.g. A mobile car detailing service for busy commuters.",
                  text: $plan.idea, lines: 4)

        case .problem:
            field("What problem do you solve?",
                  hint: "What is frustrating, expensive, or slow for your customer right now?",
                  text: $plan.problem, lines: 4)
            field("How do you solve it?",
                  hint: "Your fix, in plain language.",
                  text: $plan.solution, lines: 4)

        case .customer:
            field("Who is your customer?",
                  hint: "Be specific. 'Homeowners with no time' beats 'everyone'.",
                  text: $plan.customerDescription, lines: 4)
            field("Where are they?",
                  hint: "Your town, a radius, or online.",
                  text: $plan.customerLocation, lines: 2)

        case .offer:
            Text("What you sell")
                .font(.headline)
            ForEach(plan.offers.indices, id: \.self) { index in
                HStack {
                    Text("• \(plan.offers[index])")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Button {
                        plan.offers.remove(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
            }
            HStack {
                TextField("Add a service or product", text: $newOffer)
                    .textFieldStyle(.roundedBorder)
                Button {
                    let trimmed = newOffer.trimmed
                    guard !trimmed.isEmpty else { return }
                    plan.offers.append(trimmed)
                    newOffer = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Theme.accent)
                }
            }

        case .pricing:
            HStack(spacing: 12) {
                priceField("Lowest price", text: $plan.priceLow)
                priceField("Highest price", text: $plan.priceHigh)
            }
            if plan.averagePrice > 0 {
                calloutRow("Average sale", plan.averagePrice.currency)
            }
            field("Why this price?",
                  hint: "What makes it worth it — speed, quality, convenience, guarantee?",
                  text: $plan.pricingNotes, lines: 4)

        case .money:
            expenseEditor

        case .brand:
            field("Business name", hint: "Short, easy to say, easy to spell.",
                  text: $plan.businessName, lines: 1)
            field("Tagline", hint: "One line that says what you do.",
                  text: $plan.tagline, lines: 2)
            logoDesigner

        case .launch:
            launchEditor
        }
    }

    // MARK: Money

    private var expenseEditor: some View {
        VStack(alignment: .leading, spacing: 14) {
            if !plan.expenses.isEmpty {
                VStack(spacing: 8) {
                    calloutRow("Startup cost", plan.startupTotal.currency)
                    calloutRow("Monthly cost", plan.monthlyTotal.currency)
                    if let breakEven = plan.breakEvenSales {
                        calloutRow("Sales/month to break even", "\(breakEven)")
                    }
                    if let repay = plan.salesToRepayStartup {
                        calloutRow("Sales to repay startup", "\(repay)")
                    }
                }
            }

            ForEach(plan.expenses) { expense in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(expense.name)
                            .font(.subheadline.weight(.medium))
                        Text(expense.kind.rawValue)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(expense.amount.currency)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                    Button {
                        plan.expenses.removeAll { $0.id == expense.id }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
            }

            VStack(spacing: 10) {
                TextField("Expense name", text: $newExpenseName)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    TextField("Amount", text: $newExpenseAmount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    Picker("", selection: $newExpenseKind) {
                        ForEach(ExpenseKind.allCases) { kind in
                            Text(kind.rawValue).tag(kind)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Button {
                    addExpense()
                } label: {
                    Text("Add Expense")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.accent)
                        .clipShape(.rect(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }

            suggestionChips
        }
    }

    private var suggestionChips: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Common expenses")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
            FlowLayout(spacing: 6) {
                ForEach(["Equipment", "Supplies", "Fuel", "Insurance", "Licenses", "Phone", "Website", "Marketing", "Software"], id: \.self) { name in
                    Button {
                        newExpenseName = name
                    } label: {
                        Text(name)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(Theme.accentBlue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(Theme.accentBlue.opacity(0.12))
                            .clipShape(.capsule)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func addExpense() {
        let name = newExpenseName.trimmed
        let cleaned = newExpenseAmount.filter { $0.isNumber || $0 == "." }
        guard !name.isEmpty, let amount = Double(cleaned), amount > 0 else { return }
        plan.expenses.append(
            PlanExpense(name: name, amount: amount, kind: newExpenseKind)
        )
        newExpenseName = ""
        newExpenseAmount = ""
    }

    // MARK: Logo

    private var logoDesigner: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your logo")
                .font(.headline)

            HStack {
                Spacer()
                LogoMarkView(design: plan.logo, businessName: plan.businessName, size: 120)
                Spacer()
            }

            Toggle("Use initials instead of a symbol", isOn: $plan.logo.useMonogram)
                .font(.subheadline)
                .tint(Theme.accent)

            Text("Shape")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
            Picker("", selection: $plan.logo.shape) {
                ForEach(LogoShape.allCases) { shape in
                    Text(shape.displayName).tag(shape)
                }
            }
            .pickerStyle(.segmented)

            Text("Colors")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(LogoPalette.all) { palette in
                        Button {
                            plan.logo.paletteId = palette.id
                        } label: {
                            VStack(spacing: 4) {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [palette.primary, palette.secondary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        if plan.logo.paletteId == palette.id {
                                            Circle().strokeBorder(.primary, lineWidth: 2)
                                        }
                                    }
                                Text(palette.name)
                                    .font(.system(size: 10))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
            .scrollIndicators(.hidden)

            if !plan.logo.useMonogram {
                Text("Symbol")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 52), spacing: 10)], spacing: 10) {
                    ForEach(LogoDesign.symbolChoices, id: \.self) { symbol in
                        Button {
                            plan.logo.symbol = symbol
                        } label: {
                            Image(systemName: symbol)
                                .font(.title3)
                                .foregroundStyle(plan.logo.symbol == symbol ? Color.black : Color.primary)
                                .frame(width: 48, height: 48)
                                .background(
                                    plan.logo.symbol == symbol
                                        ? AnyShapeStyle(Theme.accent)
                                        : AnyShapeStyle(Color(.secondarySystemGroupedBackground))
                                )
                                .clipShape(.rect(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: Launch

    private var launchEditor: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach([1, 2, 3, 4], id: \.self) { week in
                let steps = plan.launchSteps.filter { $0.week == week }
                if !steps.isEmpty {
                    Text("Week \(week)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.accent)
                    ForEach(steps) { step in
                        Button {
                            toggleStep(step)
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: step.isDone ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundStyle(step.isDone ? Theme.accent : .secondary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(step.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)
                                        .strikethrough(step.isDone, color: .secondary)
                                    Text(step.detail)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer()
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func toggleStep(_ step: LaunchStep) {
        guard let index = plan.launchSteps.firstIndex(where: { $0.id == step.id }) else { return }
        plan.launchSteps[index].isDone.toggle()
    }

    // MARK: Shared controls

    private func field(_ label: String, hint: String, text: Binding<String>, lines: Int) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.headline)
                .foregroundStyle(.primary)
            TextField(hint, text: text, axis: .vertical)
                .lineLimit(lines...max(lines, lines))
                .font(.subheadline)
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
        }
    }

    private func priceField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
            TextField("$0", text: text)
                .keyboardType(.decimalPad)
                .font(.subheadline)
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
        }
    }

    private func calloutRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.accent)
        }
        .padding(12)
        .background(Theme.accent.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}

extension Double {
    /// Whole-dollar display used throughout the plan builder.
    nonisolated var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = self < 100 ? 2 : 0
        return formatter.string(from: NSNumber(value: self)) ?? "$0"
    }
}
