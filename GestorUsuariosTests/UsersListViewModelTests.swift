//  UsersListViewModelTests.swift
//  UsersAppTests

import XCTest
import Combine
@testable import UsersApp

final class UsersListViewModelTests: XCTestCase {
    func test_search_filters() {
        let repo = MockRepo()
        let vm = UsersListViewModel(repo: repo)

        repo.users.send([
            .init(id: 1, username: "user1", name: "Alice", email: "a@mail.com", phone: "1", city: "Quito", coordinate: nil),
            .init(id: 2, username: "user2", name: "Bob", email: "b@mail.com", phone: "2", city: "Guayaquil", coordinate: nil),
        ])

        XCTAssertEqual(vm.users.count, 2)
        vm.searchText = "ali"
        XCTAssertEqual(vm.users.count, 1)
        XCTAssertEqual(vm.users.first?.name, "Alice")
    }
}