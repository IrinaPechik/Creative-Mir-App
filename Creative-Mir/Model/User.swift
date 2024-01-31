//
//  Customer.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 23.01.2024.
//

import Foundation

enum UserRoles: String, Codable {
    case customer = "I want to organise my event"
    case supplier = "I am a supplier"
    case venue = "I am a venue"
}

struct User {
//    var id: String
    var userRole: UserRoles
    var name: String
    var surname: String
    var birthDate: Date
    var country: String
    var city: String
}
