//
//  HomeViewModelTests.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/30/25.
//

import XCTest
@testable import LetMeIn

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeView.Model!

    var mockRepository = MockHomeRepository()
    var testAuthenticatedUser = AuthenticatedUser(token: "testToken", username: "testUsername")
    var testPassword = "testPassword"

    override func setUp() {
        mockRepository = MockHomeRepository()
        viewModel = HomeView.Model(repository: mockRepository)
    }

    func testInitialState() {
        XCTAssertNil(viewModel.user)
        XCTAssert(viewModel.password.isEmpty)
        XCTAssertNil(viewModel.error)
        XCTAssert(viewModel.repository is MockHomeRepository)
    }

    func testDeleteInitial() async {
        XCTAssertNil(viewModel.user)
        XCTAssert(viewModel.password.isEmpty)
        XCTAssertFalse(mockRepository.didCallDelete)

        let _ = await viewModel.deleteAccount()

        XCTAssertFalse(mockRepository.didCallDelete)
    }

    func testDeleteSuccess() async {
        XCTAssertNil(viewModel.user)
        XCTAssert(viewModel.password.isEmpty)
        XCTAssertFalse(mockRepository.didCallDelete)

        viewModel.user = testAuthenticatedUser
        viewModel.password = testPassword

        let success = await viewModel.deleteAccount()

        XCTAssert(mockRepository.didCallDelete)
        XCTAssertNil(viewModel.error)
        XCTAssert(success)
    }

    func testDeleteFails() async {
        XCTAssertNil(viewModel.user)
        XCTAssert(viewModel.password.isEmpty)
        XCTAssertFalse(mockRepository.didCallDelete)

        viewModel.user = testAuthenticatedUser
        viewModel.password = testPassword
        mockRepository.shouldSucceed = false

        let success = await viewModel.deleteAccount()

        XCTAssert(mockRepository.didCallDelete)
        XCTAssert(viewModel.error is MockError)
        XCTAssert((viewModel.error as? MockError) == .mockHomeRepository)
        XCTAssertFalse(success)
    }

    func test_resetError_setsErrorToNil() async {
        viewModel.user = testAuthenticatedUser
        viewModel.password = testPassword
        mockRepository.shouldSucceed = false
        _ = await viewModel.deleteAccount()
        XCTAssertNotNil(viewModel.error)

        viewModel.resetError()

        XCTAssertNil(viewModel.error)
    }
}
