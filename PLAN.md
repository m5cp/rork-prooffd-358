# Quick wins + medium-priority upgrades for Prooffd

## Quick wins (low risk)

- [x] **Fix the EULA link** — EULA now opens Apple's standard EULA URL via `Link`.
- [x] **Clean up the "Save vs 1 year" badge on Lifetime** — removed synthetic savings badge.
- [x] **Add "Prooffd" brand lockup to share cards** — `ProooffdLockup` used in all three share cards.
- [x] **Replace legacy delayed callbacks with modern async waits** — all `DispatchQueue.main.asyncAfter` in views swapped for `Task.sleep`.
- [x] **Streak freeze (1 grace day per week)** — weekly ISO-week freeze, `streakFreezeJustUsed` surfaces a notice in Progress.
- [x] **Weekly Summary card (appears on Mondays)** — `WeeklySummaryCard` + `WeeklySummaryScheduler` on Explore tab.
- [x] **Siri tip on Results screen** — `SiriDailyTipHint` chip on Explore, dismissible, remembers state.

## Medium priority (test before shipping)

- [x] **Add an Annual plan and re-rank the paywall** — Annual default-selected with weekly framing, Monthly next, Lifetime demoted. (Requires adding an annual product in App Store Connect + RevenueCat offerings.)
- [x] **"Your plan: before vs after" visual at the top of the paywall** — two-column Free vs Pro comparison.
- [x] **Live Activity for active build + streak** — `BuildLiveActivity` widget + `BuildLiveActivityService`, `NSSupportsLiveActivities` added.
- [x] **Interactive widget: "Complete today's action"** — `CompleteMicroActionIntent` on medium + large widgets, reconciled on next app open.
- [x] **Foundation Models powered daily tip (iOS 26+)** — `PersonalizedTipService` generates a personalized daily tip on-device, falls back to curated library.
- [x] **Accessibility spot-check** — added 44pt minimum frames on paywall toolbar/restore, combined accessibility labels on plan columns, summary stats, and Siri tip.

## What won't change

- Onboarding flow, skip behavior, quiz logic, existing build/plan data, notification content library, and the overall navigation structure all stay as-is.
- No framework removals, no auth changes, no data migrations.
