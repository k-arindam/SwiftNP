//
//  NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

public final class NDArray: CustomStringConvertible {
    public var description: String { "\(data)" }
    
    public let shape: Shape
    public let dtype: DType
    private let data: [Any]
    
    // MARK: - Getter & Setters
    public var ndim: Int { shape.count }
    public var size: Int { shape.reduce(1, *) }
    public var isScalar: Bool { shape.count == 0 }
    
    // MARK: - Initializers
    private init(shape: Shape, dtype: DType, data: [Any]) {
        self.shape = shape
        self.dtype = dtype
        self.data = data
    }
    
    public convenience init(shape: [Int], dtype: DType = .float64, defaultValue: NSNumber) {
        shape.forEach { precondition($0 >= 0, "Shape cannot be negative") }
        
        guard let castedValue = dtype.cast(defaultValue) else {
            fatalError("Invalid default value")
        }
        
        var tmpArray: NDArray? = nil
        
        for dim in shape.reversed() {
            if tmpArray != nil {
                tmpArray = NDArray(repeating: tmpArray!, count: dim, dtype: dtype)
            } else {
                tmpArray = NDArray(repeating: castedValue, count: dim)
            }
        }
        
        guard let array = tmpArray else { fatalError("Unable to create array") }
        
        self.init(shape: array.shape, dtype: array.dtype, data: array.data)
    }
    
    public convenience init(array: [Any]) {
        let inferredShape = Utils.inferShape(from: array)
        let flattenedArray = Utils.flatten(array)
        
        // Check if the shape matches the size of the array
        let totalSize = inferredShape.reduce(1, *)
        guard flattenedArray.count == totalSize else {
            fatalError("Shape \(inferredShape) does not match the total number of elements in the array: \(flattenedArray.count)")
        }
        
        // Automatically detect dtype based on the first element (assuming homogeneous array)
        guard let firstElement = flattenedArray.first as? any Numeric else {
            fatalError("Array is empty. Cannot determine dtype.")
        }
        guard let dtype = DType.typeOf(firstElement) else {
            fatalError("Could not determine dtype from array elements.")
        }
        
        //        let shape = [2, 2]
        //        let dtype: DType = .float64
        
        self.init(shape: inferredShape, dtype: dtype, data: array)
    }
    
    private convenience init(repeating: Any, count: Int, dtype: DType) {
        var shape = [count]
        
        if let repeatingItem = repeating as? NDArray { shape.append(contentsOf: repeatingItem.shape) }
        
        else if let repeatingArray = repeating as? [NDArray] { shape.append(contentsOf: repeatingArray.first!.shape) }
        
        let data = Array(repeating: repeating, count: count)
        
        self.init(shape: shape, dtype: dtype, data: data)
    }
    
    private convenience init(repeating: any Numeric, count: Int) {
        guard let dtype = DType.typeOf(repeating) else { fatalError("Invalid input value") }
        
        let data = Array(repeating: repeating, count: count)
        
        self.init(shape: [count], dtype: dtype, data: data)
    }
    
    // MARK: - Methods
    
    internal static func generate(of shape: Shape, with value: any Numeric) -> NDArray {
        guard let dtype = DType.typeOf(value) else { fatalError("Unable to determine data type") }
        
        if shape.count == 0 { return NDArray(repeating: value, count: 1, dtype: dtype) }
        
        if shape.count == 1 { return NDArray(repeating: value, count: shape.first!, dtype: dtype) }
        
        return NDArray(repeating: generate(of: Array(shape.dropFirst()), with: value), count: shape.first!, dtype: dtype)
    }
    
    public func toString() -> String {
        "SwiftNP.NDArray ----->>> shape: \(shape), dtype: \(dtype), data: \(description)"
    }
    
    private func reshape(to shape: Shape) -> NDArray? { nil }
}
