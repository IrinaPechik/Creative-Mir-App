//
//  StorageService.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 12.03.2024.
//

import Foundation
import FirebaseStorage

class StorageService {
    static let shared = StorageService()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    private var ideaCategoriesRef: StorageReference {
        storage.child("ideaCategories")
    }
    
    private var ideasRef: StorageReference {
        storage.child("ideas")
    }
    
    private var usersRef: StorageReference {
        storage.child("users")
    }
    
    private var suppliersRef: StorageReference {
        storage.child("suppliers")
    }
    
    private var venuesRef: StorageReference {
        storage.child("venues")
    }
    
    // MARK: - Idea Category Images
    func uploadIdeaCategoryImage(categoryId: String, image: Data, completion: @escaping (Result<String, Error>) -> ()) {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        ideaCategoriesRef.child(categoryId).putData(image, metadata: metadata) { metadata, error in
            guard let metadata = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success("Размер полученного изображения: \(metadata.size)"))
        }
    }
    
    func downloadCategoryImage(id: String, completion: @escaping (Result<Data, Error>) -> ()) {
        ideaCategoriesRef.child(id).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
    }
    
    // MARK: - Idea images
    func uploadIdeaImage(ideaId: String, image: Data, completion: @escaping (Result<String, Error>) -> ()) {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        ideasRef.child(ideaId).putData(image, metadata: metadata) { metadata, error in
            guard let metadata = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success("Размер полученного изображения: \(metadata.size)"))
        }
    }
    
    func downloadIdeaImage(id: String, completion: @escaping (Result<Data, Error>) -> ()) {
        ideasRef.child(id).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
    }
    // MARK: - User avatars
    func uploadUserAvatarImage(userId: String, image: Data, completion: @escaping (Result<String, Error>) -> ()) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        usersRef.child(userId).putData(image, metadata: metadata) { metadata, error in
            guard let metadata = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success("Размер полученного изображения: \(metadata.size)"))
        }
    }
    
    func downloadUserAvatarImage(id: String, completion: @escaping (Result<Data, Error>) -> ()) {
        usersRef.child(id).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
    }
    
    // MARK: - Suppliers photo from work
    func uploadSuppliersPhotoFromWorkImages(supplierId: String, images: [Data], completion: @escaping (Result<String, Error>) -> ()) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        for (index, image) in images.enumerated() {
            suppliersRef.child("\(supplierId)/\(index)").putData(image, metadata: metadata) { metadata, error in
                guard let metadata = metadata else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    return
                }
                completion(.success("Размер полученного изображения: \(metadata.size)"))
            }
        }
    }
    
    func downloadSuppliersPhotoFromWorkImages(id: String, completion: @escaping (Result<[Data], Error>) -> ()) {
        let imageRef = suppliersRef.child(id)
        
        imageRef.listAll { result, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            var allImages: [Data] = []
            let group = DispatchGroup()
            
            for item in result!.items {
                group.enter()
                item.getData(maxSize: 2 * 1024 * 1024) { data, error in
                    defer {
                        group.leave()
                    }
                    
                    if let data = data {
                        allImages.append(data)
                    } else if let error = error {
                        completion(.failure(error))
                        return
                    }
                }
            }
            group.notify(queue: .main) {
                completion(.success(allImages))
            }
        }
    }
    
    // MARK: - Venues photo from work
    func uploadVenuesPhotoFromWorkImages(venueId: String, images: [Data], completion: @escaping (Result<String, Error>) -> ()) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        for (index, image) in images.enumerated() {
            venuesRef.child("\(venueId)/\(index)").putData(image, metadata: metadata) { metadata, error in
                guard let metadata = metadata else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    return
                }
                completion(.success("Размер полученного изображения: \(metadata.size)"))
            }
        }
    }
    
    func downloadVenuesPhotoFromWorkImages(id: String, completion: @escaping (Result<[Data], Error>) -> ()) {
        let imageRef = venuesRef.child(id)
        
        imageRef.listAll { result, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            var allImages: [Data] = []
            let group = DispatchGroup()
            
            for item in result!.items {
                group.enter()
                item.getData(maxSize: 2 * 1024 * 1024) { data, error in
                    defer {
                        group.leave()
                    }
                    
                    if let data = data {
                        allImages.append(data)
                    } else if let error = error {
                        completion(.failure(error))
                        return
                    }
                }
            }
            group.notify(queue: .main) {
                completion(.success(allImages))
            }
        }
    }
}
