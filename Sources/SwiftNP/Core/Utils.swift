//
//  Utils.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

/// A utility class that provides helper functions and methods for the SwiftNP framework.
/// This class is declared as public and final, meaning it cannot be subclassed and is accessible from outside its defining module.
public final class Utils {
    /// Infers the shape of a nested array structure.
    ///
    /// - Parameter array: An array that can contain elements of any type, potentially including nested arrays.
    /// - Returns: A `Shape` object representing the dimensions of the nested array.
    ///            Each entry in the shape corresponds to the count of elements in each nested level.
    ///
    /// Example:
    ///     let nestedArray: [Any] = [[1, 2], [3, 4, 5]]
    ///     let result = inferShape(from: nestedArray)  // result could represent a shape like [2, 3]
    ///
    /// - Complexity: O(d), where d is the depth of the nested structure.
    public static func inferShape<T>(from array: [T]) -> Shape {
        var shape = Shape() // Initialize a Shape object to store dimensions
        
        var currentArray: Any = array // Start with the input array
        
        // Traverse the nested arrays until there are no more nested arrays
        while let array = currentArray as? [Any] {
            shape.append(array.count) // Append the count of elements at the current level
            currentArray = array.first ?? [] // Move to the first element for the next level
        }
        
        return shape // Return the inferred shape
    }
    
    /// Flattens a nested array into a single-dimensional array.
    ///
    /// - Parameter array: An array that can contain elements of any type, including nested arrays.
    /// - Returns: A flattened array containing all elements from the nested structure,
    ///            with types preserved as `Any`.
    ///
    /// Example:
    ///     let nestedArray: [Any] = [1, [2, 3], [4, [5, 6]]]
    ///     let result = flatten(nestedArray)  // result will be [1, 2, 3, 4, 5, 6]
    ///
    /// - Complexity: O(n), where n is the total number of elements across all nested arrays.
    public static func flatten<T>(_ array: [T]) -> [Any] {
        var flattened = [Any]() // Initialize an empty array to hold flattened elements
        
        for element in array {
            // Check if the current element is a nested array
            if let nestedArray = element as? [Any] {
                // Recursively flatten the nested array and append its contents
                flattened.append(contentsOf: flatten(nestedArray))
            } else {
                // If it's not a nested array, append the element directly
                flattened.append(element)
            }
        }
        
        return flattened // Return the flattened array
    }
    
    /// Checks if the given array conforms to the specified shape.
    ///
    /// - Parameter array: An array of `Any` type, which may contain nested arrays.
    /// - Parameter shape: A `Shape` object representing the expected dimensions of the array.
    /// - Returns: A Boolean value indicating whether the array conforms to the specified shape.
    ///
    /// Example:
    ///     let array: [Any] = [[1, 2], [3, 4]]
    ///     let shape = Shape([2, 2])
    ///     let result = conformsToShape(array: array, shape: shape)  // result will be true
    ///
    /// - Complexity: O(n), where n is the total number of elements in the array.
    public static func conformsToShape(array: [Any], shape: Shape) -> Bool {
        // Helper function to recursively check if the array conforms to the given shape at each level
        func verifyShape(_ array: Any, shape: [Int], level: Int = 0) -> Bool {
            if level >= shape.count {
                // If we've reached the end of the shape definition, check if it's a scalar (non-array value)
                return !(array is [Any])
            }
            
            guard let currentArray = array as? [Any], currentArray.count == shape[level] else {
                // Check if the array at this level matches the expected size from the shape
                return false
            }
            
            // Recursively check for the next level of nesting
            for subArray in currentArray {
                if !verifyShape(subArray, shape: shape, level: level + 1) {
                    return false // Return false if any sub-array does not conform
                }
            }
            
            return true // Return true if the current array conforms to the shape
        }
        
        // Check if the entire array conforms to the given shape starting from level 0
        return verifyShape(array, shape: shape)
    }
    
}
