//
//  Transpose+AccelerateBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

internal extension AccelerateBackend {
    func transpose<T>(_ array: NDArray<T>, axes: Axes?) throws(SNPError) -> NDArray<T> where T : SNPNumeric {
        throw .unimplementedError
    }
}
