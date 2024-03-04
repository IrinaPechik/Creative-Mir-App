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

enum ComapanyOrIndividalPerformer: String, Codable {
    case individual = "Individual person"
    case company = "Company"
}

