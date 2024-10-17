//
//  Arithmetic.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation

extension NDArrayImpl {
    /// Performs element-wise addition between two NDArrays.
    ///
    /// - Parameters:
    ///   - other: Another NDArray to be added to the current NDArray.
    /// - Throws: SNPError if the shapes are not compatible for broadcasting or other errors occur.
    /// - Returns: A new NDArray containing the result of the element-wise addition.
    public func add(_ other: any NDArray) throws(SNPError) -> any NDArray { try arithmeticOperation(other, ops: .addition) }

    /// Performs element-wise subtraction between two NDArrays.
    ///
    /// - Parameters:
    ///   - other: Another NDArray to be subtracted from the current NDArray.
    /// - Throws: SNPError if the shapes are not compatible for broadcasting or other errors occur.
    /// - Returns: A new NDArray containing the result of the element-wise subtraction.
    public func subtract(_ other: any NDArray) throws(SNPError) -> any NDArray { try arithmeticOperation(other, ops: .subtraction) }

    /// Performs element-wise multiplication between two NDArrays.
    ///
    /// - Parameters:
    ///   - other: Another NDArray to multiply element-wise with the current NDArray.
    /// - Throws: SNPError if the shapes are not compatible for broadcasting or other errors occur.
    /// - Returns: A new NDArray containing the result of the element-wise multiplication.
    public func multiply(_ other: any NDArray) throws(SNPError) -> any NDArray { try arithmeticOperation(other, ops: .multiplication) }

    /// Multiplies the current NDArray by a scalar value.
    ///
    /// - Parameters:
    ///   - scalar: A Double scalar value to multiply with all elements of the NDArray.
    /// - Throws: SNPError in case of shape errors or other operation failures.
    /// - Returns: A new NDArray where each element is multiplied by the scalar value.
    public func multiply(by scalar: Double) throws(SNPError) -> any NDArray { try self.scalarOperation(scalar, ops: .multiply) }
    
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
    public func dot(_ other: any NDArray) throws(SNPError) -> any NDArray { try self.product(other) }

    /// Performs element-wise division between two NDArrays.
    ///
    /// - Parameters:
    ///   - other: Another NDArray to divide the current NDArray element-wise.
    /// - Throws: SNPError if the shapes are not compatible for broadcasting or other errors occur.
    /// - Returns: A new NDArray containing the result of the element-wise division.
    public func divide(_ other: any NDArray) throws(SNPError) -> any NDArray { try arithmeticOperation(other, ops: .division) }

    /// Divides the current NDArray by a scalar value.
    ///
    /// - Parameters:
    ///   - scalar: A Double scalar value to divide each element of the NDArray.
    /// - Throws: SNPError in case of shape errors or other operation failures.
    /// - Returns: A new NDArray where each element is divided by the scalar value.
    public func divide(by scalar: Double) throws(SNPError) -> any NDArray { try self.scalarOperation(scalar, ops: .divide) }
    
    /// Performs an arithmetic operation (addition or subtraction) between the current NDArray instance and another NDArray.
    ///
    /// - Parameters:
    ///   - other: The NDArray to perform the operation with.
    ///   - ops: The arithmetic operation to perform (addition or subtraction).
    /// - Throws:
    ///   - `SNPError.indexError` if the shapes of the two NDArray instances do not match.
    ///   - `SNPError.typeError` if the data type cannot be determined or if an unknown data type is encountered.
    /// - Returns: A new NDArray resulting from the specified arithmetic operation between the two NDArray instances.
    private func arithmeticOperation(_ other: any NDArray, ops: ArithmeticOperation) throws(SNPError) -> any NDArray {
        guard let other = other as? NDArrayImpl else { throw SNPError.unimplementedError }
        
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
        return try NDArrayImpl(shape: self.shape, dtype: dtype, data: flatArrayLHS).reshape(to: self.shape)
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
    internal func product(_ other: any NDArray) throws(SNPError) -> any NDArray {
        /// Checks if the `other` parameter can be cast to `NDArrayImpl`.
        ///
        /// This guard statement ensures that the dot product operation is only performed
        /// if `other` is of the correct type. If the cast fails, it throws an
        /// `unimplementedError`, indicating that the operation cannot proceed with
        /// the given type.
        ///
        /// - Throws: SNPError.unimplementedError if the cast fails.
        guard let other = other as? NDArrayImpl else {
            throw SNPError.unimplementedError
        }

        // Store the shapes of the current and other NDArrays.
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
        return try NDArrayImpl(array: try Utils.reshapeFlatArray(result2D, to: resultShape))
    }
        
    /// Performs a scalar operation (multiplication or division) on the elements of the NDArray.
    /// The operation is applied recursively, allowing for multi-dimensional arrays.
    ///
    /// - Parameters:
    ///   - scalar: The scalar value to multiply or divide by.
    ///   - ops: The type of scalar operation to perform (multiply or divide).
    /// - Returns: A new NDArray containing the results of the scalar operation.
    /// - Throws: `SNPError` if an unsupported type is encountered during the operation.
    private func scalarOperation(_ scalar: Double, ops: ScalarOperation) throws(SNPError) -> any NDArray {
        
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
                        if let ndarray = element as? NDArrayImpl {
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
        return try NDArrayImpl(array: result)
    }
}
