//
//  SNPError.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 09/10/24.
//

import Foundation

/// An enumeration representing various error types for the SwiftNP framework.
/// This conforms to the Error protocol and provides custom descriptions for error handling.
public enum SNPError: Error, Sendable, CustomStringConvertible {
    case shapeError(messageKey: String.LocalizationValue)         // Error for shape-related issues
    case typeError(messageKey: String.LocalizationValue)          // Error for type-related issues
    case valueError(messageKey: String.LocalizationValue)         // Error for invalid value inputs
    case indexError(messageKey: String.LocalizationValue)         // Error for index out of bounds
    case memoryError(messageKey: String.LocalizationValue)        // Error related to memory allocation or access
    case floatingPointError(messageKey: String.LocalizationValue) // Error for floating point precision issues
    case assertionError(messageKey: String.LocalizationValue)     // Error for assertion failures
    case otherError(messageKey: String.LocalizationValue)         // Error for all other types of error
    case unimplementedError                                       // Error for unimplemented methods
    
    /// A textual description of the error, used for logging and debugging.
    public var description: String {
        switch self {
        case .shapeError(let messageKey):
            return "ShapeError: \(String.custom(key: messageKey))"         // Describes shape-related errors
        case .typeError(let messageKey):
            return "TypeError: \(String.custom(key: messageKey))"          // Describes type-related errors
        case .valueError(let messageKey):
            return "ValueError: \(String.custom(key: messageKey))"         // Describes invalid value errors
        case .indexError(let messageKey):
            return "IndexError: \(String.custom(key: messageKey))"         // Describes index-related errors
        case .memoryError(let messageKey):
            return "MemoryError: \(String.custom(key: messageKey))"        // Describes memory-related errors
        case .floatingPointError(let messageKey):
            return "FloatingPointError: \(String.custom(key: messageKey))" // Describes floating point errors
        case .assertionError(let messageKey):
            return "AssertionError: \(String.custom(key: messageKey))"     // Describes assertion errors
        case .otherError(let messageKey):
            return "OtherError: \(String.custom(key: messageKey))"         // Describes other errors
        case .unimplementedError:
            return "UnimplementedError: this method is not implemented yet. Please file an issue on GitHub."
        }
    }
}
