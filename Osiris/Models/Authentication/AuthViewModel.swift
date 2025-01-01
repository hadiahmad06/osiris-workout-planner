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
import SwiftUI

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    //@ var logViewModel = LogViewModel()
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var currentLog: Log?
    
    @Published var authErrorMessage: String
    
    init() {
        authErrorMessage = ""
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
            
//            if !(currentUser?.isActive ?? false) {
//                signOut()
//            }
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
        signOut()
    }
    
    func fetchUser() async {
        // attempt to get uid
        guard let uid = Auth.auth().currentUser?.uid else {
            print("fetch failed, signing out")
            signOut()
            return
        }
        
        // fetch user
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {
            print("Failed to fetch user data")
            return
        }
        
        // attempt to decode user
        if let user = try? snapshot.data(as: User.self) {
            // if user is active, continue
            if user.isActive {
                self.currentUser = user
                print("DEBUG: USER FETCHED")
                
                // fetch log
                guard let logSnapshot = try? await Firestore.firestore().collection("logs").document(user.logID).getDocument() else {
                    print("Failed to fetch log data for user")
                    return
                }
                
                // attempt to decode log
                if let log = try? logSnapshot.data(as: Log.self) {
                    self.currentLog = log
                    print("DEBUG: LOG FETCHED")
                } else {
                    print("Failed to decode log data")
                }
            } else {
                print("User is not active")
                authErrorMessage = "Your account has been suspended. Please contact support."
                signOut()
                
            }
        } else {
            print("Failed to decode user data")
            authErrorMessage = "We failed to access your account, please try again later."
            signOut()
        }
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
    
//    func updateStreaks(streaks: [Date:StreakStatus]) {
//        //todo
//    }
    
    func updateStatus(date: Date, rest: Bool) async {
        do {
            // if a local update is made, continue
            if let idx = currentLog!.updateDateStatus(date: date, rest: rest) {
                // given the change adds a rest day, proceed
                if rest {
                    // encodes status and normalizes date to prepare for cloud update
                    let normalizedDate = Log.calendar().startOfDay(for: date)
                    let encodedDate = try Firestore.Encoder().encode(normalizedDate)
                    
                    // attempts to update entire streaks dictionary
                    try await Firestore.firestore().collection("logs").document(currentLog!.id).collection("restDays").document("\(idx)").setData(encodedDate)
                
                } else {
                    // otherwise, delete document to imitate local change
                    try await Firestore.firestore().collection("logs").document(currentLog!.id).collection("restDays").document("\(idx)").delete()
                }
            }
        } catch {
            print("DEBUG: Failed to update rest days with error \(error.localizedDescription)")
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
    
    func findStreak(for d: Date) -> StreakStatus {
        // (ignore the time part)
        let normalizedDate = Log.calendar().startOfDay(for: d)
        
        for date in currentLog?.restDays ?? [] {
            if Log.calendar().isDate(date, inSameDayAs: normalizedDate) {
                return .skipped
            }
        }
        for entry in currentLog?.entries ?? [] {
            if Log.calendar().isDate(entry.timestamp, inSameDayAs: normalizedDate) {
                return .completed
            }
        }
        if (d.timeIntervalSince1970 < Log.calendar().startOfDay(for: Date()).timeIntervalSince1970) {
            return .missed
        }
        return .pending
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
                let streak = findStreak(for: targetDate)
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
