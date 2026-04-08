import SwiftUI

struct OnboardingView: View {
    var onComplete: (ChosenPath, UserProfile) -> Void
    @State private var vm = OnboardingViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            meshBackground

            VStack(spacing: 0) {
                headerBar
                    .padding(.top, 8)

                progressBar
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                ScrollView {
                    VStack(spacing: 0) {
                        stepHeader
                            .padding(.top, 28)
                            .padding(.bottom, 24)

                        stepContent
                            .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 120)
                }
                .scrollIndicators(.hidden)

                Spacer(minLength: 0)
            }

            VStack {
                Spacer()
                bottomButtons
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.6).delay(0.15)) {
                vm.appeared = true
            }
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            if vm.currentStep > 0 {
                Button {
                    vm.previous()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(width: 44, height: 44)
                }
                .transition(.opacity)
            } else {
                Color.clear.frame(width: 44, height: 44)
            }

            Spacer()

            Text("\(vm.currentStep + 1) of \(vm.totalSteps)")
                .font(.caption.weight(.medium))
                .foregroundStyle(Theme.textTertiary)
                .monospacedDigit()

            Spacer()

            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .animation(.spring(duration: 0.3), value: vm.currentStep)
    }

    // MARK: - Progress

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Theme.cardBackgroundLight)
                    .frame(height: 4)

                Capsule()
                    .fill(Theme.accent)
                    .frame(width: geo.size.width * vm.progress, height: 4)
                    .animation(.spring(duration: 0.5, bounce: 0.15), value: vm.progress)
            }
        }
        .frame(height: 4)
    }

    // MARK: - Step Header

    private var stepHeader: some View {
        VStack(spacing: 8) {
            Text(vm.stepTitle)
                .font(.title.bold())
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)

            Text(vm.stepSubtitle)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .id(vm.currentStep)
        .transition(.asymmetric(
            insertion: .move(edge: vm.direction).combined(with: .opacity),
            removal: .move(edge: vm.direction == .trailing ? .leading : .trailing).combined(with: .opacity)
        ))
        .animation(.spring(duration: 0.4, bounce: 0.1), value: vm.currentStep)
    }

    // MARK: - Step Content

    @ViewBuilder
    private var stepContent: some View {
        Group {
            switch vm.currentStep {
            case 0: pathSelectionStep
            case 1: workPreferenceStep
            case 2: workEnvironmentStep
            case 3: workConditionsStep
            case 4: budgetStep
            case 5: hoursStep
            case 6: incomeTimelineStep
            case 7: educationStep
            default: EmptyView()
            }
        }
        .id(vm.currentStep)
        .transition(.asymmetric(
            insertion: .move(edge: vm.direction).combined(with: .opacity),
            removal: .move(edge: vm.direction == .trailing ? .leading : .trailing).combined(with: .opacity)
        ))
        .animation(.spring(duration: 0.4, bounce: 0.1), value: vm.currentStep)
    }

    // MARK: - Step 0: Path Selection

    private var pathSelectionStep: some View {
        VStack(spacing: 14) {
            ForEach([ChosenPath.business, .trades, .degree], id: \.rawValue) { path in
                let isSelected = vm.chosenPath == path
                Button {
                    withAnimation(.spring(duration: 0.35)) {
                        vm.chosenPath = path
                    }
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isSelected ? path.color : path.color.opacity(0.12))
                                .frame(width: 56, height: 56)
                            Image(systemName: path.icon)
                                .font(.title2)
                                .foregroundStyle(isSelected ? .white : path.color)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(path.title)
                                .font(.headline)
                                .foregroundStyle(Theme.textPrimary)
                            Text(path.subtitle)
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                                .lineLimit(2)
                        }

                        Spacer(minLength: 4)

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(path.color)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(16)
                    .background(isSelected ? path.color.opacity(0.08) : Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(isSelected ? path.color : Theme.border, lineWidth: isSelected ? 2 : 0.5)
                    )
                    .shadow(color: isSelected ? path.color.opacity(0.15) : .clear, radius: 12, y: 4)
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: isSelected)
            }
        }
    }

    // MARK: - Step 1: Work Preference

    private var workPreferenceStep: some View {
        VStack(spacing: 12) {
            workPrefCard(
                icon: "hammer.fill",
                title: "Hands-on & Physical",
                subtitle: "Building, fixing, working with your hands",
                value: .physical,
                color: Color(hex: "F59E0B")
            )
            workPrefCard(
                icon: "laptopcomputer",
                title: "Computer & Digital",
                subtitle: "Remote, online, screen-based work",
                value: .digital,
                color: Theme.accentBlue
            )
            workPrefCard(
                icon: "arrow.left.arrow.right",
                title: "Mix of Both",
                subtitle: "Flexible between physical and digital",
                value: .either,
                color: Theme.accent
            )
        }
    }

    private func workPrefCard(icon: String, title: String, subtitle: String, value: WorkPreference, color: Color) -> some View {
        let isSelected = vm.workPreference == value
        return Button {
            withAnimation(.spring(duration: 0.35)) {
                vm.workPreference = value
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : color)
                    .frame(width: 48, height: 48)
                    .background(isSelected ? color : color.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer(minLength: 4)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(color)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(14)
            .background(isSelected ? color.opacity(0.06) : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? color : Theme.border, lineWidth: isSelected ? 1.5 : 0.5)
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - Step 2: Work Environment

    private var workEnvironmentStep: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(WorkEnvironment.allCases) { env in
                chipToggle(
                    icon: env.icon,
                    label: env.rawValue,
                    isSelected: vm.workEnvironments.contains(env),
                    color: Theme.accentBlue
                ) {
                    vm.toggleEnvironment(env)
                }
            }
        }
    }

    // MARK: - Step 3: Work Conditions

    private var workConditionsStep: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(WorkCondition.allCases) { condition in
                chipToggle(
                    icon: condition.icon,
                    label: condition.rawValue,
                    isSelected: vm.workConditions.contains(condition),
                    color: Color(hex: "F59E0B")
                ) {
                    vm.toggleCondition(condition)
                }
            }
        }
    }

    // MARK: - Step 4: Budget

    private var budgetStep: some View {
        VStack(spacing: 10) {
            ForEach(BudgetRange.allCases) { range in
                let isSelected = vm.budget == range
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        vm.budget = range
                    }
                } label: {
                    HStack {
                        Text(range.rawValue)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Theme.accent)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                    .background(isSelected ? Theme.accent.opacity(0.08) : Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: isSelected ? 1.5 : 0.5)
                    )
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: isSelected)
            }
        }
    }

    // MARK: - Step 5: Hours

    private var hoursStep: some View {
        VStack(spacing: 10) {
            ForEach(HoursPerDay.allCases) { hours in
                let isSelected = vm.hoursPerDay == hours
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        vm.hoursPerDay = hours
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(hours.rawValue + " hours")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Theme.textPrimary)
                            Text(hoursDetail(hours))
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Theme.accent)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(isSelected ? Theme.accent.opacity(0.08) : Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: isSelected ? 1.5 : 0.5)
                    )
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: isSelected)
            }
        }
    }

    private func hoursDetail(_ hours: HoursPerDay) -> String {
        switch hours {
        case .lessThan1: return "Side project pace"
        case .oneToTwo: return "Great for a side hustle"
        case .threeToFour: return "Serious commitment"
        case .fivePlus: return "Full-time dedication"
        }
    }

    // MARK: - Step 6: Income Timeline

    private var incomeTimelineStep: some View {
        VStack(spacing: 10) {
            ForEach(IncomeTimeline.allCases) { timeline in
                let isSelected = vm.incomeTimeline == timeline
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        vm.incomeTimeline = timeline
                    }
                } label: {
                    HStack {
                        Text(timeline.rawValue)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Theme.accent)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                    .background(isSelected ? Theme.accent.opacity(0.08) : Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: isSelected ? 1.5 : 0.5)
                    )
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: isSelected)
            }
        }
    }

    // MARK: - Step 7: Education

    private var educationStep: some View {
        VStack(spacing: 10) {
            ForEach(EducationWillingness.allCases) { edu in
                let isSelected = vm.educationWillingnesses.contains(edu)
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        vm.toggleEducation(edu)
                    }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: edu.icon)
                            .font(.body)
                            .foregroundStyle(isSelected ? .white : Theme.accent)
                            .frame(width: 40, height: 40)
                            .background(isSelected ? Theme.accent : Theme.accent.opacity(0.12))
                            .clipShape(.rect(cornerRadius: 10))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(edu.rawValue)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Theme.textPrimary)
                            Text(edu.subtitle)
                                .font(.caption2)
                                .foregroundStyle(Theme.textSecondary)
                                .lineLimit(2)
                        }

                        Spacer(minLength: 4)

                        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                            .font(.title3)
                            .foregroundStyle(isSelected ? Theme.accent : Theme.textTertiary)
                    }
                    .padding(12)
                    .background(isSelected ? Theme.accent.opacity(0.06) : Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: isSelected ? 1.5 : 0.5)
                    )
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: isSelected)
            }
        }
    }

    // MARK: - Chip Toggle

    private func chipToggle(icon: String, label: String, isSelected: Bool, color: Color, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                action()
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(isSelected ? .white : color)
                    .frame(width: 28, height: 28)
                    .background(isSelected ? color : color.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 7))

                Text(label)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(isSelected ? color.opacity(0.06) : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? color : Theme.border, lineWidth: isSelected ? 1.5 : 0.5)
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - Bottom Buttons

    private var bottomButtons: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [
                    colorScheme == .dark ? Color(hex: "0F1117").opacity(0) : Color(hex: "F5F5F7").opacity(0),
                    colorScheme == .dark ? Color(hex: "0F1117") : Color(hex: "F5F5F7")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 32)
            .allowsHitTesting(false)

            VStack(spacing: 12) {
                if vm.currentStep == vm.totalSteps - 1 {
                    Button {
                        guard let path = vm.chosenPath else { return }
                        let profile = vm.buildProfile()
                        onComplete(path, profile)
                    } label: {
                        HStack(spacing: 8) {
                            Text("See My Matches")
                                .font(.headline)
                            Image(systemName: "sparkles")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(vm.canAdvance ? Theme.accent : Theme.cardBackgroundLight)
                        .clipShape(.capsule)
                    }
                    .disabled(!vm.canAdvance)
                    .sensoryFeedback(.impact(weight: .medium), trigger: vm.currentStep == vm.totalSteps - 1 && vm.canAdvance)
                } else {
                    Button {
                        vm.next()
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(vm.canAdvance ? Theme.accent : Theme.cardBackgroundLight)
                            .clipShape(.capsule)
                    }
                    .disabled(!vm.canAdvance)
                    .sensoryFeedback(.selection, trigger: vm.currentStep)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 36)
            .background(colorScheme == .dark ? Color(hex: "0F1117") : Color(hex: "F5F5F7"))
        }
    }

    // MARK: - Background

    private var meshBackground: some View {
        Group {
            if colorScheme == .dark {
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                    colors: [
                        Color(hex: "0F1117"), Color(hex: "131620"), Color(hex: "0F1117"),
                        Color(hex: "111420"), Color(hex: "14201A"), Color(hex: "111420"),
                        Color(hex: "0F1117"), Color(hex: "131620"), Color(hex: "0F1117")
                    ]
                )
                .ignoresSafeArea()
            } else {
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                    colors: [
                        Color(hex: "F8F8FA"), Color(hex: "EEF5F0"), Color(hex: "F8F8FA"),
                        Color(hex: "F0F5EE"), Color(hex: "E8F0E8"), Color(hex: "EEF2F6"),
                        Color(hex: "F8F8FA"), Color(hex: "F2F2F5"), Color(hex: "F8F8FA")
                    ]
                )
                .ignoresSafeArea()
            }
        }
    }
}
