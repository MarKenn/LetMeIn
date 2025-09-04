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

        await expect(repository, toDeleteWithResult: .success(true))
    }

    func test_delete_deliversSuccessWithFalseValue() async {
        XCTAssertFalse(mockDataProvider.didCallDelete)

        mockDataProvider.deleteSuccessValue = false

        await expect(repository, toDeleteWithResult: .success(false))
    }

    func testDeleteFail() async {
        XCTAssertFalse(mockDataProvider.didCallDelete)

        mockDataProvider.shouldSucceed = false

        await expect(repository, toDeleteWithResult: .failure(MockError.mockUserDataProvider))
    }

    // MARK: - Helpers

    func expect(
        _ repository: InFileHomeRepository,
        toDeleteWithResult expectedResult: HomeRepository.Result,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        let receivedResult = await repository.delete(testAuthenticatedUser, password: testPassword)

        XCTAssert(mockDataProvider.didCallDelete, file: file, line: line)

        switch (receivedResult, expectedResult) {
        case let (.success(receivedValue), .success(expectedValue)):
            XCTAssertEqual(receivedValue, expectedValue, file: file, line: line)
        case let (.failure(receivedError as MockError), .failure(expectedError as MockError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail(
                "Expecting \(expectedResult), got \(receivedResult) instead", file: file, line: line
            )
        }
    }
}
