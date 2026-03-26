import SwiftUI

nonisolated enum AvatarOption: String, CaseIterable, Identifiable, Codable, Sendable {
    case hare, tortoise, bird, fish
    case cat, dog, ladybug, ant
    case leaf, star, bolt, flame
    case drop, snowflake, moon, sun
    case cloud, mountain, pawprint, heart

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .hare: return "hare.fill"
        case .tortoise: return "tortoise.fill"
        case .bird: return "bird.fill"
        case .fish: return "fish.fill"
        case .cat: return "cat.fill"
        case .dog: return "dog.fill"
        case .ladybug: return "ladybug.fill"
        case .ant: return "ant.fill"
        case .leaf: return "leaf.fill"
        case .star: return "star.fill"
        case .bolt: return "bolt.fill"
        case .flame: return "flame.fill"
        case .drop: return "drop.fill"
        case .snowflake: return "snowflake"
        case .moon: return "moon.fill"
        case .sun: return "sun.max.fill"
        case .cloud: return "cloud.fill"
        case .mountain: return "mountain.2.fill"
        case .pawprint: return "pawprint.fill"
        case .heart: return "heart.fill"
        }
    }

    var color: Color {
        switch self {
        case .hare: return Color(hex: "FB923C")
        case .tortoise: return Color(hex: "34D399")
        case .bird: return Color(hex: "60A5FA")
        case .fish: return Color(hex: "2DD4BF")
        case .cat: return Color(hex: "818CF8")
        case .dog: return Color(hex: "FBBF24")
        case .ladybug: return Color(hex: "EF4444")
        case .ant: return Color(hex: "B45309")
        case .leaf: return Color(hex: "22C55E")
        case .star: return Color(hex: "FBBF24")
        case .bolt: return Color(hex: "3B82F6")
        case .flame: return Color(hex: "FB923C")
        case .drop: return Color(hex: "06B6D4")
        case .snowflake: return Color(hex: "93C5FD")
        case .moon: return Color(hex: "6366F1")
        case .sun: return Color(hex: "F59E0B")
        case .cloud: return Color(hex: "9CA3AF")
        case .mountain: return Color(hex: "64748B")
        case .pawprint: return Color(hex: "F472B6")
        case .heart: return Color(hex: "EF4444")
        }
    }

    static func random() -> AvatarOption {
        AvatarOption.allCases.randomElement() ?? .star
    }
}

struct AvatarView: View {
    let avatar: AvatarOption
    var size: CGFloat = 50

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [avatar.color, avatar.color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            Image(systemName: avatar.symbol)
                .font(.system(size: size * 0.4))
                .foregroundStyle(.white)
        }
    }
}

struct AvatarPickerView: View {
    @Binding var selectedAvatar: AvatarOption
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.adaptive(minimum: 60), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(AvatarOption.allCases) { option in
                        Button {
                            selectedAvatar = option
                        } label: {
                            VStack(spacing: 6) {
                                AvatarView(avatar: option, size: 52)
                                    .overlay {
                                        if selectedAvatar == option {
                                            Circle()
                                                .stroke(option.color, lineWidth: 3)
                                                .frame(width: 58, height: 58)
                                        }
                                    }
                                Text(option.rawValue.capitalized)
                                    .font(.caption2)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Theme.background)
            .navigationTitle("Choose Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }
}
