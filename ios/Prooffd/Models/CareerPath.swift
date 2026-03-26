import Foundation

nonisolated struct CareerPath: Identifiable, Codable, Sendable {
    let id: String
    let name: String
    let icon: String
    let salaryRange: String
    let timeToIncome: String
    let costRange: String
    let overview: String
    let steps: [String]
    let fundingOptions: [String]
    let whyAIResistant: String
}

enum CareerPathDatabase {
    static let all: [CareerPath] = [
        CareerPath(
            id: "electrician",
            name: "Licensed Electrician",
            icon: "bolt.fill",
            salaryRange: "$55K – $100K+",
            timeToIncome: "4–5 years (apprenticeship)",
            costRange: "$2K – $5K",
            overview: "Electricians install, maintain, and repair electrical systems in homes, businesses, and industrial settings. High demand, strong pay, and a clear apprenticeship pathway.",
            steps: [
                "Complete a pre-apprenticeship program or trade school",
                "Apply for an electrical apprenticeship (4–5 years)",
                "Log required supervised hours",
                "Pass the journeyman electrician exam",
                "Obtain your state license",
                "Build clientele or join a firm"
            ],
            fundingOptions: ["Union apprenticeships (paid training)", "Pell Grants for trade school", "State workforce development programs"],
            whyAIResistant: "Physical wiring, troubleshooting, and code-compliant installations require hands-on human expertise that AI cannot replicate."
        ),
        CareerPath(
            id: "plumber",
            name: "Licensed Plumber",
            icon: "wrench.and.screwdriver.fill",
            salaryRange: "$50K – $90K+",
            timeToIncome: "4–5 years",
            costRange: "$2K – $4K",
            overview: "Plumbers install and repair water, gas, and drainage systems. Essential service with consistent demand regardless of economic conditions.",
            steps: [
                "Enroll in a plumbing trade program",
                "Secure a plumbing apprenticeship",
                "Complete 4–5 years of supervised work",
                "Pass the journeyman plumber exam",
                "Get licensed in your state",
                "Start taking independent jobs or open a business"
            ],
            fundingOptions: ["Union apprenticeships", "Community college financial aid", "Veterans benefits for trade training"],
            whyAIResistant: "Diagnosing leaks, fitting pipes in unique spaces, and emergency repairs require physical presence and problem-solving that AI cannot perform."
        ),
        CareerPath(
            id: "hvac",
            name: "HVAC Technician",
            icon: "thermometer.snowflake",
            salaryRange: "$45K – $85K+",
            timeToIncome: "6 months – 2 years",
            costRange: "$1K – $3K",
            overview: "HVAC technicians install and service heating, ventilation, and air conditioning systems. Growing demand driven by climate needs and new construction.",
            steps: [
                "Complete HVAC certification program (6–24 months)",
                "Get EPA 608 certification for refrigerant handling",
                "Apply for entry-level HVAC positions",
                "Gain field experience with a licensed company",
                "Pursue additional certifications (NATE)",
                "Consider starting your own HVAC business"
            ],
            fundingOptions: ["Trade school financial aid", "Employer-sponsored training", "State energy workforce grants"],
            whyAIResistant: "Physical installation, refrigerant handling, ductwork, and on-site diagnostics require human hands and judgment."
        ),
        CareerPath(
            id: "welder",
            name: "Certified Welder",
            icon: "flame.fill",
            salaryRange: "$40K – $80K+",
            timeToIncome: "6 months – 2 years",
            costRange: "$500 – $2K",
            overview: "Welders join metal parts using high-heat tools. Opportunities span construction, manufacturing, automotive, and specialized industries like underwater welding.",
            steps: [
                "Enroll in a welding program or community college",
                "Learn MIG, TIG, and Stick welding techniques",
                "Get AWS (American Welding Society) certification",
                "Build a portfolio of welding projects",
                "Apply for welding positions or contract work",
                "Specialize in high-paying niches (pipeline, underwater)"
            ],
            fundingOptions: ["Community college tuition assistance", "Workforce Innovation grants", "Employer training programs"],
            whyAIResistant: "Precision manual welding in variable conditions, custom fabrication, and field repairs require human skill and adaptability."
        ),
        CareerPath(
            id: "solar_installer",
            name: "Solar Panel Installer",
            icon: "sun.max.fill",
            salaryRange: "$40K – $70K+",
            timeToIncome: "3–12 months",
            costRange: "$500 – $2K",
            overview: "Solar installers mount photovoltaic systems on rooftops and ground mounts. Fast-growing field driven by clean energy demand and government incentives.",
            steps: [
                "Complete a solar installation training program",
                "Get OSHA safety certification",
                "Apply for entry-level installer positions",
                "Gain rooftop and ground-mount experience",
                "Pursue NABCEP certification for advancement",
                "Consider starting a solar installation company"
            ],
            fundingOptions: ["Clean energy workforce grants", "Trade school financial aid", "On-the-job training programs"],
            whyAIResistant: "Rooftop work, custom mounting configurations, electrical connections, and site-specific installations require physical human labor."
        ),
        CareerPath(
            id: "cdl_driver",
            name: "CDL Truck Driver",
            icon: "truck.box.fill",
            salaryRange: "$50K – $80K+",
            timeToIncome: "3–6 weeks",
            costRange: "$3K – $7K",
            overview: "CDL drivers transport goods across local, regional, or national routes. One of the fastest paths to a reliable income with minimal education required.",
            steps: [
                "Enroll in a CDL training program (3–6 weeks)",
                "Pass the CDL written and skills tests",
                "Get your commercial driver's license",
                "Apply with trucking companies (many offer sign-on bonuses)",
                "Complete required supervised driving hours",
                "Choose your route type: local, regional, or OTR"
            ],
            fundingOptions: ["Company-sponsored CDL training", "WIOA grants", "Veterans CDL assistance programs"],
            whyAIResistant: "While autonomous trucks are developing, human drivers remain essential for complex routes, loading/unloading, last-mile delivery, and regulatory compliance."
        ),
        CareerPath(
            id: "cybersecurity",
            name: "Cybersecurity Analyst",
            icon: "lock.shield.fill",
            salaryRange: "$60K – $120K+",
            timeToIncome: "6–18 months",
            costRange: "$500 – $5K",
            overview: "Cybersecurity analysts protect organizations from digital threats. Massive skills gap means high demand and strong salaries even for career changers.",
            steps: [
                "Study networking and security fundamentals",
                "Earn CompTIA Security+ certification",
                "Build a home lab for hands-on practice",
                "Complete online courses (TryHackMe, HackTheBox)",
                "Apply for SOC Analyst or junior security roles",
                "Pursue advanced certs (CySA+, CISSP) for growth"
            ],
            fundingOptions: ["Free online training platforms", "Employer tuition reimbursement", "Government cyber workforce programs"],
            whyAIResistant: "While AI assists in threat detection, human analysts are essential for investigation, incident response, policy decisions, and adversarial thinking."
        ),
        CareerPath(
            id: "real_estate",
            name: "Real Estate Agent",
            icon: "house.fill",
            salaryRange: "$40K – $100K+",
            timeToIncome: "2–6 months",
            costRange: "$1K – $3K",
            overview: "Real estate agents help people buy, sell, and rent properties. Commission-based income with unlimited earning potential and flexible schedule.",
            steps: [
                "Complete your state's pre-licensing course",
                "Pass the real estate licensing exam",
                "Join a brokerage for mentorship and leads",
                "Build your sphere of influence and online presence",
                "Close your first transaction",
                "Develop a referral network for consistent deals"
            ],
            fundingOptions: ["Low-cost online pre-licensing courses", "Brokerage-sponsored training", "Self-funded (low barrier to entry)"],
            whyAIResistant: "Property showings, client relationships, negotiation, and local market expertise require human connection and judgment that AI supports but cannot replace."
        )
    ]
}
