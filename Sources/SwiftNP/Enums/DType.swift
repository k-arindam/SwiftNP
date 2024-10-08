//
//  DType.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

public enum DType: CaseIterable {
    case int8
    case int16
    case int32
    case int64
    case uint8
    case uint16
    case uint32
    case uint64
    case float16
    case float32
    case float64
    case double
    
    public var type: any Numeric.Type {
        switch self {
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
    
    public static func typeOf(_ input: any Numeric) -> DType? {
        switch input {
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
    
    public func cast(_ value: NSNumber) -> (any Numeric)? {
        switch self {
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
