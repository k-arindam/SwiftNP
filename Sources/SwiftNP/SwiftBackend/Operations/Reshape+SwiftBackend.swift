//
//  Reshape+SwiftBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

internal extension SwiftBackend {
    func reshape<T>(_ array: NDArray<T>, to shape: Shape, order: ReshapeOrder) throws(SNPError) -> NDArray<T> where T : SNPNumeric {
        throw .unimplementedError
    }
}
