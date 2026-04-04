import Foundation

nonisolated enum PlanItemType: String, Codable, Sendable {
    case business
    case trade
    case degree
}

nonisolated struct PlanItem: Codable, Identifiable, Sendable {
    let id: String
    let itemId: String
    let type: PlanItemType
    let title: String
    let icon: String
    let subtitle: String
    let addedDate: Date

    nonisolated init(id: String = UUID().uuidString, itemId: String, type: PlanItemType, title: String, icon: String, subtitle: String, addedDate: Date = Date()) {
        self.id = id
        self.itemId = itemId
        self.type = type
        self.title = title
        self.icon = icon
        self.subtitle = subtitle
        self.addedDate = addedDate
    }

    nonisolated init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        itemId = try c.decode(String.self, forKey: .itemId)
        type = try c.decode(PlanItemType.self, forKey: .type)
        title = try c.decode(String.self, forKey: .title)
        icon = try c.decode(String.self, forKey: .icon)
        subtitle = try c.decode(String.self, forKey: .subtitle)
        addedDate = try c.decode(Date.self, forKey: .addedDate)
    }

    static func fromBusiness(_ path: BusinessPath) -> PlanItem {
        PlanItem(itemId: path.id, type: .business, title: path.name, icon: path.icon, subtitle: path.startupCostRange)
    }

    static func fromEducation(_ path: EducationPath) -> PlanItem {
        PlanItem(itemId: path.id, type: .trade, title: path.title, icon: path.icon, subtitle: path.typicalSalaryRange)
    }

    static func fromDegree(_ record: DegreeCareerRecord) -> PlanItem {
        PlanItem(itemId: record.id, type: .degree, title: record.title, icon: record.icon, subtitle: record.salaryExperienced)
    }
}
