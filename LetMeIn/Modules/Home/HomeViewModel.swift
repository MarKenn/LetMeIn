//
//  HomeViewModel.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol HomeViewModel {
    var repository: HomeRepository { get set }
    var user: AuthenticatedUser? { get set }
    var password: String { get set }
    var error: Error? { get }

    func deleteAccount() async -> Bool
    func resetError()
}

extension HomeView {
    @Observable
    class Model: HomeViewModel {
        var repository: HomeRepository

        var user: AuthenticatedUser?
        var password: String = ""
        private(set) var error: Error?

        init(repository: HomeRepository =  InFileHomeRepository()) {
            self.repository = repository
        }

        func deleteAccount() async -> Bool {
            guard let user = user, !password.isEmpty else { return false }

            let response = await repository.delete(user, password: password)

            switch response {
            case .success(let success):
                return success
            case .failure(let error):
                self.error = error
                return false
            }
        }

        func resetError() {
            error = nil
        }
    }
}
