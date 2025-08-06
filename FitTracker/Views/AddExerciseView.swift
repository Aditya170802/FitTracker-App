
import SwiftUI

struct AddExerciseView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var exerciseName = ""
    @State private var muscleGroup = "Chest"
    @State private var sets: [Exercise.Set] = [Exercise.Set(reps: 10, weight: 0, restTime: 60)]
    @State private var showingHistory = false
    @State private var showSaveAnimation = false
    
    let muscleGroups = ["Chest", "Back", "Shoulders", "Arms", "Legs", "Core", "Cardio"]
    
    var exerciseHistory: [Exercise] {
        dataManager.getExerciseHistory(for: exerciseName)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Exercise Details") {
                    TextField("Exercise name", text: $exerciseName)
                        .onChange(of: exerciseName) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showingHistory = !exerciseHistory.isEmpty && !exerciseName.isEmpty
                            }
                        }
                    
                    Picker("Muscle Group", selection: $muscleGroup) {
                        ForEach(muscleGroups, id: \.self) { group in
                            Text(group).tag(group)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                if !exerciseName.isEmpty && exerciseHistory.isEmpty {
                    TipView(
                        icon: "info.circle",
                        text: "This is a new exercise! Your performance will be tracked for future reference.",
                        color: .green
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                
                if showingHistory {
                    Section("Previous Performance") {
                        TipView(
                            icon: "chart.line.uptrend.xyaxis",
                            text: "Use your previous performance as a guide to progressively overload.",
                            color: .blue
                        )
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        
                        ForEach(exerciseHistory.prefix(3)) { exercise in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(exercise.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    ForEach(exercise.sets) { set in
                                        Text("\(set.reps)×\(Int(set.weight))kg")
                                            .font(.caption)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(4)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Section("Sets") {
                    TipView(
                        icon: "timer",
                        text: "Rest 60-90 seconds between sets for strength, 30-60 seconds for endurance.",
                        color: .orange
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    
                    ForEach(sets.indices, id: \.self) { index in
                        SetRowView(set: $sets[index], setNumber: index + 1)
                    }
                    
                    Button(action: addSet) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Set")
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExercise()
                    }
                    .disabled(exerciseName.isEmpty)
                    .scaleEffect(showSaveAnimation ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showSaveAnimation)
                }
            }
        }
    }
    
    private func addSet() {
        let lastSet = sets.last ?? Exercise.Set(reps: 10, weight: 0, restTime: 60)
        sets.append(Exercise.Set(reps: lastSet.reps, weight: lastSet.weight, restTime: lastSet.restTime))
    }
    
    private func saveExercise() {
        showSaveAnimation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showSaveAnimation = false
        }
        
        let exercise = Exercise(
            name: exerciseName,
            muscleGroup: muscleGroup,
            sets: sets,
            date: Date()
        )
        
        dataManager.addExercise(exercise)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SetRowView: View {
    @Binding var set: Exercise.Set
    let setNumber: Int
    
    var body: some View {
        HStack {
            Text("\(setNumber)")
                .font(.headline)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Reps")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("0", value: $set.reps, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight (kg)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("0", value: $set.weight, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Rest (sec)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("60", value: $set.restTime, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}
