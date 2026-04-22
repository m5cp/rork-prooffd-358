import Foundation

nonisolated enum WinType: String, CaseIterable, Identifiable, Sendable {
    case sentFirstMessage    = "Sent my first outreach message"
    case gotFirstInquiry     = "Got my first client inquiry"
    case completedFirstJob   = "Completed my first paid job"
    case registeredBusiness  = "Registered or filed my business"
    case openedBankAccount   = "Opened a business bank account"
    case earnedFirst100      = "Made my first $100"
    case earnedFirst500      = "Made my first $500"
    case earnedFirst1000     = "Made my first $1,000"
    case contactedProgram    = "Contacted an apprenticeship or program"
    case appliedToProgram    = "Applied to a training program"
    case passedCertExam      = "Passed a certification exam"
    case boughtTools         = "Bought my first professional tools"
    case startedTraining     = "Started training or apprenticeship"
    case gotFirstTradeJob    = "Got my first job in the trade"
    case filedFAFSA          = "Filed my FAFSA"
    case tookEntranceExam    = "Took my entrance exam"
    case submittedApp        = "Submitted my application"
    case gotAccepted         = "Got accepted to a program"
    case enrolled            = "Enrolled in classes"
    case completedSemester   = "Completed my first semester"
    case madeDecision        = "Made a decision about my path"
    case toldSomeone         = "Told someone about my plan"
    case completedActionPlan = "Finished my 7-day action plan"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .sentFirstMessage, .toldSomeone:    return "envelope.fill"
        case .gotFirstInquiry:                   return "bell.fill"
        case .completedFirstJob, .completedSemester: return "checkmark.seal.fill"
        case .registeredBusiness:                return "building.2.fill"
        case .openedBankAccount:                 return "building.columns.fill"
        case .earnedFirst100, .earnedFirst500,
             .earnedFirst1000:                   return "dollarsign.circle.fill"
        case .contactedProgram, .appliedToProgram: return "phone.fill"
        case .passedCertExam:                    return "rosette"
        case .boughtTools:                       return "wrench.and.screwdriver.fill"
        case .startedTraining:                   return "figure.walk"
        case .gotFirstTradeJob:                  return "hammer.fill"
        case .filedFAFSA:                        return "doc.text.fill"
        case .tookEntranceExam:                  return "pencil.and.ruler.fill"
        case .submittedApp:                      return "paperplane.fill"
        case .gotAccepted:                       return "star.fill"
        case .enrolled:                          return "graduationcap.fill"
        case .madeDecision:                      return "flag.fill"
        case .completedActionPlan:               return "calendar.badge.checkmark"
        }
    }

    var category: CommittedPathType? {
        switch self {
        case .sentFirstMessage, .gotFirstInquiry, .completedFirstJob,
             .registeredBusiness, .openedBankAccount, .earnedFirst100,
             .earnedFirst500, .earnedFirst1000:
            return .business
        case .contactedProgram, .appliedToProgram, .passedCertExam,
             .boughtTools, .startedTraining, .gotFirstTradeJob:
            return .trade
        case .filedFAFSA, .tookEntranceExam, .submittedApp,
             .gotAccepted, .enrolled, .completedSemester:
            return .degree
        case .madeDecision, .toldSomeone, .completedActionPlan:
            return nil
        }
    }
}
