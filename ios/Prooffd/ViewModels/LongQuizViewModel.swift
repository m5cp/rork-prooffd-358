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
        }
    }

    func next() {
        guard canAdvance else { return }
        if currentQuestion < totalQuestions - 1 {
            currentQuestion += 1
        } else {
            isComplete = true
        }
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
    }
}
