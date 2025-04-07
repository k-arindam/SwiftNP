//
//  ScalarOperation.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

/// An enumeration representing scalar operations that can be performed on matrices.
/// This enum conforms to the `MatrixOperation`, `Codable`, and `CaseIterable` protocols.
///
/// Scalar operations are performed on individual elements of a matrix and include:
/// - `multiply`: Represents multiplication by a scalar.
/// - `divide`: Represents division by a scalar.
internal enum ScalarOperation: Codable, CaseIterable {
    case multiply   // Multiplication operation
    case divide     // Division operation
}
