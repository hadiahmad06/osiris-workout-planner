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
    var restDays: [Date]
    var exerciseStats: [ExerciseStats]
    
    static func calendar() -> Foundation.Calendar {
        return Foundation.Calendar(identifier: .gregorian)
    }
    
    init(id: String) {
        self.id = id
        self.entries = []
        self.restDays = []
        self.exerciseStats = []
    }
    
    static func isSameDay(date1: Date, date2: Date) -> Bool {
        return Log.calendar().isDate(date1, inSameDayAs: date2)
    }
    
    mutating func updateDateStatus(date: Date, rest: Bool?) -> Int? {
        let _rest: Bool
        // if nil, toggle
        _rest = rest ?? !isRestDay(date: date)
        
        if !_rest {
            if let idx = restDays.firstIndex(where: { Log.isSameDay(date1: $0, date2: date) }) {
                restDays.remove(at: idx)
                return idx
            }
            return nil
        } else {
            if let _ = restDays.firstIndex(where: { Log.isSameDay(date1: $0, date2: date) }) {
                return nil
            } else {
                self.restDays.append(date)
                return restDays.endIndex - 1
            }
        }
    }
    
    func isRestDay(date: Date) -> Bool {
        return restDays.first(where: { Log.isSameDay(date1: $0, date2: date) }) != nil
    }
    
//    mutating func updateStreak(date: Date, status: StreakStatus) {
//        self.streaks[Log.calendar().startOfDay(for: date)] = status
//    }
    
//    static func
    
    
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
