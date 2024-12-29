//
//  Log.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//

import Foundation

enum StreakStatus: Codable {
    case completed, skipped, missed, pending
    
    static func name(streakStatus: StreakStatus) -> String {
        switch streakStatus {
        case .completed: return "Completed"
        case .skipped: return "Skipped"
        case .missed: return "Missed"
        case .pending: return "Pending"
        }
    }
}

//struct Streak: Codable {
//    var status: StreakStatus
//    var date: Date
//}

struct Log: Codable {
    var id: String
    var entries: [WorkoutEntry] // All workout entries
    var streaks: [Date:StreakStatus]
    
    static func calendar() -> Foundation.Calendar {
        return Foundation.Calendar(identifier: .gregorian)
    }
    
    init(id: String) {
        self.id = id
        self.entries = []
        self.streaks = [:]
    }
    
    static func isSameDay(date1: Date, date2: Date) -> Bool {
        return Log.calendar().isDate(date1, inSameDayAs: date2)
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
