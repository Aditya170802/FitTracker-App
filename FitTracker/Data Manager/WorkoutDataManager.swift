import Foundation

class WorkoutDataManager: ObservableObject {
    @Published var exercises: [Exercise] = []
    
    private let userDefaults = UserDefaults.standard
    private let exercisesKey = "SavedExercises"
    
    init() {
        loadExercises()
    }
    
    func saveExercises() {
        if let encoded = try? JSONEncoder().encode(exercises) {
            userDefaults.set(encoded, forKey: exercisesKey)
        }
    }
    
    func loadExercises() {
        if let data = userDefaults.data(forKey: exercisesKey),
           let decoded = try? JSONDecoder().decode([Exercise].self, from: data) {
            exercises = decoded
        }
    }
    
    func addExercise(_ exercise: Exercise) {
        exercises.append(exercise)
        saveExercises()
    }
    
    func getExerciseHistory(for name: String) -> [Exercise] {
        return exercises.filter { $0.name.lowercased() == name.lowercased() }
            .sorted { $0.date > $1.date }
    }
    
    func getFilteredExercises(dateFilter: DateFilter) -> [Exercise] {
        let calendar = Calendar.current
        
        guard let filterDate = dateFilter.filterDate() else {
            return exercises.sorted { $0.date > $1.date }
        }
        
        return exercises.filter { exercise in
            switch dateFilter {
            case .today:
                return calendar.isDate(exercise.date, inSameDayAs: Date())
            case .thisWeek:
                return exercise.date >= filterDate
            case .thisMonth:
                return exercise.date >= filterDate
            case .lastMonth:
                // Get the start and end of last month
                guard let lastMonthStart = calendar.dateInterval(of: .month, for: calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date())?.start,
                      let lastMonthEnd = calendar.dateInterval(of: .month, for: calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date())?.end else {
                    return false
                }
                return exercise.date >= lastMonthStart && exercise.date < lastMonthEnd
            case .all:
                return true
            }
        }.sorted { $0.date > $1.date }
    }
    
    func getWeeklyProgress() -> [WeeklyProgress] {
        let calendar = Calendar.current
        let groupedByWeek = Dictionary(grouping: exercises) { exercise in
            calendar.dateInterval(of: .weekOfYear, for: exercise.date)?.start ?? exercise.date
        }
        
        return groupedByWeek.map { weekStart, exercises in
            let totalSets = exercises.reduce(0) { $0 + $1.sets.count }
            let totalVolume = exercises.reduce(0.0) { total, exercise in
                total + exercise.sets.reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
            }
            
            return WeeklyProgress(
                weekStart: weekStart,
                totalWorkouts: exercises.count,
                totalSets: totalSets,
                totalVolume: totalVolume
            )
        }.sorted { $0.weekStart > $1.weekStart }
    }
}
