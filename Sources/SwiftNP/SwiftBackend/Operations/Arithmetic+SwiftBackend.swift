//
//  Arithmetic+SwiftBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation
import Accelerate

internal extension SwiftBackend {
    func arithmeticOperation<T>(lhs: NDArray<T>, rhs: NDArray<T>, ops: ArithmeticOperation) throws(SNPError) -> NDArray<T> where T: SNPNumeric {
        guard lhs.shape == rhs.shape else {
            throw .shapeError(messageKey: "")
        }
        
        switch ops {
        case .addition:
            return NDArray(shape: lhs.shape, data: zip(lhs.data, rhs.data).map(+))
        case .subtraction:
            return NDArray(shape: lhs.shape, data: zip(lhs.data, rhs.data).map(-))
        case .multiplication:
            return NDArray(shape: lhs.shape, data: zip(lhs.data, rhs.data).map(*))
        case .division:
            return NDArray(shape: lhs.shape, data: zip(lhs.data, rhs.data).map(/))
        }
    }
    
    private func divide<T>(_ lhs: NDArray<T>, with rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: FloatingPoint {
        let result = zip(lhs.data, rhs.data).map(/)
        return NDArray(shape: lhs.shape, data: result)
    }
    
    private func divide<T>(_ lhs: NDArray<T>, with rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: BinaryInteger {
        let result = zip(lhs.data, rhs.data).map(/)
        return NDArray(shape: lhs.shape, data: result)
    }
    
    func scalarOperation<T>(on array: NDArray<T>, with scalar: Double, ops: ScalarOperation) throws(SNPError) -> NDArray<T> where T: SNPNumeric {
        throw .unimplementedError
    }
    
    func product<T>(lhs: NDArray<T>, rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: SNPNumeric {
        throw .unimplementedError
    }
}
