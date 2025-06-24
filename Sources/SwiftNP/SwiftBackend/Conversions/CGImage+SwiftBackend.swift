//
//  CGImage+SwiftBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation
import CoreGraphics

internal extension SwiftBackend {
    func ndarray<T>(from cgImage: CGImage) throws(SNPError) -> NDArray<T> where T: SNPNumeric {
        throw .unimplementedError
    }
    
    func cgImage<T>(from ndarray: NDArray<T>) throws(SNPError) -> CGImage where T: SNPNumeric {
        throw .unimplementedError
    }
}
