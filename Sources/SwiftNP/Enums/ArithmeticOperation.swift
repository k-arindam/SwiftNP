//
//  ArithmeticOperation.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 14/10/24.
//

import Foundation

/// An enumeration representing arithmetic operations that can be performed on matrices (NDArray).
internal enum ArithmeticOperation: MatrixOperation, Codable, CaseIterable {
    
    /// Represents the addition operation between two NDArray instances.
    case addition
    
    /// Represents the subtraction operation between two NDArray instances.
    case subtraction
}
