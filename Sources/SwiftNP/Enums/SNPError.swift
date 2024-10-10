//
//  SNPError.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 09/10/24.
//

import Foundation

public enum SNPError: Error, CustomStringConvertible {
    case typeError(String)
    case valueError(String)
    case indexError(String)
    case memoryError(String)
    case floatingPointError(String)
    case assertionError(String)
    
    public var description: String {
        switch self {
        case .typeError(let message):
            return "TypeError: \(message)"
        case .valueError(let message):
            return "ValueError: \(message)"
        case .indexError(let message):
            return "IndexError: \(message)"
        case .memoryError(let message):
            return "MemoryError: \(message)"
        case .floatingPointError(let message):
            return "FloatingPointError: \(message)"
        case .assertionError(let message):
            return "AssertionError: \(message)"
        }
    }
}
