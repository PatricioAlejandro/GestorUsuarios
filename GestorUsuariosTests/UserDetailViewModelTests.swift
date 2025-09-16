//  UserDetailViewModelTests.swift
//  UsersAppTests

import XCTest
@testable import UsersApp

final class UserDetailViewModelTests: XCTestCase {
    func test_save_updates_name_email() {
        let repo = MockRepo()
        let user = UserUI(id: 1, username: "user1", name: "Alice", email: "a@mail.com", phone: "1", city: "Quito", coordinate: nil)
        repo.users.send([user])

        let vm = UserDetailViewModel(userId: 1, repo: repo)
        vm.name = "Alicia"
        vm.email = "ali@mail.com"
        vm.save()

        XCTAssertEqual(repo.users.value.first?.name, "Alicia")
        XCTAssertEqual(repo.users.value.first?.email, "ali@mail.com")
    }
}