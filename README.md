# Prooffd

A native iOS app that matches you with real business ideas based on your skills, budget, time, and preferences. Answer a short quiz and get personalized business path recommendations you can start this week.

## Features

- **Personalized Quiz** — Answer questions about your budget, available hours, tech comfort, experience level, and more to get tailored results.
- **50 Business Paths** — A curated database of real, actionable business ideas across categories like home services, food & beverage, pet services, digital/online, and more.
- **Smart Matching Engine** — Scores and ranks business paths based on your unique profile, so you see the most relevant options first.
- **Detailed Path Breakdowns** — Each business path includes startup cost ranges, time to first dollar, action plans, and customer type info.
- **Pro Templates** (Pro) — Draft emails, text message templates, sales intro scripts, social media posts, offer/pricing sheets, and one-page business plans for each path.
- **PDF Export** (Pro) — Export business plans and templates as PDFs.
- **Discover Tab** — Browse all business paths, daily tips, and weekly challenges to keep you motivated.
- **Progress Tracking** — Readiness score, streak tracker, and achievements to gamify your journey.
- **What-If Scenarios** — Explore how changing your profile (budget, hours, skills) would unlock different paths.
- **Favorites** — Save business paths you're interested in for quick access.
- **Share Cards** — Share your quiz results and top matches with friends.

## Tech Stack

- **Swift & SwiftUI** — 100% native iOS, targeting iOS 18+
- **MVVM Architecture** — Clean separation of views, view models, models, and services
- **@Observable** — Modern Swift observation for reactive state management
- **RevenueCat** — In-app subscription management for Pro features
- **Dark Mode** — Dark theme by default with a custom color system
- **UserDefaults** — Local persistence for profile, favorites, streaks, and achievements

## Project Structure

```
Prooffd/
├── ProoffdApp.swift              # App entry point
├── ContentView.swift             # Root navigation
├── Models/
│   ├── BusinessPath.swift        # Business path data model
│   ├── Category.swift            # Business categories
│   ├── UserProfile.swift         # User quiz profile
│   ├── Achievement.swift         # Gamification achievements
│   ├── DailyTip.swift            # Daily tip model
│   ├── WeeklyChallenge.swift     # Weekly challenge model
│   └── StreakTracker.swift        # App usage streak tracking
├── Views/
│   ├── OnboardingView.swift      # First-launch onboarding
│   ├── QuizView.swift            # Profile quiz flow
│   ├── AnalyzingView.swift       # Matching animation
│   ├── ResultsView.swift         # Main tab view (Matches, Discover, Progress)
│   ├── PathDetailView.swift      # Individual business path details
│   ├── DiscoverView.swift        # Browse all paths and tips
│   ├── ProgressView.swift        # Readiness score and achievements
│   ├── PaywallView.swift         # Pro subscription paywall
│   ├── SettingsView.swift        # App settings
│   ├── WhatIfView.swift          # What-if scenario explorer
│   ├── DisclaimerView.swift      # Legal disclaimer
│   ├── TermsOfServiceView.swift  # Terms of service
│   └── PrivacyPolicyView.swift   # Privacy policy
├── ViewModels/
│   ├── AppState.swift            # Central app state
│   ├── QuizViewModel.swift       # Quiz logic
│   └── StoreViewModel.swift      # RevenueCat subscription logic
├── Services/
│   ├── BusinessPathDatabase.swift    # Business path data
│   ├── MatchingEngine.swift          # Profile-to-path matching algorithm
│   └── BusinessPlanGenerator.swift   # Business plan generation
└── Utilities/
    └── Theme.swift               # App-wide color and styling
```

## Disclaimer

Prooffd is for **entertainment and informational purposes only**. It does not constitute financial, investment, business, or legal advice.

- There is **no promise or expectation** you will earn any money using this app.
- You **could lose money** on any business idea presented.
- We are **not responsible** for any money you spend pursuing ideas from this app.
- **Do your own research** — consult licensed professionals, and check your local, state, and federal laws regarding business licensing, LLC formation, permits, taxes, and gig economy regulations before starting anything.

## License

All rights reserved.
