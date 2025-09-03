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
    var error: Error? { get }

    var didLogin: ((AuthenticatedUser) -> Void)? { get set }

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
        var didLogin: ((AuthenticatedUser) -> Void)?
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
                guard let didLogin else {
                    self.error = LoginViewError.didLoginClosureMissing
                    return
                }
                didLogin(authenticatedUser)
            case .failure(let error):
                self.error = error
            }
        }

        func resetError() {
            error = nil
        }
    }

    enum LoginViewError: Error, LocalizedError {
        case didLoginClosureMissing

        public var errorDescription: String? {
            switch self {
            case .didLoginClosureMissing: "Missing closure didLogin: ((AuthenticatedUser) -> Void)?"
            }
        }
    }
}
