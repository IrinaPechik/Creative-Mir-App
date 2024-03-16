//
//  ExploreVenuesViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 16.03.2024.
//

import Foundation

class ExploreVenuesViewModel: ObservableObject {
    @Published var venues: [MWVenue] = [MWVenue]()
    @Published var likedVenues: [MWVenue] = [MWVenue]()
    
    func getVenues(completion: @escaping (Result<[MWVenue], Error>) -> ()) {
        DatabaseService.shared.getVenues { result in
            switch result {
            case .success(let venues):
                self.venues = venues
                completion(.success(venues))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func addLikeToVenue(customerId: String, venue: MWVenue) {
        DatabaseService.shared.setLikedVenueToCustomer(customerId: customerId, venue: venue) { error in
            if error != nil {
                print("erroe while saving liked venue")
            } else {
                print("liked venue was saved")
            }
        }
    }
    
    func removeLikeFromVenue(customerId: String, venue: MWVenue) {
        DatabaseService.shared.deleteLikedVenueToCustomer(customerId: customerId, venue: venue) { error in
            if error != nil {
                print("erroe while deleting liked venu")
            } else {
                print("liked supplier was deleted")
            }
        }
    }
}

