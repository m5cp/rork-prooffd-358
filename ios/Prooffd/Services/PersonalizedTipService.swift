import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

@MainActor
@Observable
final class PersonalizedTipService {
    static let shared = PersonalizedTipService()

    private(set) var personalizedTip: DailyTip?
    private(set) var isGenerating: Bool = false
    private var lastGeneratedDateKey: String?

    private init() {}

    func generateIfNeeded(activeBuildName: String?, streakDays: Int, category: TipCategory) async {
        let todayKey = Self.todayKey()
        guard lastGeneratedDateKey != todayKey else { return }

        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            guard SystemLanguageModel.default.availability == .available else { return }
            isGenerating = true
            defer { isGenerating = false }

            let context: String
            if let name = activeBuildName, !name.isEmpty {
                context = "The user is actively building a '\(name)' plan and has a \(streakDays)-day streak."
            } else {
                context = "The user has a \(streakDays)-day streak and hasn't started a build yet."
            }

            let prompt = """
            Generate one concise, actionable daily career or business tip for a user of the Prooffd app.
            Context: \(context)
            Category: \(category.rawValue).
            Return a punchy title (max 6 words) and a 2-sentence body. No emojis. No quotes. No greeting.
            Format exactly as:
            TITLE: <title>
            BODY: <body>
            """

            do {
                let session = LanguageModelSession()
                let response = try await session.respond(to: prompt)
                if let tip = parse(response: response.content, category: category) {
                    personalizedTip = tip
                    lastGeneratedDateKey = todayKey
                }
            } catch {
                // Fall back to library tip
            }
        }
        #endif
    }

    private func parse(response: String, category: TipCategory) -> DailyTip? {
        let lines = response.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        var title = ""
        var body = ""
        for line in lines {
            if line.hasPrefix("TITLE:") {
                title = String(line.dropFirst("TITLE:".count)).trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("BODY:") {
                body = String(line.dropFirst("BODY:".count)).trimmingCharacters(in: .whitespaces)
            }
        }
        guard !title.isEmpty, !body.isEmpty else { return nil }
        return DailyTip(id: 9999, title: title, body: body, icon: "sparkles", category: category)
    }

    private static func todayKey() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }
}
