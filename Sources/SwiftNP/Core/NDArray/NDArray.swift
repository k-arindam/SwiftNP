//
//  NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

/// A class representing a multi-dimensional array (NDArray) in the SwiftNP framework.
/// This class conforms to CustomStringConvertible for custom string representation.
public final class NDArray: Equatable, CustomStringConvertible {
    
    /// Compares two NDArray instances for equality.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray to compare.
    ///   - rhs: The right-hand side NDArray to compare.
    /// - Returns: A boolean indicating whether the two NDArray instances are equal.
    ///   - Two NDArray instances are considered equal if they have the same shape,
    ///     the same data type, and their flattened data arrays are equal.
    public static func == (lhs: NDArray, rhs: NDArray) -> Bool {
        guard lhs.shape == rhs.shape else { return false }
        
        guard lhs.dtype == rhs.dtype else { return false }
        
        if let lhsData = try? lhs.flattenedData(),
           let rhsData = try? rhs.flattenedData() {
            return Utils.equalArray(lhsData, rhsData)
        }
                
        return false
    }
    
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
    ///   - shape: A `Shape` representing the desired dimensions of the NDArray (e.g., [2, 3] for a 2x3 matrix).
    ///   - value: A numeric value (e.g., Int, Float, etc.) used to fill the entire NDArray.
    /// - Returns: An NDArray initialized with the specified shape and filled with the numeric value.
    /// - Throws: `SNPError.typeError` if the data type cannot be determined from the provided value.
    internal static func generate(of shape: Shape, with value: any Numeric) throws(SNPError) -> NDArray {
        
        // Attempt to determine the dtype from the provided numeric value. If dtype can't be determined, throw a type error.
        guard let dtype = DType.typeOf(value) else {
            throw SNPError.typeError(.custom(key: "UnknownDTypeOf", args: ["\(value)"]))
        }
        
        // If the shape is empty (scalar case), return an NDArray with a single value.
        if shape.count == 0 {
            return NDArray(repeating: value, count: 1, dtype: dtype) // Scalar case
        }
        
        // If the shape is one-dimensional, return an NDArray filled with the value, repeated the required number of times.
        if shape.count == 1 {
            return NDArray(repeating: value, count: shape.first!, dtype: dtype) // 1D case
        }
        
        // Recursive case: for higher-dimensional arrays, generate an array with one dimension less, and then repeat that array.
        let repeating = try generate(of: Array(shape.dropFirst()), with: value) // Recursive generation
        return NDArray(repeating: repeating, count: shape.first!, dtype: dtype) // Create NDArray with repeated values
    }
    
    /// Returns the flattened data of the NDArray as an array of numeric values.
    ///
    /// - Throws: `SNPError.typeError` if any element is not a numeric type.
    internal func flattenedData() throws(SNPError) -> [any Numeric] {
        /// A recursive function to flatten the NDArray.
        ///
        /// - Parameter array: The NDArray to be flattened.
        /// - Throws: `SNPError.typeError` if any element is not a numeric type.
        func flatten(_ array: NDArray) throws(SNPError) -> [any Numeric] {
            var flattened = [any Numeric]() // Initialize an empty array to hold the flattened values
            
            // Iterate over each element in the NDArray's data
            for element in array.data {
                // If the element is another NDArray, recursively flatten it
                if let element = element as? NDArray {
                    flattened.append(contentsOf: try flatten(element))
                }
                // If the element is a numeric type, add it to the flattened array
                else if let element = element as? any Numeric {
                    flattened.append(element)
                }
                // If the element is neither, throw a type error
                else {
                    throw SNPError.typeError(.custom(key: "UnknownDType"))
                }
            }
            
            return flattened // Return the flattened array
        }
        
        return try flatten(self) // Call the flatten function on the current NDArray
    }
    
    /// Returns a string representation of the NDArray including its shape, dtype, and data.
    public func toString() -> String {
        "SwiftNP.NDArray ----->>> shape: \(shape), dtype: \(dtype), data: \(description)"
    }
}
