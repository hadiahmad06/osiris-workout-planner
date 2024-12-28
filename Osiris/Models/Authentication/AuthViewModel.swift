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

@MainActor
class AuthViewModel: ObservableObject {
    //@ var logViewModel = LogViewModel()
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws { //current bug, signing in doesnt fetch data correctly
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, username: String, nickname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, username: username, nickname: nickname, email: email)
            
            // Encode and save user data to Firestore
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil // wipes userSession and sends back to LoginView
            self.currentUser = nil // wipes data from currentUser
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { print("fetch failed, signing out"); signOut(); return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { print("fetch failed, signing out"); signOut(); return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
}

// For XCode previews
extension AuthViewModel {
    static var EXAMPLE_VIEW_MODEL = AuthViewModel()
}
