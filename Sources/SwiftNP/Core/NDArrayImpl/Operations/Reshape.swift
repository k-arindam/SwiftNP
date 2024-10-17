//
//  Reshape.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation

public extension NDArrayImpl {
    /// Reshapes the NDArray to the specified shape and order.
    ///
    /// - Parameters:
    ///   - shape: The desired shape of the reshaped NDArray.
    ///   - order: The order in which the array should be reshaped, either C-style or Fortran-style.
    /// - Returns: An NDArray reshaped to the specified dimensions.
    /// - Throws: `SNPError` if there are issues with dimensions or if the reshape cannot be performed.
    func reshape(to shape: Shape, order: ReshapeOrder) throws(SNPError) -> any NDArray {
        // Ensure all dimensions in the new shape are non-negative
        guard shape.allSatisfy(\.isFinite) else {
            throw SNPError.valueError(.custom(key: "NegativeDim"))
        }
        
        // Flatten the current data for easy reshaping
        let flattenedArray = try self.flattenedData()
        let totalSize = shape.reduce(1, *) // Calculate the total size of the new shape
        
        // Check if the total size matches the number of elements in the flattened array
        guard totalSize == flattenedArray.count else {
            throw SNPError.shapeError(.custom(key: "ReshapeArraySizeMismatch", args: ["\(flattenedArray.count)", "\(shape)"]))
        }
        
        // Handle the case for a one-dimensional shape
        if shape.count == 1 {
            return NDArrayImpl(shape: shape, dtype: self.dtype, data: flattenedArray)
        }
        
        var reshapedArray = [Any]() // Array to hold the reshaped data
        
        /// Recursive function for reshaping in C-style order.
        ///
        /// - Parameters:
        ///   - currentDimension: The current dimension being processed.
        ///   - currentIndex: A reference to the current index in the flattened array.
        ///   - currentArray: The array to which reshaped elements are added.
        func reshapeRecursiveC(currentDimension: Int, currentIndex: inout Int, currentArray: inout [Any]) {
            // Base case: if at the last dimension, fill it with elements
            if currentDimension == shape.count - 1 {
                for _ in 0..<shape[currentDimension] {
                    currentArray.append(flattenedArray[currentIndex])
                    currentIndex += 1 // Move to the next index in the flattened array
                }
            } else {
                // Recursive case: create sub-arrays for the next dimension
                for _ in 0..<shape[currentDimension] {
                    var subArray = [Any]()
                    reshapeRecursiveC(currentDimension: currentDimension + 1, currentIndex: &currentIndex, currentArray: &subArray)
                    currentArray.append(subArray) // Append the constructed sub-array
                }
            }
        }
        
        /// Recursive function for reshaping in Fortran-style order.
        ///
        /// - Parameters:
        ///   - currentDimension: The current dimension being processed.
        ///   - indices: An array holding the current indices for each dimension.
        ///   - currentArray: The array to which reshaped elements are added.
        func reshapeRecursiveF(currentDimension: Int, indices: inout [Int], currentArray: inout [Any]) {
            // Base case: if at the last dimension, calculate and fill it with elements
            if currentDimension == shape.count - 1 {
                for i in 0..<shape[currentDimension] {
                    indices[currentDimension] = i // Set the current index
                    let flatIndex = indices.enumerated().reduce(0) { $0 + $1.1 * (0..<$1.0).reduce(1) { $0 * shape[$1] } }
                    currentArray.append(flattenedArray[flatIndex]) // Append element at calculated flat index
                }
            } else {
                // Recursive case: create sub-arrays for the next dimension
                for i in 0..<shape[currentDimension] {
                    indices[currentDimension] = i // Set the current index
                    var subArray = [Any]()
                    reshapeRecursiveF(currentDimension: currentDimension + 1, indices: &indices, currentArray: &subArray)
                    currentArray.append(subArray) // Append the constructed sub-array
                }
            }
        }
        
        // Perform reshaping based on the specified order
        switch order {
        case .c:
            var index = 0
            reshapeRecursiveC(currentDimension: 0, currentIndex: &index, currentArray: &reshapedArray) // C-style reshaping
        case .f:
            var indices = [Int](repeating: 0, count: shape.count)
            reshapeRecursiveF(currentDimension: 0, indices: &indices, currentArray: &reshapedArray) // Fortran-style reshaping
        }
        
        // Return the reshaped NDArray
        return try NDArrayImpl(array: reshapedArray)
    }
}
