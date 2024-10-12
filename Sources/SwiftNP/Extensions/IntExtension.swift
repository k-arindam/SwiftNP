//
//  IntExtension.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation

public extension Int {
    
    /// A computed property that checks if the integer is non-negative.
    ///
    /// - Returns: A Boolean value indicating whether the integer is finite (non-negative).
    /// - Example:
    ///     let number = 5
    ///     print(number.isFinite) // Prints: true
    var isFinite: Bool {
        return self >= 0 // Returns true if the integer is non-negative, false otherwise
    }
}
