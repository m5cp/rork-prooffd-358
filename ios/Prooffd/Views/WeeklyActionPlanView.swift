import SwiftUI

struct WeeklyActionPlanView: View {
    @Binding var plan: WeeklyActionPlan
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var showPaywall = false

    private var completedCount: Int { plan.actions.filter { $0.isCompleted }.count }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    progressHeader
                    ForEach(Array(plan.actions.enumerated()), id: \.element.id) { index, action in
                        dayCard(action: action, index: index)
                    }
                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, sizeClass == .regular ? 40 : 16)
                .padding(.top, 12)
            }
            .background(Theme.background)
            .navigationTitle("Week 1 Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }.foregroundStyle(Theme.accent)
                }
            }
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: plan.pathIcon)
                    .font(.title2)
                    .foregroundStyle(Theme.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text(plan.pathName).font(.headline).foregroundStyle(Theme.textPrimary)
                    Text("\(completedCount)/7 days complete").font(.caption).foregroundStyle(Theme.textSecondary)
                }
                Spacer()
            }
            ProgressView(value: Double(completedCount), total: 7).tint(Theme.accent)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
    }

    private func dayCard(action: DailyAction, index: Int) -> some View {
        let isLocked = index >= 3 && !store.isPremium
        let showUnlockBanner = index == 3 && !store.isPremium

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle()
                        .fill(action.isCompleted ? Theme.accent :
                              isLocked ? Theme.textTertiary.opacity(0.15) : Theme.accent.opacity(0.15))
                        .frame(width: 32, height: 32)
                    if action.isCompleted {
                        Image(systemName: "checkmark").font(.caption.weight(.bold)).foregroundStyle(.black)
                    } else {
                        Text("\(action.dayNumber)").font(.caption.weight(.bold))
                            .foregroundStyle(isLocked ? Theme.textTertiary : Theme.accent)
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(action.dayLabel).font(.caption).foregroundStyle(Theme.textSecondary)
                    Text(action.title).font(.subheadline.weight(.semibold))
                        .foregroundStyle(isLocked ? Theme.textTertiary : Theme.textPrimary)
                }
                Spacer()
                if !isLocked {
                    HStack(spacing: 3) {
                        Image(systemName: "clock").font(.caption2)
                        Text("\(action.estimatedMinutes) min").font(.caption)
                    }
                    .foregroundStyle(Theme.textTertiary)
                } else {
                    Image(systemName: "lock.fill").font(.caption).foregroundStyle(Theme.textTertiary)
                }
            }

            if showUnlockBanner {
                Button { showPaywall = true } label: {
                    HStack {
                        Image(systemName: "lock.fill").foregroundStyle(Theme.accent)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Unlock Days 4–7 with Pro")
                                .font(.subheadline.weight(.semibold)).foregroundStyle(Theme.textPrimary)
                            Text("4 more specific action steps to complete your first week")
                                .font(.caption).foregroundStyle(Theme.textSecondary)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Text("Upgrade").font(.caption.weight(.bold)).foregroundStyle(.black)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Theme.accent).clipShape(Capsule())
                    }
                }
            } else if !isLocked {
                Text(action.detail).font(.caption).foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if !action.isCompleted {
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            plan.actions[index].isCompleted = true
                            ActionPlanGenerator.save(plan)
                        }
                    } label: {
                        Text("Mark Complete").font(.caption.weight(.semibold)).foregroundStyle(Theme.accent)
                            .padding(.horizontal, 14).padding(.vertical, 7)
                            .background(Theme.accent.opacity(0.12)).clipShape(Capsule())
                    }
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14)
            .stroke(action.isCompleted ? Theme.accent.opacity(0.4) : Theme.border, lineWidth: 1))
        .opacity(isLocked && index > 3 ? 0.45 : 1)
    }
}
