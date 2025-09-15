//  AppCoordinator.swift
//  UsersApp


import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var rootView: AnyView

    init() {
        let usersCoordinator = UsersCoordinator()
        rootView = AnyView(usersCoordinator.start())
    }
}
