import SwiftUI

enum PDFExportService {
    static func exportBuildPDF(_ build: BuildProject) -> URL? {
        let content = BuildPDFDocument(build: build)
        let renderer = ImageRenderer(content: content)
        renderer.scale = 2.0
        let safeName = build.businessName.replacingOccurrences(of: "/", with: "-")
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(safeName) - Build Plan.pdf")
        renderer.render { size, context in
            var box = CGRect(origin: .zero, size: .init(width: size.width, height: size.height))
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        return url
    }

    static func exportPathPDF(_ result: MatchResult) -> URL? {
        let content = PathPDFDocument(result: result)
        let renderer = ImageRenderer(content: content)
        renderer.scale = 2.0
        let safeName = result.businessPath.name.replacingOccurrences(of: "/", with: "-")
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(safeName) - Business Plan.pdf")
        renderer.render { size, context in
            var box = CGRect(origin: .zero, size: .init(width: size.width, height: size.height))
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        return url
    }

    static func presentShareSheet(items: [Any]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else { return }
        var topController = root
        while let presented = topController.presentedViewController { topController = presented }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = topController.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: topController.view.bounds.midX, y: topController.view.bounds.midY, width: 0, height: 0)
        activityVC.popoverPresentationController?.permittedArrowDirections = []
        topController.present(activityVC, animated: true)
    }
}

struct BuildPDFDocument: View {
    let build: BuildProject

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(build.businessName)
                        .font(.title.bold())
                    Text(build.pathName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(build.progressPercentage)% Complete")
                        .font(.title3.bold())
                        .foregroundStyle(.green)
                    Text("AI Safe Score: \(build.aiSafeScore)/100")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            pdfField("Overview", build.overview)
            pdfField("Startup Cost", build.startupCost)
            pdfField("Time to First Dollar", build.timeToFirstDollar)

            Divider()

            Text("Progress & Steps")
                .font(.headline)
            ForEach(Array(build.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top) {
                    Text("\(step.isCompleted ? "✓" : "○") \(index + 1). \(step.title)")
                        .font(.body)
                    Spacer()
                    if let date = step.completedDate {
                        Text(date.formatted(.dateTime.month(.abbreviated).day()))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                if let notes = step.notes, !notes.isEmpty {
                    Text("  Notes: \(notes)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !build.pricingNotes.isEmpty {
                Divider()
                pdfField("Pricing", build.pricingNotes)
            }
            if !build.serviceNotes.isEmpty {
                pdfField("Services", build.serviceNotes)
            }
            if !build.strategyNotes.isEmpty {
                pdfField("Strategy", build.strategyNotes)
            }

            if !build.customerSources.isEmpty {
                Divider()
                Text("Customer Sources").font(.headline)
                ForEach(build.customerSources, id: \.self) { source in
                    Text("• \(source)").font(.body).foregroundStyle(.secondary)
                }
            }

            if !build.pricingTips.isEmpty {
                Text("Pricing Tips").font(.headline)
                ForEach(build.pricingTips, id: \.self) { tip in
                    Text("• \(tip)").font(.body).foregroundStyle(.secondary)
                }
            }

            Divider()
            Text("Generated by Prooffd")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("Started \(build.startDate.formatted(.dateTime.month().day().year()))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(40)
        .frame(width: 612)
        .background(.white)
    }

    private func pdfField(_ title: String, _ content: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline)
            Text(content).font(.body).foregroundStyle(.secondary)
        }
    }
}

struct PathPDFDocument: View {
    let result: MatchResult

    private var path: BusinessPath { result.businessPath }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(path.name)
                        .font(.title.bold())
                    Text(path.category.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(result.scorePercentage)% Match")
                        .font(.title2.bold())
                        .foregroundStyle(.green)
                    Text("AI Safe: \(path.aiProofRating)/100 (\(path.aiSafeLabel))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            pdfField("Overview", path.overview)
            pdfField("Startup Cost", path.startupCostRange)
            pdfField("Time to First Dollar", path.timeToFirstDollar)
            pdfField("Typical Market Rates", path.typicalMarketRates)
            pdfField("Customer Type", path.customerType)
            pdfField("Education Required", SmartCareerBrain.educationChipText(for: path))

            Divider()

            Text("Action Plan")
                .font(.headline)
            let smartSteps = SmartCareerBrain.smartActionPlan(for: path)
            ForEach(Array(smartSteps.enumerated()), id: \.offset) { index, step in
                Text("\(index + 1). \(step)")
                    .font(.body)
            }

            Divider()

            pdfField("Starter Pricing", path.starterPricing)
            pdfField("Draft Email", path.draftEmail)
            pdfField("Draft Text Message", path.draftTextMessage)
            pdfField("Sales Intro Script", path.salesIntroScript)
            pdfField("Social Media Post", path.socialMediaPost)
            pdfField("Offer & Pricing", path.offerPricingSheet)

            let planSections = BusinessPlanGenerator.generate(for: path)
            Divider()
            Text("One-Page Business Plan")
                .font(.title2.bold())
            ForEach(Array(planSections.enumerated()), id: \.offset) { _, section in
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(section.number). \(section.title)")
                        .font(.headline)
                    ForEach(Array(section.content.enumerated()), id: \.offset) { _, line in
                        if !line.text.isEmpty {
                            Text(pdfLineText(line))
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Divider()
            Text("Generated by Prooffd")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(40)
        .frame(width: 612)
        .background(.white)
    }

    private func pdfField(_ title: String, _ content: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline)
            Text(content).font(.body).foregroundStyle(.secondary)
        }
    }

    private func pdfLineText(_ line: BusinessPlanLine) -> String {
        switch line.style {
        case .bullet: return "• \(line.text)"
        case .financial(let label, let value): return "\(label): \(value)"
        default: return line.text
        }
    }
}
