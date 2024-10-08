// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class SwiftNP {
    public static func ndarray(_ swiftArray: [any Numeric]) -> NDArray {
        NDArray(array: swiftArray)
    }
    
    public static func zeros(shape: Shape) -> NDArray {
        NDArray(shape: shape, dtype: .float64, defaultValue: 0.0)
    }
    
    public static func ones(shape: Shape) -> NDArray {
        NDArray(shape: shape, dtype: .float64, defaultValue: 1.0)
    }
}
