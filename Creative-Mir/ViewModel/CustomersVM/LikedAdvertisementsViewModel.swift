//
//  LikedAdvertisementsViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 15.03.2024.
//

import Foundation

class LikedAdvertisementsViewModel: ObservableObject {
    @Published var likedSuppliers: [MWSupplier] = [MWSupplier]()
    @Published var likedVenues: [MWVenue] = [MWVenue]()
    
    func getLikedSuppliers(customerId: String, completion: @escaping (Result<[MWSupplier], Error>) -> ()) {
        DatabaseService.shared.getLikedSuppliers(customerId: customerId) { result in
            switch result {
            case .success(let suppliers):
                self.likedSuppliers = suppliers
                completion(.success(suppliers))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func getLikedVenues(customerId: String, completion: @escaping (Result<[MWVenue], Error>) -> ()) {
        DatabaseService.shared.getLikedVenues(customerId: customerId) { result in
            switch result {
            case .success(let venues):
                self.likedVenues = venues
                completion(.success(venues))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
