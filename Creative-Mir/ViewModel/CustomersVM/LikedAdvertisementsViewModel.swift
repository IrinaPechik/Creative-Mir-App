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
    
    func getLikedSuppliers(customerId: String) {
        DatabaseService.shared.getLikedSuppliers(customerId: customerId) { result in
            switch result {
            case .success(let suppliers):
                self.likedSuppliers = suppliers
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getLikedVenues(customerId: String) {
        DatabaseService.shared.getLikedVenues(customerId: customerId) { result in
            switch result {
            case .success(let venues):
                self.likedVenues = venues
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
