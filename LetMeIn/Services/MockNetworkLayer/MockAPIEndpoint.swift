//
//  APIEndpoint.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

enum MockMethod: String {
    case read
    case write
    case delete
}

protocol MockAPIEndpoint {
    var baseURL: URL { get }
    var method: MockMethod { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
    var body: Codable? { get }
}
