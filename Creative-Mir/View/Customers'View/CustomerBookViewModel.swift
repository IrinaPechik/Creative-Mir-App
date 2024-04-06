//
//  CustomerBookViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import Foundation

class CustomerBookViewModel: ObservableObject {
    var bookings: [MWBooking] = [MWBooking]()
    
    @Published var suppliersBookings: [MWBooking] = [MWBooking]()
    @Published var venuesBookings: [MWBooking] = [MWBooking]()
    
    func getCustomerBookings(customerId: String) {
        DatabaseService.shared.getBookingsByCustomerid(by: customerId) { [self] res in
            switch res {
            case .success(let result):
                self.bookings = result
                for booking in self.bookings {
                    DatabaseService.shared.getUser(id: booking.performerId) { userRes in
                        switch userRes {
                        case .success(let user):
                            DatabaseService.shared.getUserRole(email: user.email) { userRoleRes in
                                switch userRoleRes {
                                case .success(let userRole):
                                    if userRole == "supplier" {
                                        self.suppliersBookings.append(booking)
                                    } else if userRole == "venue" {
                                        self.venuesBookings.append(booking)
                                    }
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
