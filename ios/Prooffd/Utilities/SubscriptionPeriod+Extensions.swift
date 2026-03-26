import RevenueCat

extension RevenueCat.SubscriptionPeriod {

    func periodTitle() -> String {
        switch unit {
        case .day:
            return value == 1 ? "1 Day" : "\(value) Days"
        case .week:
            return value == 1 ? "1 Week" : "\(value) Weeks"
        case .month:
            return value == 1 ? "1 Month" : "\(value) Months"
        case .year:
            return value == 1 ? "1 Year" : "\(value) Years"
        @unknown default:
            return "\(value)"
        }
    }
}
