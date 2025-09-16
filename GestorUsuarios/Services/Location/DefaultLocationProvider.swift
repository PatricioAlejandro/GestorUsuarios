//  DefaultLocationProvider.swift
//  UsersApp

import Foundation
import Combine
import CoreLocation

final class DefaultLocationProvider: LocationProvider {
    private let service: LocationService
    private let subject = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)

    init(service: LocationService = .init()) {
        self.service = service
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.subject.send(service.lastCoordinate)
        }
    }

    var lastCoordinatePublisher: AnyPublisher<CLLocationCoordinate2D?, Never> {
        subject.eraseToAnyPublisher()
    }
    func requestAuthorization() { service.requestAuthorization() }
    func requestOneShot() { service.requestLocation() }
}