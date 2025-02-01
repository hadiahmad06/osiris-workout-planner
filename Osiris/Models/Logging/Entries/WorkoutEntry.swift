//
//  WorkoutEntry.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/25/24.
//

import Foundation

class WorkoutEntry: Identifiable, Codable {
    var id: String
    var exerciseEntries: [ExerciseEntry]
    var totalTime: Int                  // total time of workout recorded
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

class WorkoutEntryUI {
    var base: WorkoutEntry
    var _nextOrder: Int = 0
    var nextOrder: Int {
        get {
            _nextOrder += 1
            return _nextOrder
        }
        set {
            _nextOrder = newValue
        }
    }
    var currentExercise: ExerciseEntry? = nil
    
    init(planID: String?, name: String = "") {
        self.base = WorkoutEntry(planID: planID, name: name)
    }
    
    init(_ base: WorkoutEntry) {
        self.base = base
    }
}
