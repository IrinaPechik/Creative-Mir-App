//
//  MWSupplier.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 04.03.2024.
//

import Foundation

struct MWSupplier: Identifiable {
    var id: String
    var storyAboutYourself: String
    var legalStatus: String
    var stageName: String?
    var companyName: String?
    var companyPosition: String?
    var skill: String
    var experience: Int
    var experienceMeasure: String
    var storyAboutWork: String
    var photosFromWork: [Data?]
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["storyAboutYourself"] = self.storyAboutYourself
        repres["legalStatus"] = self.legalStatus
        repres["stageName"] = self.stageName
        repres["companyName"] = self.companyName
        repres["companyPosition"] = self.companyPosition
        repres["skill"] = self.skill
        repres["experience"] = self.experience
        repres["experienceMeasure"] = self.experienceMeasure
        repres["storyAboutWork"] = self.storyAboutWork
        repres["photosFromWork"] = self.photosFromWork
        return repres
    }
}
