import SwiftUI

struct BusinessCategoryListSheet: View {
    let category: BusinessCategory
    @Environment(AppState.self) private var appState
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedResult: MatchResult?
    @State private var selectedZone: AIZone?
    @State private var selectedCostFilter: CostFilter?
    @State private var showFilters: Bool = false
    @State private var showPaywall: Bool = false

    private var catColor: Color { Theme.categoryColor(for: category) }

    private var results: [MatchResult] {
        var items = appState.matchResults.filter { $0.businessPath.category == category && !appState.isPathHidden($0.businessPath.id) }
        if let zone = selectedZone {
            items = items.filter { $0.businessPath.zone == zone }
        }
        if let cost = selectedCostFilter {
            items = items.filter { cost.matches($0.businessPath) }
        }
        return items.sorted { $0.businessPath.aiProofRating > $1.businessPath.aiProofRating }
    }

    private var hasActiveFilters: Bool {
        selectedZone != nil || selectedCostFilter != nil
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    if showFilters {
                        filterBar
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    if results.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "briefcase")
                                .font(.title2)
                                .foregroundStyle(.tertiary)
                            Text("No businesses in this category")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(results) { result in
                                businessCard(result)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            showFilters.toggle()
                        }
                    } label: {
                        Image(systemName: showFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                            .foregroundStyle(hasActiveFilters ? Theme.accent : .secondary)
                    }
                }
            }
            .sheet(item: $selectedResult) { result in
                PathDetailView(result: result)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Color(.systemGroupedBackground))
    }

    private var filterBar: some View {
        VStack(spacing: 10) {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    Text("AI Zone:")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                    ForEach(AIZone.allCases) { zone in
                        filterChip(zone.label, isActive: selectedZone == zone) {
                            withAnimation(.spring(duration: 0.3)) {
                                selectedZone = selectedZone == zone ? nil : zone
                            }
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 0)
            .scrollIndicators(.hidden)

            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    Text("Cost:")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                    ForEach(CostFilter.allCases) { cost in
                        filterChip(cost.label, isActive: selectedCostFilter == cost) {
                            withAnimation(.spring(duration: 0.3)) {
                                selectedCostFilter = selectedCostFilter == cost ? nil : cost
                            }
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 0)
            .scrollIndicators(.hidden)

            if hasActiveFilters {
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        selectedZone = nil
                        selectedCostFilter = nil
                    }
                } label: {
                    Text("Clear Filters")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }

    private func filterChip(_ title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(isActive ? .white : .secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isActive ? Theme.accent : Color(.tertiarySystemGroupedBackground))
                .clipShape(.capsule)
        }
    }

    private func businessCard(_ result: MatchResult) -> some View {
        let path = result.businessPath
        let zone = path.zone
        let aiColor: Color = zone == .safe ? Theme.accent : zone == .human ? Color(hex: "FBBF24") : .orange

        return Button {
            selectedResult = result
            appState.markPathExplored(path.id)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: path.icon)
                    .font(.body)
                    .foregroundStyle(catColor)
                    .frame(width: 44, height: 44)
                    .background(catColor.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    Text(path.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        Text(path.startupCostRange)
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        Text("·")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)

                        Text(path.timeToFirstDollar)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer(minLength: 4)

                HStack(spacing: 4) {
                    Image(systemName: zone.icon)
                        .font(.system(size: 10))
                    Text("\(path.aiProofRating)")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(aiColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(aiColor.opacity(0.1))
                .clipShape(.capsule)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                QuickShareHelper.shareBusiness(path.name)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
}
