//
//  MockUserDataProvider.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

@testable import LetMeIn

class MockUserDataProvider: UserDataProvider {
    var didCallRegister = false
    var didCallLogin = false
    var didCallDelete = false
    var shouldSucceed: Bool = true
    var deleteSuccessValue: Bool = true

    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        didCallLogin = true

        return shouldSucceed
        ? .success(AuthenticatedUser(token: password, username: username))
        : .failure(MockError.mockUserDataProvider)
    }

    func register(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        didCallRegister = true

        return shouldSucceed
        ? .success(AuthenticatedUser(token: password, username: username))
        : .failure(MockError.mockUserDataProvider)
    }

    func delete(_ authenticatedUser: AuthenticatedUser, password: String) async -> Result<Bool, Error> {
        didCallDelete = true

        return shouldSucceed
        ? .success(deleteSuccessValue)
        : .failure(MockError.mockUserDataProvider)
    }
}
