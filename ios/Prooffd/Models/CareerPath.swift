import Foundation

typealias CareerPath = EducationPath

enum CareerPathDatabase {
    static let all: [EducationPath] = EducationPathDatabase.all
}

enum EducationPathDatabase {
    static let all: [EducationPath] = trades + certifications + healthcare + technology + business + creative + military

    static let trades: [EducationPath] = [
        EducationPath(
            id: "electrician", title: "Licensed Electrician", icon: "bolt.fill",
            category: .trade, aiSafeScore: 95,
            overview: "Electricians install, maintain, and repair electrical systems in homes, businesses, and industrial settings. High demand, strong pay, and a clear apprenticeship pathway.",
            whyItWorksNow: "Massive worker shortage in electrical trades. Renewable energy and EV charging installations are creating unprecedented demand.",
            futureDemand: "Very strong — electrification trends and aging workforce guarantee growing demand for decades.",
            typicalSalaryRange: "$55K – $100K+",
            prerequisites: ["High school diploma or GED", "Basic math skills", "Physical fitness"],
            testRequirements: ["Journeyman electrician exam", "State licensing exam"],
            deliveryType: "Apprenticeship + classroom",
            timeToComplete: "4–5 years (apprenticeship)",
            costRange: "$2K – $5K",
            fundingOptions: ["Union apprenticeships (paid training)", "Pell Grants for trade school", "State workforce development programs"],
            howToFindPrograms: ["Contact your local IBEW union", "Search community college electrical programs", "Check state apprenticeship registries"],
            employerSponsoredOptions: ["Many electrical contractors sponsor apprentices", "Union programs provide paid training"],
            militaryPath: "Military electrical training transfers well. Many veterans qualify for advanced placement in apprenticeship programs.",
            basicSteps: [
                "Complete a pre-apprenticeship program or trade school",
                "Apply for an electrical apprenticeship (4–5 years)",
                "Log required supervised hours",
                "Pass the journeyman electrician exam",
                "Obtain your state license",
                "Build clientele or join a firm"
            ],
            linkedJobIds: ["handyman", "appliance-repair"]
        ),
        EducationPath(
            id: "plumber", title: "Licensed Plumber", icon: "wrench.and.screwdriver.fill",
            category: .trade, aiSafeScore: 95,
            overview: "Plumbers install and repair water, gas, and drainage systems. Essential service with consistent demand regardless of economic conditions.",
            whyItWorksNow: "Critical infrastructure needs and aging plumbing systems create constant demand. Severe shortage of licensed plumbers nationwide.",
            typicalSalaryRange: "$50K – $90K+",
            testRequirements: ["Journeyman plumber exam", "State licensing exam"],
            timeToComplete: "4–5 years",
            costRange: "$2K – $4K",
            fundingOptions: ["Union apprenticeships", "Community college financial aid", "Veterans benefits for trade training"],
            militaryPath: "Military plumbing and pipefitting experience provides excellent foundation.",
            basicSteps: [
                "Enroll in a plumbing trade program",
                "Secure a plumbing apprenticeship",
                "Complete 4–5 years of supervised work",
                "Pass the journeyman plumber exam",
                "Get licensed in your state",
                "Start taking independent jobs or open a business"
            ],
            linkedJobIds: ["handyman", "sprinkler-irrigation"]
        ),
        EducationPath(
            id: "hvac", title: "HVAC Technician", icon: "thermometer.snowflake",
            category: .trade, aiSafeScore: 92,
            overview: "HVAC technicians install and service heating, ventilation, and air conditioning systems. Growing demand driven by climate needs and new construction.",
            whyItWorksNow: "Climate change is driving record HVAC demand. Energy efficiency regulations require skilled technicians for new systems.",
            typicalSalaryRange: "$45K – $85K+",
            testRequirements: ["EPA 608 certification", "NATE certification (optional)"],
            timeToComplete: "6 months – 2 years",
            costRange: "$1K – $3K",
            fundingOptions: ["Trade school financial aid", "Employer-sponsored training", "State energy workforce grants"],
            basicSteps: [
                "Complete HVAC certification program (6–24 months)",
                "Get EPA 608 certification for refrigerant handling",
                "Apply for entry-level HVAC positions",
                "Gain field experience with a licensed company",
                "Pursue additional certifications (NATE)",
                "Consider starting your own HVAC business"
            ],
            linkedJobIds: ["appliance-repair"]
        ),
        EducationPath(
            id: "welder", title: "Certified Welder", icon: "flame.fill",
            category: .trade, aiSafeScore: 90,
            overview: "Welders join metal parts using high-heat tools. Opportunities span construction, manufacturing, automotive, and specialized industries like underwater welding.",
            typicalSalaryRange: "$40K – $80K+",
            testRequirements: ["AWS certification"],
            timeToComplete: "6 months – 2 years",
            costRange: "$500 – $2K",
            fundingOptions: ["Community college tuition assistance", "Workforce Innovation grants", "Employer training programs"],
            basicSteps: [
                "Enroll in a welding program or community college",
                "Learn MIG, TIG, and Stick welding techniques",
                "Get AWS (American Welding Society) certification",
                "Build a portfolio of welding projects",
                "Apply for welding positions or contract work",
                "Specialize in high-paying niches (pipeline, underwater)"
            ],
            linkedJobIds: ["welding"]
        ),
        EducationPath(
            id: "solar_installer", title: "Solar Panel Installer", icon: "sun.max.fill",
            category: .trade, aiSafeScore: 88,
            overview: "Solar installers mount photovoltaic systems on rooftops and ground mounts. Fast-growing field driven by clean energy demand and government incentives.",
            typicalSalaryRange: "$40K – $70K+",
            testRequirements: ["OSHA safety certification", "NABCEP certification (advanced)"],
            timeToComplete: "3–12 months",
            costRange: "$500 – $2K",
            fundingOptions: ["Clean energy workforce grants", "Trade school financial aid", "On-the-job training programs"],
            basicSteps: [
                "Complete a solar installation training program",
                "Get OSHA safety certification",
                "Apply for entry-level installer positions",
                "Gain rooftop and ground-mount experience",
                "Pursue NABCEP certification for advancement",
                "Consider starting a solar installation company"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "carpenter", title: "Carpenter", icon: "hammer.fill",
            category: .trade, aiSafeScore: 93,
            overview: "Carpenters build, install, and repair structures and fixtures made of wood and other materials. Essential in construction, remodeling, and custom woodworking.",
            whyItWorksNow: "Housing demand and renovation boom keep carpenters in high demand. Skilled carpenters are increasingly hard to find.",
            typicalSalaryRange: "$40K – $75K+",
            testRequirements: ["Apprenticeship completion", "OSHA safety card"],
            timeToComplete: "3–4 years (apprenticeship)",
            costRange: "$1K – $3K",
            fundingOptions: ["Union apprenticeships (paid training)", "Trade school financial aid", "Habitat for Humanity training"],
            basicSteps: [
                "Enroll in a carpentry pre-apprenticeship or trade school",
                "Apply for a carpentry apprenticeship",
                "Complete 3–4 years of on-the-job training",
                "Get OSHA safety certified",
                "Specialize in framing, finish, or cabinet work",
                "Start taking independent projects or open a shop"
            ],
            linkedJobIds: ["handyman", "furniture-restoration"]
        ),
        EducationPath(
            id: "auto_mechanic", title: "Auto Mechanic / Technician", icon: "car.fill",
            category: .trade, aiSafeScore: 88,
            overview: "Auto mechanics diagnose, repair, and maintain vehicles. Consistent demand as long as people drive cars, with growing EV specialization opportunities.",
            whyItWorksNow: "Average vehicle age is at record highs, driving repair demand. EV transition creates need for new specializations.",
            typicalSalaryRange: "$35K – $70K+",
            testRequirements: ["ASE certifications"],
            timeToComplete: "6 months – 2 years",
            costRange: "$2K – $10K",
            fundingOptions: ["Trade school financial aid", "Dealership-sponsored training", "Manufacturer training programs"],
            basicSteps: [
                "Complete an automotive technology program",
                "Earn ASE certifications in key areas",
                "Gain hands-on experience at a shop or dealership",
                "Specialize in a brand or system (brakes, transmission, EV)",
                "Build a reputation for quality work",
                "Consider opening your own repair shop"
            ],
            linkedJobIds: ["auto-detailing"]
        ),
        EducationPath(
            id: "diesel_mechanic", title: "Diesel Mechanic", icon: "engine.combustion.fill",
            category: .trade, aiSafeScore: 90,
            overview: "Diesel mechanics service and repair diesel engines in trucks, buses, construction equipment, and generators. Higher pay than standard auto mechanics.",
            whyItWorksNow: "Freight industry growth and aging equipment fleet create constant demand for skilled diesel technicians.",
            typicalSalaryRange: "$45K – $80K+",
            testRequirements: ["ASE diesel certifications"],
            timeToComplete: "1–2 years",
            costRange: "$3K – $10K",
            fundingOptions: ["Trade school financial aid", "Fleet company training programs", "Veterans benefits"],
            basicSteps: [
                "Enroll in a diesel technology program",
                "Complete hands-on shop training",
                "Earn ASE diesel mechanic certifications",
                "Get hired at a fleet company, dealership, or shop",
                "Specialize in heavy equipment or marine diesel",
                "Consider mobile diesel repair service"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "cnc_machinist", title: "CNC Machinist", icon: "gearshape.2.fill",
            category: .trade, aiSafeScore: 82,
            overview: "CNC machinists program and operate computer-controlled machines to create precision metal parts. Combines technical skill with manufacturing expertise.",
            whyItWorksNow: "Reshoring of manufacturing and defense industry growth are driving strong demand for precision machinists.",
            typicalSalaryRange: "$40K – $70K+",
            testRequirements: ["NIMS certification (optional)"],
            timeToComplete: "6 months – 2 years",
            costRange: "$2K – $8K",
            fundingOptions: ["Community college programs", "Manufacturer apprenticeships", "WIOA training grants"],
            basicSteps: [
                "Enroll in a CNC machining program",
                "Learn G-code programming and CAD/CAM software",
                "Practice on manual and CNC machines",
                "Earn NIMS certifications for credibility",
                "Apply to manufacturing or aerospace companies",
                "Advance to CNC programmer or shop supervisor"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "heavy_equipment_operator", title: "Heavy Equipment Operator", icon: "arrow.up.and.down.and.arrow.left.and.right",
            category: .trade, aiSafeScore: 85,
            overview: "Heavy equipment operators run bulldozers, excavators, cranes, and other large machinery for construction, mining, and infrastructure projects.",
            whyItWorksNow: "Infrastructure spending bills and construction growth are creating record demand for skilled operators.",
            typicalSalaryRange: "$45K – $80K+",
            testRequirements: ["OSHA safety certification", "Equipment-specific licenses"],
            timeToComplete: "3–6 months",
            costRange: "$3K – $10K",
            fundingOptions: ["Union training programs", "Equipment dealer training", "WIOA and state workforce grants"],
            basicSteps: [
                "Enroll in a heavy equipment operator training program",
                "Get OSHA safety certified",
                "Practice on multiple equipment types",
                "Obtain required licenses for your state",
                "Apply with construction or mining companies",
                "Specialize in crane operation for higher pay"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "elevator_installer", title: "Elevator Installer & Repairer", icon: "arrow.up.arrow.down",
            category: .trade, aiSafeScore: 95,
            overview: "Elevator installers and repairers assemble, install, maintain, and repair elevators, escalators, and similar equipment. One of the highest-paying trades.",
            whyItWorksNow: "Aging building infrastructure and new high-rise construction create steady demand. Very few trained technicians available.",
            typicalSalaryRange: "$70K – $100K+",
            testRequirements: ["State elevator mechanic license"],
            timeToComplete: "4 years (apprenticeship)",
            costRange: "$1K – $3K",
            fundingOptions: ["IUEC union apprenticeship (paid training)", "Elevator company sponsorship"],
            basicSteps: [
                "Apply to IUEC (elevator union) apprenticeship",
                "Complete 4-year apprenticeship program",
                "Study electrical, mechanical, and hydraulic systems",
                "Pass the state licensing exam",
                "Work as a journeyman for an elevator company",
                "Specialize in modernization or maintenance"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "locksmith", title: "Locksmith", icon: "key.fill",
            category: .trade, aiSafeScore: 88,
            overview: "Locksmiths install, repair, and open locks for homes, businesses, and vehicles. Low startup cost with strong earning potential as an independent operator.",
            typicalSalaryRange: "$35K – $65K+",
            testRequirements: ["State locksmith license (varies)"],
            timeToComplete: "3–6 months",
            costRange: "$1K – $5K",
            fundingOptions: ["Online locksmith courses", "Apprenticeship with established locksmith", "Self-funded training"],
            basicSteps: [
                "Complete a locksmith training program",
                "Learn residential, commercial, and automotive locks",
                "Get your state license if required",
                "Invest in basic locksmith tools and a van",
                "Build relationships with property managers and real estate agents",
                "Offer emergency and after-hours services for premium rates"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "ironworker", title: "Ironworker / Structural Welder", icon: "building.2.fill",
            category: .trade, aiSafeScore: 93,
            overview: "Ironworkers install structural steel and iron in buildings, bridges, and infrastructure. Physically demanding work with excellent union pay and benefits.",
            typicalSalaryRange: "$50K – $90K+",
            testRequirements: ["Ironworker apprenticeship completion", "AWS welding certs"],
            timeToComplete: "3–4 years (apprenticeship)",
            costRange: "$1K – $3K",
            fundingOptions: ["Ironworkers union apprenticeship (paid)", "State workforce programs"],
            basicSteps: [
                "Apply to your local Ironworkers union apprenticeship",
                "Complete safety training and OSHA certification",
                "Learn structural steel erection and welding",
                "Complete 3–4 years of on-the-job training",
                "Pass welding certifications for structural work",
                "Advance to foreman or start a steel erection company"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "mason", title: "Bricklayer / Mason", icon: "square.stack.3d.up.fill",
            category: .trade, aiSafeScore: 94,
            overview: "Masons build and repair structures using brick, stone, concrete block, and other masonry materials. Highly skilled trade with artistic and structural applications.",
            typicalSalaryRange: "$40K – $75K+",
            testRequirements: ["Apprenticeship completion"],
            timeToComplete: "3–4 years (apprenticeship)",
            costRange: "$1K – $3K",
            fundingOptions: ["BAC union apprenticeship (paid)", "Trade school programs", "WIOA grants"],
            basicSteps: [
                "Apply to a masonry apprenticeship program",
                "Learn brick, block, and stone laying techniques",
                "Study blueprint reading and layout",
                "Complete 3–4 years of supervised work",
                "Build a portfolio of completed projects",
                "Specialize in restoration, stone, or decorative masonry"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "aircraft_mechanic", title: "Aircraft Mechanic (A&P)", icon: "airplane",
            category: .trade, aiSafeScore: 90,
            overview: "Aircraft mechanics inspect, maintain, and repair airplanes and helicopters. FAA-certified with excellent pay and job security in aviation.",
            whyItWorksNow: "Severe shortage of A&P mechanics as older technicians retire. Airlines and MRO facilities are actively recruiting.",
            typicalSalaryRange: "$55K – $90K+",
            testRequirements: ["FAA Airframe & Powerplant (A&P) certificate"],
            deliveryType: "FAA-approved school",
            timeToComplete: "18–24 months",
            costRange: "$15K – $30K",
            fundingOptions: ["GI Bill for veterans", "FAA-approved school financial aid", "Airline tuition reimbursement"],
            basicSteps: [
                "Enroll in an FAA-approved A&P school",
                "Complete airframe and powerplant coursework",
                "Gain required hands-on maintenance hours",
                "Pass the FAA written, oral, and practical exams",
                "Get hired at an airline, MRO, or charter company",
                "Specialize in avionics, engines, or composites"
            ],
            linkedJobIds: []
        ),
    ]

    static let certifications: [EducationPath] = [
        EducationPath(
            id: "cdl_driver", title: "CDL Truck Driver", icon: "truck.box.fill",
            category: .certification, aiSafeScore: 70,
            overview: "CDL drivers transport goods across local, regional, or national routes. One of the fastest paths to a reliable income with minimal education required.",
            typicalSalaryRange: "$50K – $80K+",
            testRequirements: ["CDL written test", "CDL skills test"],
            timeToComplete: "3–6 weeks",
            costRange: "$3K – $7K",
            fundingOptions: ["Company-sponsored CDL training", "WIOA grants", "Veterans CDL assistance programs"],
            basicSteps: [
                "Enroll in a CDL training program (3–6 weeks)",
                "Pass the CDL written and skills tests",
                "Get your commercial driver's license",
                "Apply with trucking companies",
                "Complete required supervised driving hours",
                "Choose your route type: local, regional, or OTR"
            ],
            linkedJobIds: ["courier-delivery"]
        ),
        EducationPath(
            id: "personal_trainer", title: "Certified Personal Trainer", icon: "figure.strengthtraining.traditional",
            category: .certification, aiSafeScore: 82,
            overview: "Personal trainers design fitness programs and guide clients through exercises. Growing wellness industry with flexible work options.",
            typicalSalaryRange: "$35K – $70K+",
            testRequirements: ["NASM, ACE, or ISSA certification", "CPR/AED certification"],
            deliveryType: "Online or in-person",
            timeToComplete: "2–6 months",
            costRange: "$500 – $2K",
            fundingOptions: ["Certification payment plans", "Gym-sponsored certifications", "Self-funded"],
            basicSteps: [
                "Choose a certification (NASM, ACE, or ISSA)",
                "Study exercise science and program design",
                "Get CPR/AED certified",
                "Pass the certification exam",
                "Start training clients at a gym or independently",
                "Build an online presence for client acquisition"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "lean_six_sigma", title: "Lean Six Sigma", icon: "chart.line.downtrend.xyaxis",
            category: .certification, aiSafeScore: 68,
            overview: "Lean Six Sigma professionals improve business processes by reducing waste and defects. Valued across manufacturing, healthcare, finance, and tech industries.",
            whyItWorksNow: "Companies are focused on efficiency and cost reduction. Six Sigma skills command premium salaries and consulting rates.",
            typicalSalaryRange: "$55K – $110K+",
            testRequirements: ["Lean Six Sigma Green Belt or Black Belt exam"],
            deliveryType: "Online or in-person",
            timeToComplete: "2–6 months",
            costRange: "$500 – $5K",
            fundingOptions: ["Employer-sponsored training", "Online course platforms", "ASQ membership discounts"],
            basicSteps: [
                "Study Lean and Six Sigma fundamentals",
                "Earn your Green Belt certification",
                "Lead a real improvement project at work",
                "Document measurable results",
                "Pursue Black Belt for advanced roles",
                "Consider consulting or training others"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "scrum_master", title: "Certified Scrum Master", icon: "arrow.triangle.2.circlepath",
            category: .certification, aiSafeScore: 60,
            overview: "Scrum Masters facilitate agile teams, remove blockers, and ensure smooth project delivery. High demand in tech and increasingly in other industries.",
            typicalSalaryRange: "$70K – $120K+",
            testRequirements: ["CSM or PSM certification exam"],
            deliveryType: "Online or workshop",
            timeToComplete: "2–4 weeks",
            costRange: "$500 – $2K",
            fundingOptions: ["Employer-sponsored training", "Scrum Alliance workshops", "Self-funded (low cost)"],
            basicSteps: [
                "Learn agile and Scrum fundamentals",
                "Attend a Certified ScrumMaster course",
                "Pass the CSM or PSM certification exam",
                "Practice facilitating Scrum ceremonies",
                "Apply for Scrum Master or agile coach roles",
                "Pursue advanced certifications (SAFe, A-CSM)"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "drone_pilot", title: "Commercial Drone Pilot", icon: "airplane.circle.fill",
            category: .certification, aiSafeScore: 75,
            overview: "Commercial drone pilots operate UAVs for aerial photography, surveying, inspections, agriculture, and real estate. Fast-growing field with low barriers to entry.",
            whyItWorksNow: "Drone applications are expanding rapidly in construction, agriculture, insurance, and media. FAA Part 107 makes entry straightforward.",
            typicalSalaryRange: "$40K – $80K+",
            testRequirements: ["FAA Part 107 Remote Pilot Certificate"],
            deliveryType: "Online + flight practice",
            timeToComplete: "2–4 weeks",
            costRange: "$300 – $2K",
            fundingOptions: ["Self-funded (low cost)", "Company-sponsored certification", "Veteran benefits"],
            basicSteps: [
                "Study FAA Part 107 regulations and airspace",
                "Pass the FAA Remote Pilot knowledge test",
                "Invest in a commercial-grade drone",
                "Practice flight skills and camera techniques",
                "Build a portfolio of aerial work",
                "Market to real estate, construction, or agriculture clients"
            ],
            linkedJobIds: ["drone-photography"]
        ),
        EducationPath(
            id: "home_inspector", title: "Home Inspector", icon: "house.and.flag.fill",
            category: .certification, aiSafeScore: 82,
            overview: "Home inspectors evaluate the condition of residential properties before sales. Independent work with flexible scheduling and strong earning potential.",
            typicalSalaryRange: "$45K – $80K+",
            testRequirements: ["State home inspection license", "National Home Inspector Exam (in some states)"],
            deliveryType: "Online + field training",
            timeToComplete: "2–4 months",
            costRange: "$2K – $5K",
            fundingOptions: ["Online training programs", "InterNACHI membership", "Self-funded"],
            basicSteps: [
                "Complete a state-approved home inspection course",
                "Learn building systems (electrical, plumbing, HVAC, structural)",
                "Perform supervised practice inspections",
                "Pass the state licensing or certification exam",
                "Build relationships with real estate agents",
                "Invest in inspection tools and report software"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "notary_signing_agent", title: "Notary / Loan Signing Agent", icon: "signature",
            category: .certification, aiSafeScore: 72,
            overview: "Notary signing agents guide borrowers through mortgage document signings. Flexible, part-time friendly work with per-signing fees of $75–$200+.",
            typicalSalaryRange: "$30K – $75K+",
            testRequirements: ["State notary commission", "NNA certification (recommended)"],
            deliveryType: "Online",
            timeToComplete: "2–4 weeks",
            costRange: "$200 – $1K",
            fundingOptions: ["Self-funded (very low cost)", "NNA training bundles"],
            basicSteps: [
                "Apply for your state notary commission",
                "Complete loan signing agent training (NNA)",
                "Get background checked and E&O insured",
                "Pass the NNA certification exam",
                "Sign up with signing services and title companies",
                "Build a reputation for accuracy and professionalism"
            ],
            linkedJobIds: ["notary"]
        ),
        EducationPath(
            id: "osha_safety", title: "OSHA Safety Specialist", icon: "exclamationmark.triangle.fill",
            category: .certification, aiSafeScore: 78,
            overview: "Safety specialists ensure workplaces comply with OSHA regulations. Essential role in construction, manufacturing, and energy with growing demand.",
            typicalSalaryRange: "$50K – $85K+",
            testRequirements: ["OSHA 30-Hour certification", "ASP or CSP (advanced)"],
            deliveryType: "Online or in-person",
            timeToComplete: "1–6 months",
            costRange: "$500 – $3K",
            fundingOptions: ["Employer-sponsored training", "OSHA Education Center courses", "Online training platforms"],
            basicSteps: [
                "Complete OSHA 30-Hour General Industry or Construction course",
                "Study workplace safety regulations and standards",
                "Gain safety coordination experience at a worksite",
                "Pursue ASP (Associate Safety Professional) certification",
                "Apply for safety coordinator or specialist roles",
                "Advance to CSP for management positions"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "real_estate_appraiser", title: "Real Estate Appraiser", icon: "building.columns.fill",
            category: .certification, aiSafeScore: 70,
            overview: "Real estate appraisers determine property values for mortgages, sales, and taxes. Independent work with good income and flexible scheduling.",
            typicalSalaryRange: "$45K – $80K+",
            testRequirements: ["State appraiser license", "Appraisal Institute exams"],
            deliveryType: "Online + supervised hours",
            timeToComplete: "6–12 months",
            costRange: "$2K – $5K",
            fundingOptions: ["Appraisal Institute courses", "Self-funded", "Employer mentorship programs"],
            basicSteps: [
                "Complete required appraisal education courses",
                "Find a supervising appraiser for apprenticeship hours",
                "Log 1,000+ hours of supervised appraisal work",
                "Pass the state licensing exam",
                "Build relationships with lenders and attorneys",
                "Pursue certified residential or general appraiser license"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "comptia_aplus", title: "CompTIA A+", icon: "desktopcomputer",
            category: .certification, aiSafeScore: 65,
            overview: "The standard entry-level certification for IT Help Desk and Support roles. Validates foundational IT skills including hardware, software, networking, and troubleshooting.",
            whyItWorksNow: "Every organization needs IT support. CompTIA A+ is the most recognized entry-level IT certification worldwide.",
            typicalSalaryRange: "$40K – $65K+",
            testRequirements: ["CompTIA A+ Core 1 (220-1101)", "CompTIA A+ Core 2 (220-1102)"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "2–4 months",
            costRange: "$500 – $2K",
            fundingOptions: ["Google IT Support Certificate (free prep)", "Employer-paid certifications", "CompTIA voucher discounts", "Veterans benefits"],
            basicSteps: [
                "Study hardware, networking, and OS fundamentals",
                "Complete practice labs and hands-on exercises",
                "Pass the Core 1 exam (hardware and networking)",
                "Pass the Core 2 exam (software and security)",
                "Apply for help desk or IT support positions",
                "Pursue Network+ or Security+ for advancement"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "comptia_security_plus", title: "CompTIA Security+", icon: "lock.shield.fill",
            category: .certification, aiSafeScore: 75,
            overview: "Essential certification for entry-level cybersecurity roles. Covers network security, threat management, cryptography, and identity management. Required by many government and DoD positions.",
            whyItWorksNow: "Cybersecurity job openings far exceed qualified candidates. Security+ is often the minimum requirement for government security roles.",
            typicalSalaryRange: "$55K – $95K+",
            testRequirements: ["CompTIA Security+ SY0-701 exam"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "2–4 months",
            costRange: "$400 – $2K",
            fundingOptions: ["Employer-sponsored training", "DoD workforce programs", "CompTIA voucher discounts", "Veterans benefits"],
            basicSteps: [
                "Complete CompTIA A+ or have equivalent IT experience",
                "Study security fundamentals, threats, and cryptography",
                "Practice with labs and simulations",
                "Pass the Security+ SY0-701 exam",
                "Apply for SOC analyst or security roles",
                "Pursue CySA+ or CISSP for advancement"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "aws_cloud_practitioner", title: "AWS Certified Cloud Practitioner", icon: "cloud.fill",
            category: .certification, aiSafeScore: 62,
            overview: "Introduction to cloud computing with Amazon Web Services. Validates understanding of AWS Cloud concepts, services, security, architecture, and pricing. Great entry point for cloud careers.",
            whyItWorksNow: "AWS dominates the cloud market. Cloud Practitioner is the starting certification that opens doors to higher-paying cloud roles.",
            typicalSalaryRange: "$50K – $80K+",
            testRequirements: ["AWS Cloud Practitioner CLF-C02 exam"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "1–3 months",
            costRange: "$100 – $1K",
            fundingOptions: ["AWS free tier for practice", "AWS Skill Builder (free courses)", "Employer-sponsored certification"],
            basicSteps: [
                "Create a free AWS account for hands-on practice",
                "Study cloud concepts and AWS core services",
                "Complete AWS Cloud Practitioner Essentials (free)",
                "Practice with sample exams and labs",
                "Pass the CLF-C02 certification exam",
                "Pursue Solutions Architect Associate for advancement"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "google_it_support", title: "Google IT Support Professional Certificate", icon: "laptopcomputer",
            category: .certification, aiSafeScore: 65,
            overview: "A beginner-friendly path to IT support hosted on Coursera. Developed by Google, it covers troubleshooting, networking, operating systems, security, and system administration. No prior experience needed.",
            whyItWorksNow: "Google certificates are increasingly recognized by employers as equivalent to entry-level experience. Affordable and fully online.",
            typicalSalaryRange: "$38K – $60K+",
            testRequirements: ["Complete all 5 courses on Coursera"],
            deliveryType: "Online",
            timeToComplete: "3–6 months",
            costRange: "$0 – $300 (Coursera subscription)",
            fundingOptions: ["Coursera financial aid (free)", "Google Career Certificate scholarships", "Employer tuition reimbursement"],
            basicSteps: [
                "Enroll in the Google IT Support Certificate on Coursera",
                "Complete courses on troubleshooting, networking, and OS",
                "Finish the security and system administration modules",
                "Complete hands-on labs and assessments",
                "Earn the certificate and add to your resume",
                "Apply for IT help desk and support roles"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "ccna", title: "CCNA (Cisco Certified Network Associate)", icon: "network",
            category: .certification, aiSafeScore: 68,
            overview: "For those wanting to work in networking and hardware. Validates ability to install, configure, and troubleshoot enterprise networks. Highly respected in the networking industry.",
            whyItWorksNow: "Network infrastructure is expanding with IoT, 5G, and cloud computing. CCNA-certified professionals are in steady demand.",
            typicalSalaryRange: "$55K – $90K+",
            testRequirements: ["Cisco CCNA 200-301 exam"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "3–6 months",
            costRange: "$500 – $3K",
            fundingOptions: ["Cisco Networking Academy (discounted)", "Employer-sponsored certification", "Community college programs"],
            basicSteps: [
                "Study networking fundamentals (TCP/IP, subnetting)",
                "Practice with Cisco Packet Tracer (free simulator)",
                "Complete hands-on lab exercises",
                "Pass the CCNA 200-301 exam",
                "Apply for network administrator or engineer roles",
                "Pursue CCNP for senior networking positions"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "cissp", title: "CISSP (Certified Information Systems Security Professional)", icon: "shield.checkered",
            category: .certification, aiSafeScore: 78,
            overview: "An advanced certification for security management. The gold standard for experienced cybersecurity professionals. Covers eight security domains and requires 5 years of experience.",
            whyItWorksNow: "CISSP holders command top salaries as organizations invest heavily in security leadership. Required for many CISO and senior security roles.",
            typicalSalaryRange: "$100K – $170K+",
            testRequirements: ["CISSP CAT exam (3 hours, 100–150 questions)", "5 years professional experience in 2+ security domains"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "3–6 months study (requires 5 years experience)",
            costRange: "$700 – $5K",
            fundingOptions: ["Employer-sponsored training", "ISC2 membership discounts", "DoD workforce development programs"],
            basicSteps: [
                "Gain 5 years of cybersecurity experience",
                "Study all 8 CISSP domains",
                "Complete an official ISC2 training course",
                "Pass the CISSP CAT exam",
                "Get endorsed by an existing CISSP holder",
                "Maintain certification with continuing education"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "pmp", title: "PMP (Project Management Professional)", icon: "list.clipboard.fill",
            category: .certification, aiSafeScore: 62,
            overview: "The top-tier gold standard for project managers. Recognized globally across all industries. Validates ability to lead projects, manage teams, and deliver results.",
            whyItWorksNow: "PMP holders earn 20–25% more than non-certified peers. Every industry needs project managers, making this one of the most versatile certifications.",
            typicalSalaryRange: "$75K – $130K+",
            testRequirements: ["PMP exam (180 questions, 230 minutes)", "35 hours of PM education", "36 months leading projects (with degree) or 60 months (without)"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "3–6 months study",
            costRange: "$500 – $3K",
            fundingOptions: ["Employer-sponsored training", "PMI membership discounts", "Udemy and Coursera courses"],
            basicSteps: [
                "Complete 35 hours of project management education",
                "Document your project leadership experience",
                "Apply to PMI for exam eligibility",
                "Study using the PMBOK Guide and practice exams",
                "Pass the PMP certification exam",
                "Maintain with 60 PDUs every 3 years"
            ],
            linkedJobIds: ["event-planning"]
        ),
        EducationPath(
            id: "capm", title: "CAPM (Certified Associate in Project Management)", icon: "list.bullet.clipboard.fill",
            category: .certification, aiSafeScore: 60,
            overview: "The entry-level version of the PMP for those without experience. Great stepping stone to PMP certification. Validates understanding of project management fundamentals.",
            whyItWorksNow: "Shows employers you understand PM methodology even without years of experience. Gets your foot in the door for project coordinator roles.",
            typicalSalaryRange: "$50K – $75K+",
            testRequirements: ["CAPM exam (150 questions, 3 hours)", "23 hours of PM education"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "1–3 months study",
            costRange: "$300 – $1K",
            fundingOptions: ["PMI membership discounts", "Google Project Management Certificate counts toward hours", "Self-funded (low cost)"],
            basicSteps: [
                "Complete 23 hours of project management education",
                "Apply to PMI for CAPM exam eligibility",
                "Study PM fundamentals and the PMBOK Guide",
                "Pass the CAPM certification exam",
                "Apply for project coordinator or junior PM roles",
                "Gain experience and pursue PMP certification"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "shrm_cp", title: "SHRM-CP (Human Resource Management)", icon: "person.3.fill",
            category: .certification, aiSafeScore: 60,
            overview: "The go-to certification for HR professionals from the Society for Human Resource Management. Covers people management, organization strategy, and workplace compliance.",
            whyItWorksNow: "HR is evolving with remote work, DEI, and compliance needs. SHRM-CP demonstrates competency in modern human resource practices.",
            typicalSalaryRange: "$55K – $85K+",
            testRequirements: ["SHRM-CP exam (160 questions, 4 hours)", "HR-related experience or education"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "2–4 months study",
            costRange: "$400 – $2K",
            fundingOptions: ["Employer-sponsored training", "SHRM membership discounts", "University HR certificate programs"],
            basicSteps: [
                "Verify eligibility based on HR experience or education",
                "Study the SHRM Body of Competency and Knowledge",
                "Complete an official SHRM preparation course",
                "Practice with sample questions and scenarios",
                "Pass the SHRM-CP certification exam",
                "Maintain with 60 PDCs every 3 years"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "six_sigma", title: "Six Sigma Green/Black Belt", icon: "chart.line.downtrend.xyaxis",
            category: .certification, aiSafeScore: 68,
            overview: "Focused on process improvement and efficiency. Huge in manufacturing and operations. Six Sigma professionals use data-driven methods to reduce waste, defects, and improve quality.",
            whyItWorksNow: "Companies are laser-focused on efficiency and cost reduction. Six Sigma skills command premium salaries and consulting rates across industries.",
            typicalSalaryRange: "$60K – $120K+",
            testRequirements: ["Green Belt exam (completion of a project)", "Black Belt exam (advanced project leadership)"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "2–6 months",
            costRange: "$500 – $5K",
            fundingOptions: ["Employer-sponsored training", "ASQ membership discounts", "Online platforms (Coursera, edX)"],
            basicSteps: [
                "Study DMAIC methodology and statistical tools",
                "Earn Green Belt through coursework and a project",
                "Lead a real process improvement project",
                "Document measurable results and ROI",
                "Pursue Black Belt for leadership and consulting roles",
                "Apply to operations, quality, or consulting positions"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "google_data_analytics", title: "Google Data Analytics Certificate", icon: "chart.bar.fill",
            category: .certification, aiSafeScore: 55,
            overview: "Teaches SQL, Tableau, and R for data-driven roles. A beginner-friendly certificate hosted on Coursera, developed by Google. Covers data cleaning, analysis, visualization, and storytelling.",
            whyItWorksNow: "Data literacy is becoming essential across all industries. This certificate is recognized by 150+ employers in the Google Career Certificate network.",
            typicalSalaryRange: "$45K – $75K+",
            testRequirements: ["Complete all 8 courses on Coursera"],
            deliveryType: "Online",
            timeToComplete: "3–6 months",
            costRange: "$0 – $300 (Coursera subscription)",
            fundingOptions: ["Coursera financial aid (free)", "Google Career Certificate scholarships", "Employer tuition reimbursement"],
            basicSteps: [
                "Enroll in Google Data Analytics on Coursera",
                "Learn spreadsheets, SQL, and data cleaning",
                "Study Tableau for data visualization",
                "Learn R programming for statistical analysis",
                "Complete a capstone case study project",
                "Apply for junior data analyst positions"
            ],
            linkedJobIds: ["bookkeeping"]
        ),
        EducationPath(
            id: "microsoft_office_specialist", title: "Microsoft Office Specialist (MOS)", icon: "doc.richtext.fill",
            category: .certification, aiSafeScore: 50,
            overview: "Validates expert-level skills in Excel, Word, and PowerPoint. Recognized by employers worldwide as proof of Microsoft Office proficiency. Great for administrative and business roles.",
            whyItWorksNow: "Microsoft Office remains the standard in business. MOS certification proves productivity skills that every employer values.",
            typicalSalaryRange: "$35K – $55K+",
            testRequirements: ["MOS exam for each application (Excel, Word, PowerPoint)"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "1–3 months",
            costRange: "$100 – $500",
            fundingOptions: ["Free Microsoft Learn training", "Community college courses", "Self-funded (very low cost)"],
            basicSteps: [
                "Choose which MOS exams to pursue (Excel is most valuable)",
                "Study using Microsoft Learn (free online resources)",
                "Practice with real-world document and spreadsheet projects",
                "Pass the MOS certification exam(s)",
                "Add to resume for administrative or business roles",
                "Pursue Expert-level MOS for advanced recognition"
            ],
            linkedJobIds: ["bookkeeping"]
        ),
    ]

    static let healthcare: [EducationPath] = [
        EducationPath(
            id: "dental_hygienist", title: "Dental Hygienist", icon: "mouth.fill",
            category: .healthcare, aiSafeScore: 88,
            overview: "Dental hygienists clean teeth, examine patients for oral diseases, and provide preventive care. Excellent work-life balance with strong pay.",
            typicalSalaryRange: "$55K – $85K+",
            testRequirements: ["National Board Dental Hygiene Examination", "State clinical exam"],
            deliveryType: "Associate degree program",
            timeToComplete: "2–3 years",
            costRange: "$10K – $30K",
            fundingOptions: ["FAFSA and Pell Grants", "Dental office tuition sponsorship", "State healthcare workforce grants"],
            basicSteps: [
                "Complete prerequisite courses (biology, chemistry)",
                "Apply to an accredited dental hygiene program",
                "Complete the associate degree (2–3 years)",
                "Pass the National Board examination",
                "Obtain your state license",
                "Apply to dental practices"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "massage_therapist", title: "Licensed Massage Therapist", icon: "hand.raised.fill",
            category: .healthcare, aiSafeScore: 92,
            overview: "Massage therapists provide therapeutic bodywork for pain relief, relaxation, and rehabilitation. Hands-on career that AI cannot replicate.",
            typicalSalaryRange: "$35K – $65K+",
            testRequirements: ["MBLEx (Massage and Bodywork Licensing Examination)", "State license"],
            timeToComplete: "6–12 months",
            costRange: "$5K – $15K",
            fundingOptions: ["Financial aid for massage schools", "Employer sponsorship at spas", "VA benefits for veterans"],
            basicSteps: [
                "Enroll in an accredited massage therapy program",
                "Complete 500–1000 hours of training (varies by state)",
                "Pass the MBLEx exam",
                "Obtain your state license",
                "Build clientele at a spa, clinic, or independently",
                "Specialize in sports, medical, or deep tissue massage"
            ],
            linkedJobIds: ["mobile-massage"]
        ),
        EducationPath(
            id: "cna", title: "Certified Nursing Assistant", icon: "heart.fill",
            category: .healthcare, aiSafeScore: 90,
            overview: "CNAs provide basic patient care in hospitals, nursing homes, and home health settings. Fast entry into healthcare with clear advancement to LPN/RN.",
            typicalSalaryRange: "$28K – $40K+",
            testRequirements: ["State CNA certification exam"],
            timeToComplete: "4–12 weeks",
            costRange: "$500 – $2K",
            fundingOptions: ["Many facilities offer free CNA training", "Community college programs", "Red Cross training"],
            basicSteps: [
                "Enroll in a state-approved CNA program",
                "Complete classroom and clinical training",
                "Pass the state certification exam",
                "Apply to hospitals, nursing homes, or home health agencies",
                "Gain experience and consider LPN or RN advancement",
                "Explore specializations (ICU, pediatrics, etc.)"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "emt", title: "EMT / Paramedic", icon: "cross.case.fill",
            category: .healthcare, aiSafeScore: 92,
            overview: "EMTs and paramedics provide emergency medical care and transport patients. Critical role with fast training and clear advancement path.",
            typicalSalaryRange: "$35K – $60K+",
            testRequirements: ["NREMT certification", "State EMT license"],
            timeToComplete: "3–6 months (EMT), 1–2 years (Paramedic)",
            costRange: "$1K – $5K",
            fundingOptions: ["Fire department sponsorship", "Community college aid", "Military medic experience transfers"],
            basicSteps: [
                "Complete an EMT-Basic course (120+ hours)",
                "Pass the NREMT certification exam",
                "Get your state EMT license",
                "Gain experience with an ambulance service",
                "Consider paramedic training for advancement",
                "Explore fire department or flight medic careers"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "phlebotomist", title: "Phlebotomy Technician", icon: "drop.fill",
            category: .healthcare, aiSafeScore: 85,
            overview: "Phlebotomists draw blood for tests, transfusions, and donations. Quick training path to a healthcare career with room for advancement.",
            typicalSalaryRange: "$30K – $45K+",
            testRequirements: ["National phlebotomy certification"],
            timeToComplete: "4–8 weeks",
            costRange: "$500 – $2K",
            fundingOptions: ["Community college programs", "Hospital-sponsored training", "Red Cross training programs"],
            basicSteps: [
                "Enroll in a phlebotomy training program",
                "Complete classroom and clinical hours",
                "Practice venipuncture techniques",
                "Pass the national certification exam",
                "Apply to hospitals, labs, and clinics",
                "Consider advancing to medical lab technician"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "surgical_tech", title: "Surgical Technologist", icon: "staroflife.fill",
            category: .healthcare, aiSafeScore: 90,
            overview: "Surgical technologists assist in operations by preparing operating rooms, sterilizing equipment, and handing instruments to surgeons during procedures.",
            whyItWorksNow: "Aging population is increasing surgical volume. Hospitals are actively recruiting surgical techs.",
            typicalSalaryRange: "$45K – $65K+",
            testRequirements: ["CST certification exam"],
            deliveryType: "Certificate or associate degree",
            timeToComplete: "9–24 months",
            costRange: "$5K – $20K",
            fundingOptions: ["FAFSA and Pell Grants", "Hospital tuition assistance", "Military medic experience transfers"],
            basicSteps: [
                "Enroll in an accredited surgical technology program",
                "Complete coursework in anatomy, sterile technique, and surgical procedures",
                "Perform clinical rotations in operating rooms",
                "Pass the CST certification exam",
                "Apply to hospitals and surgical centers",
                "Specialize in cardiac, orthopedic, or neurosurgery"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "respiratory_therapist", title: "Respiratory Therapist", icon: "lungs.fill",
            category: .healthcare, aiSafeScore: 88,
            overview: "Respiratory therapists treat patients with breathing difficulties using specialized equipment and therapies. Critical role in hospitals and long-term care.",
            typicalSalaryRange: "$50K – $75K+",
            testRequirements: ["TMC exam", "Clinical Simulation Exam (CSE)", "State license"],
            deliveryType: "Associate degree program",
            timeToComplete: "2 years",
            costRange: "$10K – $25K",
            fundingOptions: ["FAFSA and Pell Grants", "Hospital tuition reimbursement", "State healthcare workforce grants"],
            basicSteps: [
                "Complete prerequisite science courses",
                "Enroll in an accredited respiratory therapy program",
                "Complete clinical rotations in hospitals",
                "Pass the TMC and Clinical Simulation exams",
                "Obtain your state license",
                "Specialize in neonatal, critical care, or sleep therapy"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "medical_assistant", title: "Medical Assistant", icon: "stethoscope",
            category: .healthcare, aiSafeScore: 82,
            overview: "Medical assistants perform clinical and administrative tasks in physician offices, hospitals, and clinics. Fast training with diverse daily work.",
            typicalSalaryRange: "$30K – $45K+",
            testRequirements: ["CMA or RMA certification"],
            timeToComplete: "9–12 months",
            costRange: "$3K – $15K",
            fundingOptions: ["Community college financial aid", "Clinic-sponsored training", "WIOA grants"],
            basicSteps: [
                "Enroll in a medical assistant certificate or diploma program",
                "Learn clinical skills (vitals, injections, EKGs)",
                "Complete an externship at a medical office",
                "Pass the CMA or RMA certification exam",
                "Apply to physician offices, clinics, or hospitals",
                "Consider advancing to nursing or health administration"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "pharmacy_tech", title: "Pharmacy Technician", icon: "pills.fill",
            category: .healthcare, aiSafeScore: 72,
            overview: "Pharmacy technicians assist pharmacists in dispensing medications, managing inventory, and serving customers. Steady work with clear advancement paths.",
            typicalSalaryRange: "$30K – $45K+",
            testRequirements: ["PTCB or ExCPT certification"],
            timeToComplete: "3–12 months",
            costRange: "$1K – $5K",
            fundingOptions: ["Pharmacy chain training programs (free)", "Community college programs", "WIOA grants"],
            basicSteps: [
                "Complete a pharmacy technician training program",
                "Learn medication names, dosages, and interactions",
                "Pass the PTCB or ExCPT certification exam",
                "Register with your state board of pharmacy",
                "Get hired at a retail pharmacy or hospital",
                "Specialize in compounding, IV, or oncology pharmacy"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "vet_tech", title: "Veterinary Technician", icon: "pawprint.fill",
            category: .healthcare, aiSafeScore: 88,
            overview: "Vet techs assist veterinarians with animal care, procedures, lab work, and client education. Rewarding career for animal lovers with hands-on variety.",
            typicalSalaryRange: "$30K – $45K+",
            testRequirements: ["VTNE (Veterinary Technician National Exam)"],
            deliveryType: "Associate degree program",
            timeToComplete: "2 years",
            costRange: "$8K – $20K",
            fundingOptions: ["FAFSA and Pell Grants", "Veterinary clinic tuition assistance", "AVMA scholarship programs"],
            basicSteps: [
                "Enroll in an AVMA-accredited vet tech program",
                "Complete coursework in animal anatomy, pharmacology, and radiology",
                "Perform clinical rotations at vet clinics",
                "Pass the VTNE certification exam",
                "Get state credentialed (varies by state)",
                "Specialize in emergency, dental, or exotic animal care"
            ],
            linkedJobIds: ["pet-sitting"]
        ),
        EducationPath(
            id: "cpc_medical_coder", title: "CPC (Certified Professional Coder)", icon: "doc.text.fill",
            category: .healthcare, aiSafeScore: 55,
            overview: "High-demand credential for medical billing and coding. CPCs translate healthcare services into standardized codes for insurance claims and billing. Remote-friendly with consistent demand.",
            whyItWorksNow: "Healthcare spending continues to grow. Every medical visit generates codes, creating constant demand for certified coders.",
            typicalSalaryRange: "$38K – $60K+",
            testRequirements: ["CPC certification exam (100 questions, 4 hours)"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "4–12 months",
            costRange: "$2K – $6K",
            fundingOptions: ["AAPC scholarships", "Community college financial aid", "Employer tuition reimbursement"],
            basicSteps: [
                "Learn medical terminology and anatomy basics",
                "Study ICD-10, CPT, and HCPCS coding systems",
                "Complete an AAPC-approved coding program",
                "Practice with real coding scenarios and exercises",
                "Pass the CPC certification exam",
                "Apply for coding positions at hospitals, clinics, or remotely"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "cma_medical_assistant", title: "CMA (Certified Medical Assistant)", icon: "stethoscope",
            category: .healthcare, aiSafeScore: 82,
            overview: "Covers both clinical tasks and office administration. CMAs take vitals, assist with exams, administer medications, manage records, and handle patient scheduling. Versatile healthcare role.",
            whyItWorksNow: "Physician offices are expanding and need versatile staff who can handle both clinical and administrative duties.",
            typicalSalaryRange: "$32K – $48K+",
            testRequirements: ["CMA (AAMA) certification exam"],
            deliveryType: "In-person, but online and hybrid programs are available",
            timeToComplete: "9–12 months",
            costRange: "$3K – $15K",
            fundingOptions: ["Community college financial aid", "Clinic-sponsored training", "WIOA grants"],
            basicSteps: [
                "Enroll in a CAAHEP-accredited medical assistant program",
                "Learn clinical skills (vitals, injections, EKGs, phlebotomy)",
                "Study office administration and medical records",
                "Complete a clinical externship",
                "Pass the CMA (AAMA) certification exam",
                "Apply to physician offices, clinics, or urgent care centers"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "cpht_pharmacy_tech", title: "CPhT (Certified Pharmacy Technician)", icon: "pills.fill",
            category: .healthcare, aiSafeScore: 72,
            overview: "For working in retail or hospital pharmacies. CPhTs assist pharmacists with dispensing medications, managing inventory, compounding, and serving patients. Steady work with clear advancement.",
            whyItWorksNow: "Pharmacies are expanding services including vaccinations and testing. Certified techs earn more and have better job prospects.",
            typicalSalaryRange: "$32K – $48K+",
            testRequirements: ["PTCB (Pharmacy Technician Certification Board) exam"],
            deliveryType: "In-person, but online programs are available",
            timeToComplete: "3–6 months",
            costRange: "$1K – $5K",
            fundingOptions: ["Pharmacy chain training programs (some free)", "Community college programs", "WIOA grants"],
            basicSteps: [
                "Complete a pharmacy technician training program",
                "Learn medication names, dosages, and interactions",
                "Study pharmacy law and compounding basics",
                "Pass the PTCB certification exam",
                "Register with your state board of pharmacy",
                "Get hired at a retail pharmacy or hospital"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "cpt_phlebotomy", title: "Phlebotomy Technician (CPT)", icon: "drop.fill",
            category: .healthcare, aiSafeScore: 85,
            overview: "Specialized in drawing blood for tests, transfusions, and donations. Usually requires a brief in-person clinical component. Quick entry into healthcare with room for advancement.",
            whyItWorksNow: "Lab testing is expanding and every blood draw requires a trained phlebotomist. Quick certification makes this an accessible healthcare entry point.",
            typicalSalaryRange: "$30K – $45K+",
            testRequirements: ["National phlebotomy certification (NHA CPT or ASCP)"],
            deliveryType: "In-person (clinical hours required), but online didactic portions available",
            timeToComplete: "4–8 weeks",
            costRange: "$500 – $2K",
            fundingOptions: ["Community college programs", "Hospital-sponsored training", "Red Cross training programs"],
            basicSteps: [
                "Enroll in a phlebotomy training program",
                "Complete classroom instruction on anatomy and safety",
                "Practice venipuncture techniques in clinical setting",
                "Complete required supervised blood draws",
                "Pass the national certification exam (CPT)",
                "Apply to hospitals, labs, clinics, and blood banks"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "ekg_technician", title: "EKG Technician (CET)", icon: "waveform.path.ecg",
            category: .healthcare, aiSafeScore: 82,
            overview: "Specializes in heart monitor testing. EKG technicians perform electrocardiograms, apply Holter monitors, and assist cardiologists with cardiac diagnostics. Quick certification with growing demand.",
            whyItWorksNow: "Heart disease remains the leading cause of death. Cardiac testing demand grows as the population ages and preventive care expands.",
            typicalSalaryRange: "$32K – $50K+",
            testRequirements: ["Certified EKG Technician (CET) exam from NHA"],
            deliveryType: "In-person, but online and hybrid programs are available",
            timeToComplete: "4–12 weeks",
            costRange: "$500 – $3K",
            fundingOptions: ["Community college programs", "Hospital-sponsored training", "MedCerts or similar online programs"],
            basicSteps: [
                "Enroll in an EKG technician training program",
                "Study cardiac anatomy and electrical conduction",
                "Learn to place leads and operate EKG equipment",
                "Practice reading and recognizing EKG rhythms",
                "Pass the CET certification exam",
                "Apply to hospitals, cardiology offices, and clinics"
            ],
            linkedJobIds: []
        ),
    ]

    static let technology: [EducationPath] = [
        EducationPath(
            id: "cybersecurity", title: "Cybersecurity Analyst", icon: "lock.shield.fill",
            category: .technology, aiSafeScore: 75,
            overview: "Cybersecurity analysts protect organizations from digital threats. Massive skills gap means high demand and strong salaries even for career changers.",
            typicalSalaryRange: "$60K – $120K+",
            testRequirements: ["CompTIA Security+", "CySA+ (advanced)", "CISSP (senior)"],
            deliveryType: "Online or in-person",
            timeToComplete: "6–18 months",
            costRange: "$500 – $5K",
            fundingOptions: ["Free online training platforms", "Employer tuition reimbursement", "Government cyber workforce programs"],
            basicSteps: [
                "Study networking and security fundamentals",
                "Earn CompTIA Security+ certification",
                "Build a home lab for hands-on practice",
                "Complete online courses (TryHackMe, HackTheBox)",
                "Apply for SOC Analyst or junior security roles",
                "Pursue advanced certs (CySA+, CISSP) for growth"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "web_developer", title: "Web Developer", icon: "globe",
            category: .technology, aiSafeScore: 55,
            overview: "Web developers build and maintain websites and web applications. Strong demand but increasingly augmented by AI tools.",
            typicalSalaryRange: "$50K – $110K+",
            deliveryType: "Online bootcamp or self-taught",
            timeToComplete: "3–12 months",
            costRange: "$0 – $15K",
            fundingOptions: ["Free resources (freeCodeCamp, The Odin Project)", "Bootcamp financing and ISAs", "Employer tuition reimbursement"],
            basicSteps: [
                "Learn HTML, CSS, and JavaScript fundamentals",
                "Build 3–5 portfolio projects",
                "Learn a framework (React, Vue, or Angular)",
                "Create a professional portfolio website",
                "Apply for junior developer positions",
                "Continue learning and specializing"
            ],
            linkedJobIds: ["web-design"]
        ),
        EducationPath(
            id: "it_support", title: "IT Support Specialist", icon: "desktopcomputer",
            category: .technology, aiSafeScore: 65,
            overview: "IT support specialists help organizations with technology issues. Entry point to many tech careers.",
            typicalSalaryRange: "$40K – $65K+",
            testRequirements: ["CompTIA A+", "CompTIA Network+ (optional)"],
            deliveryType: "Online or in-person",
            timeToComplete: "3–6 months",
            costRange: "$300 – $3K",
            fundingOptions: ["Google IT Support Certificate", "Employer-paid certifications", "Community college programs"],
            basicSteps: [
                "Complete Google IT Support Certificate or equivalent",
                "Study for CompTIA A+ certification",
                "Build a home lab for practice",
                "Pass the CompTIA A+ exam",
                "Apply for help desk or IT support roles",
                "Pursue Network+ or Security+ for advancement"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "data_analyst", title: "Data Analyst", icon: "chart.bar.fill",
            category: .technology, aiSafeScore: 55,
            overview: "Data analysts collect, process, and analyze data to help organizations make informed decisions. Growing field across all industries.",
            typicalSalaryRange: "$50K – $85K+",
            deliveryType: "Online or bootcamp",
            timeToComplete: "3–9 months",
            costRange: "$0 – $10K",
            fundingOptions: ["Google Career Certificate", "Bootcamp financing", "Employer tuition reimbursement"],
            basicSteps: [
                "Learn Excel and basic statistics",
                "Complete Google Data Analytics Certificate",
                "Learn SQL for database querying",
                "Practice with real datasets on Kaggle",
                "Build a portfolio of analysis projects",
                "Apply for junior analyst positions"
            ],
            linkedJobIds: ["bookkeeping"]
        ),
        EducationPath(
            id: "cloud_computing", title: "Cloud Computing (AWS/Azure)", icon: "cloud.fill",
            category: .technology, aiSafeScore: 62,
            overview: "Cloud engineers design, deploy, and manage cloud infrastructure on platforms like AWS, Azure, and Google Cloud. High demand and excellent salaries.",
            whyItWorksNow: "Nearly every company is migrating to the cloud. Certified cloud professionals command premium salaries.",
            typicalSalaryRange: "$70K – $130K+",
            testRequirements: ["AWS Cloud Practitioner", "AWS Solutions Architect (advanced)", "Azure Fundamentals"],
            deliveryType: "Online self-study or bootcamp",
            timeToComplete: "3–9 months",
            costRange: "$300 – $5K",
            fundingOptions: ["Free tier cloud accounts for practice", "Employer-sponsored certification", "Online course subscriptions"],
            basicSteps: [
                "Learn cloud computing fundamentals",
                "Set up a free AWS or Azure account for hands-on practice",
                "Earn AWS Cloud Practitioner or Azure Fundamentals cert",
                "Build projects deploying real applications to the cloud",
                "Pursue Solutions Architect or DevOps certifications",
                "Apply for cloud engineer or DevOps roles"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "network_admin", title: "Network Administrator", icon: "network",
            category: .technology, aiSafeScore: 68,
            overview: "Network administrators design, install, and manage computer networks for organizations. Foundational IT role with clear advancement paths.",
            typicalSalaryRange: "$50K – $85K+",
            testRequirements: ["CompTIA Network+", "CCNA (Cisco)"],
            deliveryType: "Online or in-person",
            timeToComplete: "3–9 months",
            costRange: "$500 – $5K",
            fundingOptions: ["Employer-sponsored certifications", "Community college programs", "CompTIA voucher discounts"],
            basicSteps: [
                "Study networking fundamentals (TCP/IP, DNS, DHCP)",
                "Earn CompTIA Network+ certification",
                "Build a home lab with routers and switches",
                "Gain experience at a help desk or junior IT role",
                "Pursue CCNA for advanced networking roles",
                "Specialize in security, wireless, or data center networking"
            ],
            linkedJobIds: []
        ),
    ]

    static let business: [EducationPath] = [
        EducationPath(
            id: "real_estate", title: "Real Estate Agent", icon: "house.fill",
            category: .business, aiSafeScore: 72,
            overview: "Real estate agents help people buy, sell, and rent properties. Commission-based income with unlimited earning potential and flexible schedule.",
            typicalSalaryRange: "$40K – $100K+",
            testRequirements: ["State pre-licensing course", "Real estate licensing exam"],
            deliveryType: "Online or in-person",
            timeToComplete: "2–6 months",
            costRange: "$1K – $3K",
            fundingOptions: ["Low-cost online pre-licensing courses", "Brokerage-sponsored training", "Self-funded (low barrier to entry)"],
            basicSteps: [
                "Complete your state's pre-licensing course",
                "Pass the real estate licensing exam",
                "Join a brokerage for mentorship and leads",
                "Build your sphere of influence and online presence",
                "Close your first transaction",
                "Develop a referral network for consistent deals"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "insurance_agent", title: "Insurance Agent", icon: "shield.fill",
            category: .business, aiSafeScore: 65,
            overview: "Insurance agents sell and service insurance policies for individuals and businesses. Commission-based with residual income potential.",
            typicalSalaryRange: "$40K – $90K+",
            testRequirements: ["State insurance licensing exam"],
            deliveryType: "Online or in-person",
            timeToComplete: "1–3 months",
            costRange: "$200 – $1K",
            fundingOptions: ["Agency-sponsored licensing", "Self-funded (low cost)", "Insurance company training programs"],
            basicSteps: [
                "Choose your insurance lines (life, health, property, casualty)",
                "Complete pre-licensing education",
                "Pass the state licensing exam",
                "Join an established agency or go independent",
                "Build a client base through networking",
                "Focus on renewals for residual income"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "project_manager", title: "Project Manager (PMP)", icon: "list.clipboard.fill",
            category: .business, aiSafeScore: 62,
            overview: "Project managers plan, execute, and close projects across industries. Strong demand in tech, construction, and healthcare.",
            typicalSalaryRange: "$55K – $100K+",
            testRequirements: ["CAPM or PMP certification"],
            deliveryType: "Online or in-person",
            timeToComplete: "3–12 months",
            costRange: "$0 – $5K",
            fundingOptions: ["Google Project Management Certificate", "Employer-sponsored PMP prep", "PMI membership discounts"],
            basicSteps: [
                "Complete the Google Project Management Certificate",
                "Learn agile and waterfall methodologies",
                "Study for CAPM or PMP certification",
                "Gain project coordination experience",
                "Build a track record of delivered projects",
                "Pursue PMP certification for senior roles"
            ],
            linkedJobIds: ["event-planning"]
        ),
        EducationPath(
            id: "bookkeeper_cert", title: "Bookkeeper / Accounting Cert", icon: "dollarsign.square.fill",
            category: .business, aiSafeScore: 58,
            overview: "Certified bookkeepers manage financial records for businesses. Remote-friendly work with steady demand from small businesses and freelancers.",
            typicalSalaryRange: "$35K – $60K+",
            testRequirements: ["AIPB Certified Bookkeeper exam", "QuickBooks ProAdvisor (optional)"],
            deliveryType: "Online or in-person",
            timeToComplete: "3–6 months",
            costRange: "$500 – $3K",
            fundingOptions: ["Online course platforms", "Community college programs", "Self-funded (low cost)"],
            basicSteps: [
                "Learn accounting fundamentals and bookkeeping principles",
                "Master QuickBooks or Xero accounting software",
                "Earn the AIPB Certified Bookkeeper credential",
                "Get QuickBooks ProAdvisor certified (free)",
                "Find clients through local businesses and online platforms",
                "Consider specializing in an industry (restaurants, contractors, etc.)"
            ],
            linkedJobIds: ["bookkeeping"]
        ),
        EducationPath(
            id: "paralegal", title: "Paralegal / Legal Assistant", icon: "books.vertical.fill",
            category: .business, aiSafeScore: 60,
            overview: "Paralegals assist attorneys with legal research, document preparation, and case management. Growing field with various specialization options.",
            typicalSalaryRange: "$40K – $65K+",
            testRequirements: ["Paralegal certificate or ABA-approved program"],
            deliveryType: "Certificate or associate degree",
            timeToComplete: "6–24 months",
            costRange: "$3K – $15K",
            fundingOptions: ["Community college financial aid", "Law firm tuition assistance", "FAFSA and Pell Grants"],
            basicSteps: [
                "Enroll in an ABA-approved paralegal program",
                "Study legal research, writing, and procedures",
                "Complete coursework in your area of interest (family, corporate, litigation)",
                "Perform an internship at a law firm",
                "Earn a paralegal certificate or degree",
                "Apply to law firms, corporate legal departments, or government agencies"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "medical_billing", title: "Medical Billing & Coding", icon: "doc.text.fill",
            category: .business, aiSafeScore: 55,
            overview: "Medical coders translate healthcare services into standardized codes for billing and insurance. Remote-friendly career with consistent healthcare demand.",
            typicalSalaryRange: "$35K – $55K+",
            testRequirements: ["CPC or CCS certification"],
            deliveryType: "Online or community college",
            timeToComplete: "4–12 months",
            costRange: "$2K – $8K",
            fundingOptions: ["AAPC scholarships", "Community college financial aid", "Employer tuition reimbursement"],
            basicSteps: [
                "Learn medical terminology and anatomy basics",
                "Study ICD-10, CPT, and HCPCS coding systems",
                "Complete an accredited medical coding program",
                "Pass the CPC or CCS certification exam",
                "Apply for coding positions at hospitals, clinics, or remote companies",
                "Specialize in a coding area (surgery, radiology, cardiology)"
            ],
            linkedJobIds: []
        ),
    ]

    static let creative: [EducationPath] = [
        EducationPath(
            id: "ux_designer", title: "UX/UI Designer", icon: "paintbrush.pointed.fill",
            category: .creative, aiSafeScore: 58,
            overview: "UX designers create user-friendly digital experiences for apps and websites. Combines creativity with problem-solving.",
            typicalSalaryRange: "$55K – $100K+",
            deliveryType: "Online bootcamp or self-taught",
            timeToComplete: "3–9 months",
            costRange: "$0 – $12K",
            fundingOptions: ["Google UX Design Certificate", "Bootcamp ISAs", "Self-taught with free resources"],
            basicSteps: [
                "Learn UX design principles and user research methods",
                "Master Figma or Sketch design tools",
                "Complete the Google UX Design Certificate",
                "Build 3–5 case study portfolio projects",
                "Create a professional portfolio website",
                "Apply for junior UX designer positions"
            ],
            linkedJobIds: ["graphic-design", "web-design"]
        ),
        EducationPath(
            id: "culinary_arts", title: "Culinary Arts / Chef", icon: "fork.knife",
            category: .creative, aiSafeScore: 90,
            overview: "Culinary arts programs teach professional cooking, baking, kitchen management, and food safety. Hands-on career with diverse paths from restaurants to private cheffing.",
            whyItWorksNow: "Food culture boom and demand for personal chefs, meal prep services, and food trucks create diverse earning opportunities.",
            typicalSalaryRange: "$30K – $70K+",
            testRequirements: ["ServSafe Food Handler certification"],
            deliveryType: "In-person culinary school",
            timeToComplete: "6–24 months",
            costRange: "$5K – $30K",
            fundingOptions: ["Culinary school financial aid", "Restaurant apprenticeship programs", "FAFSA and Pell Grants"],
            basicSteps: [
                "Enroll in a culinary arts program or apprenticeship",
                "Learn knife skills, cooking techniques, and food safety",
                "Get ServSafe certified",
                "Complete kitchen externship hours",
                "Work in professional kitchens to build experience",
                "Specialize in pastry, ethnic cuisine, or catering"
            ],
            linkedJobIds: ["meal-prep", "personal-chef"]
        ),
        EducationPath(
            id: "cosmetology", title: "Cosmetology / Barber", icon: "scissors",
            category: .creative, aiSafeScore: 92,
            overview: "Cosmetologists and barbers provide hair cutting, styling, coloring, and grooming services. Highly personal, hands-on work with strong client relationships.",
            whyItWorksNow: "Personal grooming is recession-resistant. Social media creates opportunities for stylists to build large followings and premium pricing.",
            typicalSalaryRange: "$25K – $60K+",
            testRequirements: ["State cosmetology or barber license"],
            timeToComplete: "9–18 months",
            costRange: "$5K – $20K",
            fundingOptions: ["Beauty school financial aid", "FAFSA and Pell Grants", "Salon apprenticeship programs"],
            basicSteps: [
                "Enroll in a state-licensed cosmetology or barber school",
                "Complete required training hours (varies by state)",
                "Learn cutting, coloring, styling, and chemical treatments",
                "Pass the state licensing exam (written and practical)",
                "Build a clientele at a salon or barbershop",
                "Consider booth rental or opening your own shop"
            ],
            linkedJobIds: []
        ),
        EducationPath(
            id: "graphic_design_cert", title: "Graphic Design Certificate", icon: "pencil.and.ruler.fill",
            category: .creative, aiSafeScore: 50,
            overview: "Graphic designers create visual content for brands, marketing, and digital media. AI is augmenting the field but human creativity and client relationships remain essential.",
            typicalSalaryRange: "$40K – $75K+",
            testRequirements: ["Adobe Certified Professional (optional)"],
            deliveryType: "Online or community college",
            timeToComplete: "3–12 months",
            costRange: "$0 – $10K",
            fundingOptions: ["Free resources (Canva, YouTube)", "Community college programs", "Adobe Creative Cloud student pricing"],
            basicSteps: [
                "Learn design principles (typography, color theory, layout)",
                "Master Adobe Creative Suite (Photoshop, Illustrator, InDesign)",
                "Build a portfolio of 10+ diverse projects",
                "Create a professional website showcasing your work",
                "Start freelancing on platforms like Fiverr or Upwork",
                "Pursue full-time design roles or build a freelance business"
            ],
            linkedJobIds: ["graphic-design"]
        ),
        EducationPath(
            id: "audio_engineering", title: "Audio / Sound Engineering", icon: "waveform",
            category: .creative, aiSafeScore: 75,
            overview: "Audio engineers record, mix, and produce sound for music, film, podcasts, and live events. Technical creative career with diverse applications.",
            typicalSalaryRange: "$35K – $80K+",
            testRequirements: ["No formal certification required"],
            deliveryType: "Certificate program or self-taught",
            timeToComplete: "6–18 months",
            costRange: "$2K – $15K",
            fundingOptions: ["Audio school financial aid", "Online courses (low cost)", "Studio apprenticeships"],
            basicSteps: [
                "Learn audio fundamentals (acoustics, signal flow, EQ, compression)",
                "Master a DAW (Pro Tools, Logic Pro, or Ableton Live)",
                "Practice recording and mixing real projects",
                "Build a portfolio of mixed and produced tracks",
                "Intern or apprentice at a recording studio",
                "Freelance or get hired at a studio, venue, or production company"
            ],
            linkedJobIds: ["podcast-production"]
        ),
        EducationPath(
            id: "interior_design", title: "Interior Design", icon: "sofa.fill",
            category: .creative, aiSafeScore: 78,
            overview: "Interior designers plan and furnish indoor spaces for functionality, safety, and aesthetics. Combines creativity with client relationships and spatial problem-solving.",
            typicalSalaryRange: "$40K – $75K+",
            testRequirements: ["NCIDQ certification (for licensed states)"],
            deliveryType: "Certificate, associate, or bachelor's degree",
            timeToComplete: "1–4 years",
            costRange: "$5K – $40K",
            fundingOptions: ["Design school financial aid", "FAFSA and Pell Grants", "Firm-sponsored education"],
            basicSteps: [
                "Complete an interior design certificate or degree program",
                "Learn space planning, color theory, and CAD software",
                "Build a portfolio through projects and internships",
                "Gain work experience at a design firm",
                "Pursue NCIDQ certification if required in your state",
                "Start your own practice or specialize (residential, commercial, staging)"
            ],
            linkedJobIds: ["home-staging"]
        ),
        EducationPath(
            id: "photography_cert", title: "Photography", icon: "camera.fill",
            category: .creative, aiSafeScore: 72,
            overview: "Professional photographers capture images for weddings, events, portraits, products, and real estate. Flexible career with multiple income streams.",
            typicalSalaryRange: "$30K – $70K+",
            testRequirements: ["No formal certification required"],
            deliveryType: "Self-taught, workshops, or certificate",
            timeToComplete: "3–12 months",
            costRange: "$2K – $10K (includes equipment)",
            fundingOptions: ["Online courses (low cost)", "Community college programs", "Self-funded equipment investment"],
            basicSteps: [
                "Learn photography fundamentals (exposure, composition, lighting)",
                "Master photo editing software (Lightroom, Photoshop)",
                "Invest in a camera body and versatile lens kit",
                "Build a portfolio through practice and free shoots",
                "Choose a niche (weddings, portraits, real estate, product)",
                "Market your services and build a booking pipeline"
            ],
            linkedJobIds: ["drone-photography", "event-photography"]
        ),
        EducationPath(
            id: "video_production", title: "Video Production", icon: "video.fill",
            category: .creative, aiSafeScore: 65,
            overview: "Video producers create content for social media, corporate clients, weddings, and entertainment. Exploding demand driven by digital marketing and streaming.",
            whyItWorksNow: "Every business needs video content. Social media algorithms favor video, creating massive demand for producers.",
            typicalSalaryRange: "$35K – $80K+",
            testRequirements: ["No formal certification required"],
            deliveryType: "Self-taught, workshops, or certificate",
            timeToComplete: "3–12 months",
            costRange: "$2K – $10K (includes equipment)",
            fundingOptions: ["Online courses (low cost)", "Film school programs", "Self-funded equipment"],
            basicSteps: [
                "Learn video shooting fundamentals (framing, lighting, audio)",
                "Master editing software (Premiere Pro, DaVinci Resolve, Final Cut)",
                "Build a reel with diverse projects",
                "Start with local businesses, events, or social media content",
                "Develop a niche (corporate, wedding, social media, documentary)",
                "Scale into a production company or specialize further"
            ],
            linkedJobIds: ["video-editing"]
        ),
        EducationPath(
            id: "floral_design", title: "Floral Design", icon: "leaf.fill",
            category: .creative, aiSafeScore: 90,
            overview: "Floral designers create arrangements for weddings, events, retail shops, and corporate clients. Artistic hands-on work with seasonal variety.",
            typicalSalaryRange: "$25K – $50K+",
            testRequirements: ["AIFD certification (optional, advanced)"],
            timeToComplete: "3–12 months",
            costRange: "$1K – $5K",
            fundingOptions: ["Community college floral programs", "Flower shop apprenticeships", "Self-taught with online courses"],
            basicSteps: [
                "Take floral design courses (community college or online)",
                "Learn design principles, flower varieties, and care techniques",
                "Practice arrangements for friends and family events",
                "Apprentice at a flower shop or event company",
                "Build a portfolio of your best work",
                "Start freelancing for weddings and events"
            ],
            linkedJobIds: ["event-planning"]
        ),
    ]

    static let military: [EducationPath] = [
        EducationPath(
            id: "military_enlisted", title: "Military — Enlisted", icon: "shield.checkered",
            category: .military, aiSafeScore: 92,
            overview: "Enlist in the U.S. military and receive paid training, housing, healthcare, and a guaranteed salary from day one. No degree required. The military trains and certifies you in hundreds of career fields — from mechanics and IT to medical and logistics. Transferable skills and veterans benefits (GI Bill) open doors after service.",
            whyItWorksNow: "All branches are actively recruiting with signing bonuses and expanded benefits. Military experience is highly valued by employers, and the GI Bill covers college tuition after service.",
            futureDemand: "Very strong — national defense needs are constant, and veterans are prioritized in hiring across government and private sectors.",
            typicalSalaryRange: "$24K – $45K+ (base pay, plus housing, food, and healthcare)",
            prerequisites: ["U.S. citizen or permanent resident", "Age 17–39 (varies by branch)", "High school diploma or GED", "Pass the ASVAB test", "Meet physical fitness standards"],
            testRequirements: ["ASVAB (Armed Services Vocational Aptitude Battery)", "Physical fitness test", "Medical exam at MEPS"],
            deliveryType: "Basic training + MOS/rating school",
            timeToComplete: "8–16 weeks basic training + job training (varies)",
            costRange: "$0 (fully paid — you earn a salary during training)",
            fundingOptions: ["Fully funded — salary from day one", "GI Bill for post-service education", "Tuition Assistance during service", "Signing bonuses for in-demand roles"],
            howToFindPrograms: ["Visit your local military recruiter", "Explore goarmy.com, navy.com, airforce.com, marines.com, or gocoastguard.com", "Take the ASVAB practice test online"],
            employerSponsoredOptions: ["The military IS the employer — full salary, housing, and benefits from day one"],
            militaryPath: "This is the military path. Enlisted service members receive hands-on training and certifications that transfer directly to civilian careers.",
            basicSteps: [
                "Research branches and MOS/rating options that interest you",
                "Visit a recruiter and take the ASVAB test",
                "Complete processing at MEPS (medical and paperwork)",
                "Ship to basic training (8–16 weeks)",
                "Complete your MOS/rating job training school",
                "Serve your contract and earn certifications, experience, and GI Bill benefits"
            ],
            linkedJobIds: ["handyman", "courier-delivery", "appliance-repair"]
        ),
        EducationPath(
            id: "military_officer", title: "Military — Officer", icon: "star.circle.fill",
            category: .military, aiSafeScore: 90,
            overview: "Commission as a military officer and lead teams from day one. Requires a 4-year college degree (any major). Officers manage personnel, operations, and complex projects across every field — from engineering and aviation to intelligence and healthcare. Higher starting pay, leadership experience, and strong post-military career prospects.",
            whyItWorksNow: "Officer candidates are in high demand, especially in technical fields. Military leadership experience is among the most respected credentials in the job market.",
            futureDemand: "Very strong — officers transition into senior management, government, defense contractors, and executive leadership roles at high rates.",
            typicalSalaryRange: "$44K – $75K+ (base pay, plus housing, food, and healthcare)",
            prerequisites: ["U.S. citizen", "Bachelor's degree (any major)", "Age 18–34 (varies by branch and commissioning source)", "Pass the AFOQT, OAR, or equivalent test", "Meet physical fitness standards", "No disqualifying medical conditions"],
            testRequirements: ["Branch-specific officer aptitude test (AFOQT, OAR, etc.)", "Physical fitness test", "Medical exam at MEPS", "Officer Candidate School or ROTC completion"],
            deliveryType: "OCS, ROTC, or Service Academy",
            timeToComplete: "10–16 weeks OCS (after college) or 4 years ROTC (during college)",
            costRange: "$0 (ROTC scholarships cover tuition; OCS is fully paid)",
            fundingOptions: ["ROTC scholarships (full tuition + stipend)", "Service Academy (free education)", "OCS after earning a degree", "Student loan repayment programs"],
            howToFindPrograms: ["Contact an Officer recruiter for your preferred branch", "Apply to ROTC programs at your university", "Explore service academy nominations through your congressional representative"],
            employerSponsoredOptions: ["ROTC provides full-ride scholarships at 1,000+ universities", "Service Academies provide free education and a guaranteed career"],
            militaryPath: "This is the officer commissioning path. Officers lead teams and gain management experience that translates to senior civilian roles.",
            basicSteps: [
                "Earn a 4-year bachelor's degree (any major)",
                "Choose a commissioning path: OCS, ROTC, or Service Academy",
                "Pass the officer aptitude test and physical requirements",
                "Complete Officer Candidate School or commission through ROTC",
                "Attend your branch-specific officer training course",
                "Lead teams and gain leadership credentials valued across all industries"
            ],
            linkedJobIds: ["event-planning"]
        ),
    ]
}

extension EducationPath {
    var name: String { title }
    var salaryRange: String { typicalSalaryRange }
    var timeToIncome: String { timeToComplete }
    var steps: [String] { basicSteps }
    var whyAIResistant: String {
        zone == .safe
            ? "This field requires hands-on, physical work that AI cannot replicate. Human judgment and presence are essential."
            : zone == .human
            ? "While AI tools may assist in some areas, the core work requires human expertise, relationships, and decision-making."
            : "AI is impacting this field. Success requires adapting to and leveraging AI tools rather than competing with them."
    }
}
