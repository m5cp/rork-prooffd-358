import WidgetKit
import SwiftUI

nonisolated struct ProoffdEntry: TimelineEntry {
    let date: Date
    let streakCount: Int
    let longestStreak: Int
    let buildsCount: Int
    let tipTitle: String
    let tipBody: String
    let tipCategory: String
    let microActionTitle: String
    let microActionCompleted: Bool
    let totalPoints: Int
    let levelName: String
}

nonisolated struct ProoffdProvider: TimelineProvider {
    private static let suiteName = "group.app.rork.prooffd"

    func placeholder(in context: Context) -> ProoffdEntry {
        ProoffdEntry(
            date: .now,
            streakCount: 5,
            longestStreak: 12,
            buildsCount: 2,
            tipTitle: "Start Before You're Ready",
            tipBody: "Most successful entrepreneurs launched before they felt 100% prepared.",
            tipCategory: "Mindset",
            microActionTitle: "Explore a New Path",
            microActionCompleted: false,
            totalPoints: 150,
            levelName: "Explorer"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (ProoffdEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ProoffdEntry>) -> Void) {
        let entry = readEntry()
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func readEntry() -> ProoffdEntry {
        let shared = UserDefaults(suiteName: Self.suiteName)
        return ProoffdEntry(
            date: .now,
            streakCount: shared?.integer(forKey: "widget_streakCount") ?? 0,
            longestStreak: shared?.integer(forKey: "widget_longestStreak") ?? 0,
            buildsCount: shared?.integer(forKey: "widget_buildsCount") ?? 0,
            tipTitle: shared?.string(forKey: "widget_tipTitle") ?? "Open Prooffd",
            tipBody: shared?.string(forKey: "widget_tipBody") ?? "Take the quiz and discover your AI-proof career path.",
            tipCategory: shared?.string(forKey: "widget_tipCategory") ?? "Mindset",
            microActionTitle: shared?.string(forKey: "widget_microActionTitle") ?? "Open the app",
            microActionCompleted: shared?.bool(forKey: "widget_microActionCompleted") ?? false,
            totalPoints: shared?.integer(forKey: "widget_totalPoints") ?? 0,
            levelName: shared?.string(forKey: "widget_levelName") ?? "Starter"
        )
    }
}

struct SmallWidgetView: View {
    let entry: ProoffdEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)
                Spacer()
                Text("Prooffd")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(entry.streakCount)")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            Text(entry.streakCount == 1 ? "day streak" : "day streak")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

struct MediumWidgetView: View {
    let entry: ProoffdEntry

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.body)
                        .foregroundStyle(.orange)
                    Text("\(entry.streakCount) day streak")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.levelName)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                    Text("\(entry.totalPoints) pts")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary)
                }

                HStack(spacing: 4) {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.caption2)
                    Text("\(entry.buildsCount) builds")
                        .font(.caption2.weight(.medium))
                }
                .foregroundStyle(.secondary)
            }

            Rectangle()
                .fill(.quaternary)
                .frame(width: 1)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    Text("Daily Tip")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text(entry.tipTitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Spacer()

                Text(entry.tipCategory)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.quaternary)
                    .clipShape(.capsule)
            }
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

struct LargeWidgetView: View {
    let entry: ProoffdEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.title3)
                        .foregroundStyle(.orange)
                    Text("\(entry.streakCount) day streak")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(entry.levelName)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text("\(entry.totalPoints) pts")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    Text("Daily Tip")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(entry.tipCategory)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.quaternary)
                        .clipShape(.capsule)
                }

                Text(entry.tipTitle)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)

                Text(entry.tipBody)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .lineSpacing(2)
            }

            Divider()

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "target")
                            .font(.caption2)
                            .foregroundStyle(.green)
                        Text("Today's Action")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                    Text(entry.microActionTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                }

                Spacer()

                if entry.microActionCompleted {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                        Text("Done")
                            .font(.caption.weight(.bold))
                    }
                    .foregroundStyle(.green)
                }
            }

            Spacer(minLength: 0)

            HStack(spacing: 8) {
                statPill(icon: "list.bullet.clipboard", value: "\(entry.buildsCount)", label: "builds")
                statPill(icon: "trophy", value: "\(entry.longestStreak)", label: "best streak")
            }
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }

    private func statPill(icon: String, value: String, label: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(value)
                .font(.caption.weight(.bold))
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .foregroundStyle(.primary)
    }
}

struct AccessoryCircularView: View {
    let entry: ProoffdEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 1) {
                Image(systemName: "flame.fill")
                    .font(.caption)
                Text("\(entry.streakCount)")
                    .font(.title3.weight(.bold))
            }
        }
    }
}

struct AccessoryRectangularView: View {
    let entry: ProoffdEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .font(.caption2)
                Text("\(entry.streakCount) day streak")
                    .font(.caption.weight(.bold))
            }
            Text(entry.tipTitle)
                .font(.caption2)
                .lineLimit(2)
        }
    }
}

struct AccessoryInlineView: View {
    let entry: ProoffdEntry

    var body: some View {
        Label("\(entry.streakCount) day streak", systemImage: "flame.fill")
    }
}

struct ProoffdWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: ProoffdEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        case .accessoryCircular:
            AccessoryCircularView(entry: entry)
        case .accessoryRectangular:
            AccessoryRectangularView(entry: entry)
        case .accessoryInline:
            AccessoryInlineView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct ProoffdWidget: Widget {
    let kind: String = "ProoffdWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProoffdProvider()) { entry in
            ProoffdWidgetView(entry: entry)
        }
        .configurationDisplayName("Prooffd")
        .description("Track your streak, daily tip, and build progress.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}
