//  UserFormViewModelTests.swift
//  UsersAppTests

import XCTest
@testable import UsersApp

final class UserFormViewModelTests: XCTestCase {
    func test_submit_valid_creates_and_resets() {
        let repo = MockRepo()
        let loc = MockLocation()
        let vm = UserFormViewModel(repo: repo, location: loc)

        vm.name = "Carlos"
        vm.email = "c@mail.com"
        vm.phone = "555"
        vm.submit()

        XCTAssertEqual(repo.users.value.count, 1)
        XCTAssertEqual(vm.name, "")
        XCTAssertEqual(vm.email, "")
        XCTAssertEqual(vm.phone, "")
    }

    func test_requestLocation_sets_coordinate() {
        let repo = MockRepo()
        let loc = MockLocation()
        let vm = UserFormViewModel(repo: repo, location: loc)
        vm.requestLocation()
        XCTAssertNotNil(vm.coordinate)
    }
}