//
//  VenueProfileViewModel.swift
//  Creative-Mir
//
//  Created by Irina Pechik on 08.04.2024.
//

import Foundation
import UIKit
import MapKit


class VenueProfileViewModel: VenueProfileViewModelling {
   @Published var name: String = ""
   @Published var surname: String = ""
   @Published var email: String = ""
   @Published var birthdaydate: Date = .now
   @Published var currentUserAddress: String  = ""
    
   @Published var avatarImage: UIImage = UIImage(systemName: "heart.fill")!
   @Published var returnedPlace: Place = Place(mapItem: MKMapItem())
    @Published var returnedBuildingPlace: Place = Place(mapItem: MKMapItem())

   @Published var currentBuildingAddress: String  = ""
   @Published var companyName: String?
   @Published var companyPosition: String?
   @Published var locationName: String = ""
   @Published var locationDescription: String = ""

    let dateFormatter = DateFormatter()
    
    init() {
        DatabaseService.shared.getUser(id: AuthService.shared.currentUser!.uid) { result in
            switch result {
            case .success(let currentUser):
                self.name = currentUser.name
                self.surname = currentUser.surname
                self.email = currentUser.email
                
                self.dateFormatter.dateFormat = "dd.MM.yyyy"
                if let date = self.dateFormatter.date(from: currentUser.birthday) {
                    self.birthdaydate = date
                    print(date)
                } else {
                    print("Невозможно преобразовать строку в дату")
                }
                
                self.currentUserAddress = currentUser.residentialAddress
                
                DatabaseService.shared.getVenue(id: AuthService.shared.currentUser!.uid) { result in
                    switch result {
                    case .success(let currentVenue):
                        self.companyName = currentVenue.advertisements[0].companyName
                        self.companyPosition = currentVenue.advertisements[0].companyPosition
                        self.currentBuildingAddress = currentVenue.advertisements[0].locationAddress
                        self.locationName = currentVenue.advertisements[0].locationName
                        self.locationDescription = currentVenue.advertisements[0].locationDescription
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }

            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
        StorageService.shared.downloadUserAvatarImage(id: AuthService.shared.currentUser?.uid ?? "id") {result in
            switch result {
            case .success(let data):
                if let img = UIImage(data: data) {
                    self.avatarImage = img
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func changeUserInfo(completion: @escaping (Result<MWUser, any Error>) -> ()) {
        if !returnedPlace.address.isEmpty {
            currentUserAddress = returnedPlace.address
        }

        var user: MWUser = MWUser(id: AuthService.shared.currentUser!.uid, email: email, name: name, surname: surname, birthday: self.dateFormatter.string(from: birthdaydate), residentialAddress: currentUserAddress, role: "venue")
        
        DatabaseService.shared.setUser(user: user, imageData: self.avatarImage.jpegData(compressionQuality: 0.5)!) { result in
            switch result {
            case .success(let user):
                print(user.name)
                completion(.success(user))
            case .failure(let failure):
                print(failure.localizedDescription)
                completion(.failure(failure))
            }
        }
    }
    
    func changeVenueInfo(legalStatus: String,  completion: @escaping (Result<MWVenue, any Error>) -> ()) {
        if !returnedBuildingPlace.fullAddress.isEmpty {
            currentBuildingAddress = returnedBuildingPlace.fullAddress
        }
        let venueAdvertisement = VenueAdvertisemnt(legalStatus: legalStatus, companyName: companyName, companyPosition: companyPosition, locationAddress: currentBuildingAddress, locationName: locationName, locationDescription: locationDescription)
        
        let venue = MWVenue(id: AuthService.shared.currentUser!.uid, advertisements: [venueAdvertisement])

        DatabaseService.shared.setVenueWithoutImages(venue: venue) { res in
            switch res {
            case .success(let venue):
                print(venue.advertisements[0].companyName)
                completion(.success(venue))
            case .failure(let failure):
                print(failure.localizedDescription)
                completion(.failure(failure))
            }
        }
    }
    
    
}
