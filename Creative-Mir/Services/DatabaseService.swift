//
//  DatabaseService.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 23.01.2024.
//

import Foundation
import FirebaseFirestore

class DatabaseService {
    static let shared = DatabaseService()
    private let db = Firestore.firestore()
    
    private var customersRef: CollectionReference {
        return db.collection("customers")
    }
    
    private init() {}
    
    func createCustomer(customer: Customer) async throws {
        try customersRef.document(customer.id).setData(from: customer, merge: false)
    }
}
