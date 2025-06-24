//
// NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

public final class NDArray<Element>: Sendable, Equatable, CustomStringConvertible where Element: SNPNumeric & Sendable {
    internal init(shape: Shape, data: [Element]) {
        self.shape = shape
        self.dtype = Element.self
        self.data = data
    }
    
    public let shape: Shape
    
    public let dtype: any SNPNumeric.Type
    
    public let data: [Element]
    
    public var ndim: Int { shape.count }
    
    public var size: Int { shape.size }
    
    public var isScalar: Bool { shape.count == 0 }
    
    public var description: String { "NDArray" }
    
    public func isEqual(to: NDArray) -> Bool { (data == to.data) && (shape == to.shape) && (dtype == to.dtype) }
}
