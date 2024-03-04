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
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private init() {}

    func setUser(user: MWUser, completion: @escaping (Result<MWUser, Error>) -> ()) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    func setSupplier(supplier: MWSupplier, completion: @escaping (Result<MWSupplier, Error>) -> ()) {
        usersRef.document(supplier.id).setData(supplier.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(supplier))
            }
        }
    }
}
