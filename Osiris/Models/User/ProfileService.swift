//
//  ProfileService.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//
//  issues:
//  - changes might not be thread-safe, im planning on making it a queue

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
//import SwiftUI

class ProfileService {
    // will change to type Profile
    var currentProfile: Profile? = nil
    
    var friends: [Profile] = []
    var outRequests: [Profile] = []
    var inRequests: [Profile] = []
    var blocked: [Profile] = []
    
//    var changesQueue: QueueArray<SocialChange> = QueueArray()
    var changes: [SocialChange] = []
    
    var connections: [Connection] = [] {
        didSet { Task { await parseConnections() }}
    }
    
    // fetches current user's profile
    func fetchProfile(_ user: User) async -> FunctionResult {
        
        // attempt to locate profile
        let id = user.profileID
        guard let profileSnapshot = try? await Firestore.firestore().collection("profiles").document(id).getDocument() else {
            print("DEBUG: Failed to fetch profile for user")
            return .failure
        }
        
        // attempt to decode profile
        if let profile = try? profileSnapshot.data(as: Profile.self) {
            self.currentProfile = profile
            let _ = await parseConnections()
            print("DEBUG: PROFILE FETCHED")
            return .success
        } else {
            print("DEBUG: Failed to decode profile")
            return .failure
        }
        
    }
    
    // fetches profiles for all connections
    func parseConnections() async -> FunctionResult {
        // attempt to locate profile
        for connection in connections {
            let id = connection.id
            let type = connection.type
            
            // attempt to locate profile
            guard let profileSnapshot = try? await Firestore.firestore().collection("profiles").document(id).getDocument() else {
                print("DEBUG: Failed to fetch profile for user")
                return .failure
            }
            
            // attempt to decode profile
            if let profile = try? profileSnapshot.data(as: Profile.self) {
                switch type {
                case .friend: self.friends.append(profile)
                case .inbound: self.inRequests.append(profile)
                case .outbound: self.outRequests.append(profile)
                case .blocked: self.blocked.append(profile)
                case .other: break // -> to be removed or to be added
                }
                return .success
            } else {
                print("DEBUG: Failed to decode profile data")
                return .failure
            }
        }
        return .success
    }
    
    
    
    func parseChanges() async {
        for (index, change) in changes.enumerated() {
            switch change.type {
            case .friend:
                if let idx = connections.firstIndex(where: { $0.id == change.id } ) {
                    switch change.change {
                    case .add: break
                    case .remove:
                        // first removes the connection for the other user
                        if await removeConnectionForUser(id: change.id) == .success {
                            // ONLY after ensuring both parties have removed the connection
                            // removes pending change from queue
                            if await removeConnectionForUser(id: currentProfile!.id) == .success {
                                // removes connection locally
                                connections.remove(at: idx)
                                changes.remove(at: index)
                            }
                        }
                    case .block:
                        // blocked users are one-sided connections
                        if await updateConnectionForUser(id: currentProfile!.id, type: .blocked) == .success {
                            connections[idx].type = .blocked
                            changes.remove(at: index)
                        }
                    case .unblock: break
                    }
                }
            case .inbound:
                if let idx = connections.firstIndex(where: { $0.id == change.id } ) {
                    switch change.change {
                    case .add:
                        // sets connection to inbound for other party (current user is sending an outgoing request)
                        if await updateConnectionForUser(id: change.id, type: .inbound) == .success {
                            // ONLY after ensuring both users have recieved and sent the request
                            if await updateConnectionForUser(id: currentProfile!.id, type: .blocked) == .success {
                                // sets local current users connection to inbound
                                connections[idx].type = .outbound
                                // removes pending change from queue
                                changes.remove(at: index)
                            }
                        }
                    case .remove:
                        if await removeConnectionForUser(id: change.id) == .success {
                            if await removeConnectionForUser(id: currentProfile!.id) == .success {
                                connections.remove(at: idx)
                                changes.remove(at: index)
                            }
                        }
                    case .block:
                        if await updateConnectionForUser(id: currentProfile!.id, type: .blocked) == .success {
                            connections[idx].type = .blocked
                            changes.remove(at: index)
                        }
                    case .unblock: break
                    }
                }
            case .outbound:
                if let idx = connections.firstIndex(where: { $0.id == change.id } ) {
                    switch change.change {
                    case .add: break
                    case .remove:
                        if await removeConnectionForUser(id: change.id) == .success {
                            if await removeConnectionForUser(id: currentProfile!.id) == .success {
                                connections.remove(at: idx)
                                changes.remove(at: index)
                            }
                        }
                    case .block:
                        if await updateConnectionForUser(id: currentProfile!.id, type: .blocked) == .success {
                            connections[idx].type = .blocked
                            changes.remove(at: index)
                        }
                    case .unblock: break
                    }
                }
            case .blocked:
                if let idx = connections.firstIndex(where: { $0.id == change.id } ) {
                    switch change.change {
                    case .add: break
                    case .remove: break
                    case .block: break
                    case .unblock:
                        if await removeConnectionForUser(id: change.id) == .success {
                            if await removeConnectionForUser(id: currentProfile!.id) == .success {
                                connections.remove(at: idx)
                                changes.remove(at: index)
                            }
                        }
                    }
                }
            case .other:
                if let idx = connections.firstIndex(where: { $0.id == change.id } ) {
                    switch change.change {
                    case .add:
                        if await updateConnectionForUser(id: change.id, type: .inbound) == .success {
                            if await updateConnectionForUser(id: currentProfile!.id, type: .outbound) == .success {
                                connections[idx].type = .outbound
                                changes.remove(at: index)
                            }
                        }
                    case .remove: break
                    case .block:
                        if await updateConnectionForUser(id: currentProfile!.id, type: .blocked) == .success {
                            connections[idx].type = .outbound
                            changes.remove(at: index)
                        }
                    case .unblock: break
                    }
                }
            }
        
        }
    }
    
    private func getProfile(id: String) async -> FunctionResult {
        return .failure
    }
    
    private func checkBlocked(id: String) async -> Bool? {
        // attempt to locate profile
        guard let profileSnapshot = try? await Firestore.firestore().collection("profiles").document(id).getDocument() else {
            print("DEBUG: Failed to fetch profile when checking blocked status")
            return nil
        }
        
        // attempt to decode profile
        if let profile = try? profileSnapshot.data(as: Profile.self) {
            if let connection = profile.connections.first(where: { $0.id == id } ) {
                // if other user has blocked current user
                if connection.type == .blocked {
                    return true
                }
            }
        } else {
            print("DEBUG: Failed to decode profile when checking blocked status")
            return nil
        }
        // otherwise return false
        return false
    }
    
    // updates connection for user on the other end
    // might need to add a special case for adding a connection if this fails (haven't tested)
    private func updateConnectionForUser(id: String, type: ConnectionType) async -> FunctionResult {
        do {
            if let check = await checkBlocked(id: id) {
                if check {
                    // creates new connection
                    let connection = Connection(id: currentProfile!.id, type: type)
                    // attempts to encode connection
                    let encodedConnection = try Firestore.Encoder().encode(connection)
                    try await Firestore.firestore().collection("profiles").document(id)
                        .collection("connections").document(currentProfile!.id).setData(encodedConnection)
                    return .success
                } else {
                    print("Didn't change other user's connection as self is blocked")
                    return .failure
                }
            } else {
                // failed to load other's profile
                return .failure
            }
            
            
        } catch {
            print("DEBUG: Failed to update connection with error \(error.localizedDescription)")
            return .failure
        }
    }

    // removes connection for user on the other end
    private func removeConnectionForUser(id: String) async -> FunctionResult {
        do {
            if let check = await checkBlocked(id: id) {
                if check {
                    try await Firestore.firestore().collection("profiles").document(id)
                        .collection("connections").document(currentProfile!.id).delete()
                    return .success
                } else {
                    print("Didn't remove other user's connection as self is blocked")
                    return .failure
                }
            } else {
                // failed to load other's profile
                return .failure
            }
        } catch {
            print("DEBUG: Failed to remove connection with error \(error.localizedDescription)")
            return .failure
        }
    }
}

enum ConnectionType: Codable {
    case friend
    case inbound
    case outbound
    case blocked
    case other
}

enum Change: Codable {
    case add
    case remove
    case block
    case unblock
}

struct Connection: Codable {
    var id: String
    var type: ConnectionType
}

struct SocialChange {
    var id: String
    var type: ConnectionType
    var change: Change
}
