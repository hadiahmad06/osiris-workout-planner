//
//  CloudService.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/3/25.
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
    var auth: AuthService
    var log: LogService
    @Published var online: Bool = false
    
    init() {
        self.auth = AuthService()
        self.log = LogService()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserSessionChange),
            name: .userSessionChanged,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserSignOut),
            name: .userSignedOut,
            object: nil
        )
        
        Task {
            await fetchData()
        }
    }
    
    // should only change when userSession changes value, not when it goes from nil -> nil
    @objc private func handleUserSessionChange() {
        Task {
            await fetchData()
        }
    }
    
    @objc private func handleUserSignOut() {
        self.online = false
        if self.auth.userSession != nil { self.auth.userSession = nil }
        self.auth.currentUser = nil
        self.log._currentLog = nil
    }
        
    
    func fetchData() async {
        if await auth.fetchUser() == .success {
            if await log.fetchLog(id: auth.currentUser!.logID) == .success {
                self.online = true
            }
        } else {
            self.online = false
            print("Failed to fetch data")
        }
    }
    
    
    
}

// For XCode previews
extension CloudService {
    static var EXAMPLE_CLOUD_SERVICE = CloudService()
}

