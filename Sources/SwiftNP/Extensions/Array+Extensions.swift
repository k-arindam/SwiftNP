//
//  Array+Extensions.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 10/10/24.
//

import Foundation

/// An extension to the Array type that adds a computed property to check if all elements are of the same type.
public extension Array {
    
    /// A Boolean property that indicates whether all elements in the array are of the same type.
    ///
    /// - Returns: `true` if the array is empty or if all elements are of the same type; otherwise, `false`.
    ///
    /// Example:
    ///     let homogeneousArray: [Any] = [1, 2, 3]
    ///     let isHomogeneous = homogeneousArray.isHomogeneous // true
    ///
    ///     let heterogeneousArray: [Any] = [1, "two", 3.0]
    ///     let isHeterogeneous = heterogeneousArray.isHomogeneous // false
    var isHomogeneous: Bool {
        guard let firstElement = self.first else {
            return true // An empty array is considered homogeneous
        }
        
        let expectedType = type(of: firstElement) // Get the type of the first element
        
        // Check if all elements are of the same type as the first element
        return self.allSatisfy { element in type(of: element) == expectedType }
    }
}
