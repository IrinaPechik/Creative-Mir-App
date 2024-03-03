//
//  FullAddressViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 03.03.2024.
//

import Foundation
import MapKit

@MainActor
class FullAddressViewModel: ObservableObject {
    @Published var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        // Фильтруем только города и страны.
//        searchRequest.resultTypes = [.pointOfInterest]
        
        let search = MKLocalSearch(request: searchRequest)
        search.start {response, error in
            guard let response = response else {
                print("Error \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            self.places = response.mapItems.map(Place.init)
        }
    }
}
