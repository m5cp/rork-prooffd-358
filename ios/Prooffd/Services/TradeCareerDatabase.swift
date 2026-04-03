import Foundation

enum TradeCareerDatabase {
    static func lookup(_ pathId: String) -> TradeCareerDetailData? {
        let id = pathId.lowercased()
        return allData[id]
    }

    static func lookupByEducationId(_ eduId: String) -> TradeCareerDetailData? {
        let id = eduId.lowercased()
        return allData[id] ?? educationIdMap[id]
    }

    private static let educationIdMap: [String: TradeCareerDetailData] = [
        "electrician": allData["electrician"]!,
        "plumber": allData["plumber"]!,
        "hvac": allData["hvac"]!,
        "welder": allData["welder"]!,
        "diesel_mechanic": allData["diesel-mechanic"] ?? allData["diesel_mechanic"]!,
        "aircraft_mechanic": allData["aircraft-mechanic"] ?? allData["aircraft_mechanic"]!,
        "locksmith": allData["locksmith"]!,
        "home_inspector": allData["home-inspector"] ?? allData["home_inspector"]!,
        "drone_pilot": allData["drone-pilot"] ?? allData["drone_pilot"]!,
        "cdl_driver": allData["cdl-driver"] ?? allData["cdl_driver"]!,
        "cna": allData["cna"]!,
        "emt": allData["emt"]!,
        "phlebotomist": allData["phlebotomist"]!,
        "medical_assistant": allData["medical-assistant"] ?? allData["medical_assistant"]!,
        "pharmacy_tech": allData["pharmacy-tech"] ?? allData["pharmacy_tech"]!,
        "surgical_tech": allData["surgical-tech"] ?? allData["surgical_tech"]!,
        "respiratory_therapist": allData["respiratory-therapist"] ?? allData["respiratory_therapist"]!,
        "dental_hygienist": allData["dental-hygienist"] ?? allData["dental_hygienist"]!,
        "vet_tech": allData["vet-tech"] ?? allData["vet_tech"]!,
        "cybersecurity": allData["cybersecurity"]!,
        "it_support": allData["it-support"] ?? allData["it_support"]!,
        "web_developer": allData["web-developer"] ?? allData["web_developer"]!,
        "data_analyst": allData["data-analyst"] ?? allData["data_analyst"]!,
        "cloud_computing": allData["cloud-computing"] ?? allData["cloud_computing"]!,
        "network_admin": allData["network-admin"] ?? allData["network_admin"]!,
        "real_estate": allData["real-estate"] ?? allData["real_estate"]!,
        "insurance_agent": allData["insurance-agent"] ?? allData["insurance_agent"]!,
        "massage_therapist": allData["massage-therapist"] ?? allData["massage_therapist"]!,
    ]

    private static let allData: [String: TradeCareerDetailData] = [
        "electrician": TradeCareerDetailData(
            pathId: "electrician",
            entryLevelPay: "$18–$25/hr as apprentice",
            midCareerPay: "$55K–$100K+ as journeyman",
            selfEmploymentUpside: "Master electricians running their own shop can earn $100K–$200K+ with crews",
            timeToEntry: "4–5 years",
            timeToEntryDetail: "Apprenticeship combines paid on-the-job training with classroom instruction. You earn while you learn from day one.",
            aiResistantReasons: [
                "Every job requires physical presence at the worksite",
                "Wiring and troubleshooting require human judgment in unpredictable environments",
                "State licensing creates a regulated barrier to entry",
                "Safety-critical work demands accountability that AI cannot provide",
                "Growing demand from EV chargers, solar, and smart home systems",
                "Aging workforce is retiring faster than new electricians are entering"
            ],
            firstJobStrategies: [
                "Apply to your local IBEW union for a paid apprenticeship",
                "Contact residential and commercial electrical contractors directly",
                "Enroll in a trade school pre-apprenticeship program",
                "Apply to employer-sponsored apprenticeship programs",
                "Check state apprenticeship registry for open positions"
            ],
            futureBusinessOption: "Licensed master electricians can start their own contracting business. Residential and commercial electrical services are in high demand, and independent electricians often earn significantly more than employees.",
            tuitionCostRange: "$2K–$5K (often offset by paid apprenticeship wages)",
            toolsAndExamRequirements: [
                "Journeyman electrician exam (state-specific)",
                "NEC code knowledge",
                "Basic hand tools and multimeter",
                "Personal protective equipment",
                "OSHA safety certification"
            ],
            licensingRequirements: [
                "Journeyman electrician license (after apprenticeship)",
                "Master electrician license (with additional experience)",
                "State and local permits for independent work",
                "Continuing education for license renewal"
            ]
        ),

        "plumber": TradeCareerDetailData(
            pathId: "plumber",
            entryLevelPay: "$16–$24/hr as apprentice",
            midCareerPay: "$50K–$90K+ as journeyman",
            selfEmploymentUpside: "Master plumbers with their own business can earn $100K–$180K+ annually",
            timeToEntry: "4–5 years",
            timeToEntryDetail: "Plumbing apprenticeships combine paid work with technical training. Most programs are 4–5 years with progressive pay increases.",
            aiResistantReasons: [
                "Plumbing work must be done on-site in physical spaces",
                "Every job involves unique layouts, materials, and conditions",
                "State licensing ensures only trained professionals can do the work",
                "Water and gas systems require safety accountability",
                "Aging infrastructure creates constant repair demand",
                "Severe national shortage of licensed plumbers"
            ],
            firstJobStrategies: [
                "Apply to plumbing union apprenticeships (UA Local)",
                "Contact local plumbing companies for apprentice openings",
                "Enroll in a plumbing trade school program",
                "Look for employer-sponsored training at commercial plumbing firms",
                "Check state workforce development apprenticeship listings"
            ],
            futureBusinessOption: "Licensed master plumbers can open their own plumbing business. Emergency plumbing, new construction, and remodeling provide consistent revenue streams.",
            tuitionCostRange: "$2K–$4K (often paid training through apprenticeships)",
            toolsAndExamRequirements: [
                "Journeyman plumber exam",
                "Pipe wrenches, cutters, and threading tools",
                "Soldering and brazing equipment",
                "Drain cleaning tools",
                "Safety gear and PPE"
            ],
            licensingRequirements: [
                "Journeyman plumber license",
                "Master plumber license (additional experience required)",
                "Backflow prevention certification in some states",
                "Continuing education for license renewal"
            ]
        ),

        "hvac": TradeCareerDetailData(
            pathId: "hvac",
            entryLevelPay: "$16–$22/hr entry-level",
            midCareerPay: "$45K–$85K+ experienced technician",
            selfEmploymentUpside: "Independent HVAC contractors can earn $80K–$150K+ with a client base",
            timeToEntry: "6 months – 2 years",
            timeToEntryDetail: "HVAC programs range from 6-month certificates to 2-year associate degrees. Many enter through employer-sponsored training.",
            aiResistantReasons: [
                "HVAC systems require hands-on diagnosis and physical repair",
                "Every building has unique ductwork, equipment, and conditions",
                "EPA certification required for refrigerant handling",
                "Climate change is driving record demand for HVAC services",
                "Emergency repair work requires immediate physical presence",
                "Energy efficiency regulations create ongoing upgrade demand"
            ],
            firstJobStrategies: [
                "Complete an HVAC certificate program at a trade school",
                "Apply directly to HVAC companies as a helper or trainee",
                "Look for employer-sponsored training programs",
                "Get EPA 608 certification to handle refrigerants",
                "Start at a large company for structured training, then specialize"
            ],
            futureBusinessOption: "Experienced HVAC technicians can start their own service company. Seasonal demand for heating and cooling creates year-round work, and maintenance contracts provide recurring revenue.",
            tuitionCostRange: "$1K–$3K for certificate; $5K–$15K for associate degree",
            toolsAndExamRequirements: [
                "EPA 608 certification (mandatory for refrigerant handling)",
                "NATE certification (optional but valued)",
                "Manifold gauges and recovery equipment",
                "Electrical testing tools",
                "HVAC-specific hand tools"
            ],
            licensingRequirements: [
                "EPA Section 608 certification (required)",
                "State HVAC contractor license (varies by state)",
                "NATE certification (industry standard)",
                "Continuing education for license maintenance"
            ]
        ),

        "welder": TradeCareerDetailData(
            pathId: "welder",
            entryLevelPay: "$15–$22/hr entry-level",
            midCareerPay: "$40K–$80K+ experienced / specialized",
            selfEmploymentUpside: "Specialized welders (pipeline, underwater, aerospace) can earn $80K–$150K+. Mobile welding businesses are highly profitable.",
            timeToEntry: "6 months – 2 years",
            timeToEntryDetail: "Welding programs range from short certificates to 2-year degrees. Many welders start with basic certifications and add specialties over time.",
            aiResistantReasons: [
                "Welding requires precise manual skill in varied physical positions",
                "Each weld joint is unique based on material, position, and conditions",
                "Structural and safety-critical welding demands human accountability",
                "Field welding in construction, pipelines, and repair cannot be automated",
                "AWS certification validates skill that robots cannot replicate in most settings",
                "Specialized welding (underwater, aerospace) has very high barriers"
            ],
            firstJobStrategies: [
                "Enroll in a welding program at a community college or trade school",
                "Apply as a welder's helper at fabrication shops",
                "Get basic AWS certifications to prove skill",
                "Look for employer training at manufacturing plants",
                "Join a union apprenticeship program for structural welding"
            ],
            futureBusinessOption: "Mobile welding and custom fabrication are profitable business paths. Farm and ranch repair, ornamental metalwork, and emergency welding services offer strong independent income.",
            tuitionCostRange: "$500–$2K for basic certification; $5K–$15K for full program",
            toolsAndExamRequirements: [
                "AWS (American Welding Society) certification",
                "MIG, TIG, and Stick welding proficiency",
                "Welding helmet, gloves, and protective gear",
                "Personal welding machine (for mobile work)",
                "Metal cutting and grinding tools"
            ],
            licensingRequirements: [
                "AWS certification (industry standard)",
                "Specific welding procedure qualifications for structural work",
                "OSHA safety certification for construction sites",
                "D1.1 structural welding certification for construction"
            ]
        ),

        "welding": TradeCareerDetailData(
            pathId: "welding",
            entryLevelPay: "$15–$22/hr entry-level",
            midCareerPay: "$40K–$80K+ experienced / specialized",
            selfEmploymentUpside: "Mobile welding businesses and custom fabrication can generate $80K–$150K+",
            timeToEntry: "6 months – 2 years",
            timeToEntryDetail: "Welding training ranges from short certifications to multi-year apprenticeships depending on specialty.",
            aiResistantReasons: [
                "Welding requires hands-on precision in physical environments",
                "Each joint, position, and material combination is unique",
                "Safety-critical structural work demands human accountability",
                "Field welding cannot be automated in most real-world conditions",
                "Specialized welding commands premium rates"
            ],
            firstJobStrategies: [
                "Enroll in a welding program at a community college",
                "Apply as a helper at fabrication or manufacturing shops",
                "Get AWS certifications to demonstrate competency",
                "Look for employer-sponsored training programs"
            ],
            futureBusinessOption: "Mobile welding, farm and ranch repair, ornamental metalwork, and emergency services create strong independent business opportunities.",
            tuitionCostRange: "$500–$2K for basic; $5K–$15K for full program",
            toolsAndExamRequirements: [
                "AWS certification",
                "MIG, TIG, Stick proficiency",
                "Welding PPE and equipment"
            ],
            licensingRequirements: [
                "AWS certification (industry standard)",
                "OSHA safety training for jobsites"
            ]
        ),

        "diesel-mechanic": TradeCareerDetailData(
            pathId: "diesel-mechanic",
            entryLevelPay: "$18–$24/hr entry-level",
            midCareerPay: "$45K–$80K+ experienced",
            selfEmploymentUpside: "Mobile diesel repair services can earn $80K–$120K+ serving fleet operators",
            timeToEntry: "1–2 years",
            timeToEntryDetail: "Diesel technology programs are typically 1–2 years. Many fleet companies also offer employer-sponsored training.",
            aiResistantReasons: [
                "Diesel engines require physical hands-on diagnosis and repair",
                "Fleet vehicles break down in unpredictable locations requiring mobile service",
                "Heavy equipment and commercial trucks are essential to the economy",
                "ASE diesel certifications validate specialized knowledge",
                "Freight industry growth ensures steady long-term demand"
            ],
            firstJobStrategies: [
                "Complete a diesel technology program at a trade school",
                "Apply to fleet companies (trucking, construction, transit)",
                "Look for dealership training programs (Cummins, Caterpillar, John Deere)",
                "Start as a shop helper and learn while earning",
                "Get ASE diesel certifications for better opportunities"
            ],
            futureBusinessOption: "Mobile diesel repair is a growing niche. Serving trucking companies, construction firms, and agricultural operations can be very profitable with lower overhead than a fixed shop.",
            tuitionCostRange: "$3K–$10K for diesel technology program",
            toolsAndExamRequirements: [
                "ASE diesel mechanic certifications",
                "Diagnostic scan tools for diesel engines",
                "Heavy-duty hand and air tools",
                "Torque wrenches and specialty diesel tools",
                "Safety gear for shop and field work"
            ],
            licensingRequirements: [
                "ASE Medium/Heavy Truck certifications",
                "EPA regulations knowledge for emissions systems",
                "State inspection license in some areas"
            ]
        ),

        "aircraft-mechanic": TradeCareerDetailData(
            pathId: "aircraft-mechanic",
            entryLevelPay: "$22–$30/hr entry-level",
            midCareerPay: "$55K–$90K+ experienced",
            selfEmploymentUpside: "Independent A&P mechanics doing contract MRO work can earn $100K+ at major airports",
            timeToEntry: "18–24 months",
            timeToEntryDetail: "FAA-approved A&P school programs are typically 18–24 months. Military aviation experience can qualify for accelerated paths.",
            aiResistantReasons: [
                "Aircraft maintenance requires hands-on inspection and repair",
                "FAA regulations mandate human oversight for all airworthiness decisions",
                "Every aircraft has unique service history and condition",
                "Safety-critical work cannot be delegated to automation",
                "Severe shortage of A&P mechanics as older technicians retire",
                "Airlines and MRO facilities are actively recruiting"
            ],
            firstJobStrategies: [
                "Enroll in an FAA-approved A&P school",
                "Apply to airline apprenticeship or internship programs",
                "Contact MRO (Maintenance, Repair, Overhaul) facilities directly",
                "Leverage military aviation experience for advanced placement",
                "Apply to regional airlines which often hire newly certified A&Ps"
            ],
            futureBusinessOption: "Experienced A&P mechanics can do contract work for MRO facilities or start a mobile inspection service for general aviation aircraft.",
            tuitionCostRange: "$15K–$30K for FAA-approved school",
            toolsAndExamRequirements: [
                "FAA Airframe & Powerplant (A&P) certificate",
                "Written, oral, and practical FAA exams",
                "Aviation-specific hand tools",
                "Inspection equipment and borescopes",
                "Safety equipment for hangar and ramp work"
            ],
            licensingRequirements: [
                "FAA Airframe certificate",
                "FAA Powerplant certificate",
                "Inspection Authorization (IA) for advanced inspectors",
                "Recurrent training requirements"
            ]
        ),

        "water-heater": TradeCareerDetailData(
            pathId: "water-heater",
            entryLevelPay: "$16–$22/hr entry-level",
            midCareerPay: "$40K–$65K+ experienced",
            selfEmploymentUpside: "Independent water heater specialists can earn $60K–$100K+ focusing on replacements and maintenance",
            timeToEntry: "3–12 months",
            timeToEntryDetail: "Training through plumbing helpers, manufacturer training, or short trade programs. Some states require plumbing-adjacent licensing.",
            aiResistantReasons: [
                "Physical installation and repair in residential and commercial spaces",
                "Every installation involves unique plumbing configurations",
                "Gas and electrical connections require safety training",
                "In-person diagnosis of leaks, failures, and efficiency issues",
                "Homeowners need trusted local service providers"
            ],
            firstJobStrategies: [
                "Get hired as a plumbing helper to learn water heater systems",
                "Take manufacturer training courses (Rheem, AO Smith, Bradford White)",
                "Start by offering water heater maintenance and flushing services",
                "Partner with plumbing companies for overflow referrals"
            ],
            futureBusinessOption: "Water heater installation, replacement, and maintenance can be a focused niche business with strong recurring revenue from maintenance contracts.",
            tuitionCostRange: "$500–$3K for relevant training",
            toolsAndExamRequirements: [
                "Basic plumbing tools",
                "Pipe wrenches and fittings",
                "Gas line tools and leak detection equipment",
                "Manufacturer-specific training completion"
            ],
            licensingRequirements: [
                "Plumbing license may be required depending on state",
                "Gas fitting certification if working with gas water heaters",
                "Local permits for installation work"
            ]
        ),

        "basic-electrical": TradeCareerDetailData(
            pathId: "basic-electrical",
            entryLevelPay: "$15–$20/hr entry-level",
            midCareerPay: "$35K–$55K+ experienced helper/maintenance",
            selfEmploymentUpside: "Licensed electricians earn significantly more — this path can lead to full licensure",
            timeToEntry: "3–12 months for basic work; 4–5 years for licensure",
            timeToEntryDetail: "Basic electrical maintenance can be learned quickly, but full electrical work typically requires licensure through an apprenticeship.",
            aiResistantReasons: [
                "Electrical work requires physical presence and hands-on skill",
                "Safety-critical work with high accountability",
                "State licensing limits who can perform this work",
                "Every building and circuit is different",
                "Growing demand from residential and commercial needs"
            ],
            firstJobStrategies: [
                "Start as an electrical helper at a contracting company",
                "Take basic electrical courses at a trade school",
                "Apply for electrical apprenticeship programs",
                "Look for maintenance electrician roles at facilities"
            ],
            futureBusinessOption: "After completing a full apprenticeship and licensure, starting an electrical contracting business is a natural progression.",
            tuitionCostRange: "$500–$3K for basic courses; $2K–$5K for apprenticeship path",
            toolsAndExamRequirements: [
                "Basic hand tools and multimeter",
                "Understanding of NEC code basics",
                "Safety equipment and PPE"
            ],
            licensingRequirements: [
                "Electrical work typically requires a license in most states",
                "Helper or apprentice registration may be needed",
                "Full journeyman license after completing apprenticeship"
            ]
        ),

        "basic-plumbing": TradeCareerDetailData(
            pathId: "basic-plumbing",
            entryLevelPay: "$14–$20/hr entry-level helper",
            midCareerPay: "$35K–$55K+ experienced maintenance",
            selfEmploymentUpside: "Licensed plumbers earn significantly more — this path can lead to full licensure",
            timeToEntry: "3–12 months for basic work; 4–5 years for licensure",
            timeToEntryDetail: "Basic plumbing maintenance can be learned through short courses, but full plumbing work requires licensure.",
            aiResistantReasons: [
                "Physical hands-on work in varied residential and commercial settings",
                "Water system safety requires trained human judgment",
                "Licensing creates a barrier to entry that protects qualified workers",
                "Aging infrastructure creates constant maintenance demand"
            ],
            firstJobStrategies: [
                "Get hired as a plumber's helper",
                "Enroll in plumbing fundamentals at a trade school",
                "Apply for plumbing apprenticeships",
                "Look for facility maintenance roles that include plumbing"
            ],
            futureBusinessOption: "After full licensure, plumbing businesses are highly profitable with strong demand for residential and commercial services.",
            tuitionCostRange: "$500–$3K for basics; $2K–$4K for apprenticeship",
            toolsAndExamRequirements: [
                "Basic plumbing hand tools",
                "Pipe wrenches and cutters",
                "Safety equipment"
            ],
            licensingRequirements: [
                "Plumbing helper or apprentice registration",
                "Full journeyman license after apprenticeship",
                "State-specific requirements vary"
            ]
        ),

        "locksmith": TradeCareerDetailData(
            pathId: "locksmith",
            entryLevelPay: "$14–$18/hr entry-level",
            midCareerPay: "$35K–$65K+ experienced",
            selfEmploymentUpside: "Independent locksmiths with emergency services can earn $60K–$100K+",
            timeToEntry: "3–6 months",
            timeToEntryDetail: "Locksmith training programs are relatively short. Apprenticing with an established locksmith accelerates learning.",
            aiResistantReasons: [
                "Lock and key work requires physical hands-on skill",
                "Emergency lockouts demand immediate in-person response",
                "Modern electronic and smart lock systems add complexity",
                "Trust-based customer relationship — people let you into their homes",
                "State licensing in many areas limits competition"
            ],
            firstJobStrategies: [
                "Complete a locksmith training program",
                "Apprentice with an established locksmith",
                "Get your state locksmith license if required",
                "Start with residential lockout services and key duplication",
                "Build relationships with property managers and real estate agents"
            ],
            futureBusinessOption: "Independent locksmith businesses thrive on emergency services, commercial contracts, and recurring property management relationships.",
            tuitionCostRange: "$1K–$5K for training program",
            toolsAndExamRequirements: [
                "Lock pick sets and key cutting machines",
                "Automotive lock tools",
                "Electronic access system tools",
                "Mobile service van or vehicle",
                "State locksmith exam if applicable"
            ],
            licensingRequirements: [
                "State locksmith license (varies — required in many states)",
                "Background check in most states",
                "Business registration and insurance"
            ]
        ),

        "home-inspector": TradeCareerDetailData(
            pathId: "home-inspector",
            entryLevelPay: "$300–$500 per inspection (entry-level)",
            midCareerPay: "$45K–$80K+ experienced",
            selfEmploymentUpside: "Busy inspectors doing 4–5 inspections/week can earn $80K–$120K+",
            timeToEntry: "2–4 months",
            timeToEntryDetail: "State-approved training programs are typically 2–4 months. Some states require supervised inspections before full licensure.",
            aiResistantReasons: [
                "Every home is unique — inspections require physical presence and judgment",
                "Crawling through attics, basements, and crawlspaces cannot be automated",
                "Liability and trust require a licensed human professional",
                "Real estate transactions depend on inspector findings",
                "Growing housing market keeps demand steady"
            ],
            firstJobStrategies: [
                "Complete a state-approved home inspection course",
                "Perform supervised practice inspections under a mentor",
                "Pass the state licensing or certification exam",
                "Build relationships with local real estate agents",
                "Join InterNACHI for credibility and resources"
            ],
            futureBusinessOption: "Home inspection is naturally an independent business. Adding specialties like radon testing, mold inspection, or commercial inspection increases revenue.",
            tuitionCostRange: "$2K–$5K for training and certification",
            toolsAndExamRequirements: [
                "State home inspection license exam",
                "National Home Inspector Exam (in some states)",
                "Moisture meters and thermal cameras",
                "Inspection report software",
                "Ladder, flashlights, and personal protective equipment"
            ],
            licensingRequirements: [
                "State home inspector license (most states require it)",
                "E&O insurance recommended",
                "Continuing education for license renewal"
            ]
        ),

        "drone-pilot": TradeCareerDetailData(
            pathId: "drone-pilot",
            entryLevelPay: "$200–$500 per flight job",
            midCareerPay: "$40K–$80K+ full-time",
            selfEmploymentUpside: "Drone operators specializing in construction, agriculture, or film can earn $80K–$120K+",
            timeToEntry: "2–4 weeks",
            timeToEntryDetail: "FAA Part 107 knowledge test can be prepared for in 2–4 weeks. Flight skill takes additional practice.",
            aiResistantReasons: [
                "Drone operations require local physical presence",
                "Airspace regulations demand human pilot judgment",
                "FAA licensing creates a regulated barrier to entry",
                "Client-facing work (real estate, events) requires human interaction",
                "Applications expanding in construction, agriculture, and insurance"
            ],
            firstJobStrategies: [
                "Pass the FAA Part 107 Remote Pilot knowledge test",
                "Invest in a quality commercial drone",
                "Build a portfolio with sample aerial work",
                "Market to real estate agents, construction firms, and event planners",
                "Join drone pilot networks for subcontracting opportunities"
            ],
            futureBusinessOption: "Drone services can scale into a full business offering aerial photography, mapping, inspections, and agricultural surveys.",
            tuitionCostRange: "$300–$2K for test prep and initial equipment",
            toolsAndExamRequirements: [
                "FAA Part 107 Remote Pilot Certificate",
                "Commercial-grade drone ($1K–$5K)",
                "Spare batteries and accessories",
                "Photo/video editing software",
                "Airspace planning and compliance tools"
            ],
            licensingRequirements: [
                "FAA Part 107 Remote Pilot Certificate (required)",
                "Drone registration with FAA",
                "Liability insurance recommended",
                "State/local regulations may apply"
            ]
        ),

        "cdl-driver": TradeCareerDetailData(
            pathId: "cdl-driver",
            entryLevelPay: "$45K–$55K first year",
            midCareerPay: "$50K–$80K+ experienced",
            selfEmploymentUpside: "Owner-operators can earn $100K–$200K+ gross revenue (net varies with expenses)",
            timeToEntry: "3–6 weeks",
            timeToEntryDetail: "CDL training programs are typically 3–6 weeks. Many trucking companies offer company-sponsored training with a service commitment.",
            aiResistantReasons: [
                "Autonomous trucks are decades away from widespread adoption",
                "Last-mile delivery and urban routes are too complex for automation",
                "Loading, unloading, and customer interaction require a human",
                "Regulatory compliance and inspection require human drivers",
                "Severe driver shortage keeps wages rising"
            ],
            firstJobStrategies: [
                "Enroll in a CDL training program",
                "Apply for company-sponsored CDL training (Schneider, Werner, Swift)",
                "Pass the CDL written and skills tests",
                "Start with a large carrier for structured mentorship",
                "Choose route type: local, regional, or over-the-road"
            ],
            futureBusinessOption: "Experienced drivers can become owner-operators or start small trucking companies. Authority and dedicated contracts provide higher earning potential.",
            tuitionCostRange: "$3K–$7K (many companies offer free training with commitment)",
            toolsAndExamRequirements: [
                "CDL written knowledge test",
                "CDL skills/driving test",
                "DOT medical examination",
                "Pre-trip inspection knowledge",
                "Hazmat endorsement (optional, higher pay)"
            ],
            licensingRequirements: [
                "Commercial Driver's License (CDL) — Class A or B",
                "DOT medical card",
                "Clean driving record required",
                "Drug and alcohol testing compliance",
                "Endorsements for hazmat, tanker, doubles (optional)"
            ]
        ),

        "cna": TradeCareerDetailData(
            pathId: "cna",
            entryLevelPay: "$14–$18/hr entry-level",
            midCareerPay: "$28K–$40K+ experienced",
            selfEmploymentUpside: "Private-duty CNAs can charge $20–$30/hr. CNA is also a stepping stone to LPN/RN careers earning $50K–$90K+.",
            timeToEntry: "4–12 weeks",
            timeToEntryDetail: "CNA programs are among the fastest healthcare certifications. Many hospitals and nursing homes offer free training in exchange for a work commitment.",
            aiResistantReasons: [
                "Direct patient care requires physical human presence",
                "Bathing, feeding, and mobility assistance cannot be automated",
                "Emotional support and patient interaction are essential",
                "Healthcare facilities have constant staffing needs",
                "Aging population is driving demand higher every year"
            ],
            firstJobStrategies: [
                "Enroll in a state-approved CNA program",
                "Apply to facilities that offer free CNA training with a job guarantee",
                "Complete clinical hours at a nursing home or hospital",
                "Pass the state certification exam",
                "Apply to hospitals, nursing homes, or home health agencies"
            ],
            futureBusinessOption: "CNAs can advance to LPN or RN with additional education. Some CNAs also do private-duty home care independently.",
            tuitionCostRange: "$500–$2K (often free through employer-sponsored programs)",
            toolsAndExamRequirements: [
                "State CNA certification exam (written and skills)",
                "Blood pressure cuff and stethoscope",
                "Scrubs and comfortable shoes",
                "CPR/BLS certification"
            ],
            licensingRequirements: [
                "State CNA certification (required)",
                "Background check and health screening",
                "CPR/BLS certification",
                "Renewal with continuing education hours"
            ]
        ),

        "emt": TradeCareerDetailData(
            pathId: "emt",
            entryLevelPay: "$15–$20/hr entry-level EMT",
            midCareerPay: "$35K–$60K+ paramedic",
            selfEmploymentUpside: "Flight medics and specialized paramedics can earn $60K–$80K+. Fire department paramedics often earn more with overtime.",
            timeToEntry: "3–6 months (EMT); 1–2 years (Paramedic)",
            timeToEntryDetail: "EMT-Basic can be completed in as little as 3 months. Paramedic programs take 1–2 years and require EMT-B first.",
            aiResistantReasons: [
                "Emergency medical care requires immediate physical presence",
                "Every emergency is unique and requires real-time human judgment",
                "Patient assessment and treatment cannot be automated",
                "Life-and-death accountability demands trained humans",
                "Communities will always need emergency medical services"
            ],
            firstJobStrategies: [
                "Complete an EMT-Basic course (120+ hours)",
                "Pass the NREMT certification exam",
                "Apply to ambulance services, fire departments, and hospitals",
                "Gain experience and consider paramedic advancement",
                "Look for fire department-sponsored paramedic training"
            ],
            futureBusinessOption: "While direct self-employment is less common, EMTs can advance to paramedic, flight medic, fire department, or nursing careers with significantly higher pay.",
            tuitionCostRange: "$1K–$5K (EMT); $5K–$15K (Paramedic)",
            toolsAndExamRequirements: [
                "NREMT certification exam",
                "State EMT or paramedic license",
                "CPR/BLS and ACLS certification",
                "Clinical and field internship hours"
            ],
            licensingRequirements: [
                "NREMT certification (national)",
                "State EMT or paramedic license",
                "CPR/BLS certification maintained",
                "Continuing education for recertification"
            ]
        ),

        "phlebotomist": TradeCareerDetailData(
            pathId: "phlebotomist",
            entryLevelPay: "$14–$18/hr entry-level",
            midCareerPay: "$30K–$45K+ experienced",
            selfEmploymentUpside: "Mobile phlebotomy services can charge $25–$75 per draw for home visits and corporate wellness",
            timeToEntry: "4–8 weeks",
            timeToEntryDetail: "One of the fastest healthcare certifications. Programs include classroom instruction and supervised blood draws.",
            aiResistantReasons: [
                "Blood draws require physical human skill and patient interaction",
                "Patient comfort and vein assessment need human judgment",
                "Every patient's veins and conditions are different",
                "Lab testing demand grows as healthcare expands",
                "Quick certification makes this a reliable entry point"
            ],
            firstJobStrategies: [
                "Complete a phlebotomy training program",
                "Pass the national certification exam (NHA CPT or ASCP)",
                "Apply to hospitals, labs, clinics, and blood banks",
                "Consider mobile phlebotomy for higher earning potential",
                "Use this as a stepping stone to medical lab or nursing"
            ],
            futureBusinessOption: "Mobile phlebotomy services for home visits, corporate wellness, and insurance exams can be a profitable independent business.",
            tuitionCostRange: "$500–$2K",
            toolsAndExamRequirements: [
                "National phlebotomy certification exam",
                "Venipuncture supplies and collection tubes",
                "Tourniquet and safety needles",
                "PPE and biohazard disposal supplies"
            ],
            licensingRequirements: [
                "National phlebotomy certification (NHA CPT or ASCP)",
                "State certification may be required (varies)",
                "CPR certification recommended"
            ]
        ),

        "medical-assistant": TradeCareerDetailData(
            pathId: "medical-assistant",
            entryLevelPay: "$14–$18/hr entry-level",
            midCareerPay: "$30K–$45K+ experienced",
            selfEmploymentUpside: "MAs typically advance into higher-paying roles — LPN, RN, health administration — rather than self-employment",
            timeToEntry: "9–12 months",
            timeToEntryDetail: "Medical assistant certificate or diploma programs are typically 9–12 months, including an externship at a medical office.",
            aiResistantReasons: [
                "Combines hands-on clinical tasks with patient interaction",
                "Taking vitals, administering injections, and assisting exams require physical presence",
                "Patient communication and comfort cannot be automated",
                "Every patient visit involves unique conditions",
                "Healthcare demand continues growing with an aging population"
            ],
            firstJobStrategies: [
                "Complete a CAAHEP-accredited medical assistant program",
                "Pass the CMA or RMA certification exam",
                "Leverage your clinical externship for job placement",
                "Apply to physician offices, clinics, and urgent care centers",
                "Consider specializing in a medical area for higher pay"
            ],
            futureBusinessOption: "Medical assistants typically advance into nursing (LPN/RN), health administration, or specialized clinical roles rather than independent business.",
            tuitionCostRange: "$3K–$15K",
            toolsAndExamRequirements: [
                "CMA or RMA certification exam",
                "Stethoscope and blood pressure cuff",
                "Scrubs and clinical attire",
                "CPR/BLS certification"
            ],
            licensingRequirements: [
                "CMA (AAMA) or RMA (AMT) certification",
                "CPR/BLS certification",
                "State-specific requirements may apply"
            ]
        ),

        "pharmacy-tech": TradeCareerDetailData(
            pathId: "pharmacy-tech",
            entryLevelPay: "$14–$18/hr entry-level",
            midCareerPay: "$30K–$45K+ experienced",
            selfEmploymentUpside: "Pharmacy techs typically advance into specialized roles (compounding, IV, oncology) or pharmacy management rather than self-employment",
            timeToEntry: "3–12 months",
            timeToEntryDetail: "Some pharmacy chains offer on-the-job training. Formal programs are 3–12 months.",
            aiResistantReasons: [
                "Handling, counting, and dispensing medication requires physical accuracy",
                "Patient interaction for prescription pickup and questions",
                "Compounding and IV preparation need manual precision",
                "Regulatory environment requires human accountability",
                "Pharmacies are expanding services (vaccinations, testing)"
            ],
            firstJobStrategies: [
                "Apply to pharmacy chains that offer on-the-job training (CVS, Walgreens)",
                "Complete a pharmacy technician program",
                "Pass the PTCB or ExCPT certification exam",
                "Register with your state board of pharmacy",
                "Start retail and advance to hospital pharmacy for higher pay"
            ],
            futureBusinessOption: "Pharmacy techs advance within the profession — compounding specialty, hospital pharmacy, or pursue a PharmD degree for full pharmacist career.",
            tuitionCostRange: "$1K–$5K (some employers offer free training)",
            toolsAndExamRequirements: [
                "PTCB or ExCPT certification exam",
                "State pharmacy board registration",
                "Knowledge of medication names and dosages"
            ],
            licensingRequirements: [
                "PTCB or ExCPT certification",
                "State board of pharmacy registration",
                "Background check required",
                "Continuing education for recertification"
            ]
        ),

        "surgical-tech": TradeCareerDetailData(
            pathId: "surgical-tech",
            entryLevelPay: "$20–$26/hr entry-level",
            midCareerPay: "$45K–$65K+ experienced",
            selfEmploymentUpside: "Travel surgical techs can earn $55K–$80K+ with premium assignments. Advancement to surgical first assist adds $10K–$20K.",
            timeToEntry: "9–24 months",
            timeToEntryDetail: "Certificate programs are ~12 months; associate degrees are ~24 months. Both include operating room clinical rotations.",
            aiResistantReasons: [
                "Surgical procedures require skilled human hands in the operating room",
                "Instrument handling, sterile technique, and anticipation of surgeon needs are human skills",
                "Every surgery is different with real-time decision making",
                "Patient safety accountability cannot be delegated to automation",
                "Aging population increases surgical volume"
            ],
            firstJobStrategies: [
                "Enroll in an accredited surgical technology program",
                "Complete clinical rotations in operating rooms",
                "Pass the CST certification exam",
                "Apply to hospitals and ambulatory surgical centers",
                "Consider travel assignments for higher pay and experience"
            ],
            futureBusinessOption: "Surgical techs advance within healthcare — surgical first assist, operating room management, or transition to nursing or PA programs.",
            tuitionCostRange: "$5K–$20K",
            toolsAndExamRequirements: [
                "CST (Certified Surgical Technologist) exam",
                "CPR/BLS certification",
                "Surgical scrubs and proper OR attire",
                "Clinical rotation completion"
            ],
            licensingRequirements: [
                "CST certification (national standard)",
                "State-specific requirements may apply",
                "CPR/BLS certification",
                "Continuing education for recertification"
            ]
        ),

        "respiratory-therapist": TradeCareerDetailData(
            pathId: "respiratory-therapist",
            entryLevelPay: "$22–$28/hr entry-level",
            midCareerPay: "$50K–$75K+ experienced",
            selfEmploymentUpside: "Travel respiratory therapists can earn $60K–$90K+. Advancement to management or education adds $10K–$20K.",
            timeToEntry: "2 years",
            timeToEntryDetail: "Associate degree program with clinical rotations. Some pursue bachelor's degrees for advancement.",
            aiResistantReasons: [
                "Respiratory care requires hands-on patient assessment and treatment",
                "Ventilator management in ICU demands real-time human judgment",
                "Emergency intubation and airway management are manual skills",
                "Patient education and emotional support are essential",
                "Critical care demand continues growing"
            ],
            firstJobStrategies: [
                "Enroll in an accredited respiratory therapy program",
                "Complete clinical rotations at hospitals",
                "Pass the TMC and Clinical Simulation exams",
                "Obtain your state license",
                "Apply to hospitals — especially ICU, ER, and NICU departments"
            ],
            futureBusinessOption: "Respiratory therapists typically advance into specialized areas (neonatal, sleep therapy, pulmonary rehab), education, or management.",
            tuitionCostRange: "$10K–$25K for associate degree",
            toolsAndExamRequirements: [
                "TMC (Therapist Multiple Choice) exam",
                "Clinical Simulation Exam (CSE)",
                "State respiratory therapy license",
                "CPR/BLS and ACLS certification"
            ],
            licensingRequirements: [
                "CRT or RRT credential (national)",
                "State respiratory therapy license",
                "CPR/BLS and ACLS certification",
                "Continuing education for license renewal"
            ]
        ),

        "dental-hygienist": TradeCareerDetailData(
            pathId: "dental-hygienist",
            entryLevelPay: "$28–$38/hr entry-level",
            midCareerPay: "$55K–$85K+ experienced",
            selfEmploymentUpside: "Dental hygienists in some states can practice independently. Temp/travel hygienists earn premium hourly rates ($40–$60/hr).",
            timeToEntry: "2–3 years",
            timeToEntryDetail: "Associate degree from an accredited dental hygiene program. Competitive admission — prerequisite courses required.",
            aiResistantReasons: [
                "Teeth cleaning and oral assessment require direct physical skill",
                "Patient interaction and comfort management are essential",
                "X-ray positioning and periodontal probing need human hands",
                "Licensed profession with state-regulated scope of practice",
                "Dental visits are non-negotiable for most people"
            ],
            firstJobStrategies: [
                "Complete prerequisite courses (biology, chemistry, anatomy)",
                "Apply to an accredited dental hygiene program",
                "Pass the National Board and state clinical exam",
                "Build relationships during clinical rotations for job leads",
                "Apply to general and specialty dental practices"
            ],
            futureBusinessOption: "In some states, dental hygienists can open independent practices or mobile hygiene services. Education, public health, and dental sales are also advancement paths.",
            tuitionCostRange: "$10K–$30K for associate degree",
            toolsAndExamRequirements: [
                "National Board Dental Hygiene Examination",
                "State clinical licensing exam",
                "Scalers, curettes, and hygiene instruments",
                "Loupes and protective eyewear",
                "CPR/BLS certification"
            ],
            licensingRequirements: [
                "State dental hygiene license (required)",
                "National Board Dental Hygiene Examination",
                "CPR/BLS certification",
                "Continuing education for license renewal"
            ]
        ),

        "vet-tech": TradeCareerDetailData(
            pathId: "vet-tech",
            entryLevelPay: "$14–$18/hr entry-level",
            midCareerPay: "$30K–$45K+ experienced",
            selfEmploymentUpside: "Specialized vet techs (emergency, dental, exotic) earn premium rates. Some do mobile vet tech services.",
            timeToEntry: "2 years",
            timeToEntryDetail: "Associate degree from an AVMA-accredited program with clinical rotations at veterinary facilities.",
            aiResistantReasons: [
                "Animal care requires physical hands-on skills",
                "Restraining, drawing blood, and assisting surgery need a trained human",
                "Every animal patient is different with unique needs",
                "Pet owners expect compassionate human caregivers",
                "Pet ownership is at all-time highs driving demand"
            ],
            firstJobStrategies: [
                "Enroll in an AVMA-accredited vet tech program",
                "Complete clinical rotations at vet clinics and hospitals",
                "Pass the VTNE certification exam",
                "Apply to veterinary clinics, emergency hospitals, and specialty practices",
                "Consider specializing in emergency, dental, or exotic animal care"
            ],
            futureBusinessOption: "Vet techs can advance into specialty areas, veterinary management, or mobile vet tech services. Some transition to veterinary pharmaceutical sales.",
            tuitionCostRange: "$8K–$20K for associate degree",
            toolsAndExamRequirements: [
                "VTNE (Veterinary Technician National Exam)",
                "State credentialing (varies)",
                "Stethoscope and diagnostic tools",
                "Scrubs and protective equipment"
            ],
            licensingRequirements: [
                "VTNE certification (national)",
                "State veterinary technician credential",
                "CPR certification recommended",
                "Continuing education for renewal"
            ]
        ),

        "cybersecurity": TradeCareerDetailData(
            pathId: "cybersecurity",
            entryLevelPay: "$50K–$65K entry-level SOC analyst",
            midCareerPay: "$60K–$120K+ experienced",
            selfEmploymentUpside: "Cybersecurity consultants can earn $100K–$200K+ independently. Bug bounty hunters and pentesters have uncapped earning potential.",
            timeToEntry: "6–18 months",
            timeToEntryDetail: "Self-study with certifications can get you entry-level roles in 6–12 months. Bootcamps accelerate the process.",
            aiResistantReasons: [
                "Cyber threats evolve constantly — human analysts adapt to novel attacks",
                "Incident response requires real-time human judgment and communication",
                "Security policy and compliance need business context only humans understand",
                "Penetration testing requires creative human thinking",
                "Massive skills gap means demand far exceeds supply",
                "Government and defense roles require human security clearances"
            ],
            firstJobStrategies: [
                "Earn CompTIA Security+ certification as a baseline",
                "Build a home lab and practice on TryHackMe or HackTheBox",
                "Apply for SOC Analyst or junior security roles",
                "Network through cybersecurity meetups and conferences",
                "Consider government/DoD roles which hire entry-level with Security+"
            ],
            futureBusinessOption: "Cybersecurity consulting, penetration testing, and virtual CISO services are lucrative independent business paths for experienced professionals.",
            tuitionCostRange: "$500–$5K for certifications; bootcamps $5K–$15K",
            toolsAndExamRequirements: [
                "CompTIA Security+ certification",
                "CySA+ or CISSP for advancement",
                "Home lab with virtual machines",
                "Security tools (Wireshark, Nmap, Burp Suite)"
            ],
            licensingRequirements: [
                "CompTIA Security+ (industry baseline)",
                "CySA+ for analyst roles",
                "CISSP for senior/management roles",
                "Continuing education for certification renewal"
            ]
        ),

        "it-support": TradeCareerDetailData(
            pathId: "it-support",
            entryLevelPay: "$16–$22/hr entry-level",
            midCareerPay: "$40K–$65K+ experienced",
            selfEmploymentUpside: "Independent IT support businesses can earn $60K–$100K+ serving small businesses",
            timeToEntry: "3–6 months",
            timeToEntryDetail: "Google IT Support Certificate or CompTIA A+ can be completed in 3–6 months with self-study.",
            aiResistantReasons: [
                "Hardware troubleshooting requires physical presence",
                "User training and support need human patience and communication",
                "Network issues in physical offices need on-site diagnosis",
                "Every IT environment is different",
                "Small businesses need trusted local IT support"
            ],
            firstJobStrategies: [
                "Complete Google IT Support Certificate or equivalent",
                "Pass CompTIA A+ certification",
                "Apply for help desk or IT support roles",
                "Offer local IT support to small businesses",
                "Build toward Network+ or Security+ for advancement"
            ],
            futureBusinessOption: "Independent IT support and managed services for small businesses is a profitable business path with recurring revenue from maintenance contracts.",
            tuitionCostRange: "$300–$3K",
            toolsAndExamRequirements: [
                "CompTIA A+ certification",
                "Google IT Support Certificate (alternative entry)",
                "Basic toolkit for hardware work",
                "USB drives and diagnostic software"
            ],
            licensingRequirements: [
                "CompTIA A+ (industry entry standard)",
                "No state licensing required",
                "Network+ or Security+ for advancement"
            ]
        ),

        "web-developer": TradeCareerDetailData(
            pathId: "web-developer",
            entryLevelPay: "$40K–$55K entry-level",
            midCareerPay: "$50K–$110K+ experienced",
            selfEmploymentUpside: "Freelance web developers can earn $60K–$150K+ with a strong client base",
            timeToEntry: "3–12 months",
            timeToEntryDetail: "Self-study with free resources, bootcamps, or structured courses. Portfolio projects demonstrate skill to employers.",
            aiResistantReasons: [
                "Client communication and understanding business needs require human skills",
                "Custom solutions for unique business problems need creative thinking",
                "Debugging and maintaining complex systems requires human judgment",
                "AI tools augment but don't replace developers for complex work",
                "Strong demand continues despite AI-assisted coding tools"
            ],
            firstJobStrategies: [
                "Build 3–5 strong portfolio projects",
                "Complete a bootcamp or structured self-study path",
                "Create a professional portfolio website",
                "Apply for junior developer positions",
                "Freelance on platforms like Upwork to build experience"
            ],
            futureBusinessOption: "Web development agencies, SaaS products, and freelance development are all viable independent business paths.",
            tuitionCostRange: "$0–$15K (free resources to bootcamp)",
            toolsAndExamRequirements: [
                "No formal certification required",
                "Portfolio of completed projects",
                "Knowledge of HTML, CSS, JavaScript, and a framework",
                "Git and version control proficiency"
            ],
            licensingRequirements: [
                "No licensing required",
                "Portfolio and demonstrated skill are the standard"
            ]
        ),

        "data-analyst": TradeCareerDetailData(
            pathId: "data-analyst",
            entryLevelPay: "$40K–$55K entry-level",
            midCareerPay: "$50K–$85K+ experienced",
            selfEmploymentUpside: "Freelance data analysts and consultants can earn $70K–$120K+",
            timeToEntry: "3–9 months",
            timeToEntryDetail: "Google Data Analytics Certificate or equivalent structured learning with practice projects on real datasets.",
            aiResistantReasons: [
                "Data interpretation requires human context and business understanding",
                "Communicating insights to stakeholders is a human skill",
                "Data quality assessment needs judgment beyond pattern matching",
                "Every business has unique data challenges",
                "Demand growing across all industries"
            ],
            firstJobStrategies: [
                "Complete Google Data Analytics Certificate",
                "Learn SQL and practice with real datasets on Kaggle",
                "Build a portfolio of analysis projects",
                "Apply for junior analyst positions",
                "Network through data science communities"
            ],
            futureBusinessOption: "Data consulting, analytics-as-a-service, and BI dashboard development are viable freelance and business paths.",
            tuitionCostRange: "$0–$10K",
            toolsAndExamRequirements: [
                "SQL proficiency",
                "Excel and spreadsheet expertise",
                "Tableau or Power BI visualization skills",
                "Python or R for statistical analysis",
                "Portfolio of analysis projects"
            ],
            licensingRequirements: [
                "No licensing required",
                "Google or IBM certificates add credibility",
                "Portfolio is the primary credential"
            ]
        ),

        "cloud-computing": TradeCareerDetailData(
            pathId: "cloud-computing",
            entryLevelPay: "$55K–$75K entry-level",
            midCareerPay: "$70K–$130K+ experienced",
            selfEmploymentUpside: "Cloud consultants and architects can earn $120K–$200K+ independently",
            timeToEntry: "3–9 months",
            timeToEntryDetail: "Start with AWS Cloud Practitioner or Azure Fundamentals, then advance to associate-level certifications.",
            aiResistantReasons: [
                "Cloud architecture requires understanding unique business requirements",
                "Security and compliance decisions need human judgment",
                "Migration planning involves complex stakeholder communication",
                "Infrastructure troubleshooting needs contextual problem-solving",
                "Nearly every company is migrating to the cloud"
            ],
            firstJobStrategies: [
                "Earn AWS Cloud Practitioner or Azure Fundamentals certification",
                "Build hands-on projects using free-tier cloud accounts",
                "Pursue Solutions Architect Associate certification",
                "Apply for cloud support or junior cloud engineer roles",
                "Join cloud communities and attend meetups"
            ],
            futureBusinessOption: "Cloud consulting, managed cloud services, and cloud migration advisory are highly profitable independent business paths.",
            tuitionCostRange: "$300–$5K",
            toolsAndExamRequirements: [
                "AWS Cloud Practitioner or Azure Fundamentals",
                "Solutions Architect Associate (advanced)",
                "Free-tier cloud accounts for practice",
                "Infrastructure-as-code tools (Terraform, CloudFormation)"
            ],
            licensingRequirements: [
                "No state licensing required",
                "Cloud certifications are the industry standard",
                "Continuing education to maintain certifications"
            ]
        ),

        "network-admin": TradeCareerDetailData(
            pathId: "network-admin",
            entryLevelPay: "$40K–$55K entry-level",
            midCareerPay: "$50K–$85K+ experienced",
            selfEmploymentUpside: "Independent network consultants serving SMBs can earn $80K–$120K+",
            timeToEntry: "3–9 months",
            timeToEntryDetail: "CompTIA Network+ is the entry point. CCNA adds Cisco-specific expertise for enterprise environments.",
            aiResistantReasons: [
                "Physical network equipment requires on-site installation and maintenance",
                "Network troubleshooting in complex environments needs human diagnosis",
                "Security incidents require real-time human response",
                "Every organization has unique network architecture",
                "IoT and 5G expansion increase networking complexity"
            ],
            firstJobStrategies: [
                "Earn CompTIA Network+ certification",
                "Build a home lab with routers and switches",
                "Apply for help desk or junior network roles",
                "Pursue CCNA for Cisco enterprise environments",
                "Offer small business network setup services"
            ],
            futureBusinessOption: "Managed network services, IT consulting, and network security services are strong independent business paths.",
            tuitionCostRange: "$500–$5K",
            toolsAndExamRequirements: [
                "CompTIA Network+ certification",
                "CCNA (Cisco) for enterprise roles",
                "Network testing tools and cable testers",
                "Home lab equipment for practice"
            ],
            licensingRequirements: [
                "No state licensing required",
                "Industry certifications are the standard",
                "Continuing education for certification renewal"
            ]
        ),

        "real-estate": TradeCareerDetailData(
            pathId: "real-estate",
            entryLevelPay: "$30K–$45K first year (commission-based)",
            midCareerPay: "$40K–$100K+ established agent",
            selfEmploymentUpside: "Top agents and team leaders can earn $150K–$300K+. Brokers earn overrides on agent production.",
            timeToEntry: "2–6 months",
            timeToEntryDetail: "Complete pre-licensing education (varies by state), pass the exam, and join a brokerage. Income is commission-based from the start.",
            aiResistantReasons: [
                "Home buying is the biggest financial decision — clients need trusted human guidance",
                "Property showings, negotiations, and closings require in-person presence",
                "Every transaction involves unique human relationships and emotions",
                "Local market knowledge and networking are deeply personal skills",
                "Licensing creates a regulatory barrier"
            ],
            firstJobStrategies: [
                "Complete your state's pre-licensing course",
                "Pass the real estate licensing exam",
                "Join a brokerage that offers mentorship and training",
                "Build your sphere of influence and online presence",
                "Focus on a niche (first-time buyers, investors, luxury)"
            ],
            futureBusinessOption: "Real estate naturally lends itself to independent business — building a team, becoming a broker, or investing in property.",
            tuitionCostRange: "$1K–$3K for pre-licensing course and exam",
            toolsAndExamRequirements: [
                "State pre-licensing course completion",
                "Real estate licensing exam",
                "CRM and lead management software",
                "Professional photography for listings",
                "Reliable vehicle for showings"
            ],
            licensingRequirements: [
                "State real estate license (required)",
                "Must work under a licensed broker",
                "Continuing education for license renewal",
                "E&O insurance recommended"
            ]
        ),

        "insurance-agent": TradeCareerDetailData(
            pathId: "insurance-agent",
            entryLevelPay: "$35K–$45K first year",
            midCareerPay: "$40K–$90K+ established",
            selfEmploymentUpside: "Independent agents with residual commissions can earn $100K–$200K+ as their book of business grows",
            timeToEntry: "1–3 months",
            timeToEntryDetail: "State pre-licensing course and exam can be completed in weeks. Many agencies provide training and leads.",
            aiResistantReasons: [
                "Insurance decisions involve complex personal circumstances",
                "Clients need trusted human advisors for major coverage decisions",
                "Claims advocacy and policy reviews require human judgment",
                "Relationship-based selling rewards personal connection",
                "State licensing creates a regulatory barrier"
            ],
            firstJobStrategies: [
                "Complete your state's insurance pre-licensing course",
                "Pass the state insurance licensing exam",
                "Join an agency or carrier for training and mentorship",
                "Build your network through referrals and community involvement",
                "Consider specializing in a niche (life, commercial, Medicare)"
            ],
            futureBusinessOption: "Independent insurance agencies are a proven business model with residual commission income that grows over time.",
            tuitionCostRange: "$300–$1K for pre-licensing and exam",
            toolsAndExamRequirements: [
                "State insurance licensing exam",
                "CRM and client management software",
                "Quoting and comparison tools",
                "E&O insurance"
            ],
            licensingRequirements: [
                "State insurance license (required per line of authority)",
                "Continuing education for license renewal",
                "E&O insurance required or recommended",
                "Background check"
            ]
        ),

        "mobile-barber": TradeCareerDetailData(
            pathId: "mobile-barber",
            entryLevelPay: "$15–$25/hr starting out",
            midCareerPay: "$35K–$55K+ experienced",
            selfEmploymentUpside: "Mobile barbers with premium clientele and strong booking can earn $60K–$90K+",
            timeToEntry: "6–12 months",
            timeToEntryDetail: "Barber school or cosmetology program with barber specialty. State licensing exam required.",
            aiResistantReasons: [
                "Haircuts require precise physical skill and artistic judgment",
                "Every client's hair, face, and preferences are unique",
                "Trust-based personal service — clients become loyal regulars",
                "Mobile convenience commands premium pricing",
                "State licensing limits who can legally cut hair"
            ],
            firstJobStrategies: [
                "Complete barber school or cosmetology program",
                "Pass your state barber licensing exam",
                "Build a client base at a barbershop first",
                "Invest in mobile equipment and a vehicle setup",
                "Market to busy professionals and elderly clients"
            ],
            futureBusinessOption: "Mobile barber businesses can scale to barbershop ownership, franchising, or training programs.",
            tuitionCostRange: "$5K–$15K for barber school",
            toolsAndExamRequirements: [
                "State barber licensing exam",
                "Professional clippers, trimmers, and shears",
                "Mobile barber station and chair",
                "Sanitization supplies and PPE",
                "Reliable vehicle"
            ],
            licensingRequirements: [
                "State barber license (required)",
                "Completion of barber school hours (varies by state)",
                "Health and sanitation compliance",
                "Continuing education in some states"
            ]
        ),

        "cosmetology": TradeCareerDetailData(
            pathId: "cosmetology",
            entryLevelPay: "$12–$18/hr starting out",
            midCareerPay: "$30K–$50K+ experienced",
            selfEmploymentUpside: "Independent cosmetologists with premium clientele can earn $50K–$80K+. Salon owners can earn much more.",
            timeToEntry: "9–18 months",
            timeToEntryDetail: "State-approved cosmetology school programs vary from 9–18 months depending on the state's hour requirements.",
            aiResistantReasons: [
                "Hair, skin, and beauty services require hands-on artistic skill",
                "Every client has unique features, preferences, and styles",
                "Personal trust and comfort are essential to the service",
                "State licensing creates a regulated profession",
                "Beauty services are recession-resistant — people always invest in self-care"
            ],
            firstJobStrategies: [
                "Complete a state-approved cosmetology program",
                "Pass the state cosmetology licensing exam",
                "Build clientele at a salon or rent a booth",
                "Specialize in a niche (color, extensions, bridal)",
                "Build a social media presence showcasing your work"
            ],
            futureBusinessOption: "Cosmetologists can open their own salon, suite-based business, or mobile beauty service. Education and product lines are additional revenue streams.",
            tuitionCostRange: "$5K–$20K for cosmetology school",
            toolsAndExamRequirements: [
                "State cosmetology licensing exam",
                "Professional shears, color kit, and styling tools",
                "Sanitation and safety supplies",
                "Mannequin heads for exam practice"
            ],
            licensingRequirements: [
                "State cosmetology license (required)",
                "Completion of required school hours",
                "Health and sanitation compliance",
                "Continuing education in some states"
            ]
        ),

        "massage-therapist": TradeCareerDetailData(
            pathId: "massage-therapist",
            entryLevelPay: "$18–$25/hr starting out",
            midCareerPay: "$35K–$65K+ experienced",
            selfEmploymentUpside: "Independent massage therapists charging $80–$150/session can earn $60K–$90K+",
            timeToEntry: "6–12 months",
            timeToEntryDetail: "State-required training hours range from 500–1000+ depending on your state. MBLEx exam required.",
            aiResistantReasons: [
                "Therapeutic touch is the core service — cannot be replicated by machines",
                "Every body is different requiring adaptive technique",
                "Client trust and comfort are essential to the therapeutic relationship",
                "Licensed profession with clear scope of practice",
                "Growing wellness industry drives steady demand"
            ],
            firstJobStrategies: [
                "Enroll in an accredited massage therapy program",
                "Complete your state's required training hours",
                "Pass the MBLEx licensing exam",
                "Build clientele at a spa, clinic, or gym",
                "Market specialties like sports, deep tissue, or medical massage"
            ],
            futureBusinessOption: "Independent massage therapy is a natural business path. Mobile massage, private practice, and corporate wellness programs are all viable.",
            tuitionCostRange: "$5K–$15K for massage school",
            toolsAndExamRequirements: [
                "MBLEx licensing exam",
                "State massage therapy license",
                "Professional massage table and supplies",
                "Oils, linens, and sanitation supplies"
            ],
            licensingRequirements: [
                "State massage therapy license (required in most states)",
                "MBLEx certification",
                "Liability insurance recommended",
                "Continuing education for license renewal"
            ]
        ),

        "childcare": TradeCareerDetailData(
            pathId: "childcare",
            entryLevelPay: "$12–$16/hr entry-level",
            midCareerPay: "$25K–$40K+ experienced",
            selfEmploymentUpside: "Licensed home childcare providers can earn $40K–$70K+ depending on capacity and rates",
            timeToEntry: "1–6 months",
            timeToEntryDetail: "CPR/First Aid certification, background checks, and state childcare licensing requirements. Some states require additional training hours.",
            aiResistantReasons: [
                "Caring for children requires constant human attention and judgment",
                "Safety, emotional support, and developmental interaction need a caregiver",
                "Every child has unique needs and temperaments",
                "Parents entrust their children only to trusted humans",
                "Childcare demand consistently outstrips supply"
            ],
            firstJobStrategies: [
                "Get CPR and First Aid certified",
                "Complete your state's childcare training requirements",
                "Get background checked and fingerprinted",
                "Apply to childcare centers or start home-based care",
                "Research your state's family childcare licensing requirements"
            ],
            futureBusinessOption: "Licensed home childcare is a viable small business. Some providers expand to childcare centers or preschools over time.",
            tuitionCostRange: "$200–$2K for required training and licensing",
            toolsAndExamRequirements: [
                "CPR/First Aid certification",
                "State background check and fingerprinting",
                "State childcare licensing training hours",
                "Child development training",
                "Age-appropriate equipment and supplies"
            ],
            licensingRequirements: [
                "State childcare license (required for most settings)",
                "Background check and fingerprinting",
                "CPR/First Aid certification",
                "Health and safety home inspection (for home-based care)",
                "Continuing education for license renewal"
            ]
        ),

        "home-childcare": TradeCareerDetailData(
            pathId: "home-childcare",
            entryLevelPay: "$12–$16/hr entry-level",
            midCareerPay: "$25K–$40K+ experienced",
            selfEmploymentUpside: "Licensed home childcare can earn $40K–$70K+ depending on state ratios and rates",
            timeToEntry: "1–6 months",
            timeToEntryDetail: "State licensing, training hours, CPR/First Aid, background check, and home safety inspection.",
            aiResistantReasons: [
                "Childcare is entirely human — nurturing, safety, and development",
                "Parents trust only vetted, caring humans with their children",
                "State licensing ensures quality and accountability",
                "Chronic childcare shortage keeps demand high"
            ],
            firstJobStrategies: [
                "Research your state's family childcare licensing requirements",
                "Complete CPR/First Aid and required training hours",
                "Pass background check and home safety inspection",
                "Set up your home to meet licensing standards",
                "Market to local families through community groups"
            ],
            futureBusinessOption: "Home childcare can expand to a larger center, before/after school programs, or preschool operation.",
            tuitionCostRange: "$200–$2K for licensing and training",
            toolsAndExamRequirements: [
                "CPR/First Aid certification",
                "State background check",
                "Child development training hours",
                "Home safety equipment"
            ],
            licensingRequirements: [
                "State family childcare license",
                "Background check and fingerprinting",
                "Home safety inspection",
                "CPR/First Aid certification",
                "Continuing education"
            ]
        ),
    ]
}
