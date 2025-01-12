//
//  LocalData.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/10/25.
//

import Foundation
import SwiftUICore

struct Workout {
    @EnvironmentObject var cloudService: CloudService
    private var currentWorkout: WorkoutEntry?
    private var selectedExercise: ExerciseEntry?
    
    mutating func startWorkout(_ plan: Plan?) {
        let name = plan?.name ?? "Custom"
        let id = plan?.id ?? nil
        self.currentWorkout = WorkoutEntry(planID: id, name: name)
    }
    
    mutating func addExerciseEntry(_ id: String) {
        if self.currentWorkout != nil {
            let entry = ExerciseEntry(order: currentWorkout!.nextOrder,
                                      exerciseID: id)
            
            currentWorkout!.exerciseEntries.append(entry)
            selectedExercise = entry
        }
    }
    
    mutating func addSet() {
        if self.selectedExercise != nil {
            let nextOrder = selectedExercise!.nextOrder
            selectedExercise!.sets.append(Set(order: nextOrder,
                                              reps: -1,
                                              weight: -1))
            selectedExercise!.selectedSet = nextOrder
        }
    }
    
    mutating func popSet() {
        if self.selectedExercise != nil {
            selectedExercise!.sets.removeLast()
            selectedExercise!.nextOrder -= 1
        }
    }
    
    mutating func editWeight(_ weight: Int) {
        if self.selectedExercise != nil {
            selectedExercise!.sets.remo
        }
    }
    
    mutating func pushWorkout() -> FunctionResult {
        if self.currentWorkout != nil {
            let timestamp = currentWorkout!.timestamp
            let timeInterval = Date().timeIntervalSince(timestamp)  // Returns TimeInterval (Double)
            self.currentWorkout!.totalTime = Int(timeInterval)  // Convert to Int if totalTime is expected to be an integer
            return .success
        }
        return .failure
    }
}

struct OptionalSet {
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
