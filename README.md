# Osiris Workout Planner

## Overview

(This project is a work in progress)

Osiris is a workout tracking app designed to help users track their exercise routines and build workout plans using AI. The app is built using SwiftUI and integrates with Firebase for authentication and data storage.

## Recent Updates

### Dec 31, 2024
   - `AuthViewModel` -> removed all methods for `streaks`, replaced them with methods for `restDays`
   - `Log` -> removed the property `streaks`, instead opting for `restDays` of type `[Date]`
   - `TodayView` -> changed a few function calls for streaks
   - Plans: I plan to use either hashing or firebase's built in querying to make locating specific entries or dates simpler. My next step will be to implement a pop up view for workout plans, as well as adding a global collection of workout plans, so that they can be shared with others and used by multiple people.

### Dec 30, 2024
   - `AuthViewModel` -> attempted to update streaks in log, but failed
   - `Log` -> created new property of `Log`, `streaks`, of type `[Date:StreakStatus]`
   - `AuthViewModel` -> added new property of `AuthViewModel`, `authErrorMessage`, which is updated in `fetchUser()`
   - `LoginView` -> successfully implemented `authErrorMessage` into the UI
   - `RegistrationView` -> ditto
   - `TodayView` -> added temporary buttons to test using `AuthViewModel`, more specifically `updateStreak()` and `getWeekStatuses()`
   - Plans: I plan to remove `streaks` and instead change `WorkoutEntry` to use optional types and store a status. Only 2 statuses should be stored, `.skipped` and `.completed`, the other 2 can be inferred by the program and do not need to be stored. I also plan to implement a pop up view on `TodayView` soon that allows the user to select a workout plan or rest day for the selected date.

### Dec 29, 2024
   - `WorkoutEntry` -> removed DateEntry structure, opted for a separate dictionary keeping track of streaks
   - `AuthViewModel` -> added functions to add and update log and properties of log
   - `TodayView` -> attempted to create weekly view (not perfectly functioning)
   - `LoginView` -> button becomes fully opaque when fields are correctly filled
   - `RegistrationView` -> ditto
   - `Log`
   - `ContentView`
   - `User`
   
### Dec 28th and prior
   - look at commits i didnt write this down
        

## Features Implemented

### 1. **Authentication System**
   - Users can sign up and log in using Firebase Authentication.
   - Authentication state is managed through the `AuthViewModel`, which tracks whether a user is logged in or not.
   - Firebase Auth handles user sessions, including storing and fetching user-specific data securely.
   - Data stored:
        User data: Username, nickname, email
        Workout Logs: streak data, workout entries
            Workout Entries: sets and reps of each exercise, total time, reference to workout plan associated with entry
            
   
<img src="GithubAssets/signup_screen.png" alt="Sign up screen screenshot" width="200"/>

### 2. **Firebase Integration**
   - Firebase is used to store and sync user data, including workout logs and user preferences.
   - Firebase Authentication handles user session management.
   - Workout plans are stored in Firebase Cloud Firestore, allowing users to retrieve their data across different devices.
   
### 3. **User Interface**
   - Created a user interface with SwiftUI 

## To Do

### 1. **AI Exercise Recommendation System**
   - Create my own model based on CoreML or use an API with OpenAI or Google's Gemini that can do the following:
   - New users can provide information regarding what equipment they have access to, their goals, and other factors. Then, exercises are filtered by some of those factors, while the more open-ended factors are processed through a RAG model. A workout plan is created and shared with the user. If the user is not satisfied with an exercise, they can replace them manually, or automatically with a prompt:
   - Users can replace exercises with alternative exercises based on their issues. eg: User struggles doing Bodyweight Dips, the app could recommend Close Grip Bench Press, an exercise that is easier to learn (lower rating), but still strengthens the same or similar muscle groups. 
    
### 2. **Achievements**
   - Users can collect achievements through logging workouts, adding friends, hitting certain muscle groups, etc.

### 3. **Friends and Social**
   - Users can add friends through their usernames, and see their saved workouts, previous workouts, and achievements.
   - Users can compete with friends to reach a goal. Eg: first to bench 225 (Maybe on this one)

### 4. **Strength Level Ranking**
   - I aim to work with strengthlevel.com to allow users to see where they stand among other lifters.
   - If this is not possible, I can create my own dataset using statistics online regarding lifts, as well as user data.
