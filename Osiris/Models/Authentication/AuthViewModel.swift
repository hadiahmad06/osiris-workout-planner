//
//  Untitled.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    //@ var logViewModel = LogViewModel()
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var currentLog: Log?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
            
            if !(currentUser?.isActive ?? false) {
                signOut()
            }
        }
        
    }
    
    func signIn(withEmail email: String, password: String) async throws { //current bug, signing in doesnt fetch data correctly
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String,
                    password: String,
                    username: String,
                    nickname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, username: username, nickname: nickname, email: email)
            
            // Encode and save user data to Firestore
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            let encodedLog = try Firestore.Encoder().encode(Log(id: user.logID))
            try await Firestore.firestore().collection("logs").document(user.logID).setData(encodedLog)
            await fetchUser()
            
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil // wipes userSession and sends back to LoginView
            self.currentUser = nil // wipes data from currentUser
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deactivateAccount() async {
        currentUser?.isActive = false
        await updateUser()
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { print("fetch failed, signing out"); signOut(); return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        
        if let user = try? snapshot.data(as: User.self) {
            if user.isActive {
                self.currentUser = user
                print("DEBUG: USER FETCHED")
                guard let logSnapshot = try? await Firestore.firestore().collection("logs").document(user.logID).getDocument() else { return }
                self.currentLog = try? logSnapshot.data(as: Log.self)
                print("DEBUG: LOG FETCHED")
            }
        }
        // self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func updateUser() async {
        do {
            let encodedUser = try Firestore.Encoder().encode(currentUser)
            try await Firestore.firestore().collection("users").document(currentUser!.id).updateData(encodedUser)
        } catch {
            print("DEBUG: Failed to update user data with error \(error.localizedDescription)")
        }
    }
    
    func updateLog() async {
        do {
            let encodedLog = try Firestore.Encoder().encode(currentLog)
            try await Firestore.firestore().collection("logs").document(currentLog!.id).updateData(encodedLog)
        } catch {
            print("DEBUG: Failed to update log with error \(error.localizedDescription)")
        }
    }
    
    func updateStreaks(streaks: [Date:StreakStatus]) {
        //todo
    }
    
    func addStreakStatus(date: Date, streakStatus: StreakStatus) async {
        do {
            let normalizedDate = Log.calendar().startOfDay(for: date)
            currentLog!.streaks[normalizedDate] = streakStatus
            let encodedStreaks = try Firestore.Encoder().encode(currentLog!.streaks)
            try await Firestore.firestore().collection("logs").document(currentLog!.id).updateData(encodedStreaks)
        } catch {
            print("DEBUG: Failed to update log with error \(error.localizedDescription)")
        }
    }
    
    func updateWorkoutEntry(entry: WorkoutEntry) async {
        do {
            let encodedEntry = try Firestore.Encoder().encode(entry)
            try await Firestore.firestore().collection("logs").document(currentLog!.id).collection("entries").document(entry.id).updateData(encodedEntry)
        } catch {
            print("DEBUG: Failed to update workout entry with error \(error.localizedDescription)")
        }
    }
    
    func addWorkoutEntry(id: String, entry: WorkoutEntry) async {
        do {
            let encodedEntry = try Firestore.Encoder().encode(entry)
            try await Firestore.firestore().collection("logs").document(currentLog!.id).collection("entries").document(entry.id).setData(encodedEntry)
        } catch {
            print("DEBUG: Failed to add workout entry: \(error)")
        }
    }
    
    func getEntries(forDate date: Date) -> [WorkoutEntry] {
        var result: [WorkoutEntry] = []
        for entry in currentLog!.entries {
            if Log.isSameDay(date1: date, date2: entry.timestamp) {
                result.append(entry)
            }
        }
        return result
    }
    
    func checkForEntry(forDate date: Date) -> Bool {
        for entry in currentLog!.entries {
            if Log.isSameDay(date1: date, date2: entry.timestamp) {
                return true
            }
        }
        return false
    }
    
    func findStreak(for date: Date) -> StreakStatus? {
        // (ignore the time part)
        let normalizedDate = Log.calendar().startOfDay(for: date)
        
        for (storedDate, streakStatus) in currentLog?.streaks ?? [:] {
            if Log.calendar().isDate(storedDate, inSameDayAs: normalizedDate) {
                return streakStatus
            }
        }
        
        return nil // No streak found for that date
    }
    
    func getWeekStatuses(weekOffset: Int = 0) -> [(Date,StreakStatus)] {
        // Get the current day of the week (1 = Sunday, 7 = Saturday)
        let dayOfWeek = Log.calendar().component(.weekday, from: Date())
        
        // Calculate the offset to get to the start of the week (Sunday)
        let offset: Int = 1 - dayOfWeek
        let startDateOffset: Int = offset - (weekOffset * 7)
        
        var result: [(Date,StreakStatus)] = []
        
        // Loop through 7 days (one week)
        for i in 0..<7 { // offset from startDate
            // Calculate the date for the current day
            if let targetDate = Log.calendar().date(byAdding: .day, value: startDateOffset + i, to: Date()) {
                // Get the entry for that date, or create a mock entry if none is found
                
                // Append the entry to the result
                let streak = findStreak(for: targetDate) ?? .pending
                result.append((targetDate,streak))
                    
            } else {
                print("DEBUG: Could not create date for \(startDateOffset + i).")
            }
        }
        return result
    }
}


// For XCode previews
extension AuthViewModel {
    static var EXAMPLE_VIEW_MODEL = AuthViewModel()
}
