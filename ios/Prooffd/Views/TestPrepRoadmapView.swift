import SwiftUI

struct TestPrepRoadmapView: View {
    let roadmap: TestPrepRoadmap

    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass

    enum PrepCard: String, CaseIterable {
        case overview, studyPlan, free, paid
        var title: String {
            switch self {
            case .overview:  return "Overview"
            case .studyPlan: return "Study Plan"
            case .free:      return "Free Resources"
            case .paid:      return "Paid Resources"
            }
        }
        var icon: String {
            switch self {
            case .overview:  return "info.circle.fill"
            case .studyPlan: return "calendar"
            case .free:      return "gift.fill"
            case .paid:      return "creditcard.fill"
            }
        }
    }

    @State private var expanded: PrepCard? = .overview
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(PrepCard.allCases, id: \.self) { card in
                        sectionCard(card)
                    }
                    retakePolicyBlock
                    Color.clear.frame(height: 30)
                }
                .padding(.horizontal, sizeClass == .regular ? 40 : 16)
                .padding(.top, 12)
            }
            .background(Theme.background)
            .navigationTitle(roadmap.examName)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.accent)
                        .frame(minWidth: 44, minHeight: 44)
                }
            }
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }

    private func sectionCard(_ card: PrepCard) -> some View {
        let isExpanded = expanded == card
        return VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    expanded = isExpanded ? nil : card
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Theme.accent.opacity(0.12))
                            .frame(width: 40, height: 40)
                        Image(systemName: card.icon).foregroundStyle(Theme.accent).font(.system(size: 15))
                    }
                    Text(card.title).font(.headline).foregroundStyle(Theme.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.textTertiary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.spring(response: 0.3), value: isExpanded)
                }
                .padding(16)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider().background(Theme.border).padding(.horizontal, 16)
                Group {
                    switch card {
                    case .overview:  overviewContent
                    case .studyPlan: studyPlanContent
                    case .free:      freeContent
                    case .paid:      paidContent
                    }
                }
                .padding(16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isExpanded ? Theme.accent.opacity(0.3) : Theme.border, lineWidth: 1))
    }

    private var overviewContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            infoRow(label: "Who needs it",     value: roadmap.whoNeedsIt)
            infoRow(label: "Register at",      value: roadmap.registrationURL)
            infoRow(label: "Typical cost",     value: roadmap.typicalCost)
            infoRow(label: "Score range",      value: roadmap.scoreRange)
            infoRow(label: "Target scores",    value: roadmap.targetScores)
            infoRow(label: "Format",           value: roadmap.format)
        }
    }

    private var studyPlanContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(roadmap.studyPhases.enumerated()), id: \.element.id) { index, phase in
                if index == 0 || store.isPremium {
                    phaseBlock(phase, locked: false)
                } else if index == 1 && !store.isPremium {
                    paywallBanner
                    phaseBlock(phase, locked: true)
                } else {
                    phaseBlock(phase, locked: true)
                }
            }
        }
    }

    private func phaseBlock(_ phase: StudyPhase, locked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(phase.weekRange.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.accent)
                Spacer()
                if locked {
                    Image(systemName: "lock.fill").font(.caption).foregroundStyle(Theme.textTertiary)
                } else {
                    Text("\(phase.hoursPerWeek) hrs/wk")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            Text(phase.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(locked ? Theme.textTertiary : Theme.textPrimary)
            Text(locked ? "Unlock Pro to see this phase." : phase.description)
                .font(.footnote)
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(locked ? 1 : nil)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackgroundLight)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var paywallBanner: some View {
        Button { showPaywall = true } label: {
            HStack(spacing: 10) {
                Image(systemName: "lock.fill").foregroundStyle(.white)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Unlock full study plan").font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                    Text("All phases, timelines, and drills").font(.caption).foregroundStyle(.white.opacity(0.85))
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.white.opacity(0.9))
            }
            .padding(14)
            .background(
                LinearGradient(colors: [Theme.accent, Theme.accent.opacity(0.85)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private var freeContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(roadmap.freeResources, id: \.self) { item in
                bulletRow(item)
            }
        }
    }

    @ViewBuilder
    private var paidContent: some View {
        if store.isPremium {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(roadmap.paidResources, id: \.self) { item in
                    bulletRow(item)
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 12) {
                paywallBanner
                Text("Vetted paid prep courses and books. Unlock Pro to see recommendations.")
                    .font(.footnote)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
    }

    private func bulletRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle().fill(Theme.accent).frame(width: 6, height: 6).padding(.top, 6)
            Text(text).font(.footnote).foregroundStyle(Theme.textPrimary)
            Spacer(minLength: 0)
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(Theme.textTertiary)
            Text(value)
                .font(.footnote)
                .foregroundStyle(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var retakePolicyBlock: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "arrow.counterclockwise").foregroundStyle(Theme.accentBlue).font(.footnote)
            VStack(alignment: .leading, spacing: 4) {
                Text("Retake Policy")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textSecondary)
                Text(roadmap.retakePolicy)
                    .font(.footnote)
                    .foregroundStyle(Theme.textPrimary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackgroundLight)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
