//
//  APIService.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol MockAPIService {
    func load<ModelType: Codable>(_ endpoint: MockAPIEndpoint) async -> Result<ModelType, Error>
}

extension MockAPIService {
    func load<ModelType: Codable>(_ endpoint: MockAPIEndpoint) async -> Result<ModelType, Error> {
        var response: Result<ModelType, Error>
        switch endpoint.method {
        case .read:
            response = fetch(endpoint)
        case .write:
            response = write(endpoint)
        case .delete:
            response = delete(endpoint)
        }

        switch response {
        case .success(let responseObject):
            return .success(responseObject)
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - MOCK NETWORK REQUEST
extension MockAPIService {
    /// Reads the contents of URL
    /// - Parameter url: URL pointing to the location of the file or resource
    /// - Returns: A result type with a generic model type on success, or an error
    private func read<ModelType: Codable>(_ url: URL) -> Result<ModelType, Error> {
        let decoder = JSONDecoder()

        do {
            let data = try Data(contentsOf: url)

            let objects = try decoder.decode(ModelType.self, from: data)
            print("Successfully read from file at: \(url)")
            return .success(objects)
        } catch {
            return .failure(error)
        }
    }

    private func fetchAll(_ url: URL) -> [MockAPIUser] {
        /// Fetch all users
        let usersResult: Result<[MockAPIUser], Error> = read(url)

        /// Check if object already exiss
        if case .success(let objects) = usersResult {
            print(objects)
            return objects
        }

        return []
    }

    private func fetch<ModelType: Codable>(_ endpoint: MockAPIEndpoint) -> Result<ModelType, Error> {
        /// Check if we have an object
        /// Check if the object has a match
        /// Encode matched user as Data
        guard let objectToFetch = endpoint.body as? AuthCredential,
              let user = fetchAll(endpoint.baseURL).first(where: {
                  $0.username == objectToFetch.username
                  && $0.password == objectToFetch.password
              }),
              let userData = try? JSONEncoder().encode(user) else {
            return .failure(MockAPIError.invalidCredentials)
        }

        ///Decode data to generic ModelType
        return encodeDataToResult(userData)
    }

    private func write<ModelType: Codable>(_ endpoint: MockAPIEndpoint) -> Result<ModelType, Error> {
        /// Check if we have an object to write
        guard let objectToWrite = endpoint.body as? AuthCredential else {
            return .failure(MockAPIError.invalidCredentials)
        }

        /// Fetch all users
        var users: [MockAPIUser] = fetchAll(endpoint.baseURL)

        /// Check if object already exiss
        let objectExists: Bool = users.first(where: {
            $0.username == objectToWrite.username
        }) != nil
        guard !objectExists else {
            return .failure(MockAPIError.userAlreadyExists)
        }

        /// Append newUser to array of current users
        let newUser = MockAPIUser(
            token: UUID().uuidString,
            username: objectToWrite.username,
            password: objectToWrite.password)
        users.append(newUser)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            /// Write array of users to file
            let data = try encoder.encode(users)
            try data.write(to: endpoint.baseURL)

            /// Encode newUser as Data, and decode Data to generic ModelType
            let userData = try encoder.encode(newUser)
            return encodeDataToResult(userData)
        } catch {
            print("Failed to write JSON data: \(error.localizedDescription)")
            return .failure(MockAPIError.cantCreateUser)
        }
    }

    private func delete<ModelType: Codable>(_ endpoint: MockAPIEndpoint) -> Result<ModelType, Error> {
        /// Check if we have required information  to delete the object
        guard let userCredential = endpoint.body as? AuthCredential,
              let token = endpoint.headers?["token"] else {
            return .failure(MockAPIError.invalidCredentials)
        }

        /// Fetch all users
        var users: [MockAPIUser] = fetchAll(endpoint.baseURL)

        /// Check if object  exist
        let objectExists: Bool = users.first(where: {
            $0.username == userCredential.username
            && $0.password == userCredential.password
            && $0.token == token
        }) != nil
        guard objectExists else {
            return .failure(MockAPIError.incorrectPasswordOrAccess)
        }

        /// Remove item
        users.removeAll {
            $0.username == userCredential.username
            && $0.password == userCredential.password
            && $0.token == token
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            /// Write array of users to file
            let data = try encoder.encode(users)
            try data.write(to: endpoint.baseURL)

            let resultData = try JSONEncoder().encode(objectExists)

            return encodeDataToResult(resultData, customError: MockAPIError.userNotFound)
        } catch {
            print("Failed to write JSON data: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    private func encodeDataToResult<ModelType: Codable>(_ data: Data, customError: Error? = nil) -> Result<ModelType, Error> {
        let decoder = JSONDecoder()

        do {
            let responseObject = try decoder.decode(ModelType.self, from: data)
            return .success(responseObject)
        } catch {
            print("Failed to write JSON data: \(error.localizedDescription)")
            return .failure(customError ?? MockAPIError.cantCreateUser)
        }
    }
}
