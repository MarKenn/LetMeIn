//
//  AuthenticationRepository.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol AuthenticationRepository {
    var userDataProvider: UserDataProvider { get set }

    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, Error>
    func register(_ username: String, password: String) async -> Result<AuthenticatedUser, Error>
}

class InFileAuthenticationRepository: AuthenticationRepository {
    var userDataProvider: UserDataProvider

    init(userDataProvider: UserDataProvider = UserDataService()) {
        self.userDataProvider = userDataProvider
    }

    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        await userDataProvider.login(username, password: password)
    }

    func register(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        return await userDataProvider.register(username, password: password)
    }
}
