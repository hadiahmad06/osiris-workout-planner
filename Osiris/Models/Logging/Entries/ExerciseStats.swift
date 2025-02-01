//
//  ExerciseStats.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/5/25.
//

class ExerciseStats: Codable {
    var id: String                  // same as exerciseID
    var personalRecord: Double
    var estimatedRecord: Double
    var sets: Int
    var reps: Int
    var totalMoved: Int
    
    init(exerciseID: String, personalRecord: Double, estimatedRecord: Double, sets: Int, reps: Int, totalMoved: Int) {
        self.id = exerciseID
        self.personalRecord = personalRecord
        self.estimatedRecord = estimatedRecord
        self.sets = sets
        self.reps = reps
        self.totalMoved = totalMoved
    }
}
