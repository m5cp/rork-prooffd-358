import Foundation

enum DocumentVaultDatabase {
    static let all: [VaultDocument] = legal + financial + marketing + guides

    static let legal: [VaultDocument] = [
        VaultDocument(
            id: "service-contract",
            title: "Simple Service Contract",
            icon: "doc.text.fill",
            category: .legal,
            description: "One-page agreement between you and a client for any service",
            content: """
SERVICE AGREEMENT

This Service Agreement is made as of [DATE] between:

SERVICE PROVIDER
Name / Business Name: [YOUR NAME OR BUSINESS NAME]
Address: [YOUR ADDRESS]
Phone: [YOUR PHONE]
Email: [YOUR EMAIL]

CLIENT
Name: [CLIENT FULL NAME OR BUSINESS NAME]
Address: [CLIENT ADDRESS]
Phone: [CLIENT PHONE]
Email: [CLIENT EMAIL]

1. SCOPE OF WORK
Provider agrees to perform the following services:
[DESCRIBE YOUR SERVICES IN SPECIFIC DETAIL]
Start Date: [DATE]
Estimated Completion / Service Period: [DATE or ONGOING]

2. PAYMENT
Total Agreed Price: $[AMOUNT]
Payment Schedule:
  Deposit (due at signing): $[AMOUNT]
  Final Payment (due on completion): $[AMOUNT]
  OR Per visit / per job rate: $[AMOUNT]
  Invoices due within [14 / 30] days of receipt
Late Payments: Balances unpaid after [30] days incur a 1.5% monthly late fee.
Accepted Payment Methods: [CASH / CHECK / ZELLE / VENMO / OTHER]

3. CANCELLATION
Either party may cancel this agreement with [14] days written notice.
If Client cancels after work has begun: Client owes for all work completed through the cancellation date. The initial deposit is non-refundable once work has started.
If Provider cancels: Provider will refund any prepaid amounts for work not yet performed.

4. CLIENT RESPONSIBILITIES
Client agrees to:
(a) Provide timely access to the work location or materials needed
(b) Communicate concerns or changes in writing
(c) Make payments on the schedule above
(d) Not hold Provider responsible for delays caused by Client failure to provide access, approvals, or required items

5. INDEPENDENT CONTRACTOR
Provider is an independent contractor, not an employee of Client. Provider is solely responsible for all taxes on amounts earned under this agreement.

6. LIABILITY
Provider's total liability under this agreement is limited to the total fees paid by Client in the 30 days prior to the claim. Provider is not liable for indirect, incidental, special, or consequential damages of any kind.

7. DISPUTES
Both parties agree to attempt to resolve any dispute through good-faith negotiation before pursuing other remedies. This agreement is governed by the laws of the State of [YOUR STATE].

8. ENTIRE AGREEMENT
This document is the complete agreement between the parties. Any changes must be made in writing and signed by both parties.

SIGNATURES
Provider Signature: _______________________ Date: ___________
Printed Name: _________________________________

Client Signature: _______________________ Date: ___________
Printed Name: _________________________________

NOTE: This is a general-purpose template suitable for service engagements under $5,000. For contracts involving intellectual property or recurring high-value services, consult a licensed attorney in your state before signing.
""",
            isPro: true
        ),
        VaultDocument(
            id: "nda-template",
            title: "Non-Disclosure Agreement",
            icon: "lock.doc.fill",
            category: .legal,
            description: "Mutual NDA to protect your ideas when meeting with partners",
            content: """
MUTUAL NON-DISCLOSURE AGREEMENT

This Non-Disclosure Agreement is entered into as of [DATE] between:

Party A: [YOUR FULL NAME OR BUSINESS NAME], Address: [ADDRESS]
Party B: [OTHER PARTY FULL NAME OR BUSINESS NAME], Address: [ADDRESS]

1. PURPOSE
The Parties wish to explore a potential business relationship involving [BRIEF DESCRIPTION]. In connection with this discussion, each Party may disclose confidential information to the other.

2. DEFINITION OF CONFIDENTIAL INFORMATION
Confidential Information means any non-public information disclosed by one Party to the other, whether orally, in writing, or by any other means, that is designated as confidential or that reasonably should be understood to be confidential. This includes business plans, pricing, customer lists, trade secrets, financial data, processes, methods, and technical information.

3. OBLIGATIONS
Each Party agrees to:
(a) Hold all Confidential Information in strict confidence
(b) Not disclose Confidential Information to any third party without prior written consent
(c) Use Confidential Information solely for the purpose described above
(d) Limit access to those who need to know it for the stated purpose

4. EXCLUSIONS
These obligations do not apply to information that:
(a) Was already publicly known at the time of disclosure
(b) Becomes publicly known through no fault of the receiving Party
(c) Was independently developed without use of the Confidential Information
(d) Is required to be disclosed by law or court order

5. TERM
This Agreement is effective as of the date signed and remains in effect for [2] years.

6. RETURN OF INFORMATION
Upon written request, each Party will promptly return or destroy all Confidential Information received from the other Party.

7. NO LICENSE
Nothing in this Agreement grants either Party any rights to the other's intellectual property except as expressly stated herein.

8. GOVERNING LAW
This Agreement is governed by the laws of the State of [YOUR STATE].

SIGNATURES
Party A Signature: _______________________ Date: ___________
Printed Name: _________________________________

Party B Signature: _______________________ Date: ___________
Printed Name: _________________________________

NOTE: This mutual NDA is suitable for early-stage business conversations. For agreements involving trade secrets, IP licensing, or investments over $50,000, have an attorney review before signing.
""",
            isPro: true
        ),
        VaultDocument(
            id: "llc-operating-agreement",
            title: "LLC Operating Agreement",
            icon: "building.2.fill",
            category: .legal,
            description: "Single-member LLC operating agreement template",
            content: """
OPERATING AGREEMENT OF [YOUR BUSINESS NAME] LLC

A [STATE] Limited Liability Company
Effective Date: [DATE]

ARTICLE I — FORMATION
1.1 Name: [YOUR BUSINESS NAME] LLC (the "Company")
1.2 State of Formation: [STATE], filed with Secretary of State on [DATE]
1.3 Principal Office: [YOUR ADDRESS]
1.4 Registered Agent: [YOUR NAME] at [ADDRESS]

ARTICLE II — MEMBER
2.1 Sole Member: [YOUR FULL LEGAL NAME], Address: [YOUR ADDRESS], Ownership: 100%
2.2 New members may only be admitted by written amendment to this Agreement.

ARTICLE III — PURPOSE
3.1 The Company is organized to engage in any lawful business activity permitted under the laws of [STATE], including: [BRIEF DESCRIPTION OF YOUR BUSINESS].

ARTICLE IV — MANAGEMENT
4.1 The Company shall be member-managed. The Member has full authority to make all decisions.
4.2 The Member is authorized to: open and manage bank accounts; enter into contracts; hire and terminate employees or contractors; acquire, lease, or dispose of Company assets.

ARTICLE V — CAPITAL AND FINANCES
5.1 Initial capital contribution: $[AMOUNT]
5.2 The Company shall maintain its own bank account(s) separate from the Member's personal accounts. Commingling of funds is prohibited.
5.3 Distributions may be taken at any time at the Member's sole discretion, provided the Company retains sufficient funds to meet obligations.

ARTICLE VI — TAX TREATMENT
6.1 As a single-member LLC, the Company will be treated as a disregarded entity for federal income tax purposes unless the Member elects otherwise.
6.2 The Member will report all Company income and expenses on Schedule C of their personal federal tax return.

ARTICLE VII — LIABILITY PROTECTION
7.1 The Member is not personally liable for Company debts beyond their capital contribution, except as required by law.
7.2 To maintain protection: keep Company and personal finances separate; sign contracts in the Company name; maintain adequate capitalization.

ARTICLE VIII — DISSOLUTION
8.1 The Company shall dissolve upon written decision of the Member, death or incapacity of the Member, or as required by law.

ARTICLE IX — GENERAL PROVISIONS
9.1 Amendments must be in writing and signed by the Member.
9.2 Governing law: State of [STATE].

SIGNATURE
Sole Member:
Signature: _______________________ Date: ___________
Printed Name: _________________________________

IMPORTANT NOTES:
- File your Articles of Organization with your state BEFORE using this agreement
- This agreement is NOT filed with the state — keep it in your records
- Get an EIN free at IRS.gov — takes 5 minutes
- Open a separate business bank account immediately
""",
            isPro: true
        )
    ]

    static let financial: [VaultDocument] = [
        VaultDocument(
            id: "invoice-template",
            title: "Invoice Template",
            icon: "doc.richtext.fill",
            category: .financial,
            description: "Professional invoice you can fill in and send to any client",
            content: """
INVOICE

FROM:
[YOUR NAME / BUSINESS NAME]
[Your Address]
[City, State, ZIP]
[Your Phone] | [Your Email]

TO:
[CLIENT NAME / BUSINESS NAME]
[Client Address]
[City, State, ZIP]

Invoice #:     [0001]
Invoice Date:  [MM/DD/YYYY]
Due Date:      [MM/DD/YYYY]

---
SERVICES RENDERED
---
Description                         Qty    Rate      Amount
[Service or item description]        1    $[rate]   $[total]
[Service or item description]        1    $[rate]   $[total]
[Service or item description]        1    $[rate]   $[total]
---
                                          Subtotal: $[0.00]
                          Tax ([X]% if applicable): $[0.00]
                                 Discount (if any): -$[0.00]
---
                                      TOTAL DUE:    $[0.00]

PAYMENT INSTRUCTIONS:
Zelle: [your phone or email]
Venmo: @[yourhandle]
Cash or Check payable to: [Your Name]

Payment is due by [DUE DATE]. Late payments after 30 days are subject to a 1.5% monthly late fee.

NOTES:
[Any project notes, warranty info, or thank you message]

Thank you for your business!

HOW TO USE:
1. Fill in all [BRACKETED] fields
2. Add or delete service rows as needed
3. Screenshot or print to PDF (use your phone's print function and select Save as PDF)
4. Email or text the PDF to your client
5. Keep a copy for your records
""",
            isPro: false
        ),
        VaultDocument(
            id: "pricing-sheet",
            title: "Pricing & Offer Sheet",
            icon: "tag.fill",
            category: .financial,
            description: "Template to define your services, packages, and rates",
            content: """
[YOUR BUSINESS NAME]
[YOUR TAGLINE — one sentence about what you do]

[Your Phone] | [Your Email] | [Your City/Area]

---
OUR SERVICES
---

BASIC — $[PRICE]
Best for: [TYPE OF CUSTOMER]
Includes:
  - [What's included]
  - [What's included]
  - [What's included]
Turnaround: [TIME]

STANDARD — $[PRICE]  (Most Popular)
Best for: [TYPE OF CUSTOMER]
Everything in Basic, plus:
  - [Additional item]
  - [Additional item]
  - [Additional item]
Turnaround: [TIME]

PREMIUM — $[PRICE]
Best for: [TYPE OF CUSTOMER]
Everything in Standard, plus:
  - [Additional item]
  - [Additional item]
  - [Priority scheduling / dedicated service]
Turnaround: [TIME]

---
ADD-ON SERVICES
---
[Add-On Service 1] .......... $[PRICE]
[Add-On Service 2] .......... $[PRICE]
[Add-On Service 3] .......... $[PRICE]

---
FREQUENTLY ASKED QUESTIONS
---
How do I get started?
Contact us at [PHONE/EMAIL]. We will discuss your needs, confirm the right package, and schedule your start.

How do I pay?
We accept [PAYMENT METHODS]. Payment is due [WHEN].

Do you offer discounts?
[Your discount policy]

What if I am not satisfied?
[Your satisfaction guarantee]

Are you insured?
[Your insurance status]

---
WHY [YOUR BUSINESS NAME]?
[2-3 sentences about what makes you different. Be specific.]

READY TO GET STARTED?
[YOUR PHONE]
[YOUR EMAIL]
[YOUR WEBSITE / SOCIAL]

HOW TO USE: Print it and hand to prospects, convert to PDF and email to leads, or post on social media.
""",
            isPro: true
        ),
        VaultDocument(
            id: "revenue-log",
            title: "90-Day Revenue Log",
            icon: "chart.bar.doc.horizontal.fill",
            category: .financial,
            description: "Track every dollar you earn in your first 90 days",
            content: """
MY 90-DAY REVENUE TRACKER
Business Name: [YOUR BUSINESS NAME]
Start Date: [DATE]
Goal: $[YOUR 90-DAY TARGET]

HOW TO USE:
- Record every dollar you earn, no matter how small
- Update at the end of each day or after each job
- This is your proof of momentum

---
DAYS 1-30
---
Date | Client | Service Provided | Amount | Notes
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______

MONTH 1 TOTAL: $__________

---
DAYS 31-60
---
Date | Client | Service Provided | Amount | Notes
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______

MONTH 2 TOTAL: $__________
RUNNING TOTAL: $__________

---
DAYS 61-90
---
Date | Client | Service Provided | Amount | Notes
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______
_____ | __________________ | ______________________ | $______ | ______

MONTH 3 TOTAL: $__________

---
90-DAY SUMMARY
---
Total Revenue Earned:       $__________
Number of Clients Served:   __________
Average Per Client:         $__________

MILESTONES — CHECK THESE OFF:
[ ] First dollar earned
[ ] First $100
[ ] First $500
[ ] First $1,000  — This is the mindset shift. Celebrate this.
[ ] First $2,500
[ ] First $5,000
[ ] First $10,000

LESSONS LEARNED:
What worked best to get clients?
What took longer than expected?
What would you do differently?
""",
            isPro: false
        )
    ]

    static let marketing: [VaultDocument] = [
        VaultDocument(
            id: "email-kit",
            title: "First Client Email Kit",
            icon: "envelope.fill",
            category: .marketing,
            description: "5 proven outreach emails for landing your first clients",
            content: """
FIRST CLIENT EMAIL KIT — 5 Templates

---
EMAIL 1: THE NEIGHBOR APPROACH
Best for: Local service businesses
When: To people in your neighborhood or local community
---
Subject: Local [SERVICE] — Quick Question

Hi [NAME],

My name is [YOUR NAME] and I just started offering [YOUR SERVICE] in [NEIGHBORHOOD/CITY].

I noticed you are in the area and wanted to reach out personally. I am not a big company — just a local person who [one sentence about your background].

I am offering [free first visit / free estimate / introductory rate of $X] to a few neighbors this month so I can build my portfolio and get some word of mouth going.

Would you be open to a quick conversation or a free estimate? No pressure at all — I just figure if I do great work, you might tell a friend.

Thanks for your time.
[YOUR NAME]
[YOUR PHONE]
[YOUR EMAIL]

---
EMAIL 2: THE REFERRAL REQUEST
Best for: Asking people you already know to spread the word
When: Before you have any clients
---
Subject: Small favor — would mean a lot

Hey [NAME],

Hope you are doing well. I recently started [YOUR BUSINESS NAME / offering YOUR SERVICE] and I am looking for my first few clients.

If you know anyone who might need [DESCRIBE YOUR SERVICE IN ONE SENTENCE], I would be incredibly grateful if you could pass my name along.

Here is what I offer:
- [Service 1]
- [Service 2]
- [Price range or starting at $X]

You can just forward this email or share my number: [YOUR PHONE].

Thanks so much — I really appreciate it.
[YOUR NAME]

---
EMAIL 3: THE FOLLOW-UP
Best for: Following up when someone did not reply
When: 5-7 days after your first outreach
---
Subject: Re: [ORIGINAL SUBJECT LINE]

Hi [NAME],

Just wanted to bump this up in case it got buried. No worries if the timing is not right.

Quick recap: I am [YOUR NAME], offering [SERVICE] in [AREA]. I am still offering [free estimate / introductory rate] for new clients this month.

If you are interested, the easiest next step is a quick call or text: [YOUR PHONE].

Either way, hope you have a great week.
[YOUR NAME]

---
EMAIL 4: THE PROBLEM-SOLUTION
Best for: Cold outreach where you have spotted a specific need
When: When you have done your research on the recipient
---
Subject: Quick question about [SPECIFIC THING YOU NOTICED]

Hi [NAME],

My name is [YOUR NAME]. I [saw your listing / drive by your property / found your business] and noticed [SPECIFIC THING].

I specialize in [SERVICE] for [TYPE OF CUSTOMER] in [AREA]. I am local, reliable, and I offer a free first estimate with no obligation.

Would you be open to a quick call to see if it is a fit?

[YOUR NAME]
[YOUR PHONE]
[YOUR EMAIL]

---
EMAIL 5: THE FREE AUDIT OFFER
Best for: Cold outreach where you can provide a quick free assessment
When: Prospects who might not know they need you yet
---
Subject: Free [ASSESSMENT/ESTIMATE] — no catch

Hi [NAME],

I am [YOUR NAME], a local [YOUR SERVICE TYPE] in [AREA].

I would like to offer you a completely free [15-minute walk-through / quick assessment / no-obligation estimate].

What you get from the free visit:
- [Specific thing you will assess]
- [Another specific thing]
- A written quote if you would like to move forward

There is no pitch, no pressure. I do this because I would rather show you what I can do than just tell you.

Interested? Just reply here or text me at [YOUR PHONE].

[YOUR NAME]

---
TIPS FOR ALL EMAILS:
- Personalize every email — even one specific detail makes a huge difference
- Send from a professional email if possible
- Follow up exactly once if you do not hear back, then let it go
- Track who you contacted and when in your 90-Day Revenue Log
""",
            isPro: true
        ),
        VaultDocument(
            id: "review-scripts",
            title: "Review & Referral Scripts",
            icon: "star.fill",
            category: .marketing,
            description: "Scripts to ask happy clients for reviews and referrals",
            content: """
HOW TO GET REVIEWS AND REFERRALS

The best time to ask is within 24-48 hours of completing great work.

---
SCRIPT 1: TEXT MESSAGE — Review Request
Best for: Google, Yelp, or Facebook reviews
Timing: Within 24 hours of completing the job
---
"Hi [NAME]! It was great working with you today. If you have 60 seconds, it would mean the world to me if you left a quick review on Google — it really helps my small business grow. Here is the direct link: [YOUR GOOGLE REVIEW LINK]. No pressure at all, and thank you either way! — [YOUR NAME]"

How to get your Google review link:
1. Search for your business on Google Maps
2. Click "Get more reviews"
3. Copy the link and shorten it with bit.ly if needed

---
SCRIPT 2: EMAIL — Testimonial Request
Best for: Getting a written quote you can use on your website or social media
Timing: 2-3 days after completing the job
---
Subject: Quick request — would you share your experience?

Hi [NAME],

I hope you are happy with how everything turned out.

I am building my business and testimonials from satisfied clients are incredibly valuable. Would you be willing to write 2-3 sentences about your experience?

If it helps, here are some things you could mention:
- What you needed done and why you chose me
- What the experience was like
- Whether you would recommend me and to whom

You can just reply to this email with your words.

Thank you so much.
[YOUR NAME]

---
SCRIPT 3: IN-PERSON — Referral Request
Best for: Asking a happy client if they know anyone else
Timing: Right after finishing the job, when they are most satisfied
---
What to say:
"I am so glad everything worked out well. I am growing mostly through word of mouth, so if you know anyone else who might need [YOUR SERVICE], I would love if you could mention my name. I will take great care of anyone you send my way."

Then hand them 2-3 business cards or ask: "Would it be okay if I followed up with you in a month just in case anyone comes to mind?"

---
REFERRAL INCENTIVE IDEA (optional):
"If you refer someone who books with me, I will take $[AMOUNT] off your next service as a thank you."

---
WHERE TO COLLECT REVIEWS:
- Google Business Profile — most valuable for local businesses
- Yelp — important for food, home services, beauty
- Facebook Business Page — good for community visibility
- Nextdoor Recommendations — powerful for neighborhood services

---
HOW TO RESPOND TO REVIEWS:
Positive: "Thank you so much, [NAME]! It was a pleasure working with you. Looking forward to serving you again."

Negative: "Thank you for the feedback, [NAME]. I am sorry your experience did not meet expectations. Please reach out to me directly at [PHONE/EMAIL] so I can make it right."

Never argue publicly. One gracious response to a negative review builds more trust than five positive ones.
""",
            isPro: true
        )
    ]

    static let guides: [VaultDocument] = [
        VaultDocument(
            id: "how-to-form-llc",
            title: "How to Form an LLC",
            icon: "building.2.crop.circle.fill",
            category: .guides,
            description: "Step-by-step walkthrough — real costs, no surprises",
            content: """
HOW TO FORM AN LLC — A PLAIN-ENGLISH GUIDE
What to expect, what it costs, and what to watch out for.

⚠ IMPORTANT DISCLAIMER
All fees and costs in this guide are general estimates
based on typical ranges. Actual costs vary significantly
by state, county, and city and change over time.
Always verify current fees and requirements directly
with your state's official Secretary of State website
and your local city or county offices before filing
anything. This guide is for educational purposes only
and is not legal or financial advice.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WHAT YOU ARE ACTUALLY SETTING UP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
An LLC (Limited Liability Company) is a legal entity
that separates you from your business. It is created
by filing a document called Articles of Organization
with your state government and paying a filing fee.

Once formed, your business exists as its own legal
entity. This means:
  - Business debts are generally the business's
    responsibility, not yours personally
  - Contracts are signed in the company's name
  - The business has its own tax ID (EIN)
  - Business and personal finances are kept separate

An LLC does not manage itself. You have to maintain
it properly or the protections it offers can be lost.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
THE REAL COST BREAKDOWN (ESTIMATES ONLY)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
The costs below are general estimates. Your actual
costs depend entirely on your state, county, and city.
Check all fees with official government sources before
budgeting — do not rely solely on what any third-party
service quotes you.

ONE-TIME SETUP COSTS:

  State filing fee (Articles of Organization)
    → Estimated range: $50–$500
    → Varies widely by state
    → This fee is paid directly to your state
    → See the state table below for rough estimates
    → Always verify the current amount at your state's
      official Secretary of State website

  Registered agent
    → Every LLC is required to have a registered agent
      in its state of formation
    → A registered agent receives official legal and
      government documents on behalf of your business
    → You can serve as your own registered agent if
      you have a physical street address (not a P.O.
      Box) in your state and are available during
      normal business hours
    → If you prefer not to serve as your own, you can
      hire a registered agent service — fees vary
    → This is not optional — every LLC must have one

  EIN (Employer Identification Number)
    → This is always free — apply at IRS.gov
    → Takes approximately 5 minutes online
    → You need this to open a business bank account
      and to file taxes

  Operating Agreement
    → A written document outlining how your LLC is
      managed and owned
    → Some states legally require it — others do not
    → Even where not required, it is strongly
      recommended for your own protection
    → See the LLC Operating Agreement template in
      this Document Vault (Documents → Legal)
    → Cost ranges from free (template) to several
      hundred dollars (attorney-drafted)

  Business bank account
    → Required to keep business and personal
      finances properly separated
    → Fees vary by bank and account type
    → Shop around — many banks offer business
      checking options at various price points

  Business license (city or county)
    → Many cities and counties require one even for
      home-based businesses
    → Cost varies by location — typically $20–$100
      per year in many areas but can be higher
    → Check your city hall or county clerk website
      for your specific requirements

TOTAL ONE-TIME SETUP (rough estimate):
  Do-it-yourself minimum: $50–$200 in most states
  With professional assistance: $300–$1,500+
  Actual cost depends entirely on your state and
  what services you choose to use

ANNUAL ONGOING COSTS (estimates):

  State annual report or renewal fee
    → Most states require a yearly or biennial
      filing to keep your LLC active
    → Estimated range: $0–$500+ per year
    → Some states charge very little or nothing
    → Some states are significantly more expensive
    → Missing this filing can result in your LLC
      being administratively dissolved

  Registered agent renewal (if using a service)
    → Varies by provider

  Business license renewal
    → Varies by city and county

  Tax preparation
    → Varies depending on complexity and whether
      you use a CPA or file yourself

TOTAL ANNUAL ONGOING (rough estimate):
  Low: $0–$100 per year in low-fee states
  Typical: $100–$300 per year
  High-cost states: $500–$1,000+ per year

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
STATE FILING FEE ESTIMATES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
These are rough estimates only. Fees change and
vary. Always verify the current amount at your
state's official Secretary of State website before
filing. Searching "[YOUR STATE] LLC formation" or
"[YOUR STATE] Secretary of State" will get you there.

⚠ These numbers are approximate and may be outdated.
Do not use them for budgeting without verifying.

GENERALLY LOWER FEES (roughly $50–$100):
  Arizona, Colorado, Hawaii, Iowa, Kentucky,
  Mississippi, Missouri, Montana, New Mexico,
  Michigan, Ohio

MID-RANGE FEES (roughly $100–$200):
  Alabama, Alaska, Connecticut, Florida, Georgia,
  Idaho, Illinois, Indiana, Kansas, Louisiana,
  Maine, Maryland, Minnesota, Nevada, New Hampshire,
  New Jersey, New York, North Carolina, North Dakota,
  Pennsylvania, Rhode Island, South Carolina,
  South Dakota, Utah, Vermont, Virginia, Washington,
  West Virginia, Wisconsin, Wyoming

HIGHER FEES (roughly $200–$500+):
  California, Delaware, Massachusetts, Tennessee,
  Texas

SPECIAL SITUATIONS:
  California: Has a minimum $800 per year franchise
    tax regardless of revenue — important to know
    before forming here
  New York: Requires new LLCs to publish a formation
    notice in local newspapers — this can add
    significant cost depending on the county
  Nevada: Requires a state business license in
    addition to the filing fee

Again — these are rough estimates only. Verify
everything with your state before filing.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
STEP-BY-STEP: HOW TO FORM YOUR LLC
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 1: CHOOSE YOUR STATE
Form your LLC in the state where you live and do
business. Forming in a different state typically
adds complexity and cost for small local businesses.
Research your specific state's requirements before
deciding otherwise.

STEP 2: CHOOSE YOUR BUSINESS NAME
  - Must include "LLC," "L.L.C.," or "Limited
    Liability Company"
  - Must be unique in your state — check availability
    on your Secretary of State website
  - Cannot include certain restricted words like
    "Bank" or "Insurance" without special approval
  - Check that a matching domain name and social
    handles are available at the same time

STEP 3: DECIDE ON YOUR REGISTERED AGENT
  - Every LLC must designate a registered agent
  - You can serve as your own if you have a
    physical in-state address and are consistently
    available during business hours
  - If you prefer privacy or travel frequently,
    registered agent services are available at
    various price points — research your options
  - This is a legal requirement, not optional

STEP 4: FILE YOUR ARTICLES OF ORGANIZATION
  - Go to your state's official Secretary of State
    website and locate the LLC formation section
  - Complete the online or paper form — typically
    asks for your LLC name, registered agent
    information, organizer details, and business
    address
  - Pay the state filing fee
  - Processing times vary by state — from same
    day to several weeks

STEP 5: GET YOUR EIN
  - Apply at IRS.gov at no cost
  - Available immediately upon completion online
  - You will need this to open a business bank
    account and for tax purposes

STEP 6: CREATE YOUR OPERATING AGREEMENT
  - Use the LLC Operating Agreement template
    in this Document Vault under Documents → Legal
  - Keep it with your business records
  - Bring it when opening a business bank account
  - Some states legally require this document

STEP 7: OPEN A BUSINESS BANK ACCOUNT
  - Bring your EIN confirmation, Articles of
    Organization, Operating Agreement, and ID
  - Never mix personal and business funds — this
    is critical for maintaining liability protection
  - Compare business checking options at your
    bank or credit union

STEP 8: GET ANY REQUIRED BUSINESS LICENSES
  - Check with your city hall and county clerk
  - Some industries require additional state
    licenses — see the Licenses & Permits Guide
    in this vault

STEP 9: SET UP BASIC BOOKKEEPING
  - Track income and expenses from day one
  - Set aside a portion of every payment for taxes
    — as a self-employed LLC owner you are
    responsible for self-employment tax in addition
    to income tax
  - Consult a CPA or tax professional before your
    first tax season

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
THINGS THAT OFTEN SURPRISE NEW LLC OWNERS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. FORMATION SERVICES ADD THEIR OWN FEES
   Many LLC formation services advertise at a low
   price but do not prominently display the state
   filing fee on top. The total cost is their
   service fee plus the state fee. Ask for the
   complete total before proceeding with any service.

2. ANNUAL REPORTS ARE NOT OPTIONAL
   Most states require an annual or biennial report
   with a fee to keep your LLC active. Missing it
   can result in your LLC being dissolved by the
   state. Set a calendar reminder for your due date
   and verify it with your Secretary of State.

3. AN LLC DOES NOT AUTOMATICALLY PROTECT YOU
   Liability protection only works if you maintain
   proper separation between personal and business.
   Mixing funds, signing personal guarantees, or
   operating improperly can allow courts to hold
   you personally liable regardless of the LLC.
   Keep accounts separate. Always sign contracts
   as a representative of the LLC, not personally.

4. YOU STILL PAY SELF-EMPLOYMENT TAX
   A single-member LLC taxed as a disregarded
   entity does not reduce self-employment tax on
   its own. You still pay SE tax on net profit.
   An S-Corp election may reduce this once your
   income reaches a certain level — see the
   LLC vs Sole Prop vs S-Corp guide in this vault.

5. FORMATION SERVICES ARE NOT ATTORNEYS
   LLC formation and registered agent services
   prepare and file documents — they do not
   provide legal advice. If your business has
   partners, investors, employees, or intellectual
   property, consult a licensed attorney for your
   specific situation.

6. CALIFORNIA AND NEW YORK HAVE SPECIAL RULES
   California has a minimum annual franchise tax
   that applies regardless of revenue. New York
   has a publication requirement that adds cost.
   If you are in either state, research these
   requirements specifically before forming.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
USING A FORMATION SERVICE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
LLC formation services can be a convenient option
if you prefer to have the filing handled for you.
They vary in price, speed, and what is included.

If you use one, ask these questions first:
  - What is the total cost including the state fee?
  - Is registered agent service included and for
    how long?
  - What happens after the first year — are there
    renewal charges?
  - Do they notify you about annual report deadlines?

You can also file directly through your state's
Secretary of State website without using any
service. The process is the same — you fill out
the form and pay the filing fee directly.

Both approaches are valid. The right choice depends
on how much time you want to spend and whether you
prefer hands-on or hands-off.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NEXT STEPS AFTER FORMING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. Complete the LLC Operating Agreement template
     (Documents → Legal in this vault)
  2. Review the Licenses & Permits Guide
     (Documents → Guides) for what else you may need
  3. Open a business bank account as soon as possible
  4. Set up basic bookkeeping before your first invoice
  5. Speak with a CPA before your first tax season

Remember: forming the LLC is just the beginning.
Maintaining it properly — keeping finances separate,
filing annual reports on time, and operating in the
company's name — is what actually protects you.
""",
            isPro: false
        ),
        VaultDocument(
            id: "llc-vs-sole-prop",
            title: "LLC vs Sole Prop vs S-Corp",
            icon: "building.columns.fill",
            category: .guides,
            description: "Plain-English guide to choosing your business structure",
            content: """
WHICH BUSINESS STRUCTURE IS RIGHT FOR YOU?

---
OPTION 1: SOLE PROPRIETORSHIP
---
What it is: The simplest structure. You and your business are legally the same entity. There is nothing to file — you already are one if you are doing business without a formal structure.

Best for:
- Just starting out with low risk
- Testing a business idea
- Side income under $20,000/year
- No employees and minimal liability risk

How taxes work: Business income is reported on Schedule C of your personal tax return. You pay income tax plus self-employment tax (15.3%) on net profit.

The big problem: There is NO separation between you and your business. If someone sues your business, they can come after your personal assets.

Cost to set up: $0 federal, possibly a local business license ($20-$100)

---
OPTION 2: LLC (LIMITED LIABILITY COMPANY)
---
What it is: A legal entity that separates you from your business. Your personal assets are protected if someone sues the business, as long as you keep finances separate.

Best for:
- Any service business with customer contact or risk
- Anyone earning over $20,000/year
- Anyone who wants to look more professional

How taxes work: Same as sole proprietorship by default — income flows through to your personal return (Schedule C).

Cost to set up: $50-$500 depending on your state
Ongoing: Annual report in most states ($0-$300/year)

How to form one:
1. Choose a business name (check your state Secretary of State website)
2. File Articles of Organization online
3. Get an EIN free at IRS.gov — takes 5 minutes
4. Open a business bank account
5. Create an operating agreement (use the template in this vault)

---
OPTION 3: S-CORPORATION ELECTION
---
What it is: A tax election you make for an LLC or corporation by filing IRS Form 2553. Can save significant money on self-employment taxes once you are earning enough.

Best for: Business owners with net profit over $40,000-$50,000/year

How the savings work: As a default LLC you pay 15.3% self-employment tax on ALL net profit. As an S-Corp you pay yourself a reasonable salary and pay payroll taxes only on that salary. Additional profit taken as a distribution is NOT subject to self-employment tax. On $80,000 net profit with a $50,000 salary you could save $4,500+ per year.

The catch: More admin — you must run payroll, file quarterly payroll taxes, and file a separate S-Corp tax return. You will likely need a CPA.

---
QUICK COMPARISON
---
                   Sole Prop    LLC        S-Corp
Liability:             NO        YES         YES
Setup cost:            $0      $50-500    Same as LLC
Tax return:         Sched C    Sched C    Form 1120-S
Self-employ tax:      Full       Full    On salary only
Paperwork:           Light    Moderate      More
Best when profit:      Any        Any       $50K+

THE SIMPLE ANSWER:
- Just starting with low income/risk: Sole Prop
- Any real business with customers: LLC
- Earning $50,000+ net profit: Talk to a CPA about S-Corp

NOTE: Tax laws change and vary by state. Before making a structural decision, spend one hour with a local CPA or use a service like 1-800Accountant or Bench for low-cost guidance.
""",
            isPro: false
        ),
        VaultDocument(
            id: "licensing-guide",
            title: "Licenses & Permits Guide",
            icon: "checkmark.seal.fill",
            category: .guides,
            description: "What licenses and permits your business actually needs",
            content: """
WHAT LICENSES AND PERMITS DOES YOUR BUSINESS NEED?

---
THE 4 MOST COMMON REQUIREMENTS
---

1. BUSINESS LICENSE (General)
Almost every city and county requires one, even if you work from home.
Cost: Usually $20-$100/year
Where to get it: Search "[YOUR CITY] business license" or go to your city hall website.

2. DBA (DOING BUSINESS AS)
If you operate under a name other than your legal name, you may need to file a DBA.
Example: If your name is John Smith but your business is "Smith's Landscaping" you need a DBA.
Cost: $10-$100. File with your county clerk.

3. EIN (EMPLOYER IDENTIFICATION NUMBER)
Like a Social Security Number for your business. Required if you hire employees or form an LLC.
Cost: FREE. Apply at IRS.gov in 5 minutes.

4. STATE TAX REGISTRATION
If your state has a sales tax and you sell goods or taxable services, you may need a seller's permit.
Cost: Usually free to register.
Where: Your state's Department of Revenue website.

---
BY BUSINESS TYPE
---

HOME SERVICES (Cleaning, Landscaping, Painting, Handyman):
- General business license
- DBA if using a trade name
- Contractor's license if doing structural work (varies by state)
- General liability insurance ($50-$100/month for basic coverage)

FOOD BUSINESSES (Baking, Catering, Food Truck):
- General business license
- Food Handler's Permit (usually online course, $15-$25)
- State Cottage Food License if selling homemade food from home
- Food Truck: city permit, commissary agreement, vehicle inspection

PET SERVICES (Dog Walking, Grooming, Pet Sitting):
- General business license
- Groomer: some states require a license

BEAUTY / PERSONAL CARE (Hair, Nails, Massage):
- State cosmetology or esthetics license — REQUIRED in most states
- General business license for your location

TRADES (Electrical, Plumbing, HVAC):
- Journeyman or Master license — required in almost every state
- General contractor's license if bidding large jobs
- Liability insurance — required by clients and often by law

DIGITAL / ONLINE SERVICES (Freelance, Virtual Assistant):
- General business license if your city requires it
- No industry-specific license typically required

---
WHERE TO LOOK UP YOUR REQUIREMENTS
---
- SBA.gov/licenses — official U.S. Small Business Administration guide
- Your city or county website — search "[YOUR CITY] business license"
- Your state Secretary of State website — for LLC and DBA filing
- SCORE.org — free mentorship from retired business owners

---
INSURANCE NOTE
---
General Liability Insurance covers property damage or injury you cause while working.
Cost: $50-$150/month for basic coverage.
Quote at: Next Insurance (next.co) or Thimble (thimble.com) — both specialize in small business and you can get coverage in minutes.

NOTE: Licensing laws vary significantly by state, county, and city. Always verify requirements with your local city hall, county clerk, and state licensing board before starting.
""",
            isPro: false
        )
    ]
}
