import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(showContent ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                
                VStack(spacing: 16) {
                    Text("FitTracker Pro")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(showContent ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8).delay(0.2), value: showContent)
                    
                    Text("Track your workouts, monitor progress,\nand achieve your fitness goals")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8).delay(0.4), value: showContent)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showWelcome = false
                    }
                }) {
                    HStack {
                        Text("Get Started")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(0.6), value: showContent)
            }
        }
        .onAppear {
            showContent = true
        }
    }
}
