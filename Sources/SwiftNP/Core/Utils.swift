//
//  Utils.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

/// A utility class that provides helper functions and methods for the SwiftNP framework.
/// This class is declared as internal and final, meaning it cannot be subclassed and is not accessible from outside its defining module.
internal final class Utils {
    /// This function checks if a given value is an atomic (non-collection) value.
    /// An atomic value is a value that is not an array (e.g., an integer, string, or other single object).
    ///
    /// - Parameter value: A value of any type (`Any`) to be checked.
    /// - Returns: `true` if the value is not an array (atomic), `false` if it is an array (non-atomic).
    internal static func isAtomicValue(_ value: Any) -> Bool {
        
        // Check if the value is NOT an array (i.e., not a collection of elements).
        // If the value is not an array, it is considered atomic, hence return true.
        // If the value is an array, return false.
        return !(value is [Any])
    }
    
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
    internal static func inferShape<T>(from array: [T]) -> Shape {
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
    internal static func flatten<T>(_ array: [T]) -> [Any] {
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
    internal static func conformsToShape(array: [Any], shape: Shape) -> Bool {
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
    
    /// Compares two arrays (or nested arrays) for equality.
    ///
    /// - Parameters:
    ///   - array1: The first array or element to compare.
    ///   - array2: The second array or element to compare.
    /// - Returns: A boolean indicating whether the two arrays (or elements) are equal.
    ///
    /// This function checks if both inputs are of the same type.
    /// If both are arrays, it compares their counts and recursively compares their elements.
    /// If they are not arrays, it compares their string representations for equality.
    internal static func equalArray(_ array1: Any, _ array2: Any) -> Bool {
        // Check if both are of the same type
        guard type(of: array1) == type(of: array2) else {
            return false
        }
        
        if let array1 = array1 as? [Any], let array2 = array2 as? [Any] {
            // If both are arrays, compare their counts
            guard array1.count == array2.count else {
                return false
            }
            
            // Compare each element
            for (element1, element2) in zip(array1, array2) {
                if !equalArray(element1, element2) {
                    return false
                }
            }
            
            return true
        }
        
        // If they are not arrays, compare them directly
        return "\(array1)" == "\(array2)"
    }
    
    /// This function computes the strides for a given shape array.
    /// Strides define how much you need to move in memory to go to the next element in each dimension.
    /// In a multi-dimensional array, strides help calculate the offset for each dimension.
    ///
    /// - Parameter shape: An array of integers representing the shape of a multi-dimensional array.
    ///                    Each element in `shape` represents the size of that dimension.
    /// - Returns: An array of strides where each element tells the step size needed to move to the next element in that dimension.
    internal static func computeStrides(_ shape: [Int]) -> [Int] {
        
        // Initialize an array of strides with 1, where each index corresponds to a dimension in the shape.
        var strides = [Int](repeating: 1, count: shape.count)
        
        // Iterate over the shape in reverse order, excluding the last element.
        // The stride for each dimension is calculated based on the stride of the next dimension multiplied by its size.
        for i in (0..<shape.count - 1).reversed() {
            strides[i] = strides[i + 1] * shape[i + 1]  // Calculate the stride for the current dimension.
        }
        
        // Return the computed strides array.
        return strides
    }
    
    /// This function reshapes a flat array into a nested array structure based on the specified shape.
    /// The shape represents the desired dimensions of the array after reshaping.
    /// It recursively divides the array into smaller subarrays based on the provided shape.
    ///
    /// - Parameters:
    ///   - array: The flat input array that needs to be reshaped.
    ///   - shape: A `Shape` (typically an array of integers) that specifies the target dimensions of the reshaped array.
    /// - Returns: A reshaped array with the specified dimensions. If the shape has only one dimension, it returns the array as is.
    /// - Throws: `SNPError` if the input array is not flat or if it contains nested arrays.
    internal static func reshapeFlatArray(_ array: [Any], to shape: Shape) throws(SNPError) -> [Any] {
        
        // If the target shape has only one dimension, return the array as it is since no reshaping is needed.
        if shape.count == 1 {
            return array
        }
        
        // Ensure the array is homogeneous and does not contain nested arrays.
        guard array.isHomogeneous, !(array.first is [Any]) else {
            // Throw a value error if the array is not flat.
            throw SNPError.valueError(.custom(key: "NotFlat"))
        }
        
        // Calculate the size of the outer dimension (first dimension) in the shape.
        let outerSize = shape[0]
        
        // Calculate the inner shape by dropping the first dimension from the shape.
        // This will represent the remaining dimensions for the recursive calls.
        let innerShape = Array(shape.dropFirst())
        
        // Calculate the total size of the inner dimensions by multiplying all dimensions in the inner shape.
        let innerSize = innerShape.reduce(1, *)  // Multiply all inner dimensions to get the size of each subarray.
        
        // Initialize an empty array to hold the reshaped array.
        var reshapedArray: [Any] = []
        
        // Loop over the outer size and partition the flat array into subarrays according to the inner size.
        for i in 0..<outerSize {
            let start = i * innerSize       // Calculate the starting index for the current subarray.
            let end = start + innerSize     // Calculate the ending index for the current subarray.
            
            // Extract the subarray for the current dimension from the input array.
            let subArray = Array(array[start..<end])
            
            // Recursively reshape the subarray according to the remaining dimensions (inner shape).
            reshapedArray.append(try reshapeFlatArray(subArray, to: innerShape))
        }
        
        // Return the fully reshaped array.
        return reshapedArray
    }

}
