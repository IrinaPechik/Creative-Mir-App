//
//  BookingRequestsViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.04.2024.
//

import Foundation

class BookingRequestsViewModel: ObservableObject {
    @Published var allRequestsForBooking: [MWBooking] = []
    
    func getAllRequests(id: String) {
        DatabaseService.shared.getBookingsByPerformerId(by: id) { result in
            switch result {
            case .success(let requests):
                self.allRequestsForBooking = requests
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
