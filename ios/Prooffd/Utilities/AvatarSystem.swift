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

    /// Bundled glossy 3D render for this avatar.
    var artwork: String {
        switch self {
        case .hare: return "rabbit_head_3d"
        case .tortoise: return "tortoise_3d_icon"
        case .bird: return "bird_3d_icon"
        case .fish: return "fish_3d"
        case .cat: return "cat_head_3d"
        case .dog: return "dog_head_3d"
        case .ladybug: return "ladybug_icon"
        case .ant: return "ant_3d_icon"
        case .leaf: return "leaf_3d_glossy"
        case .star: return "star_five_pointed_3d"
        case .bolt: return "lightning_bolt"
        case .flame: return "flame_icon"
        case .drop: return "water_droplet_3d"
        case .snowflake: return "snowflake_3d"
        case .moon: return "crescent_moon_3d"
        case .sun: return "sun_rays_3d"
        case .cloud: return "cloud_fluffy_3d"
        case .mountain: return "mountain_peaks_snow"
        case .pawprint: return "paw_print"
        case .heart: return "heart_3d_glossy"
        }
    }

    static func random() -> AvatarOption {
        AvatarOption.allCases.randomElement() ?? .star
    }
}

struct AvatarView: View {
    let avatar: AvatarOption
    var size: CGFloat = 50
    /// When set, the user's own photo replaces the illustrated avatar.
    var photoFilename: String? = nil

    @State private var photo: UIImage? = nil

    var body: some View {
        Group {
            if let photo {
                Color(.secondarySystemBackground)
                    .frame(width: size, height: size)
                    .overlay {
                        Image(uiImage: photo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .allowsHitTesting(false)
                    }
                    .clipShape(.circle)
                    .overlay {
                        Circle().strokeBorder(
                            LinearGradient(
                                colors: [Theme.accent.opacity(0.9), Theme.accentBlue.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: max(1.5, size * 0.035)
                        )
                    }
                    .shadow(color: Theme.accent.opacity(0.3), radius: size * 0.12)
            } else {
                RenderedIcon(name: avatar.artwork, size: size, glow: avatar.color, zoom: 1.0)
            }
        }
        .task(id: photoFilename) {
            guard let photoFilename else {
                photo = nil
                return
            }
            photo = ProfilePhotoStore.load(photoFilename)
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
