//
//  UsersRepository.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation
import Combine
import CoreLocation

public struct UserUI: Identifiable {
    public let id: Int
    public var username: String
    public var name: String
    public var email: String
    public var phone: String
    public var city: String
    public var coordinate: CLLocationCoordinate2D?
}

public struct NewUser {
    public var name: String
    public var email: String
    public var phone: String
    public var coordinate: CLLocationCoordinate2D?
}

public struct UpdateUser {
    public let id: Int
    public var name: String
    public var email: String
}

public protocol UsersRepository {
    func refreshUsers() async throws
    func usersPublisher() -> AnyPublisher<[UserUI], Never>
    func userPublisher(id: Int) -> AnyPublisher<UserUI?, Never>
    func create(user: NewUser) throws
    func update(user: UpdateUser) throws
    func logicalDelete(id: Int) throws
}

public protocol LocationProvider {
    var lastCoordinatePublisher: AnyPublisher<CLLocationCoordinate2D?, Never> { get }
    func requestAuthorization()
    func requestOneShot()
}
