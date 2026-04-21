import Foundation
import ActivityKit

@MainActor
enum BuildLiveActivityService {
    private static var currentActivityId: String?

    static func start(for build: BuildProject, streakDays: Int) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        Task { await end() }

        let attributes = BuildActivityAttributes(
            buildId: build.id,
            buildName: build.pathName,
            pathIcon: build.pathIcon
        )
        let state = BuildActivityAttributes.ContentState(
            progressPercent: build.progressPercentage,
            streakDays: streakDays,
            nextStepTitle: build.nextStep?.title ?? "You're all caught up!",
            stepsCompleted: build.steps.filter(\.isCompleted).count,
            totalSteps: build.steps.count
        )

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: Date().addingTimeInterval(60 * 60 * 8)),
                pushType: nil
            )
            currentActivityId = activity.id
        } catch {
            // Silently ignore — Live Activities may be disabled.
        }
    }

    static func update(for build: BuildProject, streakDays: Int) async {
        let activities = Activity<BuildActivityAttributes>.activities
        guard let activity = activities.first(where: { $0.attributes.buildId == build.id }) else { return }
        let state = BuildActivityAttributes.ContentState(
            progressPercent: build.progressPercentage,
            streakDays: streakDays,
            nextStepTitle: build.nextStep?.title ?? "You're all caught up!",
            stepsCompleted: build.steps.filter(\.isCompleted).count,
            totalSteps: build.steps.count
        )
        await activity.update(.init(state: state, staleDate: Date().addingTimeInterval(60 * 60 * 8)))
    }

    static func end() async {
        for activity in Activity<BuildActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        currentActivityId = nil
    }
}
