//
//  UsersCoordinator.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import SwiftUI

@MainActor
final class UsersCoordinator {
    private let repo: UsersRepository

    init(repo: UsersRepository) {
        self.repo = repo
    }
    func start() -> some View {
        NavigationStack {
            UsersListView(viewModel: UsersListViewModel(repo: self.repo))
        }
    }
}
