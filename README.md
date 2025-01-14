# Osiris Workout Planner

## Overview

(This project is a work in progress)

Osiris is a workout tracking app designed to help users track their exercise routines and build workout plans using AI. The app is built using SwiftUI and integrates with Firebase for authentication and data storage.

## Most Recent

### Jan 14, 2024
   - [`ProfileService`](Osiris/Models/User/ProfileService.swift) now maintains synchronization of connection statuses between users.
   - [`Profile`](Osiris/Models/User/Profile.swift) was created and added to collection `profiles` so that some user data can be kept private. These changes are reflected in [`ProfileService`](Osiris/Models/User/ProfileService.swift)
   - Added method `queueChange(username: String, change: Change)` to [`ProfileService`](Osiris/Models/User/ProfileService.swift)
   - Have already drawn out a SocialView to recreate in Swift! 
   - I took a break from workout logging as I ran into an issue but I'll revisit that after I'm done with socials.
   
## Table of Contents
1. [Features Implemented](#features-implemented)
   1. [Authentication System](#authentication-system)
   2. [Realtime Database](#cloud-storage)
   3. [Friends and Social](#friends-and-social)
d. [User Interface](#user-interface)
2. [To-do](#to-do)
3. [Recent Updates](#recent-updates)

## Features Implemented

### 1. **Authentication System**
   - Users can sign up and log in through a simple login or signup screen, powered with Firebase Authentication
   - Authentication state is managed through the [`AuthService`](Osiris/Models/Authentication/AuthService.swift), which tracks the current user session, and current user data.
   - Firebase Auth handles user sessions, including storing and fetching user-specific data securely.
            
<div style="display: flex; justify-content: center; align-items: center;">
    <img src="GithubAssets/startup_phase.gif" alt="Start up screen GIF" width="200"/>   
    <img src="GithubAssets/switch_auth.gif" alt="Switch auth screen GIF" width="200"/>   
</div>

### 2. **Cloud Storage**
   - All online pushes and pulls are handled with [`CloudService`](Osiris/Models/CloudService.swift)
   - Authentication is also done using [`CloudService`](Osiris/Models/CloudService.swift)
   - Firebase is used to store and sync data, including workout logs in [`LogService`](Osiris/Models/Logging/LogService.swift).
   - [`ProfileService`](Osiris/Models/User/ProfileService.swift) safely handles user connections, like friends, requests, blocked users, etc. 
   - Workout plans and logs are stored in separate database collections, allowing users to share workout plans without compromising their own data.
   
### 3. **Friends and Social**
   - [`ProfileService`](Osiris/Models/User/ProfileService.swift) handles friends, pending requests, and blocked users while ensuring local data is synchronized with the cloud.
   - `SocialView` (in-progress) will display friends, pending outgoing and incoming requests, and blocked users and allow the user to add new friends by entering their username.
   
### 4. **User Interface**
   - Created an interactive login/signup screen using SwiftUI animations, in [`AuthView`](Osiris/Views/Authentication/AuthView.swift) 
   - Created a [`TodayView`](Osiris/Views/Menu/Tabs/Today/TodayView.swift) page which shows statuses for each day in the current week. It also gives an overview of previous workouts for the selected day and allows users to start a new workout.
   


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

## Recent Updates

### Jan 13, 2024
   - [`ProfileService`](Osiris/Models/User/ProfileService.swift) handles connection changes and updates locally only if Firestore changes are successful.
   - [`ProfileService`](Osiris/Models/User/ProfileService.swift) was created to manage user connections and handle changes to connection requests.
   - The method `pushChanges()` was created to ensure local changes reflect changes on the cloud
   - `parseConnections()` initializes user connections, adding them to relevant categories to be displayed on SocialView (incomplete atm) (friends, inbound, outbound, blocked).

### Jan 12, 2024
   - Still figuring out local data
   - Changed [CloudService](Osiris/Models/CloudService.swift) to include authentication
   - Deprecated AuthService

### Jan 11, 2024
   - Trying to figure out how I want to store local data and when I want to push it to the cloud.

Goals for now:
   - Fix TodayView
   - Add social page
   - Allow viewing of logs with StatsView

### Jan 9-10, 2024
   - [PlanService](Osiris/Models/Planning/PlanService.swift) was created to track workout plans
   - [LocalData](Osiris/Models/LocalData.swift) was created to store local data (like in progress workout entries) before they are pushed using [CloudService](Osiris/Models/CloudService.swift)
   - [WeekView](Osiris/Views/Menu/Tabs/Today/WeekView.swift) was added to control animations between [TodayView](Osiris/Views/Menu/Tabs/Today/TodayView.swift) and [WorkoutView](Osiris/Views/Menu/Tabs/Today/WorkoutView.swift)
   - [Animations](Osiris/Models/Animation/Animations) is a work-in-progress struct with functions that aims to allow modularity in views with similar animations.

### Jan 7, 2024
   - Created [`AuthView`](Osiris/Views/Authentication/AuthView.swift) -> animates [`LoginView`](Osiris/Views/Authentication/LoginView.swift) and [`RegistrationView`](Osiris/Views/Authentication/RegistrationView.swift) smoothly, only rendering what's on screen.
   - [`ControllerView`](Osiris/Views/ControllerView.swift) -> implements [`AuthView`](Osiris/Views/Authentication/AuthView.swift)
   - [`LoginView`](Osiris/Views/Authentication/LoginView.swift) + [`RegistrationView`](Osiris/Views/Authentication/RegistrationView.swift) -> moved logo component to [`AuthView`](Osiris/Views/Authentication/AuthView.swift)

### Jan 4-6, 2024
   - `CloudService` -> main access to Firebase
   - `AuthService` -> originally `AuthViewModel`, now only includes methods related to the `user` collection
   - `LogService` -> originally a part of `AuthViewModel`, now solely contains methods related to the `logs` collection
   - `TodayView` -> Implemented a modular menu that can be used to set workout plans and rest day statuses.
   - `LaunchView` -> Added a launch screen and animated the loading screen
   - `ExerciseStats` -> Created a class to hold individual exercise stats for users.

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

