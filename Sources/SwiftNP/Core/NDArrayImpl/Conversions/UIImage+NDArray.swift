//
//  UIImage+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation

#if canImport(UIKit)

import UIKit

public extension UIImage {
    
    /// Converts a `UIImage` to an `NDArray`. This is a computed property that attempts to create an `NDArray` from a `UIImage`.
    /// - Throws: `SNPError` if the conversion fails, e.g., no CGImage or CGContext available.
    var toNDArray: any NDArray {
        get throws(SNPError) {
            try NDArrayImpl.from(self)
        }
    }
    
    /// Initializes a `UIImage` from an `NDArray`. It assumes the NDArray is structured as an image and
    /// attempts to convert it back into a `CGImage` to initialize the `UIImage`.
    ///
    /// - Parameter ndarray: The `NDArray` to convert into a `UIImage`.
    /// - Throws: `SNPError` if the `NDArray` cannot be converted into a valid `CGImage`.
    convenience init(ndarray: any NDArray) throws(SNPError) {
        let cgImage = try ndarray.toCGImage()
        self.init(cgImage: cgImage)
    }
}

public extension NDArrayImpl {
    
    /// Creates an `NDArray` from a `UIImage` by converting the image's pixel data into a multidimensional array.
    ///
    /// - Parameter image: The `UIImage` to convert into an `NDArray`.
    /// - Throws: `SNPError` if the conversion fails, e.g., no CGImage or CGContext available.
    /// - Returns: An `NDArray` that represents the image's pixel data, with a content type of `.image`.
    static func from(_ image: UIImage) throws(SNPError) -> any NDArray {
        // Ensure the UIImage contains a valid CGImage.
        guard let cgImage = image.cgImage else {
            throw SNPError.otherError(.custom(key: "NoCGImage"))
        }
        
        // Get the width and height of the CGImage.
        let width = cgImage.width
        let height = cgImage.height
        
        // Prepare an array to hold pixel data (RGBA format).
        var pixelData = [UInt8](repeating: 0, count: width * height * 4)
        
        // Create a CGContext to draw the CGImage into the pixel buffer.
        guard let context = CGContext(data: &pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: 4 * width,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            throw SNPError.otherError(.custom(key: "NoCGContext"))
        }
        
        // Draw the CGImage into the pixel buffer.
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Create a 3D array to hold the pixel data, structured as [height][width][RGBA].
        var result = [[[UInt8]]](repeating: [[UInt8]](repeating: [UInt8](repeating: 0, count: 4), count: width), count: height)
        
        // Populate the 3D array with pixel data.
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (width * y + x) * 4
                result[y][x] = [
                    pixelData[pixelIndex],     // Red
                    pixelData[pixelIndex + 1], // Green
                    pixelData[pixelIndex + 2], // Blue
                    pixelData[pixelIndex + 3]  // Alpha
                ]
            }
        }
        
        // Return an NDArray with the structured pixel data and image content type.
        return try NDArrayImpl(array: result, contentType: .image)
    }
    
    /// Converts the NDArray back into a `CGImage`. This function assumes the NDArray represents an image
    /// and has pixel data structured as [height][width][RGBA].
    ///
    /// - Throws: `SNPError` if the NDArray is not structured as an image or the conversion fails.
    /// - Returns: A `CGImage` created from the NDArray's pixel data.
    func toCGImage() throws(SNPError) -> CGImage {
        // Retrieve the raw data from the NDArray.
        let raw = try self.rawData()
        
        // Ensure the NDArray contains image data.
        guard self.contentType == .image,
              let pixelArray = raw as? [[[UInt8]]],
              !pixelArray.isEmpty,
              !pixelArray.first!.isEmpty
        else {
            throw SNPError.typeError(.custom(key: "NotImageArray"))
        }
        
        // Get the width and height of the image.
        let height = pixelArray.count
        let width = pixelArray[0].count
        
        // Prepare a flat array to hold the pixel data (RGBA format).
        var pixelData = [UInt8](repeating: 0, count: width * height * 4)
        
        // Populate the flat pixel array with data from the 3D array.
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (width * y + x) * 4
                pixelData[pixelIndex] = pixelArray[y][x][0]     // Red
                pixelData[pixelIndex + 1] = pixelArray[y][x][1] // Green
                pixelData[pixelIndex + 2] = pixelArray[y][x][2] // Blue
                pixelData[pixelIndex + 3] = pixelArray[y][x][3] // Alpha
            }
        }
        
        // Create a CGDataProvider from the pixel data.
        guard let provider = CGDataProvider(data: Data(pixelData) as CFData) else {
            throw SNPError.otherError(.custom(key: "NoCGDataProvider"))
        }
        
        // Create and return a CGImage from the pixel data.
        guard let cgImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        ) else {
            throw SNPError.otherError(.custom(key: "NoCGImage"))
        }
        
        return cgImage
    }
}

#endif
