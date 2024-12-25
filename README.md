# Osiris Workout Planner

## Overview

Osiris is a workout tracking app designed to help users track their exercise routines and build workout plans using AI. The app is built using SwiftUI and integrates with Firebase for authentication and data storage.

## Features Implemented

### 1. **Authentication System**
   - Users can sign up and log in using Firebase Authentication.
   - Authentication state is managed through the `AuthViewModel`, which tracks whether a user is logged in or not.
   - Firebase Auth handles user sessions, including storing and fetching user-specific data securely.
   
![Sign up screen screenshot](./GithubAssets/signup_screen.png =200x)

### 2. **Firebase Integration**
   - Firebase is used to store and sync user data, including workout logs and user preferences.
   - Firebase Authentication handles user session management.
   - Workout plans are stored in Firebase Cloud Firestore, allowing users to retrieve their data across different devices.

## To Do

### 1. **AI Exercise Recommendation System**
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
