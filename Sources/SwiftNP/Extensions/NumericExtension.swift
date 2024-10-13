//
//  NumericExtension.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation

public extension Numeric {
    var nsnumber: NSNumber {
        switch self {
        case let intValue as Int:
            return NSNumber(value: intValue)
        case let int8Value as Int8:
            return NSNumber(value: int8Value)
        case let int16Value as Int16:
            return NSNumber(value: int16Value)
        case let int32Value as Int32:
            return NSNumber(value: int32Value)
        case let int64Value as Int64:
            return NSNumber(value: int64Value)
        case let uintValue as UInt:
            return NSNumber(value: uintValue)
        case let uint8Value as UInt8:
            return NSNumber(value: uint8Value)
        case let uint16Value as UInt16:
            return NSNumber(value: uint16Value)
        case let uint32Value as UInt32:
            return NSNumber(value: uint32Value)
        case let uint64Value as UInt64:
            return NSNumber(value: uint64Value)
        case let floatValue as Float:
            return NSNumber(value: floatValue)
        case let floatValue as Float16:
            return NSNumber(value: Float(exactly: floatValue)!)
        case let floatValue as Float32:
            return NSNumber(value: floatValue)
        case let floatValue as Float64:
            return NSNumber(value: floatValue)
        case let doubleValue as Double:
            return NSNumber(value: doubleValue)
        default:
            fatalError("Unsupported numeric type")
        }
    }
}
