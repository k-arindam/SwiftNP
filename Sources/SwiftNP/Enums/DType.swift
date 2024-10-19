//
//  DType.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

#if canImport(CoreML)
import CoreML
#endif

/// An enumeration representing different data types (DType) supported in SwiftNP.
/// Each case corresponds to a numeric type used for arrays and computations.
public enum DType: CaseIterable, Codable {
    case int       // Represents a 32-bit signed integer
    case int8      // Represents an 8-bit signed integer
    case int16     // Represents a 16-bit signed integer
    case int32     // Represents a 32-bit signed integer
    case int64     // Represents a 64-bit signed integer
    case uint8     // Represents an 8-bit unsigned integer
    case uint16    // Represents a 16-bit unsigned integer
    case uint32    // Represents a 32-bit unsigned integer
    case uint64    // Represents a 64-bit unsigned integer
    case float16   // Represents a 16-bit floating point
    case float32   // Represents a 32-bit floating point
    case float64   // Represents a 64-bit floating point
    case double    // Represents a double-precision floating point
    
    /// Returns the corresponding numeric type for the DType.
    /// - Returns: The type associated with the DType case.
    public var type: any Numeric.Type {
        switch self {
        case .int:     return Int.self
        case .int8:    return Int8.self
        case .int16:   return Int16.self
        case .int32:   return Int32.self
        case .int64:   return Int64.self
        case .uint8:   return UInt8.self
        case .uint16:  return UInt16.self
        case .uint32:  return UInt32.self
        case .uint64:  return UInt64.self
        case .float16: return Float16.self
        case .float32: return Float32.self
        case .float64: return Float64.self
        case .double:  return Double.self
        }
    }
    
    #if canImport(CoreML)
    /// A computed property that maps the DType to the corresponding MLMultiArrayDataType.
    /// This is useful for integrating with Core ML when converting NDArray data types.
    public var mlMultiArrayDataType: MLMultiArrayDataType? {
        switch self {
            // Map all integer types to int32 for compatibility.
        case .int, .int8, .int16, .int32:
            return .int32
            // For float16, check the iOS version and return the appropriate type.
        case .float16:
            if #available(iOS 16.0, *) {
                return .float16
            } else {
                return .float32  // Fallback to float32 for earlier iOS versions.
            }
            // Return float32 for the float32 DType.
        case .float32:
            return .float32
            // Return double for both float64 and double types.
        case .float64, .double:
            return .double
            // Return nil for unsupported types.
        default:
            return nil
        }
    }
    #endif
    
    /// Determines the DType of a given numeric input.
    /// - Parameter input: A numeric value of any type.
    /// - Returns: The corresponding DType, or nil if the input type is unsupported.
    public static func typeOf(_ input: any Numeric) -> DType? {
        switch input {
        case is Int:     return .int
        case is Int8:    return .int8
        case is Int16:   return .int16
        case is Int32:   return .int32
        case is Int64:   return .int64
        case is UInt8:   return .uint8
        case is UInt16:  return .uint16
        case is UInt32:  return .uint32
        case is UInt64:  return .uint64
        case is Float16: return .float16
        case is Float32: return .float32
        case is Float64: return .float64
        case is Double:  return .double
        default:         return nil
        }
    }
    
    /// Casts a NSNumber to the corresponding numeric type defined by the DType.
    /// - Parameter value: A NSNumber to be cast to the specified DType.
    /// - Returns: An optional value of the corresponding numeric type, or nil if casting fails.
    public func cast(_ value: NSNumber) -> (any Numeric)? {
        switch self {
        case .int:     return Int(exactly: value)
        case .int8:    return Int8(exactly: value)
        case .int16:   return Int16(exactly: value)
        case .int32:   return Int32(exactly: value)
        case .int64:   return Int64(exactly: value)
        case .uint8:   return UInt8(exactly: value)
        case .uint16:  return UInt16(exactly: value)
        case .uint32:  return UInt32(exactly: value)
        case .uint64:  return UInt64(exactly: value)
        case .float16: if let float = Float(exactly: value) { return Float16(exactly: float) } else { return nil }
        case .float32: return Float32(exactly: value)
        case .float64: return Float64(exactly: value)
        case .double:  return Double(exactly: value)
        }
    }
}
