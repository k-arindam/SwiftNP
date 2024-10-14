//
//  MLMultiArrayDataTypeExtension.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 14/10/24.
//

import Foundation
import CoreML

public extension MLMultiArrayDataType {
    /// Converts an MLMultiArrayDataType to a corresponding DType.
    /// - Returns: The DType that corresponds to this MLMultiArrayDataType.
    var dtype: DType {
        switch self {
        case .int32:
            return .int32  // Maps MLMultiArrayDataType.int32 to DType.int32
        case .float:
            return .float64  // Maps MLMultiArrayDataType.float to DType.float64
        case .float16:
            return .float16  // Maps MLMultiArrayDataType.float16 to DType.float16
        case .float32:
            return .float32  // Maps MLMultiArrayDataType.float32 to DType.float32
        case .float64:
            return .float64  // Maps MLMultiArrayDataType.float64 to DType.float64
        case .double:
            return .double  // Maps MLMultiArrayDataType.double to DType.double
        @unknown default:
            return .float64  // Fallback for unknown types; defaults to DType.float64
        }
    }
}
