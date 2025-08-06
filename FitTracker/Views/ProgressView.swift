import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    
    var weeklyProgress: [WeeklyProgress] {
        dataManager.getWeeklyProgress()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if weeklyProgress.isEmpty {
                        EmptyProgressView()
                    } else {
                        TipView(
                            icon: "target",
                            text: "Consistency is key! Aim for at least 3 workouts per week for optimal results.",
                            color: .green
                        )
                        .padding(.horizontal)
                        
                        StatsCardsView(weeklyProgress: weeklyProgress)
                        WeeklyProgressChart(weeklyProgress: weeklyProgress)
                    }
                }
                .padding()
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct EmptyProgressView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No progress data")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text("Complete some workouts to see your progress")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            TipView(
                icon: "calendar",
                text: "Track your workouts regularly to see meaningful progress trends and stay motivated.",
                color: .blue
            )
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct StatsCardsView: View {
    let weeklyProgress: [WeeklyProgress]
    
    var totalWorkouts: Int {
        weeklyProgress.first?.totalWorkouts ?? 0
    }
    
    var totalVolume: Double {
        weeklyProgress.first?.totalVolume ?? 0
    }
    
    var body: some View {
        HStack(spacing: 15) {
            StatCard(
                title: "This Week",
                value: "\(totalWorkouts)",
                subtitle: "Workouts",
                color: .blue
            )
            
            StatCard(
                title: "Volume",
                value: "\(Int(totalVolume))",
                subtitle: "kg lifted",
                color: .green
            )
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WeeklyProgressChart: View {
    let weeklyProgress: [WeeklyProgress]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Progress")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(weeklyProgress.reversed()) { week in
                        WeeklyBarView(progress: week)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WeeklyBarView: View {
    let progress: WeeklyProgress
    
    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 4) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 20, height: max(CGFloat(progress.totalWorkouts) * 10, 5))
                    .cornerRadius(2)
                
                Text("\(progress.totalWorkouts)")
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            
            Text(progress.weekStart, formatter: weekFormatter)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

private let weekFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter
}()
