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
                            viewModel.applyDerivedFields()
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
                            viewModel.applyDerivedFields()
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
                        viewModel.applyDerivedFields()
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
                case 0: categoryStep
                case 1: workEnvironmentStep
                case 2: workConditionsStep
                case 3: situationStep
                default: EmptyView()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 80)
        }
        .scrollIndicators(.hidden)
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

    private var workConditionsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "What conditions are you okay with?", subtitle: "Select all that apply.")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                ForEach(WorkCondition.allCases) { condition in
                    let isSelected = viewModel.profile.workConditions.contains(condition)
                    Button {
                        withAnimation(.spring(duration: 0.25)) {
                            viewModel.toggleCondition(condition)
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: condition.icon)
                                .font(.body)
                                .foregroundStyle(isSelected ? .white : Theme.accent)
                            Text(condition.rawValue)
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

            if !viewModel.profile.workConditions.isEmpty {
                Text("\(viewModel.profile.workConditions.count) selected")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Theme.accent)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private var situationStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "What describes your situation?", subtitle: "Select all that apply.")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                ForEach(SituationTag.allCases) { tag in
                    let isSelected = viewModel.profile.situationTags.contains(tag)
                    Button {
                        withAnimation(.spring(duration: 0.25)) {
                            viewModel.toggleSituationTag(tag)
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: tag.icon)
                                .font(.body)
                                .foregroundStyle(isSelected ? .white : Theme.accent)
                            Text(tag.rawValue)
                                .font(.subheadline.weight(.medium))
                                .lineLimit(2)
                                .minimumScaleFactor(0.75)
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

            if !viewModel.profile.situationTags.isEmpty {
                Text("\(viewModel.profile.situationTags.count) selected")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Theme.accent)
                    .frame(maxWidth: .infinity, alignment: .center)
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
}
