import SwiftUI

@Observable
class QuizViewModel {
    var currentStep: Int = 0
    var profile: UserProfile = UserProfile()
    var direction: Edge = .trailing

    let totalSteps: Int = 13

    var progress: Double {
        Double(currentStep + 1) / Double(totalSteps)
    }

    var canAdvance: Bool {
        switch currentStep {
        case 0: return !profile.firstName.trimmingCharacters(in: .whitespaces).isEmpty
        case 1: return profile.selectedCategories.count == 2
        case 2: return profile.budget != nil
        case 3: return profile.hoursPerDay != nil
        case 4: return profile.workPreference != nil
        case 5: return profile.workStyle != nil
        case 6: return true
        case 7: return profile.techComfort != nil
        case 8: return profile.experienceLevel != nil
        case 9: return profile.customerInteraction != nil
        case 10: return profile.hasCar != nil
        case 11: return profile.sellingComfort != nil
        case 12: return profile.needsFastCash != nil
        default: return false
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

    func toggleCategory(_ category: BusinessCategory) {
        if profile.selectedCategories.contains(category) {
            profile.selectedCategories.removeAll { $0 == category }
        } else if profile.selectedCategories.count < 2 {
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
}
