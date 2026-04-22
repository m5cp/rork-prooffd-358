import SwiftUI

struct LogWinView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedWinType: WinType? = nil
    @State private var note: String = ""
    @State private var filterCategory: CommittedPathType? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        filterPill("All", selected: filterCategory == nil) {
                            filterCategory = nil
                        }
                        filterPill("Business",
                                   selected: filterCategory == .business) {
                            filterCategory = .business
                        }
                        filterPill("Trade",
                                   selected: filterCategory == .trade) {
                            filterCategory = .trade
                        }
                        filterPill("Degree",
                                   selected: filterCategory == .degree) {
                            filterCategory = .degree
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }

                Divider().background(Theme.border)

                ScrollView {
                    VStack(spacing: 8) {
                        let filtered = WinType.allCases.filter {
                            filterCategory == nil || $0.category == filterCategory
                                || $0.category == nil
                        }
                        ForEach(filtered) { win in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedWinType = selectedWinType == win ? nil : win
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: win.icon)
                                        .foregroundStyle(
                                            selectedWinType == win ?
                                            .black : Theme.accent
                                        )
                                        .frame(width: 20)
                                    Text(win.rawValue)
                                        .font(.subheadline)
                                        .foregroundStyle(
                                            selectedWinType == win ?
                                            .black : Theme.textPrimary
                                        )
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Image(systemName: selectedWinType == win ?
                                          "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(
                                            selectedWinType == win ?
                                            .black : Theme.textTertiary
                                        )
                                }
                                .padding(12)
                                .background(
                                    selectedWinType == win ?
                                    Theme.accent : Theme.cardBackground
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedWinType == win ?
                                            Theme.accent : Theme.border,
                                            lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }

                        if selectedWinType != nil {
                            TextField("Add a note (optional)",
                                      text: $note, axis: .vertical)
                                .font(.subheadline)
                                .foregroundStyle(Theme.textPrimary)
                                .padding(12)
                                .background(Theme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.border, lineWidth: 1))
                        }

                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }

                if let win = selectedWinType {
                    Button {
                        appState.logRealWorldWin(type: win, note: note)
                        dismiss()
                    } label: {
                        Text("Log This Win 🎉")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .background(Theme.background)
            .navigationTitle("Log a Win")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Theme.accent)
                }
            }
            .onAppear {
                if filterCategory == nil {
                    filterCategory = appState.myPath?.type
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private func filterPill(_ label: String, selected: Bool,
                            action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(selected ? Theme.accent : Theme.cardBackground)
                .foregroundStyle(selected ? Color.black : Theme.textSecondary)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Theme.border,
                                          lineWidth: selected ? 0 : 1))
        }
    }
}
