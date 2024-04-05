//
//  MWBooking.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.04.2024.
//

import Foundation
import FirebaseFirestore

struct MWBooking: Identifiable {
    var id: String
    var customerId: String
    var performerId: String
    var bookingStatus: String
    var customerMessage: String
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["customerId"] = self.customerId
        repres["performerId"] = self.performerId
        repres["bookingStatus"] = self.bookingStatus
        repres["customerMessage"] = self.customerMessage
        return repres
    }
    
    init(id: String, customerId: String, performerId: String, bookingStatus: String, customerMessage: String) {
        self.id = id
        self.customerId = customerId
        self.performerId = performerId
        self.bookingStatus = bookingStatus
        self.customerMessage = customerMessage
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String else {return nil}
        guard let customerId = data["customerId"] as? String else {return nil}
        guard let performerId = data["performerId"] as? String else {return nil}
        guard let bookingStatus = data["bookingStatus"] as? String else {return nil}
        guard let customerMessage = data["customerMessage"] as? String else {return nil}

        self.id = id
        self.customerId = customerId
        self.performerId = performerId
        self.bookingStatus = bookingStatus
        self.customerMessage = customerMessage
    }
}
