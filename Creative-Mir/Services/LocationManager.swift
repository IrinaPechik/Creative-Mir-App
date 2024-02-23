//
//  LocationManager.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 22.02.2024.
//

import Foundation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    
    private let locationManger = CLLocationManager()
    
    override init() {
        super.init()
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.distanceFilter = kCLDistanceFilterNone
        locationManger.requestAlwaysAuthorization()
        locationManger.startUpdatingLocation() // remember to udate info.plist
        locationManger.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
}
