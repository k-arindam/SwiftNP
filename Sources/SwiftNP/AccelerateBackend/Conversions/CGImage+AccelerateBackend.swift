//
//  CGImage+AccelerateBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation
import CoreGraphics

internal extension AccelerateBackend {
    func ndarray<T>(from cgImage: CGImage) throws(SNPError) -> NDArray<T> where T: Numeric {
        .init()
    }
    
    func cgImage<T>(from ndarray: NDArray<T>) throws(SNPError) -> CGImage where T: Numeric {
        .init(
            width: 1920,
            height: 1080,
            bitsPerComponent: 8,
            bitsPerPixel: 4,
            bytesPerRow: 32,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: .alphaInfoMask,
            provider: .init(filename: "")!,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )!
    }
}
