import SwiftUI

/// Entry point for the Business Plan Builder: lists the founder's plans and
/// starts new ones.
struct VenturePlanListView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var openPlanId: UUID? = nil
    @State private var showIdeaSpark: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    intro

                    Button {
                        let plan = VenturePlan()
                        appState.addVenturePlan(plan)
                        openPlanId = plan.id
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Start a New Business Plan")
                                    .font(.headline)
                                Text("Eight guided steps, start to finish")
                                    .font(.caption)
                                    .opacity(0.8)
                            }
                            Spacer()
                        }
                        .foregroundStyle(.black)
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [Theme.accent, Theme.accentBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(.rect(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)

                    Button {
                        showIdeaSpark = true
                    } label: {
                        HStack(spacing: 12) {
                            RenderedIcon(name: "question_mark_glowing", size: 44, glow: Color(hex: "FBBF24"))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("No idea yet?")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("Generate ideas built around your quiz answers")
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
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)

                    if appState.venturePlans.isEmpty {
                        emptyState
                    } else {
                        ForEach(appState.venturePlans) { plan in
                            planRow(plan)
                        }
                    }

                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("Business Plan")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .navigationDestination(item: $openPlanId) { id in
                VenturePlanBuilderView(planId: id)
            }
            .sheet(isPresented: $showIdeaSpark) {
                IdeaSparkView { idea in
                    var plan = VenturePlan()
                    plan.idea = idea.pitch
                    plan.problem = idea.problem
                    plan.solution = idea.solution
                    plan.customerDescription = idea.customer
                    plan.offers = idea.offers
                    plan.logo.symbol = idea.symbol
                    appState.addVenturePlan(plan)
                    showIdeaSpark = false
                    openPlanId = plan.id
                }
            }
        }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Build your business, step by step")
                .font(.headline)
                .foregroundStyle(.primary)
            Text("Work out what you sell, who buys it, what it costs, and how you launch — then export the whole thing as a PDF.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            ArtworkImage(name: PathArtwork.emptyState, contentMode: .fit)
                .frame(height: 140)
            Text("No plans yet")
                .font(.headline)
                .foregroundStyle(.primary)
            Text("Start one above. You can keep several plans and compare them.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 18))
    }

    private func planRow(_ plan: VenturePlan) -> some View {
        Button {
            openPlanId = plan.id
        } label: {
            HStack(spacing: 14) {
                LogoMarkView(
                    design: plan.logo,
                    businessName: plan.businessName,
                    size: 56
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.businessName.trimmed.isEmpty ? "Untitled Plan" : plan.businessName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(plan.idea.trimmed.isEmpty ? "Tap to keep building" : plan.idea)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    ProgressView(value: plan.progress)
                        .tint(Theme.accent)
                    Text("\(plan.completedStageCount) of \(PlanStage.allCases.count) sections done")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.tertiary)
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 18))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button("Delete Plan", role: .destructive) {
                appState.deleteVenturePlan(plan.id)
            }
        }
    }
}
