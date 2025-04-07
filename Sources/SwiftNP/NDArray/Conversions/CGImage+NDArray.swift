//
//  CGImage+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation
import CoreGraphics

public extension NDArray {
    static func from(image: CGImage) throws(SNPError) -> NDArray { try SwiftNP.backend.ndarray(from: image) }
    
    func cgImage() throws(SNPError) -> CGImage { try SwiftNP.backend.cgImage(from: self) }
}
