import SwiftUI

@Observable
class OnboardingViewModel {
    var currentStep: Int = 0
    var direction: Edge = .trailing
    var appeared: Bool = false

    var chosenPath: ChosenPath?
    var workPreference: WorkPreference?
    var workEnvironments: [WorkEnvironment] = []
    var workConditions: [WorkCondition] = []
    var budget: BudgetRange?
    var hoursPerDay: HoursPerDay?
    var incomeTimeline: IncomeTimeline?
    var educationWillingnesses: [EducationWillingness] = []

    let totalSteps: Int = 8

    var progress: Double {
        if currentStep == 0 { return 0.05 }
        return Double(currentStep) / Double(totalSteps - 1)
    }

    var canAdvance: Bool {
        switch currentStep {
        case 0: return chosenPath != nil
        case 1: return workPreference != nil
        case 2: return !workEnvironments.isEmpty
        case 3: return !workConditions.isEmpty
        case 4: return budget != nil
        case 5: return hoursPerDay != nil
        case 6: return incomeTimeline != nil
        case 7: return !educationWillingnesses.isEmpty
        default: return false
        }
    }

    var stepTitle: String {
        switch currentStep {
        case 0: return "What's your path?"
        case 1: return "What kind of work?"
        case 2: return "Where do you work best?"
        case 3: return "What are you okay with?"
        case 4: return "What can you invest?"
        case 5: return "How much time per day?"
        case 6: return "How fast do you need income?"
        case 7: return "Training you're open to?"
        default: return ""
        }
    }

    var stepSubtitle: String {
        switch currentStep {
        case 0: return "Choose the direction that fits you best.\nYou can explore the others later."
        case 1: return "Are you more hands-on or screen-based?"
        case 2: return "Pick all that appeal to you."
        case 3: return "Select everything you're comfortable with."
        case 4: return "Your upfront budget to get started."
        case 5: return "Be realistic — consistency beats long hours."
        case 6: return "This helps us prioritize fast-start options."
        case 7: return "Select all levels you'd consider."
        default: return ""
        }
    }

    func next() {
        guard canAdvance, currentStep < totalSteps - 1 else { return }
        direction = .trailing
        withAnimation(.spring(duration: 0.4, bounce: 0.1)) {
            currentStep += 1
        }
    }

    func previous() {
        guard currentStep > 0 else { return }
        direction = .leading
        withAnimation(.spring(duration: 0.4, bounce: 0.1)) {
            currentStep -= 1
        }
    }

    func toggleEnvironment(_ env: WorkEnvironment) {
        if workEnvironments.contains(env) {
            workEnvironments.removeAll { $0 == env }
        } else {
            workEnvironments.append(env)
        }
    }

    func toggleCondition(_ condition: WorkCondition) {
        if workConditions.contains(condition) {
            workConditions.removeAll { $0 == condition }
        } else {
            workConditions.append(condition)
        }
    }

    func toggleEducation(_ edu: EducationWillingness) {
        if educationWillingnesses.contains(edu) {
            educationWillingnesses.removeAll { $0 == edu }
        } else {
            educationWillingnesses.append(edu)
        }
    }

    func buildProfile() -> UserProfile {
        var profile = UserProfile()
        profile.workPreference = workPreference
        profile.workEnvironments = workEnvironments
        profile.workConditions = workConditions
        profile.budget = budget
        profile.hoursPerDay = hoursPerDay
        profile.incomeTimeline = incomeTimeline
        profile.educationWillingnesses = educationWillingnesses
        deriveTechComfort(for: &profile)
        deriveWorkStyle(for: &profile)
        return profile
    }

    private func deriveTechComfort(for profile: inout UserProfile) {
        let physicalEnvs: [WorkEnvironment] = [.outdoors, .warehouse, .constructionSite]
        let digitalEnvs: [WorkEnvironment] = [.officeDesk, .homeBased]
        let hasPhysical = workEnvironments.contains(where: { physicalEnvs.contains($0) })
        let hasDigital = workEnvironments.contains(where: { digitalEnvs.contains($0) })

        if workConditions.contains(.officeDesk) && !workConditions.contains(where: { [.gettingDirty, .heavyLifting, .sweaty, .heights].contains($0) }) {
            profile.techComfort = .verySavvy
        } else if !workConditions.contains(.officeDesk) && workConditions.contains(where: { [.gettingDirty, .heavyLifting, .sweaty].contains($0) }) {
            profile.techComfort = .basic
        } else if hasDigital && !hasPhysical {
            profile.techComfort = .verySavvy
        } else {
            profile.techComfort = .moderate
        }
    }

    private func deriveWorkStyle(for profile: inout UserProfile) {
        if workPreference == .digital {
            profile.workStyle = .solo
        } else if workPreference == .physical {
            profile.workStyle = .withPeople
        } else {
            profile.workStyle = .either
        }
    }
}
