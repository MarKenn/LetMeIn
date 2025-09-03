//
//  HomeViewModel.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol HomeViewModel {
    var repository: HomeRepository { get set }
    var password: String { get set }
    var error: Error? { get }

    func delete(user: AuthenticatedUser) async -> Bool
    func resetError()
    func resetAccountDeletion()
}

extension HomeView {
    @Observable
    class Model: HomeViewModel {
        var repository: HomeRepository

        var password: String = ""
        private(set) var error: Error?

        init(repository: HomeRepository =  InFileHomeRepository()) {
            self.repository = repository
        }

        func delete(user: AuthenticatedUser) async -> Bool {
            guard !password.isEmpty else { return false }

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

        func resetAccountDeletion() {
            password = ""
            resetError()
        }
    }
}
