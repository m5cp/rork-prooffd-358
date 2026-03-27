import SwiftUI

struct SponsoredCardView: View {
    let program: SponsoredProgram
    let accentColor: Color

    init(program: SponsoredProgram) {
        self.program = program
        self.accentColor = Color(hex: program.accentColorHex)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: program.icon)
                        .font(.title3)
                        .foregroundStyle(accentColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(program.badgeText)
                            .font(.system(size: 9, weight: .bold))
                            .tracking(0.5)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background(accentColor)
                            .clipShape(.capsule)

                        Text(program.sponsor)
                            .font(.caption2)
                            .foregroundStyle(Theme.textTertiary)
                    }

                    Text(program.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(2)
                }

                Spacer(minLength: 4)
            }

            Text(program.tagline)
                .font(.caption.weight(.semibold))
                .foregroundStyle(accentColor)

            Text(program.description)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(3)
                .lineSpacing(2)

            Button {
                SponsoredPlacementDatabase.trackTap(programId: program.id)
                if let url = program.url {
                    UIApplication.shared.open(url)
                }
            } label: {
                HStack(spacing: 6) {
                    Text(program.ctaLabel)
                    Image(systemName: "arrow.right")
                        .font(.caption2)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(accentColor)
                .clipShape(.capsule)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [accentColor.opacity(0.06), Theme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(accentColor.opacity(0.15), lineWidth: 1)
        )
        .cardShadow()
        .onAppear {
            SponsoredPlacementDatabase.trackImpression(programId: program.id)
        }
    }
}

struct SponsoredBannerCard: View {
    let program: SponsoredProgram

    var body: some View {
        let color = Color(hex: program.accentColorHex)
        Button {
            SponsoredPlacementDatabase.trackTap(programId: program.id)
            if let url = program.url {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: program.icon)
                        .font(.body)
                        .foregroundStyle(color)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Text(program.badgeText)
                            .font(.system(size: 8, weight: .bold))
                            .tracking(0.4)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1.5)
                            .background(color)
                            .clipShape(.capsule)
                        Text(program.name)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(1)
                    }
                    Text(program.tagline)
                        .font(.caption2)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 4)

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(12)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.1), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
        .onAppear {
            SponsoredPlacementDatabase.trackImpression(programId: program.id)
        }
    }
}
