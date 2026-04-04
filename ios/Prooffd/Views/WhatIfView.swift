import SwiftUI

struct WhatIfView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var tempProfile: UserProfile
    @State private var previewResults: [MatchResult] = []
    @State private var hasChanges: Bool = false

    let originalProfile: UserProfile

    init(profile: UserProfile) {
        self.originalProfile = profile
        self._tempProfile = State(initialValue: profile)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerCard

                    VStack(spacing: 12) {
                        tweakSection(title: "Budget", icon: "dollarsign.circle.fill") {
                            tweakPicker(options: BudgetRange.allCases, selected: tempProfile.budget) {
                                tempProfile.budget = $0
                                recalculate()
                            }
                        }

                        tweakSection(title: "Work Type", icon: "briefcase.fill") {
                            tweakPicker(options: WorkPreference.allCases, selected: tempProfile.workPreference) {
                                tempProfile.workPreference = $0
                                recalculate()
                            }
                        }

                        tweakSection(title: "Work Style", icon: "person.2.fill") {
                            tweakPicker(options: WorkStyle.allCases, selected: tempProfile.workStyle) {
                                tempProfile.workStyle = $0
                                recalculate()
                            }
                        }

                        tweakSection(title: "Tech Comfort", icon: "desktopcomputer") {
                            tweakPicker(options: TechComfort.allCases, selected: tempProfile.techComfort) {
                                tempProfile.techComfort = $0
                                recalculate()
                            }
                        }

                        tweakSection(title: "Need Fast Cash", icon: "bolt.fill") {
                            HStack(spacing: 10) {
                                whatIfBoolChip("Yes", isSelected: tempProfile.needsFastCash == true) {
                                    tempProfile.needsFastCash = true
                                    recalculate()
                                }
                                whatIfBoolChip("No", isSelected: tempProfile.needsFastCash == false) {
                                    tempProfile.needsFastCash = false
                                    recalculate()
                                }
                            }
                        }

                        tweakSection(title: "Has Car", icon: "car.fill") {
                            HStack(spacing: 10) {
                                whatIfBoolChip("Yes", isSelected: tempProfile.hasCar == true) {
                                    tempProfile.hasCar = true
                                    recalculate()
                                }
                                whatIfBoolChip("No", isSelected: tempProfile.hasCar == false) {
                                    tempProfile.hasCar = false
                                    recalculate()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    if hasChanges && !previewResults.isEmpty {
                        previewSection
                            .padding(.horizontal, 16)
                    }

                    if hasChanges {
                        Button {
                            applyChanges()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Apply Changes & Update Matches")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.accent)
                            .clipShape(.capsule)
                        }
                        .padding(.horizontal, 24)
                        .sensoryFeedback(.impact(weight: .medium), trigger: hasChanges)
                    }

                    Color.clear.frame(height: 40)
                }
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
            .navigationTitle("What If...")
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
        .onAppear {
            previewResults = MatchingEngine.match(profile: tempProfile, paths: BusinessPathDatabase.allPaths)
            appState.markWhatIfUsed()
        }
    }

    private var headerCard: some View {
        VStack(spacing: 8) {
            Image(systemName: "slider.horizontal.3")
                .font(.title)
                .foregroundStyle(Theme.accentBlue)
            Text("Tweak Your Answers")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.textPrimary)
            Text("Adjust a few settings and instantly see how your matches change — no full retake needed.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .padding(.horizontal, 16)
    }

    private func tweakSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
            }
            content()
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
    }

    private func tweakPicker<T: Identifiable & RawRepresentable>(
        options: [T],
        selected: T?,
        onSelect: @escaping (T) -> Void
    ) -> some View where T.RawValue == String {
        FlowLayout(spacing: 8) {
            ForEach(options) { option in
                let isSelected = selected?.rawValue == option.rawValue
                Button {
                    withAnimation(.spring(duration: 0.25)) {
                        onSelect(option)
                    }
                } label: {
                    Text(option.rawValue)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(isSelected ? .white : Theme.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(isSelected ? Theme.accentBlue : Theme.cardBackgroundLight)
                        .clipShape(.capsule)
                }
            }
        }
    }

    private func whatIfBoolChip(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(duration: 0.25)) {
                action()
            }
        } label: {
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(isSelected ? .white : Theme.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.accentBlue : Theme.cardBackgroundLight)
                .clipShape(.capsule)
        }
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundStyle(Theme.accent)
                Text(hasChanges ? "Preview: \(previewResults.count) matches" : "\(previewResults.count) matches")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)

                if hasChanges {
                    let diff = previewResults.count - appState.matchResults.count
                    if diff != 0 {
                        Text(diff > 0 ? "+\(diff)" : "\(diff)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(diff > 0 ? Theme.accent : .orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background((diff > 0 ? Theme.accent : Color.orange).opacity(0.15))
                            .clipShape(.capsule)
                    }
                }
            }

            ForEach(Array(previewResults.prefix(5).enumerated()), id: \.element.id) { index, result in
                HStack(spacing: 12) {
                    Text("\(index + 1)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Theme.textTertiary)
                        .frame(width: 18)

                    Image(systemName: result.businessPath.icon)
                        .font(.caption)
                        .foregroundStyle(Theme.categoryColor(for: result.businessPath.category))
                        .frame(width: 20)

                    Text(result.businessPath.name)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)

                    Spacer()

                    HStack(spacing: 3) {
                        Image(systemName: result.businessPath.zone.icon)
                            .font(.system(size: 9))
                        Text("\(result.businessPath.aiProofRating)")
                            .font(.caption.weight(.bold))
                    }
                    .foregroundStyle(result.businessPath.zone == .safe ? Theme.accent : result.businessPath.zone == .human ? Color(hex: "FBBF24") : .orange)
                }
            }

            if previewResults.count > 5 {
                Text("+ \(previewResults.count - 5) more matches")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
        )
    }

    private func recalculate() {
        hasChanges = profilesDiffer(tempProfile, originalProfile)
        previewResults = MatchingEngine.match(profile: tempProfile, paths: BusinessPathDatabase.allPaths)
    }

    private func profilesDiffer(_ a: UserProfile, _ b: UserProfile) -> Bool {
        a.budget != b.budget ||
        a.workPreference != b.workPreference ||
        a.workStyle != b.workStyle ||
        a.techComfort != b.techComfort ||
        a.selectedCategories != b.selectedCategories ||
        a.workEnvironments != b.workEnvironments ||
        a.workConditions != b.workConditions ||
        a.situationTags != b.situationTags
    }

    private func applyChanges() {
        appState.userProfile = tempProfile
        appState.runMatching()
        if let data = try? JSONEncoder().encode(tempProfile) {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
        dismiss()
    }
}
