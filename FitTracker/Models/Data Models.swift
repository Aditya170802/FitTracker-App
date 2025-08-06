import Foundation

struct Exercise: Identifiable, Codable {
    let id = UUID()
    var name: String
    var muscleGroup: String
    var sets: [Set]
    var date: Date
    
    struct Set: Identifiable, Codable {
        let id = UUID()
        var reps: Int
        var weight: Double
        var restTime: Int // in seconds
    }
}

struct WeeklyProgress: Identifiable {
    let id = UUID()
    let weekStart: Date
    let totalWorkouts: Int
    let totalSets: Int
    let totalVolume: Double
}

enum DateFilter: String, CaseIterable {
    case all = "All Time"
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case lastMonth = "Last Month"
    
    func filterDate() -> Date? {
        let calendar = Calendar.current
        switch self {
        case .all:
            return nil
        case .today:
            return calendar.startOfDay(for: Date())
        case .thisWeek:
            return calendar.dateInterval(of: .weekOfYear, for: Date())?.start
        case .thisMonth:
            return calendar.dateInterval(of: .month, for: Date())?.start
        case .lastMonth:
            return calendar.dateInterval(of: .month, for: calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date())?.start
        }
    }
}
