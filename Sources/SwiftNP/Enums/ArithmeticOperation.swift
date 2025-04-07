//
//  ArithmeticOperation.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

/// An enumeration representing arithmetic operations that can be performed on matrices (NDArray).
internal enum ArithmeticOperation: Codable, CaseIterable {
    
    /// Represents the addition operation between two NDArray instances.
    case addition
    
    /// Represents the subtraction operation between two NDArray instances.
    case subtraction
    
    /// Represents the multiplication operation between two NDArray instances.
    case multiplication
    
    /// Represents the division operation between two NDArray instances.
    case division
}
