//
//  LocalData.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/10/25.
//

import Foundation
import SwiftUICore

@MainActor
class LocalService: ObservableObject {
    @EnvironmentObject var cloudService: CloudService
    private var currentWorkout: WorkoutEntryUI? {
        didSet {
            if (oldValue == nil) != (currentWorkout == nil) {
                NotificationCenter.default.post(name: .showWorkoutViewChanged, object: nil)
            }
        }
    }
    
    var working: Bool {
        self.currentWorkout != nil
    }
    
    func startWorkout(_ plan: Plan? = nil) {
        let name = plan?.name ?? "Custom"
        let id = plan?.id ?? nil
        self.currentWorkout = WorkoutEntryUI(planID: id, name: name)
    }
    
    func addExerciseEntry(_ id: String) {
        if self.currentWorkout != nil {
            let entry = ExerciseEntryUI(order: currentWorkout!.nextOrder,
                                      exerciseID: id)
            
            currentWorkout!.base.exerciseEntries.append(entry.base)
            currentWorkout!.selectedExercise = entry
        }
    }
    
    func addSet() {
        if self.currentWorkout!.selectedExercise != nil {
            let nextOrder = currentWorkout!.selectedExercise!.nextOrder
            currentWorkout!.selectedExercise!.base.sets.append(Set(order: nextOrder,
                                              reps: -1,
                                              weight: -1))
            currentWorkout!.selectedExercise!.selectedSet = findIdx(nextOrder)!
        }
    }
    
    func popSet(order: Int? = nil) { // needs to be fixed
        if self.currentWorkout!.selectedExercise != nil {
            if order != nil {
                print("Cannot remove at specified index")
//                if let realIdx = selectedExercise!.sets.firstIndex(of: Set(idx: idx)) {
//                    
//                }
            } else {
                currentWorkout!.selectedExercise!.base.sets.removeLast()
                currentWorkout!.selectedExercise!.nextOrder -= 1
            }
        }
    }
    
    func editWeight(_ weight: Int?) {
        if self.currentWorkout!.selectedExercise != nil {
            let idx = currentWorkout!.selectedExercise!.selectedSet
            currentWorkout!.selectedExercise!.base.sets[idx].weight = weight
        }
    }
    func editReps(_ reps: Int?) {
        if self.currentWorkout!.selectedExercise != nil {
            let idx = currentWorkout!.selectedExercise!.selectedSet
            currentWorkout!.selectedExercise!.base.sets[idx].reps = reps
        }
    }
    
    func getTimeElapsed() -> Int {
        if self.currentWorkout != nil {
            return Int(currentWorkout!.base.totalTime)
        }
        return 0
    }
    
    func findIdx(_ order: Int) -> Int? {
        return currentWorkout!.selectedExercise!.base.sets.firstIndex(where: { $0.order == order } )
    }
    
    func pushWorkout() -> FunctionResult {
        if self.currentWorkout != nil {
            let timestamp = currentWorkout!.base.timestamp
            // might be wrong elapsed time
            self.currentWorkout!.base.totalTime = Int(Date().timeIntervalSince(timestamp))
            return .success
        }
        return .failure
    }
    
    func cancelWorkout() {
        currentWorkout = nil
        print("DEBUG: workout cancelled")
    }
}

//struct OptionalSet {
//    var id: String
////    var exerciseID: String
//    var order: Int
//    var reps: Int
//    var type: MovementType              // isometric, eccentric, regular
//    var weight: Int
//    var mergeNext: Bool
//    
//    init(order: Int, reps: Int, type: MovementType, weight: Int, mergeNext: Bool = false) {
//        self.id = UUID().uuidString
////        self.exerciseID = exercise
//        self.order = order
//        self.reps = reps
//        self.type = type
//        self.weight = weight
//        self.mergeNext = mergeNext
//    }
//}

extension Notification.Name {
    static let showWorkoutViewChanged = Notification.Name("showWorkoutViewChanged")
}
