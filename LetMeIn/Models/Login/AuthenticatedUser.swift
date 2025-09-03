//
//  AuthenticatedUser.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

struct AuthenticatedUser: Codable, Equatable {
    var token: String
    var username: String
}
