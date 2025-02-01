//
//  Set.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/30/25.
//

import Foundation

struct Set: Identifiable, Codable {
    var id: String
    var order: Int
    var type: MovementType              // isometric, eccentric, regular
    var reps: Int?
    var weight: Int?
    var working: Bool
    
    init(order: Int, type: MovementType = .regular, reps: Int?, weight: Int?, working: Bool = false) {
        self.id = UUID().uuidString
        self.order = order
        self.type = type
        self.reps = reps
        self.weight = weight
        self.working = working
    }
}
