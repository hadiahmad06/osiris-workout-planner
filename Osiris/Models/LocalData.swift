//
//  LocalData.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/10/25.
//

import Foundation
import SwiftUICore

struct LocalData {
    @EnvironmentObject var cloudService: CloudService
    private var currentWorkout: WorkoutEntry?
    
    mutating func startWorkout(_ plan: Plan?) {
        let name = plan?.name ?? "Custom"
        let id = plan?.id ?? nil
        self.currentWorkout = WorkoutEntry(planID: id, name: name)
    }
    
    func addExerciseEntry() {
        
    }
    
    func pushWorkout() -> FunctionResult {
        if let workout = self.currentWorkout {
            let timestamp = workout.timestamp
            let timeInterval = Date().timeIntervalSince(timestamp)  // Returns TimeInterval (Double)
            //self.currentWorkout?.totalTime = Int(timeInterval)  // Convert to Int if totalTime is expected to be an integer
            return .success
        }
    }
}
