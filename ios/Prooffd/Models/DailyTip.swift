import Foundation

nonisolated struct DailyTip: Identifiable, Sendable {
    let id: Int
    let title: String
    let body: String
    let icon: String
    let category: TipCategory
}

nonisolated enum TipCategory: String, Sendable {
    case mindset = "Mindset"
    case marketing = "Marketing"
    case money = "Money"
    case hustle = "Hustle"
    case growth = "Growth"
    case strategy = "Strategy"

    var icon: String {
        switch self {
        case .mindset: return "brain.head.profile.fill"
        case .marketing: return "megaphone.fill"
        case .money: return "dollarsign.circle.fill"
        case .hustle: return "flame.fill"
        case .growth: return "chart.line.uptrend.xyaxis"
        case .strategy: return "target"
        }
    }
}

enum DailyTipDatabase {
    static let tips: [DailyTip] = [
        DailyTip(id: 1, title: "Start Before You're Ready", body: "Most successful entrepreneurs launched before they felt 100% prepared. Imperfect action beats perfect inaction every time. Your first client won't care about your logo — they care about results.", icon: "rocket.fill", category: .mindset),
        DailyTip(id: 2, title: "The $0 Marketing Move", body: "Post one helpful tip in a local Facebook group today. Don't sell — just help. People remember who helped them first, and they'll come back when they need your service.", icon: "megaphone.fill", category: .marketing),
        DailyTip(id: 3, title: "Price Higher Than You Think", body: "New entrepreneurs almost always undercharge. Price 20% higher than feels comfortable. You can always offer a discount, but you can never raise prices on existing clients without friction.", icon: "dollarsign.circle.fill", category: .money),
        DailyTip(id: 4, title: "The 2-Hour Launch", body: "You don't need a website to start. Create a simple Google Form for intake, a Venmo for payments, and start texting people you know. That's a business in 2 hours.", icon: "bolt.fill", category: .hustle),
        DailyTip(id: 5, title: "Your Network Is Your Net Worth", body: "Text 5 people today and tell them what you're starting. Not to sell — just to plant the seed. Word of mouth is still the #1 way small businesses get their first clients.", icon: "person.3.fill", category: .growth),
        DailyTip(id: 6, title: "Stack Your Services", body: "Once you land one service, upsell a related add-on. Lawn care? Offer gutter cleaning. Dog walking? Offer pet sitting. Each add-on increases revenue without finding new clients.", icon: "square.stack.3d.up.fill", category: .strategy),
        DailyTip(id: 7, title: "The Follow-Up Fortune", body: "80% of sales happen after the 5th follow-up, but most people quit after 1. Set a reminder to follow up with every lead at least 3 times. Persistence pays.", icon: "arrow.counterclockwise", category: .hustle),
        DailyTip(id: 8, title: "Testimonials Are Currency", body: "After every job, ask for a review. Screenshot it. Post it. A single great testimonial from a real person is worth more than any ad you could run.", icon: "star.fill", category: .marketing),
        DailyTip(id: 9, title: "Separate Your Money", body: "Open a separate bank account for your business today. Even a free checking account works. Mixing personal and business money is the #1 beginner mistake.", icon: "banknote.fill", category: .money),
        DailyTip(id: 10, title: "The Early Bird Advantage", body: "Reply to inquiries within 5 minutes and you're 10x more likely to win the job. Speed signals professionalism. Set up notifications so you never miss a lead.", icon: "clock.badge.checkmark.fill", category: .strategy),
        DailyTip(id: 11, title: "Learn One Thing Daily", body: "Spend 15 minutes a day learning about your industry on YouTube. In 30 days, you'll know more than 90% of your competition. Knowledge compounds faster than money.", icon: "book.fill", category: .growth),
        DailyTip(id: 12, title: "Batch Your Work", body: "Group similar tasks together. Do all your invoicing at once, all your outreach at once, all your content creation at once. Context-switching kills productivity.", icon: "square.grid.3x3.fill", category: .strategy),
        DailyTip(id: 13, title: "The Power of 'No'", body: "Not every client is your client. Saying no to bad-fit work protects your time and energy for the clients who truly value what you do. Quality over quantity.", icon: "hand.raised.fill", category: .mindset),
        DailyTip(id: 14, title: "Before & After Photos", body: "Take photos of every project — before, during, and after. This is free content that sells itself. One good before/after post can generate 10+ inquiries.", icon: "camera.fill", category: .marketing),
        DailyTip(id: 15, title: "The Referral Ask", body: "After completing a great job, ask: 'Do you know anyone else who could use this?' A warm referral closes 4x faster than a cold lead.", icon: "person.badge.plus", category: .hustle),
        DailyTip(id: 16, title: "Track Every Dollar", body: "Use a simple spreadsheet or app to track income and expenses from day one. You'll thank yourself at tax time, and you'll spot profit leaks early.", icon: "chart.bar.fill", category: .money),
        DailyTip(id: 17, title: "Your First 100 Days", body: "Focus the first 100 days on one thing: getting 10 paying clients. Don't build a website, don't design a logo, don't order business cards. Just get 10 clients.", icon: "figure.run", category: .hustle),
        DailyTip(id: 18, title: "Automate the Boring Stuff", body: "Set up automatic invoicing, automatic appointment reminders, and automatic follow-up texts. Every hour you save on admin is an hour you can spend earning.", icon: "gearshape.2.fill", category: .strategy),
        DailyTip(id: 19, title: "Competition Is Validation", body: "If someone else is already doing what you want to do, that's a good sign — it means there's demand. Don't compete on price. Compete on speed, quality, or personality.", icon: "checkmark.seal.fill", category: .mindset),
        DailyTip(id: 20, title: "The Weekend Side Hustle", body: "If you're starting while employed, dedicate just Saturday mornings to your business. 4 hours a week adds up to 200+ hours a year. That's enough to build something real.", icon: "calendar.badge.clock", category: .growth),
        DailyTip(id: 21, title: "Google My Business Is Free", body: "If you serve a local area, set up Google Business Profile today. It's free, shows up in Maps, and is often the first place people look for local services.", icon: "map.fill", category: .marketing),
        DailyTip(id: 22, title: "Raise Prices Annually", body: "Increase your rates 5-10% every year minimum. Your skills improve, costs go up, and loyal clients expect small increases. Those who leave over 5% weren't great clients.", icon: "arrow.up.right", category: .money),
        DailyTip(id: 23, title: "Done Is Better Than Perfect", body: "Your first flyer will be ugly. Your first pitch will be awkward. Your first job will be slow. That's the price of entry. Ship it, learn, and iterate.", icon: "checkmark.circle.fill", category: .mindset),
        DailyTip(id: 24, title: "Create a Simple Contract", body: "Even for small jobs, use a basic written agreement. It sets expectations, prevents disputes, and makes you look professional. A Google Doc template works.", icon: "doc.text.fill", category: .strategy),
        DailyTip(id: 25, title: "Celebrate Small Wins", body: "Your first dollar earned is a bigger milestone than your first thousand. Every win builds momentum. Keep a 'wins journal' and read it when things get tough.", icon: "trophy.fill", category: .mindset),
        DailyTip(id: 26, title: "The Rule of 7", body: "People need to see your brand 7 times before they take action. Post consistently, follow up consistently, show up consistently. Visibility beats brilliance.", icon: "repeat", category: .marketing),
        DailyTip(id: 27, title: "Emergency Fund First", body: "Before reinvesting profits, save one month of expenses as a buffer. Business is unpredictable. Having a cash cushion turns emergencies into inconveniences.", icon: "shield.fill", category: .money),
        DailyTip(id: 28, title: "Niche Down to Scale Up", body: "The riches are in the niches. Instead of 'cleaning service,' try 'Airbnb turnover cleaning.' Specialized services command higher prices and attract better clients.", icon: "scope", category: .growth),
        DailyTip(id: 29, title: "Reply Like a Pro", body: "Create templates for common questions and save them in your Notes app. Fast, professional replies win more business than custom messages sent hours late.", icon: "text.bubble.fill", category: .strategy),
        DailyTip(id: 30, title: "Your Vibe Attracts Your Tribe", body: "Be authentic in how you present your business. People buy from people they connect with. Let your personality show — it's your unfair advantage over big companies.", icon: "sparkles", category: .mindset),
        DailyTip(id: 31, title: "Set Business Hours", body: "Even if you're a one-person operation, set clear work hours. Boundaries prevent burnout and make you more productive during your 'on' hours.", icon: "clock.fill", category: .growth),
    ]

    static func tipForToday() -> DailyTip {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % tips.count
        return tips[index]
    }
}
