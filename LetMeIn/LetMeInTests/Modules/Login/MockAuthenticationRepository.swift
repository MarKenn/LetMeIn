//
//  MockAuthenticationRepository.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

@testable import LetMeIn

class MockAuthenticationRepository: AuthenticationRepository {
    var userDataProvider: UserDataProvider

    init(userDataProvider: UserDataProvider = MockUserDataProvider()) {
        self.userDataProvider = userDataProvider
    }

    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        await userDataProvider.login(username, password: password)
    }

    func register(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        return await userDataProvider.register(username, password: password)
    }
}
