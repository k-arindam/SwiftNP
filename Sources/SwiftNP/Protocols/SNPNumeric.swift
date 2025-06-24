//
//  SNPNumeric.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 09/05/25.
//

import Foundation

public protocol SNPNumeric: Numeric {
    static func /(lhs: Self, rhs: Self) -> Self
}

extension Int: SNPNumeric {}
extension Int8: SNPNumeric {}
extension Int16: SNPNumeric {}
extension Int32: SNPNumeric {}
extension Int64: SNPNumeric {}

extension UInt: SNPNumeric {}
extension UInt8: SNPNumeric {}
extension UInt16: SNPNumeric {}
extension UInt32: SNPNumeric {}
extension UInt64: SNPNumeric {}

extension Float: SNPNumeric {}
extension Float16: SNPNumeric {}

extension CGFloat: SNPNumeric {}
extension Double: SNPNumeric {}
