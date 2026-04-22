import SwiftUI

struct ApplicationChecklistView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var expanded: Int? = 0
    @State private var checked: Set<String> = Self.loadChecked()

    private static let storageKey = "degreeAppChecklist"

    private struct ChecklistItem: Identifiable {
        let id: String
        let text: String
    }

    private struct Section: Identifiable {
        let id: Int
        let icon: String
        let title: String
        let items: [ChecklistItem]
    }

    private let sections: [Section] = [
        .init(id: 0, icon: "calendar", title: "12 Months Before", items: [
            .init(id: "m12-1", text: "Research 8–12 target schools across a range of selectivity"),
            .init(id: "m12-2", text: "Calculate debt-to-salary ratio for each program (use the ROI Calculator)"),
            .init(id: "m12-3", text: "Register for the SAT or ACT"),
            .init(id: "m12-4", text: "Build your school list: 3 reach, 4 match, 3 safety"),
            .init(id: "m12-5", text: "Start a tracking spreadsheet (deadlines, requirements, fees)"),
            .init(id: "m12-6", text: "Create a Common App account at commonapp.org"),
            .init(id: "m12-7", text: "Request 2 letters of recommendation from teachers or mentors")
        ]),
        .init(id: 1, icon: "pencil.and.outline", title: "8–10 Months Before", items: [
            .init(id: "m8-1", text: "Retake the SAT or ACT if needed to hit your target score"),
            .init(id: "m8-2", text: "Begin drafting your personal statement (Common App essay)"),
            .init(id: "m8-3", text: "Research each school's supplemental essay requirements"),
            .init(id: "m8-4", text: "Visit campuses (in-person or virtual tours)"),
            .init(id: "m8-5", text: "Check Early Decision and Early Action deadlines (usually Nov 1)"),
            .init(id: "m8-6", text: "Research scholarship deadlines and build a second tracking list")
        ]),
        .init(id: 2, icon: "doc.text.fill", title: "October 1 — File FAFSA", items: [
            .init(id: "fafsa-1", text: "File FAFSA at studentaid.gov as early as possible (opens Oct 1)"),
            .init(id: "fafsa-2", text: "Have prior-year tax return and financial info ready"),
            .init(id: "fafsa-3", text: "Finalize your personal statement — final proofread"),
            .init(id: "fafsa-4", text: "Complete supplemental essays for your top 3 schools")
        ]),
        .init(id: 3, icon: "paperplane.fill", title: "Regular Decision Deadlines", items: [
            .init(id: "rd-1", text: "Submit all applications (most due January 1 or January 15)"),
            .init(id: "rd-2", text: "Request official transcripts sent to each school"),
            .init(id: "rd-3", text: "Confirm all letters of recommendation have been submitted"),
            .init(id: "rd-4", text: "Verify all application fees are paid (or waiver approved)"),
            .init(id: "rd-5", text: "Apply to every scholarship on your list (don't skip small ones)")
        ]),
        .init(id: 4, icon: "checkmark.seal.fill", title: "After Decisions Arrive", items: [
            .init(id: "after-1", text: "Compare financial aid award letters side by side"),
            .init(id: "after-2", text: "Calculate real cost: tuition + fees + housing − all aid"),
            .init(id: "after-3", text: "Contact financial aid offices to negotiate better packages"),
            .init(id: "after-4", text: "Accept your chosen school's offer (deposit usually due May 1)"),
            .init(id: "after-5", text: "Notify schools you are declining"),
            .init(id: "after-6", text: "Complete housing application before the deadline")
        ])
    ]

    private var totalItems: Int { sections.reduce(0) { $0 + $1.items.count } }
    private var completedItems: Int { checked.count }
    private var progress: Double { totalItems == 0 ? 0 : Double(completedItems) / Double(totalItems) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    progressHeader
                    ForEach(sections) { section in
                        sectionCard(section)
                    }
                    Color.clear.frame(height: 30)
                }
                .padding(.horizontal, sizeClass == .regular ? 40 : 16)
                .padding(.top, 12)
            }
            .background(Theme.background)
            .navigationTitle("Application Checklist")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.accent)
                        .frame(minWidth: 44, minHeight: 44)
                }
            }
        }
    }

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Your Progress").font(.subheadline).foregroundStyle(Theme.textSecondary)
                Spacer()
                Text("\(completedItems) of \(totalItems)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.cardBackgroundLight).frame(height: 8)
                    Capsule().fill(Theme.accent).frame(width: geo.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.border, lineWidth: 1))
    }

    private func sectionCard(_ section: Section) -> some View {
        let isExpanded = expanded == section.id
        let sectionCompleted = section.items.filter { checked.contains($0.id) }.count

        return VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    expanded = isExpanded ? nil : section.id
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Theme.accent.opacity(0.12))
                            .frame(width: 40, height: 40)
                        Image(systemName: section.icon).foregroundStyle(Theme.accent).font(.system(size: 15))
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(section.title).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.textPrimary)
                        Text("\(sectionCompleted) of \(section.items.count) complete")
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                    }
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
                VStack(spacing: 0) {
                    ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                        if index > 0 { Divider().background(Theme.border).padding(.leading, 44) }
                        checklistRow(item)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isExpanded ? Theme.accent.opacity(0.3) : Theme.border, lineWidth: 1))
    }

    private func checklistRow(_ item: ChecklistItem) -> some View {
        let isChecked = checked.contains(item.id)
        return Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                if isChecked { checked.remove(item.id) } else { checked.insert(item.id) }
                persist()
            }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isChecked ? Theme.accent : Theme.textTertiary)
                Text(item.text)
                    .font(.footnote)
                    .foregroundStyle(isChecked ? Theme.textTertiary : Theme.textPrimary)
                    .strikethrough(isChecked, color: Theme.textTertiary)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16).padding(.vertical, 12)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func persist() {
        UserDefaults.standard.set(Array(checked), forKey: Self.storageKey)
    }

    private static func loadChecked() -> Set<String> {
        let arr = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        return Set(arr)
    }
}
