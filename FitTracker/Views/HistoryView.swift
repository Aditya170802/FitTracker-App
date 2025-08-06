//
//  HistoryView.swift
//  FitTracker
//
//  Created by Aditya Ghuraiya on 07/08/25.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    @State private var searchText = ""
    @State private var selectedDateFilter: DateFilter = .all
    @State private var showingFilterOptions = false
    
    var filteredExercises: [Exercise] {
        let dateFiltered = dataManager.getFilteredExercises(dateFilter: selectedDateFilter)
        
        if searchText.isEmpty {
            return dateFiltered
        } else {
            return dateFiltered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Section
                VStack(spacing: 12) {
                    HStack {
                        Text("Filter by date:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: {
                            showingFilterOptions = true
                        }) {
                            HStack {
                                Text(selectedDateFilter.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                            }
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    
                    if filteredExercises.isEmpty && selectedDateFilter != .all {
                        TipView(
                            icon: "calendar.badge.exclamationmark",
                            text: "No workouts found for the selected time period. Try a different date range.",
                            color: .orange
                        )
                    } else if !filteredExercises.isEmpty {
                        TipView(
                            icon: "magnifyingglass",
                            text: "Use the search bar to find specific exercises quickly.",
                            color: .blue
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // List Section
                if filteredExercises.isEmpty && selectedDateFilter == .all {
                    EmptyHistoryView()
                } else {
                    List {
                        ForEach(filteredExercises) { exercise in
                            ExerciseRowView(exercise: exercise)
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search exercises...")
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
        }
        .actionSheet(isPresented: $showingFilterOptions) {
            ActionSheet(
                title: Text("Filter Workouts"),
                buttons: DateFilter.allCases.map { filter in
                    .default(Text(filter.rawValue)) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedDateFilter = filter
                        }
                    }
                } + [.cancel()]
            )
        }
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No workout history")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text("Your completed workouts will appear here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            TipView(
                icon: "book",
                text: "Your workout history helps you track progress and identify patterns in your training.",
                color: .purple
            )
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct ExerciseRowView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(exercise.name)
                    .font(.headline)
                Spacer()
                Text(exercise.muscleGroup)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack {
                Text(exercise.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(exercise.sets.count) sets")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(exercise.sets) { set in
                        Text("\(set.reps) × \(Int(set.weight))kg")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
        .padding(.vertical, 4)
    }
}
