import Foundation

enum TradeToolkitDatabase {
    static let all: [TradeToolkit] = [electrician, plumber, hvac, welder, carpenter, solar]

    static func toolkit(for id: String) -> TradeToolkit? {
        all.first { $0.id == id }
    }

    static let electrician = TradeToolkit(
        id: "electrician",
        tradeName: "Electrician",
        tradeIcon: "bolt.fill",
        aiProofScore: 95,
        mustHaveTools: [
            ToolItem(id: "e1", name: "Voltage tester (non-contact)", costRange: "$15–$40", isMustHave: true, canRent: false),
            ToolItem(id: "e2", name: "Digital multimeter", costRange: "$30–$80", isMustHave: true, canRent: false),
            ToolItem(id: "e3", name: "Wire strippers (10–22 AWG)", costRange: "$15–$30", isMustHave: true, canRent: false),
            ToolItem(id: "e4", name: "Lineman's pliers", costRange: "$20–$40", isMustHave: true, canRent: false),
            ToolItem(id: "e5", name: "Needle-nose pliers", costRange: "$12–$25", isMustHave: true, canRent: false),
            ToolItem(id: "e6", name: "Flathead and Phillips screwdrivers (set)", costRange: "$15–$30", isMustHave: true, canRent: false),
            ToolItem(id: "e7", name: "Fish tape (25 ft)", costRange: "$25–$60", isMustHave: true, canRent: false),
            ToolItem(id: "e8", name: "Conduit bender (1/2\" and 3/4\")", costRange: "$40–$120", isMustHave: true, canRent: true),
            ToolItem(id: "e9", name: "Drill/driver (cordless, 18V or 20V)", costRange: "$80–$200", isMustHave: true, canRent: false),
            ToolItem(id: "e10", name: "Safety glasses", costRange: "$10–$20", isMustHave: true, canRent: false),
            ToolItem(id: "e11", name: "Tool belt / pouch", costRange: "$30–$80", isMustHave: true, canRent: false),
            ToolItem(id: "e12", name: "Electrician's tape and wire nuts", costRange: "$15–$30", isMustHave: true, canRent: false)
        ],
        estimatedStarterKit: "$350–$800",
        canRentNote: "Can rent at first: conduit bender, fish tape for large pulls, cable puller, pipe threader",
        unionName: "IBEW (International Brotherhood of Electrical Workers)",
        unionWebsite: "ibew.org",
        unionBenefits: [
            "Paid apprenticeship wages from day one",
            "Health insurance from day one",
            "Pension plan",
            "Negotiated wages typically 20–40% above non-union",
            "Legal representation and job security"
        ],
        payDifference: "20–40% more than non-union in comparable markets",
        howToJoin: "Visit ibew.org, find your local chapter, apply during open enrollment. Most locals hold open applications 1–4 times per year.",
        nonUnionNote: "Non-union electricians can earn very well, especially as independent contractors. Many start non-union and join later, or stay non-union for more flexibility on jobs.",
        licenseName: "Journeyman Electrician License Exam",
        licenseAuthority: "State Electrical Board (varies by state)",
        licenseCost: "$50–$150 for exam; $30–$100/year for renewal",
        licenseStudyTime: "4–8 weeks of focused prep after completing apprenticeship",
        licenseKeyTopics: [
            "NEC (National Electrical Code)",
            "Electrical theory and calculations",
            "Wiring methods and materials",
            "Safety procedures",
            "Load calculations"
        ],
        licenseStateNote: "Every state has its own hour requirements. Most require 4 years (8,000 hours) of apprenticeship before sitting for the journeyman exam. Check NASCLA.org for your specific state requirements.",
        ninetyDaySteps: [
            "Week 1–2: Research apprenticeship programs and trade schools in your area",
            "Week 3–4: Contact your local IBEW chapter at ibew.org and ask about the next application window",
            "Week 5–6: Complete any required pre-apprenticeship coursework or entrance exam prep (math and reading)",
            "Week 7–8: Apply to 2–3 apprenticeship programs or enroll in a vocational school electrical program",
            "Week 9–10: Confirm financial aid application (FAFSA, Pell Grant, state workforce grants)",
            "Week 11–12: Purchase your starter tool kit — most programs tell you exactly what to buy on day one"
        ]
    )

    static let plumber = TradeToolkit(
        id: "plumber",
        tradeName: "Plumber",
        tradeIcon: "drop.fill",
        aiProofScore: 95,
        mustHaveTools: [
            ToolItem(id: "p1", name: "Pipe wrench (10\" and 14\")", costRange: "$20–$45 each", isMustHave: true, canRent: false),
            ToolItem(id: "p2", name: "Channel-lock pliers (set)", costRange: "$20–$50", isMustHave: true, canRent: false),
            ToolItem(id: "p3", name: "Basin wrench", costRange: "$20–$35", isMustHave: true, canRent: false),
            ToolItem(id: "p4", name: "Hacksaw + blades", costRange: "$15–$30", isMustHave: true, canRent: false),
            ToolItem(id: "p5", name: "PVC pipe cutter", costRange: "$15–$35", isMustHave: true, canRent: false),
            ToolItem(id: "p6", name: "Copper pipe cutter", costRange: "$15–$30", isMustHave: true, canRent: false),
            ToolItem(id: "p7", name: "Drain snake (25 ft hand)", costRange: "$30–$60", isMustHave: true, canRent: true),
            ToolItem(id: "p8", name: "Torch kit (for copper soldering)", costRange: "$30–$60", isMustHave: true, canRent: false),
            ToolItem(id: "p9", name: "Drill/driver (cordless)", costRange: "$80–$200", isMustHave: true, canRent: false),
            ToolItem(id: "p10", name: "Safety glasses and work gloves", costRange: "$25–$45", isMustHave: true, canRent: false),
            ToolItem(id: "p11", name: "Press-fit tool", costRange: "$400–$800", isMustHave: false, canRent: true)
        ],
        estimatedStarterKit: "$300–$700 (excluding press-fit tool)",
        canRentNote: "Can rent at first: power drain snake, pipe press tool, hydrostatic test pump, sewer camera",
        unionName: "United Association of Plumbers and Pipefitters (UA)",
        unionWebsite: "ua.org",
        unionBenefits: [
            "Paid apprenticeship wages from day one",
            "Health and welfare fund",
            "Pension plan",
            "Annuity fund",
            "Negotiated wages and job security"
        ],
        payDifference: "15–35% more than non-union, with far better benefits",
        howToJoin: "Visit ua.org, find your local union, attend an open house or application event.",
        nonUnionNote: "Residential plumbing companies often hire non-union and provide on-the-job training. A good path if the union application window is closed.",
        licenseName: "Journeyman Plumber License",
        licenseAuthority: "State Plumbing Board or Contractor Licensing Board",
        licenseCost: "$75–$200",
        licenseStudyTime: "6–10 weeks after completing apprenticeship hours",
        licenseKeyTopics: [
            "Plumbing codes (IPC + state amendments)",
            "Pipe sizing and drainage",
            "Venting systems",
            "Water supply systems",
            "Gas lines (if applicable)",
            "Fixture installation"
        ],
        licenseStateNote: "Licensing requirements vary dramatically by state. Some states use a statewide exam; others are county or city-level. Check your state's plumbing licensing board website.",
        ninetyDaySteps: [
            "Week 1–2: Research UA union apprenticeship programs or community college plumbing programs in your area",
            "Week 3–4: Contact your local UA chapter for application dates",
            "Week 5–6: Prepare for apprenticeship entrance exam — basic math including fractions, measurements, and area calculations",
            "Week 7–8: Apply to apprenticeship or enroll in trade school",
            "Week 9–10: Get familiar with local plumbing codes for your area (International Plumbing Code + state amendments)",
            "Week 11–12: Buy your starter tools — most programs provide a list on day one"
        ]
    )

    static let hvac = TradeToolkit(
        id: "hvac-tech",
        tradeName: "HVAC Technician",
        tradeIcon: "wind",
        aiProofScore: 93,
        mustHaveTools: [
            ToolItem(id: "h1", name: "Manifold gauge set (refrigerant gauges)", costRange: "$60–$200", isMustHave: true, canRent: false),
            ToolItem(id: "h2", name: "Digital thermometer with probe", costRange: "$30–$60", isMustHave: true, canRent: false),
            ToolItem(id: "h3", name: "Multimeter", costRange: "$30–$80", isMustHave: true, canRent: false),
            ToolItem(id: "h4", name: "Vacuum pump (2-stage, 5 CFM min)", costRange: "$80–$200", isMustHave: true, canRent: false),
            ToolItem(id: "h5", name: "Refrigerant scale", costRange: "$60–$150", isMustHave: true, canRent: false),
            ToolItem(id: "h6", name: "Leak detector (electronic)", costRange: "$50–$200", isMustHave: true, canRent: false),
            ToolItem(id: "h7", name: "Drill/driver (cordless)", costRange: "$80–$200", isMustHave: true, canRent: false),
            ToolItem(id: "h8", name: "Tin snips (left, right, straight)", costRange: "$30–$60", isMustHave: true, canRent: false),
            ToolItem(id: "h9", name: "Voltage tester", costRange: "$20–$40", isMustHave: true, canRent: false),
            ToolItem(id: "h10", name: "Safety glasses and gloves", costRange: "$25–$45", isMustHave: true, canRent: false),
            ToolItem(id: "h11", name: "Refrigerant recovery machine", costRange: "$400–$800", isMustHave: false, canRent: true)
        ],
        estimatedStarterKit: "$600–$1,400 (excluding recovery machine)",
        canRentNote: "EPA 608 REQUIRED: You must have EPA 608 certification before legally handling refrigerants. Get this first — it is a one-time certification, approximately $20 test fee.",
        unionName: "SMART (Sheet Metal, Air, Rail and Transportation Workers)",
        unionWebsite: "smart-union.org",
        unionBenefits: [
            "5-year paid apprenticeship",
            "Health insurance",
            "Pension plan",
            "Training for multiple specialties",
            "Negotiated wages"
        ],
        payDifference: "25–45% more than non-union entry level",
        howToJoin: "Visit smart-union.org, find your local JATC (Joint Apprenticeship Training Committee) and apply.",
        nonUnionNote: "Many of the best HVAC training opportunities are with non-union residential and commercial companies. Brand-name dealers like Carrier and Lennox train aggressively.",
        licenseName: "EPA 608 Universal Certification (required first) + State Mechanical License",
        licenseAuthority: "EPA (federal, nationwide) + State Mechanical Board",
        licenseCost: "EPA 608: approximately $20. State license: $50–$200.",
        licenseStudyTime: "EPA 608: 1–2 weeks study. State exam: 4–8 weeks after training.",
        licenseKeyTopics: [
            "Refrigeration theory",
            "Electrical systems",
            "Load calculations",
            "Air distribution",
            "Safety procedures",
            "Refrigerant handling and recovery"
        ],
        licenseStateNote: "Most states require a state HVAC or mechanical license for independent work or contracting. EPA 608 is federal and required nationwide regardless of state.",
        ninetyDaySteps: [
            "Week 1–2: Study for and take EPA 608 Section 608 Universal exam — available at local HVAC supply houses or online proctored",
            "Week 3–4: Enroll in HVAC trade school (6–24 months) or apply for apprenticeship through SMART union or local HVAC employer",
            "Week 5–6: Purchase core hand tools and begin building your kit",
            "Week 7–8: Shadow or assist an established tech if possible — many small HVAC companies hire helpers even without full certification",
            "Week 9–10: Study refrigerant types, load calculations, and duct sizing",
            "Week 11–12: Register for NATE certification prep — National American Technician Excellence certification is valued by employers"
        ]
    )

    static let welder = TradeToolkit(
        id: "welder",
        tradeName: "Welder",
        tradeIcon: "flame.fill",
        aiProofScore: 85,
        mustHaveTools: [
            ToolItem(id: "w1", name: "Welding helmet (auto-darkening)", costRange: "$50–$200", isMustHave: true, canRent: false),
            ToolItem(id: "w2", name: "Welding gloves (heavy leather)", costRange: "$15–$40", isMustHave: true, canRent: false),
            ToolItem(id: "w3", name: "Fire-resistant jacket or sleeves", costRange: "$30–$80", isMustHave: true, canRent: false),
            ToolItem(id: "w4", name: "Angle grinder (4.5\") + discs", costRange: "$60–$120", isMustHave: true, canRent: false),
            ToolItem(id: "w5", name: "Wire brush and chipping hammer", costRange: "$10–$20", isMustHave: true, canRent: false),
            ToolItem(id: "w6", name: "C-clamps and locking pliers (Vise-Grips)", costRange: "$20–$50", isMustHave: true, canRent: false),
            ToolItem(id: "w7", name: "Speed square and tape measure", costRange: "$15–$30", isMustHave: true, canRent: false),
            ToolItem(id: "w8", name: "Safety glasses (under helmet)", costRange: "$10–$20", isMustHave: true, canRent: false),
            ToolItem(id: "w9", name: "Steel-toe boots", costRange: "$80–$150", isMustHave: true, canRent: false),
            ToolItem(id: "w10", name: "MIG welder", costRange: "$400–$800", isMustHave: false, canRent: true)
        ],
        estimatedStarterKit: "$300–$650 (excludes welding machine — most employers provide)",
        canRentNote: "Most employers provide welding machines. Your personal kit is your safety gear, hand tools, and prep tools.",
        unionName: "United Brotherhood of Carpenters (UBC) for structural / United Association (UA) for pipe welding",
        unionWebsite: "carpenters.org / ua.org",
        unionBenefits: [
            "Paid apprenticeship",
            "Health insurance",
            "Pension plan",
            "Access to high-paying pipeline and structural projects"
        ],
        payDifference: "Certified pipe welders (6G) often earn $40–$80/hour — one of the highest-paid skilled trades",
        howToJoin: "Contact the applicable local union apprenticeship program. Pipe welding: UA. Structural: UBC or Iron Workers.",
        nonUnionNote: "Industrial and manufacturing welding is often non-union with good pay. Construction and pipeline tend toward union. Many excellent welding careers are built entirely outside the union system.",
        licenseName: "AWS Certification (D1.1 Structural or 6G Pipe)",
        licenseAuthority: "American Welding Society (AWS)",
        licenseCost: "$150–$400 per certification test",
        licenseStudyTime: "Certification readiness depends on practice hours, not time. Most programs recommend 200–400 hours of arc time before testing.",
        licenseKeyTopics: [
            "SMAW (Stick), GMAW (MIG), GTAW (TIG) processes",
            "AWS D1.1 Structural Steel standards",
            "6G pipe position welding",
            "Blueprint reading",
            "Weld inspection and quality"
        ],
        licenseStateNote: "There is no universal government license for welders. Certification is through AWS. Find an AWS-accredited testing facility near you at aws.org.",
        ninetyDaySteps: [
            "Week 1–2: Enroll in a welding program at a community college or vocational school (typically 6–18 months, AWS curriculum)",
            "Week 3–4: Get familiar with the three main processes: MIG (GMAW), TIG (GTAW), and Stick (SMAW)",
            "Week 5–6: Focus on flat and horizontal position welding fundamentals",
            "Week 7–8: Begin working toward AWS D1.1 (Structural Steel) or 6G pipe certification — these are the most marketable",
            "Week 9–10: Practice daily — welding is 90% muscle memory",
            "Week 11–12: Apply for entry-level welder helper or tack welder positions to get shop or field experience while training"
        ]
    )

    static let carpenter = TradeToolkit(
        id: "carpenter",
        tradeName: "Carpenter",
        tradeIcon: "hammer.fill",
        aiProofScore: 92,
        mustHaveTools: [
            ToolItem(id: "c1", name: "Framing hammer (20 oz)", costRange: "$20–$50", isMustHave: true, canRent: false),
            ToolItem(id: "c2", name: "Tape measure (25 ft)", costRange: "$10–$20", isMustHave: true, canRent: false),
            ToolItem(id: "c3", name: "Speed square and combination square", costRange: "$15–$35", isMustHave: true, canRent: false),
            ToolItem(id: "c4", name: "Circular saw (7-1/4\")", costRange: "$60–$180", isMustHave: true, canRent: false),
            ToolItem(id: "c5", name: "Drill/driver (cordless, 20V)", costRange: "$80–$200", isMustHave: true, canRent: false),
            ToolItem(id: "c6", name: "Utility knife + blades", costRange: "$10–$20", isMustHave: true, canRent: false),
            ToolItem(id: "c7", name: "Level (4 ft)", costRange: "$15–$40", isMustHave: true, canRent: false),
            ToolItem(id: "c8", name: "Chalk line", costRange: "$10–$20", isMustHave: true, canRent: false),
            ToolItem(id: "c9", name: "Safety glasses and hearing protection", costRange: "$30–$50", isMustHave: true, canRent: false),
            ToolItem(id: "c10", name: "Tool belt", costRange: "$30–$80", isMustHave: true, canRent: false),
            ToolItem(id: "c11", name: "Nail gun (framing + finish) + compressor", costRange: "$300–$750", isMustHave: false, canRent: true)
        ],
        estimatedStarterKit: "$400–$900 (excluding nail guns and compressor)",
        canRentNote: "Can rent at first: table saw, miter saw, air compressor, nail guns",
        unionName: "United Brotherhood of Carpenters and Joiners (UBC)",
        unionWebsite: "carpenters.org",
        unionBenefits: [
            "4-year paid apprenticeship",
            "Health insurance",
            "Pension plan",
            "Training in framing, finishing, millwork, and more",
            "Negotiated wages"
        ],
        payDifference: "10–30% more than non-union, with full benefits",
        howToJoin: "Visit carpenters.org, find your regional council, and contact the local apprenticeship coordinator.",
        nonUnionNote: "Residential construction is largely non-union in many markets. Many excellent carpentry careers are built entirely outside the union system, especially in custom and finish work.",
        licenseName: "General Contractor License (if bidding jobs) + OSHA 10 Certification",
        licenseAuthority: "State Contractor Licensing Board",
        licenseCost: "OSHA 10: $20–$200. General contractor license varies by state.",
        licenseStudyTime: "OSHA 10: one day. General contractor exam: 4–8 weeks of prep.",
        licenseKeyTopics: [
            "Blueprint reading",
            "Building codes",
            "Framing techniques",
            "OSHA safety standards",
            "Math for carpentry (measurements, area, angles)"
        ],
        licenseStateNote: "No universal carpenter license in most states. General Contractor license required if you bid jobs over a certain dollar threshold — this varies from $500 to $75,000 depending on your state. Check your state contractor licensing board.",
        ninetyDaySteps: [
            "Week 1–2: Research UBC apprenticeship programs or local contractor training programs in your area",
            "Week 3–4: Contact your local United Brotherhood of Carpenters or apply to a carpentry trade school",
            "Week 5–6: Learn blueprint reading basics — critical for all carpentry work, free resources on YouTube",
            "Week 7–8: Apply to apprenticeship or begin trade school enrollment",
            "Week 9–10: Volunteer or offer to help on a project to build portfolio and references",
            "Week 11–12: Build your starter tool kit based on the type of carpentry you are targeting — rough framing vs finish work"
        ]
    )

    static let solar = TradeToolkit(
        id: "solar-installer",
        tradeName: "Solar Installer",
        tradeIcon: "sun.max.fill",
        aiProofScore: 90,
        mustHaveTools: [
            ToolItem(id: "s1", name: "Safety harness and fall protection", costRange: "$100–$300", isMustHave: true, canRent: false),
            ToolItem(id: "s2", name: "Voltage tester (non-contact)", costRange: "$15–$40", isMustHave: true, canRent: false),
            ToolItem(id: "s3", name: "Multimeter", costRange: "$30–$80", isMustHave: true, canRent: false),
            ToolItem(id: "s4", name: "Cordless drill/driver with bits", costRange: "$80–$200", isMustHave: true, canRent: false),
            ToolItem(id: "s5", name: "Impact driver", costRange: "$80–$150", isMustHave: true, canRent: false),
            ToolItem(id: "s6", name: "Tape measure (25 ft)", costRange: "$10–$20", isMustHave: true, canRent: false),
            ToolItem(id: "s7", name: "Level (4 ft)", costRange: "$15–$40", isMustHave: true, canRent: false),
            ToolItem(id: "s8", name: "Wire strippers and crimping tool", costRange: "$20–$40", isMustHave: true, canRent: false),
            ToolItem(id: "s9", name: "Hard hat", costRange: "$20–$40", isMustHave: true, canRent: false),
            ToolItem(id: "s10", name: "Safety glasses", costRange: "$10–$20", isMustHave: true, canRent: false),
            ToolItem(id: "s11", name: "Roof-safe footwear (soft sole)", costRange: "$60–$120", isMustHave: true, canRent: false)
        ],
        estimatedStarterKit: "$500–$1,100",
        canRentNote: "Most equipment (racking, rails, inverters, panels) is supplied by the company or project. You bring your personal tools and safety gear.",
        unionName: "IBEW (for electrical/inverter work) or UBC (for racking and structural)",
        unionWebsite: "ibew.org / carpenters.org",
        unionBenefits: [
            "Prevailing wage requirements on commercial and utility projects",
            "Health insurance",
            "Pension plan",
            "Training in solar-specific electrical work"
        ],
        payDifference: "Union solar jobs on commercial and utility projects can pay significantly more than residential non-union rates",
        howToJoin: "Contact your local IBEW chapter and ask about solar-specific apprenticeship tracks.",
        nonUnionNote: "The residential solar boom is largely non-union. Many installers make excellent income without union membership, especially with NABCEP certification.",
        licenseName: "OSHA 10 (required) + NABCEP Entry Level Exam + NABCEP PVIP Certification (advanced)",
        licenseAuthority: "OSHA (safety) + NABCEP (North American Board of Certified Energy Practitioners)",
        licenseCost: "OSHA 10: $20–$200. NABCEP Entry Level: approximately $100. NABCEP PVIP: approximately $400.",
        licenseStudyTime: "OSHA 10: one day. NABCEP Entry Level: 2–4 weeks study. NABCEP PVIP: 4–8 weeks plus required field experience.",
        licenseKeyTopics: [
            "DC and AC electrical systems",
            "String sizing and inverter wiring",
            "Racking and mounting systems",
            "Roof safety and fall protection",
            "NEC Article 690 (Solar Photovoltaic Systems)"
        ],
        licenseStateNote: "California, Arizona, and Texas are the largest solar markets — each has specific licensing requirements. If you want to handle inverter wiring and interconnection independently, you will need a state electrical license.",
        ninetyDaySteps: [
            "Week 1–2: Research solar companies in your area hiring entry-level installers — most train on the job",
            "Week 3–4: Study for and complete OSHA 10 certification — required on most solar job sites",
            "Week 5–6: Take the NABCEP Entry Level Exam — a strong differentiator that can be done before you have a job",
            "Week 7–8: Apply to solar installation companies — entry-level positions listed as solar technician helper or racking installer",
            "Week 9–10: Learn electrical basics — DC circuits, string sizing, and inverter wiring are key to advancement",
            "Week 11–12: Consider enrolling in an IREC-accredited solar training program for faster advancement"
        ]
    )
}
