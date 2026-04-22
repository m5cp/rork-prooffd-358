import SwiftUI

struct HowToPickProgramView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var expanded: Int? = 0

    private struct Item: Identifiable {
        let id: Int
        let title: String
        let body: String
    }

    private let items: [Item] = [
        .init(id: 0, title: "Accreditation",
              body: """
Accreditation is non-negotiable. Credits from an unaccredited school usually do not transfer, and employers often will not recognize the degree.

• Verify at db.ed.gov — the official U.S. Department of Education database
• Regional accreditation is stronger than national — always prefer regionally accredited schools
• For specific fields, check field-specific accreditation: ABET (engineering), CCNE (nursing), ABA (law), AACSB (business)

If you cannot confirm accreditation, move on.
"""),
        .init(id: 1, title: "Graduation Rate",
              body: """
A low graduation rate is a red flag. It means most students who enroll do not finish.

• Look up any school at collegescorecard.ed.gov
• Target 50%+ graduation rate for most 4-year programs
• For community colleges, look at transfer-out and completion rates combined
• Very low rates (under 30%) signal systemic problems — students not getting support, advising, or funding
"""),
        .init(id: 2, title: "Post-Graduation Salary Data",
              body: """
Real salary data is public — use it.

• collegescorecard.ed.gov shows median earnings 1, 5, and 10 years after graduation
• Data is broken down by program, not just school — a nursing degree from School A can pay more than a business degree from School B
• Compare programs at multiple schools before committing
• If a program's 5-year median earnings are lower than the regional median wage, question the ROI
"""),
        .init(id: 3, title: "Debt vs Salary",
              body: """
The single most important financial rule of college: total debt should not exceed your expected first-year salary.

• Use the ROI Calculator in this app to model your specific numbers
• If a program will leave you with $80,000 in debt and a $45,000 starting salary, find a cheaper path to the same career
• Public in-state schools and community college transfers often deliver the same outcome at half the cost
"""),
        .init(id: 4, title: "Program Reputation",
              body: """
Reputation matters more in some fields than others.

• High-reputation fields: investment banking, corporate law, top-tier consulting, elite medical specialties
• Lower-reputation sensitivity: engineering, nursing, teaching, accounting, most trades
• Look at LinkedIn: where do graduates of this program actually work?
• Talk to 2–3 alumni on LinkedIn before committing — most are happy to answer a polite message
"""),
        .init(id: 5, title: "Class Size and Faculty Access",
              body: """
The size of the school matters less than the size of the classes you will actually take.

• Large state schools can have intro classes of 300+ students
• Small private and honors programs may cap at 25
• Ask: what is the average class size in my upper-level major courses?
• Ask: is it possible to get research or mentorship from faculty?
• More faculty access = stronger recommendation letters for jobs and grad school
"""),
        .init(id: 6, title: "Career Services Quality",
              body: """
A strong career services office can be worth more than a better-ranked school.

• Ask: what percentage of graduates have a full-time job within 6 months?
• Ask: what is the career services student-to-counselor ratio?
• Ask: what major employers actively recruit on campus?
• Look for internship placement rates — a strong internship pipeline is a huge advantage
"""),
        .init(id: 7, title: "Location and Job Market",
              body: """
Most new graduates take their first job in or near where they went to school. Choose location strategically.

• Regional schools build regional professional networks
• Consider local industry strength — Austin and Raleigh for tech, NYC for finance, Nashville for healthcare, Houston for energy
• Cost of living during school and after graduation both affect your net outcome
• A cheaper school in a city with a weak job market can be worse than a pricier school in a strong one
"""),
        .init(id: 8, title: "Online vs In-Person",
              body: """
Online programs have closed much of the prestige gap — but not all of it.

Pros of online: Lower cost, flexibility, keep working while studying, no relocation
Cons of online: Weaker peer networks, some employers still discount heavily, harder to build faculty relationships

• Hybrid programs are increasingly respected
• For technical fields (engineering, healthcare), in-person labs still matter
• For business, tech, and education, strong online programs are widely accepted
"""),
        .init(id: 9, title: "Transfer Credits and Prior Learning",
              body: """
Cut time and cost dramatically by not starting from zero.

• Community college credits often transfer to 4-year schools — verify transfer agreements before enrolling
• Military training, CLEP exams, and AP credits all count
• Some schools offer Prior Learning Assessment (PLA) that awards credit for professional certifications and work experience
• Ask every school on your list: "How many credits will transfer, and how much does it reduce my time and cost?"
""")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(items) { item in
                        itemCard(item)
                    }
                    Color.clear.frame(height: 30)
                }
                .padding(.horizontal, sizeClass == .regular ? 40 : 16)
                .padding(.top, 12)
            }
            .background(Theme.background)
            .navigationTitle("How to Pick a Program")
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

    private func itemCard(_ item: Item) -> some View {
        let isExpanded = expanded == item.id
        return VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    expanded = isExpanded ? nil : item.id
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Theme.accent.opacity(0.12))
                            .frame(width: 40, height: 40)
                        Text("\(item.id + 1)")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.accent)
                    }
                    Text(item.title)
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
                Text(item.body)
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
