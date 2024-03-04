//
//  Supplier.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 04.03.2024.
//

import Foundation

struct MWUser: Identifiable {
    var id: String
    var name: String
    var surname: String
    var birthday: String
    var residentialAddress: String
    var avatarImage: Data?
    var role: String
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        repres["surname"] = self.surname
        repres["birthday"] = self.birthday
        repres["residentialAddress"] = self.residentialAddress
        repres["avatarImage"] = self.avatarImage
        repres["role"] = self.role
        return repres
    }
}

