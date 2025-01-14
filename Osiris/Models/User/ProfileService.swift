//
//  ProfileService.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//
//  issues:
//  - changes might not be thread-safe, im planning on making it a queue
//  - planning to use this on a new collection profiles, which will hold public information, this way its kept separate from private user data (like email and logID)

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
//import SwiftUI

class ProfileService {
    // will change to type Profile
    var currentProfile: User? = nil
    
    var friends: [User] = []
    var outRequests: [User] = []
    var inRequests: [User] = []
    var blocked: [User] = []
    
//    var changesQueue: QueueArray<SocialChange> = QueueArray()
    var changes: [SocialChange] = []
    
    var connections: [Connection] = []
//    {
//        didSet {
//            Task {
//                let _ = await parseConnections()
//            }
//        }
//    }
    
//    init(currentUser: User) async {
//        connections = currentUser.connections
//        let _ = await parseConnections()
//        // sets connections -> parses connections
//    }
    
    func fetchConnections(_ currentUser: User) async -> FunctionResult {
        self.currentUser = currentUser
        self.connections = currentUser.connections
        if await parseConnections() == .success {
            return .success
        }
        return .failure
    }
    
    func parseConnections() async -> FunctionResult {
        // attempt to locate profile
        for x in connections {
            let id = x.id
            guard let profileSnapshot = try? await Firestore.firestore().collection("users").document(id).getDocument() else {
                print("Failed to fetch profile for user")
                return .failure
            }
            
            // attempt to decode profile
            if let profile = try? profileSnapshot.data(as: User.self) {
                switch x.type {
                case .friend: self.friends.append(profile)
                case .inbound: self.inRequests.append(profile)
                case .outbound: self.outRequests.append(profile)
                case .blocked: self.blocked.append(profile)
                }
                //print("DEBUG: PROFILE FETCHED")
                return .success
            } else {
                print("Failed to decode profile data")
                return .failure
            }
        }
        return .success
    }
    
    func pushChanges() async {
        for (index, change) in changes.enumerated() {
            switch change.type {
            case .friend:
                if change.change == .remove {
                    // handles removing a friend: remove from connections
                    if let idx = connections.firstIndex(where: { $0.id == change.id }) {
                        // attempts removing on the cloud
                        if await removeConnectionForUser(id: change.id) == .success {
                            // only removes locally if it succeeds in pushing change to cloud
                            connections.remove(at: idx)
                            if await parseConnections() == .success {
                                changes.remove(at: index)
                            }
                        }
                    }
                }
                // You can't reject or accept a friend
                
            case .inbound:
                if change.change == .add {
                    // handles accepting an inbound connection request: changes connection type
                    if let idx = connections.firstIndex(where: { $0.id == change.id }) {
                        // attempts updating connection on the cloud
                        if await updateConnectionForUser(id: change.id, newType: .friend) == .success {
                            // only updates locally if it succeeds in pushing change to cloud
                            connections[idx].type = .friend
                            if await parseConnections() == .success {
                                changes.remove(at: index)
                            }
                        }
                    }
                } else if change.change == .remove {
                    // handles accepting an inbound connection request: changes connection type
                    if let idx = connections.firstIndex(where: { $0.id == change.id }) {
                        // attempts removing connection on the cloud
                        if await removeConnectionForUser(id: change.id) == .success {
                            // only removes locally if it succeeds in pushing change to cloud
                            connections.remove(at: idx)
                            if await parseConnections() == .success {
                                changes.remove(at: index)
                            }
                        }
                    }
                }
            case .outbound:
                if change.change == .remove {
                    // handles removing an outbound connection request: removes connection
                    if let idx = connections.firstIndex(where: { $0.id == change.id }) {
                        // attempts removing connection on the cloud
                        if await removeConnectionForUser(id: change.id) == .success {
                            // only updates locally if it succeeds in pushing change to cloud
                            connections.remove(at: idx)
                            if await parseConnections() == .success {
                                changes.remove(at: index)
                            }
                        }
                    }
                }
            case .blocked:
                if change.change == .remove {
                    // handles removing a blocked user: removes connection
                    if let idx = connections.firstIndex(where: { $0.id == change.id }) {
                        // updates locally
                        connections.remove(at: idx)
                        if await parseConnections() == .success {
                            changes.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    private func getProfile(id: String) async -> FunctionResult {
        
    }

    private func updateConnectionForUser(id: String, newType: ConnectionType) async -> FunctionResult {
//        do {
//            let user = Connection(currentProfile.idusername: username, nickname: nickname, email: email)
//            
//            // Encode and save user data to Firestore
//            let encodedUser = try Firestore.Encoder().encode(user)
//            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
//            
//            // Encode and save log data to Firestore
//            let encodedLog = try Firestore.Encoder().encode(Log(id: user.logID))
//            try await Firestore.firestore().collection("logs").document(user.logID).setData(encodedLog)
//            
//            self.userSession = result.user
//            //let _ = await fetchUser()
//        } catch {
//            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
//        }
//        do {
//            // attempt to locate connection details
//            guard let connectionSnapshot = try? await
//                // will change from "users" to "profiles"
//                Firestore.firestore().collection("users").document(id).collection("connections").document(currentProfile.id).getDocument() else {
//                print("Failed to fetch connection details")
//                return .failure
//            }
//            
//            // attempt to decode profile
//            if let connection = try? connectionSnapshot.data(as: Connection.self) {
//                print("DEBUG: Connection FETCHED")
//                return .success
//            } else {
//                print("Failed to decode profile data")
//                return .failure
//            }
//            
//            let encodedEntry = try Firestore.Encoder().encode(entry)
//            if let _ = _currentLog?.entries.first(where: {$0.id == entry.id}) ?? nil {
//                try await Firestore.firestore().collection("logs").document(_currentLog!.id).collection("entries").document(entry.id).updateData(encodedEntry)
//            } else {
//                try await Firestore.firestore().collection("logs").document(_currentLog!.id).collection("entries").document(entry.id).setData(encodedEntry)
//            }
//        } catch {
//            print("DEBUG: Failed to update workout entry with error \(error.localizedDescription)")
//        }
    }

    private func removeConnectionForUser(id: String) async -> FunctionResult {
//        do {
//            let ref = Firestore.firestore().collection("users").document(id)
//            
//            // Assuming you keep the connections array as a list or dictionary of `Connection` objects,
//            // remove the user from the list and update Firestore.
//            let user = try await ref.getDocument()
//            var currentConnections = user.data()?["connections"] as? [String: Connection] ?? [:]
//            
//            // Remove the connection
//            currentConnections[id] = nil
//            
//            // Update Firestore with the new data.
//            try await ref.updateData(["connections": currentConnections])
//            
//        } catch {
//            print("Error removing connection in Firestore: \(error)")
//        }
//    }
}

enum ConnectionType: Codable {
    case friend
    case inbound
    case outbound
    case blocked
}

struct Connection: Codable {
    var id: String
    var type: ConnectionType
}

struct SocialChange {
    var id: String
    var type: ConnectionType
    var change: Change
    
    enum Change: Codable {
        case add
        case remove
    }
}
