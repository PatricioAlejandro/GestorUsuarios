//  Models.swift
//  UsersApp

import Foundation
import RealmSwift
import CoreLocation

class User: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var username: String
    @Persisted var email: String
    @Persisted var phone: String
    @Persisted var city: String
    @Persisted var website: String
    @Persisted var companyName: String
    @Persisted var companyCatchPhrase: String
    @Persisted var companyBs: String
    @Persisted var isDeleted: Bool
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
}

struct APIUser: Decodable {
    struct Address: Decodable {
        struct Geo: Decodable {
            let lat: String
            let lng: String
        }
        let street: String
        let suite: String
        let city: String
        let zipCode: String
        let geo: Geo
    }
    
    struct Company: Decodable {
        let name: String
        let catchPhrase: String
        let bs: String
    }
    
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: Address
    let company: Company
}

extension User {
    static func from(api: APIUser) -> User {
        let user = User()
        user.id = api.id
        user.name = api.name
        user.username = api.username
        user.email = api.email
        user.phone = api.phone
        user.website = api.website
        user.city = api.address.city
        user.isDeleted = false
        if let lat = Double(api.address.geo.lat), let lng = Double(api.address.geo.lng) {
            user.latitude = lat
            user.longitude = lng
        }
        user.companyName = api.company.name
        user.companyCatchPhrase = api.company.catchPhrase
        user.companyBs = api.company.bs
        return user
    }
}
