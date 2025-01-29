//
//  MockHomeRepository.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/30/25.
//

@testable import LetMeIn

class MockHomeRepository: HomeRepository {
    var didCallDelete = false
    var shouldSucceed: Bool = true

    var userDataProvider: UserDataProvider

    init(userDataProvider: UserDataProvider = MockUserDataProvider()) {
        self.userDataProvider = userDataProvider
    }

    func delete(_ authenticatedUser: LetMeIn.AuthenticatedUser, password: String) async -> Result<Bool, any Error> {
        didCallDelete = true

        return shouldSucceed
        ? .success(true)
        : .failure(MockError.mockHomeRepository)
    }
}
