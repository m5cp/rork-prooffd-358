import Foundation

/// A single plain-language explanation of why a path scored well (or poorly)
/// for this user, derived from the same signals `MatchingEngine` scores on.
nonisolated struct MatchReason: Identifiable, Sendable {
    let id = UUID()
    let icon: String
    let text: String
    /// `false` marks an honest caveat rather than a selling point.
    let isPositive: Bool
}

/// Turns a scored match back into the handful of answers that drove it, so the
/// user sees "because you said AI worries you" instead of an unexplained number.
///
/// This reads the same profile fields `MatchingEngine` scores, but it is
/// deliberately separate: the engine's signatures stay untouched, and this can
/// be called from any view that already has a profile and a path.
nonisolated enum MatchReasons {

    /// Reasons worth surfacing, strongest first, capped at `limit`.
    static func reasons(for path: BusinessPath,
                        profile: UserProfile,
                        limit: Int = 5) -> [MatchReason] {
        var positives: [MatchReason] = []
        var caveats: [MatchReason] = []

        // AI resistance — the headline signal of the whole app.
        if let concern = profile.aiConcern {
            switch concern {
            case .veryWorried, .somewhat:
                if path.aiProofRating >= 80 {
                    positives.append(MatchReason(
                        icon: "shield.checkered",
                        text: "You said AI worries you — this is one of the hardest jobs to automate (\(path.aiProofRating)/100).",
                        isPositive: true))
                } else if path.aiProofRating < 50 {
                    caveats.append(MatchReason(
                        icon: "exclamationmark.triangle.fill",
                        text: "Heads up: AI already touches this field (\(path.aiProofRating)/100 resistance).",
                        isPositive: false))
                }
            case .wantToUseIt:
                if path.isDigital {
                    positives.append(MatchReason(
                        icon: "cpu",
                        text: "You want to use AI as a tool — this is digital work where AI makes you faster.",
                        isPositive: true))
                }
            case .notReally:
                break
            }
        }

        // Growth ambition vs. how the path actually scales.
        if let growth = profile.growthAmbition {
            switch growth {
            case .justMe where path.soloFriendly:
                positives.append(MatchReason(
                    icon: "person.fill",
                    text: "You want to keep it to just you — this works as a one-person operation.",
                    isPositive: true))
            case .realCompany where path.isScalable:
                positives.append(MatchReason(
                    icon: "building.2.fill",
                    text: "You want to build a real company — this one scales past you.",
                    isPositive: true))
            case .realCompany where !path.isScalable:
                caveats.append(MatchReason(
                    icon: "exclamationmark.triangle.fill",
                    text: "You want something scalable, but this tends to stay a one-person job.",
                    isPositive: false))
            case .smallCrew where path.isScalable:
                positives.append(MatchReason(
                    icon: "person.2.fill",
                    text: "Room to add a small crew when you're ready.",
                    isPositive: true))
            default:
                break
            }
        }

        // Licensing.
        if let appetite = profile.credentialAppetite {
            if appetite == .happyTo, path.requiresLicense {
                positives.append(MatchReason(
                    icon: "checkmark.seal.fill",
                    text: "You're willing to get licensed — that keeps competition out and pay up.",
                    isPositive: true))
            } else if appetite == .ratherNot, path.requiresLicense {
                caveats.append(MatchReason(
                    icon: "exclamationmark.triangle.fill",
                    text: "You'd rather skip paperwork, but this one requires a license.",
                    isPositive: false))
            } else if appetite == .ratherNot, !path.requiresLicense {
                positives.append(MatchReason(
                    icon: "bolt.fill",
                    text: "No license required — you can start without the paperwork.",
                    isPositive: true))
            }
        }

        // Schedule shape.
        if let schedule = profile.scheduleShape {
            if schedule == .eveningsWeekends {
                if path.isDigital || path.soloFriendly {
                    positives.append(MatchReason(
                        icon: "moon.stars.fill",
                        text: "You only have evenings and weekends — this fits around another job.",
                        isPositive: true))
                } else {
                    caveats.append(MatchReason(
                        icon: "clock.fill",
                        text: "This usually needs daytime hours, and you said evenings and weekends only.",
                        isPositive: false))
                }
            }
        }

        // Risk appetite.
        if let risk = profile.riskTolerance {
            if risk == .upside, path.isScalable, path.incomeLevel == .high {
                positives.append(MatchReason(
                    icon: "chart.line.uptrend.xyaxis",
                    text: "You wanted upside — this has a high ceiling if it works.",
                    isPositive: true))
            } else if risk == .steady, path.requiresLicense, path.demandLevel == .high {
                positives.append(MatchReason(
                    icon: "lock.shield.fill",
                    text: "You wanted steady — licensed work with strong demand is about as stable as it gets.",
                    isPositive: true))
            }
        }

        // Fast cash.
        if profile.needsFastCash == true, path.fastCashPotential {
            positives.append(MatchReason(
                icon: "bolt.fill",
                text: "You need money coming in soon — this one can pay early.",
                isPositive: true))
        }

        // Car requirement is a hard practical blocker.
        if profile.hasCar == false, path.requiresCar {
            caveats.append(MatchReason(
                icon: "car.fill",
                text: "This normally needs a vehicle, and you said you don't have one yet.",
                isPositive: false))
        }

        // Things they explicitly asked to avoid.
        if profile.thingsToAvoid.contains(.physicalHazards), path.requiresPhysicalWork {
            caveats.append(MatchReason(
                icon: "exclamationmark.triangle.fill",
                text: "You asked to avoid physical risk — this involves hands-on work.",
                isPositive: false))
        }
        if profile.thingsToAvoid.contains(.selling), path.requiresSelling {
            caveats.append(MatchReason(
                icon: "exclamationmark.triangle.fill",
                text: "You asked to avoid selling, and this depends on finding your own clients.",
                isPositive: false))
        }

        // Show the strongest positives, then at most two honest caveats.
        return Array(positives.prefix(max(0, limit - min(2, caveats.count)))
                     + caveats.prefix(2))
    }
}
