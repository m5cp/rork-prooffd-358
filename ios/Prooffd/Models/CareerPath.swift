import Foundation

typealias CareerPath = EducationPath

enum CareerPathDatabase {
    static let all: [EducationPath] = EducationPathDatabase.all
}

enum EducationPathDatabase {
    static let all: [EducationPath] = trades + certifications + healthcare + technology

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
            id: "cybersecurity", title: "Cybersecurity Analyst", icon: "lock.shield.fill",
            category: .technology, aiSafeScore: 75,
            overview: "Cybersecurity analysts protect organizations from digital threats. Massive skills gap means high demand and strong salaries even for career changers.",
            typicalSalaryRange: "$60K – $120K+",
            testRequirements: ["CompTIA Security+", "CySA+ (advanced)", "CISSP (senior)"],
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
            id: "real_estate", title: "Real Estate Agent", icon: "house.fill",
            category: .business, aiSafeScore: 72,
            overview: "Real estate agents help people buy, sell, and rent properties. Commission-based income with unlimited earning potential and flexible schedule.",
            typicalSalaryRange: "$40K – $100K+",
            testRequirements: ["State pre-licensing course", "Real estate licensing exam"],
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
    ]

    static let certifications: [EducationPath] = [
        EducationPath(
            id: "personal_trainer", title: "Certified Personal Trainer", icon: "figure.strengthtraining.traditional",
            category: .certification, aiSafeScore: 82,
            overview: "Personal trainers design fitness programs and guide clients through exercises. Growing wellness industry with flexible work options.",
            typicalSalaryRange: "$35K – $70K+",
            testRequirements: ["NASM, ACE, or ISSA certification", "CPR/AED certification"],
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
            id: "insurance_agent", title: "Insurance Agent", icon: "shield.fill",
            category: .business, aiSafeScore: 65,
            overview: "Insurance agents sell and service insurance policies for individuals and businesses. Commission-based with residual income potential.",
            typicalSalaryRange: "$40K – $90K+",
            testRequirements: ["State insurance licensing exam"],
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
    ]

    static let healthcare: [EducationPath] = [
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
            id: "phlebotomist", title: "Phlebotomist", icon: "drop.fill",
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
    ]

    static let technology: [EducationPath] = [
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
            id: "project_manager", title: "Project Manager", icon: "list.clipboard.fill",
            category: .business, aiSafeScore: 62,
            overview: "Project managers plan, execute, and close projects across industries. Strong demand in tech, construction, and healthcare.",
            typicalSalaryRange: "$55K – $100K+",
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
