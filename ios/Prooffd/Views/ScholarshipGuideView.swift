import SwiftUI

struct ScholarshipGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var expanded: Int? = 0

    private struct Section: Identifiable {
        let id: Int
        let icon: String
        let title: String
        let body: String
    }

    private let sections: [Section] = [
        .init(id: 0, icon: "doc.text.fill", title: "Step 1: Start with FAFSA",
              body: """
FAFSA is the Free Application for Federal Student Aid — the single most important financial aid form you will ever fill out. File it at studentaid.gov.

Why it matters:
• Unlocks the Pell Grant (up to $7,395/year — free money, never repaid)
• Unlocks federal student loans with the lowest rates
• Required by most state and institutional aid programs

File as early as possible each October 1. Many state and school programs award aid on a first-come, first-served basis — applying late can cost you thousands.
""") ,
        .init(id: 1, icon: "map.fill", title: "Step 2: State Aid Programs",
              body: """
Every state has its own scholarship and grant programs for in-state students. Many are based on need or academic merit; some are lottery-funded.

How to find them:
• Search "[YOUR STATE] state scholarship" or "[YOUR STATE] higher education commission"
• Most require your FAFSA to be submitted first
• Examples: Cal Grant (CA), HOPE Scholarship (GA), TAP (NY), Bright Futures (FL), TEXAS Grant (TX)

State aid is often the second-largest source of free money for in-state students, after Pell.
"""),
        .init(id: 2, icon: "building.columns.fill", title: "Step 3: Your School's Aid Office",
              body: """
Schools have their own institutional scholarships — separate from federal and state aid. This is negotiable money.

Action steps:
• Contact the financial aid office directly after you are admitted
• Ask what institutional scholarships you still qualify for
• Honors programs often include automatic funding — apply for them
• If you receive a better aid offer from another school, some schools will match or increase yours. It never hurts to ask politely.
"""),
        .init(id: 3, icon: "magnifyingglass", title: "Step 4: Scholarship Databases",
              body: """
Free databases that match your profile to thousands of scholarships:

• Fastweb.com
• Scholarships.com
• Cappex.com
• Bold.org
• Scholly (app)
• Niche.com/scholarships

Create a complete profile on 2–3 of these. The more details you add, the better your matches. Set aside 30 minutes a week to apply.
"""),
        .init(id: 4, icon: "person.2.fill", title: "Step 5: Niche Scholarships",
              body: """
The biggest national scholarships have thousands of applicants. Niche scholarships have far fewer — and much better odds.

Where to look:
• Local community foundations (search "[YOUR CITY] community foundation scholarships")
• Your parents' employers — many companies fund employee-family scholarships
• Union scholarships (if family is in a trade)
• Professional associations in your target field
• Minority-specific, religion-specific, and heritage-specific scholarships
• Major-specific scholarships (nursing, engineering, teaching, etc.)
"""),
        .init(id: 5, icon: "pencil.and.outline", title: "Step 6: Essay Tips",
              body: """
The essay is often what wins the scholarship.

• Answer the specific question asked — read it twice
• Tell a real story with specific, concrete details
• Show growth, resilience, or a turning point
• Connect your story to your goals and to the scholarship's mission
• Proofread out loud, then get a second set of eyes
• Stay within the word count — going over signals that you cannot follow directions

A strong 400-word essay beats a rambling 800-word one every time.
"""),
        .init(id: 6, icon: "chart.bar.fill", title: "Step 7: Realistic Expectations",
              body: """
Scholarships are a numbers game. Plan accordingly.

• Apply to 10–15 scholarships to win 1–3
• Smaller local scholarships ($500–$2,000) have far less competition — start there
• Reuse and adapt essays across applications instead of writing each from scratch
• Block 2–4 hours per week and treat it like a part-time job
• Track deadlines in a spreadsheet or calendar

Ten $1,000 wins is $10,000 in free money. Consistency beats intensity.
""")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(sections) { section in
                        sectionCard(section)
                    }
                    Color.clear.frame(height: 30)
                }
                .padding(.horizontal, sizeClass == .regular ? 40 : 16)
                .padding(.top, 12)
            }
            .background(Theme.background)
            .navigationTitle("Scholarship Strategy")
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

    private func sectionCard(_ section: Section) -> some View {
        let isExpanded = expanded == section.id
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
                    Text(section.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.leading)
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
                Text(section.body)
                    .font(.footnote)
                    .foregroundStyle(Theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isExpanded ? Theme.accent.opacity(0.3) : Theme.border, lineWidth: 1))
    }
}
