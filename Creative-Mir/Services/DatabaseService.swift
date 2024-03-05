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
    
    private var suppliersRef: CollectionReference {
        return db.collection("suppliers")
    }
    
    private var venuesRef: CollectionReference {
        return db.collection("venues")
    }
    
    private var customersRef: CollectionReference {
        return db.collection("customers")
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
        suppliersRef.document(supplier.id).setData(supplier.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(supplier))
            }
        }
    }
    
    func setVenue(venue: MWVenue, completion: @escaping (Result<MWVenue, Error>) -> ()) {
        venuesRef.document(venue.id).setData(venue.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(venue))
            }
        }
    }
    
    func setCustomer(customer: MWCustomer, completion: @escaping (Result<MWCustomer, Error>) -> ()) {
        customersRef.document(customer.id).setData(customer.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(customer))
            }
        }
    }
    
    func checkUserExist(email: String, completion: @escaping (Bool) -> Void) {
        usersRef.whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                completion(false)
                return
            }
            // Проверяем, есть ли возвращенные документы
            if let querySnapshot = querySnapshot {
                if querySnapshot.isEmpty {
                    // Документов с указанным email не найдено
                    completion(false)
                } else {
                    // Найден один или более документов с указанным email
                    completion(true)
                }
            } else {
                // Запрос вернул nil
                completion(false)
            }
        }
    }
}
