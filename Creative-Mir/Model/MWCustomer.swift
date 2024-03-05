//
//  MWCustomer.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 05.03.2024.
//

import Foundation

struct MWCustomer: Identifiable, Codable {
    var id: String

    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        return repres
    }
}

