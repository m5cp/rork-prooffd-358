import ActivityKit
import WidgetKit
import SwiftUI

nonisolated struct BuildActivityAttributes: ActivityAttributes, Sendable {
    public nonisolated struct ContentState: Codable, Hashable, Sendable {
        var progressPercent: Int
        var streakDays: Int
        var nextStepTitle: String
        var stepsCompleted: Int
        var totalSteps: Int
    }

    var buildId: String
    var buildName: String
    var pathIcon: String
}

struct BuildLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BuildActivityAttributes.self) { context in
            LockScreenBuildView(attributes: context.attributes, state: context.state)
                .activityBackgroundTint(Color.black.opacity(0.85))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Image(systemName: context.attributes.pathIcon)
                            .font(.caption)
                            .foregroundStyle(.green)
                        Text(context.attributes.buildName)
                            .font(.caption.weight(.semibold))
                            .lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text("\(context.state.streakDays)")
                            .font(.caption.weight(.bold))
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        ProgressView(value: Double(context.state.progressPercent), total: 100)
                            .tint(.green)
                        HStack {
                            Text("\(context.state.progressPercent)% \u{2022} \(context.state.stepsCompleted)/\(context.state.totalSteps) steps")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(context.state.nextStepTitle)
                                .font(.caption2.weight(.semibold))
                                .lineLimit(1)
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: context.attributes.pathIcon)
                    .foregroundStyle(.green)
            } compactTrailing: {
                Text("\(context.state.progressPercent)%")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.green)
            } minimal: {
                Text("\(context.state.progressPercent)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.green)
            }
            .keylineTint(.green)
        }
    }
}

struct LockScreenBuildView: View {
    let attributes: BuildActivityAttributes
    let state: BuildActivityAttributes.ContentState

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: attributes.pathIcon)
                    .font(.subheadline)
                    .foregroundStyle(.green)
                Text(attributes.buildName)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text("\(state.streakDays) day streak")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
            ProgressView(value: Double(state.progressPercent), total: 100)
                .tint(.green)
            HStack {
                Text("\(state.progressPercent)% \u{2022} \(state.stepsCompleted)/\(state.totalSteps)")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text(state.nextStepTitle)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(1)
            }
        }
        .padding(14)
    }
}
