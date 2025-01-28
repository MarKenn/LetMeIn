//
//  AuthenticationRepository.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol AuthenticationRepository {
    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, MockAPIError>

    func createUser(_ username: String, password: String) async -> Result<AuthenticatedUser, MockAPIError> 
}

class InFileAuthenticationRepository: AuthenticationRepository {
    var userDataProvider: UserDataProvider

    init(
        userDataProvider: UserDataProvider = UserDataService()
    ) {
        self.userDataProvider = userDataProvider
    }

    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, MockAPIError> {
        await userDataProvider.login(username, password: password)
    }

    func createUser(_ username: String, password: String) async -> Result<AuthenticatedUser, MockAPIError> {
        return await userDataProvider.saveUser(username, password: password)
    }
}
