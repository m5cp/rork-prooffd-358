import SwiftUI

@Observable
class QuizViewModel {
    var currentStep: Int = 0
    var profile: UserProfile = UserProfile()
    var direction: Edge = .trailing
    var showTeaser: Bool = false
    var hasShownTeaser: Bool = false

    let totalSteps: Int = 13

    var progress: Double {
        Double(currentStep + 1) / Double(totalSteps)
    }

    var progressText: String {
        let pct = Int(progress * 100)
        if pct < 50 { return "\(pct)% complete" }
        if pct < 80 { return "\(pct)% complete — almost there" }
        return "\(pct)% complete — final stretch"
    }

    var motivationMessage: String? {
        switch currentStep {
        case 3: return "You're on the right track — this is getting accurate"
        case 6: return "Great answers so far — your matches are shaping up"
        case 9: return "Users similar to you often find strong matches"
        case 11: return "Almost done — just a couple more questions"
        default: return nil
        }
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
        if currentStep == 5 && !hasShownTeaser {
            hasShownTeaser = true
            showTeaser = true
            return
        }
        direction = .trailing
        withAnimation(.spring(duration: 0.4, bounce: 0.1)) {
            currentStep += 1
        }
    }

    func dismissTeaser() {
        showTeaser = false
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
