//
//  NDArrayImpl.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

/// A class representing a multi-dimensional array (NDArray) in the SwiftNP framework.
/// This class conforms to CustomStringConvertible for custom string representation.
public final class NDArrayImpl: NDArray {
    
    /// Compares two NDArray instances for equality.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray to compare.
    ///   - rhs: The right-hand side NDArray to compare.
    /// - Returns: A boolean indicating whether the two NDArray instances are equal.
    ///   - Two NDArray instances are considered equal if they have the same shape,
    ///     the same data type, and their flattened data arrays are equal.
    public static func == (lhs: NDArrayImpl, rhs: NDArrayImpl) -> Bool { lhs.isEqual(to: rhs) }
    
    /// A string representation of the NDArray, displaying its data.
    public var description: String { "\(data)" }
    
    /// The shape of the NDArray, represented as an array of integers.
    public let shape: Shape
    
    /// The data type of the elements in the NDArray.
    public let dtype: DType
    
    /// The content type of the NDArray, if any.
    public let contentType: ContentType
    
    /// The underlying data storage for the elements of the NDArray.
    internal let data: NDStorage
    
    // MARK: - Getter & Setters
    
    /// The number of dimensions of the NDArray.
    public var ndim: Int { shape.count }
    
    /// The total number of elements in the NDArray.
    public var size: Int { shape.size }
    
    /// A Boolean indicating whether the NDArray is a scalar (i.e., has no dimensions).
    public var isScalar: Bool { shape.count == 0 }
    
    // MARK: - Initializers
    
    /// Initializes an NDArray with the specified shape, data type, and data.
    ///
    /// - Parameters:
    ///   - shape: The shape of the NDArray.
    ///   - dtype: The data type of the elements.
    ///   - data: The underlying data array.
    internal init(shape: Shape, dtype: DType, data: [Any], contentType: ContentType = .unknown) {
        self.shape = shape
        self.dtype = dtype
        self.data = data
        self.contentType = contentType
    }
    
    // MARK: - Methods
    
    /// Generates an NDArray filled with a specified numeric value and shape.
    ///
    /// - Parameters:
    ///   - shape: A `Shape` representing the desired dimensions of the NDArray (e.g., [2, 3] for a 2x3 matrix).
    ///   - value: A numeric value (e.g., Int, Float, etc.) used to fill the entire NDArray.
    /// - Returns: An NDArray initialized with the specified shape and filled with the numeric value.
    /// - Throws: `SNPError.typeError` if the data type cannot be determined from the provided value.
    internal static func generate(of shape: Shape, with value: any Numeric) throws(SNPError) -> any NDArray {
        
        // Attempt to determine the dtype from the provided numeric value. If dtype can't be determined, throw a type error.
        guard let dtype = DType.typeOf(value) else {
            throw SNPError.typeError(.custom(key: "UnknownDTypeOf", args: ["\(value)"]))
        }
        
        // If the shape is empty (scalar case), return an NDArray with a single value.
        if shape.count == 0 {
            return NDArrayImpl(repeating: value, count: 1, dtype: dtype) // Scalar case
        }
        
        // If the shape is one-dimensional, return an NDArray filled with the value, repeated the required number of times.
        if shape.count == 1 {
            return NDArrayImpl(repeating: value, count: shape.first!, dtype: dtype) // 1D case
        }
        
        // Recursive case: for higher-dimensional arrays, generate an array with one dimension less, and then repeat that array.
        let repeating = try generate(of: Array(shape.dropFirst()), with: value) // Recursive generation
        return NDArrayImpl(repeating: repeating, count: shape.first!, dtype: dtype) // Create NDArray with repeated values
    }
    
    /// Returns the flattened data of the NDArray as an array of numeric values.
    ///
    /// - Throws: `SNPError.typeError` if any element is not a numeric type.
    internal func flattenedData() throws(SNPError) -> [any Numeric] {
        /// A recursive function to flatten the NDArray.
        ///
        /// - Parameter array: The NDArray to be flattened.
        /// - Throws: `SNPError.typeError` if any element is not a numeric type.
        func flatten(_ array: NDArrayImpl) throws(SNPError) -> [any Numeric] {
            var flattened = [any Numeric]() // Initialize an empty array to hold the flattened values
            
            // Iterate over each element in the NDArray's data
            for element in array.data {
                // If the element is another NDArray, recursively flatten it
                if let element = element as? NDArrayImpl {
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
    
    /// Retrieves the raw data of the NDArray as an array of `Any` type elements.
    /// This method handles both numeric elements and nested NDArrays, recursively fetching data.
    ///
    /// - Throws: `SNPError.typeError` if the data type is unknown or unsupported.
    ///
    /// - Returns: An array of `Any`, representing the NDArray's raw data.
    internal func rawData() throws(SNPError) -> [Any] {
        
        /// Recursively fetches data from an NDArray, handling both numeric elements and nested NDArrays.
        ///
        /// - Parameter array: The NDArray to fetch data from.
        /// - Throws: `SNPError.typeError` if an unknown data type is encountered.
        /// - Returns: An array of `Any` representing the NDArray's content.
        func fetchData(from array: NDArrayImpl) throws(SNPError) -> [Any] {
            // Check if the data in the NDArray is already a numeric array
            if let array = array.data as? [any Numeric] {
                return array  // Return numeric array directly
            }
            // If the data contains nested NDArrays, recursively fetch data from each NDArray
            else if let array = array.data as? [NDArrayImpl] {
                do {
                    // Map over the nested arrays, applying the fetch recursively
                    return try array.map { try fetchData(from: $0) }
                } catch {
                    // If an error occurs during recursion, throw an unknown data type error
                    throw SNPError.typeError(.custom(key: "UnknownDType"))
                }
            }
            // If the data doesn't match any supported types, throw an error
            else {
                throw SNPError.typeError(.custom(key: "UnknownDType"))
            }
        }

        // Call the recursive fetch function starting with the current NDArray
        return try fetchData(from: self)
    }
    
    /// Compares the current NDArray with another NDArray for equality.
    ///
    /// - Parameters:
    ///   - other: Another NDArray to compare with the current NDArray.
    /// - Returns: A Boolean indicating whether the two NDArrays are equal.
    ///   The NDArrays are considered equal if they have the same shape, data type, and identical flattened data.
    public func isEqual(to other: any NDArray) -> Bool {
        // Check if the other NDArray is of type NDArrayImpl
        guard let other = other as? NDArrayImpl else { return false }
        
        // Check if both NDArrays have the same shape
        guard shape == other.shape else { return false }
        
        // Check if both NDArrays have the same data type (dtype)
        guard dtype == other.dtype else { return false }
        
        // Attempt to flatten both NDArrays and compare their data
        if let lhsData = try? flattenedData(),
           let rhsData = try? other.flattenedData() {
            // Use a utility function to compare the two flattened arrays
            return Utils.equalArray(lhsData, rhsData)
        }
        
        // Return false if data couldn't be compared or flattened
        return false
    }
    
    /// Returns a string representation of the NDArray including its shape, dtype, and data.
    public func toString() -> String {
        "SwiftNP.NDArray ----->>> shape: \(shape), dtype: \(dtype), data: \(description)"
    }
}
