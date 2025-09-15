//
//  APIClient.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation
import Alamofire

struct APIClient {
    static let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!

    func get<T: Decodable>(_ path: String) async throws -> T {
        let url = APIClient.baseURL.appendingPathComponent(path)
        let data = try await AF.request(url).serializingData().value
        let dataDecoded = try JSONDecoder().decode(T.self, from: data)
        print("__________________AQUI LOS USUARIOS")
        print(dataDecoded)
        return dataDecoded
    }
}
