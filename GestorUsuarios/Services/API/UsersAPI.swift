//
//  UsersAPI.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation

struct UsersAPI: UsersAPIType {
    private let client = APIClient()
    func fetchUsers() async throws -> [APIUser] {
        try await client.get("/users")
    }
}
