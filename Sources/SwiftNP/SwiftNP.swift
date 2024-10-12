// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// A class that provides methods for creating and manipulating multi-dimensional arrays (NDArray) in the SwiftNP framework.
public final class SwiftNP {
    
    /// Creates an NDArray from a Swift array of any type.
    ///
    /// - Parameter swiftArray: An array containing elements of any type to be converted into an NDArray.
    /// - Returns: An NDArray representation of the provided array.
    /// - Throws: `SNPError` if there are issues during conversion.
    ///
    /// Example:
    ///     let array: [Any] = [1, 2, 3]
    ///     let ndarray = SwiftNP.ndarray(array) // Creates an NDArray from the array
    public static func ndarray(_ swiftArray: [Any]) throws(SNPError) -> NDArray {
        // Convert the Swift array into an NDArray using the initializer defined in NDArray
        try NDArray(array: swiftArray)
    }
    
    /// Creates an NDArray filled with zeros of a specified shape.
    ///
    /// - Parameter shape: The desired shape of the NDArray to be created.
    /// - Returns: An NDArray initialized with zeros, with the specified shape and a default data type of .float64.
    /// - Throws: `SNPError` if there are issues during array creation.
    ///
    /// Example:
    ///     let zerosArray = SwiftNP.zeros(shape: [2, 3]) // Creates a 2x3 NDArray filled with zeros
    public static func zeros(shape: Shape) throws(SNPError) -> NDArray {
        // Create an NDArray of the specified shape, filled with zeros
        try NDArray(shape: shape, dtype: .float64, defaultValue: 0.0)
    }
    
    /// Creates an NDArray filled with ones of a specified shape.
    ///
    /// - Parameter shape: The desired shape of the NDArray to be created.
    /// - Returns: An NDArray initialized with ones, with the specified shape and a default data type of .float64.
    /// - Throws: `SNPError` if there are issues during array creation.
    ///
    /// Example:
    ///     let onesArray = SwiftNP.ones(shape: [2, 3]) // Creates a 2x3 NDArray filled with ones
    public static func ones(shape: Shape) throws(SNPError) -> NDArray {
        // Create an NDArray of the specified shape, filled with ones
        try NDArray(shape: shape, dtype: .float64, defaultValue: 1.0)
    }
}
