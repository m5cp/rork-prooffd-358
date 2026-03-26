import SwiftUI

@Observable
class QuizViewModel {
    var currentStep: Int = 0
    var profile: UserProfile = UserProfile()
    var direction: Edge = .trailing
    var showCheckpoint: Bool = false
    var hasShownCheckpoint: Bool = false
    var checkpointMatches: [MatchResult] = []

    let totalSteps: Int = 11

    var progress: Double {
        if currentStep == 0 { return 0.05 }
        return Double(currentStep) / Double(totalSteps - 1)
    }

    var progressText: String {
        if currentStep == 0 { return "Profile" }
        return "\(currentStep) of 10"
    }

    var motivationMessage: String? {
        switch currentStep {
        case 3: return "Great start — keep going!"
        case 6: return "Matches are getting sharper"
        case 9: return "Almost done — just 2 more"
        default: return nil
        }
    }

    var canAdvance: Bool {
        switch currentStep {
        case 0: return !profile.firstName.trimmingCharacters(in: .whitespaces).isEmpty
        case 1: return !profile.selectedCategories.isEmpty
        case 2: return profile.budget != nil
        case 3: return profile.workPreference != nil
        case 4: return profile.hoursPerDay != nil
        case 5: return profile.workStyle != nil
        case 6: return profile.techComfort != nil
        case 7: return profile.experienceLevel != nil
        case 8: return profile.customerInteraction != nil
        case 9: return profile.sellingComfort != nil
        case 10: return profile.hasCar != nil
        default: return false
        }
    }

    var canShowEarlyResults: Bool {
        currentStep >= 5 && !profile.selectedCategories.isEmpty && profile.budget != nil
    }

    var pointsEarned: Int {
        var pts = 0
        if !profile.firstName.isEmpty { pts += 5 }
        if !profile.selectedCategories.isEmpty { pts += 10 }
        if profile.budget != nil { pts += 10 }
        if profile.workPreference != nil { pts += 10 }
        if profile.hoursPerDay != nil { pts += 5 }
        if profile.workStyle != nil { pts += 5 }
        if profile.techComfort != nil { pts += 5 }
        if profile.experienceLevel != nil { pts += 5 }
        if profile.customerInteraction != nil { pts += 5 }
        if profile.sellingComfort != nil { pts += 5 }
        if profile.hasCar != nil { pts += 5 }
        return pts
    }

    func next() {
        guard canAdvance, currentStep < totalSteps - 1 else { return }
        if currentStep == 4 && !hasShownCheckpoint {
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

    private func generateCheckpointMatches() {
        checkpointMatches = MatchingEngine.quickMatch(
            profile: profile,
            paths: BusinessPathDatabase.allPaths,
            limit: 2
        )
    }
}
