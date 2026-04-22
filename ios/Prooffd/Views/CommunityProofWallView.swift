import SwiftUI

struct CommunityProofWallView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("From the Community")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.textPrimary)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ProofCardDatabase.all) { card in
                        proofCard(card)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
            }
        }
    }

    private func proofCard(_ card: ProofCard) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(card.name).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.textPrimary)
                    Text(card.cityState).font(.caption).foregroundStyle(Theme.textSecondary)
                }
                Spacer()
                Text(card.pathName)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Theme.accent)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Theme.accent.opacity(0.12))
                    .clipShape(Capsule())
                    .lineLimit(1)
            }

            Text("\"\(card.quote)\"")
                .font(.subheadline)
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(width: 280)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.border, lineWidth: 1))
    }
}
