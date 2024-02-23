//
//  Place.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 22.02.2024.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var address: String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        
        cityAndState = placemark.locality ?? "" // city
        if let country = placemark.country {
            cityAndState = cityAndState.isEmpty ? country : "\(cityAndState), \(country)"
        }
        return cityAndState
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
}
