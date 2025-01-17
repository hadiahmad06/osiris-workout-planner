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
    
    var socialErrorMessage = "" {
        didSet {
            NotificationCenter.default.post(name: .socialErrorMessageChanged, object: nil)
        }
    }
    
//    var changesQueue: QueueArray<SocialChange> = QueueArray()
    var changes: [SocialChange] = [] {
        didSet { if !changes.isEmpty {Task { await pushChanges() }}}
    }
    
    var connections: [Connection] = [] {
        didSet { Task { await parseConnections() }}
    }
    
    func queueChange(forID id: String, change: Change) async {
        // if they somehow have their own profile in a connections menu
        if id == currentProfile!.id {
            socialErrorMessage = "how did you end up here??"
        } else {
            // attempt to locate profile
            guard let profileSnapshot = try? await Firestore.firestore().collection("profiles").document(id).getDocument() else {
                print("DEBUG: Failed to fetch profile to queue a change")
                return
            }
            
            // attempt to decode profile
            if let profile = try? profileSnapshot.data(as: Profile.self) {
                let id = profile.id
                let type: ConnectionType
                
                // checks for if theres already a connection
                if let connection = connections.first(where: { $0.id == id }) {
                    type = connection.type
                } else {
                    // if no connection, add to cached
                    connections.append(Connection(id: id, type: .cached))
                    type = .cached
                }
                // pushes change to queue
                changes.append(SocialChange(id: id, type: type, change: change))
            }
        }
    }
    
    func queueChange(forUsername username: String, change: Change) async {
        // if they enter their own username
        if username == currentProfile!.username {
            socialErrorMessage = "Cannot add yourself as a friend 🫵😂"
        } else {
            let ref = Firestore.firestore().collection("profiles")
            
            // attempt to locate profile
            guard let querySnapshot = try? await ref.whereField("username", isEqualTo: username).getDocuments() else {
                print("DEBUG: Failed to fetch profile to queue a change")
                return
            }
            // if a profile is found
            if let snapshot = querySnapshot.documents.first {
                // attempt to decode profile
                if let profile = try? snapshot.data(as: Profile.self) {
                    let id = profile.id
                    let type: ConnectionType
                    
                    // checks for if theres already a connection
                    if let connection = connections.first(where: { $0.id == id }) {
                        type = connection.type
                    } else {
                        // if no connection, add to cached
                        connections.append(Connection(id: id, type: .cached))
                        type = .cached
                    }
                    // pushes change to queue
                    changes.append(SocialChange(id: id, type: type, change: change))
                } else {
                    print("DEBUG: Failed to decode profile snapshot")
                }
            } else {
                print("DEBUG: No profile found with username: \(username)")
            }
        }
    }
    
    // fetches current user's profile
    func fetchProfile(_ user: User) async -> FunctionResult {
        let ref = Firestore.firestore().collection("profiles").document(user.profileID)
        // attempt to locate profile
        guard let profileSnapshot = try? await ref.getDocument() else {
            print("DEBUG: Failed to fetch profile for user")
            return .failure
        }
        guard let connectionsSnapshot = try? await ref.collection("connections").getDocuments() else {
            print("DEBUG: Failed to fetch connections for user")
            return .failure
        }
        
        // attempt to decode profile
        if let profile = try? profileSnapshot.data(as: Profile.self) {
            self.currentProfile = profile
            print("DEBUG: PROFILE FETCHED")
            // attempt to decode connections
            var connections: [Connection] = []
            for document in connectionsSnapshot.documents {
                if let connection = try? document.data(as: Connection.self) {
                    connections.append(connection)
                }
            }
            self.connections = connections
            print("DEBUG: CONNECTIONS FETCHED")
            return .success
        } else {
            print("DEBUG: Failed to decode profile")
            return .failure
        }
    }
    
    
//    guard let connectionsSnapshot = try? await Firestore.firestore().collection("profiles").document(id).collection("connections").getDocuments() else {
//        print("DEBUG: Failed to fetch connections for user")
//        //return .failure
//    }
    
    // fetches profiles for all connections
    func parseConnections() async -> FunctionResult {
        // reset parsed connections
        friends = []; inRequests = []; outRequests = []
        
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
                case .cached: break // -> to be removed or to be added
                }
            } else {
                print("DEBUG: Failed to decode profile data")
                return .failure
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("connectionsParsed"), object: nil)
        return .success
    }
    
    func pushChanges() async {
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
                            if await removeConnectionForSelf(id: change.id) == .success {
                                // removes connection locally
                                connections.remove(at: idx)
                                changes.remove(at: index)
                            }
                        }
                    case .block:
                        // blocked users are one-sided connections
                        if await updateConnectionForSelf(id: change.id, type: .blocked) == .success {
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
                            if await updateConnectionForSelf(id: change.id, type: .blocked) == .success {
                                // sets local current users connection to inbound
                                connections[idx].type = .outbound
                                // removes pending change from queue
                                changes.remove(at: index)
                            }
                        }
                    case .remove:
                        if await removeConnectionForUser(id: change.id) == .success {
                            if await removeConnectionForSelf(id: change.id) == .success {
                                connections.remove(at: idx)
                                changes.remove(at: index)
                            }
                        }
                    case .block:
                        if await updateConnectionForSelf(id: change.id, type: .blocked) == .success {
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
                            if await removeConnectionForSelf(id: change.id) == .success {
                                connections.remove(at: idx)
                                changes.remove(at: index)
                            }
                        }
                    case .block:
                        if await updateConnectionForSelf(id: change.id, type: .blocked) == .success {
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
                            if await removeConnectionForSelf(id: change.id) == .success {
                                connections.remove(at: idx)
                                changes.remove(at: index)
                            }
                        }
                    }
                }
            case .cached:
                if let idx = connections.firstIndex(where: { $0.id == change.id } ) {
                    switch change.change {
                    case .add:
                        if await updateConnectionForUser(id: change.id, type: .inbound) == .success {
                            if await updateConnectionForSelf(id: change.id, type: .outbound) == .success {
                                connections[idx].type = .outbound
                                changes.remove(at: index)
                            }
                        }
                    case .remove: break
                    case .block:
                        if await updateConnectionForSelf(id: change.id, type: .blocked) == .success {
                            connections[idx].type = .outbound
                            changes.remove(at: index)
                        }
                    case .unblock: break
                    }
                }
            }
        
        }
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
    
    private func updateConnectionForSelf(id: String, type: ConnectionType) async -> FunctionResult {
        do {
            // creates new connection
            let connection = Connection(id: id, type: type)
            // attempts to encode connection
            let encodedConnection = try Firestore.Encoder().encode(connection)
            try await Firestore.firestore().collection("profiles").document(currentProfile!.id)
                .collection("connections").document(id).setData(encodedConnection)
            return .success
        } catch {
            print("DEBUG: Failed to update connection with error \(error.localizedDescription)")
            return .failure
        }
    }
    
    private func removeConnectionForSelf(id: String) async -> FunctionResult {
        do {
            try await Firestore.firestore().collection("profiles").document(currentProfile!.id)
                .collection("connections").document(id).delete()
            return .success
        } catch {
            print("DEBUG: Failed to remove connection with error \(error.localizedDescription)")
            return .failure
        }
    }
    
    // updates connection for user on the other end
    // might need to add a special case for adding a connection if this fails (haven't tested)
    private func updateConnectionForUser(id: String, type: ConnectionType) async -> FunctionResult {
        do {
            if let check = await checkBlocked(id: id) {
                if check {
                    print("Didn't change other user's connection as self is blocked")
                    return .failure
                } else {
                    // creates new connection
                    let connection = Connection(id: currentProfile!.id, type: type)
                    // attempts to encode connection
                    let encodedConnection = try Firestore.Encoder().encode(connection)
                    try await Firestore.firestore().collection("profiles").document(id)
                        .collection("connections").document(currentProfile!.id).setData(encodedConnection)
                    return .success
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
                    print("Didn't remove other user's connection as self is blocked")
                    return .failure
                } else {
                    try await Firestore.firestore().collection("profiles").document(id)
                        .collection("connections").document(currentProfile!.id).delete()
                    return .success
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

extension Notification.Name {
    static let socialErrorMessageChanged = Notification.Name("socialErrorMessageChanged")
    static let connectionsParsed = Notification.Name("connectionsParsed")
}

enum ConnectionType: Codable {
    case friend
    case inbound
    case outbound
    case blocked
    case cached
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
