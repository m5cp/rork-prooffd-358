import Foundation

nonisolated struct UserLevel: Sendable {
    let rank: Int
    let title: String
    let icon: String
    let minPoints: Int
    let maxPoints: Int

    var color: String {
        switch rank {
        case 1: return "94A3B8"
        case 2: return "60A5FA"
        case 3: return "34D399"
        case 4: return "FBBF24"
        case 5: return "818CF8"
        default: return "94A3B8"
        }
    }

    static let all: [UserLevel] = [
        UserLevel(rank: 1, title: "Explorer", icon: "binoculars.fill", minPoints: 0, maxPoints: 49),
        UserLevel(rank: 2, title: "Planner", icon: "map.fill", minPoints: 50, maxPoints: 149),
        UserLevel(rank: 3, title: "Builder", icon: "hammer.fill", minPoints: 150, maxPoints: 349),
        UserLevel(rank: 4, title: "Launcher", icon: "rocket.fill", minPoints: 350, maxPoints: 699),
        UserLevel(rank: 5, title: "Operator", icon: "star.circle.fill", minPoints: 700, maxPoints: Int.max),
    ]

    static func forPoints(_ points: Int) -> UserLevel {
        all.last(where: { points >= $0.minPoints }) ?? all[0]
    }

    static func nextLevel(after current: UserLevel) -> UserLevel? {
        guard current.rank < all.count else { return nil }
        return all.first(where: { $0.rank == current.rank + 1 })
    }

    func progressToNext(points: Int) -> Double {
        guard let next = UserLevel.nextLevel(after: self) else { return 1.0 }
        let range = Double(next.minPoints - minPoints)
        let progress = Double(points - minPoints)
        return min(max(progress / range, 0), 1.0)
    }
}
