//
//  NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 18/10/24.
//

import Foundation
import CoreML

#if canImport(UIKit)
import UIKit
#endif

/// A protocol defining the essential properties and methods for NDArray types.
///
/// This protocol outlines the fundamental characteristics and operations that any NDArray implementation should support,
/// including shape, data type, content type, and various mathematical operations.
public protocol NDArray: Equatable, CustomStringConvertible {
    
    /// The shape of the NDArray as an array of integers, representing the dimensions.
    var shape: Shape { get }
    
    /// The data type of the elements contained within the NDArray.
    var dtype: DType { get }
    
    /// The content type of the NDArray, indicating the kind of data it holds.
    var contentType: ContentType { get }
    
    /// The number of dimensions of the NDArray.
    var ndim: Int { get }
    
    /// The total number of elements in the NDArray.
    var size: Int { get }
    
    /// A Boolean indicating whether the NDArray is a scalar (i.e., has no dimensions).
    var isScalar: Bool { get }
    
    /// Converts the NDArray to a string representation.
    func toString() -> String
    
    /// Creates an NDArray instance from a given MLMultiArray.
    /// - Parameter mlMultiArray: The MLMultiArray to convert.
    /// - Throws: An error of type SNPError if conversion fails.
    /// - Returns: A new NDArray representing the MLMultiArray.
    static func from(_ mlMultiArray: MLMultiArray) throws(SNPError) -> any NDArray
    
    /// Converts the NDArray to an MLMultiArray.
    /// - Throws: An error of type SNPError if conversion fails.
    /// - Returns: A new MLMultiArray representing the NDArray.
    func toMLMultiArray() throws(SNPError) -> MLMultiArray
    
    #if canImport(UIKit)
    /// Creates an NDArray instance from a UIImage.
    /// - Parameter image: The UIImage to convert.
    /// - Throws: An error of type SNPError if conversion fails.
    /// - Returns: A new NDArray representing the UIImage.
    @available(iOS 15, *)
    static func from(_ image: UIImage) throws(SNPError) -> any NDArray
    
    /// Converts the NDArray to a CGImage.
    /// - Throws: An error of type SNPError if conversion fails.
    /// - Returns: A new CGImage representing the NDArray.
    @available(iOS 15, *)
    func toCGImage() throws(SNPError) -> CGImage
    #endif
    
    /// Compares the current NDArray with another NDArray for equality.
    /// - Parameter other: Another NDArray to compare with.
    /// - Returns: A Boolean indicating whether the two NDArrays are equal.
    func isEqual(to other: any NDArray) -> Bool
    
    /// Adds another NDArray to the current NDArray.
    /// - Parameter other: The NDArray to add.
    /// - Throws: An error of type SNPError if the operation fails.
    /// - Returns: A new NDArray representing the result of the operation.
    func add(_ other: any NDArray) throws(SNPError) -> any NDArray
    
    /// Subtracts another NDArray from the current NDArray.
    /// - Parameter other: The NDArray to subtract.
    /// - Throws: An error of type SNPError if the operation fails.
    /// - Returns: A new NDArray representing the result of the operation.
    func subtract(_ other: any NDArray) throws(SNPError) -> any NDArray
    
    /// Multiplies the current NDArray by another NDArray.
    /// - Parameter other: The NDArray to multiply by.
    /// - Throws: An error of type SNPError if the operation fails.
    /// - Returns: A new NDArray representing the result of the operation.
    func multiply(_ other: any NDArray) throws(SNPError) -> any NDArray
    
    /// Multiplies the current NDArray by a scalar value.
    /// - Parameter scalar: The scalar value to multiply by.
    /// - Throws: An error of type SNPError if the operation fails.
    /// - Returns: A new NDArray representing the result of the operation.
    func multiply(by scalar: Double) throws(SNPError) -> any NDArray
    
    /// Computes the dot product of the current NDArray with another NDArray.
    /// - Parameter other: The NDArray to compute the dot product with.
    /// - Throws: An error of type SNPError if the operation fails.
    /// - Returns: A new NDArray representing the result of the operation.
    func dot(_ other: any NDArray) throws(SNPError) -> any NDArray
    
    /// Divides the current NDArray by another NDArray.
    /// - Parameter other: The NDArray to divide by.
    /// - Throws: An error of type SNPError if the operation fails.
    /// - Returns: A new NDArray representing the result of the operation.
    func divide(_ other: any NDArray) throws(SNPError) -> any NDArray
    
    /// Divides the current NDArray by a scalar value.
    /// - Parameter scalar: The scalar value to divide by.
    /// - Throws: An error of type SNPError if the operation fails.
    /// - Returns: A new NDArray representing the result of the operation.
    func divide(by scalar: Double) throws(SNPError) -> any NDArray
    
    /// Reshapes the NDArray to a new shape.
    /// - Parameters:
    ///   - shape: The new shape for the NDArray.
    ///   - order: The order in which to read/write the data when reshaping.
    /// - Throws: An error of type SNPError if the operation fails.
    /// - Returns: A new NDArray representing the result of the operation.
    func reshape(to shape: Shape, order: ReshapeOrder) throws(SNPError) -> any NDArray
    
    /// Transposes the NDArray based on the given axes.
    /// - Parameter axes: The new order of axes for transposition.
    /// - Throws: An error of type SNPError if the operation fails.
    /// - Returns: A new NDArray representing the result of the operation.
    func transpose(axes: [Int]?) throws(SNPError) -> any NDArray
}
