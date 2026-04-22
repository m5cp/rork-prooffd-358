import Foundation

enum MilestoneGenerator {

    static func milestones(for type: CommittedPathType,
                           pathName: String) -> [PathMilestone] {
        switch type {
        case .business:
            return businessMilestones(pathName: pathName)
        case .trade:
            return tradeMilestones(pathName: pathName)
        case .degree:
            return degreeMilestones(pathName: pathName)
        }
    }

    private static func businessMilestones(pathName: String) -> [PathMilestone] {
        [
            PathMilestone(id: "b1", title: "Research \(pathName) in your local area",
                          category: .research),
            PathMilestone(id: "b2", title: "Identify 3 potential first customers",
                          category: .research),
            PathMilestone(id: "b3", title: "Register your business or set up your LLC",
                          category: .setup),
            PathMilestone(id: "b4", title: "Open a dedicated business bank account",
                          category: .financial),
            PathMilestone(id: "b5", title: "Send your first outreach message",
                          category: .action),
            PathMilestone(id: "b6", title: "Complete your first paid job or service",
                          category: .action),
            PathMilestone(id: "b7", title: "Earn your first $500",
                          category: .milestone),
            PathMilestone(id: "b8", title: "Earn your first $1,000",
                          category: .milestone)
        ]
    }

    private static func tradeMilestones(pathName: String) -> [PathMilestone] {
        [
            PathMilestone(id: "t1", title: "Research \(pathName) programs in your area",
                          category: .research),
            PathMilestone(id: "t2", title: "Understand licensing requirements in your state",
                          category: .research),
            PathMilestone(id: "t3", title: "Contact an apprenticeship or training program",
                          category: .action),
            PathMilestone(id: "t4", title: "Plan your training budget and funding",
                          category: .financial),
            PathMilestone(id: "t5", title: "Purchase your starter tool kit",
                          category: .setup),
            PathMilestone(id: "t6", title: "Apply to or enroll in a training program",
                          category: .training),
            PathMilestone(id: "t7", title: "Complete your first day of training",
                          category: .training),
            PathMilestone(id: "t8", title: "Get your first paid job in the trade",
                          category: .milestone)
        ]
    }

    private static func degreeMilestones(pathName: String) -> [PathMilestone] {
        [
            PathMilestone(id: "d1", title: "Research programs that match your \(pathName) goal",
                          category: .research),
            PathMilestone(id: "d2", title: "File your FAFSA at studentaid.gov",
                          category: .financial),
            PathMilestone(id: "d3", title: "Take your entrance exam (SAT / ACT / GRE / GMAT)",
                          category: .action),
            PathMilestone(id: "d4", title: "Submit your application",
                          category: .action),
            PathMilestone(id: "d5", title: "Receive your acceptance letter",
                          category: .milestone),
            PathMilestone(id: "d6", title: "Compare financial aid offers",
                          category: .financial),
            PathMilestone(id: "d7", title: "Accept your offer and pay your deposit",
                          category: .setup),
            PathMilestone(id: "d8", title: "Complete your first semester",
                          category: .milestone)
        ]
    }
}
