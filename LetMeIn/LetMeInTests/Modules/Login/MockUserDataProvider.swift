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
    var shouldSucceed: Bool = true

    func register(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        didCallRegister = true

        return shouldSucceed
        ? .success(AuthenticatedUser(token: "test", username: username))
        : .failure(MockAPIError.unknownError)
    }
    
    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        didCallLogin = false

        return shouldSucceed
        ? .success(AuthenticatedUser(token: "test", username: username))
        : .failure(MockAPIError.unknownError)
    }
}
