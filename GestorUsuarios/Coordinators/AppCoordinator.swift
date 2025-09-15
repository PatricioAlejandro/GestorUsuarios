//
//  AppCoordinator.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//


import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var rootView: AnyView

    init() {
        let repo = DefaultUsersRepository()
        let usersCoordinator = UsersCoordinator(repo: repo)
        rootView = AnyView(usersCoordinator.start())
    }
}
