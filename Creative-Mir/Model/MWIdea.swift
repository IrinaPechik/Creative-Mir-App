//
//  MWIdea.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI
import FirebaseFirestore

enum EventTypes: String, Codable, CaseIterable {
    case birthday = "Birthday"
    case wedding = "Wedding"
    case animalsBirthday = "Animals Birthday"
    case newYear = "New year"
    
    var image: Image {
            switch self {
            case .birthday:
                return Image(systemName: "gift")
            case .wedding:
                return Image(systemName: "heart")
            case .animalsBirthday:
                return Image(systemName: "tortoise")
            case .newYear:
                return Image(systemName: "sparkles")
            }
        }
}

struct MWIdea: Codable, Identifiable {
    var id: String
    var name: String
    var image: Data
    var description: String
    var eventType: String
    var ageRestriction: Int
    var venuesRecommendations: String
    var suppliersRecommendations: String
    var peopleLimit: Int
    var colorScheme: String
    
    init(id: String,
         name: String,
         image: Data,
         description: String,
         eventType: String,
         ageRestriction: Int,
         venuesRecommendations: String,
         suppliersRecommendations: String,
         peopleLimit: Int,
         colorScheme: String) {
            
            self.id = id
            self.name = name
            self.image = image
            self.description = description
            self.eventType = eventType
            self.ageRestriction = ageRestriction
            self.venuesRecommendations = venuesRecommendations
            self.suppliersRecommendations = suppliersRecommendations
            self.peopleLimit = peopleLimit
            self.colorScheme = colorScheme
        }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String else {return nil}
        guard let name = data["name"] as? String else {return nil}
        guard let image = data["image"] as? Data else {return nil}
        guard let description = data["description"] as? String else {return nil}
        guard let eventType = data["eventType"] as? String else {return nil}
        guard let ageRestriction = data["ageRestriction"] as? Int else {return nil}
        guard let venuesRecommendations = data["venuesRecommendations"] as? String else {return nil}
        guard let suppliersRecommendations = data["suppliersRecommendations"] as? String else {return nil}
        guard let peopleLimit = data["peopleLimit"] as? Int else {return nil}
        guard let colorScheme = data["colorScheme"] as? String else {return nil}

        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.eventType = eventType
        self.ageRestriction = ageRestriction
        self.venuesRecommendations = venuesRecommendations
        self.suppliersRecommendations = suppliersRecommendations
        self.peopleLimit = peopleLimit
        self.colorScheme = colorScheme
    }
}
