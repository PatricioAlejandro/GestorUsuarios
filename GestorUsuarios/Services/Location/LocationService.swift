//  LocationService.swift
//  UsersApp

import Foundation
import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager = CLLocationManager()
    @Published var lastCoordinate: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastCoordinate = locations.last?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
    }
}