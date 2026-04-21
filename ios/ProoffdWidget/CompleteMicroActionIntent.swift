import AppIntents
import WidgetKit
import Foundation

nonisolated struct CompleteMicroActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete Today's Action"
    static var description = IntentDescription("Marks today's micro-action as done.")
    static var isDiscoverable: Bool = true

    init() {}

    func perform() async throws -> some IntentResult {
        let suite = UserDefaults(suiteName: "group.app.rork.prooffd")
        suite?.set(true, forKey: "widget_microActionCompleted")
        suite?.set(Date(), forKey: "widget_microActionCompletedDate")
        suite?.set(true, forKey: "widget_pendingMicroActionSync")

        let current = suite?.integer(forKey: "widget_totalPoints") ?? 0
        suite?.set(current + 5, forKey: "widget_totalPoints")

        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
