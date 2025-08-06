# FitTracker

A professional, feature-rich workout tracking app built with SwiftUI that helps you monitor your fitness journey, track progress, and achieve your goals.

## 🌟 Features

### 📱 **Core Functionality**
- **Exercise Tracking**: Add custom exercises with sets, reps, weight, and rest times
- **Progress Monitoring**: Visual charts showing weekly workout progress and volume
- **Workout History**: Complete log of all exercises with search functionality
- **Smart Suggestions**: View previous performance when adding familiar exercises

### 🎯 **Professional UI/UX**
- Clean, modern interface following iOS design guidelines
- Contextual tips and guidance throughout the app
- Smooth, purposeful animations for enhanced user experience
- Professional onboarding with gradient welcome screen
- Intuitive tab-based navigation

### 📊 **Advanced Features**
- **Date Filtering**: Filter workout history by Today, This Week, This Month, Last Month, or All Time
- **Progress Analytics**: Weekly volume tracking and workout frequency statistics
- **Exercise History**: See your progression over time for each exercise
- **Muscle Group Organization**: Categorize exercises by muscle groups (Chest, Back, Shoulders, Arms, Legs, Core, Cardio)

## 🏗️ **Technical Architecture**

### **Built With**
- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive data flow with `@StateObject` and `@Published`
- **UserDefaults**: Local data persistence using JSON encoding
- **Foundation**: Date handling and calendar operations

### **Data Models**
- `Exercise`: Core workout data structure with sets array
- `WeeklyProgress`: Analytics data for progress tracking
- `DateFilter`: Enum for filtering workout history
- `WorkoutDataManager`: ObservableObject managing all workout data

### **Key Components**
- **WelcomeView**: Animated onboarding experience
- **WorkoutView**: Main exercise tracking interface
- **AddExerciseView**: Comprehensive exercise creation form
- **ProgressView**: Visual analytics and statistics
- **HistoryView**: Searchable workout history with filtering

📈 Future Enhancements

Workout Templates: Pre-built routines for different goals
Exercise Library: Comprehensive database with instructions
Photo Progress: Before/after photo tracking
Export Features: Share progress data
Apple Health Integration: Sync with HealthKit
Advanced Analytics: Detailed performance metrics

