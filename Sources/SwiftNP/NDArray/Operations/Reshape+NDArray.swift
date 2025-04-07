//
//  Reshape+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

public extension NDArray {
    /// Reshapes the NDArray to the specified shape and order.
    ///
    /// - Parameters:
    ///   - shape: The desired shape of the reshaped NDArray.
    ///   - order: The order in which the array should be reshaped, either C-style or Fortran-style.
    /// - Returns: An NDArray reshaped to the specified dimensions.
    /// - Throws: `SNPError` if there are issues with dimensions or if the reshape cannot be performed.
    func reshape(to shape: Shape, order: ReshapeOrder) throws(SNPError) -> NDArray { try SwiftNP.backend.reshape(self, to: shape, order: order) }
}
