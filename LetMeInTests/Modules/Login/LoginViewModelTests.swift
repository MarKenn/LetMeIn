//
//  LoginViewModelTests.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import XCTest
@testable import LetMeIn

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginView.Model!

    var mockRepository = MockAuthenticationRepository()
    var testAuthenticatedUser = AuthenticatedUser(token: "testToken", username: "testUsername")

    override func setUp() {
        mockRepository = MockAuthenticationRepository()
        viewModel = LoginView.Model(repository: mockRepository)
    }

    func testInitialState() {
        XCTAssert(viewModel.username.isEmpty)
        XCTAssert(viewModel.password.isEmpty)
        XCTAssertNil(viewModel.authenticatedUser)
        XCTAssertNil(viewModel.error)
        XCTAssert(viewModel.repository is MockAuthenticationRepository)
    }

    func testRegister() async {
        XCTAssertFalse(mockRepository.didCallRegister)

        await viewModel.register()

        XCTAssert(mockRepository.didCallRegister)
    }

    func testLogin() async {
        XCTAssertFalse(mockRepository.didCallLogin)

        await viewModel.login()

        XCTAssert(mockRepository.didCallLogin)
    }

    func testHandleResponseSuccess() {
        XCTAssertNil(viewModel.authenticatedUser)

        viewModel.handleResponse(.success(testAuthenticatedUser))

        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.authenticatedUser?.username, testAuthenticatedUser.username)
        XCTAssertEqual(viewModel.authenticatedUser?.token, testAuthenticatedUser.token)
    }

    func testHandleResponseFail() {
        XCTAssertNil(viewModel.error)

        viewModel.handleResponse(.failure(MockError.mockAuthenticationRepository))

        XCTAssertNotNil(viewModel.error)
        XCTAssert(viewModel.error is MockError)
        XCTAssert((viewModel.error as? MockError) == .mockAuthenticationRepository)
    }

    func test_resetError_setsErrorToNil() {
        viewModel.handleResponse(.failure(MockError.mockAuthenticationRepository))
        XCTAssertNotNil(viewModel.error)

        viewModel.resetError()

        XCTAssertNil(viewModel.error)
    }
}
