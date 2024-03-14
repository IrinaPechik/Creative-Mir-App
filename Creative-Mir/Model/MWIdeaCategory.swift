//
//  MWIdeaCategory.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 08.03.2024.
//

import Foundation
import FirebaseFirestore

struct MWIdeaCategory: Codable, Identifiable {
    var id: String
    var categoryName: String
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["categoryName"] = self.categoryName
        return repres
    }
    
    init(id: String, categoryName: String) {
        self.id = id
        self.categoryName = categoryName
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String else {return nil}
        guard let categoryName = data["categoryName"] as? String else {return nil}

        self.id = id
        self.categoryName = categoryName
    }
}
