import SwiftUI

/// Stores a user-supplied profile photo on disk.
///
/// The image lives in Application Support rather than `UserDefaults` so the
/// profile stays small; `UserProfile` only persists the filename.
enum ProfilePhotoStore {
    private static let directoryName = "ProfilePhotos"
    private static let maxDimension: CGFloat = 512

    private static var directory: URL? {
        guard let base = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else { return nil }

        let dir = base.appendingPathComponent(directoryName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(
                at: dir,
                withIntermediateDirectories: true
            )
        }
        return dir
    }

    static func url(for filename: String) -> URL? {
        directory?.appendingPathComponent(filename)
    }

    /// Downscales and writes the image, returning its generated filename.
    static func save(_ image: UIImage) -> String? {
        let resized = downscaled(image)
        guard let data = resized.jpegData(compressionQuality: 0.85) else {
            return nil
        }
        let filename = "profile-\(UUID().uuidString).jpg"
        guard let url = url(for: filename) else { return nil }
        do {
            try data.write(to: url, options: .atomic)
            return filename
        } catch {
            print("ProfilePhotoStore: failed to save photo")
            return nil
        }
    }

    static func load(_ filename: String) -> UIImage? {
        guard let url = url(for: filename),
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    static func delete(_ filename: String) {
        guard let url = url(for: filename) else { return }
        try? FileManager.default.removeItem(at: url)
    }

    /// Keeps the longest edge at or below `maxDimension` so large camera-roll
    /// images don't sit in memory at full size.
    private static func downscaled(_ image: UIImage) -> UIImage {
        let longest = max(image.size.width, image.size.height)
        guard longest > maxDimension else { return image }

        let scale = maxDimension / longest
        let newSize = CGSize(
            width: image.size.width * scale,
            height: image.size.height * scale
        )
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
