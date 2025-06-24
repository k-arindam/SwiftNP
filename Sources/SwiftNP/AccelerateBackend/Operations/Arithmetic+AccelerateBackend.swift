//
//  Arithmetic+AccelerateBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation
import Accelerate

internal extension AccelerateBackend {
    func arithmeticOperation<T>(lhs: NDArray<T>, rhs: NDArray<T>, ops: ArithmeticOperation) throws(SNPError) -> NDArray<T> where T: SNPNumeric {
        throw .unimplementedError
    }
    
    func scalarOperation<T>(on array: NDArray<T>, with scalar: Double, ops: ScalarOperation) throws(SNPError) -> NDArray<T> where T: SNPNumeric {
        throw .unimplementedError
    }
    
    func product<T>(lhs: NDArray<T>, rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: SNPNumeric {
        throw .unimplementedError
    }
}

fileprivate extension AccelerateBackend {
    func arithmeticOperation<T>(
        lhs: [T],
        rhs: [T],
        shape: Shape,
        ops: ArithmeticOperation,
        vadd: @escaping (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void,
        vsub: @escaping (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void,
        vmul: @escaping (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void,
        vdiv: @escaping (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void
    ) -> NDArray<T> where T: BinaryFloatingPoint {
        var result = [T](repeating: 0, count: shape.size)
        
        let count = vDSP_Length(shape.size)
        let stride: vDSP_Stride = 1
        
        lhs.withUnsafeBufferPointer { lhsPtr in
            rhs.withUnsafeBufferPointer { rhsPtr in
                result.withUnsafeMutableBufferPointer { resPtr in
                    switch ops {
                    case .addition:
                        vadd(lhsPtr.baseAddress!, stride, rhsPtr.baseAddress!, stride, resPtr.baseAddress!, stride, count)
                    case .subtraction:
                        vsub(lhsPtr.baseAddress!, stride, rhsPtr.baseAddress!, stride, resPtr.baseAddress!, stride, count)
                    case .multiplication:
                        vmul(lhsPtr.baseAddress!, stride, rhsPtr.baseAddress!, stride, resPtr.baseAddress!, stride, count)
                    case .division:
                        vdiv(lhsPtr.baseAddress!, stride, rhsPtr.baseAddress!, stride, resPtr.baseAddress!, stride, count)
                    }
                }
            }
        }
        
        return NDArray(shape: shape, data: result)
    }
}
