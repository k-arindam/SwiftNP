//
//  NSImage+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

#if canImport(AppKit)

import AppKit

public extension NDArray {
    static func from(image: NSImage) throws(SNPError) -> NDArray { try SwiftNP.backend.ndarray(from: image) }
    
    func nsImage() throws(SNPError) -> NSImage { try SwiftNP.backend.nsImage(from: self) }
}

#endif
