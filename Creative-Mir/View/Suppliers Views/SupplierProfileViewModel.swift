//
//  SupplierProfileViewModelling.swift
//  Creative-Mir
//
//  Created by Irina Pechik on 08.04.2024.
//

import Foundation
import UIKit
import MapKit

class SupplierProfileViewModel: SupplierProfileViewModelling {
   @Published var name: String = ""
   @Published var surname: String = ""
   @Published var email: String = ""
    @Published var birthdaydate: Date = .now
   @Published var currentUserAddress: String  = ""
    
   @Published var avatarImage: UIImage = UIImage(systemName: "heart.fill")!
   @Published var returnedPlace: Place = Place(mapItem: MKMapItem())
    
   @Published var skill: String  = ""
   @Published var stageName: String?
   @Published var companyName: String?
   @Published var companyPosition: String?
   @Published var experience: Int = 0
   @Published var experienceMeasure: String = ""
   @Published var storyAboutWork: String = ""
   @Published var storyAboutYourself: String = ""
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
                
                DatabaseService.shared.getSupplier(id: AuthService.shared.currentUser!.uid) { result in
                    switch result {
                    case .success(let currentSupplier):
                        self.stageName = currentSupplier.advertisements[0].stageName
                        self.companyName = currentSupplier.advertisements[0].companyName
                        self.companyPosition = currentSupplier.advertisements[0].companyPosition
                        self.experience = currentSupplier.advertisements[0].experience
                        self.experienceMeasure = currentSupplier.advertisements[0].experienceMeasure
                        self.storyAboutWork = currentSupplier.advertisements[0].storyAboutWork
                        self.storyAboutYourself = currentSupplier.storyAboutYourself
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

        var user: MWUser = MWUser(id: AuthService.shared.currentUser!.uid, email: email, name: name, surname: surname, birthday: self.dateFormatter.string(from: birthdaydate), residentialAddress: currentUserAddress, role: "supplier")
        
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
    
    func changeSupplierInfo(legalStatus: String, completion: @escaping (Result<MWSupplier, any Error>) -> ()) {
        var supplierAdverisement = SupplierAdvertisemnt(legalStatus: legalStatus, stageName: stageName, companyName: companyName, companyPosition: companyPosition, skill: skill, experience: experience, experienceMeasure: experienceMeasure, storyAboutWork: storyAboutWork)
        var supplier = MWSupplier(id: AuthService.shared.currentUser!.uid, storyAboutYourself: storyAboutYourself, advertisements: [supplierAdverisement])
        DatabaseService.shared.setSupplierWithoutImages(supplier: supplier) { res in
            switch res {
            case .success(let supplier):
                print(supplier.storyAboutYourself)
                completion(.success(supplier))
            case .failure(let failure):
                print(failure.localizedDescription)
                completion(.failure(failure))
            }
        }
    }
    
    
}
