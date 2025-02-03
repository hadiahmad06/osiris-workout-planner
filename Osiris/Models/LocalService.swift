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
    // capitalized to differentiate as service
    @Published private var Exercise: ExerciseService = ExerciseService()
    private var _currentWorkout: WorkoutEntryUI? {
        didSet {
            if (oldValue == nil) != (_currentWorkout == nil) {
                NotificationCenter.default.post(name: .showWorkoutViewChanged, object: nil)
            }
        }
    }
    var workout: WorkoutEntryUI {
        get {
            if _currentWorkout != nil {
                return _currentWorkout!
            } else {
                print("no workout currently")
                return WorkoutEntryUI()
            }
        }
        set {
            fatalError("cannot set current workout externally")
        }
    }
    
    var working: Bool {
        self._currentWorkout != nil
    }
    
    func startWorkout(fromID planID: String? = nil) async {
        let plan: Plan?
        if planID != nil {
            plan = await cloudService.plan.getPlan(fromId: planID!)
        } else {
            plan = nil
        }
        let name = plan?.name ?? "Custom"
        self._currentWorkout = WorkoutEntryUI(planID: planID, name: name, plan: plan)
    }
    
    func startWorkout(fromPlan plan: Plan? = nil) {
        let name = plan?.name ?? "Custom"
        let id = plan?.id ?? nil
        self._currentWorkout = WorkoutEntryUI(planID: id, name: name)
    }
    
    func addExerciseEntry(_ id: String) {
        if self._currentWorkout != nil {
            let entry = ExerciseEntryUI(order: _currentWorkout!.nextOrder,
                                      exerciseID: id)
            entry.exercise = Exercise.getExercise(byId: id)
            
//            _currentWorkout!.base.exerciseEntries.append(entry.base)
            _currentWorkout!.exerciseEntriesUI.append(entry)
            _currentWorkout!.selectedExercise = entry
            NotificationCenter.default.post(name: .workoutUpdated, object: nil)
        }
    }
    
    func navigate(toIdx idx: Int) {
        _currentWorkout!.selectedExercise = self._currentWorkout!.exerciseEntriesUI[idx]
    }
    
    func addSet() {
        if self._currentWorkout!.selectedExercise != nil {
            let nextOrder = _currentWorkout!.selectedExercise!.nextOrder
            _currentWorkout!.selectedExercise!.base.sets.append(Set(order: nextOrder,
                                              reps: -1,
                                              weight: -1))
            _currentWorkout!.selectedExercise!.selectedSet = findIdx(nextOrder)!
            NotificationCenter.default.post(name: .workoutUpdated, object: nil)
        }
    }
    
    func popSet(order: Int? = nil) { // needs to be fixed
        if self._currentWorkout!.selectedExercise != nil {
            if order != nil {
                print("Cannot remove at specified index")
//                if let realIdx = selectedExercise!.sets.firstIndex(of: Set(idx: idx)) {
//                    
//                }
            } else {
                _currentWorkout!.selectedExercise!.base.sets.removeLast()
                _currentWorkout!.selectedExercise!.nextOrder -= 1
                NotificationCenter.default.post(name: .workoutUpdated, object: nil)
            }
        }
    }
    
    func editWeight(_ weight: Int?) {
        if self._currentWorkout!.selectedExercise != nil {
            let idx = _currentWorkout!.selectedExercise!.selectedSet
            _currentWorkout!.selectedExercise!.base.sets[idx].weight = weight
        }
    }
    func editReps(_ reps: Int?) {
        if self._currentWorkout!.selectedExercise != nil {
            let idx = _currentWorkout!.selectedExercise!.selectedSet
            _currentWorkout!.selectedExercise!.base.sets[idx].reps = reps
        }
    }
    
    
    
    func findIdx(_ order: Int) -> Int? {
        return _currentWorkout!.selectedExercise!.base.sets.firstIndex(where: { $0.order == order } )
    }
    
    func pushWorkout() -> FunctionResult {
        if self._currentWorkout != nil {
            let timestamp = _currentWorkout!.base.timestamp
            // might be wrong elapsed time
            self._currentWorkout!.base.timeElapsed = Int(Date().timeIntervalSince(timestamp))
            for entry in self._currentWorkout!.exerciseEntriesUI {
                _currentWorkout!.base.exerciseEntries.append(entry.base)
            }
            return .success
        }
        return .failure
    }
    
    func cancelWorkout() {
        self._currentWorkout = nil
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

extension LocalService {
    static var EXAMPLE_LOCAL_SERVICE: LocalService = {
        var x = LocalService()
        
        x.startWorkout()
        return x
    }()
}

extension Notification.Name {
    static let showWorkoutViewChanged = Notification.Name("showWorkoutViewChanged")
}

extension Notification.Name {
    static let workoutUpdated = Notification.Name("workoutUpdated")
}
