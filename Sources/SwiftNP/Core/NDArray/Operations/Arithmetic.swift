//
//  Arithmetic.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation

extension NDArray {
    /// Adds two NDArrays element-wise
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray in the addition.
    ///   - rhs: The right-hand side NDArray in the addition.
    /// - Returns: A new NDArray representing the result of element-wise addition.
    /// - Throws: SNPError if the shapes of the NDArrays are incompatible.
    public static func +(lhs: NDArray, rhs: NDArray) throws(SNPError) -> NDArray { try lhs.arithmeticOperation(rhs, ops: .addition) }
    
    /// Subtracts two NDArrays element-wise
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray in the subtraction.
    ///   - rhs: The right-hand side NDArray in the subtraction.
    /// - Returns: A new NDArray representing the result of element-wise subtraction.
    /// - Throws: SNPError if the shapes of the NDArrays are incompatible.
    public static func -(lhs: NDArray, rhs: NDArray) throws(SNPError) -> NDArray { try lhs.arithmeticOperation(rhs, ops: .subtraction) }
    
    /// Multiplies two NDArrays element-wise
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray in the multiplication.
    ///   - rhs: The right-hand side NDArray in the multiplication.
    /// - Returns: A new NDArray representing the result of element-wise multiplication.
    /// - Throws: SNPError if the shapes of the NDArrays are incompatible.
    public static func *(lhs: NDArray, rhs: NDArray) throws(SNPError) -> NDArray { try lhs.arithmeticOperation(rhs, ops: .multiplication) }
    
    /// Multiplies an NDArray by a scalar
    /// - Parameters:
    ///   - lhs: The NDArray to be multiplied.
    ///   - scalar: The scalar value to multiply each element by.
    /// - Returns: A new NDArray with each element multiplied by the scalar.
    /// - Throws: SNPError in case of computation errors.
    public static func *(lhs: NDArray, scalar: Double) throws(SNPError) -> NDArray { try lhs.scalarOperation(scalar, ops: .multiply) }
    
    /// Multiplies an NDArray by a scalar
    /// - Parameters:
    ///   - scalar: The scalar value to multiply each element by.
    ///   - rhs: The NDArray to be multiplied.
    /// - Returns: A new NDArray with each element multiplied by the scalar.
    /// - Throws: SNPError in case of computation errors.
    public static func *(scalar: Double, rhs: NDArray) throws(SNPError) -> NDArray { try rhs.scalarOperation(scalar, ops: .multiply) }
    
    /// Divides two NDArrays element-wise
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray in the division.
    ///   - rhs: The right-hand side NDArray in the division.
    /// - Returns: A new NDArray representing the result of element-wise division.
    /// - Throws: SNPError if the shapes of the NDArrays are incompatible.
    public static func /(lhs: NDArray, rhs: NDArray) throws(SNPError) -> NDArray { try lhs.arithmeticOperation(rhs, ops: .division) }
    
    /// Divides an NDArray by a scalar
    /// - Parameters:
    ///   - lhs: The NDArray to be divided.
    ///   - scalar: The scalar value to divide each element by.
    /// - Returns: A new NDArray with each element divided by the scalar.
    /// - Throws: SNPError in case of computation errors.
    public static func /(lhs: NDArray, scalar: Double) throws(SNPError) -> NDArray { try lhs.scalarOperation(scalar, ops: .divide) }
    
    /// Performs an arithmetic operation (addition or subtraction) between the current NDArray instance and another NDArray.
    ///
    /// - Parameters:
    ///   - other: The NDArray to perform the operation with.
    ///   - ops: The arithmetic operation to perform (addition or subtraction).
    /// - Throws:
    ///   - `SNPError.indexError` if the shapes of the two NDArray instances do not match.
    ///   - `SNPError.typeError` if the data type cannot be determined or if an unknown data type is encountered.
    /// - Returns: A new NDArray resulting from the specified arithmetic operation between the two NDArray instances.
    private func arithmeticOperation(_ other: NDArray, ops: ArithmeticOperation) throws(SNPError) -> NDArray {
        // Ensure both NDArray instances have the same shape.
        guard self.shape == other.shape else { throw SNPError.indexError(.custom(key: "SameShapeRequired")) }
        
        // Determine the appropriate data type for the result.
        var dtype: DType = .float64
        if self.dtype == other.dtype {
            dtype = self.dtype
        }
        
        // Flatten the data from both NDArray instances for element-wise operations.
        var flatArrayLHS = try self.flattenedData()
        let flatArrayRHS = try other.flattenedData()
        
        // Iterate over the flattened arrays to perform the specified operation.
        for (index, element) in flatArrayLHS.enumerated() {
            let lhs = element
            let rhs = flatArrayRHS[index]
            
            // Initialize a variable to hold the result of the operation.
            var result: NSNumber = 0
            
            // Perform the specified operation.
            switch ops {
            case .addition:
                result = NSNumber(value: lhs.nsnumber.doubleValue + rhs.nsnumber.doubleValue)
                
            case .subtraction:
                result = NSNumber(value: lhs.nsnumber.doubleValue - rhs.nsnumber.doubleValue)
                
            case .multiplication:
                result = NSNumber(value: lhs.nsnumber.doubleValue * rhs.nsnumber.doubleValue)
                
            case .division:
                result = NSNumber(value: lhs.nsnumber.doubleValue / rhs.nsnumber.doubleValue)
            }
            
            // Cast the result to the appropriate data type and update the flattened array.
            if let casted = dtype.cast(result) {
                flatArrayLHS[index] = casted
            } else {
                throw SNPError.typeError(.custom(key: "UnknownDTypeOf", args: ["\(element)"]))
            }
        }
        
        // Create a new NDArray from the flattened results and reshape it to the original shape.
        return try NDArray(shape: self.shape, dtype: dtype, data: flatArrayLHS).reshape(to: self.shape)
    }
    
    /// Computes the matrix product (dot product) of two NDArrays.
    ///
    /// This method implements matrix multiplication between two NDArrays following the rules:
    /// - The last dimension of the first array (A) must match the second-to-last dimension of the second array (B).
    /// - Supports higher-dimensional arrays by broadcasting their leading dimensions (if compatible).
    ///
    /// - Parameters:
    ///   - other: The second NDArray (B) to multiply with the current NDArray (A).
    /// - Throws: SNPError.shapeError if the shapes of A and B are incompatible for matrix multiplication.
    /// - Returns: A new NDArray containing the result of the matrix product.
    internal func product(_ other: NDArray) throws(SNPError) -> NDArray {
        let shapeA = self.shape
        let shapeB = other.shape
        
        // Ensure that the last dimension of A matches the second-to-last dimension of B.
        guard shapeA.last == shapeB[shapeB.count - 2] else {
            throw SNPError.shapeError(.custom(key: "IncompatibleShapes", args: ["\(self.shape)", "\(other.shape)"]))
        }
        
        /// Multiplies two 2D matrices and returns the result as a flattened 1D array of Double.
        ///
        /// - Parameters:
        ///   - matrixA: Flattened data of matrix A.
        ///   - matrixB: Flattened data of matrix B.
        ///   - shapeA: Shape of matrix A (e.g., [rows, common_dimension]).
        ///   - shapeB: Shape of matrix B (e.g., [common_dimension, columns]).
        /// - Returns: The resulting matrix multiplication as a flattened 1D array of Double.
        func multiply2D(_ matrixA: [any Numeric], _ matrixB: [any Numeric], shapeA: [Int], shapeB: [Int]) -> [Double] {
            let rowsA = shapeA[0]  // Number of rows in matrix A
            let commonDim = shapeA[1]  // Shared dimension between A and B (columns of A, rows of B)
            let colsB = shapeB[1]  // Number of columns in matrix B
            
            // Initialize result array for storing the matrix product.
            var result = [Float64](repeating: 0.0, count: rowsA * colsB)
            
            // Perform the matrix multiplication.
            for i in 0..<rowsA {
                for j in 0..<colsB {
                    for k in 0..<commonDim {
                        let lhs = matrixA[i * commonDim + k].nsnumber  // Element of A
                        let rhs = matrixB[k * colsB + j].nsnumber      // Element of B
                        let newValue = lhs.doubleValue * rhs.doubleValue  // Multiply A and B elements
                        result[i * colsB + j] += newValue  // Accumulate the product in the result matrix
                    }
                }
            }
            
            return result
        }
        
        // Flatten both NDArrays for matrix multiplication.
        let flatA = try self.flattenedData()
        let flatB = try other.flattenedData()
        
        // Get the 2D shapes from the last two dimensions of both A and B.
        let shapeA2D = [shapeA[shapeA.count - 2], shapeA.last!]
        let shapeB2D = [shapeB[shapeB.count - 2], shapeB.last!]
        
        // Broadcast the leading dimensions (if necessary) for higher-dimensional matrices.
        let broadcastedShape = try Utils.broadcastShape(Array(shapeA.dropLast(2)), Array(shapeB.dropLast(2)))
        
        // Perform the matrix multiplication for the 2D parts of A and B.
        let result2D = multiply2D(flatA, flatB, shapeA: shapeA2D, shapeB: shapeB2D)
        
        // The final result shape combines the broadcasted dimensions with the product of the 2D shapes.
        let resultShape: Shape = broadcastedShape + [shapeA[shapeA.count - 2], shapeB.last!]

        // Reshape the 1D result back into the full multidimensional shape.
        return try NDArray(array: try Utils.reshapeFlatArray(result2D, to: resultShape))
    }
    
    private func divide(_ other: NDArray) throws(SNPError) -> NDArray { other }
    
    /// Performs a scalar operation (multiplication or division) on the elements of the NDArray.
    /// The operation is applied recursively, allowing for multi-dimensional arrays.
    ///
    /// - Parameters:
    ///   - scalar: The scalar value to multiply or divide by.
    ///   - ops: The type of scalar operation to perform (multiply or divide).
    /// - Returns: A new NDArray containing the results of the scalar operation.
    /// - Throws: `SNPError` if an unsupported type is encountered during the operation.
    private func scalarOperation(_ scalar: Double, ops: ScalarOperation) throws(SNPError) -> NDArray {
        
        /// Recursively applies the scalar operation to the input data.
        /// Handles both numeric values and multi-dimensional arrays.
        ///
        /// - Parameters:
        ///   - input: The input data to which the scalar operation is applied (could be numeric or an array).
        ///   - scalar: The scalar value used in the operation.
        /// - Returns: The result of the scalar operation, which could be a numeric value or an array.
        /// - Throws: `SNPError` if the input type is unsupported or if an error occurs during processing.
        func scalarRecursive(_ input: Any, scalar: Double) throws(SNPError) -> Any {
            // Check if the input is an NSNumber (a numeric type)
            if let numeric = input as? NSNumber {
                let doubleValue = Double(truncating: numeric) // Convert to Double
                
                // Perform the appropriate scalar operation based on the specified operation type
                if ops == .multiply {
                    return doubleValue * scalar // Multiply by scalar
                } else {
                    return doubleValue / scalar // Divide by scalar
                }
            }
            // Check if the input is an array (could be multi-dimensional)
            else if let array = input as? [Any] {
                do {
                    // Apply the scalar operation recursively to each element in the array
                    return try array.map { element in
                        if let ndarray = element as? NDArray {
                            // If the element is an NDArray, apply scalar operation recursively to its data
                            return try scalarRecursive(ndarray.data, scalar: scalar)
                        } else {
                            // If it's not an NDArray, treat it as an individual element
                            return try scalarRecursive(element, scalar: scalar)
                        }
                    }
                } catch {
                    // Catch errors during mapping and throw a specific type error
                    throw SNPError.typeError(.custom(key: "UnknownDType"))
                }
            } else {
                // If the input type is unsupported, throw an error
                throw SNPError.typeError(.custom(key: "UnknownDType"))
            }
        }
        
        // Apply the scalar operation recursively to the data of the NDArray
        guard let result = try scalarRecursive(self.data, scalar: scalar) as? [Any] else {
            // Ensure that the result is of the expected array type; otherwise, throw an assertion error
            throw SNPError.assertionError(.custom(key: "CreateUnsuccessful"))
        }
        
        // Return a new NDArray with the processed data, retaining the original shape and dtype
        return try NDArray(array: result)
    }
}
