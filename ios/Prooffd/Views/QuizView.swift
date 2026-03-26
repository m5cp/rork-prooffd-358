import SwiftUI

struct QuizView: View {
    @State private var viewModel = QuizViewModel()
    var onComplete: (UserProfile) -> Void
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
                        .accessibilityLabel("Go back")
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

                    Text("\(viewModel.currentStep + 1)/\(viewModel.totalSteps)")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .monospacedDigit()
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
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            viewModel.profile = initialProfile
        }
    }

    @ViewBuilder
    private func quizStep(_ step: Int) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                switch step {
                case 0: nameStep
                case 1: categoryStep
                case 2: budgetStep
                case 3: hoursStep
                case 4: workPreferenceStep
                case 5: workStyleStep
                case 6: workConditionsStep
                case 7: techComfortStep
                case 8: experienceStep
                case 9: customerInteractionStep
                case 10: carStep
                case 11: sellingComfortStep
                case 12: fastCashStep
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
            quizHeader(title: "Pick your top 2 work categories", subtitle: "Choose the areas that interest you most.")

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

    private var workConditionsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "What are you okay with?", subtitle: "Select all work conditions you can tolerate.")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                ForEach(WorkCondition.allCases) { condition in
                    let isSelected = viewModel.profile.workConditions.contains(condition)
                    Button {
                        withAnimation(.spring(duration: 0.25)) {
                            viewModel.toggleCondition(condition)
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: condition.icon)
                                .font(.caption)
                            Text(condition.rawValue)
                                .font(.caption)
                        }
                        .foregroundStyle(isSelected ? .white : Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(isSelected ? Theme.accentBlue : Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                }
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

    private var experienceStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Experience level?", subtitle: "What's your overall work experience?")
            optionList(ExperienceLevel.allCases, selected: viewModel.profile.experienceLevel) {
                viewModel.profile.experienceLevel = $0
            }
        }
    }

    private var customerInteractionStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Customer interaction?", subtitle: "How much do you want to interact with customers?")
            optionList(CustomerInteraction.allCases, selected: viewModel.profile.customerInteraction) {
                viewModel.profile.customerInteraction = $0
            }
        }
    }

    private var carStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Do you have a car?", subtitle: "Some businesses require reliable transportation.")
            HStack(spacing: 12) {
                boolButton("Yes", icon: "car.fill", isSelected: viewModel.profile.hasCar == true) {
                    viewModel.profile.hasCar = true
                }
                boolButton("No", icon: "figure.walk", isSelected: viewModel.profile.hasCar == false) {
                    viewModel.profile.hasCar = false
                }
            }
        }
    }

    private var sellingComfortStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Comfort with selling?", subtitle: "How comfortable are you pitching your services?")
            optionList(SellingComfort.allCases, selected: viewModel.profile.sellingComfort) {
                viewModel.profile.sellingComfort = $0
            }
        }
    }

    private var fastCashStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            quizHeader(title: "Need fast cash?", subtitle: "Are you looking to earn money quickly?")
            HStack(spacing: 12) {
                boolButton("Yes, ASAP", icon: "bolt.fill", isSelected: viewModel.profile.needsFastCash == true) {
                    viewModel.profile.needsFastCash = true
                }
                boolButton("No rush", icon: "clock.fill", isSelected: viewModel.profile.needsFastCash == false) {
                    viewModel.profile.needsFastCash = false
                }
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
        .accessibilityElement(children: .combine)
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
    }
}
