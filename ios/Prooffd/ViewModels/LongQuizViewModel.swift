import SwiftUI

@Observable
class LongQuizViewModel {
    var currentQuestion: Int = 0
    var isComplete: Bool = false

    var selectedEnvironments: [WorkEnvironment] = []
    var sellingComfort: SellingComfort?
    var hasCar: Bool?
    var techComfort: TechComfort?
    var workStyle: WorkStyle?
    var experienceLevel: ExperienceLevel?
    var customerInteraction: CustomerInteraction?
    var needsFastCash: Bool?
    var thingsToAvoid: [ThingToAvoid] = []
    var hasPhysicalLimitation: Bool?
    var learningStyle: LearningStyle?
    var incomeTarget: IncomeTarget?
    var aiConcern: AIConcern?
    var riskTolerance: RiskTolerance?
    var growthAmbition: GrowthAmbition?
    var credentialAppetite: CredentialAppetite?
    var scheduleShape: ScheduleShape?
    var clientType: ClientType?
    var militaryInterest: MilitaryInterest?
    var militaryEligibility: MilitaryEligibility?

    let totalQuestions = LongQuizQuestion.allCases.count

    var progress: Double {
        Double(currentQuestion) / Double(totalQuestions)
    }

    var currentQ: LongQuizQuestion {
        LongQuizQuestion(rawValue: currentQuestion) ?? .workEnvironments
    }

    var canAdvance: Bool {
        switch currentQ {
        case .workEnvironments:    return !selectedEnvironments.isEmpty
        case .sellingComfort:      return sellingComfort != nil
        case .hasCar:              return hasCar != nil
        case .techComfort:         return techComfort != nil
        case .workStyle:           return workStyle != nil
        case .experienceLevel:     return experienceLevel != nil
        case .customerInteraction: return customerInteraction != nil
        case .needsFastCash:       return needsFastCash != nil
        case .thingsToAvoid:       return !thingsToAvoid.isEmpty
        case .physicalLimitation:  return hasPhysicalLimitation != nil
        case .learningStyle:       return learningStyle != nil
        case .incomeTarget:        return incomeTarget != nil
        case .aiConcern:           return aiConcern != nil
        case .riskTolerance:       return riskTolerance != nil
        case .growthAmbition:      return growthAmbition != nil
        case .credentialAppetite:  return credentialAppetite != nil
        case .scheduleShape:       return scheduleShape != nil
        case .clientType:          return clientType != nil
        case .militaryInterest:    return militaryInterest != nil
        case .militaryEligibility: return militaryEligibility != nil
        }
    }

    /// Eligibility is only worth asking if the person is open to serving.
    private var skipsEligibility: Bool {
        militaryInterest == .notForMe
    }

    func next() {
        guard canAdvance else { return }
        // Someone who ruled out service shouldn't be asked their age and
        // citizenship for a path they'll never see.
        if currentQ == .militaryInterest, skipsEligibility {
            militaryEligibility = nil
            isComplete = true
            return
        }
        if currentQuestion < totalQuestions - 1 {
            currentQuestion += 1
        } else {
            isComplete = true
        }
    }

    /// True when the current question is the last one this user will be shown.
    var isOnFinalQuestion: Bool {
        if currentQ == .militaryInterest, skipsEligibility { return true }
        return currentQuestion == totalQuestions - 1
    }

    func previous() {
        if currentQuestion > 0 { currentQuestion -= 1 }
    }

    func applyToProfile(_ profile: inout UserProfile) {
        if !selectedEnvironments.isEmpty {
            profile.workEnvironments = selectedEnvironments
        }
        if let v = sellingComfort      { profile.sellingComfort = v }
        if let v = hasCar              { profile.hasCar = v }
        if let v = techComfort         { profile.techComfort = v }
        if let v = workStyle           { profile.workStyle = v }
        if let v = experienceLevel     { profile.experienceLevel = v }
        if let v = customerInteraction { profile.customerInteraction = v }
        if let v = needsFastCash       { profile.needsFastCash = v }
        if !thingsToAvoid.isEmpty      { profile.thingsToAvoid = thingsToAvoid }
        if let v = hasPhysicalLimitation { profile.hasPhysicalLimitation = v }
        if let v = learningStyle       { profile.learningStyle = v }
        if let v = incomeTarget        { profile.incomeTarget = v }
        if let v = aiConcern           { profile.aiConcern = v }
        if let v = riskTolerance       { profile.riskTolerance = v }
        if let v = growthAmbition      { profile.growthAmbition = v }
        if let v = credentialAppetite  { profile.credentialAppetite = v }
        if let v = scheduleShape       { profile.scheduleShape = v }
        if let v = clientType          { profile.clientType = v }
        if let v = militaryInterest    { profile.militaryInterest = v }
        // Deliberately assigned even when nil: someone who switches to "not for
        // me" on a retake must clear a stale eligibility answer.
        profile.militaryEligibility = militaryEligibility

        // Keep education willingness in sync with how this person actually
        // learns, so the matcher's education term reflects the long quiz.
        if let style = learningStyle, profile.educationWillingnesses.isEmpty {
            profile.educationWillingnesses = [style.preferredEducation]
        }
        // A stated appetite for credentials outranks a cautious education
        // answer given earlier in onboarding.
        if credentialAppetite == .happyTo,
           !profile.educationWillingnesses.contains(.tradeSchool),
           !thingsToAvoid.contains(.longEducation) {
            profile.educationWillingnesses.append(.tradeSchool)
        }

        // Evenings-and-weekends people cannot realistically run a path that
        // demands a full day, so cap the hours expectation.
        if scheduleShape == .eveningsWeekends, profile.hoursPerDay == nil {
            profile.hoursPerDay = .oneToTwo
        }

        if thingsToAvoid.contains(.longEducation) {
            profile.educationWillingnesses.removeAll { $0 == .fourYear || $0 == .twoYear }
            if profile.educationWillingnesses.isEmpty {
                profile.educationWillingnesses = [.shortCert]
            }
        }
    }

    func loadFromProfile(_ profile: UserProfile) {
        selectedEnvironments = profile.workEnvironments
        sellingComfort = profile.sellingComfort
        hasCar = profile.hasCar
        techComfort = profile.techComfort
        workStyle = profile.workStyle
        experienceLevel = profile.experienceLevel
        customerInteraction = profile.customerInteraction
        needsFastCash = profile.needsFastCash
        thingsToAvoid = profile.thingsToAvoid
        hasPhysicalLimitation = profile.hasPhysicalLimitation
        learningStyle = profile.learningStyle
        incomeTarget = profile.incomeTarget
        aiConcern = profile.aiConcern
        riskTolerance = profile.riskTolerance
        growthAmbition = profile.growthAmbition
        credentialAppetite = profile.credentialAppetite
        scheduleShape = profile.scheduleShape
        clientType = profile.clientType
        militaryInterest = profile.militaryInterest
        militaryEligibility = profile.militaryEligibility
    }
}
