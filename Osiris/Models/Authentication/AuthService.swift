//
//  Untitled.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/23/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@Observable
class AuthService {
    var userSession: FirebaseAuth.User?  {
        didSet {
            // Trigger notification when userSession changes
            NotificationCenter.default.post(name: .userSessionChanged, object: nil)
        }
    }
    
    var _currentUser: User?
    var authErrorMessage: String
    
//    func userSessionStatus() -> Bool {
//        if userSession != nil {
//            return true
//        } else {
//            return false
//        }
//    }

    var currentUser: User? {
        get {
            return _currentUser
        }
        set {
            print("DEBUG: Cannot set currentUser property directly")
        }
    }
    
    init(currentUser: User? = nil) {
        self.authErrorMessage = ""
        self.userSession = Auth.auth().currentUser
        self._currentUser = currentUser
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
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = User(id: result.user.uid, username: username, nickname: nickname, email: email)
            
            // Encode and save user data to Firestore
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            // Encode and save log data to Firestore
            let encodedLog = try Firestore.Encoder().encode(Log(id: user.logID))
            try await Firestore.firestore().collection("logs").document(user.logID).setData(encodedLog)
            
            self.userSession = result.user
            //let _ = await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: .userSignedOut, object: nil)
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

extension Notification.Name {
    static let userSessionChanged = Notification.Name("userSessionChanged")
    static let userSignedOut = Notification.Name("userSignedOut")
}
