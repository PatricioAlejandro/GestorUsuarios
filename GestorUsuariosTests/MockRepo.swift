//  MockRepo.swift
//  UsersAppTests

import Foundation
import Combine
import CoreLocation
@testable import UsersApp

final class MockRepo: UsersRepository {
    var users = CurrentValueSubject<[UserUI], Never>([])

    func refreshUsers() async throws {}
    func usersPublisher() -> AnyPublisher<[UserUI], Never> { users.eraseToAnyPublisher() }
    func userPublisher(id: Int) -> AnyPublisher<UserUI?, Never> {
        users.map { list in list.first(where: {$0.id == id}) }.eraseToAnyPublisher()
    }
    func create(user: NewUser) throws {
        let nextId = (users.value.map {$0.id}.max() ?? 0) + 1
        let ui = UserUI(id: nextId, username: user.name.lowercased(), name: user.name, email: user.email, phone: user.phone, city: "", coordinate: user.coordinate)
        users.send(users.value + [ui])
    }
    func update(user: UpdateUser) throws {
        let updated = users.value.map { u in
            guard u.id == user.id else { return u }
            return UserUI(id: u.id, username: u.username, name: user.name, email: user.email, phone: u.phone, city: u.city, coordinate: u.coordinate)
        }
        users.send(updated)
    }
    func logicalDelete(id: Int) throws {
        users.send(users.value.filter { $0.id != id })
    }
}

final class MockLocation: LocationProvider {
    var subject = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
    var lastCoordinatePublisher: AnyPublisher<CLLocationCoordinate2D?, Never> { subject.eraseToAnyPublisher() }
    func requestAuthorization() {}
    func requestOneShot() { subject.send(.init(latitude: 1.0, longitude: 2.0)) }
}