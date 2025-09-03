//
//  HomeRepository.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol HomeRepository {
    typealias Result = Swift.Result<Bool, Error>

    var userDataProvider: UserDataProvider { get set }

    func delete(_ authenticatedUser: AuthenticatedUser, password: String) async -> Result
}

class InFileHomeRepository: HomeRepository {
    var userDataProvider: UserDataProvider

    init(userDataProvider: UserDataProvider = UserDataService()) {
        self.userDataProvider = userDataProvider
    }

    func delete(_ authenticatedUser: AuthenticatedUser, password: String) async -> HomeRepository.Result {
        await userDataProvider.delete(authenticatedUser, password: password)
    }
}
