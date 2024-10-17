//
//  NDArrayExtension.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 18/10/24.
//

import Foundation

public extension NDArray {
    /// Reshapes the NDArray to the specified shape and order (default is C-style order).
    ///
    /// - Parameters:
    ///   - shape: The desired shape of the reshaped NDArray.
    /// - Returns: An NDArray reshaped to the specified dimensions.
    /// - Throws: `SNPError` if there are issues with dimensions or if the reshape cannot be performed.
    func reshape(to shape: Shape) throws(SNPError) -> any NDArray { try reshape(to: shape, order: .c) }
    
    /// Transposes the NDArray according to the specified axes.
    /// It reverses the order of the axes by default.
    /// The function can throw errors related to shape mismatches or invalid axes.
    ///
    /// - Returns: A new NDArray that is the transposed version of the original array.
    /// - Throws: `SNPError` if the axes length does not match the shape or if invalid axes are provided.
    func transpose() throws(SNPError) -> any NDArray { try transpose(axes: nil) }
}
