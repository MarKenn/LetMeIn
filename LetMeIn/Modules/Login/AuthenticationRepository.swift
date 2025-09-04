//
//  AuthenticationRepository.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol AuthenticationRepository {
    typealias Result = Swift.Result<AuthenticatedUser, Error>

    var userDataProvider: UserDataProvider { get set }

    func login(_ username: String, password: String) async -> Result
    func register(_ username: String, password: String) async -> Result
}

class InFileAuthenticationRepository: AuthenticationRepository {
    var userDataProvider: UserDataProvider

    init(userDataProvider: UserDataProvider = UserDataService()) {
        self.userDataProvider = userDataProvider
    }

    func login(_ username: String, password: String) async -> AuthenticationRepository.Result {
        await userDataProvider.login(username, password: password)
    }

    func register(_ username: String, password: String) async -> AuthenticationRepository.Result {
        await userDataProvider.register(username, password: password)
    }
}
