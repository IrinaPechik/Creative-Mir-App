//
//  MWVenue.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 05.03.2024.
//

import Foundation

struct MWVenue: Identifiable, Codable {
    var id: String
    var advertisements: [VenueAdvertisemnt] = []
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["advertisements"] = self.advertisements
        // Преобразование каждого advertisement в его словарное представление
        let adsRepresentation = advertisements.map { $0.representation }
        repres["advertisements"] = adsRepresentation

        return repres
    }
    
    mutating func addAdvertisement(advertisement: VenueAdvertisemnt) {
        advertisements.append(advertisement)
    }
}

struct VenueAdvertisemnt: Codable {
    var legalStatus: String
    var companyName: String?
    var companyPosition: String?
    var locationAddress: String
    var locationName: String
    var locationDescription: String
    
    var photosFromWork: [Data?]
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["legalStatus"] = legalStatus
        repres["companyName"] = companyName
        repres["companyPosition"] = companyPosition
        repres["locationAddress"] = locationAddress
        repres["locationName"] = locationName
        repres["locationDescription"] = locationDescription
        repres["photosFromWork"] = photosFromWork
        return repres
    }
}
