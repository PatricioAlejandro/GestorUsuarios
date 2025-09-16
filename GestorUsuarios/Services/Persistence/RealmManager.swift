//
//  RealmManager.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation
import RealmSwift
import CoreLocation

@MainActor
final class RealmManager {
    static let shared = RealmManager()
    private let realm = try! Realm()

    func saveUsers(_ apiUsers: [APIUser]) throws {
        let objects = apiUsers.map(User.from)
        try realm.write { realm.add(objects, update: .modified) }
    }

    func fetchUsersFiltered() -> [User] {
        Array(realm.objects(User.self).where { $0.isDeleted == false })
    }

    func user(withId id: Int) -> User? {
        realm.object(ofType: User.self, forPrimaryKey: id)
    }

    func update(userId: Int, name: String, email: String) throws {
        guard let user = user(withId: userId) else { return }
        try realm.write {
            user.name = name
            user.email = email
        }
    }

    func createUser(name: String, email: String, phone: String, coordinate: CLLocationCoordinate2D?) throws {
        let nextId = (realm.objects(User.self).max(ofProperty: "id") as Int? ?? 0) + 1
        let u = User()
        u.id = nextId
        u.name = name
        u.username = name.replacingOccurrences(of: " ", with: "").lowercased()
        u.email = email
        u.phone = phone
        u.city = ""
        if let c = coordinate {
            u.latitude = c.latitude; u.longitude = c.longitude
        }
        try realm.write { realm.add(u, update: .modified) }
    }

    func logicalDelete(userId: Int) throws {
        guard let user = user(withId: userId) else { return }
        try realm.write { user.isDeleted = true }
    }
}
