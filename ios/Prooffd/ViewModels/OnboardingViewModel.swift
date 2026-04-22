import SwiftUI

@Observable
class OnboardingViewModel {
    var currentStep: Int = 0
    var direction: Edge = .trailing
    var appeared: Bool = false

    var motivationGoal: MotivationGoal?
    var situationGoal: SituationGoal?
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
        case 0: return motivationGoal != nil
        case 1: return workPreference != nil
        case 2: return situationGoal != nil
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
        case 0: return "What matters most to you?"
        case 1: return "What kind of work?"
        case 2: return "What sounds most like your situation?"
        case 3: return "What are you okay with?"
        case 4: return "What can you invest?"
        case 5: return "How much time per day?"
        case 6: return "How fast do you need income?"
        case 7: return "How much training would you consider?"
        default: return ""
        }
    }

    var stepSubtitle: String {
        switch currentStep {
        case 0: return "This helps us understand what kind of path fits your life."
        case 1: return "Pick the style that fits you best."
        case 2: return "Choose the one that describes you right now."
        case 3: return "Select everything you are comfortable with."
        case 4: return "Your upfront budget to get started."
        case 5: return "Be realistic — consistency matters more than long hours."
        case 6: return "This helps us prioritize the right options for you."
        case 7: return "Choose the highest level of training you would consider."
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

    func selectEducation(_ edu: EducationWillingness) {
        educationWillingnesses = [edu]
    }

    func buildProfile() -> UserProfile {
        var profile = UserProfile()
        profile.motivationGoal = motivationGoal
        profile.situationGoal = situationGoal
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
        let professionalEnvs: [WorkEnvironment] = [.hospital, .clinic, .laboratory, .courtroom, .classroom, .aircraft]
        let hasPhysical = workEnvironments.contains(where: { physicalEnvs.contains($0) })
        let hasDigital = workEnvironments.contains(where: { digitalEnvs.contains($0) })
        let hasProfessional = workEnvironments.contains(where: { professionalEnvs.contains($0) })

        if workConditions.contains(.officeDesk) && !workConditions.contains(where: { [.gettingDirty, .heavyLifting, .sweaty, .heights].contains($0) }) {
            profile.techComfort = .verySavvy
        } else if hasProfessional && !hasPhysical {
            profile.techComfort = .moderate
        } else if !workConditions.contains(.officeDesk) && workConditions.contains(where: { [.gettingDirty, .heavyLifting, .sweaty].contains($0) }) {
            profile.techComfort = .basic
        } else if hasDigital && !hasPhysical {
            profile.techComfort = .verySavvy
        } else {
            profile.techComfort = .moderate
        }
    }

    private func deriveWorkStyle(for profile: inout UserProfile) {
        let peopleEnvs: [WorkEnvironment] = [.hospital, .clinic, .classroom, .courtroom]
        let hasPeopleEnv = workEnvironments.contains(where: { peopleEnvs.contains($0) })
        let hasPeopleConditions = workConditions.contains(where: { [.patientCare, .emotionalSituations, .publicSpeaking].contains($0) })

        if hasPeopleEnv || hasPeopleConditions {
            profile.workStyle = .withPeople
        } else if workPreference == .digital {
            profile.workStyle = .solo
        } else if workPreference == .physical {
            profile.workStyle = .withPeople
        } else {
            profile.workStyle = .either
        }
    }
}
