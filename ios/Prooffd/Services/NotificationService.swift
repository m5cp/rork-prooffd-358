import Foundation
import UserNotifications

@Observable
class NotificationService {
    static let shared = NotificationService()

    var notificationsEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "notificationsEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "notificationsEnabled") }
    }

    private init() {}

    func enableNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            Task { @MainActor in
                if granted {
                    self.notificationsEnabled = true
                    self.scheduleGentleReminders()
                } else {
                    self.notificationsEnabled = false
                }
            }
        }
    }

    func disableNotifications() {
        notificationsEnabled = false
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func scheduleGentleReminders() {
        guard notificationsEnabled else { return }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        let reminders: [(String, String, Int, Int)] = [
            ("Keep your streak alive!", "Open the app to maintain your streak and earn points.", 9, 0),
            ("Time for your next step", "You're making progress — complete today's step to keep going.", 12, 0),
            ("Don't forget your build!", "A few minutes a day adds up. Check your progress.", 18, 0),
        ]

        for (index, reminder) in reminders.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = reminder.0
            content.body = reminder.1
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = reminder.2
            dateComponents.minute = reminder.3

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "gentle_reminder_\(index)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request)
        }
    }

    func scheduleStreakReminder(currentStreak: Int) {
        guard notificationsEnabled, currentStreak > 0 else { return }

        let content = UNMutableNotificationContent()
        content.title = "\(currentStreak) day streak!"
        content.body = "Don't lose your \(currentStreak)-day streak. Open Prooffd to keep it going."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0

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

        let content = UNMutableNotificationContent()
        content.title = "You're \(progress)% done!"
        content.body = "Your \(buildName) build is coming along. Keep going!"
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
