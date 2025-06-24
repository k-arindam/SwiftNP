//
//  MLMultiArray+AccelerateBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

#if canImport(CoreML)

import CoreML

internal extension AccelerateBackend {
    func ndarray<T>(from mlMultiArray: MLMultiArray) throws(SNPError) -> NDArray<T> where T : SNPNumeric {
        throw .unimplementedError
    }
    
    func mlMultiArray<T>(from ndarray: NDArray<T>) throws(SNPError) -> MLMultiArray where T : SNPNumeric {
        throw .unimplementedError
    }
}

#endif
