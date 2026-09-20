import SwiftUI

/// Military service as a first-class path, rather than a category buried two
/// taps inside Trades. Enlisted and officer are presented side by side because
/// the entry requirements differ sharply: one needs no degree, the other
/// requires a bachelor's and closes at age 34.
struct MilitaryExplorePage: View {
    @Environment(AppState.self) private var appState
    @State private var selectedPath: CareerPath?
    @State private var selectedOfficerRecord: DegreeCareerRecord?

    private let accent = Color(hex: "4ADE80")

    private var enlistedPath: EducationPath? {
        EducationPathDatabase.military.first { $0.id == "military_enlisted" }
    }

    private var officerPath: EducationPath? {
        EducationPathDatabase.military.first { $0.id == "military_officer" }
    }

    private var eligibility: MilitaryEligibility? {
        appState.userProfile.militaryEligibility
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                introCard

                if let eligibility {
                    eligibilityBanner(eligibility)
                }

                if let enlistedPath {
                    routeCard(
                        path: enlistedPath,
                        artwork: PathArtwork.militaryService,
                        routeLabel: "NO DEGREE REQUIRED",
                        headline: "Enlisted",
                        blurb: "Paid training, housing, and healthcare from day one. The military certifies you in a job field, and the GI Bill covers college after you serve.",
                        isAvailable: eligibility?.allowsEnlisted ?? true,
                        unavailableNote: "Active-duty enlistment closes at 39, and requires citizenship or permanent residency."
                    )
                }

                if let officerPath {
                    routeCard(
                        path: officerPath,
                        artwork: PathArtwork.militaryOfficer,
                        routeLabel: "BACHELOR'S DEGREE REQUIRED",
                        headline: "Officer",
                        blurb: "Commission and lead teams from day one. Any major works. Higher starting pay, and leadership experience that transfers to senior civilian roles.",
                        isAvailable: eligibility?.allowsOfficer ?? true,
                        unavailableNote: "Commissioning closes at 34 and requires a bachelor's degree plus U.S. citizenship."
                    )
                }

                officerCareerLink

                Color.clear.frame(height: 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .navigationTitle("Military Service")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedPath) { career in
            CareerPathDetailSheet(career: career)
        }
        .sheet(item: $selectedOfficerRecord) { record in
            DegreeCareerDetailSheet(record: record)
        }
    }

    private var introCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            RenderedIcon(name: PathArtwork.militaryService, size: 104, glow: accent)
                .frame(maxWidth: .infinity)

            Text("Two ways in")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.textPrimary)

            Text("Both pay you from your first day of training. The difference is whether you already hold a four-year degree.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
    }

    private func eligibilityBanner(_ eligibility: MilitaryEligibility) -> some View {
        let open = eligibility.allowsEnlisted || eligibility.allowsOfficer
        return HStack(spacing: 12) {
            Image(systemName: eligibility.icon)
                .font(.title3)
                .foregroundStyle(open ? accent : Color(hex: "FBBF24"))
                .frame(width: 40, height: 40)
                .background((open ? accent : Color(hex: "FBBF24")).opacity(0.12))
                .clipShape(.rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(eligibility.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(eligibility.subtitle)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke((open ? accent : Color(hex: "FBBF24")).opacity(0.3), lineWidth: 1)
        )
    }

    private func routeCard(
        path: EducationPath,
        artwork: String,
        routeLabel: String,
        headline: String,
        blurb: String,
        isAvailable: Bool,
        unavailableNote: String
    ) -> some View {
        let score = appState.educationScore(for: path.id)

        return Button {
            selectedPath = path
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    ArtworkImage(name: artwork)
                        .frame(height: 170)
                        .frame(maxWidth: .infinity)
                        .clipped()

                    LinearGradient(
                        colors: [.clear, .black.opacity(0.4), .black.opacity(0.9)],
                        startPoint: .init(x: 0.5, y: 0.25),
                        endPoint: .bottom
                    )
                    .allowsHitTesting(false)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(routeLabel)
                            .font(.system(size: 10, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(accent)
                        Text(headline)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                    }
                    .padding(16)
                }
                .overlay(alignment: .topTrailing) {
                    if isAvailable {
                        VStack(spacing: 0) {
                            Text("\(score)%")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                            Text("match")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(10)
                        .background(.black.opacity(0.4), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding(12)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(blurb)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)

                    if !isAvailable {
                        HStack(alignment: .top, spacing: 7) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption2)
                                .foregroundStyle(Color(hex: "FBBF24"))
                            Text(unavailableNote)
                                .font(.caption)
                                .foregroundStyle(Color(hex: "FBBF24"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    HStack(spacing: 14) {
                        statChip(icon: "dollarsign.circle.fill", text: path.typicalSalaryRange)
                        statChip(icon: "clock.fill", text: path.timeToComplete)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.cardBackground)
            }
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(accent.opacity(isAvailable ? 0.25 : 0.1), lineWidth: 1)
            )
            .opacity(isAvailable ? 1 : 0.72)
        }
        .buttonStyle(ArtworkPressStyle())
    }

    private func statChip(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(accent)
            Text(text)
                .font(.caption2.weight(.medium))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private var officerCareerLink: some View {
        if let record = DegreeCareerDatabase.allRecords.first(where: { $0.id == "military-officer" }) {
            Button {
                selectedOfficerRecord = record
            } label: {
                HStack(spacing: 14) {
                    ArtworkThumbnail(name: PathArtwork.militaryOfficer, size: 54, accent: accent)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Officer as a long-term career")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                        Text("Pay progression, commissioning routes, and life after service")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .lineLimit(2)
                    }
                    Spacer(minLength: 4)
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(14)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
    }
}
