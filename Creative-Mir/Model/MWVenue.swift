//
//  MWVenue.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 05.03.2024.
//

import Foundation
import FirebaseFirestore

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
    
    init(id: String, advertisements: [VenueAdvertisemnt] = []) {
        self.id = id
        self.advertisements = advertisements
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String else {return nil}
        guard let advertisementsData = data["advertisements"] as? [[String: Any]] else { return nil }
        // Преобразуем массив словарей в массив VenueAdvertisemnt, используя compactMap
        let advertisements: [VenueAdvertisemnt] = advertisementsData.compactMap { dict -> VenueAdvertisemnt? in
            return VenueAdvertisemnt(from: dict)
        }

        self.id = id
        self.advertisements = advertisements
    }
}

struct VenueAdvertisemnt: Codable {
    var legalStatus: String
    var companyName: String?
    var companyPosition: String?
    var locationAddress: String
    var locationName: String
    var locationDescription: String
        
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["legalStatus"] = legalStatus
        repres["companyName"] = companyName
        repres["companyPosition"] = companyPosition
        repres["locationAddress"] = locationAddress
        repres["locationName"] = locationName
        repres["locationDescription"] = locationDescription
        return repres
    }
    
    init(legalStatus: String, companyName: String? = nil, companyPosition: String? = nil, locationAddress: String, locationName: String, locationDescription: String) {
        self.legalStatus = legalStatus
        self.companyName = companyName
        self.companyPosition = companyPosition
        self.locationAddress = locationAddress
        self.locationName = locationName
        self.locationDescription = locationDescription
    }
    
    
    init(from dictionary: [String: Any]) {
        self.legalStatus = dictionary["legalStatus"] as? String ?? ""
        self.companyName = dictionary["companyName"] as? String
        self.companyPosition = dictionary["companyPosition"] as? String
        self.locationAddress = dictionary["locationAddress"] as? String ?? ""
        self.locationName = dictionary["locationName"] as? String ?? ""
        self.locationDescription = dictionary["locationDescription"] as? String ?? ""
    }
}
