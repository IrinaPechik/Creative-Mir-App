//
//  Customer.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 23.01.2024.
//

import Foundation

struct Customer: Codable {
    var id: String
    var name: String
    var surname: String
    var birthDate: Date
    var country: String
    var city: String
}
