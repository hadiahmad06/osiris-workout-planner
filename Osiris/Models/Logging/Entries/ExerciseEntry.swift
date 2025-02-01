//
//  ExerciseEntry.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/30/25.
//

import Foundation


class ExerciseEntry: Identifiable, Codable {
    var id: String
    var order: Int
    var exerciseID: String
    var sets: [Set]
    
    init(order: Int, exerciseID: String) {
        self.id = UUID().uuidString
        self.order = order
        self.exerciseID = exerciseID
        self.sets = []
    }
}

class ExerciseEntryUI {
    var base: ExerciseEntry
    private var _nextOrder: Int = 0
    var nextOrder: Int {
        get {
            _nextOrder += 1
            return _nextOrder
        }
        set {
            _nextOrder = newValue
        }
    }
    var selectedSet: Int = 1
    
    // utilizes composition so that we can have extra properties when editing.
    init(order: Int, exerciseID: String) {
        base = ExerciseEntry(order: order, exerciseID: exerciseID)
    }
    
    // for when editing an old entry
    init(_ base: ExerciseEntry) {
        self.base = base
    }
}
