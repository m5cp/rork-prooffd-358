import SwiftUI

struct FuturePlanQuizView: View {
    @Binding var isPresented: Bool
    var onComplete: () -> Void

    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var vm = FuturePlanViewModel()
    @State private var addedToMyPath = false

    var body: some View {
        NavigationStack {
            ZStack {
                ElectricBackdrop()

                if vm.isComplete {
                    resultsContent
                } else {
                    quizContent
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if vm.currentQuestionIndex > 0 && !vm.isComplete {
                        Button {
                            withAnimation(.spring(duration: 0.3)) { vm.previous() }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    if !vm.isComplete {
                        Text("Q\(vm.currentQuestionIndex + 1) of \(vm.totalQuestions)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.textTertiary)
                            .monospacedDigit()
                    } else {
                        Text("Future Plan")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !vm.isComplete { vm.savePartial() }
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .preferredColorScheme(.dark)
            .onAppear {
                vm.loadPartial()
                if let path = appState.myPath, let plan = appState.futurePlan,
                   path.id == plan.nicheId && path.name == plan.nicheName {
                    addedToMyPath = true
                }
            }
        }
    }

    // MARK: - Quiz Layout

    private var quizContent: some View {
        VStack(spacing: 0) {
            progressBar
                .padding(.horizontal, 16)
                .padding(.top, 8)

            ScrollView {
                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    questionContent
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 140)
            }
            .scrollIndicators(.hidden)

            VStack {
                Spacer()
                bottomButton
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.cardBackgroundLight).frame(height: 5)
                Capsule()
                    .fill(Theme.electricGradient)
                    .frame(width: geo.size.width * vm.progress, height: 5)
                    .shadow(color: Theme.accent.opacity(0.6), radius: 4)
                    .animation(.spring(duration: 0.4), value: vm.progress)
            }
        }
        .frame(height: 5)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text(vm.currentQ.title(for: vm.answers.stage))
                .font(.title2.bold())
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
            Text(vm.currentQ.subtitle(for: vm.answers.stage))
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .id(vm.currentQuestionIndex)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    @ViewBuilder
    private var questionContent: some View {
        Group {
            switch vm.currentQ {
            case .stage:            stageStep
            case .favoriteSubjects: subjectsStep
            case .workFeel:         workFeelStep
            case .activities:       activitiesStep
            case .freeTime:         freeTimeStep
            case .familySupport:    familySupportStep
            case .moneyGoal:        moneyGoalStep
            case .dreamLifestyle:   dreamLifestyleStep
            case .adultFocus:       adultFocusStep
            case .adultBudget:      adultBudgetStep
            case .incomeTarget:     incomeTargetStep
            }
        }
        .id(vm.currentQuestionIndex)
    }

    private var bottomButton: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [Theme.background.opacity(0), Theme.background],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 24)
            .allowsHitTesting(false)

            Button {
                if vm.currentQuestionIndex == vm.totalQuestions - 1 {
                    appState.applyFuturePlan(vm)
                } else {
                    withAnimation(.spring(duration: 0.35)) { vm.next() }
                }
            } label: {
                Text(vm.currentQuestionIndex == vm.totalQuestions - 1 ? "Build My Future Plan" : "Continue")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(vm.canAdvance
                        ? AnyShapeStyle(Theme.electricGradient)
                        : AnyShapeStyle(Theme.accent.opacity(0.4)))
                    .clipShape(.capsule)
                    .shadow(color: vm.canAdvance ? Theme.accent.opacity(0.35) : .clear, radius: 10, y: 4)
            }
            .disabled(!vm.canAdvance)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .background(Theme.background)
        }
    }

    // MARK: - Question Steps

    private var stageStep: some View {
        VStack(spacing: 12) {
            ForEach(SchoolStage.allCases) { stage in
                singleSelectCard(icon: stage.icon, title: stage.rawValue,
                                 subtitle: stage.subtitle,
                                 isSelected: vm.answers.stage == stage) {
                    vm.selectStage(stage)
                }
            }
        }
    }

    private var subjectsStep: some View {
        chipGrid(items: FavoriteSubject.allCases, icon: \.icon,
                 isSelected: { vm.answers.favoriteSubjects.contains($0) },
                 toggle: { vm.toggleSubject($0) })
    }

    private var workFeelStep: some View {
        chipGrid(items: WorkFeelInterest.allCases, icon: \.icon,
                 isSelected: { vm.answers.workFeel.contains($0) },
                 toggle: { vm.toggleWorkFeel($0) })
    }

    private var activitiesStep: some View {
        chipGrid(items: StudentActivity.allCases, icon: \.icon,
                 isSelected: { vm.answers.activities.contains($0) },
                 toggle: { vm.toggleActivity($0) })
    }

    private var freeTimeStep: some View {
        VStack(spacing: 12) {
            ForEach(HoursPerDay.allCases) { hours in
                singleSelectCard(icon: "clock.fill", title: "\(hours.rawValue) hours",
                                 subtitle: "",
                                 isSelected: vm.answers.freeTime == hours) {
                    vm.answers.freeTime = hours
                }
            }
        }
    }

    private var familySupportStep: some View {
        VStack(spacing: 12) {
            ForEach(FamilySupportLevel.allCases) { level in
                singleSelectCard(icon: level.icon, title: level.rawValue,
                                 subtitle: level.subtitle,
                                 isSelected: vm.answers.familySupport == level) {
                    vm.answers.familySupport = level
                }
            }
        }
    }

    private var moneyGoalStep: some View {
        VStack(spacing: 12) {
            ForEach(FirstMoneyGoal.allCases) { goal in
                singleSelectCard(icon: goal.icon, title: goal.rawValue,
                                 subtitle: "",
                                 isSelected: vm.answers.moneyGoal == goal) {
                    vm.answers.moneyGoal = goal
                }
            }
        }
    }

    private var dreamLifestyleStep: some View {
        VStack(spacing: 12) {
            ForEach(DreamLifestyle.allCases) { dream in
                singleSelectCard(icon: dream.icon, title: dream.rawValue,
                                 subtitle: "",
                                 isSelected: vm.answers.dreamLifestyle == dream) {
                    vm.answers.dreamLifestyle = dream
                }
            }
        }
    }

    private var adultFocusStep: some View {
        VStack(spacing: 12) {
            ForEach(AdultFocus.allCases) { focus in
                singleSelectCard(icon: focus.icon, title: focus.rawValue,
                                 subtitle: focus.subtitle,
                                 isSelected: vm.answers.adultFocus == focus) {
                    vm.answers.adultFocus = focus
                }
            }
        }
    }

    private var adultBudgetStep: some View {
        VStack(spacing: 12) {
            ForEach(BudgetRange.allCases) { budget in
                singleSelectCard(icon: "dollarsign.circle.fill", title: budget.rawValue,
                                 subtitle: "",
                                 isSelected: vm.answers.adultBudget == budget) {
                    vm.answers.adultBudget = budget
                }
            }
        }
    }

    private var incomeTargetStep: some View {
        VStack(spacing: 10) {
            ForEach(IncomeTarget.allCases) { target in
                singleSelectCard(icon: target.icon, title: target.rawValue,
                                 subtitle: "",
                                 isSelected: vm.answers.incomeTarget == target) {
                    vm.answers.incomeTarget = target
                }
            }
        }
    }

    // MARK: - Results

    private var resultsContent: some View {
        Group {
            if let plan = appState.futurePlan {
                ScrollView {
                    VStack(spacing: 24) {
                        heroCard(plan: plan)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)

                        if !plan.whyThisFits.isEmpty {
                            whyCard(plan: plan)
                                .padding(.horizontal, 20)
                        }

                        roadmapCard(plan: plan)
                            .padding(.horizontal, 20)

                        outlookSection(plan: plan)
                            .padding(.horizontal, 20)

                        resultsButtons(plan: plan)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                    }
                    .padding(.top, 8)
                }
                .scrollIndicators(.hidden)
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.largeTitle)
                        .foregroundStyle(Theme.textTertiary)
                    Spacer()
                }
            }
        }
    }

    private func heroCard(plan: FuturePlan) -> some View {
        VStack(spacing: 16) {
            Text("YOUR NICHE PICK")
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.textTertiary)
                .tracking(1.5)

            HStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Theme.accent.opacity(0.12))
                        .frame(width: 76, height: 76)
                    Image(systemName: plan.nicheIcon)
                        .font(.system(size: 34))
                        .foregroundStyle(Theme.accent)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(plan.nicheTypeLabel)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.textTertiary)
                        .tracking(0.5)
                    Text(plan.nicheName)
                        .font(.title2.bold())
                        .foregroundStyle(Theme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }

            HStack(spacing: 14) {
                confidenceRing(confidence: plan.confidence)
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(plan.confidence)% confident")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Based on your stage, interests, and answers")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(20)
        .background(Theme.accent.opacity(0.06))
        .electricCard(cornerRadius: 20)
        .shadow(color: Theme.accent.opacity(0.18), radius: 18, y: 8)
    }

    private func confidenceRing(confidence: Int) -> some View {
        ZStack {
            Circle()
                .stroke(Theme.cardBackgroundLight, lineWidth: 8)
            Circle()
                .trim(from: 0, to: Double(confidence) / 100)
                .stroke(Theme.electricGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: Theme.accent.opacity(0.5), radius: 4)
        }
        .frame(width: 64, height: 64)
    }

    private func whyCard(plan: FuturePlan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Why this fits you", systemImage: "sparkle")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.textPrimary)

            ForEach(plan.whyThisFits, id: \.self) { reason in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 2)
                    Text(reason)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .electricCard(cornerRadius: 16)
    }

    private func roadmapCard(plan: FuturePlan) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("Your roadmap", systemImage: "map.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.textPrimary)

            ForEach(Array(plan.roadmap.enumerated()), id: \.offset) { index, stage in
                HStack(alignment: .top, spacing: 14) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(Theme.accent)
                            .frame(width: 12, height: 12)
                        if index < plan.roadmap.count - 1 {
                            Rectangle()
                                .fill(Theme.accent.opacity(0.25))
                                .frame(width: 2)
                                .frame(maxHeight: .infinity)
                        }
                    }
                    .frame(width: 12)

                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(stage.title)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(Theme.textPrimary)
                            Text(stage.subtitle)
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(stage.milestones, id: \.self) { milestone in
                                HStack(alignment: .top, spacing: 8) {
                                    Circle()
                                        .fill(Theme.textTertiary.opacity(0.4))
                                        .frame(width: 5, height: 5)
                                        .padding(.top, 5)
                                    Text(milestone)
                                        .font(.caption)
                                        .foregroundStyle(Theme.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                    Spacer(minLength: 0)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .electricCard(cornerRadius: 16)
    }

    private func outlookSection(plan: FuturePlan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("What life could look like", systemImage: "binoculars.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.textPrimary)

            ForEach(plan.ageOutlook, id: \.age) { snapshot in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Text("AGE \(snapshot.age)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.accent)
                            .tracking(1)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Theme.accent.opacity(0.1))
                            .clipShape(.capsule)
                        Text(snapshot.educationStatus)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Text(snapshot.earnings)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(snapshot.lifestyle)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .electricCard(cornerRadius: 14)
            }
        }
    }

    private func resultsButtons(plan: FuturePlan) -> some View {
        VStack(spacing: 10) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    appState.addFuturePlanToMyPath()
                    addedToMyPath = true
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: addedToMyPath ? "checkmark.circle.fill" : "flag.fill")
                    Text(addedToMyPath ? "Added to My Path" : "Add to My Path")
                }
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(addedToMyPath
                    ? AnyShapeStyle(Theme.accent.opacity(0.85))
                    : AnyShapeStyle(Theme.electricGradient))
                .clipShape(.capsule)
                .shadow(color: addedToMyPath ? .clear : Theme.accent.opacity(0.35), radius: 10, y: 4)
            }
            .disabled(addedToMyPath)
            .sensoryFeedback(.success, trigger: addedToMyPath)

            Button {
                onComplete()
                dismiss()
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.cardBackgroundLight)
                    .clipShape(.capsule)
            }
        }
    }

    // MARK: - Reusable card UIs

    private func chipGrid<T: Identifiable & RawRepresentable>(items: [T],
                                                              icon keyPath: KeyPath<T, String>,
                                                              isSelected: @escaping (T) -> Bool,
                                                              toggle: @escaping (T) -> Void) -> some View
    where T.RawValue == String {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(items) { item in
                let selected = isSelected(item)
                chipButton(icon: item[keyPath: keyPath], label: item.rawValue,
                           isSelected: selected,
                           color: Theme.accentBlue) {
                    withAnimation(.spring(duration: 0.3)) { toggle(item) }
                }
            }
        }
    }

    private func chipButton(icon: String, label: String, isSelected: Bool,
                            color: Color, action: @escaping () -> Void) -> some View {
        Button {
            action()
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
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(isSelected ? color.opacity(0.06) : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? color : Theme.border,
                            lineWidth: isSelected ? 1.5 : 0.5)
            )
            .shadow(color: isSelected ? color.opacity(0.28) : .clear, radius: 10, y: 3)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    private func singleSelectCard(icon: String, title: String, subtitle: String,
                                  isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(duration: 0.3)) { action() }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Theme.accent : Theme.accent.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(isSelected ? .black : Theme.accent)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .lineLimit(2)
                    }
                }
                Spacer(minLength: 4)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Theme.accent : Theme.textTertiary)
            }
            .padding(14)
            .background(isSelected ? Theme.accent.opacity(0.08) : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Theme.accent : Theme.border,
                            lineWidth: isSelected ? 1.5 : 0.5)
            )
            .shadow(color: isSelected ? Theme.accent.opacity(0.28) : .clear, radius: 10, y: 3)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

