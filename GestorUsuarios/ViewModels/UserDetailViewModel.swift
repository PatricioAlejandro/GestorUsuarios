//  UserDetailViewModel.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation
import Combine

@MainActor
final class UserDetailViewModel: ObservableObject {
    enum State: Equatable { case viewing, saving, saved, error(String) }

    @Published private(set) var state: State = .viewing
    @Published private(set) var user: UserUI?
    @Published var name: String = ""
    @Published var email: String = ""

    private let repo: UsersRepository
    private let userId: Int
    private var bag = Set<AnyCancellable>()
    private var didBootstrapFields = false   // <- NUEVO

    init(userId: Int, repo: UsersRepository) {
        self.userId = userId
        self.repo = repo

        repo.userPublisher(id: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.user = $0
                if let u = $0, self.didBootstrapFields == false {
                    self.name = u.name
                    self.email = u.email
                    self.didBootstrapFields = true
                }
            }
            .store(in: &bag)
    }

    func save() {
        guard let current = user else { return }
        state = .saving
        do {
            try Validators.required(name, field: "name")
            try Validators.email(email)
            try repo.update(user: .init(id: current.id, name: name, email: email))
            state = .saved
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func deleteUser() {
        do { try repo.logicalDelete(id: userId) }
        catch { state = .error(error.localizedDescription) }
    }
}
