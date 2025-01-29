//
//  InFileHomeRepositoryTests.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/30/25.
//

import XCTest
@testable import LetMeIn

final class InFileHomeRepositoryTests: XCTestCase {
    var repository: InFileHomeRepository!

    var mockDataProvider = MockUserDataProvider()
    var testAuthenticatedUser = AuthenticatedUser(token: "testToken", username: "testUsername")
    var testPassword = "testPassword"

    override func setUp() {
        mockDataProvider = MockUserDataProvider()
        repository = InFileHomeRepository(userDataProvider: mockDataProvider)
    }

    func testInitialState() {
        XCTAssert(repository.userDataProvider is MockUserDataProvider)
    }

    func testDeleteSuccess() async {
        XCTAssertFalse(mockDataProvider.didCallDelete)

        let result = await repository.delete(testAuthenticatedUser, password: testPassword)

        XCTAssert(mockDataProvider.didCallDelete)
        if case let .success(value) = result {
            XCTAssert(value)
        } else {
            XCTAssert(false, "Expecting .success(AuthenticatedUser) but got .failure(Error) instead")
        }
    }

    func testDeleteFail() async {
        XCTAssertFalse(mockDataProvider.didCallDelete)

        mockDataProvider.shouldSucceed = false
        let result = await repository.delete(testAuthenticatedUser, password: testPassword)

        XCTAssert(mockDataProvider.didCallDelete)
        if case let .failure(error) = result {
            XCTAssert(error is MockError)
            XCTAssert((error as? MockError) == .mockUserDataProvider)
        } else {
            XCTAssert(false, "Expecting .failure(Error) but got .success(AuthenticatedUser) instead")
        }
    }
}
