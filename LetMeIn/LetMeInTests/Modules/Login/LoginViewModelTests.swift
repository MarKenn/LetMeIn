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

    override func setUp() {
        mockRepository = MockAuthenticationRepository()
        viewModel = LoginView.Model(repository: mockRepository)
    }

    func testInitialState() {
        XCTAssert(viewModel.username.isEmpty)
        XCTAssert(viewModel.password.isEmpty)
        XCTAssertNil(viewModel.didLogin)
        XCTAssertNil(viewModel.error)
        XCTAssert(viewModel.repository is MockAuthenticationRepository)
    }
}
