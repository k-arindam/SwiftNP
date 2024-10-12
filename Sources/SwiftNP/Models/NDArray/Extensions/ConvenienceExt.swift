//
//  File.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 11/10/24.
//

import Foundation

extension NDArray {
    
    /// Initializes an NDArray with a specified shape, data type, and default value.
    ///
    /// - Parameters:
    ///   - shape: An array of integers defining the shape of the NDArray.
    ///   - dtype: The data type of the elements in the NDArray (default is .float64).
    ///   - defaultValue: The value to fill the NDArray with.
    /// - Precondition: All dimensions in the shape must be non-negative.
    public convenience init(shape: [Int], dtype: DType = .float64, defaultValue: NSNumber) {
        // Ensure all dimensions in the shape are non-negative
        shape.forEach { precondition($0 >= 0, "Shape cannot be negative") }
        
        // Attempt to cast the default value to the specified data type
        guard let castedValue = dtype.cast(defaultValue) else {
            fatalError("Invalid default value")
        }
        
        var tmpArray: NDArray? = nil
        
        // Create a nested NDArray structure based on the specified shape
        for dim in shape.reversed() {
            if tmpArray != nil {
                tmpArray = NDArray(repeating: tmpArray!, count: dim, dtype: dtype)
            } else {
                tmpArray = NDArray(repeating: castedValue, count: dim)
            }
        }
        
        // Ensure the temporary array was created successfully
        guard let array = tmpArray else { fatalError("Unable to create array") }
        
        // Initialize the NDArray with the shape and data from the temporary array
        self.init(shape: array.shape, dtype: array.dtype, data: array.data)
    }
    
    /// Initializes an NDArray from a Swift array of any type.
    ///
    /// - Parameter array: A Swift array containing elements of any type (e.g., Int, Float, etc.).
    /// - Precondition: The shape inferred from the array must match the number of elements.
    /// - Throws: `SNPError.indexError` if the array is empty, `SNPError.shapeError` if the array has an inhomogeneous shape, and `SNPError.assertionError` if dtype cannot be determined.
    /// - Fatal error: Will occur if the array is empty or dtype cannot be determined, preventing initialization.
    internal convenience init(array: [Any]) throws(SNPError) {
        
        // Ensure the array is not empty. If it is, throw an index error.
        guard !array.isEmpty else {
            throw SNPError.indexError("The requested array is empty.")
        }
        
        // Infer the shape of the array. This ensures that the array conforms to a specific dimensional structure.
        let inferredShape = Utils.inferShape(from: array)
        
        // Flatten the multi-dimensional array into a single-dimensional array for easier manipulation.
        let flattenedArray = Utils.flatten(array)
        
        // Check if the array conforms to the inferred shape. If not, throw a shape error.
        guard Utils.conformsToShape(array: array, shape: inferredShape) else {
            throw SNPError.shapeError("The requested array has an inhomogeneous shape. The detected shape was \(inferredShape).")
        }
        
        // Automatically detect the data type (dtype) based on the first element of the flattened array.
        // Assuming a homogeneous array, all elements should have the same type as the first.
        guard let firstElement = flattenedArray.first as? any Numeric else {
            throw SNPError.assertionError("Array is empty. Cannot determine dtype.")
        }
        
        // Use the first element to determine the dtype. If the dtype cannot be determined, throw an error.
        guard let dtype = DType.typeOf(firstElement) else {
            throw SNPError.assertionError("Could not determine dtype from array elements.")
        }
        
        // Initialize the NDArray with the inferred shape, detected dtype, and original array data.
        self.init(shape: inferredShape, dtype: dtype, data: array)
    }
    
    /// Initializes an NDArray by repeating a value a specified number of times.
    ///
    /// - Parameters:
    ///   - repeating: The value to be repeated (can be any type or NDArray).
    ///   - count: The number of times to repeat the value.
    ///   - dtype: The data type of the elements in the NDArray.
    internal convenience init(repeating: Any, count: Int, dtype: DType) {
        var shape = [count]
        
        // Determine the shape based on the type of the repeating value
        if let repeatingItem = repeating as? NDArray {
            shape.append(contentsOf: repeatingItem.shape)
        } else if let repeatingArray = repeating as? [NDArray] {
            shape.append(contentsOf: repeatingArray.first!.shape)
        }
        
        // Create an array of repeated values
        let data = Array(repeating: repeating, count: count)
        
        // Initialize the NDArray with the computed shape and data
        self.init(shape: shape, dtype: dtype, data: data)
    }
    
    /// Initializes an NDArray by repeating a numeric value a specified number of times.
    ///
    /// - Parameters:
    ///   - repeating: The numeric value to be repeated.
    ///   - count: The number of times to repeat the value.
    /// - Fatal error: Will occur if dtype cannot be determined from the repeating value.
    private convenience init(repeating: any Numeric, count: Int) {
        // Determine the data type of the repeating value
        guard let dtype = DType.typeOf(repeating) else { fatalError("Invalid input value") }
        
        // Create an array of repeated numeric values
        let data = Array(repeating: repeating, count: count)
        
        // Initialize the NDArray with the shape and data
        self.init(shape: [count], dtype: dtype, data: data)
    }
}
