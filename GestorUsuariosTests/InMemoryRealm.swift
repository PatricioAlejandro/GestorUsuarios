//  InMemoryRealm.swift
//  UsersAppTests

import Foundation
import RealmSwift

enum InMemoryRealm {
    static func make(identifier: String = UUID().uuidString) -> Realm {
        var config = Realm.Configuration()
        config.inMemoryIdentifier = identifier
        return try! Realm(configuration: config)
    }
}