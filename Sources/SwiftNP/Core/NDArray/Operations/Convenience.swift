//
//  Convenience.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 11/10/24.
//

import Foundation

extension NDArray {
    
    /// Initializes an NDArray with a specified shape, data type, and default value.
    ///
    /// - Parameters:
    ///   - shape: An array of integers defining the dimensions of the NDArray (e.g., [2, 3] for a 2x3 matrix).
    ///   - dtype: The data type of the elements in the NDArray (default is .float64).
    ///   - defaultValue: The value used to fill the NDArray (of type NSNumber).
    /// - Throws: `SNPError.valueError` if any dimension is negative, `SNPError.typeError` if the default value cannot be cast to the specified dtype, and `SNPError.assertionError` if the temporary array creation fails.
    public convenience init(shape: [Int], dtype: DType = .float64, defaultValue: NSNumber) throws(SNPError) {
        
        // Ensure all dimensions in the shape are non-negative. If any are negative, throw a value error.
        guard shape.allSatisfy(\.isFinite) else {
            throw SNPError.valueError(.custom(key: "NegativeDim"))
        }
        
        // Attempt to cast the default value to the specified data type. If casting fails, throw a type error.
        guard let castedValue = dtype.cast(defaultValue) else {
            throw SNPError.typeError(.custom(key: "UnknownDType"))
        }
        
        var tmpArray: NDArray? = nil
        
        // Create a nested NDArray structure based on the specified shape, starting from the innermost dimension.
        for dim in shape.reversed() {
            if tmpArray != nil {
                // If the temporary array already exists, repeat it for the current dimension.
                tmpArray = NDArray(repeating: tmpArray!, count: dim, dtype: dtype)
            } else {
                // If it's the first dimension, create the NDArray filled with the casted default value.
                tmpArray = try NDArray(repeating: castedValue, count: dim)
            }
        }
        
        // Ensure the temporary array was created successfully; if not, throw an assertion error.
        guard let array = tmpArray else {
            throw SNPError.assertionError(.custom(key: "CreateUnsuccessful"))
        }
        
        // Initialize the NDArray with the shape and data from the successfully created temporary array.
        self.init(shape: array.shape, dtype: array.dtype, data: array.data)
    }
    
    /// Initializes an NDArray from a Swift array of any type.
    ///
    /// - Parameter array: A Swift array containing elements of any type (e.g., Int, Float, etc.).
    /// - Throws: `SNPError.indexError` if the array is empty,
    ///           `SNPError.shapeError` if the array has an inhomogeneous shape,
    ///           and `SNPError.assertionError` if dtype cannot be determined.
    internal convenience init(array: [Any], contentType: ContentType = .unknown) throws(SNPError) {
        
        // Ensure the array is not empty. If it is, throw an index error.
        guard !array.isEmpty else {
            throw SNPError.indexError(.custom(key: "EmptyArray"))
        }
        
        // Infer the shape of the array. This ensures that the array conforms to a specific dimensional structure.
        let inferredShape = Utils.inferShape(from: array)
        
        // Flatten the multi-dimensional array into a single-dimensional array for easier manipulation.
        let flattenedArray = Utils.flatten(array)
        
        // Check if the array conforms to the inferred shape. If not, throw a shape error.
        guard Utils.conformsToShape(array: array, shape: inferredShape) else {
            throw SNPError.shapeError(.custom(key: "InhomogeneousShape", args: [inferredShape]))
        }
        
        // Automatically detect the data type (dtype) based on the first element of the flattened array.
        // Assuming a homogeneous array, all elements should have the same type as the first.
        guard let firstElement = flattenedArray.first as? any Numeric else {
            throw SNPError.assertionError(.custom(key: "EmptyArray"))
        }
        
        // Use the first element to determine the dtype. If the dtype cannot be determined, throw an error.
        guard let dtype = DType.typeOf(firstElement) else {
            throw SNPError.typeError(.custom(key: "UnknownDType"))
        }
        
        // A recursive function to map the original array to the appropriate NDArray format.
        func map(array: [Any]) throws(SNPError) -> Any {
            // Handle one-dimensional arrays of numeric values
            if let array = array as? [any Numeric] {
                return NDArray(shape: [array.count], dtype: dtype, data: array)
            }
            // Handle two-dimensional arrays
            else if let array = array as? [[Any]] {
                do {
                    let inferredShape = Utils.inferShape(from: array) // Re-infer shape for nested arrays
                    return NDArray(shape: inferredShape, dtype: dtype, data: try array.map { try map(array: $0) })
                } catch {
                    throw SNPError.typeError(.custom(key: "UnknownDType"))
                }
            }
            // If the input type is unsupported, throw an error
            else {
                throw SNPError.typeError(.custom(key: "UnknownDType"))
            }
        }
        
        // Initialize the NDArray with the inferred shape, detected dtype, and original array data.
        if let ndarray = try map(array: array) as? NDArray {
            self.init(shape: inferredShape, dtype: dtype, data: ndarray.data, contentType: contentType)
        } else {
            throw SNPError.assertionError(.custom(key: "CreateUnsuccessful"))
        }
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
    ///   - repeating: A numeric value (e.g., Int, Float, etc.) that will be repeated to fill the NDArray.
    ///   - count: The number of times to repeat the numeric value in the NDArray.
    /// - Throws: `SNPError.typeError` if the dtype cannot be determined from the repeating value.
    private convenience init(repeating: any Numeric, count: Int) throws(SNPError) {
        
        // Determine the data type (dtype) of the repeating value. If dtype can't be determined, throw a type error.
        guard let dtype = DType.typeOf(repeating) else {
            throw SNPError.typeError(.custom(key: "UnknownDType"))
        }
        
        // Create an array filled with the repeating value, repeated 'count' times.
        let data = Array(repeating: repeating, count: count)
        
        // Initialize the NDArray with the shape of [count] (1D) and the created data.
        self.init(shape: [count], dtype: dtype, data: data)
    }
}
