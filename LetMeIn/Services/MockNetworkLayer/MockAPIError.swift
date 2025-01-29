//
//  MockAPIError.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

enum MockAPIError: Error {
    case userNotFound, invalidCredentials, userAlreadyExists, cantCreateUser, cantDecodeResponse,
         incorrectPasswordOrAccess, unknownError
}

extension MockAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userAlreadyExists: return "User already exists"
        case .cantCreateUser: return "Can't create user"
        case .incorrectPasswordOrAccess: return "Incorrect password or access"
        case .cantDecodeResponse: fallthrough
        case .userNotFound: fallthrough
        case .invalidCredentials:
            return "Invalid credentials"
        default:
            return "Unknown error"
        }
    }
}
