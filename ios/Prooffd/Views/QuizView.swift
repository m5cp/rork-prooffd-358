import SwiftUI

struct QuizView: View {
    @State private var viewModel = QuizViewModel()
    var onComplete: (UserProfile) -> Void
    var onSkip: () -> Void
    var onEarlyComplete: (UserProfile) -> Void
    var initialProfile: UserProfile

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    if viewModel.currentStep > 0 {
                        Button {
                            viewModel.previous()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Theme.cardBackground)
                                .frame(height: 6)
                            Capsule()
                                .fill(Theme.accent)
                                .frame(width: geo.size.width * viewModel.progress, height: 6)
                                .animation(.spring(duration: 0.4), value: viewModel.progress)
                        }
                    }
                    .frame(height: 6)

                    Text(viewModel.progressText)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Theme.textTertiary)
                        .fixedSize()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)


                TabView(selection: $viewModel.currentStep) {
                    ForEach(0..<viewModel.totalSteps, id: \.self) { step in
                        quizStep(step)
                            .tag(step)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(duration: 0.4, bounce: 0.1), value: viewModel.currentStep)

                VStack(spacing: 12) {
                    Button {
                        if viewModel.currentStep == viewModel.totalSteps - 1 {
                            onComplete(viewModel.profile)
                        } else {
                            viewModel.next()
                        }
                    } label: {
                        Text(viewModel.currentStep == viewModel.totalSteps - 1 ? "See My Matches" : "Continue")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(viewModel.canAdvance ? Theme.accent : Theme.cardBackgroundLight)
                            .clipShape(.capsule)
                    }
                    .disabled(!viewModel.canAdvance)
                    .sensoryFeedback(.selection, trigger: viewModel.currentStep)

                    if viewModel.canShowEarlyResults {
                        Button {
                            onEarlyComplete(viewModel.profile)
                        } label: {
                            Text("Go to Dashboard Now")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Theme.accent)
                        }
                    } else {
                        Button {
                            onSkip()
                        } label: {
                            Text("Skip for Now")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }

            if viewModel.showCheckpoint {
                checkpointOverlay
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.spring(duration: 0.4), value: viewModel.showCheckpoint)
        .onAppear {
            viewModel.profile = initialProfile
        }
    }

    private var checkpointOverlay: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.accent)
                        .symbolEffect(.bounce, options: .repeating.speed(0.5))

                    Text("2 Matches Found!")
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    Text("Based on your first answers")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }

                VStack(spacing: 10) {
                    ForEach(viewModel.checkpointMatches) { result in
                        checkpointMatchCard(result)
                    }
                }
                .padding(.horizontal, 8)

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        viewModel.dismissCheckpoint()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Keep Going for Better Matches")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.accent)
                        .clipShape(.capsule)
                    }
                    .sensoryFeedback(.impact(weight: .medium), trigger: viewModel.showCheckpoint)

                    Button {
                        viewModel.showCheckpoint = false
                        onEarlyComplete(viewModel.profile)
                    } label: {
                        Text("Go to Dashboard Now")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 20)
        }
    }

    private func checkpointMatchCard(_ result: MatchResult) -> some View {
        let catColor = Theme.categoryColor(for: result.businessPath.category)
        return HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(catColor.opacity(0.2))
                    .frame(width: 48, height: 48)
                Image(systemName: result.businessPath.icon)
                    .font(.title3)
                    .foregroundStyle(catColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(result.businessPath.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                HStack(spacing: 8) {
                    Text("\(result.scorePercentage)% match")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(catColor)
                    Text(result.businessPath.startupCostRange)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.3))
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 14))
    }

    @ViewBuilder
    private func quizStep(_ step: Int) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                if let motivation = viewModel.motivationMessage, step == viewModel.currentStep {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkle")
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                        Text(motivation)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Theme.accent)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Theme.accent.opacity(0.1))
                    .clipShape(.capsule)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                switch step {
                case 0: nameStep
                case 1: categoryStep
                case 2: workEnvironmentStep
                case 3: budgetStep
                case 4: hoursStep
                case 5: workPreferenceStep
                case 6: workStyleStep
                case 7: techComfortStep
                case 8: incomeTimelineStep
                default: EmptyView()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 80)
        }
        .scrollIndicators(.hidden)
    }

    private var nameStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "What's your first name?", subtitle: "We'll use this to personalize your experience.")
            TextField("", text: $viewModel.profile.firstName, prompt: Text("Your name").foregroundStyle(Theme.textTertiary))
                .font(.title2)
                .foregroundStyle(Theme.textPrimary)
                .padding()
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))
                .autocorrectionDisabled()
                .onSubmit { viewModel.next() }
        }
    }

    private var categoryStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "What interests you?", subtitle: "Select all that apply (up to 4).")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                ForEach(BusinessCategory.allCases) { category in
                    let isSelected = viewModel.profile.selectedCategories.contains(category)
                    let catColor = Theme.categoryColor(for: category)
                    Button {
                        withAnimation(.spring(duration: 0.25)) {
                            viewModel.toggleCategory(category)
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: category.icon)
                                .font(.title2)
                                .foregroundStyle(isSelected ? .white : catColor)
                            Text(category.rawValue)
                                .font(.caption.weight(.medium))
                                .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(isSelected ? .white : Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isSelected ? catColor.opacity(0.85) : Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? catColor : catColor.opacity(0.15), lineWidth: isSelected ? 2 : 1)
                        )
                    }
                    .sensoryFeedback(.selection, trigger: isSelected)
                }
            }

            if !viewModel.profile.selectedCategories.isEmpty {
                Text("\(viewModel.profile.selectedCategories.count) selected")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Theme.accent)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private var workEnvironmentStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Where do you want to work?", subtitle: "Select all that apply.")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                ForEach(WorkEnvironment.allCases) { env in
                    let isSelected = viewModel.profile.workEnvironments.contains(env)
                    Button {
                        withAnimation(.spring(duration: 0.25)) {
                            viewModel.toggleEnvironment(env)
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: env.icon)
                                .font(.body)
                                .foregroundStyle(isSelected ? .white : Theme.accent)
                            Text(env.rawValue)
                                .font(.subheadline.weight(.medium))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .foregroundStyle(isSelected ? .white : Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 14)
                        .background(isSelected ? Theme.accentBlue : Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Theme.accentBlue : Theme.cardBackground, lineWidth: 1.5)
                        )
                    }
                    .sensoryFeedback(.selection, trigger: isSelected)
                }
            }

            if !viewModel.profile.workEnvironments.isEmpty {
                Text("\(viewModel.profile.workEnvironments.count) selected")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Theme.accent)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private var budgetStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "What's your startup budget?", subtitle: "How much can you invest to get started?")
            optionList(BudgetRange.allCases, selected: viewModel.profile.budget) {
                viewModel.profile.budget = $0
            }
        }
    }

    private var hoursStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Hours per day?", subtitle: "How much time can you dedicate daily?")
            optionList(HoursPerDay.allCases, selected: viewModel.profile.hoursPerDay) {
                viewModel.profile.hoursPerDay = $0
            }
        }
    }

    private var workPreferenceStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Work preference?", subtitle: "Do you prefer physical or digital work?")
            optionList(WorkPreference.allCases, selected: viewModel.profile.workPreference) {
                viewModel.profile.workPreference = $0
            }
        }
    }

    private var workStyleStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Work style?", subtitle: "Do you prefer working alone or with others?")
            optionList(WorkStyle.allCases, selected: viewModel.profile.workStyle) {
                viewModel.profile.workStyle = $0
            }
        }
    }

    private var techComfortStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Tech comfort level?", subtitle: "How comfortable are you with technology?")
            optionList(TechComfort.allCases, selected: viewModel.profile.techComfort) {
                viewModel.profile.techComfort = $0
            }
        }
    }

    private var incomeTimelineStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "How soon do you need income?", subtitle: "This helps us match you with realistic timelines.")
            optionList(IncomeTimeline.allCases, selected: viewModel.profile.incomeTimeline) {
                viewModel.profile.incomeTimeline = $0
            }
        }
    }

    private func quizHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(Theme.textPrimary)
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private func optionList<T: Identifiable & RawRepresentable>(
        _ options: [T],
        selected: T?,
        onSelect: @escaping (T) -> Void
    ) -> some View where T.RawValue == String {
        VStack(spacing: 10) {
            ForEach(options) { option in
                let isSelected = selected?.rawValue == option.rawValue
                Button {
                    withAnimation(.spring(duration: 0.25)) {
                        onSelect(option)
                    }
                } label: {
                    Text(option.rawValue)
                        .font(.body.weight(.medium))
                        .foregroundStyle(isSelected ? .white : Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(isSelected ? Theme.accentBlue : Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                }
                .sensoryFeedback(.selection, trigger: isSelected)
            }
        }
    }

    private func boolButton(_ title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(duration: 0.25)) {
                action()
            }
        } label: {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.body.weight(.medium))
            }
            .foregroundStyle(isSelected ? .white : Theme.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(isSelected ? Theme.accentBlue : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
