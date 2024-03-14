//
//  MWSupplier.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 04.03.2024.
//

import Foundation

struct MWSupplier: Identifiable, Codable {
    var id: String
    var storyAboutYourself: String
    var advertisements: [SupplierAdvertisemnt] = []
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["storyAboutYourself"] = self.storyAboutYourself
        repres["advertisements"] = self.advertisements
        // Преобразование каждого advertisement в его словарное представление
        let adsRepresentation = advertisements.map { $0.representation }
        repres["advertisements"] = adsRepresentation

        return repres
    }
    
    mutating func addAdvertisement(advertisement: SupplierAdvertisemnt) {
        advertisements.append(advertisement)
    }
}

struct SupplierAdvertisemnt: Codable {
    var legalStatus: String
    var stageName: String?
    var companyName: String?
    var companyPosition: String?
    var skill: String
    var experience: Int
    var experienceMeasure: String
    var storyAboutWork: String
//    var photosFromWork: [Data?]
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["legalStatus"] = legalStatus
        repres["stageName"] = stageName
        repres["companyName"] = companyName
        repres["companyPosition"] = companyPosition
        repres["skill"] = skill
        repres["experience"] = experience
        repres["experienceMeasure"] = experienceMeasure
        repres["storyAboutWork"] = storyAboutWork
//        repres["photosFromWork"] = photosFromWork
        return repres
    }
}
