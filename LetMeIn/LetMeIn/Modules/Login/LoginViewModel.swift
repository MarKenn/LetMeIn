//
//  LoginViewModel.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/28/25.
//

import Foundation

protocol LoginViewModel {
    var username: String { get set }
    var password: String { get set }
    var error: MockAPIError? { get set }

    var didLogin: ((AuthenticatedUser) -> Void)? { get set }

    func requestSignup()
    func requestLogin()
}

extension LoginView {
    @Observable
    class Model: LoginViewModel {
        var repository: AuthenticationRepository

        var username: String = ""
        var password: String = ""
        var didLogin: ((AuthenticatedUser) -> Void)?
        var error: MockAPIError?

        init(repository: AuthenticationRepository =  InFileAuthenticationRepository()) {
            self.repository = repository
        }

        func requestSignup() {
            Task {
                handleResponse(await repository.createUser(username, password: password))
            }
        }

        func requestLogin() {
            Task {
                handleResponse(await repository.login(username, password: password))
            }
        }

        func handleResponse(_ response: Result<AuthenticatedUser, MockAPIError>) {
            if case .success(let authenticatedUser) = response {
                didLogin?(authenticatedUser)
            } else if case .failure(let error) = response {
                self.error = error
            }
        }
    }
}
