//
//  UIImage+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

#if canImport(UIKit)

import UIKit

public extension NDArray {
    static func from(image: UIImage) throws(SNPError) -> NDArray { try SwiftNP.backend.ndarray(from: image) }
    
    func uiImage() throws(SNPError) -> UIImage { try SwiftNP.backend.uiImage(from: self) }
}

#endif
