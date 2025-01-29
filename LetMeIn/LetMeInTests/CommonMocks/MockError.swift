//
//  MockError.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

enum MockError: Error, LocalizedError {
    case mockAuthenticationRepository
    case mockUserDataProvider
    case mockHomeRepository
    case testError

    public var errorDescription: String? {
        switch self {
        case .mockAuthenticationRepository: "Errors for MockAuthenticationRepository"
        case .mockUserDataProvider: "Errors for MockUserDataProvider"
        case .mockUserDataProvider: "Errors for MockHomeRepository"
        default: "Mock error for tests"
        }
    }
}
