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
    var exerciseEntries: [ExerciseEntry]
    var totalTime: Int                  // total time of workout recorded in minutes
    var planID: String?                 // workout plan associated with the workout
    var name: String
    var timestamp: Date
    var musclesUtilized: [MuscleWeightage]
    
    init(planID: String?, name: String = "") {
        self.id = UUID().uuidString
        self.exerciseEntries = []
        self.totalTime = 0
        self.planID = planID
        self.name = name
        self.timestamp = Date()
        
        self.musclesUtilized = []
//        for entry in exerciseEntries {
//            for muscle in entry.exerciseID.musclesTargeted {
//                for sets in entry.sets {
//                    
//                }
//            }
//        }
    }
    
//    mutating func addExerciseEntry(_ exerciseEntry: ExerciseEntry) {
//        self.exerciseEntry.append(exerciseEntry)
//    }
}

struct ExerciseEntry: Identifiable, Codable {
    var id: String
    var order: Int
    var exerciseID: String
    var sets: [Set]
    
    init(order: Int, exerciseID: String, sets: [Set]) {
        self.id = UUID().uuidString
        self.order = order
        self.exerciseID = exerciseID
        self.sets = sets
    }
}

struct Set: Identifiable, Codable {
    var id: String
//    var exerciseID: String
    var order: Int
    var reps: Int
    var type: MovementType              // isometric, eccentric, regular
    var weight: Int
    var mergeNext: Bool
    
    init(order: Int, reps: Int, type: MovementType, weight: Int, mergeNext: Bool = false) {
        self.id = UUID().uuidString
//        self.exerciseID = exercise
        self.order = order
        self.reps = reps
        self.type = type
        self.weight = weight
        self.mergeNext = mergeNext
    }
}

