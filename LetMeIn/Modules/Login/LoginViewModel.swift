//
//  LoginViewModel.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/28/25.
//

import Foundation

protocol LoginViewModel {
    var repository: AuthenticationRepository { get set }
    var username: String { get set }
    var password: String { get set }
    var authenticatedUser: AuthenticatedUser? { get }
    var error: Error? { get }

    func register() async
    func login() async
    func resetError()
}

extension LoginView {
    @Observable
    class Model: LoginViewModel {
        var repository: AuthenticationRepository

        var username: String = ""
        var password: String = ""
        var authenticatedUser: AuthenticatedUser?
        private(set) var error: Error?

        init(repository: AuthenticationRepository =  InFileAuthenticationRepository()) {
            self.repository = repository
        }

        func register() async {
            handleResponse(await repository.register(username, password: password))
        }

        func login() async {
            handleResponse(await repository.login(username, password: password))
        }
        
        /// Handler for the result response from the repository
        /// - Parameter response: A result type with an AuthenticatedUser on success, or an error
        func handleResponse(_ response: Result<AuthenticatedUser, Error>) {
            switch response {
            case .success(let authenticatedUser):
                self.authenticatedUser = authenticatedUser
            case .failure(let error):
                self.error = error
            }
        }

        func resetError() {
            error = nil
        }
    }
}
