import SwiftUI

struct DocumentVaultView: View {
    @Environment(StoreViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: DocumentCategory = .legal
    @State private var selectedDocument: VaultDocument?
    @State private var showPaywall = false

    private var filteredDocuments: [VaultDocument] {
        DocumentVaultDatabase.all.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryPicker
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredDocuments) { doc in
                            documentRow(doc)
                        }
                        Color.clear.frame(height: 30)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Document Vault")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }.foregroundStyle(Theme.accent)
                }
            }
            .sheet(item: $selectedDocument) { doc in
                DocumentDetailView(document: doc)
            }
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(DocumentCategory.allCases, id: \.self) { cat in
                    Button {
                        withAnimation(.spring(response: 0.3)) { selectedCategory = cat }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cat.icon).font(.caption)
                            Text(cat.rawValue).font(.subheadline.weight(.semibold))
                        }
                        .foregroundStyle(selectedCategory == cat ? .black : .primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedCategory == cat ? Theme.accent : Color(.secondarySystemGroupedBackground))
                        .clipShape(.capsule)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 10)
    }

    private func documentRow(_ doc: VaultDocument) -> some View {
        let isLocked = doc.isPro && !store.isPremium
        return Button {
            if isLocked { showPaywall = true } else { selectedDocument = doc }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Theme.accent.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: doc.icon)
                        .font(.body)
                        .foregroundStyle(Theme.accent)
                }
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(doc.title).font(.subheadline.weight(.semibold)).foregroundStyle(.primary)
                        if doc.isPro {
                            Text("PRO")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Theme.accent)
                                .clipShape(.capsule)
                        } else {
                            Text("FREE")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Theme.accent)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Theme.accent.opacity(0.15))
                                .clipShape(.capsule)
                        }
                    }
                    Text(doc.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: isLocked ? "lock.fill" : "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

struct DocumentDetailView: View {
    let document: VaultDocument
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(document.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 4)

                    Text(document.content)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundStyle(.primary)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))

                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(document.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }.foregroundStyle(Theme.accent)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShareLink(item: document.content, subject: Text(document.title)) {
                        Image(systemName: "square.and.arrow.up").foregroundStyle(Theme.accent)
                    }
                }
            }
        }
    }
}
