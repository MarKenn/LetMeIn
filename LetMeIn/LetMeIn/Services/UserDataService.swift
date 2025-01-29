//
//  UserDataService.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol UserDataProvider {
    func register(_ username: String, password: String) async -> Result<AuthenticatedUser, Error>
    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, Error>
}

struct UserDataService: MockAPIService, UserDataProvider {
    func register(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        let authCredential = AuthCredential(username: username, password: password)
        return await load(MockUserEndpoint.register(authCredential))
    }

    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, Error> {
        let authCredential = AuthCredential(username: username, password: password)
        return await load(MockUserEndpoint.login(authCredential))
    }
}
