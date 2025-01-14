//
//  Untitled.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let username: String
    let nickname: String
    let email: String
    let logID: String
    let plans: [String]
    let connections: [Connection]
    var isActive: Bool
    
    var initial: String {
        return nickname.first!.uppercased()
    }
    
    init(id: String, username: String, nickname: String, email: String) {
        self.id = id
        self.username = username
        self.nickname = nickname
        self.email = email
        self.logID = UUID().uuidString
        self.plans = []
        self.connections = []
        self.isActive = true
    }
    
    private var _bodyweightMetric: Double = 0 // measured in kg
    private var _heightMetric: Double = 0 // measured in cm
}

extension User { // for bodyweight and height conversions
    
    var bodyweightMetric: Double {
        get {
            return _bodyweightMetric
        }
        set {
            _bodyweightMetric = newValue
        }
    }
    
    var bodyweightImperial: Int {
        get {
            return Int(_bodyweightMetric * 2.2)
        }
        set {
            _bodyweightMetric = Double(newValue) / 2.2
        }
    }
    
    var heightMetric: Double {
        get {
            return _heightMetric
        }
        set {
            _heightMetric = newValue
        }
    }
    
    var heightImperial: (feet: Int, inches: Int) {
        get {
            let totalInches = Int(_heightMetric / 2.54)
            let feet = totalInches / 12
            let inches = totalInches % 12
            return (feet, inches)
        }
        set {
            let totalInches = (newValue.feet * 12) + newValue.inches
            _heightMetric = Double(totalInches) * 2.54
        }
    }
}

extension User {
    static var EXAMPLE_USER = User(id: NSUUID().uuidString,
                                   username: "hadiahmad06",
                                   nickname: "Hadi",
                                   email: "hireme@epicsystems.com")
}
