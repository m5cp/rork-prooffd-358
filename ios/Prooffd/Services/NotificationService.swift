import Foundation
import UserNotifications

nonisolated enum ActivityLevel: Sendable {
    case active
    case moderate
    case low
}

@Observable
class NotificationService {
    static let shared = NotificationService()

    var notificationsEnabled: Bool {
        get {
            if !UserDefaults.standard.bool(forKey: "notificationsInitialized") {
                return true
            }
            return UserDefaults.standard.bool(forKey: "notificationsEnabled")
        }
        set {
            UserDefaults.standard.set(true, forKey: "notificationsInitialized")
            UserDefaults.standard.set(newValue, forKey: "notificationsEnabled")
        }
    }

    private let usedIndicesKey = "usedNotificationIndices"
    private let lastScheduleDateKey = "lastNotificationScheduleDate"
    private let activityDatesKey = "recentActivityDates"
    private let maxDailyNotifications = 1
    private let scheduleDaysAhead = 14

    private var usedIndices: Set<Int> {
        get {
            let array = UserDefaults.standard.array(forKey: usedIndicesKey) as? [Int] ?? []
            return Set(array)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: usedIndicesKey)
        }
    }

    private var recentActivityDates: [Date] {
        get {
            let timestamps = UserDefaults.standard.array(forKey: activityDatesKey) as? [Double] ?? []
            return timestamps.map { Date(timeIntervalSince1970: $0) }
        }
        set {
            let timestamps = newValue.map { $0.timeIntervalSince1970 }
            UserDefaults.standard.set(timestamps, forKey: activityDatesKey)
        }
    }

    private var activityLevel: ActivityLevel {
        let calendar = Calendar.current
        let now = Date()
        let recentDays = recentActivityDates.filter { calendar.dateComponents([.day], from: $0, to: now).day ?? 99 < 14 }
        let uniqueDays = Set(recentDays.map { calendar.startOfDay(for: $0) })
        switch uniqueDays.count {
        case 7...14: return .active
        case 3..<7: return .moderate
        default: return .low
        }
    }

    func recordActivity() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var dates = recentActivityDates.filter {
            (calendar.dateComponents([.day], from: $0, to: today).day ?? 99) < 30
        }
        if !dates.contains(where: { calendar.isDate($0, inSameDayAs: today) }) {
            dates.append(today)
        }
        recentActivityDates = dates
    }

    private init() {}

    func enableNotifications() {
        notificationsEnabled = true
        requestSystemPermissionIfNeeded { granted in
            Task { @MainActor in
                if granted {
                    self.scheduleGentleReminders()
                } else {
                    self.notificationsEnabled = false
                }
            }
        }
    }

    func requestPermissionIfFirstLaunch() {
        guard !UserDefaults.standard.bool(forKey: "notificationsInitialized") else { return }
        UserDefaults.standard.set(true, forKey: "notificationsInitialized")
        UserDefaults.standard.set(true, forKey: "notificationsEnabled")
    }

    func disableNotifications() {
        notificationsEnabled = false
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func requestSystemPermissionIfNeeded(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                completion(true)
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    completion(granted)
                }
            default:
                completion(false)
            }
        }
    }

    func scheduleGentleReminders() {
        guard notificationsEnabled else { return }
        requestSystemPermissionIfNeeded { granted in
            guard granted else { return }
            Task { @MainActor in
                self.performScheduleGentleReminders()
            }
        }
    }

    private func performScheduleGentleReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        var currentUsed = usedIndices

        if currentUsed.count > NotificationMessages.all.count - 100 {
            currentUsed.removeAll()
        }

        let skipInterval: Int
        switch activityLevel {
        case .active: skipInterval = 1
        case .moderate: skipInterval = 2
        case .low: skipInterval = 3
        }

        let totalNeeded = scheduleDaysAhead / skipInterval
        let picked = NotificationMessages.randomMessages(count: totalNeeded, excluding: currentUsed)

        let deliveryHours = [10]

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var messageCounter = 0

        for dayOffset in stride(from: 0, to: scheduleDaysAhead, by: skipInterval) {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }

            for slot in 0..<maxDailyNotifications {
                guard messageCounter < picked.count else { continue }

                let (catalogIndex, message) = picked[messageCounter]
                messageCounter += 1

                let content = UNMutableNotificationContent()
                content.title = message.title
                content.body = message.body
                content.sound = .default

                var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                dateComponents.hour = deliveryHours[slot]
                dateComponents.minute = Int.random(in: 0...30)

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(
                    identifier: "gentle_\(dayOffset)_\(slot)",
                    content: content,
                    trigger: trigger
                )

                UNUserNotificationCenter.current().add(request)
                currentUsed.insert(catalogIndex)
            }
        }

        usedIndices = currentUsed
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastScheduleDateKey)
    }

    func refreshRemindersIfNeeded() {
        requestPermissionIfFirstLaunch()
        guard notificationsEnabled else { return }

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else { return }
            Task { @MainActor in
                let lastSchedule = UserDefaults.standard.double(forKey: self.lastScheduleDateKey)
                let daysSince = (Date().timeIntervalSince1970 - lastSchedule) / 86400
                if daysSince >= 7 || lastSchedule == 0 {
                    self.performScheduleGentleReminders()
                }
            }
        }
    }

    func scheduleStreakReminder(currentStreak: Int) {
        guard notificationsEnabled, currentStreak > 0 else { return }

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["streak_reminder"])

        let streakMessages: [(String, String)]
        switch currentStreak {
        case 1...3:
            streakMessages = [
                ("Day \(currentStreak) streak!", "You're building momentum! Don't let it slip away."),
                ("\(currentStreak) days strong!", "You've shown up \(currentStreak) days in a row. Keep it going!"),
                ("Streak: \(currentStreak) days", "Consistency is key. Come back tomorrow to make it \(currentStreak + 1)."),
            ]
        case 4...7:
            streakMessages = [
                ("\(currentStreak)-day streak!", "Almost a full week! You're proving you're serious."),
                ("Streak power: \(currentStreak) days", "Most people quit by now. You didn't. That's rare."),
                ("\(currentStreak) days and counting!", "Your dedication is showing. Keep the chain alive."),
            ]
        case 8...14:
            streakMessages = [
                ("\(currentStreak)-day streak!", "Double digits are calling. Don't stop now!"),
                ("Incredible: \(currentStreak) days!", "You're in the top tier of consistency. Protect this streak."),
                ("\(currentStreak) days of dedication!", "This streak is becoming a habit. And habits build empires."),
            ]
        case 15...30:
            streakMessages = [
                ("\(currentStreak)-day streak!", "You're officially in habit territory. This is who you are now."),
                ("Legend: \(currentStreak) days!", "Most people dream about this kind of consistency. You live it."),
                ("\(currentStreak) days strong!", "Your streak is your resume of discipline. Don't stop."),
            ]
        default:
            streakMessages = [
                ("\(currentStreak)-day streak!", "You're unstoppable. \(currentStreak) days of pure commitment."),
                ("Streak master: \(currentStreak) days!", "At this point, your streak is legendary. Keep writing history."),
                ("\(currentStreak) days!", "This level of consistency changes lives. You're proof."),
            ]
        }

        let selected = streakMessages.randomElement() ?? streakMessages[0]

        let content = UNMutableNotificationContent()
        content.title = selected.0
        content.body = selected.1
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = Int.random(in: 0...15)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: "streak_reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleMilestoneReminder(buildName: String, progress: Int) {
        guard notificationsEnabled else { return }

        let milestoneMessages: [(String, String)]
        switch progress {
        case 0..<25:
            milestoneMessages = [
                ("Getting started on \(buildName)!", "You're \(progress)% in. The foundation is being laid."),
                ("\(buildName): \(progress)% done", "Every journey starts somewhere. You're already ahead of most."),
            ]
        case 25..<50:
            milestoneMessages = [
                ("\(buildName) is \(progress)% complete!", "Quarter of the way there. The momentum is building."),
                ("Making moves on \(buildName)!", "At \(progress)%, you're well past the starting line."),
            ]
        case 50..<75:
            milestoneMessages = [
                ("Halfway on \(buildName)!", "You're \(progress)% done. The finish line is getting closer."),
                ("\(buildName): \(progress)% and climbing!", "Past halfway! You can see the end from here."),
            ]
        case 75..<100:
            milestoneMessages = [
                ("Almost there: \(buildName)!", "At \(progress)%, you're in the home stretch. Don't slow down now!"),
                ("\(buildName) is \(progress)% done!", "So close you can taste it. Push through to the finish."),
            ]
        default:
            milestoneMessages = [
                ("\(buildName) complete!", "100%. You did it. Time to launch."),
                ("Build finished: \(buildName)", "From 0 to 100. You built this. Now go use it."),
            ]
        }

        let selected = milestoneMessages.randomElement() ?? milestoneMessages[0]

        let content = UNMutableNotificationContent()
        content.title = selected.0
        content.body = selected.1
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        let request = UNNotificationRequest(
            identifier: "milestone_\(progress)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
