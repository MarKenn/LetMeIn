//
//  UserEndpoint.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

enum MockUserEndpoint: MockAPIEndpoint {
    case login(AuthCredential)
    case register(AuthCredential)
    case delete(AuthCredential, AuthenticatedUser)

    var baseURL: URL { Constant.apiBaseURL.appendingPathComponent("users.json") }

    var path: String { "" }

    var headers: [String : String]? {
        switch self {
        case .delete(_, let auth):
            ["token": auth.token]
        default: nil
        }
    }

    var method: MockMethod {
        switch self {
        case .login:
                .read
        case .register:
                .write
        case .delete:
                .delete
        }
    }

    var parameters: [String : String]? {
        nil
    }

    var body: (any Codable)? {
        switch self {
        case .login(let credential):
            return credential
        case .register(let credential):
            return credential
        case .delete(let credential, _):
            return credential
        }
    }
}
