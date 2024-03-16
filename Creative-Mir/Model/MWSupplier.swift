//
//  MWSupplier.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 04.03.2024.
//

import Foundation
import FirebaseFirestore

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
    
    init(id: String, storyAboutYourself: String = "", advertisements: [SupplierAdvertisemnt] = []) {
        self.id = id
        self.storyAboutYourself = storyAboutYourself
        self.advertisements = advertisements
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String else {return nil}
        guard let storyAboutYourself = data["storyAboutYourself"] as? String else {return nil}
        guard let advertisementsData = data["advertisements"] as? [[String: Any]] else { return nil }
        // Преобразуем массив словарей в массив SupplierAdvertisemnt, используя compactMap
        let advertisements: [SupplierAdvertisemnt] = advertisementsData.compactMap { dict -> SupplierAdvertisemnt? in
            return SupplierAdvertisemnt(from: dict)
        }
//        let advertisements = SupplierAdvertisemnt(from: advertisementsData)
//        guard let advertisements = SupplierAdvertisemnt(from: data["advertisements"] as? [String: Any] ?? "nil") else {return nil}
//                data["advertisements"] as? [SupplierAdvertisemnt] else {return nil}

        self.id = id
        self.storyAboutYourself = storyAboutYourself
        self.advertisements = advertisements
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
        return repres
    }
    
    init(legalStatus: String, stageName: String? = nil, companyName: String? = nil, companyPosition: String? = nil, skill: String, experience: Int, experienceMeasure: String, storyAboutWork: String) {
        self.legalStatus = legalStatus
        self.stageName = stageName
        self.companyName = companyName
        self.companyPosition = companyPosition
        self.skill = skill
        self.experience = experience
        self.experienceMeasure = experienceMeasure
        self.storyAboutWork = storyAboutWork
    }
    
    init(from dictionary: [String: Any]) {
            self.legalStatus = dictionary["legalStatus"] as? String ?? ""
            self.stageName = dictionary["stageName"] as? String
            self.companyName = dictionary["companyName"] as? String
            self.companyPosition = dictionary["companyPosition"] as? String
            self.skill = dictionary["skill"] as? String ?? ""
            self.experience = dictionary["experience"] as? Int ?? 0
            self.experienceMeasure = dictionary["experienceMeasure"] as? String ?? ""
            self.storyAboutWork = dictionary["storyAboutWork"] as? String ?? ""
        }
}
