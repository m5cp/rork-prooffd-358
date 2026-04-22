import CoreSpotlight
import Foundation

enum SpotlightService {
    static let domainIdentifier = "com.prooffd.paths"

    static func indexAllPaths() {
        var items: [CSSearchableItem] = []

        for path in BusinessPathDatabase.allPaths {
            let track = SmartCareerBrain.careerTrack(for: path)
            let attributes = CSSearchableItemAttributeSet(contentType: .content)
            attributes.title = path.name
            attributes.contentDescription = path.overview
            attributes.keywords = [
                path.category.rawValue,
                track.rawValue,
                "AI-proof",
                path.aiSafeLabel
            ]
            attributes.rating = NSNumber(value: path.aiProofRating)

            let item = CSSearchableItem(
                uniqueIdentifier: "path_\(path.id)",
                domainIdentifier: domainIdentifier,
                attributeSet: attributes
            )
            items.append(item)
        }

        for edu in EducationPathDatabase.all {
            let attributes = CSSearchableItemAttributeSet(contentType: .content)
            attributes.title = edu.title
            attributes.contentDescription = edu.overview
            attributes.keywords = [
                edu.category.rawValue,
                "Trade",
                "Certification",
                "AI-proof"
            ]
            attributes.rating = NSNumber(value: edu.aiSafeScore)

            let item = CSSearchableItem(
                uniqueIdentifier: "edu_\(edu.id)",
                domainIdentifier: domainIdentifier,
                attributeSet: attributes
            )
            items.append(item)
        }

        for career in DegreeCareerDatabase.allRecords {
            let attributes = CSSearchableItemAttributeSet(contentType: .content)
            attributes.title = career.title
            attributes.contentDescription = "Advanced Education Career — \(career.category.rawValue) — \(career.aiProofTier.label)"
            attributes.keywords = [
                career.category.rawValue,
                "Advanced Education",
                "Career",
                "AI-proof",
                career.degreeRequired
            ]

            let item = CSSearchableItem(
                uniqueIdentifier: "degree_\(career.id)",
                domainIdentifier: domainIdentifier,
                attributeSet: attributes
            )
            items.append(item)
        }

        CSSearchableIndex.default().indexSearchableItems(items)
    }

    static func removeAllItems() {
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [domainIdentifier])
    }
}
