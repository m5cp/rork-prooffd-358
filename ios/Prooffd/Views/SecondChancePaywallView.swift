import SwiftUI
import RevenueCat

struct SecondChancePaywallView: View {
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Theme.border)
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            Image(systemName: "gift.fill")
                .font(.system(size: 44))
                .foregroundStyle(Theme.accent)

            VStack(spacing: 8) {
                Text("Before You Go")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Theme.textPrimary)

                Text("Full access to every template, toolkit, guide, and action plan — for less than a coffee a month.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }

            if let monthly = store.offerings?.current?.monthly {
                Button {
                    Task { await store.purchase(package: monthly) }
                } label: {
                    HStack {
                        if store.isPurchasing {
                            ProgressView().tint(.black)
                        } else {
                            Text("Get Pro — \(monthly.localizedPriceString)/mo")
                                .font(.subheadline.weight(.bold))
                        }
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(store.isPurchasing)
                .padding(.horizontal, 24)
                .onChange(of: store.isPremium) { _, isPremium in
                    if isPremium {
                        UserDefaults.standard.set(false, forKey: "showSecondPaywall")
                        dismiss()
                    }
                }
            }

            Button("No thanks") {
                UserDefaults.standard.set(false, forKey: "showSecondPaywall")
                dismiss()
            }
            .font(.subheadline)
            .foregroundStyle(Theme.textTertiary)

            Spacer()
        }
        .background(Theme.background)
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
}
