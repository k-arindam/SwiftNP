//
//  Utils.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

public final class Utils {
    public static func inferShape<T>(from array: [T]) -> Shape {
        var shape = Shape()
        
        var currentArray: Any = array
        
        while let array = currentArray as? [Any] {
            shape.append(array.count)
            currentArray = array.first ?? []
        }
        
        return shape
    }
    
    public static func flatten<T>(_ array: [T]) -> [Any] {
        var flattened = [Any]()
        
        for element in array {
            if let nestedArray = element as? [Any] {
                flattened.append(contentsOf: flatten(nestedArray))
            } else {
                flattened.append(element)
            }
        }
        
        return flattened
    }
    
    public static func conformsToShape(array: [Any], shape: Shape) -> Bool {
        let layerSize = shape.first ?? 0
        
        guard array.count == layerSize, array.isHomogeneous else { return false }
        
        let nextLayerShape: Shape = Array(shape.dropFirst())
        
        if nextLayerShape.isEmpty { return true }
        
        for (index, element) in array.enumerated() {
            guard let nestedArray = element as? [Any] else { continue }
            
            guard conformsToShape(array: nestedArray, shape: nextLayerShape) else { return false }
        }
        
        return true
    }
}
