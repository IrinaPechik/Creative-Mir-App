//
//  MWIdea.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI
import FirebaseFirestore

struct MWIdea: Codable, Identifiable {
    var id: String
    var categoryId: String
    var name: String
//    var image: String
    var description: String
    var shortDescription: String
//    var eventType: String
    var ageRestriction: Int
    var venuesRecommendations: String
    var suppliersRecommendations: String
    var peopleLimit: Int
    var colorScheme: String
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["categoryId"] = self.categoryId
        repres["name"] = self.name
//        repres["image"] = self.image
        repres["description"] = self.description
        repres["shortDescription"] = self.shortDescription
//        repres["eventType"] = self.eventType
        repres["ageRestriction"] = self.ageRestriction
        repres["venuesRecommendations"] = self.venuesRecommendations
        repres["suppliersRecommendations"] = self.suppliersRecommendations
        repres["peopleLimit"] = self.peopleLimit
        repres["colorScheme"] = self.colorScheme
        return repres
    }
    init(id: String,
         categoryId: String,
         name: String,
//         image: String,
         description: String,
         shortDescription: String,
//         eventType: String,
         ageRestriction: Int,
         venuesRecommendations: String,
         suppliersRecommendations: String,
         peopleLimit: Int,
         colorScheme: String) {
            
            self.id = id
            self.categoryId = categoryId
            self.name = name
//            self.image = image
            self.description = description
            self.shortDescription = shortDescription
//            self.eventType = eventType
            self.ageRestriction = ageRestriction
            self.venuesRecommendations = venuesRecommendations
            self.suppliersRecommendations = suppliersRecommendations
            self.peopleLimit = peopleLimit
            self.colorScheme = colorScheme
        }
    
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String else {return nil}
        guard let categoryId = data["categoryId"] as? String else {return nil}
        guard let name = data["name"] as? String else {return nil}
//        guard let image = data["image"] as? String else {return nil}
        guard let description = data["description"] as? String else {return nil}
        guard let shortDescription = data["shortDescription"] as? String else {return nil}
//        guard let eventType = data["eventType"] as? String else {return nil}
        guard let ageRestriction = data["ageRestriction"] as? Int else {return nil}
        guard let venuesRecommendations = data["venuesRecommendations"] as? String else {return nil}
        guard let suppliersRecommendations = data["suppliersRecommendations"] as? String else {return nil}
        guard let peopleLimit = data["peopleLimit"] as? Int else {return nil}
        guard let colorScheme = data["colorScheme"] as? String else {return nil}

        self.id = id
        self.categoryId = categoryId
        self.name = name
//        self.image = image
        self.description = description
        self.shortDescription = shortDescription
//        self.eventType = eventType
        self.ageRestriction = ageRestriction
        self.venuesRecommendations = venuesRecommendations
        self.suppliersRecommendations = suppliersRecommendations
        self.peopleLimit = peopleLimit
        self.colorScheme = colorScheme
    }
}
