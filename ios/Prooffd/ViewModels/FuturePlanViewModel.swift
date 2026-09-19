import SwiftUI

@Observable
class FuturePlanViewModel {
    var answers = FuturePlanAnswers()
    var currentQuestionIndex = 0
    var isComplete = false

    private static let partialKey = "futurePlanAnswers"

    var questions: [DeepDiveQuestion] {
        DeepDiveQuestion.questions(for: answers.stage)
    }

    var currentQ: DeepDiveQuestion {
        questions[min(currentQuestionIndex, max(0, questions.count - 1))]
    }

    var totalQuestions: Int { questions.count }

    var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(min(currentQuestionIndex, totalQuestions)) / Double(totalQuestions)
    }

    var canAdvance: Bool {
        switch currentQ {
        case .stage:            return answers.stage != nil
        case .favoriteSubjects: return !answers.favoriteSubjects.isEmpty
        case .workFeel:         return !answers.workFeel.isEmpty
        case .activities:       return !answers.activities.isEmpty
        case .freeTime:         return answers.freeTime != nil
        case .familySupport:    return answers.familySupport != nil
        case .moneyGoal:        return answers.moneyGoal != nil
        case .dreamLifestyle:   return answers.dreamLifestyle != nil
        case .adultFocus:       return answers.adultFocus != nil
        case .adultBudget:      return answers.adultBudget != nil
        case .incomeTarget:     return answers.incomeTarget != nil
        }
    }

    func next() {
        guard canAdvance else { return }
        if currentQuestionIndex < totalQuestions - 1 {
            currentQuestionIndex += 1
        }
    }

    func previous() {
        if currentQuestionIndex > 0 { currentQuestionIndex -= 1 }
    }

    func selectStage(_ stage: SchoolStage) {
        answers.stage = stage
    }

    func toggleSubject(_ subject: FavoriteSubject) {
        if answers.favoriteSubjects.contains(subject) {
            answers.favoriteSubjects.removeAll { $0 == subject }
        } else {
            answers.favoriteSubjects.append(subject)
        }
    }

    func toggleWorkFeel(_ interest: WorkFeelInterest) {
        if answers.workFeel.contains(interest) {
            answers.workFeel.removeAll { $0 == interest }
        } else {
            answers.workFeel.append(interest)
        }
    }

    func toggleActivity(_ activity: StudentActivity) {
        if answers.activities.contains(activity) {
            answers.activities.removeAll { $0 == activity }
        } else {
            answers.activities.append(activity)
        }
    }

    // MARK: - Partial Progress

    /// Saves in-progress answers so users can leave and resume the quiz.
    func savePartial() {
        guard answers.stage != nil else {
            UserDefaults.standard.removeObject(forKey: Self.partialKey)
            return
        }
        if let data = try? JSONEncoder().encode(answers) {
            UserDefaults.standard.set(data, forKey: Self.partialKey)
        }
    }

    func loadPartial() {
        guard let data = UserDefaults.standard.data(forKey: Self.partialKey),
              let saved = try? JSONDecoder().decode(FuturePlanAnswers.self, from: data) else { return }
        answers = saved
        if answers.stage != nil && currentQuestionIndex == 0 {
            currentQuestionIndex = 1
        }
    }

    func clearPartial() {
        UserDefaults.standard.removeObject(forKey: Self.partialKey)
    }
}
