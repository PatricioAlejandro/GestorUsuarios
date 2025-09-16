//  MockUsersAPI.swift
//  UsersAppTests

import Foundation
@testable import UsersApp

final class MockUsersAPI: UsersAPIType {
    var result: Result<[APIUser], Error> = .success([])
    func fetchUsers() async throws -> [APIUser] {
        switch result {
        case .success(let users): return users
        case .failure(let e): throw e
        }
    }

    static func sampleUsers(count: Int = 3) -> [APIUser] {
        (1...count).map { i in
            APIUser(id: i,
                    name: "Name \(i)",
                    username: "user\(i)",
                    email: "user\(i)@mail.com",
                    phone: "555-000\(i)",
                    address: .init(city: "City \(i)", geo: .init(lat: "-0.1\(i)", lng: "-78.4\(i)")))
        }
    }
}