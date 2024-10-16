//
//  Transpose.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation

public extension NDArray {
    /// Transposes the NDArray according to the specified axes.
    /// If no axes are provided, it reverses the order of the axes by default.
    /// The function can throw errors related to shape mismatches or invalid axes.
    ///
    /// - Parameter axes: An optional array of integers that specifies the new order of the axes.
    ///                   If nil, the axes will be reversed.
    /// - Returns: A new NDArray that is the transposed version of the original array.
    /// - Throws: `SNPError` if the axes length does not match the shape or if invalid axes are provided.
    func transpose(axes: [Int]? = nil) throws -> NDArray {
        
        // If the NDArray has one or fewer dimensions, return it as is since there's no need to transpose.
        if self.shape.count <= 1 {
            return self
        }
        
        // If axes are not provided, default to reversing the order of the axes.
        let axes = axes ?? Array((0..<shape.count).reversed())
        
        // Ensure the number of axes matches the number of dimensions in the shape.
        guard axes.count == shape.count else {
            throw SNPError.shapeError(.custom(key: "InequalAxesShape"))
        }
        
        // Sort the axes to check for duplicates or invalid indices.
        let sortedAxes = axes.sorted()
        for (index, value) in sortedAxes.enumerated() {
            // Ensure that the sorted axes are in the valid range [0, shape.count - 1].
            if value != index {
                throw SNPError.shapeError(.custom(key: "InvalidAxes", args: ["\(shape.count - 1)"]))
            }
        }
        
        // Reorders the shape by the axes permutation.
        let newShape = axes.map { shape[$0] }
        
        // Flatten the original data for easier manipulation during transposition.
        let flatMatrix = try flattenedData()
        
        // Compute the original and new strides for the respective shapes.
        let originalStrides = Utils.computeStrides(shape)
        let newStrides = Utils.computeStrides(newShape)
        
        // Rebuild the transposed matrix by mapping indices from the flattened data.
        func transposeRecursive(_ newShape: [Int], _ newStrides: [Int]) throws -> [Any] {
            // Initialize an array to hold the transposed matrix data.
            var transposedMatrix: [Any] = Array(repeating: 0.0, count: flatMatrix.count)
            
            // Map the indices from the new shape to the original flattened array.
            func mapIndex(_ index: Int, _ shape: [Int], _ strides: [Int]) -> Int {
                var remainder = index
                var originalIndex = 0
                
                // Compute the original index based on the transposed indices.
                for i in 0..<shape.count {
                    let quotient = remainder / strides[i]
                    remainder %= strides[i]
                    originalIndex += quotient * originalStrides[axes[i]]
                }
                return originalIndex
            }
            
            // Loop through each index in the flat matrix to build the transposed matrix.
            for i in 0..<flatMatrix.count {
                let originalIndex = mapIndex(i, newShape, newStrides)
                transposedMatrix[i] = flatMatrix[originalIndex] // Assign the value from the original flattened data.
            }
            
            // Reshape the transposed data back to the new shape and return it.
            return try Utils.reshapeFlatArray(transposedMatrix, to: newShape)
        }
        
        // Build the transposed matrix using the new shape and strides.
        let output = try transposeRecursive(newShape, newStrides)
        
        // Return a new NDArray created from the transposed output data.
        return try NDArray(array: output)
    }
}
