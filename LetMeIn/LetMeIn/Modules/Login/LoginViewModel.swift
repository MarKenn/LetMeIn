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
    var error: Error? { get set }
    var repository: AuthenticationRepository { get set }

    var didLogin: ((AuthenticatedUser) -> Void)? { get set }

    func register()
    func login()
}

extension LoginView {
    @Observable
    class Model: LoginViewModel {
        var repository: AuthenticationRepository

        var username: String = ""
        var password: String = ""
        var didLogin: ((AuthenticatedUser) -> Void)?
        var error: Error?

        init(repository: AuthenticationRepository =  InFileAuthenticationRepository()) {
            self.repository = repository
        }

        func register() {
            Task {
                handleResponse(await repository.register(username, password: password))
            }
        }

        func login() {
            Task {
                handleResponse(await repository.login(username, password: password))
            }
        }

        func handleResponse(_ response: Result<AuthenticatedUser, Error>) {
            if case .success(let authenticatedUser) = response {
                didLogin?(authenticatedUser)
            } else if case .failure(let error) = response {
                self.error = error
            }
        }
    }
}
