//
//  MLMultiArray+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

#if canImport(CoreML)

import CoreML

public extension NDArray {
    static func from(mlMultiArray: MLMultiArray) throws(SNPError) -> NDArray { try SwiftNP.backend.ndarray(from: mlMultiArray) }
    
    func mlMultiArray() throws(SNPError) -> MLMultiArray { try SwiftNP.backend.mlMultiArray(from: self) }
}

#endif
