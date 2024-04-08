//
//  CustomerProfileViewController.swift
//  Creative-Mir
//
//  Created by Irina Pechik on 07.04.2024.
//

import Foundation
import UIKit
import SwiftUI
import MapKit

class CustomerProfileViewModel: CustomerProfileViewModelling {
    
    @Published var surname: String = ""
    
    @Published var email: String = ""
    
    @Published var birthdaydate: Date = .now
    
    @Published var currentUserAddress: String = ""
    
    @Published var returnedPlace = Place(mapItem: MKMapItem())
    
    @Published var name: String = ""
    
    @Published var avatarImage: UIImage = UIImage(systemName: "heart.fill")!
    
    let dateFormatter = DateFormatter()
    
    init() {
        DatabaseService.shared.getUser(id: AuthService.shared.currentUser!.uid) { result in
            switch result {
            case .success(let currentUser):
                self.name = currentUser.name
                self.surname = currentUser.surname
                self.email = currentUser.email
//                self.avatarImage = currentUser.
                
                self.dateFormatter.dateFormat = "dd.MM.yyyy"
                if let date = self.dateFormatter.date(from: currentUser.birthday) {
                    self.birthdaydate = date
                    print(date)
                } else {
                    print("Невозможно преобразовать строку в дату")
                }
                
                self.currentUserAddress = currentUser.residentialAddress
//                self.avatarImage = nil

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
    

    func changeCustomerInfo(completion: @escaping (Result<MWUser, Error>) -> ()){
        if !returnedPlace.address.isEmpty {
            currentUserAddress = returnedPlace.address
        }

        var user: MWUser = MWUser(id: AuthService.shared.currentUser!.uid, email: email, name: name, surname: surname, birthday: self.dateFormatter.string(from: birthdaydate), residentialAddress: currentUserAddress, role: "customer")
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
        
//        AuthService.shared.updateEmail(newEmail: user.email) { error in
//            if let error = error {
//                print("Ошибка при обновлении email: \(error.localizedDescription)")
//            } else {
//                print("Email успешно обновлен")
//                DatabaseService.shared.setUser(user: user, imageData: self.avatarImage.jpegData(compressionQuality: 0.5)!) { result in
//                    switch result {
//                    case .success(let user):
//                        print(user.name)
//                    case .failure(let failure):
//                        print(failure.localizedDescription)
//                    }
//                }
//            }
//        }
    }

}
