//
//  Supplier.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 04.03.2024.
//

import Foundation
import FirebaseFirestore

struct MWUser: Identifiable {
    var id: String
    var email: String
    var name: String
    var surname: String
    var birthday: String
    var residentialAddress: String
    var role: String
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["email"] = self.email
        repres["name"] = self.name
        repres["surname"] = self.surname
        repres["birthday"] = self.birthday
        repres["residentialAddress"] = self.residentialAddress
        repres["role"] = self.role
        return repres
    }
    
    init(id: String, email: String, name: String, surname: String, birthday: String, residentialAddress: String, role: String) {
       self.id = id
       self.email = email
       self.name = name
       self.surname = surname
       self.birthday = birthday
       self.residentialAddress = residentialAddress
       self.role = role
   }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String else {return nil}
        guard let email = data["email"] as? String else {return nil}
        guard let name = data["name"] as? String else {return nil}
        guard let surname = data["surname"] as? String else {return nil}
        guard let birthday = data["birthday"] as? String else {return nil}
        guard let residentialAddress = data["residentialAddress"] as? String else {return nil}
        guard let role = data["role"] as? String else {return nil}

        self.id = id
        self.email = email
        self.name = name
        self.surname = surname
        self.birthday = birthday
        self.residentialAddress = residentialAddress
        self.role = role
    }
}

