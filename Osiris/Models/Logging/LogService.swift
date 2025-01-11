//
//  LogService.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/4/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
//import SwiftUI

class LogService {
    var _currentLog: Log?
    
    var currentLog: Log? {
        get {
            return _currentLog
        }
        set {
            print("DEBUG: Cannot set currentLog directly")
        }
    }
//    func currentLog() -> Log? {
//        return _currentLog
//    }
    
    init(currentLog: Log? = nil) {
        self._currentLog = currentLog
    }
    
    func updateLog() async {
        do {
            let encodedLog = try Firestore.Encoder().encode(_currentLog)
            try await Firestore.firestore().collection("logs").document(_currentLog!.id).updateData(encodedLog)
        } catch {
            print("DEBUG: Failed to update log with error \(error.localizedDescription)")
        }
    }
    
    func updateStatus(date: Date, rest: Bool? = nil) async {
        if let _ = _currentLog?.updateDateStatus(date: date, rest: rest) {
            await updateLog()
        } else {
            print("DEBUG: Local status update not made")
        }
        
//        do {
//            // if a local update is made, continue
//            if let idx = currentLog!.updateDateStatus(date: date, rest: rest) {
//                // given the change adds a rest day, proceed
//                if currentLog!.isRestDay(date: date) {
//                    // encodes status and normalizes date to prepare for cloud update
//                    let normalizedDate = Log.calendar().startOfDay(for: date)
//                    let encodedDate = try Firestore.Encoder().encode(normalizedDate)
//                    
//                    // attempts to add entry
//                    try await Firestore.firestore().collection("logs").document(currentLog!.id).collection("restDays").document("\(idx)").updateData(encodedDate)
//                    print("DEBUG: adds rest day with index \(idx)")
//                
//                } else {
//                    // otherwise, delete document to imitate local change
//                    try await Firestore.firestore().collection("logs").document(currentLog!.id).collection("restDays").document("\(idx)").delete()
//                    print("DEBUG: removed rest day with index \(idx)")
//                }
//            }
//        } catch {
//            print("DEBUG: Failed to update rest days with error \(error.localizedDescription)")
//        }
    }
    
    func setWorkoutEntry(entry: WorkoutEntry) async {
        do {
            let encodedEntry = try Firestore.Encoder().encode(entry)
            if let _ = _currentLog?.entries.first(where: {$0.id == entry.id}) ?? nil {
                try await Firestore.firestore().collection("logs").document(_currentLog!.id).collection("entries").document(entry.id).updateData(encodedEntry)
            } else {
                try await Firestore.firestore().collection("logs").document(_currentLog!.id).collection("entries").document(entry.id).setData(encodedEntry)
            }
        } catch {
            print("DEBUG: Failed to update workout entry with error \(error.localizedDescription)")
        }
    }
    
    func getEntries(forDate date: Date) -> [WorkoutEntry] {
        var result: [WorkoutEntry] = []
        for entry in _currentLog?.entries ?? [] {
            if Log.isSameDay(date1: date, date2: entry.timestamp) {
                result.append(entry)
            }
        }
        return result
    }
    
    func checkForEntry(forDate date: Date) -> Bool {
        for entry in _currentLog!.entries {
            if Log.isSameDay(date1: date, date2: entry.timestamp) {
                return true
            }
        }
        return false
    }
    
    func findStreak(for d: Date) -> StreakStatus {
        // (ignore the time part)
        let normalizedDate = Log.calendar().startOfDay(for: d)
        
        if let _ = _currentLog?.restDays.firstIndex(where: {
            Log.calendar().isDate($0, inSameDayAs: normalizedDate) } ) {
            return .skipped
        }
        
        if let _ = _currentLog?.entries.firstIndex(where: {
            Log.calendar().isDate($0.timestamp, inSameDayAs: normalizedDate) } ) {
            return .completed
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
        let startDateOffset: Int = offset + (weekOffset * 7)
        
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
    
    func fetchLog(id: String) async -> FunctionResult {
        // attempt to locate log
        guard let logSnapshot = try? await Firestore.firestore().collection("logs").document(id).getDocument() else {
            print("Failed to fetch log data for user")
            return .failure
        }
        
        // attempt to decode log
        if let log = try? logSnapshot.data(as: Log.self) {
            self._currentLog = log
            print("DEBUG: LOG FETCHED")
            return .success
        } else {
            print("Failed to decode log data")
            return .failure
        }
    }
}
