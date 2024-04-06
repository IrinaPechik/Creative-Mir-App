//
//  BookingRequestsViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.04.2024.
//

import Foundation

class BookingRequestsViewModel: ObservableObject {
    @Published var allRequestsForBooking: [MWBooking] = []
    @Published var approvedBookingRequests: [MWBooking] = []
    
    func getSendedRequestsForPerformer(performerId: String) {
        DatabaseService.shared.getSentBookingsByPerformerId(by: performerId) { result in
            switch result {
            case .success(let requests):
                self.allRequestsForBooking = requests
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getApprovedRequestsForPerformer(performerId: String) {
        DatabaseService.shared.getApprovedBookingsByPerformerId(by: performerId) { result in
            switch result {
            case .success(let requests):
                self.approvedBookingRequests = requests
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
