import SwiftUI

struct CareerComparisonView: View {
    let itemA: ComparisonItem
    let itemB: ComparisonItem
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var isWide: Bool { sizeClass == .regular }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack(alignment: .top, spacing: 12) {
                        header(for: itemA)
                        header(for: itemB)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    VStack(spacing: 14) {
                        scoreRow
                        textRow(label: "Salary Range", a: itemA.salaryRange, b: itemB.salaryRange, starSide: nil)
                        textRow(label: "Time to Income", a: itemA.timeToIncome, b: itemB.timeToIncome, starSide: timeStar)
                        textRow(label: "Upfront Cost", a: itemA.upfrontCost, b: itemB.upfrontCost, starSide: nil)
                        pillRow
                    }
                    .padding(.horizontal, 16)

                    Text("Both are AI-resistant careers. The best choice depends on your budget, timeline, and personal fit.")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding()

                    Color.clear.frame(height: 30)
                }
            }
            .background(Theme.background)
            .navigationTitle("Compare")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(Theme.accent)
                }
            }
        }
    }

    private func header(for item: ComparisonItem) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle().fill(Theme.accent.opacity(0.12)).frame(width: 60, height: 60)
                Image(systemName: item.icon).font(.title2).foregroundStyle(Theme.accent)
            }
            Text(item.title)
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Text(item.typeLabel)
                .font(.caption2.weight(.bold))
                .foregroundStyle(Theme.accent)
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(Theme.accent.opacity(0.12))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.border, lineWidth: 1))
    }

    private var scoreRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("AI-Proof Score")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.textSecondary)
            HStack(spacing: 12) {
                scoreCard(score: itemA.aiProofScore, starred: scoreStar == .a)
                scoreCard(score: itemB.aiProofScore, starred: scoreStar == .b)
            }
        }
    }

    private func scoreCard(score: Int, starred: Bool) -> some View {
        let color: Color = score > 80 ? Color(hex: "34D399") : (score >= 60 ? Color(hex: "FBBF24") : .orange)
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(score)")
                    .font(.title.weight(.bold))
                    .foregroundStyle(color)
                Text("/100").font(.caption).foregroundStyle(Theme.textTertiary)
                Spacer()
                if starred {
                    Image(systemName: "star.fill").font(.caption).foregroundStyle(.yellow)
                }
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.border).frame(height: 6)
                    Capsule().fill(color).frame(width: geo.size.width * CGFloat(score) / 100, height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1))
    }

    private func textRow(label: String, a: String, b: String, starSide: Side?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.caption.weight(.semibold)).foregroundStyle(Theme.textSecondary)
            HStack(spacing: 12) {
                valueCard(text: a, starred: starSide == .a)
                valueCard(text: b, starred: starSide == .b)
            }
        }
    }

    private func valueCard(text: String, starred: Bool) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text(text.isEmpty ? "—" : text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            if starred {
                Image(systemName: "star.fill").font(.caption2).foregroundStyle(.yellow)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 54, alignment: .topLeading)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1))
    }

    private var pillRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Path Type").font(.caption.weight(.semibold)).foregroundStyle(Theme.textSecondary)
            HStack(spacing: 12) {
                pillCard(itemA.typeLabel)
                pillCard(itemB.typeLabel)
            }
        }
    }

    private func pillCard(_ label: String) -> some View {
        HStack {
            Spacer()
            Text(label)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.accent)
                .padding(.horizontal, 14).padding(.vertical, 6)
                .background(Theme.accent.opacity(0.12))
                .clipShape(Capsule())
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1))
    }

    private enum Side { case a, b }

    private var scoreStar: Side? {
        if itemA.aiProofScore > itemB.aiProofScore { return .a }
        if itemB.aiProofScore > itemA.aiProofScore { return .b }
        return nil
    }

    private var timeStar: Side? {
        let a = timeScore(itemA.timeToIncome)
        let b = timeScore(itemB.timeToIncome)
        if a < b { return .a }
        if b < a { return .b }
        return nil
    }

    private func timeScore(_ s: String) -> Double {
        let lower = s.lowercased()
        let numbers = lower.split(whereSeparator: { !$0.isNumber && $0 != "." }).compactMap { Double($0) }
        let first = numbers.first ?? 99
        if lower.contains("year") { return first * 12 }
        if lower.contains("month") { return first }
        if lower.contains("week") { return first / 4.0 }
        if lower.contains("day") { return first / 30.0 }
        return first
    }
}
