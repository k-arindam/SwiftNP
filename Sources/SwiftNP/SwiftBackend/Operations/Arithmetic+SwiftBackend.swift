//
//  Arithmetic+SwiftBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation
import Accelerate

internal extension SwiftBackend {
    func arithmeticOperation<T>(lhs: NDArray<T>, rhs: NDArray<T>, ops: ArithmeticOperation) throws(SNPError) -> NDArray<T> where T: Numeric {
        throw .unimplementedError
    }
    
    func scalarOperation<T>(on array: NDArray<T>, with scalar: Double, ops: ScalarOperation) throws(SNPError) -> NDArray<T> where T: Numeric {
        throw .unimplementedError
    }
    
    func product<T>(lhs: NDArray<T>, rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: Numeric {
        throw .unimplementedError
    }
}
