//
//  UserSession.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/28/25.
//

import Foundation

@Observable
class UserSession {
    private var user: AuthenticatedUser?
    var isLoggedIn: Bool { user != nil }

    func login(_ user: AuthenticatedUser) {
        self.user = user
    }

    func logout() {
        user = nil
    }
}
