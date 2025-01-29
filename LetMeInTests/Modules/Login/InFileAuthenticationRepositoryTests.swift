//
//  InFileAuthenticationRepositoryTests.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import XCTest
@testable import LetMeIn

final class InFileAuthenticationRepositoryTests: XCTestCase {
    var repository: InFileAuthenticationRepository!

    var mockDataProvider = MockUserDataProvider()
    var testUsername = "testUsername"
    var testPassword = "testPassword"

    override func setUp() {
        mockDataProvider = MockUserDataProvider()
        repository = InFileAuthenticationRepository(userDataProvider: mockDataProvider)
    }

    func testInitialState() {
        XCTAssert(repository.userDataProvider is MockUserDataProvider)
    }

    func testLoginSuccess() async {
        XCTAssertFalse(mockDataProvider.didCallLogin)

        let result = await repository.login(testUsername, password: testPassword)

        XCTAssert(mockDataProvider.didCallLogin)
        if case let .success(value) = result {
            XCTAssertEqual(value.username, testUsername)
            XCTAssertEqual(value.token, testPassword)
        } else {
            XCTAssert(false, "Expecting .success(AuthenticatedUser) but got .failure(Error) instead")
        }
    }

    func testLoginFail() async {
        XCTAssertFalse(mockDataProvider.didCallLogin)

        mockDataProvider.shouldSucceed = false
        let result = await repository.login(testUsername, password: testPassword)

        XCTAssert(mockDataProvider.didCallLogin)
        if case let .failure(error) = result {
            XCTAssert(error is MockError)
            XCTAssert((error as? MockError) == .mockUserDataProvider)
        } else {
            XCTAssert(false, "Expecting .failure(Error) but got .success(AuthenticatedUser) instead")
        }
    }

    func testRegisterSuccess() async {
        XCTAssertFalse(mockDataProvider.didCallRegister)

        let result = await repository.register(testUsername, password: testPassword)

        XCTAssert(mockDataProvider.didCallRegister)
        if case let .success(value) = result {
            XCTAssertEqual(value.username, testUsername)
            XCTAssertEqual(value.token, testPassword)
        } else {
            XCTAssert(false, "Expecting .success(AuthenticatedUser) but got .failure(Error) instead")
        }
    }

    func testRegisterFail() async {
        XCTAssertFalse(mockDataProvider.didCallRegister)

        mockDataProvider.shouldSucceed = false
        let result = await repository.register(testUsername, password: testPassword)

        XCTAssert(mockDataProvider.didCallRegister)
        if case let .failure(error) = result {
            XCTAssert(error is MockError)
            XCTAssert((error as? MockError) == .mockUserDataProvider)
        } else {
            XCTAssert(false, "Expecting .failure(Error) but got .success(AuthenticatedUser) instead")
        }
    }
}
