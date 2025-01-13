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
            selectedExercise!.selectedSet = findIdx(nextOrder)!
        }
    }
    
    mutating func popSet(order: Int? = nil) { // needs to be fixed
        if self.selectedExercise != nil {
            if order != nil {
                print("Cannot remove at specified index")
//                if let realIdx = selectedExercise!.sets.firstIndex(of: Set(idx: idx)) {
//                    
//                }
            } else {
                selectedExercise!.sets.removeLast()
                selectedExercise!.nextOrder -= 1
            }
        }
    }
    
    mutating func editWeight(_ weight: Int?) {
        if self.selectedExercise != nil {
            let idx = selectedExercise!.selectedSet
            selectedExercise!.sets[idx].weight = weight
        }
    }
    mutating func editReps(_ reps: Int?) {
        if self.selectedExercise != nil {
            let idx = selectedExercise!.selectedSet
            selectedExercise!.sets[idx].reps = reps
        }
    }
    
    func findIdx(_ order: Int) -> Int? {
        return selectedExercise!.sets.firstIndex(where: { $0.order == order } )
    }
    
    mutating func pushWorkout() -> FunctionResult {
        if self.currentWorkout != nil {
            let timestamp = currentWorkout!.timestamp
            self.currentWorkout!.totalTime = Date().timeIntervalSince(timestamp)
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
