//
//  Profile.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/14/25.
//

struct Profile: Identifiable, Codable {
    let id: String
    let username: String
    let nickname: String
    let logID: String?
    let connections: [Connection]
    
    var initial: String {
        return nickname.first!.uppercased()
    }
    
    init(_ user: User) {
        self.id = user.profileID
        self.username = user.username
        self.nickname = user.nickname
        self.logID = user.logID
        self.connections = user.connections
    }
}
