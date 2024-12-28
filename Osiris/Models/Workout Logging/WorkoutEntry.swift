//
//  WorkoutEntry.swift
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

struct DateEntry: Identifiable, Codable {
    var id: String
    var workoutEntries: [WorkoutEntry]
    var date: Date
    var status: StreakStatus
    
    init(id: String, workoutEntries: [WorkoutEntry], date: Date, status: StreakStatus) {
        self.id = id
        self.workoutEntries = workoutEntries
        self.date = date
        self.status = status
    }
}

struct WorkoutEntry: Identifiable, Codable {
    var id: String
    var exerciseEntry: [ExerciseEntry]
    var totalTime: Int                  // total time of workout recorded in minutes
    var plan: WorkoutPlan               // workout plan associated with the workout
    
    init(id: String, exerciseEntry: [ExerciseEntry], totalTime: Int, plan: WorkoutPlan) {
        self.id = id
        self.exerciseEntry = exerciseEntry
        self.totalTime = totalTime
        self.plan = plan
    }
}

struct ExerciseEntry: Identifiable, Codable {
    var id: String
    var exercise: Exercise
    var sets: [Set]
    
    init(id: String, exercise: Exercise, sets: [Set]) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
    }
}
struct Set: Identifiable, Codable {
    var id: String
    var exercise: Exercise
    var reps: Int
    var type: MovementType              // isometric, eccentric, regular
    var weight: Int
    
    init(id: String, exercise: Exercise, reps: Int, type: MovementType, weight: Int) {
        self.id = id
        self.exercise = exercise
        self.reps = reps
        self.type = type
        self.weight = weight
    }
}

