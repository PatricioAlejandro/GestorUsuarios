//
//  DefaultUsersRepository.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation
import Combine
import RealmSwift
import CoreLocation


@MainActor
final class DefaultUsersRepository: UsersRepository {
    private let api: UsersAPIType
    private let realm: Realm
    private var usersToken: NotificationToken?
    private let usersSubject = CurrentValueSubject<[UserUI], Never>([])

    init(api: UsersAPIType = UsersAPI(), realm: Realm = try! Realm()) {
        self.api = api
        self.realm = realm
        observeUsers()
    }

    deinit { usersToken?.invalidate() }

    private func observeUsers() {
        let results = realm.objects(User.self).where { $0.isDeleted == false }.sorted(byKeyPath: "id", ascending: true)
        usersToken = results.observe { [weak self] _ in
            guard let self else { return }
            let list: [UserUI] = results.map { u in
                let coord: CLLocationCoordinate2D? = {
                    if let lat = u.latitude, let lon = u.longitude {
                        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    }
                    return nil
                }()
                return UserUI(id: u.id, username: u.username, name: u.name, email: u.email, phone: u.phone, city: u.city, coordinate: coord)
            }
            self.usersSubject.send(Array(list))
        }

        let initial = results.map { u -> UserUI in
            let coord: CLLocationCoordinate2D? = {
                if let lat = u.latitude, let lon = u.longitude {
                    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
                }
                return nil
            }()
            return UserUI(id: u.id, username: u.username, name: u.name, email: u.email, phone: u.phone, city: u.city, coordinate: coord)
        }
        usersSubject.send(Array(initial))
    }

    // MARK: UsersRepository
    func refreshUsers() async throws {
        let apiUsers = try await api.fetchUsers()
        try RealmManager.shared.saveUsers(apiUsers)
    }
    func usersPublisher() -> AnyPublisher<[UserUI], Never> {
        usersSubject.eraseToAnyPublisher()
    }
    func userPublisher(id: Int) -> AnyPublisher<UserUI?, Never> {
        usersSubject.map { list in list.first { $0.id == id } }.eraseToAnyPublisher()
    }
    func create(user: NewUser) throws {
        try RealmManager.shared.createUser(name: user.name, email: user.email, phone: user.phone, coordinate: user.coordinate)
    }
    func update(user: UpdateUser) throws {
        try RealmManager.shared.update(userId: user.id, name: user.name, email: user.email)
    }
    func logicalDelete(id: Int) throws {
        try RealmManager.shared.logicalDelete(userId: id)
    }
}
