import Foundation

enum TestPrepDatabase {
    static let all: [TestPrepRoadmap] = [sat, act, gre, gmat]

    static func roadmap(for id: String) -> TestPrepRoadmap? {
        all.first { $0.id == id }
    }

    static let sat = TestPrepRoadmap(
        id: "sat",
        examName: "SAT",
        icon: "pencil.and.ruler.fill",
        whoNeedsIt: "Anyone applying to a 4-year undergraduate college or university. Also useful for adults returning to school.",
        registrationURL: "collegeboard.org",
        typicalCost: "$60 (fee waivers available for qualifying students)",
        scoreRange: "400–1600 (Evidence-Based Reading + Math)",
        targetScores: "Community college: usually no SAT required. State university: 1000–1200 competitive. Selective schools: 1300–1400+. Elite schools: 1450+.",
        format: "2 hours 14 minutes, digital, adaptive format",
        studyPhases: [
            StudyPhase(id: "sat1", weekRange: "Weeks 1–2", title: "Diagnostic Test",
                description: "Take a full official practice test (free at collegeboard.org — 8 official tests available). Score it, identify your weakest sections, and set a target score. Spend at least 1 hour reviewing every wrong answer.",
                hoursPerWeek: 5),
            StudyPhase(id: "sat2", weekRange: "Weeks 3–5", title: "Math Foundations",
                description: "Work through algebra, geometry, data analysis, and problem-solving. Khan Academy SAT Prep is the official College Board partner and is completely free — it creates a personalized plan based on your diagnostic results. Study 45–60 minutes per day, 5 days per week.",
                hoursPerWeek: 5),
            StudyPhase(id: "sat3", weekRange: "Weeks 6–8", title: "Reading & Writing",
                description: "Practice reading comprehension with timed passages. Focus on vocabulary in context, evidence questions, and data interpretation. Cover grammar rules for the Writing and Language section. Practice 45 minutes per day.",
                hoursPerWeek: 5),
            StudyPhase(id: "sat4", weekRange: "Weeks 9–11", title: "Practice Tests",
                description: "Take one full practice test per week under real timed conditions. Review every wrong answer — this is the most important step. Do not just find the right answer — understand WHY your answer was wrong. 3 hours test + 2 hours review per week.",
                hoursPerWeek: 8),
            StudyPhase(id: "sat5", weekRange: "Week 12", title: "Final Review",
                description: "No new material this week. Review your most common mistake patterns. Get good sleep. Plan your test-day logistics including what to bring and how to get there.",
                hoursPerWeek: 3)
        ],
        freeResources: [
            "Khan Academy SAT Prep (khanacademy.org/sat) — official College Board partner, completely free",
            "College Board practice tests (8 full digital tests available free at collegeboard.org)",
            "SAT Question of the Day app (College Board)"
        ],
        paidResources: [
            "Princeton Review: $299–$1,299 depending on format",
            "Kaplan SAT Prep: $299–$499 online",
            "PrepScholar: $397 online self-paced"
        ],
        retakePolicy: "Can retake any test date. Most students improve 50–150 points on a second attempt with structured preparation."
    )

    static let act = TestPrepRoadmap(
        id: "act",
        examName: "ACT",
        icon: "square.and.pencil",
        whoNeedsIt: "Alternative to the SAT for college admissions. Accepted at all 4-year colleges. Some students score higher on ACT vs SAT — take a practice test for both to find out which suits you better.",
        registrationURL: "act.org",
        typicalCost: "$68 without writing section; $93 with writing section",
        scoreRange: "1–36 composite (average of English, Math, Reading, Science)",
        targetScores: "State university: 20–24 competitive. Selective schools: 28–31. Elite schools: 33+.",
        format: "2 hours 55 minutes plus optional 40-minute writing section. 4 sections: English, Math, Reading, Science.",
        studyPhases: [
            StudyPhase(id: "act1", weekRange: "Week 1", title: "Diagnostic Test",
                description: "Take a free full ACT practice test (available at act.org). Score all four sections. Identify your two weakest sections to prioritize in your studying.",
                hoursPerWeek: 5),
            StudyPhase(id: "act2", weekRange: "Weeks 2–3", title: "English & Grammar",
                description: "ACT English is 75 questions in 45 minutes — a fast pace. Focus on grammar rules: punctuation, sentence structure, transitions, and concision. Use free ACT prep on Khan Academy.",
                hoursPerWeek: 5),
            StudyPhase(id: "act3", weekRange: "Weeks 4–5", title: "Math",
                description: "ACT Math is 60 questions in 60 minutes. Covers pre-algebra through basic trigonometry. Make a formula sheet and memorize it. Practice speed — you have 1 minute per question.",
                hoursPerWeek: 5),
            StudyPhase(id: "act4", weekRange: "Weeks 6–7", title: "Reading & Science",
                description: "Reading: 4 passages, 10 questions each. Learn to skim and find answers quickly. Science: Almost entirely graph and chart data interpretation — prior science knowledge not required. Practice reading figures and tables.",
                hoursPerWeek: 5),
            StudyPhase(id: "act5", weekRange: "Weeks 8–9", title: "Practice Tests",
                description: "One full timed practice test per week. Analyze mistakes by section. Focus extra time on your two weakest areas from your initial diagnostic.",
                hoursPerWeek: 8),
            StudyPhase(id: "act6", weekRange: "Week 10", title: "Final Review",
                description: "Light review only. Focus on timing strategies for each section. Rest before test day.",
                hoursPerWeek: 3)
        ],
        freeResources: [
            "Khan Academy ACT Prep (khanacademy.org)",
            "Official ACT practice tests (act.org — 5 free tests)",
            "CrackACT.com — free additional practice"
        ],
        paidResources: [
            "Kaplan ACT Prep: $299–$499",
            "Princeton Review ACT: $299–$1,299",
            "Magoosh ACT: $99 — excellent value"
        ],
        retakePolicy: "Can retake any test date. Most students improve with structured prep between attempts."
    )

    static let gre = TestPrepRoadmap(
        id: "gre",
        examName: "GRE",
        icon: "graduationcap.fill",
        whoNeedsIt: "Anyone applying to most master's or doctoral programs — social sciences, humanities, sciences, engineering, and many business programs. Note: MBA programs may prefer GMAT. Law schools use LSAT. Medical schools use MCAT.",
        registrationURL: "ets.org/gre",
        typicalCost: "$220 (fee reductions available)",
        scoreRange: "Verbal Reasoning: 130–170. Quantitative Reasoning: 130–170. Analytical Writing: 0–6. Average scores: approximately 150V, 153Q, 3.5AW.",
        targetScores: "Target scores vary widely by program. Research your specific target school's median GRE scores for admitted students — this information is usually on the program's admissions page.",
        format: "Approximately 2 hours. Three sections: Verbal Reasoning, Quantitative Reasoning, Analytical Writing.",
        studyPhases: [
            StudyPhase(id: "gre1", weekRange: "Weeks 1–2", title: "Diagnostic + Vocabulary",
                description: "Take an official PowerPrep test (2 free at ets.org). GRE Verbal is heavily vocabulary-dependent. Begin learning high-frequency GRE words daily — 10–15 words per day using Magoosh flashcards (free app).",
                hoursPerWeek: 5),
            StudyPhase(id: "gre2", weekRange: "Weeks 3–5", title: "Verbal Foundations",
                description: "Study Text Completion, Sentence Equivalence, and Reading Comprehension. Learn the question types. Practice process of elimination. Continue 10 vocabulary words per day. Study approximately 1 hour per day.",
                hoursPerWeek: 5),
            StudyPhase(id: "gre3", weekRange: "Weeks 6–8", title: "Quantitative Foundations",
                description: "GRE Math covers arithmetic, algebra, geometry, and data analysis — nothing above Algebra II. Review concepts you have not used since high school. Manhattan Prep 5 lb Book of GRE Practice Problems is the gold standard resource.",
                hoursPerWeek: 5),
            StudyPhase(id: "gre4", weekRange: "Weeks 9–10", title: "Analytical Writing",
                description: "Two essays: Analyze an Issue and Analyze an Argument. Learn the template structure for each. Practice writing 2–3 essays, time yourself to 30 minutes each, and review ETS scoring guidelines. This section is often overlooked but matters for research and humanities programs.",
                hoursPerWeek: 5),
            StudyPhase(id: "gre5", weekRange: "Weeks 11–14", title: "Full Practice Tests",
                description: "One full GRE per week under real timed conditions. Review every wrong answer. Continue vocabulary 10 words per day.",
                hoursPerWeek: 8),
            StudyPhase(id: "gre6", weekRange: "Weeks 15–16", title: "Targeted Weak Areas",
                description: "Focus only on your weakest question types. Do not start new material. Light review and rest before test day.",
                hoursPerWeek: 4)
        ],
        freeResources: [
            "ETS PowerPrep (2 official full tests, free at ets.org)",
            "Magoosh GRE vocabulary flashcards (free app)",
            "Khan Academy for math review"
        ],
        paidResources: [
            "Manhattan Prep GRE Strategy Guides ($26–$35 each)",
            "Magoosh GRE ($149 for 6 months) — excellent online platform",
            "Kaplan GRE: $299–$449"
        ],
        retakePolicy: "GRE scores are valid for 5 years. You can retake up to 5 times per year. ETS offers fee reductions for qualifying students — contact ETS directly. Some programs also cover the fee."
    )

    static let gmat = TestPrepRoadmap(
        id: "gmat",
        examName: "GMAT",
        icon: "briefcase.fill",
        whoNeedsIt: "Applicants to most MBA programs. Some programs now accept the GRE as an alternative — check your target school's requirements before registering.",
        registrationURL: "mba.com",
        typicalCost: "$275",
        scoreRange: "205–805 (GMAT Focus Edition format)",
        targetScores: "Regional MBA programs: 550–620. Top 25 programs: 650–700. Top 10 programs (Harvard, Wharton): 720+.",
        format: "2 hours 15 minutes. Three sections: Quantitative Reasoning, Verbal Reasoning, Data Insights. GMAT Focus Edition format.",
        studyPhases: [
            StudyPhase(id: "gmat1", weekRange: "Weeks 1–2", title: "Diagnostic",
                description: "Take an official GMAT Focus practice exam (2 free at mba.com). Identify your weakest section. Research your target school's median GMAT score for admitted students.",
                hoursPerWeek: 5),
            StudyPhase(id: "gmat2", weekRange: "Weeks 3–5", title: "Quantitative",
                description: "Problem Solving and Data Sufficiency. Data Sufficiency is unique to the GMAT — learn it first. Covers algebra, arithmetic, geometry, statistics, and combinatorics. The Official Guide is the essential resource.",
                hoursPerWeek: 6),
            StudyPhase(id: "gmat3", weekRange: "Weeks 6–8", title: "Verbal",
                description: "Critical Reasoning is the most important section. Reading Comprehension for longer passages. Learn argument structure — conclusion, premise, assumption. This is where most points are won or lost.",
                hoursPerWeek: 6),
            StudyPhase(id: "gmat4", weekRange: "Weeks 9–10", title: "Data Insights",
                description: "New in the GMAT Focus Edition. Combines data interpretation, multi-source reasoning, and table analysis. Practice reading complex data sets quickly and accurately.",
                hoursPerWeek: 5),
            StudyPhase(id: "gmat5", weekRange: "Weeks 11–14", title: "Full Practice Tests",
                description: "2 official GMAT Focus tests available free. Purchase additional tests as needed. Review every error — understand the reasoning pattern, not just the correct answer.",
                hoursPerWeek: 8),
            StudyPhase(id: "gmat6", weekRange: "Weeks 15–16", title: "Targeted Weak Areas",
                description: "Do not revisit areas you have mastered. Drill only your remaining gaps. Light review and rest before test day.",
                hoursPerWeek: 4)
        ],
        freeResources: [
            "Official GMAT Focus practice exams (2 free at mba.com)",
            "GMAT Official Guide (buy the book — $35–$45)",
            "GMATClub.com — free forum with thousands of practice problems"
        ],
        paidResources: [
            "Target Test Prep (TTP): $99–$199/month — best for Quantitative",
            "Magoosh GMAT: $149",
            "Manhattan Prep: $249+"
        ],
        retakePolicy: "GMAT scores are valid for 5 years. You can retake up to 5 times per year, 8 times total in a lifetime."
    )
}
