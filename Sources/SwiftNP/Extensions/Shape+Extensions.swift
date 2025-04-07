//
//  Shape+Extensions.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 17/10/24.
//

import Foundation

/// Extension for `Shape` that provides a computed property to calculate the total size of the shape.
///
/// The `size` property calculates the total number of elements in a multidimensional shape by multiplying
/// all the dimensions together. This is useful when you need to determine the total number of elements
/// in an NDArray or any other structure with a given shape.
///
/// - Returns: The total number of elements as an `Int`.
public extension Shape {
    /// Calculates the total size by multiplying all dimensions of the shape.
    var size: Int {
        // The `reduce` function multiplies all dimensions of the shape.
        self.reduce(1, *)
    }
}
