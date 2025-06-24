//
//  SNPBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation
import CoreGraphics

#if canImport(CoreML)
import CoreML
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

internal protocol SNPBackend: Sendable, SNPArithmeticBackend, SNPCoreMLBackend, SNPMediaBackend {
    func reshape<T: SNPNumeric>(_ array: NDArray<T>, to shape: Shape, order: ReshapeOrder) throws(SNPError) -> NDArray<T>
    
    func transpose<T: SNPNumeric>(_ array: NDArray<T>, axes: Axes?) throws(SNPError) -> NDArray<T>
}

internal protocol SNPArithmeticBackend {
    func arithmeticOperation<T>(lhs: NDArray<T>, rhs: NDArray<T>, ops: ArithmeticOperation) throws(SNPError) -> NDArray<T> where T: SNPNumeric
    
    func scalarOperation<T>(on array: NDArray<T>, with scalar: Double, ops: ScalarOperation) throws(SNPError) -> NDArray<T> where T: SNPNumeric
    
    func product<T>(lhs: NDArray<T>, rhs: NDArray<T>,) throws(SNPError) -> NDArray<T> where T: SNPNumeric
}

internal protocol SNPCoreMLBackend {
    #if canImport(CoreML)
    
    func ndarray<T>(from mlMultiArray: MLMultiArray) throws(SNPError) -> NDArray<T> where T: SNPNumeric
    func mlMultiArray<T>(from ndarray: NDArray<T>) throws(SNPError) -> MLMultiArray where T: SNPNumeric
    
    #endif
}

internal protocol SNPMediaBackend {
    func ndarray<T>(from cgImage: CGImage) throws(SNPError) -> NDArray<T> where T: SNPNumeric
    func cgImage<T>(from ndarray: NDArray<T>) throws(SNPError) -> CGImage where T: SNPNumeric
    
    #if canImport(UIKit)
    func ndarray<T>(from uiImage: UIImage) throws(SNPError) -> NDArray<T> where T: SNPNumeric
    func uiImage<T>(from ndarray: NDArray<T>) throws(SNPError) -> UIImage where T: SNPNumeric
    #endif
    
    #if canImport(AppKit)
    func ndarray<T>(from nsImage: NSImage) throws(SNPError) -> NDArray<T> where T: SNPNumeric
    func nsImage<T>(from ndarray: NDArray<T>) throws(SNPError) -> NSImage where T: SNPNumeric
    #endif
}
