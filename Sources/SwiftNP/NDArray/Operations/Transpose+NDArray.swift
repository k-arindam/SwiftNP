//
//  Transpose+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
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
    func transpose(axes: Axes?) throws(SNPError) -> NDArray { try SwiftNP.backend.transpose(self, axes: axes) }
}
