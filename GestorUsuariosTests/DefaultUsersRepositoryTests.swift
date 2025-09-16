//  DefaultUsersRepositoryTests.swift
//  UsersAppTests

import XCTest
import Combine
import RealmSwift
@testable import UsersApp

final class DefaultUsersRepositoryTests: XCTestCase {
    var bag = Set<AnyCancellable>()

    func test_refreshUsers_savesToRealm_andPublishes() async throws {
        let realm = InMemoryRealm.make()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = realm.configuration.inMemoryIdentifier

        let api = MockUsersAPI()
        api.result = .success(MockUsersAPI.sampleUsers(count: 2))

        let repo = DefaultUsersRepository(api: api, realm: realm)

        let exp = expectation(description: "Publishes users")
        var last: [UserUI] = []
        repo.usersPublisher()
            .sink { list in
                last = list
                if list.count == 2 { exp.fulfill() }
            }
            .store(in: &bag)

        try await repo.refreshUsers()
        wait(for: [exp], timeout: 2.0)

        XCTAssertEqual(last.count, 2)
        XCTAssertEqual(last.first?.username, "user1")
    }

    func test_create_update_delete_flow() throws {
        let realm = InMemoryRealm.make()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = realm.configuration.inMemoryIdentifier

        let api = MockUsersAPI()
        let repo = DefaultUsersRepository(api: api, realm: realm)

        try repo.create(user: NewUser(name: "Alice", email: "alice@mail.com", phone: "555", coordinate: nil))
        var obj = try XCTUnwrap(realm.objects(User.self).first)
        XCTAssertEqual(obj.name, "Alice")

        try repo.update(user: UpdateUser(id: obj.id, name: "Alicia", email: "ali@mail.com"))
        obj = try XCTUnwrap(realm.objects(User.self).first)
        XCTAssertEqual(obj.name, "Alicia")
        XCTAssertEqual(obj.email, "ali@mail.com")

        try repo.logicalDelete(id: obj.id)
        XCTAssertTrue(try XCTUnwrap(realm.objects(User.self).first).isDeleted)
    }
}