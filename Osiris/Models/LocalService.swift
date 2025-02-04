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
    @Published private var Exercise: ExerciseService = ExerciseService()
    
    private var workoutService: WorkoutService? {
        didSet {
            NotificationCenter.default.post(name: .workoutUpdated, object: nil)
            //if (oldValue == nil) != (workoutService != nil) {
                NotificationCenter.default.post(name: .showWorkoutViewChanged, object: nil)
            //}
        }
    }
    
    var workout: WorkoutEntryUI {
        get {
            return workoutService?._currentWorkout ?? LocalService.EXAMPLE_LOCAL_SERVICE.workout
        }
        set {
            print("DEBUG: cannot change workout data directly")
        }
    }
    
    var working: Bool {
        workoutService != nil
    }
    
    func startWorkout(fromID planID: String? = nil) async {
        let plan = planID != nil ? await cloudService.plan.getPlan(fromId: planID!) : nil
        workoutService = WorkoutService(plan: plan)
    }
    
    func startWorkout(fromPlan plan: Plan? = nil) {
        workoutService = WorkoutService(plan: plan)
    }
    
    func cancelWorkout() {
        workoutService = nil
        print("DEBUG: workout cancelled")
    }
    
    // Expose workoutService functions through LocalService
    func addExerciseEntry(id: String, index: Int? = nil) {
        workoutService?.addExerciseEntry(id: id, index: index)
    }
    
    func navigate(toIdx idx: Int) {
        workoutService?.navigate(toIdx: idx)
    }
    
    func addSet() {
        workoutService?.addSet()
    }
    
    func removeExercise(_ idx: Int? = nil) {
        workoutService?.removeExercise(idx)
    }
    
    func removeSet(order: Int? = nil) {
        workoutService?.removeSet(order: order)
    }
    
    func editWeight(_ weight: Int?) {
        workoutService?.editWeight(weight)
    }
    
    func editReps(_ reps: Int?) {
        workoutService?.editReps(reps)
    }
    
    func pushWorkout() -> FunctionResult {
        return workoutService?.pushWorkout() ?? .failure
    }
}

//@MainActor
//class LocalService: ObservableObject {
//    @EnvironmentObject var cloudService: CloudService
//    // capitalized to differentiate as service
//    @Published private var Exercise: ExerciseService = ExerciseService()
//    private var _currentWorkout: WorkoutEntryUI? {
//        didSet {
//            NotificationCenter.default.post(name: .workoutUpdated, object: nil)
//            if (oldValue == nil) != (_currentWorkout == nil) {
//                NotificationCenter.default.post(name: .showWorkoutViewChanged, object: nil)
//            }
//        }
//    }
//    var workout: WorkoutEntryUI {
//        get {
//            if _currentWorkout != nil {
//                return _currentWorkout!
//            } else {
//                print("no workout currently")
//                return WorkoutEntryUI()
//            }
//        }
//        set {
//            fatalError("cannot set current workout externally")
//        }
//    }
//    
//    var working: Bool {
//        self._currentWorkout != nil
//    }
//    
//    func startWorkout(fromID planID: String? = nil) async {
//        let plan: Plan?
//        if planID != nil {
//            plan = await cloudService.plan.getPlan(fromId: planID!)
//        } else {
//            plan = nil
//        }
//        let name = plan?.name ?? "Custom"
//        self._currentWorkout = WorkoutEntryUI(planID: planID, name: name, plan: plan)
//    }
//    
//    func startWorkout(fromPlan plan: Plan? = nil) {
//        let name = plan?.name ?? "Custom"
//        let id = plan?.id ?? nil
//        self._currentWorkout = WorkoutEntryUI(planID: id, name: name)
//    }
//    
//    func addExerciseEntry(id: String, index: Int? = nil) {
//        if self._currentWorkout != nil {
//            let entry = ExerciseEntryUI(order: _currentWorkout!.nextOrder,
//                                      exerciseID: id)
//            entry.exercise = Exercise.getExercise(byId: id)
//            
////            _currentWorkout!.base.exerciseEntries.append(entry.base)
//            if index == nil {
//                _currentWorkout!.exerciseEntriesUI.append(entry)
//            } else {
//                _currentWorkout?.exerciseEntriesUI.insert(entry, at: index!)
//            }
//            _currentWorkout!.selectedExercise = entry
//            addSet()
//        }
//    }
//    
//    func navigate(toIdx idx: Int) {
//        let selected: ExerciseEntryUI?
//        if idx == -1 {
//            selected = self._currentWorkout!.exerciseEntriesUI.last
//        } else {
//            selected = self._currentWorkout!.exerciseEntriesUI[idx]
//        }
//        self._currentWorkout!.selectedExercise = selected
//    }
//    
//    func addSet() {
//        if self._currentWorkout!.selectedExercise != nil {
//            let nextOrder = _currentWorkout!.selectedExercise!.nextOrder
//            _currentWorkout!.selectedExercise!.base.sets.append(Set(order: nextOrder,
//                                              reps: nil,
//                                              weight: nil))
//            _currentWorkout!.selectedExercise!.selectedSet = findIdx(nextOrder)!
//        }
//    }
//    
//    func removeExercise(_ idx: Int? = nil) {
//        if idx != nil {
//            _currentWorkout!.exerciseEntriesUI.remove(at: idx!)
//        } else {
//            _currentWorkout!.exerciseEntriesUI.removeLast()
//        }
//    }
//    
//    func removeSet(order: Int? = nil) { // needs to be fixed
//        if self._currentWorkout!.selectedExercise != nil {
//            if order != nil {
//                print("Cannot remove at specified index")
////                if let realIdx = selectedExercise!.sets.firstIndex(of: Set(idx: idx)) {
////                    
////                }
//            } else {
//                _currentWorkout!.selectedExercise!.base.sets.removeLast()
//                _currentWorkout!.selectedExercise!.nextOrder -= 1
//                NotificationCenter.default.post(name: .workoutUpdated, object: nil)
//            }
//        }
//    }
//    
//    func editWeight(_ weight: Int?) {
//        if self._currentWorkout!.selectedExercise != nil {
//            let idx = _currentWorkout!.selectedExercise!.selectedSet
//            _currentWorkout!.selectedExercise!.base.sets[idx].weight = weight
//        }
//    }
//    func editReps(_ reps: Int?) {
//        if self._currentWorkout!.selectedExercise != nil {
//            let idx = _currentWorkout!.selectedExercise!.selectedSet
//            _currentWorkout!.selectedExercise!.base.sets[idx].reps = reps
//        }
//    }
//    
//    
//    
//    func findIdx(_ order: Int) -> Int? {
//        return _currentWorkout!.selectedExercise!.base.sets.firstIndex(where: { $0.order == order } )
//    }
//    
//    func pushWorkout() -> FunctionResult {
//        if self._currentWorkout != nil {
//            let timestamp = _currentWorkout!.base.timestamp
//            // might be wrong elapsed time
//            self._currentWorkout!.base.timeElapsed = Int(Date().timeIntervalSince(timestamp))
//            for entry in self._currentWorkout!.exerciseEntriesUI {
//                _currentWorkout!.base.exerciseEntries.append(entry.base)
//            }
//            return .success
//        }
//        return .failure
//    }
//    
//    func cancelWorkout() {
//        self._currentWorkout = nil
//        print("DEBUG: workout cancelled")
//    }
//}
//
////struct OptionalSet {
////    var id: String
//////    var exerciseID: String
////    var order: Int
////    var reps: Int
////    var type: MovementType              // isometric, eccentric, regular
////    var weight: Int
////    var mergeNext: Bool
////    
////    init(order: Int, reps: Int, type: MovementType, weight: Int, mergeNext: Bool = false) {
////        self.id = UUID().uuidString
//////        self.exerciseID = exercise
////        self.order = order
////        self.reps = reps
////        self.type = type
////        self.weight = weight
////        self.mergeNext = mergeNext
////    }
////}
//
extension LocalService {
    static var EXAMPLE_LOCAL_SERVICE: LocalService = {
        var x = LocalService()
        
        x.startWorkout()
        x.addExerciseEntry(id: "example")
        x.addExerciseEntry(id: "example")
        x.addExerciseEntry(id: "example")
        return x
    }()
}

extension Notification.Name {
    static let showWorkoutViewChanged = Notification.Name("showWorkoutViewChanged")
}

extension Notification.Name {
    static let workoutUpdated = Notification.Name("workoutUpdated")
}
