//
//  MockAPIService.swift
//  LetMeIn
//
//  Created by Mark Kenneth Bayona on 1/29/25.
//

import Foundation

protocol MockAPIService {
    func write(_ objects: [MockAPIUser])
    func read() -> [MockAPIUser]?
}

extension MockAPIService {
    var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    var url: URL {
        documentsDirectory.appendingPathComponent("users.json")
    }

    func write(_ objects: [MockAPIUser]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // For readable JSON formatting

        do {
            let data = try encoder.encode(objects)
            try data.write(to: url)
            print("Successfully wrote to file at: \(url)")
        } catch {
            print("Failed to write JSON data: \(error.localizedDescription)")
        }
    }

    func read() -> [MockAPIUser]? {
        let decoder = JSONDecoder()

        do {
            let data = try Data(contentsOf: url)
            
            let objects = try decoder.decode([MockAPIUser].self, from: data)
            print("Successfully read from file at: \(url)")
            return objects
        } catch {
            print("Failed to read JSON data: \(error.localizedDescription)")
            return nil
        }
    }
}
