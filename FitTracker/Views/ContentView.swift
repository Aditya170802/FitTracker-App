import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = WorkoutDataManager()
    @State private var showWelcome = true
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if showWelcome {
                WelcomeView(showWelcome: $showWelcome)
            } else {
                TabView(selection: $selectedTab) {
                    WorkoutView()
                        .tabItem {
                            Image(systemName: "dumbbell")
                            Text("Workout")
                        }
                        .tag(0)
                    
                    ProgressView()
                        .tabItem {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("Progress")
                        }
                        .tag(1)
                    
                    HistoryView()
                        .tabItem {
                            Image(systemName: "clock.arrow.circlepath")
                            Text("History")
                        }
                        .tag(2)
                }
                .environmentObject(dataManager)
                .accentColor(.blue)
            }
        }
    }
}
