//
//  SNPError.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 09/10/24.
//

import Foundation

/// An enumeration representing various error types for the SwiftNP framework.
/// This conforms to the Error protocol and provides custom descriptions for error handling.
public enum SNPError: Error, CustomStringConvertible {
    case shapeError(String)         // Error for shape-related issues
    case typeError(String)          // Error for type-related issues
    case valueError(String)         // Error for invalid value inputs
    case indexError(String)         // Error for index out of bounds
    case memoryError(String)        // Error related to memory allocation or access
    case floatingPointError(String) // Error for floating point precision issues
    case assertionError(String)     // Error for assertion failures
    case otherError(String)         // Error for all other types of error
    case unimplementedError         // Error for unimplemented methods
    
    /// A textual description of the error, used for logging and debugging.
    public var description: String {
        switch self {
        case .shapeError(let message):
            return "ShapeError: \(message)"         // Describes shape-related errors
        case .typeError(let message):
            return "TypeError: \(message)"          // Describes type-related errors
        case .valueError(let message):
            return "ValueError: \(message)"         // Describes invalid value errors
        case .indexError(let message):
            return "IndexError: \(message)"         // Describes index-related errors
        case .memoryError(let message):
            return "MemoryError: \(message)"        // Describes memory-related errors
        case .floatingPointError(let message):
            return "FloatingPointError: \(message)" // Describes floating point errors
        case .assertionError(let message):
            return "AssertionError: \(message)"     // Describes assertion errors
        case .otherError(let message):
            return "OtherError: \(message)"         // Describes other errors
        case .unimplementedError:
            return "UnimplementedError: this method is not implemented yet. Please file an issue on GitHub."
        }
    }
}

