//
//  MockAuthenticationRepository.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

@testable import LetMeIn

class MockAuthenticationRepository: AuthenticationRepository {
    var didCallRegister = false
    var didCallLogin = false
    var shouldSucceed: Bool = true

    var userDataProvider: UserDataProvider

    init(userDataProvider: UserDataProvider = MockUserDataProvider()) {
        self.userDataProvider = userDataProvider
    }

    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        didCallLogin = true

        return shouldSucceed
        ? .success(AuthenticatedUser(token: password, username: username))
        : .failure(MockError.mockAuthenticationRepository)
    }

    func register(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        didCallRegister = true
        
        return shouldSucceed
        ? .success(AuthenticatedUser(token: password, username: username))
        : .failure(MockError.mockAuthenticationRepository)
    }
}
