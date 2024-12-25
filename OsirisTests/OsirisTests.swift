////
////  OsirisTests.swift
////  OsirisTests
////
////  Created by Hadi Ahmad on 12/17/24.
////
//
//import XCTest
//import Testing
//import Foundation
//
//import Firebase
//
//import FirebaseAuth
//import FirebaseFirestoreInternal
//
//
////@testable import Osiris
//
//final class OsirisTests: XCTestCase {
//
//    // Setup Firebase before running any tests
//    override class func setUp() {
//        super.setUp()
//        
//        // Make sure Firebase is initialized
//        FirebaseApp.configure()
//    }
//
//    @Test func example() async throws {
//        // This is where you write your test logic.
//        // You can use APIs like `#expect(...)` to check expected conditions.
//        
//        // Example Firebase test (Replace this with your own logic)
//        let db = Firestore.firestore()
//        let testCollection = db.collection("testCollection")
//        
//        // Example of adding data to Firestore
//        //try await testCollection.addDocument(data: ["name": "Hadi"])
//        
//        // Example of reading data from Firestore
//        //let snapshot = try await testCollection.getDocuments()
//        //XCTAssertNotNil(snapshot)
//        
//        // Example assertion: Check if the document contains the expected name
//        //let document = snapshot.documents.first
//        //XCTAssertEqual(document?.data()["name"] as? String, "Hadi")
//    }
//}
