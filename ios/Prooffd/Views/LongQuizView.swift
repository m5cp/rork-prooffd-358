import SwiftUI

struct LongQuizView: View {
    @Binding var isPresented: Bool
    var onComplete: () -> Void

    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var vm = LongQuizViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if vm.isComplete {
                    completionContent
                } else {
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
                    }

                    VStack {
                        Spacer()
                        bottomButton
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if vm.currentQuestion > 0 && !vm.isComplete {
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
                        Text("Q\(vm.currentQuestion + 1) of \(vm.totalQuestions)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.textTertiary)
                            .monospacedDigit()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        appState.applyLongQuizAnswers(vm)
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
            .onAppear {
                vm.loadFromProfile(appState.userProfile)
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.cardBackgroundLight).frame(height: 4)
                Capsule().fill(Theme.accent)
                    .frame(width: geo.size.width * vm.progress, height: 4)
                    .animation(.spring(duration: 0.4), value: vm.progress)
            }
        }
        .frame(height: 4)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text(vm.currentQ.title)
                .font(.title2.bold())
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
            Text(vm.currentQ.subtitle)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .id(vm.currentQuestion)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    @ViewBuilder
    private var questionContent: some View {
        Group {
            switch vm.currentQ {
            case .workEnvironments:    environmentsStep
            case .sellingComfort:      sellingStep
            case .hasCar:              hasCarStep
            case .techComfort:         techStep
            case .workStyle:           workStyleStep
            case .experienceLevel:     experienceStep
            case .customerInteraction: customerInteractionStep
            case .needsFastCash:       fastCashStep
            case .thingsToAvoid:       avoidStep
            case .physicalLimitation:  physicalLimitationStep
            case .learningStyle:       learningStep
            case .incomeTarget:        incomeTargetStep
            }
        }
        .id(vm.currentQuestion)
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
                withAnimation(.spring(duration: 0.35)) {
                    vm.next()
                }
                if vm.isComplete {
                    appState.applyLongQuizAnswers(vm)
                }
            } label: {
                Text(vm.currentQuestion == vm.totalQuestions - 1 ? "See Updated Matches" : "Continue")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(vm.canAdvance ? Theme.accent : Theme.accent.opacity(0.4))
                    .clipShape(.capsule)
            }
            .disabled(!vm.canAdvance)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .background(Theme.background)
        }
    }

    private var completionContent: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Theme.accent.opacity(0.15))
                    .frame(width: 120, height: 120)
                Image(systemName: "sparkles")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.accent)
            }
            VStack(spacing: 10) {
                Text("Your matches just got sharper")
                    .font(.title2.bold())
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                Text("We've updated your results based on your answers.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Spacer()
            Button {
                onComplete()
                dismiss()
            } label: {
                Text("See Updated Matches")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.accent)
                    .clipShape(.capsule)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Questions

    private var environmentsStep: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(WorkEnvironment.allCases) { env in
                let isSel = vm.selectedEnvironments.contains(env)
                chip(icon: env.icon, label: env.rawValue, isSelected: isSel, color: Theme.accentBlue) {
                    if isSel { vm.selectedEnvironments.removeAll { $0 == env } }
                    else { vm.selectedEnvironments.append(env) }
                }
            }
        }
    }

    private var sellingStep: some View {
        VStack(spacing: 12) {
            singleSelectCard(icon: "hand.raised.fill", title: "Not comfortable",
                             subtitle: "I prefer inbound clients",
                             isSelected: vm.sellingComfort == .notComfortable) {
                vm.sellingComfort = .notComfortable
            }
            singleSelectCard(icon: "hand.thumbsup.fill", title: "Somewhat",
                             subtitle: "I could learn to do it",
                             isSelected: vm.sellingComfort == .somewhat) {
                vm.sellingComfort = .somewhat
            }
            singleSelectCard(icon: "megaphone.fill", title: "Very comfortable",
                             subtitle: "I enjoy it",
                             isSelected: vm.sellingComfort == .veryComfortable) {
                vm.sellingComfort = .veryComfortable
            }
        }
    }

    private var hasCarStep: some View {
        VStack(spacing: 12) {
            yesNoCard(title: "Yes", icon: "car.fill",
                      isSelected: vm.hasCar == true) { vm.hasCar = true }
            yesNoCard(title: "No", icon: "car.side.fill",
                      isSelected: vm.hasCar == false) { vm.hasCar = false }
        }
    }

    private func techSubtitle(_ t: TechComfort) -> String {
        switch t {
        case .notComfortable: return "I avoid tech when I can"
        case .basic:          return "Email, browsing, basic apps"
        case .moderate:       return "Comfortable with most apps"
        case .verySavvy:      return "I pick up new tools easily"
        }
    }

    private func techIcon(_ t: TechComfort) -> String {
        switch t {
        case .notComfortable: return "exclamationmark.triangle"
        case .basic:          return "iphone"
        case .moderate:       return "laptopcomputer"
        case .verySavvy:      return "sparkles"
        }
    }

    private var techStep: some View {
        VStack(spacing: 12) {
            ForEach(TechComfort.allCases) { t in
                singleSelectCard(icon: techIcon(t), title: t.rawValue, subtitle: techSubtitle(t),
                                 isSelected: vm.techComfort == t) {
                    vm.techComfort = t
                }
            }
        }
    }

    private var workStyleStep: some View {
        VStack(spacing: 12) {
            singleSelectCard(icon: "person.fill", title: "Mostly solo",
                             subtitle: "I do my best work alone",
                             isSelected: vm.workStyle == .solo) { vm.workStyle = .solo }
            singleSelectCard(icon: "person.3.fill", title: "With people",
                             subtitle: "I'm energized by collaboration",
                             isSelected: vm.workStyle == .withPeople) { vm.workStyle = .withPeople }
            singleSelectCard(icon: "arrow.left.arrow.right", title: "Either works",
                             subtitle: "I'm flexible",
                             isSelected: vm.workStyle == .either) { vm.workStyle = .either }
        }
    }

    private func expIcon(_ lvl: ExperienceLevel) -> String {
        switch lvl {
        case .beginner: return "leaf.fill"
        case .some:     return "star.fill"
        case .skilled:  return "medal.fill"
        }
    }

    private func expSubtitle(_ lvl: ExperienceLevel) -> String {
        switch lvl {
        case .beginner: return "Starting fresh"
        case .some:     return "A few hobbies or side projects"
        case .skilled:  return "Trained or professionally experienced"
        }
    }

    private var experienceStep: some View {
        VStack(spacing: 12) {
            ForEach(ExperienceLevel.allCases) { lvl in
                singleSelectCard(icon: expIcon(lvl), title: lvl.rawValue, subtitle: expSubtitle(lvl),
                                 isSelected: vm.experienceLevel == lvl) {
                    vm.experienceLevel = lvl
                }
            }
        }
    }

    private var customerInteractionStep: some View {
        VStack(spacing: 12) {
            singleSelectCard(icon: "minus.circle.fill", title: "Minimal",
                             subtitle: "Keep it limited",
                             isSelected: vm.customerInteraction == .minimal) {
                vm.customerInteraction = .minimal
            }
            singleSelectCard(icon: "bubble.left.fill", title: "Some is fine",
                             subtitle: "A moderate amount works",
                             isSelected: vm.customerInteraction == .some) {
                vm.customerInteraction = .some
            }
            singleSelectCard(icon: "person.2.wave.2.fill", title: "Love it",
                             subtitle: "The more the better",
                             isSelected: vm.customerInteraction == .lots) {
                vm.customerInteraction = .lots
            }
        }
    }

    private var fastCashStep: some View {
        VStack(spacing: 12) {
            yesNoCard(title: "Yes", icon: "bolt.fill",
                      isSelected: vm.needsFastCash == true) { vm.needsFastCash = true }
            yesNoCard(title: "No", icon: "calendar",
                      isSelected: vm.needsFastCash == false) { vm.needsFastCash = false }
        }
    }

    private var avoidStep: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(ThingToAvoid.allCases) { thing in
                let isSel = vm.thingsToAvoid.contains(thing)
                chip(icon: thing.icon, label: thing.rawValue, isSelected: isSel,
                     color: Color(hex: "F59E0B")) {
                    if isSel { vm.thingsToAvoid.removeAll { $0 == thing } }
                    else { vm.thingsToAvoid.append(thing) }
                }
            }
        }
    }

    private var physicalLimitationStep: some View {
        VStack(spacing: 12) {
            yesNoCard(title: "Yes", icon: "figure.roll",
                      isSelected: vm.hasPhysicalLimitation == true) {
                vm.hasPhysicalLimitation = true
            }
            yesNoCard(title: "No", icon: "figure.walk",
                      isSelected: vm.hasPhysicalLimitation == false) {
                vm.hasPhysicalLimitation = false
            }
        }
    }

    private var learningStep: some View {
        VStack(spacing: 12) {
            ForEach(LearningStyle.allCases) { style in
                singleSelectCard(icon: style.icon, title: style.rawValue, subtitle: "",
                                 isSelected: vm.learningStyle == style) {
                    vm.learningStyle = style
                }
            }
        }
    }

    private var incomeTargetStep: some View {
        VStack(spacing: 10) {
            ForEach(IncomeTarget.allCases) { target in
                singleSelectCard(icon: target.icon, title: target.rawValue, subtitle: "",
                                 isSelected: vm.incomeTarget == target) {
                    vm.incomeTarget = target
                }
            }
        }
    }

    // MARK: - Reusable card UIs

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
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    private func yesNoCard(title: String, icon: String, isSelected: Bool,
                           action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(duration: 0.3)) { action() }
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isSelected ? Theme.accent : Theme.accent.opacity(0.12))
                        .frame(width: 56, height: 56)
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(isSelected ? .black : Theme.accent)
                }
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Theme.accent)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(18)
            .background(isSelected ? Theme.accent.opacity(0.08) : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Theme.accent : Theme.border,
                            lineWidth: isSelected ? 2 : 0.5)
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    private func chip(icon: String, label: String, isSelected: Bool, color: Color,
                      action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(duration: 0.3)) { action() }
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
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
