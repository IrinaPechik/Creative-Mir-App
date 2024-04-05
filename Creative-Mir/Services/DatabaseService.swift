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
    
    private var bookingRef: CollectionReference {
        return db.collection("booking")
    }
    
    private init() {}
    
    // MARK: -  Setting all types of users to data base.

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
    // MARK: - User settings
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
    // MARK: -  Getting all types of users to data base.
    
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
    
    func getSupplier(id: String, completion: @escaping (Result<MWSupplier, Error>) -> ()) {
        suppliersRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var user: MWSupplier
                for doc in qSnap.documents {
                    if let user1 = MWSupplier(doc: doc), user1.id == id {
                        user = user1
                        completion(.success(user))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func getVenue(id: String, completion: @escaping (Result<MWVenue, Error>) -> ()) {
        venuesRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var user: MWVenue
                for doc in qSnap.documents {
                    if let user1 = MWVenue(doc: doc), user1.id == id {
                        user = user1
                        completion(.success(user))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func getSuppliers(completion: @escaping (Result<[MWSupplier], Error>) -> ()) {
        suppliersRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var suppliers = [MWSupplier]()
                for doc in qSnap.documents {
                    if let supplier = MWSupplier(doc: doc) {
                        suppliers.append(supplier)
                    }
                }
                completion(.success(suppliers))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func getVenues(completion: @escaping (Result<[MWVenue], Error>) -> ()) {
        venuesRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var venues = [MWVenue]()
                for doc in qSnap.documents {
                    if let venue = MWVenue(doc: doc) {
                        venues.append(venue)
                    }
                }
                completion(.success(venues))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    // MARK: - Info about advertisements likes
    

    // MARK:  Метод добавления поставщика услуг в избранное покупателя
    func setLikedSupplierToCustomer(customerId: String, supplier: MWSupplier, completion: @escaping (Error?) -> Void) {
        let likedSuppliersRef = customersRef.document(customerId).collection("likedSuppliers")
        
        likedSuppliersRef.addDocument(data: supplier.representation) { error in
            if let error = error {
                print("Error adding product to favorites: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Product added to favorites successfully")
                completion(nil)
            }
        }
    }
    
    // MARK:  Метод добавления арендодателя в избранное покупателя
    func setLikedVenueToCustomer(customerId: String, venue: MWVenue, completion: @escaping (Error?) -> Void) {
        let likedVenuesRef = customersRef.document(customerId).collection("likedVenues")
        
        likedVenuesRef.addDocument(data: venue.representation) { error in
            if let error = error {
                print("Error adding product to favorites: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Product added to favorites successfully")
                completion(nil)
            }
        }
    }
    
    // MARK:  Метод добавления идеи в избранное покупателя
    func setLikedIdeaToCustomer(customerId: String, idea: MWIdea, completion: @escaping (Error?) -> Void) {
        let likedIdaeRef = customersRef.document(customerId).collection("likedIdeas")
        
        likedIdaeRef.addDocument(data: idea.representation) { error in
            if let error = error {
                print("Error adding idea to favorites: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Idea added to favorites successfully")
                completion(nil)
            }
        }
    }
    
    // MARK: Метод удаления поставщика услуг из избранного покупателя
    func deleteLikedSupplierToCustomer(customerId: String, supplier: MWSupplier, completion: @escaping (Error?) -> Void) {
        let likedSuppliersRef = customersRef.document(customerId).collection("likedSuppliers")
        let query = likedSuppliersRef.whereField("id", isEqualTo: supplier.id)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error removing product from favorites: \(error.localizedDescription)")
                completion(error)
                return
            }
            guard let documents = snapshot?.documents else {
                print("Document not found")
                completion(nil)
                return
            }
            
            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error removing product from favorites: \(error.localizedDescription)")
                        completion(error)
                    } else {
                        print("Product removed from favorites successfully")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    // MARK: Метод удаления арендодателя из избранного покупателя
    func deleteLikedVenueToCustomer(customerId: String, venue: MWVenue, completion: @escaping (Error?) -> Void) {
        let likedVenuesRef = customersRef.document(customerId).collection("likedVenues")
        let query = likedVenuesRef.whereField("id", isEqualTo: venue.id)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error removing product from favorites: \(error.localizedDescription)")
                completion(error)
                return
            }
            guard let documents = snapshot?.documents else {
                print("Document not found")
                completion(nil)
                return
            }
            
            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error removing product from favorites: \(error.localizedDescription)")
                        completion(error)
                    } else {
                        print("Product removed from favorites successfully")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    // MARK: Метод удаления идеи из избранного покупателя
    func deleteLikedIdeaToCustomer(customerId: String, idea: MWIdea, completion: @escaping (Error?) -> Void) {
        let likedIdeaRef = customersRef.document(customerId).collection("likedIdeas")

        let query = likedIdeaRef.whereField("id", isEqualTo: idea.id)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error removing idea from favorites: \(error.localizedDescription)")
                completion(error)
                return
            }
            guard let documents = snapshot?.documents else {
                print("Document not found")
                completion(nil)
                return
            }
            
            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error removing idea from favorites: \(error.localizedDescription)")
                        completion(error)
                    } else {
                        print("Idea removed from favorites successfully")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    // MARK: Метод получения избранных поставщиков услуг
    func getLikedSuppliers(customerId: String, completion: @escaping (Result<[MWSupplier], Error>) -> ()) {
        let likedSuppliersRef = customersRef.document(customerId).collection("likedSuppliers")

        likedSuppliersRef.getDocuments { snapshot, error in
            if let error = error {
                            print("Error fetching favorite suppliers: \(error.localizedDescription)")
                            completion(.failure(error))
                            return
            }

            guard let documents = snapshot?.documents else {
                print("No favorite suppliers found")
                let customError = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "No favorite suppliers found"])
                completion(.failure(customError))
                return
            }
            if documents.isEmpty {
                print("No favorite suppliers found")
                let customError = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "No favorite suppliers found"])
                completion(.failure(customError))
                return
            }
//            let likedSuppliers = documents.compactMap {document -> MWSupplier? in
//                guard let supplierId = document.data()["id"] as? String else {
//                    print("supplier not found")
//                    return nil
//                }
//                return MWSupplier(id: supplierId)
//            }
//            completion(.success(likedSuppliers))
            let likedSuppliers = documents.compactMap { document -> MWSupplier? in
                        let data = document.data()
                        guard let id = data["id"] as? String,
                              let storyAboutYourself = data["storyAboutYourself"] as? String,
                              let advertisementsData = data["advertisements"] as? [[String: Any]] else {
                            print("Invalid supplier data")
                            return nil
                        }
                        var advertisements: [SupplierAdvertisemnt] = []
                        for advData in advertisementsData {
                            let adv = SupplierAdvertisemnt(from: advData)
                            advertisements.append(adv)
                        }
                        return MWSupplier(id: id, storyAboutYourself: storyAboutYourself, advertisements: advertisements)
                    }
                    completion(.success(likedSuppliers))
        }
    }
    
    // MARK: Метод получения избранных арендодателей
    func getLikedVenues(customerId: String, completion: @escaping (Result<[MWVenue], Error>) -> ()) {
        let likedVenuesRef = customersRef.document(customerId).collection("likedVenues")

        likedVenuesRef.getDocuments { snapshot, error in
            if let error = error {
                            print("Error fetching favorite venues: \(error.localizedDescription)")
                            completion(.failure(error))
                            return
            }
                        
            guard let documents = snapshot?.documents else {
                print("No favorite venues found")
                let customError = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "No favorite venues found"])
                completion(.failure(customError))
                return
            }
            if documents.isEmpty {
                print("No favorite venues found")
                let customError = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "No favorite venues found"])
                completion(.failure(customError))
                return
            }
        
            let likedVenues = documents.compactMap { document -> MWVenue? in
                        let data = document.data()
                        guard let id = data["id"] as? String,
                              let advertisementsData = data["advertisements"] as? [[String: Any]] else {
                            print("Invalid supplier data")
                            return nil
                        }
                        var advertisements: [VenueAdvertisemnt] = []
                        for advData in advertisementsData {
                            let adv = VenueAdvertisemnt(from: advData)
                            advertisements.append(adv)
                        }
                        return MWVenue(id: id, advertisements: advertisements)
                    }
                    completion(.success(likedVenues))
        }
    }
    
    // MARK: Метод получения избранных идей
    func getLikedIdeas(customerId: String, completion: @escaping (Result<[MWIdea], Error>) -> ()) {
        let likedIdeasRef = customersRef.document(customerId).collection("likedIdeas")

        likedIdeasRef.getDocuments { snapshot, error in
            if let error = error {
                            print("Error fetching favorite ideas: \(error.localizedDescription)")
                            completion(.failure(error))
                            return
            }
                        
            guard let documents = snapshot?.documents else {
                print("No favorite ideas found")
                let customError = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "No favorite ideas found"])
                completion(.failure(customError))
                return
            }
            if documents.isEmpty {
                print("No favorite idaes found")
                let customError = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "No favorite ideas found"])
                completion(.failure(customError))
                return
            }
        
            let likedIdeas = documents.compactMap { document -> MWIdea? in
                        let data = document.data()
                        guard let id = data["id"] as? String,
                              let categoryId = data["categoryId"] as? String,
                              let name = data["name"] as? String,
                              let description = data["description"] as? String,
                              let shortDescription = data["shortDescription"] as? String,
                              let ageRestriction = data["ageRestriction"] as? Int,
                              let venuesRecommendations = data["venuesRecommendations"] as? String,
                              let suppliersRecommendations = data["suppliersRecommendations"] as? String,
                              let peopleLimit = data["peopleLimit"] as? Int,
                              let colorScheme = data["colorScheme"] as? String
                               else {
                            print("Invalid idea data")
                            return nil
                        }
                        return MWIdea(id: id, categoryId: categoryId, name: name, description: description, shortDescription: shortDescription, ageRestriction: ageRestriction, venuesRecommendations: venuesRecommendations, suppliersRecommendations: suppliersRecommendations, peopleLimit: peopleLimit, colorScheme: colorScheme)
                    }
                    completion(.success(likedIdeas))
        }
    }
    
    // MARK: Метод проверки есть ли поставщик услуг в избранном у покупателя
    func checkWasSupplierLikedById(customerId: String, supplierId: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let likedSuppliersRef = customersRef.document(customerId).collection("likedSuppliers")

        let query = likedSuppliersRef.whereField("id", isEqualTo: supplierId)
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error checking if supplier is liked by id: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No favorite products found for id: \(supplierId)")
                completion(.success(false))
                return
            }
            
            // Если количество документов больше нуля, значит продукт найден в списке избранных
            let isLiked = documents.count > 0
            completion(.success(isLiked))
        }
    }
    
    // MARK: Метод проверки есть ли арендодатель в избранном у покупателя
    func checkWasVenueLikedById(customerId: String, venueId: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let likedVenuesRef = customersRef.document(customerId).collection("likedVenues")

        let query = likedVenuesRef.whereField("id", isEqualTo: venueId)
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error checking if supplier is liked by id: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No favorite products found for id: \(venueId)")
                completion(.success(false))
                return
            }
            
            // Если количество документов больше нуля, значит продукт найден в списке избранных
            let isLiked = documents.count > 0
            completion(.success(isLiked))
        }
    }
    
    // MARK: Метод проверки есть ли арендодатель в избранном у покупателя
    func checkWasIdeaLikedById(customerId: String, ideaId: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let likedIdeasRef = customersRef.document(customerId).collection("likedIdeas")

        let query = likedIdeasRef.whereField("id", isEqualTo: ideaId)
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error checking if idea is liked by id: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No favorite ideas found for id: \(ideaId)")
                completion(.success(false))
                return
            }
            
            // Если количество документов больше нуля, значит продукт найден в списке избранных
            let isLiked = documents.count > 0
            completion(.success(isLiked))
        }
    }
    // MARK: - Getting and setting ideas and categories
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
    
    func setBooking(booking: MWBooking, completion: @escaping (Result<MWBooking, Error>) -> ()) {
        bookingRef.document(booking.id).setData(booking.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(booking))
            }
        }
    }
    // MARK: - Getting bookings
    
    // MARK: Get all bookings by performer id
    func getBookingsByPerformerId(by performerId: String, completion: @escaping (Result<[MWBooking], Error>) -> ()) {
        bookingRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var bookings = [MWBooking]()
                for doc in qSnap.documents {
                    if let booking = MWBooking(doc: doc), booking.performerId == performerId, booking.bookingStatus == "отправлена" {
                        bookings.append(booking)
                    }
                }
                completion(.success(bookings))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Get bookings by customer id
    func getBookingsByCustomerid(by customerId: String, completion: @escaping (Result<[MWBooking], Error>) -> ()) {
        bookingRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var bookings = [MWBooking]()
                for doc in qSnap.documents {
                    if let booking = MWBooking(doc: doc), booking.customerId == customerId {
                        bookings.append(booking)
                    }
                }
                completion(.success(bookings))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
