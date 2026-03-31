import SwiftUI

@Observable
class QuizViewModel {
    var currentStep: Int = 0
    var profile: UserProfile = UserProfile()
    var direction: Edge = .trailing
    var showCheckpoint: Bool = false
    var hasShownCheckpoint: Bool = false
    var checkpointMatches: [MatchResult] = []

    let totalSteps: Int = 4

    var progress: Double {
        if currentStep == 0 { return 0.05 }
        return Double(currentStep) / Double(totalSteps - 1)
    }

    var progressText: String {
        return "\(currentStep + 1) of \(totalSteps)"
    }

    var motivationMessage: String? {
        switch currentStep {
        case 2: return "Almost done — just 2 more!"
        default: return nil
        }
    }

    var canAdvance: Bool {
        switch currentStep {
        case 0: return !profile.selectedCategories.isEmpty
        case 1: return !profile.workEnvironments.isEmpty
        case 2: return !profile.workConditions.isEmpty
        case 3: return !profile.situationTags.isEmpty
        default: return false
        }
    }

    var canShowEarlyResults: Bool {
        currentStep >= 2 && !profile.selectedCategories.isEmpty && !profile.workEnvironments.isEmpty
    }

    var pointsEarned: Int {
        var pts = 0
        if !profile.selectedCategories.isEmpty { pts += 20 }
        if !profile.workEnvironments.isEmpty { pts += 20 }
        if !profile.workConditions.isEmpty { pts += 20 }
        if !profile.situationTags.isEmpty { pts += 20 }
        return pts
    }

    func next() {
        guard canAdvance, currentStep < totalSteps - 1 else { return }
        if currentStep == 1 && !hasShownCheckpoint {
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

    func toggleSituationTag(_ tag: SituationTag) {
        if profile.situationTags.contains(tag) {
            profile.situationTags.removeAll { $0 == tag }
        } else {
            profile.situationTags.append(tag)
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
        let tags = profile.situationTags
        if tags.contains(.lowBudget) {
            profile.budget = .zero
        } else if tags.contains(.canInvest) {
            profile.budget = .under1000
        }
        if tags.contains(.needMoneyNow) {
            profile.incomeTimeline = .asap
        } else if tags.contains(.flexibleTimeline) {
            profile.incomeTimeline = .noRush
        }
        if tags.contains(.fewHours) {
            profile.hoursPerDay = .oneToTwo
        } else if tags.contains(.fullTime) {
            profile.hoursPerDay = .fivePlus
        }
        if tags.contains(.prefersPhysical) && !tags.contains(.prefersDigital) {
            profile.workPreference = .physical
        } else if tags.contains(.prefersDigital) && !tags.contains(.prefersPhysical) {
            profile.workPreference = .digital
        } else if tags.contains(.prefersPhysical) && tags.contains(.prefersDigital) {
            profile.workPreference = .either
        }
        if tags.contains(.workAlone) && !tags.contains(.workWithPeople) {
            profile.workStyle = .solo
        } else if tags.contains(.workWithPeople) && !tags.contains(.workAlone) {
            profile.workStyle = .withPeople
        } else if tags.contains(.workAlone) && tags.contains(.workWithPeople) {
            profile.workStyle = .either
        }
        if tags.contains(.techSavvy) {
            profile.techComfort = .verySavvy
        } else if tags.contains(.lowTech) {
            profile.techComfort = .basic
        }
        if tags.contains(.comfortableSelling) {
            profile.sellingComfort = .veryComfortable
        } else if tags.contains(.noSelling) {
            profile.sellingComfort = .notComfortable
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
