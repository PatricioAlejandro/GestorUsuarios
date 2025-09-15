//
//  UsersListViewModel.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation
import Combine

@MainActor
final class UsersListViewModel: ObservableObject {
    enum State: Equatable { case idle, loading, loaded, error(String) }

    @Published private(set) var state: State = .idle
    @Published private(set) var users: [UserUI] = []
    @Published var searchText: String = ""

    private let repo: UsersRepository
    private var bag = Set<AnyCancellable>()

    init(repo: UsersRepository) {
        self.repo = repo

        let source = repo.usersPublisher()
            .receive(on: DispatchQueue.main)
            .share()

        Publishers.CombineLatest($searchText.removeDuplicates(), source)
            .map { query, all in
                guard !query.isEmpty else { return all }
                let q = query.lowercased()
                return all.filter {
                    $0.username.lowercased().contains(q)
                    || $0.name.lowercased().contains(q)
                    || $0.email.lowercased().contains(q)
                    || $0.phone.lowercased().contains(q)
                    || $0.city.lowercased().contains(q)
                }
            }
            .sink { [weak self] in self?.users = $0 }
            .store(in: &bag)

        source
            .sink { [weak self] _ in
                guard let self else { return }
                if case .idle = self.state { self.state = .loaded }
            }
            .store(in: &bag)
    }

    func onAppear() {
        Task { await refresh() }
    }

    func refresh() async {
        state = .loading
        do {
            try await repo.refreshUsers()
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func delete(_ user: UserUI) {
        do {
            try repo.logicalDelete(id: user.id)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
}

