//
//  APIClient.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation
import Alamofire

enum APIClientError: LocalizedError {
    case decoding(String)
    var errorDescription: String? { switch self {
        case .decoding(let m): return m
    }}
}

struct APIClient {
    
    static let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!

    func get<T: Decodable>(_ path: String) async throws -> T {
        let url = APIClient.baseURL.appendingPathComponent(path)
        let data = try await AF.request(url)
            .validate(statusCode: 200..<300)
            .serializingData().value

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch let DecodingError.keyNotFound(key, ctx) {
            throw APIClientError.decoding("Key not found: \(key.stringValue) at \(ctx.codingPath.map{$0.stringValue}.joined(separator: "."))")
        } catch let DecodingError.valueNotFound(_, ctx) {
            throw APIClientError.decoding("Value missing at \(ctx.codingPath.map{$0.stringValue}.joined(separator: "."))")
        } catch let DecodingError.typeMismatch(_, ctx) {
            throw APIClientError.decoding("Type mismatch at \(ctx.codingPath.map{$0.stringValue}.joined(separator: "."))")
        } catch let DecodingError.dataCorrupted(ctx) {
            throw APIClientError.decoding("Data corrupted at \(ctx.codingPath.map{$0.stringValue}.joined(separator: "."))")
        } catch {
            if let s = String(data: data, encoding: .utf8) { print("Raw response:", s) }
            throw error
        }
    }
}
