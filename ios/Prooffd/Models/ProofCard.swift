import Foundation

nonisolated struct ProofCard: Identifiable, Sendable {
    let id: String
    let name: String
    let cityState: String
    let pathName: String
    let quote: String
}

enum ProofCardDatabase {
    static let all: [ProofCard] = [
        ProofCard(id: "1", name: "Marcus", cityState: "Dallas, TX",
            pathName: "Lawn Care & Landscaping",
            quote: "I took the quiz on a Tuesday. By Friday I had my LLC filed and my first client. Month 3 I hit $4,100. This app made me stop overthinking and start moving."),
        ProofCard(id: "2", name: "Priya", cityState: "Atlanta, GA",
            pathName: "Bookkeeping & Financial Services",
            quote: "I was laid off in March. Prooffd matched me with virtual bookkeeping. I completed my QuickBooks cert in 6 weeks and had 3 clients before I would have even started a traditional job search."),
        ProofCard(id: "3", name: "Devon", cityState: "Cleveland, OH",
            pathName: "Electrician Apprenticeship",
            quote: "Nobody in my family went to a 4-year school. I am in my second year of my apprenticeship making $26 per hour with full benefits. Four years from now I will be a journeyman making $40 plus."),
        ProofCard(id: "4", name: "Renee", cityState: "Phoenix, AZ",
            pathName: "Esthetician License",
            quote: "I have worked office jobs my whole career and dreaded every Monday. Prooffd showed me I was an 89 percent match for esthetics. I finished my 600-hour program and now I set my own schedule."),
        ProofCard(id: "5", name: "Carlos", cityState: "San Antonio, TX",
            pathName: "HVAC Technician",
            quote: "I was going to go to a 4-year school just because everyone said to. The ROI calculator showed me the real numbers. HVAC matched me at 91 percent. I start my apprenticeship next month."),
        ProofCard(id: "6", name: "Tamara", cityState: "Chicago, IL",
            pathName: "Registered Nursing",
            quote: "Single mom, working full time. Prooffd showed me the step-by-step path — CNA first, then RN bridge program while working. Best decision I ever made."),
        ProofCard(id: "7", name: "James", cityState: "Nashville, TN",
            pathName: "Mobile Detailing Business",
            quote: "Lost my logistics job to automation. First month detailing: $2,800. Six months in: consistent $6,000 plus per month."),
        ProofCard(id: "8", name: "Sofia", cityState: "Denver, CO",
            pathName: "Cybersecurity / CompTIA",
            quote: "Everyone told me I needed a CS degree. Prooffd showed me the cert path. I got my first IT job eight months after starting. Starting salary: $58,000.")
    ]
}
