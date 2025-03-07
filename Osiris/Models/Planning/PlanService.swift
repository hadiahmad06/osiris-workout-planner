//
//  PlanService.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/10/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class PlanService {
    private var _plans: [Plan] = []
    private var _planIds: [String] = []
    
    var plans: [Plan] {
        get {
            _plans
        }
        set {
            print("DEBUG: Cannot set plans directly")
        }
    }
    
    var planIds: [String] {
        get {
            _planIds
        }
        set {
            print("DEBUG: Cannot set planIDS directly")
        }
    }
    
//    init(plans: [String]) async {
//        self._planIDs = plans
//        let _ = await fetchPlans(plans)
//    }
    
    func fetchPlans(_ plans: [String]) async -> FunctionResult {
        for id in plans {
            guard let planSnapshot =
                try? await Firestore.firestore().collection("plans").document(id).getDocument() else {
                print("Failed to fetch plan: \(id)")
                self._plans = []
                return .failure
            }
            
            // attempt to decode plan
            if let plan = try? planSnapshot.data(as: Plan.self) {
                self._plans.append(plan)
                print("DEBUG: PLAN \(id) FETCHED")
            } else {
                print("Failed to decode plan: \(id)")
                self._plans = []
                return .failure
            }
        }
        self._planIds = plans
        //if list is empty
        return .success
    }
    
    func getPlan(fromId id: String) async -> Plan? {
        if let plan = plans.first(where: { $0.id == id }) {
            return plan
        } else {
            guard let planSnapshot =
                try? await Firestore.firestore().collection("plans").document(id).getDocument() else {
                print("Failed to fetch plan: \(id)")
                return nil
            }
            
            // attempt to decode plan
            if let plan = try? planSnapshot.data(as: Plan.self) {
                print("DEBUG: PLAN \(id) FETCHED")
                return plan
            } else {
                print("Failed to decode plan: \(id)")
                return nil
            }
        }
    }
    
    
    
    
}
