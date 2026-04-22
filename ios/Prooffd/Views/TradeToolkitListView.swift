import SwiftUI

struct TradeToolkitListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selected: TradeToolkit?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(TradeToolkitDatabase.all) { toolkit in
                        Button { selected = toolkit } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Theme.accentBlue.opacity(0.15))
                                        .frame(width: 48, height: 48)
                                    Image(systemName: toolkit.tradeIcon)
                                        .font(.title3)
                                        .foregroundStyle(Theme.accentBlue)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(toolkit.tradeName).font(.subheadline.weight(.semibold)).foregroundStyle(.primary)
                                    HStack(spacing: 6) {
                                        Image(systemName: "shield.checkered").font(.caption2).foregroundStyle(Theme.accent)
                                        Text("AI-proof \(toolkit.aiProofScore)/100")
                                            .font(.caption).foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                    }
                    Color.clear.frame(height: 30)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Trade Toolkits")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }.foregroundStyle(Theme.accent)
                }
            }
            .sheet(item: $selected) { toolkit in
                TradeToolkitDetailView(toolkit: toolkit)
            }
        }
    }
}

struct TradeToolkitDetailView: View {
    let toolkit: TradeToolkit
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    headerCard
                    sectionCard(title: "Must-Have Tools", icon: "wrench.fill") {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(toolkit.mustHaveTools) { tool in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: tool.canRent ? "arrow.triangle.2.circlepath" : "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(tool.canRent ? Theme.warning : Theme.accent)
                                        .padding(.top, 2)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(tool.name).font(.subheadline).foregroundStyle(.primary)
                                        Text(tool.costRange).font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                }
                            }
                            Divider().padding(.vertical, 4)
                            infoRow("Starter kit", toolkit.estimatedStarterKit)
                            Text(toolkit.canRentNote).font(.caption).foregroundStyle(.secondary).padding(.top, 4)
                        }
                    }
                    sectionCard(title: "Union Path", icon: "person.3.fill") {
                        VStack(alignment: .leading, spacing: 8) {
                            infoRow("Union", toolkit.unionName)
                            infoRow("Website", toolkit.unionWebsite)
                            infoRow("Pay difference", toolkit.payDifference)
                            Text("Benefits").font(.caption.weight(.semibold)).foregroundStyle(.secondary).padding(.top, 4)
                            ForEach(toolkit.unionBenefits, id: \.self) { bullet(_: $0) }
                            Text(toolkit.howToJoin).font(.caption).foregroundStyle(.secondary).padding(.top, 4)
                            Divider().padding(.vertical, 4)
                            Text("Non-union note").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                            Text(toolkit.nonUnionNote).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    sectionCard(title: "Licensing", icon: "checkmark.seal.fill") {
                        VStack(alignment: .leading, spacing: 8) {
                            infoRow("License", toolkit.licenseName)
                            infoRow("Authority", toolkit.licenseAuthority)
                            infoRow("Cost", toolkit.licenseCost)
                            infoRow("Study time", toolkit.licenseStudyTime)
                            Text("Key topics").font(.caption.weight(.semibold)).foregroundStyle(.secondary).padding(.top, 4)
                            ForEach(toolkit.licenseKeyTopics, id: \.self) { bullet(_: $0) }
                            Text(toolkit.licenseStateNote).font(.caption).foregroundStyle(.secondary).padding(.top, 4)
                        }
                    }
                    sectionCard(title: "90-Day Plan", icon: "calendar.badge.checkmark") {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(toolkit.ninetyDaySteps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 10) {
                                    Text("\(index + 1)")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.black)
                                        .frame(width: 22, height: 22)
                                        .background(Theme.accent)
                                        .clipShape(Circle())
                                    Text(step).font(.caption).foregroundStyle(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer()
                                }
                            }
                        }
                    }
                    Color.clear.frame(height: 30)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(toolkit.tradeName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }.foregroundStyle(Theme.accent)
                }
            }
        }
    }

    private var headerCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Theme.accentBlue.opacity(0.15))
                    .frame(width: 56, height: 56)
                Image(systemName: toolkit.tradeIcon).font(.title2).foregroundStyle(Theme.accentBlue)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(toolkit.tradeName).font(.title3.weight(.bold)).foregroundStyle(.primary)
                HStack(spacing: 6) {
                    Image(systemName: "shield.checkered").font(.caption).foregroundStyle(Theme.accent)
                    Text("AI-proof score: \(toolkit.aiProofScore)/100").font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundStyle(Theme.accent)
                Text(title).font(.headline).foregroundStyle(.primary)
            }
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
            Text(value).font(.subheadline).foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•").foregroundStyle(Theme.accent)
            Text(text).font(.caption).foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}
