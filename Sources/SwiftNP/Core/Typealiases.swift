//
//  Typealiases.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/10/24.
//

import Foundation

/// Type alias representing the shape of an array as an array of integers.
/// Each integer represents the size of the array at a particular dimension.
public typealias Shape = [Int]

/// Type alias for the SwiftNP framework, allowing for easier reference.
/// This can be used to refer to the SwiftNP namespace or functionality.
public typealias SNP = SwiftNP

/// A typealias representing the storage format of an NDArray.
/// `NDStorage` is used to define the internal storage structure of the NDArray,
/// allowing for flexible handling of multi-dimensional arrays with elements of any type.
///
/// - `NDStorage` is an array of `Any`, which means it can store arrays of different shapes and types,
///   providing the flexibility needed for multi-dimensional data.
internal typealias NDStorage = [Any]
