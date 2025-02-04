//
//  WorkoutService.swift
//  Osiris
//
//  Created by Hadi Ahmad on 2/3/25.
//

import Foundation

@MainActor
class WorkoutService: ObservableObject {
    var _currentWorkout: WorkoutEntryUI
    
    init(plan: Plan? = nil) {
        let name = plan?.name ?? "Custom"
        let id = plan?.id
        self._currentWorkout = WorkoutEntryUI(planID: id, name: name, plan: plan)
    }
    
    func addExerciseEntry(id: String, index: Int? = nil) {
        let entry = ExerciseEntryUI(order: _currentWorkout.nextOrder, exerciseID: id)
        entry.exercise = ExerciseService().getExercise(byId: id)
        
        if index == nil {
            _currentWorkout.exerciseEntriesUI.append(entry)
        } else {
            _currentWorkout.exerciseEntriesUI.insert(entry, at: index!)
        }
        _currentWorkout.selectedExercise = entry
        addSet()
    }
    
    func navigate(toIdx idx: Int) {
        let selected = idx == -1 ? _currentWorkout.exerciseEntriesUI.last : _currentWorkout.exerciseEntriesUI[idx]
        _currentWorkout.selectedExercise = selected
    }
    
    func addSet() {
        guard let selectedExercise = _currentWorkout.selectedExercise else { return }
        let nextOrder = selectedExercise.nextOrder
        selectedExercise.base.sets.append(Set(order: nextOrder, reps: nil, weight: nil))
        selectedExercise.selectedSet = findIdx(nextOrder)!
    }
    
    func removeExercise(_ idx: Int? = nil) {
        if let idx = idx {
            _currentWorkout.exerciseEntriesUI.remove(at: idx)
        } else {
            _currentWorkout.exerciseEntriesUI.removeLast()
        }
    }
    
    func removeSet(order: Int? = nil) {
        guard let selectedExercise = _currentWorkout.selectedExercise else { return }
        
        if order != nil {
            print("Cannot remove at specified index")
        } else {
            selectedExercise.base.sets.removeLast()
            selectedExercise.nextOrder -= 1
            NotificationCenter.default.post(name: .workoutUpdated, object: nil)
        }
    }
    
    func editWeight(_ weight: Int?) {
        guard let selectedExercise = _currentWorkout.selectedExercise else { return }
        let idx = selectedExercise.selectedSet
        selectedExercise.base.sets[idx].weight = weight
    }
    
    func editReps(_ reps: Int?) {
        guard let selectedExercise = _currentWorkout.selectedExercise else { return }
        let idx = selectedExercise.selectedSet
        selectedExercise.base.sets[idx].reps = reps
    }
    
    func findIdx(_ order: Int) -> Int? {
        return _currentWorkout.selectedExercise?.base.sets.firstIndex(where: { $0.order == order })
    }
    
    func pushWorkout() -> FunctionResult {
        _currentWorkout.base.timeElapsed = Int(Date().timeIntervalSince(_currentWorkout.base.timestamp))
        _currentWorkout.base.exerciseEntries = _currentWorkout.exerciseEntriesUI.map { $0.base }
        return .success
    }
}
