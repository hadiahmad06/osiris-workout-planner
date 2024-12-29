//
//  WorkoutEntry.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//

import Foundation




//struct DateEntry: Identifiable, Codable { // need to deprecate
//    var id: String
//    var workoutEntries: [WorkoutEntry]
//    var date: Date
//    var status: StreakStatus
//    
//    init(workoutEntries: [WorkoutEntry], date: Date, status: StreakStatus) {
//        self.id = UUID().uuidString
//        self.workoutEntries = workoutEntries
//        self.date = date
//        self.status = status
//    }
//}

struct WorkoutEntry: Identifiable, Codable {
    var id: String
    var exerciseEntry: [ExerciseEntry]
    var totalTime: Int                  // total time of workout recorded in minutes
    var planID: String                  // workout plan associated with the workout
    var timestamp: Date
    
    init(exerciseEntry: [ExerciseEntry], totalTime: Int, planID: String, timestamp: Date) {
        self.id = UUID().uuidString
        self.exerciseEntry = exerciseEntry
        self.totalTime = totalTime
        self.planID = planID
        self.timestamp = timestamp
    }
}

struct ExerciseEntry: Identifiable, Codable {
    var id: String
    var order: Int
    var exercise: Exercise
    var sets: [Set]
    
    init(order: Int, exercise: Exercise, sets: [Set]) {
        self.id = UUID().uuidString
        self.order = order
        self.exercise = exercise
        self.sets = sets
    }
}
struct Set: Identifiable, Codable {
    var id: String
    var exerciseID: String
    var reps: Int
    var type: MovementType              // isometric, eccentric, regular
    var weight: Int
    
    init(exercise: String, reps: Int, type: MovementType, weight: Int) {
        self.id = UUID().uuidString
        self.exerciseID = exercise
        self.reps = reps
        self.type = type
        self.weight = weight
    }
}

