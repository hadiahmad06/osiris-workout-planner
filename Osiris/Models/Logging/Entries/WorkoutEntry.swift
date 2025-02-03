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
    var timeElapsed: Int                  // total time of workout recorded
    var planID: String?                 // workout plan associated with the workout
    var name: String?
    var timestamp: Date
    var musclesUtilized: [MuscleWeightage]
    
    init(planID: String?, name: String? = nil) {
        self.id = UUID().uuidString
        self.exerciseEntries = []
        self.timeElapsed = 0
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
    var selectedExercise: ExerciseEntryUI? = nil
    var plan: Plan? = nil
    var exerciseEntriesUI: [ExerciseEntryUI] = []
    
    init(planID: String? = nil, name: String? = nil, plan: Plan? = nil) {
        self.base = WorkoutEntry(planID: planID, name: name)
        self.plan = plan
        for id in plan?.exercises ?? [] {
            exerciseEntriesUI.append(ExerciseEntryUI(order: nextOrder, exerciseID: id))
        }
    }
    
    init(_ base: WorkoutEntry) {
        self.base = base
    }
}
