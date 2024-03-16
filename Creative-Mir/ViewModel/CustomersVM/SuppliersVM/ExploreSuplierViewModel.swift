//
//  ExploreSuplierViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 15.03.2024.
//

import Foundation
import SwiftUI

class ExploreSuplierViewModel: ObservableObject {
    @Published var suppliers: [MWSupplier] = [MWSupplier]()
    @Published var likedSuppliers: [MWSupplier] = [MWSupplier]()
    
    func getSuppliers(completion: @escaping (Result<[MWSupplier], Error>) -> ()) {
        DatabaseService.shared.getSuppliers { result in
            switch result {
            case .success(let suppliers):
                self.suppliers = suppliers
                completion(.success(suppliers))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func addLikeToSupplier(customerId: String, supplier: MWSupplier) {
        DatabaseService.shared.setLikedSupplierToCustomer(customerId: customerId, supplier: supplier) { error in
            if error != nil {
                print("erroe while saving liked supplier")
            } else {
                print("liked supplier was saved")
            }
        }
    }
    
    func removeLikeFromSupplier(customerId: String, supplier: MWSupplier) {
        DatabaseService.shared.deleteLikedSupplierToCustomer(customerId: customerId, supplier: supplier) { error in
            if error != nil {
                print("erroe while deleting liked supplier")
            } else {
                print("liked supplier was deleted")
            }
        }
    }
}
