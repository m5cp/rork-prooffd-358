import Foundation

enum DegreeCareerDatabase {
    static func lookup(_ pathId: String) -> DegreeCareerDetailData? {
        let id = pathId.lowercased()
        return allData[id]
    }

    static func lookupByEducationId(_ eduId: String) -> DegreeCareerDetailData? {
        let id = eduId.lowercased()
        return allData[id] ?? educationIdMap[id]
    }

    private static let educationIdMap: [String: DegreeCareerDetailData] = [
        "registered_nurse": allData["registered-nurse"] ?? allData["registered_nurse"]!,
        "physical_therapist": allData["physical-therapist"] ?? allData["physical_therapist"]!,
        "occupational_therapist": allData["occupational-therapist"] ?? allData["occupational_therapist"]!,
        "speech_pathologist": allData["speech-pathologist"] ?? allData["speech_pathologist"]!,
        "physician_assistant": allData["physician-assistant"] ?? allData["physician_assistant"]!,
        "nurse_practitioner": allData["nurse-practitioner"] ?? allData["nurse_practitioner"]!,
        "pharmacist": allData["pharmacist"]!,
        "dentist": allData["dentist"]!,
        "psychologist": allData["psychologist"]!,
        "social_worker": allData["social-worker"] ?? allData["social_worker"]!,
        "civil_engineer": allData["civil-engineer"] ?? allData["civil_engineer"]!,
        "mechanical_engineer": allData["mechanical-engineer"] ?? allData["mechanical_engineer"]!,
        "electrical_engineer": allData["electrical-engineer"] ?? allData["electrical_engineer"]!,
        "accountant_cpa": allData["accountant-cpa"] ?? allData["accountant_cpa"]!,
        "architect": allData["architect"]!,
        "radiologic_technologist": allData["radiologic-technologist"] ?? allData["radiologic_technologist"]!,
        "ultrasound_technician": allData["ultrasound-technician"] ?? allData["ultrasound_technician"]!,
    ]

    private static let allData: [String: DegreeCareerDetailData] = [
        "registered-nurse": DegreeCareerDetailData(
            pathId: "registered-nurse",
            degreeRequired: "Associate Degree in Nursing (ADN) or Bachelor of Science in Nursing (BSN)",
            degreeDetail: "ADN programs take 2–3 years; BSN programs take 4 years. BSN is increasingly preferred by hospitals and opens more advancement opportunities.",
            educationTimeline: "2–4 years",
            timelineDetail: "ADN is the fastest route to RN licensure. Many nurses complete an ADN first, then pursue a BSN online while working.",
            prerequisites: ["High school diploma with strong science grades", "Anatomy, physiology, and microbiology prerequisites", "CPR/BLS certification", "Background check and health screening"],
            licensingExamPath: ["Pass the NCLEX-RN examination", "Apply for state RN license", "Maintain license with continuing education"],
            clinicalRequirements: ["Clinical rotations in medical-surgical, pediatric, OB, mental health, and community nursing", "Supervised patient care hours during program", "Skills lab training for procedures and assessments"],
            earlyCareerPay: "$55K–$70K",
            establishedCareerPay: "$75K–$100K+",
            longTermUpside: "Nurse practitioners, CRNAs, and nurse managers can earn $110K–$200K+. Travel nursing offers premium pay.",
            aiResistantReasons: [
                "Direct patient care requires physical human presence",
                "Clinical judgment in complex, rapidly changing situations",
                "NCLEX licensure creates a regulated barrier to entry",
                "Patient trust and emotional support are inherently human",
                "Severe nationwide nursing shortage guarantees demand",
                "Hands-on procedures and assessments cannot be automated"
            ],
            demandStability: "Very strong — nursing shortages are projected to worsen through 2030+. Aging population and healthcare expansion drive consistent demand across all settings.",
            bestFitSummary: "Best for people who want a stable, meaningful career with strong earning potential, clear advancement paths, and the ability to work almost anywhere. Requires compassion, resilience, and comfort with high-pressure situations."
        ),

        "physical-therapist": DegreeCareerDetailData(
            pathId: "physical-therapist",
            degreeRequired: "Doctor of Physical Therapy (DPT)",
            degreeDetail: "DPT is a 3-year graduate program after completing a bachelor's degree. Entry-level practice now requires a doctoral degree.",
            educationTimeline: "7 years total (4-year bachelor's + 3-year DPT)",
            timelineDetail: "Undergraduate degree in exercise science, biology, or kinesiology is common. DPT programs are highly competitive with GPA and GRE requirements.",
            prerequisites: ["Bachelor's degree with prerequisite courses", "Anatomy, physiology, physics, statistics", "Observation hours in physical therapy settings", "GRE scores (most programs)"],
            licensingExamPath: ["Pass the National Physical Therapy Examination (NPTE)", "Apply for state PT license", "Complete continuing education for license renewal"],
            clinicalRequirements: ["Multiple full-time clinical rotations (30+ weeks total)", "Clinical experiences in orthopedic, neurological, and acute care settings", "Supervised patient treatment under licensed PTs"],
            earlyCareerPay: "$65K–$80K",
            establishedCareerPay: "$85K–$110K+",
            longTermUpside: "Specialized PTs (orthopedic, sports, neurological) and practice owners can earn $120K–$160K+.",
            aiResistantReasons: [
                "Hands-on manual therapy and exercise guidance require physical presence",
                "Every patient's movement patterns and recovery are unique",
                "DPT doctoral requirement creates a high education barrier",
                "State licensure and continuing education protect the profession",
                "Patient motivation and trust are inherently human interactions",
                "Growing demand from aging population and sports medicine"
            ],
            demandStability: "Strong — projected 15%+ growth. Aging baby boomers, sports injuries, and post-surgical rehab drive consistent demand.",
            bestFitSummary: "Best for people who enjoy movement, anatomy, and helping others recover. Requires long education commitment but offers strong job security, good work-life balance, and the satisfaction of measurable patient outcomes."
        ),

        "occupational-therapist": DegreeCareerDetailData(
            pathId: "occupational-therapist",
            degreeRequired: "Master of Occupational Therapy (MOT) or Doctoral (OTD)",
            degreeDetail: "Entry-level OT practice requires at minimum a master's degree. OTD programs are becoming more common and take an additional year.",
            educationTimeline: "6–7 years total (4-year bachelor's + 2–3 year graduate program)",
            timelineDetail: "Undergraduate degree in health sciences, psychology, or related field. OT programs require prerequisite courses and observation hours.",
            prerequisites: ["Bachelor's degree with prerequisites", "Anatomy, physiology, psychology, statistics", "Observation hours in OT settings", "GRE scores (varies by program)"],
            licensingExamPath: ["Pass the NBCOT certification exam", "Apply for state OT license", "Complete continuing education requirements"],
            clinicalRequirements: ["Level I and Level II fieldwork rotations", "Minimum 24 weeks of supervised clinical practice", "Experience across multiple practice settings"],
            earlyCareerPay: "$60K–$75K",
            establishedCareerPay: "$80K–$100K+",
            longTermUpside: "Specialized OTs and practice owners can earn $100K–$130K+. School-based and pediatric OT offer work-life balance.",
            aiResistantReasons: [
                "Adapting daily living activities requires hands-on human assessment",
                "Every patient's functional challenges are unique to their environment",
                "Graduate-level education and licensure create strong barriers",
                "Pediatric and geriatric populations need human connection",
                "Cognitive and sensory rehabilitation cannot be automated",
                "Growing demand in schools, hospitals, and home health"
            ],
            demandStability: "Strong — projected 12%+ growth. Pediatric services, aging population, and mental health demand drive expansion.",
            bestFitSummary: "Best for creative problem-solvers who want to help people regain independence in daily life. Offers diverse practice settings and strong work-life balance with meaningful patient relationships."
        ),

        "speech-pathologist": DegreeCareerDetailData(
            pathId: "speech-pathologist",
            degreeRequired: "Master's degree in Speech-Language Pathology (MS-SLP)",
            degreeDetail: "Entry-level SLP practice requires a master's degree from a CAA-accredited program. Programs are typically 2–3 years.",
            educationTimeline: "6–7 years total (4-year bachelor's + 2–3 year master's)",
            timelineDetail: "Undergraduate degree in communication sciences and disorders is ideal. Career changers may need prerequisite courses before graduate admission.",
            prerequisites: ["Bachelor's degree (communication sciences preferred)", "Prerequisites in anatomy, phonetics, linguistics", "Observation hours in speech therapy settings", "GRE scores (varies by program)"],
            licensingExamPath: ["Pass the Praxis Examination in Speech-Language Pathology", "Complete Clinical Fellowship Year (CFY)", "Obtain ASHA Certificate of Clinical Competence (CCC-SLP)", "Apply for state license"],
            clinicalRequirements: ["375+ hours of supervised clinical practicum", "Clinical Fellowship Year (36 weeks full-time)", "Experience with pediatric and adult populations"],
            earlyCareerPay: "$55K–$70K",
            establishedCareerPay: "$75K–$100K+",
            longTermUpside: "Travel SLPs, private practice owners, and specialized clinicians can earn $100K–$140K+.",
            aiResistantReasons: [
                "Speech and language therapy requires direct human interaction",
                "Every patient's communication challenges are unique",
                "Master's degree and clinical fellowship create high barriers",
                "Building rapport with pediatric patients is inherently human",
                "Swallowing disorders require hands-on clinical assessment",
                "School systems and hospitals have chronic SLP shortages"
            ],
            demandStability: "Very strong — projected 19%+ growth. Schools, early intervention programs, and aging population drive sustained demand.",
            bestFitSummary: "Best for patient, detail-oriented people who love language and communication. Excellent job security with diverse settings including schools, hospitals, private practice, and teletherapy."
        ),

        "physician-assistant": DegreeCareerDetailData(
            pathId: "physician-assistant",
            degreeRequired: "Master of Physician Assistant Studies (MPAS)",
            degreeDetail: "PA programs are typically 2–3 years of intensive graduate training including didactic and clinical phases. Programs are extremely competitive.",
            educationTimeline: "6–7 years total (4-year bachelor's + 2–3 year PA program)",
            timelineDetail: "Most applicants need a bachelor's degree plus substantial healthcare experience (1,000–3,000 patient care hours). Prerequisites are science-heavy.",
            prerequisites: ["Bachelor's degree with strong science GPA", "Anatomy, physiology, biochemistry, microbiology, statistics", "1,000–3,000+ hours of direct patient care experience", "GRE scores", "Letters of recommendation from healthcare providers"],
            licensingExamPath: ["Pass the Physician Assistant National Certifying Exam (PANCE)", "Apply for state PA license", "Recertify every 10 years with PANRE", "Complete 100 CME credits every 2 years"],
            clinicalRequirements: ["2,000+ hours of supervised clinical rotations", "Rotations in family medicine, internal medicine, surgery, emergency medicine, pediatrics, psychiatry, and women's health", "Supervised patient encounters across specialties"],
            earlyCareerPay: "$90K–$110K",
            establishedCareerPay: "$110K–$140K+",
            longTermUpside: "Specialized PAs (surgery, dermatology, emergency) can earn $140K–$180K+. Locum tenens and urgent care PAs often earn premium rates.",
            aiResistantReasons: [
                "Diagnosing and treating patients requires physical examination",
                "Clinical decision-making in complex, urgent situations",
                "State licensure and national certification create strong barriers",
                "Patient trust and bedside manner are inherently human",
                "Physician shortage is expanding PA scope of practice",
                "Procedures and in-person care cannot be automated"
            ],
            demandStability: "Excellent — one of the fastest-growing professions. Physician shortages and healthcare expansion create increasing demand for PAs across all specialties.",
            bestFitSummary: "Best for high achievers who want a medical career with less education time than physicians. Offers specialty flexibility, strong income, and the ability to switch specialties without additional residency."
        ),

        "nurse-practitioner": DegreeCareerDetailData(
            pathId: "nurse-practitioner",
            degreeRequired: "Master of Science in Nursing (MSN) or Doctor of Nursing Practice (DNP)",
            degreeDetail: "NP programs require an active RN license and BSN. MSN programs take 2–3 years; DNP programs take 3–4 years. Both qualify for NP certification.",
            educationTimeline: "6–8 years total (4-year BSN + 2–4 year graduate program)",
            timelineDetail: "Many NPs work as RNs while completing graduate school part-time. Direct-entry NP programs exist for career changers with non-nursing bachelor's degrees.",
            prerequisites: ["BSN degree and active RN license", "Clinical nursing experience (varies by program)", "Statistics and research courses", "Professional references"],
            licensingExamPath: ["Pass national NP certification exam (ANCC or AANP)", "Apply for state APRN license", "Maintain certification with continuing education", "DEA registration for prescribing"],
            clinicalRequirements: ["500–1,000+ supervised clinical hours during program", "Clinical rotations in specialty focus area", "Preceptorship with practicing NPs or physicians"],
            earlyCareerPay: "$95K–$115K",
            establishedCareerPay: "$115K–$140K+",
            longTermUpside: "Psychiatric NPs, CRNAs, and practice owners can earn $150K–$250K+. Independent practice authority in many states.",
            aiResistantReasons: [
                "Advanced clinical assessment requires hands-on examination",
                "Prescribing and managing complex conditions requires human judgment",
                "Doctoral-level education creates a significant barrier",
                "Full practice authority expanding NP independence",
                "Primary care shortage makes NPs essential providers",
                "Patient relationships and continuity of care are inherently human"
            ],
            demandStability: "Excellent — projected 40%+ growth. Primary care shortages, expanded scope of practice laws, and aging population drive exceptional demand.",
            bestFitSummary: "Best for experienced nurses who want to advance to provider-level practice. Offers high income, autonomy, and the ability to open an independent practice in many states."
        ),

        "pharmacist": DegreeCareerDetailData(
            pathId: "pharmacist",
            degreeRequired: "Doctor of Pharmacy (PharmD)",
            degreeDetail: "PharmD is a 4-year professional doctoral program. Some programs offer a 0–6 direct entry path from high school.",
            educationTimeline: "6–8 years total (2–4 years prerequisite + 4-year PharmD)",
            timelineDetail: "Most students complete 2+ years of undergraduate prerequisite coursework before entering a PharmD program. Direct-entry 0–6 programs accept students from high school.",
            prerequisites: ["Prerequisite college coursework (biology, chemistry, organic chemistry, physics, math)", "PCAT exam (Pharmacy College Admissions Test) for some programs", "Strong science GPA"],
            licensingExamPath: ["Pass the NAPLEX (North American Pharmacist Licensure Examination)", "Pass the MPJE (state-specific pharmacy law exam)", "Apply for state pharmacist license", "Complete continuing pharmacy education"],
            clinicalRequirements: ["Introductory Pharmacy Practice Experiences (IPPEs)", "Advanced Pharmacy Practice Experiences (APPEs) — 1,440+ hours", "Rotations in community, hospital, ambulatory care, and specialty settings"],
            earlyCareerPay: "$110K–$125K",
            establishedCareerPay: "$125K–$145K+",
            longTermUpside: "Specialty pharmacists, pharmacy directors, and pharmacy owners can earn $150K–$200K+.",
            aiResistantReasons: [
                "Medication therapy management requires clinical expertise",
                "Patient counseling on drug interactions and side effects",
                "PharmD doctoral requirement is a significant barrier",
                "Immunization and clinical services expanding pharmacist roles",
                "Drug compounding and IV preparation require hands-on skill",
                "Regulatory compliance demands licensed human oversight"
            ],
            demandStability: "Stable — pharmacist roles are evolving toward more clinical services, vaccinations, and patient care. Hospital and specialty pharmacy continue growing.",
            bestFitSummary: "Best for detail-oriented people who enjoy science and patient education. Strong income from day one with diverse career paths across retail, hospital, clinical, and industry settings."
        ),

        "dentist": DegreeCareerDetailData(
            pathId: "dentist",
            degreeRequired: "Doctor of Dental Surgery (DDS) or Doctor of Dental Medicine (DMD)",
            degreeDetail: "Dental school is a 4-year professional program after completing a bachelor's degree. Both DDS and DMD are equivalent degrees.",
            educationTimeline: "8 years total (4-year bachelor's + 4-year dental school)",
            timelineDetail: "Undergraduate degree with strong sciences. Dental Admission Test (DAT) required. Dental school includes 2 years of didactic and 2 years of clinical training.",
            prerequisites: ["Bachelor's degree with science prerequisites", "Biology, chemistry, organic chemistry, physics", "Dental Admission Test (DAT)", "Dental shadowing hours", "Strong science and overall GPA"],
            licensingExamPath: ["Pass the National Board Dental Examination (NBDE Parts I & II or INBDE)", "Pass a regional or state clinical board exam", "Apply for state dental license", "Complete continuing dental education"],
            clinicalRequirements: ["Preclinical simulation lab training", "Clinical patient care rotations (2 years)", "Community clinic rotations", "Specialty rotations (oral surgery, pediatric, ortho, etc.)"],
            earlyCareerPay: "$120K–$160K",
            establishedCareerPay: "$160K–$200K+",
            longTermUpside: "Practice owners and specialists (orthodontics, oral surgery, endodontics) can earn $250K–$500K+.",
            aiResistantReasons: [
                "Dental procedures require precise hands-on manual skill",
                "Every patient's oral anatomy and conditions are unique",
                "DDS/DMD doctoral requirement is a very high barrier",
                "State licensure and board exams regulate the profession",
                "Patient trust and comfort require human interaction",
                "Growing demand as population ages and dental care expands"
            ],
            demandStability: "Strong — dental services are recession-resistant. Growing population, aging demographics, and cosmetic dentistry trends drive steady demand.",
            bestFitSummary: "Best for people with excellent manual dexterity who want high income and business ownership potential. Long education path but offers autonomy, prestige, and strong financial returns."
        ),

        "psychologist": DegreeCareerDetailData(
            pathId: "psychologist",
            degreeRequired: "Doctoral degree (PhD or PsyD in Psychology)",
            degreeDetail: "Clinical psychology requires a doctoral degree. PhD programs focus on research and clinical training; PsyD programs emphasize clinical practice. Both qualify for licensure.",
            educationTimeline: "8–12 years total (4-year bachelor's + 4–6 year doctoral program + 1–2 year postdoctoral)",
            timelineDetail: "After a bachelor's in psychology, doctoral programs take 4–6 years. A 1–2 year supervised postdoctoral fellowship is required before licensure in most states.",
            prerequisites: ["Bachelor's degree in psychology or related field", "Research experience (especially for PhD)", "Statistics and research methods courses", "GRE scores", "Letters of recommendation"],
            licensingExamPath: ["Complete APA-accredited doctoral program", "Complete supervised postdoctoral hours (1,500–2,000)", "Pass the Examination for Professional Practice in Psychology (EPPP)", "Apply for state psychologist license"],
            clinicalRequirements: ["Supervised clinical practicum during doctoral program", "Pre-doctoral internship (1 year full-time)", "Post-doctoral supervised experience (1–2 years)", "Diverse clinical populations and settings"],
            earlyCareerPay: "$65K–$85K",
            establishedCareerPay: "$90K–$130K+",
            longTermUpside: "Private practice psychologists and neuropsychologists can earn $130K–$200K+. Forensic and organizational psychology offer premium pay.",
            aiResistantReasons: [
                "Therapy requires deep human empathy and rapport",
                "Every patient's mental health journey is unique and nuanced",
                "Doctoral-level education is one of the longest professional paths",
                "Licensure with supervised hours creates high barriers",
                "Psychological assessment requires trained human judgment",
                "Mental health demand is surging with reduced stigma"
            ],
            demandStability: "Very strong — mental health awareness and demand for psychological services are at all-time highs. Telehealth is expanding access and practice opportunities.",
            bestFitSummary: "Best for deeply curious, empathetic people committed to understanding human behavior. Long education path but offers profound personal fulfillment and growing demand."
        ),

        "social-worker": DegreeCareerDetailData(
            pathId: "social-worker",
            degreeRequired: "Master of Social Work (MSW)",
            degreeDetail: "Licensed clinical social work requires an MSW from a CSWE-accredited program. MSW programs are typically 2 years (1 year for advanced standing with a BSW).",
            educationTimeline: "6 years total (4-year bachelor's + 2-year MSW)",
            timelineDetail: "Bachelor's in social work (BSW) graduates may qualify for advanced standing MSW programs (1 year). Other bachelor's degrees require the full 2-year MSW program.",
            prerequisites: ["Bachelor's degree (BSW preferred but not required)", "Volunteer or work experience in human services", "Strong writing and interpersonal skills", "Background check"],
            licensingExamPath: ["Pass the ASWB clinical or master's exam", "Complete supervised clinical hours (2,000–4,000 depending on state)", "Apply for LCSW or LMSW license", "Complete continuing education for renewal"],
            clinicalRequirements: ["900+ hours of supervised field placement during MSW", "Clinical practicum in mental health, healthcare, or community settings", "2,000–4,000 post-graduate supervised clinical hours for LCSW"],
            earlyCareerPay: "$45K–$55K",
            establishedCareerPay: "$55K–$75K+",
            longTermUpside: "LCSWs in private practice can earn $80K–$120K+. Hospital social workers and directors earn more. Telehealth is expanding opportunities.",
            aiResistantReasons: [
                "Crisis intervention requires immediate human judgment",
                "Client advocacy and case management are relationship-based",
                "Licensed clinical practice requires extensive supervised training",
                "Vulnerable populations need human trust and empathy",
                "Court systems and child welfare require human social workers",
                "Mental health and substance abuse demand continues growing"
            ],
            demandStability: "Strong — projected 7%+ growth. Mental health demand, substance abuse services, and aging population drive consistent need.",
            bestFitSummary: "Best for compassionate advocates who want to make a direct impact on people's lives. Lower starting pay than some professions but offers deep fulfillment and growing private practice opportunities."
        ),

        "civil-engineer": DegreeCareerDetailData(
            pathId: "civil-engineer",
            degreeRequired: "Bachelor of Science in Civil Engineering (BSCE)",
            degreeDetail: "A 4-year ABET-accredited bachelor's degree is the standard entry point. A master's degree is valued for specialization but not required for licensure.",
            educationTimeline: "4 years (bachelor's) + 4 years work experience for PE license",
            timelineDetail: "After completing a bachelor's degree, engineers work under a licensed PE for 4 years before taking the PE exam. Many advance while working.",
            prerequisites: ["Strong math and science foundation (calculus, physics, chemistry)", "High school AP courses in math and science recommended", "SAT/ACT scores for college admission"],
            licensingExamPath: ["Pass the Fundamentals of Engineering (FE) exam during or after college", "Gain 4 years of progressive engineering experience under a PE", "Pass the Professional Engineer (PE) exam", "Maintain license with continuing education"],
            clinicalRequirements: ["Engineering internships or co-op experiences", "Senior design capstone project", "4 years supervised work under a PE for licensure"],
            earlyCareerPay: "$60K–$75K",
            establishedCareerPay: "$85K–$120K+",
            longTermUpside: "PE-licensed engineers, project managers, and firm principals can earn $130K–$200K+.",
            aiResistantReasons: [
                "Infrastructure design requires site-specific engineering judgment",
                "PE licensure creates a strong regulated barrier",
                "Construction site oversight requires physical presence",
                "Public safety accountability cannot be delegated to AI",
                "Massive infrastructure investment bills drive decades of demand",
                "Every project involves unique soil, environmental, and regulatory conditions"
            ],
            demandStability: "Excellent — infrastructure spending at historic highs. Bridges, roads, water systems, and climate resilience projects guarantee long-term demand.",
            bestFitSummary: "Best for analytical problem-solvers who want to build things that shape communities. Strong income growth, clear licensure path, and the satisfaction of seeing your work in the physical world."
        ),

        "mechanical-engineer": DegreeCareerDetailData(
            pathId: "mechanical-engineer",
            degreeRequired: "Bachelor of Science in Mechanical Engineering (BSME)",
            degreeDetail: "A 4-year ABET-accredited degree is standard. Master's degrees add specialization in robotics, aerospace, thermal systems, or manufacturing.",
            educationTimeline: "4 years (bachelor's)",
            timelineDetail: "Most mechanical engineers enter the workforce with a bachelor's degree. PE licensure is optional but valuable for consulting and public-facing work.",
            prerequisites: ["Strong foundation in calculus, physics, and chemistry", "Computer-aided design (CAD) skills", "AP courses in math and science recommended"],
            licensingExamPath: ["Pass the FE exam (optional but recommended)", "Gain 4 years of experience under a PE (optional)", "Pass the PE exam for licensed practice (optional)", "Industry certifications in specialties (Six Sigma, PMP)"],
            clinicalRequirements: ["Engineering internships or co-op programs", "Senior design capstone project", "Lab and workshop experiences"],
            earlyCareerPay: "$65K–$80K",
            establishedCareerPay: "$90K–$120K+",
            longTermUpside: "Senior engineers, engineering managers, and consultants can earn $130K–$180K+. Aerospace and defense specialties pay premium.",
            aiResistantReasons: [
                "Physical product design requires understanding real-world constraints",
                "Manufacturing and testing require hands-on engineering judgment",
                "Broadest engineering discipline with diverse applications",
                "Innovation in energy, robotics, and manufacturing drives demand",
                "PE licensure adds professional protection",
                "Cross-disciplinary problem-solving resists narrow AI automation"
            ],
            demandStability: "Strong — mechanical engineers work across every manufacturing sector. Clean energy, electric vehicles, robotics, and defense drive sustained demand.",
            bestFitSummary: "Best for people who love understanding how things work and designing physical solutions. The most versatile engineering degree with applications in nearly every industry."
        ),

        "electrical-engineer": DegreeCareerDetailData(
            pathId: "electrical-engineer",
            degreeRequired: "Bachelor of Science in Electrical Engineering (BSEE)",
            degreeDetail: "A 4-year ABET-accredited degree is standard. Master's degrees are common for semiconductor, RF, and power systems specialization.",
            educationTimeline: "4 years (bachelor's)",
            timelineDetail: "Bachelor's degree is sufficient for most positions. Graduate school is valuable for research, academia, and highly specialized roles.",
            prerequisites: ["Advanced math (through differential equations)", "Physics (especially electromagnetism)", "Computer programming fundamentals", "AP courses in math and science recommended"],
            licensingExamPath: ["Pass the FE exam (optional)", "PE licensure for power systems and utility work", "Industry certifications for specialized areas"],
            clinicalRequirements: ["Engineering internships or co-op programs", "Lab work in circuits, signals, and power systems", "Senior design capstone project"],
            earlyCareerPay: "$65K–$85K",
            establishedCareerPay: "$95K–$130K+",
            longTermUpside: "Senior EEs, power systems engineers, and semiconductor specialists can earn $140K–$200K+.",
            aiResistantReasons: [
                "Power grid and infrastructure design requires licensed human oversight",
                "Hardware design and testing require physical interaction",
                "Semiconductor and chip design involves complex physical constraints",
                "Electrification trends drive increasing demand",
                "Safety-critical systems require human accountability",
                "Cross-disciplinary integration resists pure AI automation"
            ],
            demandStability: "Strong — electrification of transportation, renewable energy, semiconductor manufacturing, and 5G/communications drive sustained demand.",
            bestFitSummary: "Best for analytical minds fascinated by electricity, electronics, and energy systems. High demand in power, semiconductors, and communications with strong starting salaries."
        ),

        "accountant-cpa": DegreeCareerDetailData(
            pathId: "accountant-cpa",
            degreeRequired: "Bachelor's degree in Accounting (150 credit hours for CPA)",
            degreeDetail: "A bachelor's in accounting is the foundation. CPA licensure requires 150 semester hours, which often means a master's degree or additional coursework beyond a standard 120-hour bachelor's.",
            educationTimeline: "4–5 years (bachelor's + additional credits for CPA eligibility)",
            timelineDetail: "Most students complete a bachelor's in accounting (4 years) then take additional graduate courses or a master's in accounting to reach the 150-hour CPA requirement.",
            prerequisites: ["Strong math and analytical skills", "Business and economics coursework", "Accounting courses in financial, managerial, tax, and audit"],
            licensingExamPath: ["Complete 150 semester hours of education", "Pass all four sections of the CPA Exam", "Complete required work experience under a licensed CPA (1–2 years)", "Apply for state CPA license", "Complete annual continuing professional education"],
            clinicalRequirements: ["Accounting internship (Big Four or regional firm preferred)", "1–2 years supervised experience under a licensed CPA", "Tax season and audit experience"],
            earlyCareerPay: "$55K–$70K",
            establishedCareerPay: "$80K–$120K+",
            longTermUpside: "Partners at accounting firms can earn $200K–$500K+. CFOs and controllers earn $150K–$300K+.",
            aiResistantReasons: [
                "Tax strategy and business advisory require human judgment",
                "Audit and compliance demand licensed professional accountability",
                "CPA licensure creates a regulated barrier to entry",
                "Complex financial situations require nuanced interpretation",
                "Client relationships and trust are central to the profession",
                "Regulatory changes create ongoing need for expert interpretation"
            ],
            demandStability: "Very strong — every business needs accounting services. Tax law complexity and regulatory requirements guarantee long-term demand. Severe CPA shortage currently.",
            bestFitSummary: "Best for detail-oriented, analytical people who want clear career progression. CPA designation opens doors to business leadership, high income, and diverse industry opportunities."
        ),

        "architect": DegreeCareerDetailData(
            pathId: "architect",
            degreeRequired: "Bachelor of Architecture (B.Arch) or Master of Architecture (M.Arch)",
            degreeDetail: "B.Arch is a 5-year professional degree. M.Arch is a 2–3 year graduate degree for those with a non-architecture bachelor's. Both qualify for licensure.",
            educationTimeline: "5–7 years (B.Arch or bachelor's + M.Arch) + 3 years internship",
            timelineDetail: "After completing a professional degree, architects must complete the Architectural Experience Program (AXP) — approximately 3,740 hours — before taking the ARE exam.",
            prerequisites: ["Strong foundation in math, physics, and art", "Portfolio for program admission (recommended)", "Computer skills (CAD, Revit, 3D modeling)"],
            licensingExamPath: ["Complete a NAAB-accredited degree", "Complete the Architectural Experience Program (AXP)", "Pass all divisions of the Architect Registration Examination (ARE)", "Apply for state architecture license"],
            clinicalRequirements: ["Design studio courses throughout program", "Architectural internship or work experience", "AXP — 3,740 hours across multiple experience areas"],
            earlyCareerPay: "$55K–$70K",
            establishedCareerPay: "$80K–$110K+",
            longTermUpside: "Partners at firms and sole practitioners can earn $130K–$250K+. Specialized architects (healthcare, data centers) command premiums.",
            aiResistantReasons: [
                "Building design involves complex human, cultural, and site-specific factors",
                "Client relationships and design communication are inherently human",
                "Licensed practice with ARE exam creates regulatory protection",
                "Construction administration requires on-site judgment",
                "Building codes, zoning, and sustainability require expert interpretation",
                "Creative design vision and problem-solving resist automation"
            ],
            demandStability: "Moderate to strong — cyclical with construction but sustained by population growth, sustainable design mandates, and urban development.",
            bestFitSummary: "Best for creative, technically-minded people who want to shape the built environment. Long path to licensure but offers a unique blend of art, engineering, and community impact."
        ),

        "radiologic-technologist": DegreeCareerDetailData(
            pathId: "radiologic-technologist",
            degreeRequired: "Associate or Bachelor's degree in Radiologic Technology",
            degreeDetail: "Associate degree programs take 2 years and qualify for ARRT certification. Bachelor's degrees provide advancement opportunities in management and specialized modalities.",
            educationTimeline: "2–4 years",
            timelineDetail: "Associate degree is the fastest path. Many techs start with an associate and complete a bachelor's online while working.",
            prerequisites: ["High school diploma with strong science grades", "Anatomy and physiology prerequisites", "College algebra", "CPR/BLS certification"],
            licensingExamPath: ["Graduate from a JRCERT-accredited program", "Pass the ARRT (American Registry of Radiologic Technologists) exam", "Apply for state license if required", "Complete continuing education for ARRT renewal"],
            clinicalRequirements: ["Clinical rotations in hospitals and imaging centers", "Supervised patient positioning and imaging procedures", "Experience with multiple imaging modalities"],
            earlyCareerPay: "$50K–$60K",
            establishedCareerPay: "$65K–$85K+",
            longTermUpside: "CT, MRI, and interventional techs can earn $80K–$100K+. Management and education roles offer $90K–$120K+.",
            aiResistantReasons: [
                "Patient positioning and imaging require hands-on human skill",
                "Every patient's anatomy and condition present unique challenges",
                "ARRT certification and state licensure create regulated barriers",
                "Radiation safety requires trained human oversight",
                "Patient comfort and communication are essential",
                "Growing imaging demand from aging population"
            ],
            demandStability: "Strong — medical imaging is essential to diagnosis. Aging population and advancing technology drive consistent demand.",
            bestFitSummary: "Best for people who enjoy technology and patient interaction. Faster education path than many healthcare careers with good pay and clear advancement through specialization."
        ),

        "ultrasound-technician": DegreeCareerDetailData(
            pathId: "ultrasound-technician",
            degreeRequired: "Associate or Bachelor's degree in Diagnostic Medical Sonography",
            degreeDetail: "Associate programs take 2 years; bachelor's programs take 4 years. CAAHEP-accredited programs are preferred by employers.",
            educationTimeline: "2–4 years",
            timelineDetail: "Associate degree is sufficient for entry. Bachelor's degree helps with career advancement and management opportunities.",
            prerequisites: ["High school diploma with science coursework", "Anatomy and physiology prerequisites", "Physics course recommended", "CPR/BLS certification"],
            licensingExamPath: ["Graduate from a CAAHEP-accredited program", "Pass the ARDMS (American Registry for Diagnostic Medical Sonography) exam", "Choose specialty credential (abdomen, OB/GYN, cardiac, vascular)", "Complete continuing education for credential maintenance"],
            clinicalRequirements: ["Clinical rotations in hospitals and imaging centers", "Supervised scanning experience across specialties", "Hands-on patient scanning and image optimization"],
            earlyCareerPay: "$55K–$65K",
            establishedCareerPay: "$70K–$90K+",
            longTermUpside: "Cardiac and vascular sonographers and travel techs can earn $90K–$110K+.",
            aiResistantReasons: [
                "Ultrasound scanning requires real-time hands-on technique",
                "Transducer manipulation and image optimization are manual skills",
                "Patient communication and positioning are essential",
                "ARDMS certification creates a regulated barrier",
                "Diagnostic interpretation supports but doesn't replace sonographers",
                "Non-invasive imaging demand continues growing"
            ],
            demandStability: "Very strong — projected 10%+ growth. Non-invasive imaging preference and aging population drive increasing demand.",
            bestFitSummary: "Best for detail-oriented people who enjoy direct patient interaction and medical technology. Good work-life balance with strong demand and competitive pay."
        ),
    ]
}
