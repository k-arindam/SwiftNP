//
//  NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

/// A class representing a multi-dimensional array (NDArray) in the SwiftNP framework.
/// This class conforms to CustomStringConvertible for custom string representation.
public final class NDArray: CustomStringConvertible {
    
    /// A string representation of the NDArray, displaying its data.
    public var description: String { "\(data)" }
    
    /// The shape of the NDArray, represented as an array of integers.
    public let shape: Shape
    
    /// The data type of the elements in the NDArray.
    public let dtype: DType
    
    /// The underlying data storage for the elements of the NDArray.
    internal let data: [Any]
    
    // MARK: - Getter & Setters
    
    /// The number of dimensions of the NDArray.
    public var ndim: Int { shape.count }
    
    /// The total number of elements in the NDArray.
    public var size: Int { shape.reduce(1, *) }
    
    /// A Boolean indicating whether the NDArray is a scalar (i.e., has no dimensions).
    public var isScalar: Bool { shape.count == 0 }
    
    // MARK: - Initializers
    
    /// Initializes an NDArray with the specified shape, data type, and data.
    ///
    /// - Parameters:
    ///   - shape: The shape of the NDArray.
    ///   - dtype: The data type of the elements.
    ///   - data: The underlying data array.
    internal init(shape: Shape, dtype: DType, data: [Any]) {
        self.shape = shape
        self.dtype = dtype
        self.data = data
    }
    
    // MARK: - Methods
    
    /// Generates an NDArray filled with a specified numeric value and shape.
    ///
    /// - Parameters:
    ///   - shape: The desired shape of the NDArray.
    ///   - value: The numeric value to fill the NDArray with.
    /// - Returns: An NDArray initialized with the specified shape and filled with the value.
    /// - Fatal error: Will occur if the data type cannot be determined from the value.
    internal static func generate(of shape: Shape, with value: any Numeric) -> NDArray {
        guard let dtype = DType.typeOf(value) else { fatalError("Unable to determine data type") }
        
        if shape.count == 0 {
            return NDArray(repeating: value, count: 1, dtype: dtype) // Scalar case
        }
        
        if shape.count == 1 {
            return NDArray(repeating: value, count: shape.first!, dtype: dtype) // 1D case
        }
        
        // Recursive case for multi-dimensional arrays
        return NDArray(repeating: generate(of: Array(shape.dropFirst()), with: value), count: shape.first!, dtype: dtype)
    }
    
    /// Reshapes the NDArray to a new specified shape.
    /// - Parameter shape: The new shape to reshape the NDArray to.
    /// - Returns: An optional NDArray with the new shape, or nil if the reshape fails.
    private func reshape(to shape: Shape) -> NDArray? { nil }
    
    /// Returns a string representation of the NDArray including its shape, dtype, and data.
    public func toString() -> String {
        "SwiftNP.NDArray ----->>> shape: \(shape), dtype: \(dtype), data: \(description)"
    }
}
