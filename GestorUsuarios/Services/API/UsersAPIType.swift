//
//  UsersAPIType.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation

protocol UsersAPIType {
    func fetchUsers() async throws -> [APIUser]
}
