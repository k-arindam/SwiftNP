//
//  Arithmetic+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

public extension NDArray {
    /// Performs element-wise addition between two NDArrays.
    ///
    /// - Parameters:
    ///   - other: Another NDArray to be added to the current NDArray.
    /// - Throws: SNPError if the shapes are not compatible for broadcasting or other errors occur.
    /// - Returns: A new NDArray containing the result of the element-wise addition.
    func add(_ other: NDArray) throws(SNPError) -> NDArray { try SwiftNP.backend.arithmeticOperation(lhs: self, rhs: other, ops: .addition) }
    
    /// Performs element-wise subtraction between two NDArrays.
    ///
    /// - Parameters:
    ///   - other: Another NDArray to be subtracted from the current NDArray.
    /// - Throws: SNPError if the shapes are not compatible for broadcasting or other errors occur.
    /// - Returns: A new NDArray containing the result of the element-wise subtraction.
    func subtract(_ other: NDArray) throws(SNPError) -> NDArray { try SwiftNP.backend.arithmeticOperation(lhs: self, rhs: other, ops: .subtraction) }
    
    /// Performs element-wise multiplication between two NDArrays.
    ///
    /// - Parameters:
    ///   - other: Another NDArray to multiply element-wise with the current NDArray.
    /// - Throws: SNPError if the shapes are not compatible for broadcasting or other errors occur.
    /// - Returns: A new NDArray containing the result of the element-wise multiplication.
    func multiply(_ other: NDArray) throws(SNPError) -> NDArray { try SwiftNP.backend.arithmeticOperation(lhs: self, rhs: other, ops: .multiplication) }
    
    /// Multiplies the current NDArray by a scalar value.
    ///
    /// - Parameters:
    ///   - scalar: A Double scalar value to multiply with all elements of the NDArray.
    /// - Throws: SNPError in case of shape errors or other operation failures.
    /// - Returns: A new NDArray where each element is multiplied by the scalar value.
    func multiply(by scalar: Double) throws(SNPError) -> NDArray { try SwiftNP.backend.scalarOperation(on: self, with: scalar, ops: .multiply) }
    
    /// Computes the dot product of the current NDArray with another NDArray.
    ///
    /// This function performs matrix multiplication if both operands are 2D arrays,
    /// or computes the dot product for 1D arrays. It also handles broadcasting
    /// for higher-dimensional arrays based on their shapes.
    ///
    /// - Parameter other: The NDArray to compute the dot product with.
    /// - Throws: An error of type SNPError if the shapes of the NDArrays are incompatible
    /// or if the operation fails.
    /// - Returns: A new NDArray representing the result of the dot product.
    func dot(_ other: NDArray) throws(SNPError) -> NDArray { try SwiftNP.backend.product(lhs: self, rhs: other) }
    
    /// Performs element-wise division between two NDArrays.
    ///
    /// - Parameter:
    ///   - other: Another NDArray to divide the current NDArray element-wise.
    /// - Throws: SNPError if the shapes are not compatible for broadcasting or other errors occur.
    /// - Returns: A new NDArray containing the result of the element-wise division.
    func divide(_ other: NDArray) throws(SNPError) -> NDArray { try SwiftNP.backend.arithmeticOperation(lhs: self, rhs: other, ops: .division) }
    
    /// Divides the current NDArray by a scalar value.
    ///
    /// - Parameters:
    ///   - scalar: A Double scalar value to divide each element of the NDArray.
    /// - Throws: SNPError in case of shape errors or other operation failures.
    /// - Returns: A new NDArray where each element is divided by the scalar value.
    func divide(by scalar: Double) throws(SNPError) -> NDArray { try SwiftNP.backend.scalarOperation(on: self, with: scalar, ops: .divide) }
}
