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

    var baseURL: URL { Constant.apiBaseURL.appendingPathComponent("users.json") }

    var path: String { "" }

    var headers: [String : String]? { nil }

    var method: MockMethod {
        switch self {
        case .login:
                .read
        case .register:
                .write
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
        }
    }
}
