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
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                        ForEach(filteredDocuments) { doc in
                            heroCard(doc)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 30)
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

    private func heroCard(_ doc: VaultDocument) -> some View {
        let isLocked = doc.isPro && !store.isPremium
        return Button {
            if isLocked { showPaywall = true } else { selectedDocument = doc }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    LinearGradient(
                        colors: [Theme.accent.opacity(0.28), Theme.accent.opacity(0.08)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .frame(height: 110)
                    .overlay(alignment: .bottomLeading) {
                        Image(systemName: doc.icon)
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(Theme.accent)
                            .padding(14)
                    }
                    HStack(spacing: 6) {
                        if doc.isPro {
                            Text("PRO")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(Theme.accent)
                                .clipShape(.capsule)
                        } else {
                            Text("FREE")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Theme.accent)
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(.ultraThinMaterial)
                                .clipShape(.capsule)
                        }
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(6)
                                .background(.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                    }
                    .padding(10)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(doc.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(doc.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Theme.border.opacity(0.5), lineWidth: 1)
            )
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

                    FormattedDocumentContent(raw: document.content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
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

private struct FormattedDocumentContent: View {
    let raw: String

    private var blocks: [DocBlock] {
        DocBlock.parse(raw)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                switch block {
                case .title(let text):
                    Text(text)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                        .textSelection(.enabled)
                case .heading(let text):
                    Text(text)
                        .font(.headline)
                        .foregroundStyle(Theme.accent)
                        .textSelection(.enabled)
                        .padding(.top, 4)
                case .divider:
                    Rectangle()
                        .fill(Theme.border.opacity(0.6))
                        .frame(height: 1)
                        .padding(.vertical, 2)
                case .bullet(let text):
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.subheadline)
                            .foregroundStyle(Theme.accent)
                        Text(text)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .textSelection(.enabled)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                case .paragraph(let text):
                    Text(text)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .textSelection(.enabled)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(3)
                }
            }
        }
    }
}

private enum DocBlock {
    case title(String)
    case heading(String)
    case divider
    case bullet(String)
    case paragraph(String)

    static func parse(_ raw: String) -> [DocBlock] {
        var blocks: [DocBlock] = []
        var paragraphBuffer: [String] = []

        func flushParagraph() {
            if !paragraphBuffer.isEmpty {
                let joined = paragraphBuffer.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
                if !joined.isEmpty {
                    blocks.append(.paragraph(joined))
                }
                paragraphBuffer.removeAll()
            }
        }

        let lines = raw.components(separatedBy: "\n")
        var firstNonEmptyHandled = false

        for (idx, rawLine) in lines.enumerated() {
            let line = rawLine.trimmingCharacters(in: .whitespaces)

            if line.isEmpty {
                flushParagraph()
                continue
            }

            if line.allSatisfy({ $0 == "-" }) && line.count >= 3 {
                flushParagraph()
                blocks.append(.divider)
                continue
            }

            if !firstNonEmptyHandled {
                firstNonEmptyHandled = true
                if line == line.uppercased() && line.count < 80 && line.rangeOfCharacter(from: .letters) != nil {
                    blocks.append(.title(line))
                    continue
                }
            }

            let isHeading = isHeadingLine(line, index: idx, lines: lines)
            if isHeading {
                flushParagraph()
                blocks.append(.heading(line))
                continue
            }

            if line.hasPrefix("- ") || line.hasPrefix("• ") || line.hasPrefix("* ") {
                flushParagraph()
                let content = String(line.dropFirst(2)).trimmingCharacters(in: .whitespaces)
                blocks.append(.bullet(content))
                continue
            }

            if line.hasPrefix("[ ] ") || line.hasPrefix("[] ") {
                flushParagraph()
                let content = line.replacingOccurrences(of: "[ ] ", with: "").replacingOccurrences(of: "[] ", with: "")
                blocks.append(.bullet(content))
                continue
            }

            paragraphBuffer.append(line)
        }
        flushParagraph()
        return blocks
    }

    private static func isHeadingLine(_ line: String, index: Int, lines: [String]) -> Bool {
        guard line.count < 80 else { return false }
        let letters = line.unicodeScalars.filter { CharacterSet.letters.contains($0) }
        guard !letters.isEmpty else { return false }
        let uppercaseLetters = letters.filter { CharacterSet.uppercaseLetters.contains($0) }
        let isAllCaps = uppercaseLetters.count == letters.count
        if isAllCaps && !line.hasSuffix(":") && line.count < 70 {
            return true
        }
        if line.hasPrefix("ARTICLE ") || line.hasPrefix("SECTION ") || line.hasPrefix("STEP ") {
            return true
        }
        return false
    }
}
