//
//  ReshapeOrder.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

/// An enumeration that defines the possible reshaping orders for multi-dimensional arrays.
///
/// - `c`: Represents C-style ordering, where the last index changes the fastest.
/// - `f`: Represents Fortran-style ordering, where the first index changes the fastest.
public enum ReshapeOrder: String, Codable, Sendable, CaseIterable {
    case c = "C-style"        // C-style ordering
    case f = "Fortran-style"  // Fortran-style ordering
}
