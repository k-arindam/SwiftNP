//
//  MLMultiArray+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation
import CoreML

public extension MLMultiArray {
    /// Converts the MLMultiArray to an NDArray.
    /// - Throws: SNPError if the conversion fails.
    var toNDArray: any NDArray {
        get throws(SNPError) {
            try NDArrayImpl.from(self)  // Attempts to create an NDArray from this MLMultiArray.
        }
    }
    
    /// Creates an MLMultiArray from the given NDArray.
    /// - Parameter ndarray: The NDArray to convert.
    /// - Throws: SNPError if the conversion fails.
    static func from(ndarray: any NDArray) throws(SNPError) -> MLMultiArray {
        try ndarray.toMLMultiArray()  // Calls the NDArray method to perform the conversion.
    }
}

public extension NDArrayImpl {
    /// Creates an NDArray from the given MLMultiArray.
    /// - Parameter mlMultiArray: The MLMultiArray to convert.
    /// - Throws: SNPError if the conversion fails.
    static func from(_ mlMultiArray: MLMultiArray) throws(SNPError) -> any NDArray {
        let dimensions = mlMultiArray.shape.map { $0.intValue }  // Extracts dimensions from the MLMultiArray.
        let dtype = mlMultiArray.dataType.dtype // Determine the DType from MLMultiArrayDataType
        
        // Recursively unpacks the MLMultiArray into a nested array structure.
        func recursivelyUnpack(dimensions: [Int], currentIndex: [Int] = []) throws -> Any {
            // Base case: if dimensions are empty, calculate the index and return the value.
            if dimensions.isEmpty {
                let index = currentIndex.enumerated().reduce(0) { (offset, element) in
                    offset + element.element * mlMultiArray.strides[element.offset].intValue
                }
                
                guard let value = dtype.cast(mlMultiArray[index]) else {
                    throw SNPError.otherError(.custom(key: "CreateUnsuccessful"))
                }
                
                return value  // Returns the value at the computed index.
            } else {
                // Recursive case: iterate over the first dimension.
                return try (0..<dimensions[0]).map { i in
                    try recursivelyUnpack(dimensions: Array(dimensions.dropFirst()),
                                      currentIndex: currentIndex + [i])
                }
            }
        }
        
        // Attempt to unpack the MLMultiArray; throw an error if unsuccessful.
        guard let array = try? recursivelyUnpack(dimensions: dimensions) as? [Any] else {
            throw SNPError.typeError(.custom(key: "UnknownDType"))  // Error for unknown data type.
        }
        
        return try NDArrayImpl(array: array)  // Create and return an NDArray from the unpacked array.
    }
    
    /// Converts the NDArray to an MLMultiArray.
    /// - Throws: SNPError if the conversion fails.
    func toMLMultiArray() throws(SNPError) -> MLMultiArray {
        let array = try self.rawData()  // Fetches raw data from the NDArray.
        
        let shape = Utils.inferShape(from: array)  // Infers the shape of the array.
        
        // Obtain the corresponding MLMultiArray data type for the NDArray dtype.
        guard let dataType = self.dtype.mlMultiArrayDataType else {
            throw SNPError.typeError(.custom(key: "UnknownDType"))  // Error for unknown data type.
        }
        
        do {
            // Create the MLMultiArray with the inferred shape and data type.
            let mlMultiArray = try MLMultiArray(shape: shape.map { NSNumber(value: $0) }, dataType: dataType)
            
            // Recursively fill the MLMultiArray with data from the NDArray.
            func fillMLMultiArray(_ arr: [Any], indexPrefix: [Int] = []) throws(SNPError) {
                for (i, element) in arr.enumerated() {
                    let currentIndex = indexPrefix + [i]  // Current index in the multi-dimensional array.
                    
                    // If the element is a sub-array, recurse into it.
                    if let subArray = element as? [Any] {
                        try fillMLMultiArray(subArray, indexPrefix: currentIndex)
                    } else {
                        // Calculate the flat index for the MLMultiArray.
                        let flatIndex = currentIndex.enumerated().reduce(0) { (offset, element) in
                            offset + element.element * mlMultiArray.strides[element.offset].intValue
                        }
                        
                        // Convert element to any Numeric.
                        guard let element = element as? any Numeric else {
                            throw SNPError.typeError(.custom(key: "UnknownDType"))
                        }
                        
                        // Store the value in the MLMultiArray based on its type.
                        mlMultiArray[flatIndex] = element.nsnumber
                    }
                }
            }
            
            try fillMLMultiArray(array)  // Populate the MLMultiArray with data.
            return mlMultiArray  // Return the populated MLMultiArray.
        } catch let error as SNPError {
            throw error
        } catch {
            throw SNPError.otherError(.custom(key: "CreateUnsuccessful"))  // Error if creation fails.
        }
    }
}
