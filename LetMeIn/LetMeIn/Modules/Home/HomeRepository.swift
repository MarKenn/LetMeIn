//
//  HomeRepository.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol HomeRepository {
    var userDataProvider: UserDataProvider { get set }

    func delete(_ authenticatedUser: AuthenticatedUser, password: String) async -> Result<Bool, Error>
}

class InFileHomeRepository: HomeRepository {
    var userDataProvider: UserDataProvider

    init(userDataProvider: UserDataProvider = UserDataService()) {
        self.userDataProvider = userDataProvider
    }

    func delete(_ authenticatedUser: AuthenticatedUser, password: String) async -> Result<Bool, any Error> {
        await userDataProvider.delete(authenticatedUser, password: password)
    }
}
