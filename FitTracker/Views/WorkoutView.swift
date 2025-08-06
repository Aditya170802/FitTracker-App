import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    @State private var showingAddExercise = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if dataManager.exercises.isEmpty {
                    EmptyWorkoutView(showingAddExercise: $showingAddExercise)
                } else {
                    VStack(spacing: 16) {
                        TipView(
                            icon: "lightbulb",
                            text: "Tap + to add a new exercise. Your previous performance will be shown to help track progress.",
                            color: .orange
                        )
                        .padding(.horizontal)
                        .padding(.top)
                        
                        RecentWorkoutsView()
                    }
                }
            }
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddExercise = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                AddExerciseView()
            }
        }
    }
}

struct EmptyWorkoutView: View {
    @Binding var showingAddExercise: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No workouts yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text("Start your fitness journey by adding your first exercise")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            TipView(
                icon: "star",
                text: "Pro tip: Start with compound exercises like squats, deadlifts, and bench press for maximum results.",
                color: .blue
            )
            .padding(.horizontal)
            
            Button(action: {
                showingAddExercise = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Exercise")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(25)
            }
            
            Spacer()
        }
    }
}

struct RecentWorkoutsView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    
    var recentExercises: [Exercise] {
        Array(dataManager.exercises.sorted { $0.date > $1.date }.prefix(10))
    }
    
    var body: some View {
        List {
            Section("Recent Workouts") {
                ForEach(recentExercises) { exercise in
                    ExerciseRowView(exercise: exercise)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
