//  ValidatorsTests.swift
//  UsersAppTests

import XCTest
@testable import UsersApp

final class ValidatorsTests: XCTestCase {
    func test_required_ok() {
        XCTAssertNoThrow(try Validators.required("hi", field: "name"))
    }
    func test_required_fails() {
        XCTAssertThrowsError(try Validators.required("  ", field: "name"))
    }
    func test_email_ok() {
        XCTAssertNoThrow(try Validators.email("a@b.com"))
    }
    func test_email_fails() {
        XCTAssertThrowsError(try Validators.email("nope"))
    }
}