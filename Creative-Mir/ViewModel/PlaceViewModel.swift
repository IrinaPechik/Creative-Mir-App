//
//  PlaceViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 22.02.2024.
//

import Foundation
import MapKit

@MainActor
class PlaceViewModel: ObservableObject {
    @Published var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        // Фильтруем только города и страны.
        searchRequest.resultTypes = [.address]
        
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
