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
    
    private var ideasRef: CollectionReference {
        return db.collection("ideas")
    }
    
    private var ideasCategoryRef: CollectionReference {
        return db.collection("ideaCategories")
    }
    
    private init() {}

    func setUser(user: MWUser, imageData: Data, completion: @escaping (Result<MWUser, Error>) -> ()) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                // TODO: Проверить, по какому id сохранять картинку
                StorageService.shared.uploadUserAvatarImage(userId: user.id, image: imageData) { result in
                    switch result {
                    case .success(let sizeInfo):
                        print(sizeInfo)
                        completion(.success(user))
                    case .failure(let error):
                        print("error \(error)")
                    }
                }
            }
        }
    }
    
    func setSupplier(supplier: MWSupplier, images: [Data], completion: @escaping (Result<MWSupplier, Error>) -> ()) {
        suppliersRef.document(supplier.id).setData(supplier.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                StorageService.shared.uploadSuppliersPhotoFromWorkImages(supplierId: supplier.id, images: images) { result in
                    switch result {
                    case .success(let sizeInfo):
                        print(sizeInfo)
                        completion(.success(supplier))
                    case .failure(let error):
                        print("error \(error)")
                    }
                }
            }
        }
    }
    
    func setVenue(venue: MWVenue, images: [Data],  completion: @escaping (Result<MWVenue, Error>) -> ()) {
        venuesRef.document(venue.id).setData(venue.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                StorageService.shared.uploadVenuesPhotoFromWorkImages(venueId: venue.id, images: images) { result in
                    switch result {
                    case .success(let sizeInfo):
                        print(sizeInfo)
                        completion(.success(venue))
                    case .failure(let error):
                        print("error \(error)")
                    }
                }
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
    
    func getIdeas(by categoryId: String, completion: @escaping (Result<[MWIdea], Error>) -> ()) {
        ideasRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var ideas = [MWIdea]()
                for doc in qSnap.documents {
                    if let idea = MWIdea(doc: doc), idea.categoryId == categoryId {
                        ideas.append(idea)
                    }
                }
                completion(.success(ideas))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func setIdea(idea: MWIdea, completion: @escaping (Result<MWIdea, Error>) -> ()) {
        ideasRef.document(idea.id).setData(idea.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(idea))
            }
        }
    }
    
    func getIdeaCategories(completion: @escaping (Result<[MWIdeaCategory], Error>) -> ()) {
        ideasCategoryRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var ideas = [MWIdeaCategory]()
                for doc in qSnap.documents {
                    if let idea = MWIdeaCategory(doc: doc) {
                        ideas.append(idea)
                    }
                }
                completion(.success(ideas))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func setIdeaCategories(category: MWIdeaCategory, completion: @escaping (Result<MWIdeaCategory, Error>) -> ()) {
        ideasCategoryRef.document(category.id).setData(category.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(category))
            }
        }
    }
    
    func getUserRole(email: String, completion: @escaping (Result<String, Error>) -> ()) {
        usersRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var user: MWUser
                for doc in qSnap.documents {
                    if let user1 = MWUser(doc: doc), user1.email == email {
                        user = user1
                        completion(.success(user.role))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func getUser(id: String, completion: @escaping (Result<MWUser, Error>) -> ()) {
        usersRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var user: MWUser
                for doc in qSnap.documents {
                    if let user1 = MWUser(doc: doc), user1.id == id {
                        user = user1
                        completion(.success(user))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
}
