//
//  NSImage+AccelerateBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

#if canImport(AppKit)

import AppKit

internal extension AccelerateBackend {
    func ndarray<T>(from nsImage: NSImage) throws(SNPError) -> NDArray<T> where T: SNPNumeric {
        throw .unimplementedError
    }
    
    func nsImage<T>(from ndarray: NDArray<T>) throws(SNPError) -> NSImage where T: SNPNumeric {
        throw .unimplementedError
    }
}

#endif
