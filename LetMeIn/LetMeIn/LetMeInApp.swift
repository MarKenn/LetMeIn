//
//  LetMeInApp.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/28/25.
//

import SwiftUI

@main
struct LetMeInApp: App {
    @State private var userSession = UserSession()

    var body: some Scene {
        WindowGroup {
            if userSession.isLoggedIn {
                ContentView()
                    .environment(userSession)
            } else {
                LoginView()
                    .environment(userSession)
            }
        }
    }
}
