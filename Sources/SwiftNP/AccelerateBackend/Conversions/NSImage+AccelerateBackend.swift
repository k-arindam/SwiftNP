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
    func ndarray<T>(from nsImage: NSImage) throws(SNPError) -> NDArray<T> where T: Numeric {
        .init()
    }
    
    func nsImage<T>(from ndarray: NDArray<T>) throws(SNPError) -> NSImage where T: Numeric {
        .init()
    }
}

#endif
