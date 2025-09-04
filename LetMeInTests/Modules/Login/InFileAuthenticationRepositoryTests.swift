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
    var testUser = AuthenticatedUser(token: "testPassword", username: "testUsername")
    var testFailure = AuthenticationRepository.Result.failure(MockError.mockUserDataProvider)

    override func setUp() {
        mockDataProvider = MockUserDataProvider()
        repository = InFileAuthenticationRepository(userDataProvider: mockDataProvider)
    }

    func testInitialState() {
        XCTAssert(repository.userDataProvider is MockUserDataProvider)
    }

    func testLoginSuccess() async {
        XCTAssertFalse(mockDataProvider.didCallLogin)

        let result = await repository.login(testUser.username, password: testUser.token)

        expect(toCall: mockDataProvider.didCallLogin, withResult: result, toBe: .success(testUser))
    }

    func testLoginFail() async {
        XCTAssertFalse(mockDataProvider.didCallLogin)

        mockDataProvider.shouldSucceed = false
        let result = await repository.login(testUser.username, password: testUser.token)

        expect(toCall: mockDataProvider.didCallLogin, withResult: result, toBe: testFailure)
    }

    func testRegisterSuccess() async {
        XCTAssertFalse(mockDataProvider.didCallRegister)

        let result = await repository.register(testUser.username, password: testUser.token)

        expect(toCall: mockDataProvider.didCallRegister, withResult: result, toBe: .success(testUser))
    }

    func testRegisterFail() async {
        XCTAssertFalse(mockDataProvider.didCallRegister)

        mockDataProvider.shouldSucceed = false
        let result = await repository.register(testUser.username, password: testUser.token)

        expect(toCall: mockDataProvider.didCallRegister, withResult: result, toBe: testFailure)
    }

    // MARK: - Helpers

    func expect(
        toCall didCall: Bool,
        withResult receivedResult: AuthenticationRepository.Result,
        toBe expectedResult: AuthenticationRepository.Result,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssert(didCall, file: file, line: line)

        switch (receivedResult, expectedResult) {
        case let (.success(receivedUser), .success(expectedUser)):
            XCTAssertEqual(receivedUser.username, expectedUser.username, file: file, line: line)
            XCTAssertEqual(receivedUser.token, expectedUser.token, file: file, line: line)
        case let (.failure(receivedError as MockError), .failure(expectedError as MockError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail(
                "Expecting \(expectedResult), got \(receivedResult) instead", file: file, line: line
            )
        }
    }
}
