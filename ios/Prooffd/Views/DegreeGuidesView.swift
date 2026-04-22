import SwiftUI

struct DegreeGuidesView: View {
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var expandedSection: DegreeSection? = .testPrep
    @State private var showPaywall = false
    @State private var showROICalc = false
    @State private var selectedRoadmap: TestPrepRoadmap? = nil
    @State private var showScholarship = false
    @State private var showProgramPicker = false
    @State private var showAppChecklist = false

    enum DegreeSection: String, CaseIterable {
        case testPrep       = "Test Prep"
        case planningGuides = "Planning Guides"
        case calculator     = "ROI Calculator"

        var icon: String {
            switch self {
            case .testPrep:       return "pencil.and.ruler.fill"
            case .planningGuides: return "list.clipboard.fill"
            case .calculator:     return "chart.line.uptrend.xyaxis"
            }
        }
        var subtitle: String {
            switch self {
            case .testPrep:       return "SAT, ACT, GRE, GMAT — study roadmaps"
            case .planningGuides: return "Scholarships, program selection, applications"
            case .calculator:     return "Model your real cost and break-even point"
            }
        }
        var meta: String {
            switch self {
            case .testPrep:       return "4 exams  •  Pro"
            case .planningGuides: return "3 guides  •  Free"
            case .calculator:     return "Interactive tool  •  Free"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(DegreeSection.allCases, id: \.self) { section in
                        sectionCard(section)
                    }
                    Color.clear.frame(height: 30)
                }
                .padding(.horizontal, sizeClass == .regular ? 40 : 16)
                .padding(.top, 12)
            }
            .background(Theme.background)
            .navigationTitle("Degree Guides")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }.foregroundStyle(Theme.accent)
                }
            }
            .sheet(isPresented: $showROICalc)      { DegreeROICalculatorView() }
            .sheet(isPresented: $showScholarship)   { ScholarshipGuideView() }
            .sheet(isPresented: $showProgramPicker) { HowToPickProgramView() }
            .sheet(isPresented: $showAppChecklist)  { ApplicationChecklistView() }
            .sheet(isPresented: $showPaywall)       { PaywallView() }
            .sheet(item: $selectedRoadmap)          { roadmap in TestPrepRoadmapView(roadmap: roadmap) }
        }
    }

    private func sectionCard(_ section: DegreeSection) -> some View {
        let isExpanded = expandedSection == section

        return VStack(spacing: 0) {
            Button {
                if section == .calculator {
                    showROICalc = true
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        expandedSection = isExpanded ? nil : section
                    }
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Theme.accent.opacity(0.12))
                            .frame(width: 40, height: 40)
                        Image(systemName: section.icon)
                            .foregroundStyle(Theme.accent).font(.system(size: 16))
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(section.rawValue).font(.headline).foregroundStyle(Theme.textPrimary)
                        Text(section.subtitle).font(.caption).foregroundStyle(Theme.textSecondary)
                        Text(section.meta).font(.system(size: 10, weight: .medium)).foregroundStyle(Theme.textTertiary)
                    }
                    Spacer()
                    if section == .calculator {
                        Text("Free")
                            .font(.system(size: 10, weight: .bold)).foregroundStyle(Theme.accent)
                            .padding(.horizontal, 7).padding(.vertical, 3)
                            .background(Theme.accent.opacity(0.12)).clipShape(Capsule())
                        Image(systemName: "chevron.right").font(.caption).foregroundStyle(Theme.textTertiary)
                    } else {
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.semibold)).foregroundStyle(Theme.textTertiary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(.spring(response: 0.3), value: isExpanded)
                    }
                }
                .padding(16)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider().background(Theme.border).padding(.horizontal, 16)
                if section == .testPrep {
                    testPrepRows.transition(.opacity.combined(with: .move(edge: .top)))
                } else if section == .planningGuides {
                    planningGuideRows.transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isExpanded ? Theme.accent.opacity(0.3) : Theme.border, lineWidth: 1))
    }

    private var testPrepRows: some View {
        VStack(spacing: 0) {
            ForEach(Array(TestPrepDatabase.all.enumerated()), id: \.element.id) { index, roadmap in
                if index > 0 { Divider().background(Theme.border).padding(.leading, 54) }
                Button {
                    if store.isPremium { selectedRoadmap = roadmap }
                    else { showPaywall = true }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: roadmap.icon)
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.accent)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(roadmap.examName).font(.subheadline)
                                .foregroundStyle(store.isPremium ? Theme.textPrimary : Theme.textSecondary)
                            Text(roadmap.whoNeedsIt).font(.caption).foregroundStyle(Theme.textTertiary).lineLimit(1)
                        }
                        Spacer()
                        if !store.isPremium {
                            Image(systemName: "lock.fill").font(.caption).foregroundStyle(Theme.textTertiary)
                        } else {
                            Image(systemName: "chevron.right").font(.caption).foregroundStyle(Theme.textTertiary)
                        }
                    }
                    .padding(.horizontal, 16).padding(.vertical, 13)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var planningGuideRows: some View {
        VStack(spacing: 0) {
            guideRow(icon: "star.fill", title: "Scholarship Strategy", subtitle: "FAFSA, state aid, and how to win scholarships", isFree: true) { showScholarship = true }
            Divider().background(Theme.border).padding(.leading, 54)
            guideRow(icon: "building.columns.fill", title: "How to Pick a Program", subtitle: "10 things to evaluate before choosing a school", isFree: true) { showProgramPicker = true }
            Divider().background(Theme.border).padding(.leading, 54)
            guideRow(icon: "checklist", title: "Application Checklist", subtitle: "Full timeline from 12 months out to day one", isFree: true) { showAppChecklist = true }
        }
    }

    private func guideRow(icon: String, title: String, subtitle: String, isFree: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon).font(.system(size: 16)).foregroundStyle(Theme.accent).frame(width: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.subheadline).foregroundStyle(Theme.textPrimary)
                    Text(subtitle).font(.caption).foregroundStyle(Theme.textTertiary).lineLimit(1)
                }
                Spacer()
                if isFree {
                    Text("FREE").font(.system(size: 10, weight: .bold)).foregroundStyle(Theme.accent)
                        .padding(.horizontal, 7).padding(.vertical, 3)
                        .background(Theme.accent.opacity(0.12)).clipShape(Capsule())
                }
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(Theme.textTertiary)
            }
            .padding(.horizontal, 16).padding(.vertical, 13)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
