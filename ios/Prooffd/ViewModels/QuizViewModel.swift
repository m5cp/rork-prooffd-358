import SwiftUI

@Observable
class QuizViewModel {
    var currentStep: Int = 0
    var profile: UserProfile = UserProfile()
    var direction: Edge = .trailing
    var showCheckpoint: Bool = false
    var hasShownCheckpoint: Bool = false
    var checkpointMatches: [MatchResult] = []

    let totalSteps: Int = 7

    var progress: Double {
        if currentStep == 0 { return 0.05 }
        return Double(currentStep) / Double(totalSteps - 1)
    }

    var progressText: String {
        return "\(currentStep + 1) of \(totalSteps)"
    }

    var motivationMessage: String? {
        switch currentStep {
        case 3: return "Halfway there — keep going!"
        case 5: return "Almost done — just 2 more!"
        default: return nil
        }
    }

    var canAdvance: Bool {
        switch currentStep {
        case 0: return !profile.selectedCategories.isEmpty
        case 1: return !profile.workEnvironments.isEmpty
        case 2: return !profile.workConditions.isEmpty
        case 3: return profile.budget != nil
        case 4: return profile.hoursPerDay != nil
        case 5: return profile.experienceLevel != nil
        case 6: return !profile.educationWillingnesses.isEmpty
        default: return false
        }
    }

    var canShowEarlyResults: Bool {
        currentStep >= 4 && !profile.selectedCategories.isEmpty && !profile.workEnvironments.isEmpty
    }

    var pointsEarned: Int {
        var pts = 0
        if !profile.selectedCategories.isEmpty { pts += 10 }
        if !profile.workEnvironments.isEmpty { pts += 10 }
        if !profile.workConditions.isEmpty { pts += 10 }
        if profile.budget != nil { pts += 10 }
        if profile.hoursPerDay != nil { pts += 10 }
        if profile.experienceLevel != nil { pts += 10 }
        if !profile.educationWillingnesses.isEmpty { pts += 10 }

        return pts
    }

    func next() {
        guard canAdvance, currentStep < totalSteps - 1 else { return }
        if currentStep == 3 && !hasShownCheckpoint {
            hasShownCheckpoint = true
            generateCheckpointMatches()
            showCheckpoint = true
            return
        }
        direction = .trailing
        withAnimation(.spring(duration: 0.4, bounce: 0.1)) {
            currentStep += 1
        }
    }

    func dismissCheckpoint() {
        showCheckpoint = false
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

    func selectBudget(_ budget: BudgetRange) {
        profile.budget = budget
    }

    func selectHours(_ hours: HoursPerDay) {
        profile.hoursPerDay = hours
    }

    func selectExperience(_ exp: ExperienceLevel) {
        profile.experienceLevel = exp
    }

    func toggleCategory(_ category: BusinessCategory) {
        if profile.selectedCategories.contains(category) {
            profile.selectedCategories.removeAll { $0 == category }
        } else if profile.selectedCategories.count < 4 {
            profile.selectedCategories.append(category)
        }
    }

    func toggleCondition(_ condition: WorkCondition) {
        if profile.workConditions.contains(condition) {
            profile.workConditions.removeAll { $0 == condition }
        } else {
            profile.workConditions.append(condition)
        }
    }

    func toggleEnvironment(_ env: WorkEnvironment) {
        if profile.workEnvironments.contains(env) {
            profile.workEnvironments.removeAll { $0 == env }
        } else {
            profile.workEnvironments.append(env)
        }
    }

    func toggleEducation(_ edu: EducationWillingness) {
        if profile.educationWillingnesses.contains(edu) {
            profile.educationWillingnesses.removeAll { $0 == edu }
        } else {
            profile.educationWillingnesses.append(edu)
        }
    }

    func applyDerivedFields() {
        let envs = profile.workEnvironments
        let conditions = profile.workConditions
        let physicalEnvs: [WorkEnvironment] = [.outdoors, .warehouse, .constructionSite]
        let digitalEnvs: [WorkEnvironment] = [.officeDesk, .homeBased]
        let hasPhysical = envs.contains(where: { physicalEnvs.contains($0) })
        let hasDigital = envs.contains(where: { digitalEnvs.contains($0) })
        if hasPhysical && !hasDigital {
            profile.workPreference = .physical
        } else if hasDigital && !hasPhysical {
            profile.workPreference = .digital
        } else if hasPhysical && hasDigital {
            profile.workPreference = .either
        }
        if conditions.contains(.officeDesk) && !conditions.contains(where: { [.gettingDirty, .heavyLifting, .sweaty, .heights].contains($0) }) {
            profile.techComfort = .verySavvy
        } else if !conditions.contains(.officeDesk) && conditions.contains(where: { [.gettingDirty, .heavyLifting, .sweaty].contains($0) }) {
            profile.techComfort = .basic
        } else {
            profile.techComfort = .moderate
        }
    }

    private func generateCheckpointMatches() {
        checkpointMatches = MatchingEngine.quickMatch(
            profile: profile,
            paths: BusinessPathDatabase.allPaths,
            limit: 2
        )
    }
}
