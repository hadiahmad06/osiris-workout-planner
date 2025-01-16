//
//  CloudService.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/3/25.
//
//  Controlls Authentication and all other cloud access.
//
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI

protocol CloudServiceProtocol {
    var online: Bool { get }
}

@MainActor
class CloudService: ObservableObject {
    var profile: ProfileService
    var log: LogService
    var plan: PlanService
    
    @Published var online: Bool = false
    
    var userSession: FirebaseAuth.User? {
        didSet { Task { await fetchData() } }
    }
    
    var _currentUser: User?
    var authErrorMessage: String {
        didSet {NotificationCenter.default.post(name: .authErrorMessageChanged, object: nil)}
    }
    
    init() {
        self.profile = ProfileService()
        self.log = LogService()
        self.plan = PlanService()
        self.authErrorMessage = ""
        self.userSession = Auth.auth().currentUser
        self._currentUser = currentUser
        
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        if await fetchUser() == .success {
            if await plan.fetchPlans(currentUser!.plans) == .success {
                if await log.fetchLog(id: currentUser!.logID) == .success {
                    if await profile.fetchProfile(currentUser!) == .success {
                        self.online = true
                        return
                    }
                }
            }
        }
        self.online = false
        print("Failed to fetch data")
    }

    var currentUser: User? {
        get {
            return _currentUser
        }
        set {
            print("DEBUG: Cannot set currentUser property directly")
        }
    }
    
    
    // current bug, signing in doesnt fetch data correctly
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            //let _ = await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String,
                    password: String,
                    username: String,
                    nickname: String) async throws {
        do {
            // Checks if username already exists
            let querySnapshot = try await Firestore.firestore()
                .collection("users")
                .whereField("username", isEqualTo: username)
                .getDocuments()

            if !querySnapshot.isEmpty {
                // If duplicate username -> throw error
                authErrorMessage = "Username already taken."
                throw NSError(domain: "UserCreationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Username already taken."])
            }
            
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = User(id: result.user.uid, username: username, nickname: nickname, email: email)
            
            // Encode and save user data to Firestore
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            // Encode and save profile data to Firestore
            let encodedProfile = try Firestore.Encoder().encode(Profile(user))
            try await Firestore.firestore().collection("profiles").document(user.profileID).setData(encodedProfile)
            
            // Encode and save log data to Firestore
            let encodedLog = try Firestore.Encoder().encode(Log(id: user.logID))
            try await Firestore.firestore().collection("logs").document(user.logID).setData(encodedLog)
            
            self.userSession = result.user
            //let _ = await fetchUser()
        } catch {
            if (error as NSError).code == 17009 {
                authErrorMessage = "Email already in use."
            }
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.online = false
            if userSession != nil { self.userSession = nil }
            self._currentUser = nil
            self.log = LogService()
            self.profile = ProfileService()
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deactivateAccount() async {
        _currentUser?.isActive = false
        await updateUser()
        signOut()
    }
    
    func updateUser() async {
        do {
            let encodedUser = try Firestore.Encoder().encode(_currentUser)
            try await Firestore.firestore().collection("users").document(_currentUser!.id).updateData(encodedUser)
        } catch {
            print("DEBUG: Failed to update user data with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async -> FunctionResult {
        // attempt to get uid
        guard let uid = Auth.auth().currentUser?.uid else {
            print("fetch failed, signing out")
            signOut()
            return .failure
        }
        
        // fetch user
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {
            print("Failed to fetch user data")
            authErrorMessage = "Try again later."
            return .failure
        }
        
        // attempt to decode user
        if let user = try? snapshot.data(as: User.self) {
            // if user is active, continue
            if user.isActive {
                _currentUser = user
                // updates session
//                updateSession()
                print("DEBUG: USER FETCHED")
                return .success
                
            } else {
                print("User is not active")
                authErrorMessage = "Your account has been suspended. Please contact support."
                signOut()
                return .failure
                
            }
        } else {
            print("Failed to decode user data")
            authErrorMessage = "We failed to access your account, please try again later."
            signOut()
            return .failure
        }
    }
    
}

// For XCode previews
extension CloudService {
    static var EXAMPLE_CLOUD_SERVICE: CloudService = {
        var x = CloudService()
        
        let currentUser = User(id: "", username: "user.name43", nickname: "N1CKN4M3", email: "hireme@email.com")
        x.currentUser = currentUser
        x.profile.currentProfile?.trophies = ["star.fill", "trophy.fill", "moon.stars.fill"]
        x.profile.friends = [Profile(currentUser)]
        x.profile.inRequests = [Profile(currentUser)]
        x.profile.outRequests = [Profile(currentUser)]
        x.profile.blocked = [Profile(currentUser)]
        
        return x
    }()
}

extension Notification.Name {
    static let authErrorMessageChanged = Notification.Name("authErrorMessageChanged")
}
