//
//  Log.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//

import Foundation


// Represents the workout calendar, which stores workout entries for multiple days
struct Log : Codable {
    var id: String
    var entries: [DateEntry] // Array of workout entries for different days
    private let calendar: Foundation.Calendar // Explicit Calendar instance
    
    init(id: String) {
        self.id = id
        self.calendar = Foundation.Calendar(identifier: .gregorian)
        self.entries = []
    }
    
    // Add a new workout entry for a specific date
    mutating func addDataEntry(id: String, date: Date, status: StreakStatus, workoutData: [WorkoutEntry]? = nil) {
        let newEntry = DateEntry(id: id, workoutEntries: workoutData ?? [], date: date, status: status)
        entries.append(newEntry)
        // Keep entries sorted by date
        entries.sort { $0.date < $1.date }
    }
    
    // Update the status of a workout entry for a specific date
    mutating func updateWorkoutStatus(forDate date: Date, newStatus: StreakStatus) {
        if let index = entries.firstIndex(where: { Log.isSameDay(date1: $0.date, date2: date, using: calendar) }) {
            entries[index].status = newStatus
        }
    }
    
    // Function to get the workout entry for a specific date
    func getWorkoutEntry(forDate date: Date) -> DateEntry? {
        return entries.first { Log.isSameDay(date1: $0.date, date2: date, using: calendar) }
    }
    
    // Function to get a workout entry by offset from the current date
    func getWorkoutEntry(offset: Int) -> DateEntry? {
        let targetDate = calendar.date(byAdding: .day, value: offset, to: Date())!
        return entries.first { Log.isSameDay(date1: $0.date, date2: targetDate, using: calendar) }
    }
    
    // Helper function to compare dates (ignoring time) using a custom calendar
    private static func isSameDay(date1: Date, date2: Date, using calendar: Foundation.Calendar) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

//// Example Usage
//var calendar = Calendar(entries: [])
//let today = Date()
//
//// Adding workout entries
//calendar.addWorkoutEntry(date: today, status: .planned)
//calendar.addWorkoutEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: today)!, status: .completed, workoutData: WorkoutData(exerciseData: [], totalTime: 60, plan: WorkoutPlan()))
//
//// Update a specific workout status
//calendar.updateWorkoutStatus(forDate: today, newStatus: .completed)
//
//// Fetch workout entry for a specific day
//if let workoutForToday = calendar.getWorkoutEntry(forDate: today) {
//    print("Workout status for today: \(workoutForToday.status.rawValue)")
//}
