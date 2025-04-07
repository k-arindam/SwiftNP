//
//  UIImage+AccelerateBackend.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

#if canImport(UIKit)

import UIKit

internal extension AccelerateBackend {
    func ndarray<T>(from uiImage: UIImage) throws(SNPError) -> NDArray<T> where T: Numeric {
        .init()
    }
    
    func uiImage<T>(from ndarray: NDArray<T>) throws(SNPError) -> UIImage where T: Numeric {
        .init()
    }
}

#endif
