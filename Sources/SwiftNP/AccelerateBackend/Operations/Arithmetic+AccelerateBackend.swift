//
//  Arithmetic+AccelerateBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

internal extension AccelerateBackend {
    func arithmeticOperation<T>(lhs: NDArray<T>, rhs: NDArray<T>, ops: ArithmeticOperation) throws(SNPError) -> NDArray<T> where T : Numeric {
        .init()
    }
    
    func scalarOperation<T>(on array: NDArray<T>, with scalar: Double, ops: ScalarOperation) throws(SNPError) -> NDArray<T> where T : Numeric {
        .init()
    }
    
    func product<T>(lhs: NDArray<T>, rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T : Numeric {
        .init()
    }
}
