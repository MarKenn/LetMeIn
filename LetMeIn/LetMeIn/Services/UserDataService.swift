//
//  UserDataService.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol UserDataProvider {
    func saveUser(_ username: String, password: String) async -> Result<AuthenticatedUser, MockAPIError>
    func fetchAllUsers() async -> [MockAPIUser]
    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, MockAPIError>
}

enum MockAPIError: Error {
    case userNotFound, invalidCredentials, userAlreadyExists

    var localizedDescription: String {
        switch self {
        case .userAlreadyExists: return "User Already Exists"
        case .userNotFound: fallthrough
        case .invalidCredentials:
            return "Invalid credentials"
        }
    }
}

class UserDataService: MockAPIService, UserDataProvider {
    var users: [MockAPIUser] = []

    func saveUser(_ username: String, password: String) async -> Result<AuthenticatedUser, MockAPIError> {
        users = await fetchAllUsers()
        let user = users.first(where: { $0.username == username })

        guard user == nil else {
            return .failure(MockAPIError.userAlreadyExists)
        }

        let newUser = MockAPIUser(username: username, password: password, token: UUID().uuidString)
        users.append(newUser)
        write(users)

        let authenticatedUser = AuthenticatedUser(username: newUser.username, token: newUser.token)
        return .success(authenticatedUser)
    }

    func fetchAllUsers() async -> [MockAPIUser] {
        users = read() ?? []
        print(users)
        return users
    }

    func login(_ username: String, password: String) async -> Result<AuthenticatedUser, MockAPIError> {
        users = await fetchAllUsers()
        let user = users.first(where: {
            $0.username == username && $0.password == password
        })

        if let user {
            let authenticatedUser = AuthenticatedUser(username: user.username, token: user.token)
            return .success(authenticatedUser)
        } else {
            return .failure(MockAPIError.userNotFound)
        }

    }
}
