//
//  Validators.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import Foundation

enum ValidationError: LocalizedError {
    case empty(field: String)
    case invalidEmail

    var errorDescription: String? {
        switch self {
        case .empty(let f): return "Field \(f) is required."
        case .invalidEmail: return "Email is invalid."
        }
    }
}

enum Validators {
    static func required(_ value: String, field: String) throws {
        if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidationError.empty(field: field)
        }
    }

    static func email(_ value: String) throws {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"# 
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        if regex.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.utf16.count)) == nil {
            throw ValidationError.invalidEmail
        }
    }
}
